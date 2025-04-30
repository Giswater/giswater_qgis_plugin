/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
-- The code of this have been received helpfull assistance from Enric Amat (FISERSA) and Claudia Dragoste (Aigües de Girona SA)

--FUNCTION CODE: 2214

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_flow_exit (character varying);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_flow_exit (json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_graphanalytics_downstream(p_data json)
RETURNS json AS $BODY$

/*
example:
SELECT SCHEMA_NAME.gw_fct_graphanalytics_downstream($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":["20607"]},
"data":{}}$$);


SELECT SCHEMA_NAME.gw_fct_graphanalytics_downstream($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{ "coordinates":{"xcoord":419277.7306855297,"ycoord":4576625.674511955, "zoomRatio":3565.9967217571534}}}$$)

--fid: upstream:220/downstream:221;

*/
DECLARE

v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_version text;

v_debug boolean;
v_error_context text;
v_audit_result text;

v_level integer;
v_status text;
v_message text;

v_project_type text;
v_node integer;
v_point public.geometry;
v_sensibility_f float;
v_sensibility float;
v_zoomratio float;
v_fid integer;
v_device integer;
v_xcoord float;
v_ycoord float;
v_epsg integer;
v_client_epsg integer;

v_query text;
v_source text;
v_target text;
v_distance int;
v_dry text;
v_rain text;
v_context text;

v_simbology int; 

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_device := (p_data ->> 'client')::json->> 'device';
	v_xcoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'ycoord';
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_client_epsg := (p_data ->> 'client')::json->> 'epsg';
	v_zoomratio := ((p_data ->> 'data')::json->> 'coordinates')::json->>'zoomRatio';
	v_node = json_array_elements_text(json_extract_path_text(p_data,'feature','id')::json)::integer;

	v_context = 'Flow exit';
	v_fid = 221;
	v_simbology = 2214;

	-- pgrouting
	v_source= 'node_1';
	v_target= 'node_2';
	v_dry = 'dry scenario';
	v_rain = 'overflow for rain scenario';

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;

	-- select config values
	SELECT giswater, upper(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	--Look for closest node using coordinates
	IF v_node IS NULL THEN
		EXECUTE 'SELECT (value::json->>''web'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		v_sensibility = (v_zoomratio / 500 * v_sensibility_f);

		-- Make point
		SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;
		SELECT node_id INTO v_node FROM v_edit_node WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;
		IF v_node IS NULL THEN
			SELECT v_source INTO v_node FROM v_edit_arc WHERE ST_DWithin(the_geom, v_point,100)  order by st_distance (the_geom, v_point) LIMIT 1;
		END IF;
	END IF;

	v_result := COALESCE(v_result, '{}');
	v_result_info := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND (fid = 220 or fid=221);
	DELETE FROM anl_node WHERE cur_user="current_user"() AND (fid = 220 or fid=221);

	-- rain
	v_query = '
		WITH 
			arc_selected AS (
				SELECT a.arc_id, a.node_1, a.node_2
				FROM v_edit_arc a
				WHERE a.node_1 IS NOT NULL 
				AND a.node_2 IS NOT NULL 
				AND a.state > 0 
				AND a.is_operative = TRUE
			)
		SELECT 
			a.arc_id::int AS id, '||v_source||'::int AS source, '||v_target||'::int AS target,
			1 as cost, -1 as reverse_cost
			FROM arc_selected a
	';

	EXECUTE 'select count(*)::int from v_edit_arc'
	INTO v_distance;

	INSERT INTO anl_node (node_id, fid, nodecat_id, sys_type, state, expl_id, drainzone_id, addparam, the_geom)
	SELECT n.node_id, v_fid, n.node_type, n.sys_type, n.state, n.expl_id, n.drainzone_id, v_rain, n.the_geom
	FROM (
		SELECT node::varchar
		FROM pgr_drivingdistance(v_query, v_node, v_distance)
	) p 
	JOIN v_edit_node n ON n.node_id =p.node;

	-- dry
	v_query = '
		WITH 
			arc_selected AS (
				SELECT a.arc_id, a.node_1, a.node_2
				FROM v_edit_arc a
				WHERE a.node_1 IS NOT NULL 
				AND a.node_2 IS NOT NULL 
				AND a.state > 0 
				AND a.is_operative = TRUE
				AND (a.initoverflowpath IS NULL OR a.initoverflowpath = FALSE)
			)
		SELECT 
			a.arc_id::int AS id, '||v_source||'::int AS source, '||v_target||'::int AS target,
			1 as cost, -1 as reverse_cost
			FROM arc_selected a
	';

	UPDATE anl_node n set addparam = v_dry
	FROM (
		SELECT node::varchar
		FROM pgr_drivingdistance(v_query, v_node, v_distance)
	) p 
	WHERE n.cur_user="current_user"() AND n.fid = v_fid
	AND n.node_id = p.node;

	INSERT INTO anl_arc (arc_id, fid, arccat_id, sys_type, state, expl_id, drainzone_id, addparam, the_geom)
	SELECT a.arc_id, v_fid, a.arc_type, a.sys_type, a.state, a.expl_id, a.drainzone_id, n2.addparam, a.the_geom
	FROM v_edit_arc a
	JOIN anl_node n1 ON a.node_1 = n1.node_id 
	JOIN anl_node n2 ON a.node_2 = n2.node_id
	WHERE n1.cur_user="current_user"() AND n1.fid = v_fid 
	AND n2.cur_user="current_user"() AND n2.fid = v_fid;

	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
	SELECT jsonb_build_object(
		'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom',
	'crs',concat('EPSG:',ST_SRID(the_geom))
	) AS feature
	FROM (SELECT v_context as context, expl_id, arc_id, state, arccat_id as arc_type, drainzone_id, addparam as stream_type, st_length(the_geom) as length, the_geom
	FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid) row) features;

	v_result := COALESCE(v_result, '{}');
	v_result_line = concat ('{"geometryType":"LineString", "layerName": "Flowtrace arc", "features":',v_result, '}');

	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
	SELECT jsonb_build_object(
		'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom',
		'crs',concat('EPSG:',ST_SRID(the_geom))
	) AS feature
	FROM (SELECT v_context as context, expl_id, node_id as feature_id, state, nodecat_id as feature_type, sys_type, drainzone_id, addparam as stream_type, the_geom
	FROM  anl_node WHERE cur_user="current_user"() AND fid=v_fid
	UNION
	SELECT v_context as context, c.expl_id, c.connec_id, c.state, c.connec_type, c.sys_type, c.drainzone_id, a.addparam as stream_type, c.the_geom
	FROM anl_arc a JOIN v_edit_connec c using (arc_id) 
	WHERE cur_user="current_user"() AND fid=v_fid
	AND c.state > 0 
	AND c.is_operative = TRUE
	UNION
	SELECT v_context as context, g.expl_id, g.gully_id, g.state, g.gully_type, g.sys_type, g.drainzone_id, a.addparam as stream_type, g.the_geom
	FROM anl_arc a JOIN v_edit_gully g using (arc_id) 
	WHERE cur_user="current_user"() AND fid=v_fid
	AND g.state > 0 
	AND g.is_operative = TRUE) row) features;

	v_result := COALESCE(v_result, '{}');
	v_result_point = concat ('{"geometryType":"Point", "layerName": "Flowtrace node", "features":',v_result, '}');

	v_result_polygon = '{"geometryType":"", "features":[]}';

	v_status = 'Accepted';
	v_level = 3;
	v_message = 'Flow  analysis done succesfully';

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
				   ',"body":{"form":{}'||
				   ',"data":{ "info":'||v_result_info||','||
				      '"initPoint":'||v_node||','||
					  '"point":'||v_result_point||','||
					  '"line":'||v_result_line||','||
					  '"polygon":'||v_result_polygon||'}'||
					 '}'
		'}')::json, v_simbology, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

