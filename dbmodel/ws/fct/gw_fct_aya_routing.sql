/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 9001

DROP FUNCTION IF EXISTS ws.gw_fct_aya_routing(p_data json) ;
CREATE OR REPLACE FUNCTION ws.gw_fct_aya_routing(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE

SELECT ws.gw_fct_aya_routing($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_node", "id":["18","1101"]},
"data":{"nodeIni":"1041,"nodeFin":"1043",selectionMode":"previousSelection", "parameters":{}}}$$)

--fid: 9001
*/

DECLARE

v_version text;
v_result json;
v_result_info json;
v_result_line json;
v_error_context text;
v_count integer;

v_arc_array text[];
v_node_ini integer;
v_node_fin integer;
v_node_inter integer;
v_geom public.geometry;
v_roughness float;
v_dint float;
v_length float;
BEGIN

	SET search_path = "ws", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fid=9001;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=9001;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9001, null, 4, concat('AYA ROUTING'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9001, null, 4, '-------------------------------------------------------------');

	-- getting input data 
	v_node_ini = json_extract_path_text(p_data, 'data', 'parameters', 'nodeIni')::integer;
	v_node_fin = json_extract_path_text(p_data, 'data', 'parameters', 'nodeFin')::integer;
	v_node_inter = json_extract_path_text(p_data, 'data', 'parameters', 'nodeInter')::integer;

	IF v_node_inter IS NULL THEN
		EXECUTE 'SELECT array_agg(edge::text) FROM pgr_dijkstra(
	    ''SELECT v_edit_arc.arc_id::int8 as id, node_1::int8 as source, node_2::int8 as target, 1 as cost, 1 as reverse_cost FROM v_edit_arc
	    WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL'', 
	    '||v_node_ini||', '||v_node_fin||', FALSE
		) WHERE edge::integer > 0'
		INTO v_arc_array;
	ELSE
		EXECUTE 'SELECT array_agg(edge::text) FROM pgr_dijkstravia(
	    ''SELECT v_edit_arc.arc_id::int8 as id, node_1::int8 as source, node_2::int8 as target, 1 as cost, 1 as reverse_cost FROM v_edit_arc
	    WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL'', 
	    ARRAY['||v_node_ini||','||v_node_inter||','||v_node_fin||'],false,strict:=true, U_turn_on_edge:=false	
		) WHERE edge::integer > 0'
		INTO v_arc_array;
	END IF;

	SELECT ST_Union(a.the_geom)  INTO v_geom FROM v_edit_arc a WHERE arc_id = ANY (v_arc_array);
	
	SELECT round(St_length(v_geom)::numeric,2) INTO v_length;

	--calculate weighted average for dint
	WITH values AS (SELECT sum(gis_length) as val FROM v_edit_arc WHERE arc_id = ANY (v_arc_array)),
	weights AS (SELECT sum(dint*gis_length) as weight FROM v_edit_arc JOIN cat_arc ON arccat_id=id WHERE arc_id = ANY (v_arc_array))
	SELECT round(weight/ val,5) INTO v_dint
	FROM values, weights
	group by weight, val;

	--calculate weighted average for roughness
	WITH values AS (SELECT sum(gis_length) as val FROM v_edit_arc WHERE arc_id = ANY (v_arc_array)),
	weights AS (SELECT sum(roughness*gis_length) as weight FROM v_edit_arc JOIN cat_mat_roughness ON matcat_id=cat_matcat_id WHERE arc_id = ANY (v_arc_array))
	SELECT round(weight/ val,4) INTO v_roughness
	FROM values, weights
	group by weight, val;

	INSERT INTO ranc_mapping_arc (node_1, node_2,arc_id, the_geom, length, dint, roughness)
	SELECT v_node_ini, v_node_fin, v_arc_array::text, v_geom, v_length, v_dint, v_roughness
	ON CONFLICT (node_1, node_2) DO UPDATE SET arc_id=v_arc_array, the_geom=v_geom, length=v_length, dint=v_dint, roughness=v_roughness ;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9001, null, 1, concat('Aggregated arcs: ',v_arc_array));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9001, null, 1, concat('Length: ',v_length));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9001, null, 1, concat('Average weight of interior diameter: ',v_dint));	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (9001, null, 1, concat('Average weight of roughness: ',v_roughness));	
	
	-- get results
	--LINES
	v_result = null;
  	SELECT jsonb_agg(features.feature) INTO v_result
 	FROM (
    SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
    ) AS feature
    FROM (SELECT *,9001 as fid
    FROM  ranc_mapping_arc  WHERE node_1::integer=v_node_ini and node_2::integer=v_node_fin) row) features;

  	v_result := COALESCE(v_result, '{}'); 
  	v_result_line = concat ('{"geometryType":"MultiLineString", "features":',v_result, '}'); 
  	
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=9001 order by  id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"line":'||v_result_line||
			'}}'||
	    '}')::json,9001, null, null, null);

	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

/*
  SELECT ws.gw_fct_aya_routing($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{}, "pageInfo":{}, 
  "selectionMode":"wholeSelection","parameters":{"nodeIni":"1041", "nodeFin":"1043", "nodeInter":null}}}$$);


  INSERT INTO ws.sys_function(
            id, function_name, project_type, function_type, input_params, 
            return_type, descript, sys_role, sample_query, source)
    VALUES (9001, 'gw_fct_aya_routing', 'ws', 'function', 'json', 
            'json', 'Aya routing for selecting arcs located between initial and final node. In order to force route it's necessary to set intermediate node', 'role_edit', null, 'ranc');


INSERT INTO ws.config_function(
            id, function_name, style, layermanager, actions)
    VALUES (9001,'gw_fct_aya_routing', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', null, null);

INSERT INTO ws.config_toolbox(
            id, alias, functionparams, inputparams, observ, active)
    VALUES (9001, 'Aya routing', '{"featureType":[]}',
    '[{"widgetname":"nodeIni", "label":"Node inicial:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
    {"widgetname":"nodeFin", "label":"Node final:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""},
    {"widgetname":"nodeInter", "label":"Intermediate nodes:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3,"value":""}]', null, true);


INSERT INTO ws.sys_fprocess(
            fid, fprocess_name, project_type, parameters, source, isaudit, 
            fprocess_type, addparam)
    VALUES (9001, 'Aya routing', 'ws', null, 'rand', false,'Function process', null);



DROP TABLE ws.ranc_mapping_arc;
CREATE TABLE ws.ranc_mapping_arc (
node_1 text,
node_2	text,
descript text, 
arc_id text,
length float,
dint float,
roughness float,
the_geom geometry(MultiLinestring,5367),
node_1_euc text,
node_2_euc text,
CONSTRAINT ranc_mapping_arc_pkey PRIMARY KEY (node_1, node_2));

DROP TABLE ws.ranc_mapping_node;
CREATE TABLE ws.ranc_mapping_node (
node_euc text,
node_type text,
descript text,
node_ws	text,
qm3d float,
h24h float,
CONSTRAINT ranc_mapping_node_pkey PRIMARY KEY (node_euc)); 

INSERT INTO ws.sys_table(id, descript, sys_role,  source)
    VALUES ('ranc_mapping_arc', 'Mapping ids of arcs between schema ws and euc', 'role_edit','rand');

INSERT INTO ws.sys_table(id, descript, sys_role,  source)
    VALUES ('ranc_mapping_node', 'Mapping ids of nodes between schema ws and euc', 'role_edit','rand');
*/
