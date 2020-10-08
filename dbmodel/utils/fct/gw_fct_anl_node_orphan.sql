/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2110

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_node_orphan(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_orphan(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_node_orphan($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, "feature":{"tableName":"v_edit_node", "featureType":"NODE", "id":[]}, 
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
"parameters":{"isArcDivide":"true", "saveOnDatabase":"true"}}}$$)::text

-- fid: 107

*/

DECLARE

rec_node record;

v_closest_arc_id varchar;
v_closest_arc_distance numeric;
v_version text;
v_saveondatabase boolean = true;
v_result json;
v_id json;
v_result_info json;
v_result_point json;
v_array text;
v_selectionmode text;
v_worklayer text;
v_projectype text;
v_partialquery text;
v_isarcdivide text;
v_error_context text;
	
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projectype FROM sys_version order by 1 desc limit 1;

	-- getting input data 	
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_saveondatabase :=  (((p_data ->>'data')::json->>'parameters')::json->>'saveOnDatabase')::boolean;
	v_isarcdivide := (((p_data ->>'data')::json->>'parameters')::json->>'isArcDivide')::text;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=107;

	-- built partial query
	IF v_projectype = 'WS' THEN
		v_partialquery = 'JOIN cat_node nc ON nodecat_id=id JOIN cat_feature_node nt ON nt.id=nc.nodetype_id';
	ELSIF v_projectype = 'UD' THEN
		v_partialquery = 'JOIN cat_feature_node ON id = a.node_type';
	END IF;

	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		FOR rec_node IN EXECUTE 'SELECT  * FROM '||v_worklayer||' a '||v_partialquery||'  WHERE a.state>0 AND node_id IN ('||v_array||') 
		AND isarcdivide= '||v_isarcdivide||' AND 
		(SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state>0) = 0' 
		LOOP
			--find the closest arc and the distance between arc and node
			SELECT ST_Distance(arc.the_geom, rec_node.the_geom) as d, arc.arc_id INTO v_closest_arc_distance, v_closest_arc_id 
			FROM arc WHERE arc.state = 1 ORDER BY arc.the_geom <-> rec_node.the_geom  LIMIT 1;
		
			INSERT INTO anl_node (node_id, state, expl_id, fid, the_geom, nodecat_id,arc_id,arc_distance)
			VALUES (rec_node.node_id, rec_node.state, rec_node.expl_id, 107, rec_node.the_geom, rec_node.nodecat_id,v_closest_arc_id,v_closest_arc_distance);
		END LOOP;
	ELSE
		FOR rec_node IN EXECUTE 'SELECT  * FROM '||v_worklayer||' a '||v_partialquery||'  WHERE a.state>0 AND isarcdivide='||v_isarcdivide||' AND 
		(SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state>0) = 0' 
		LOOP
			--find the closest arc and the distance between arc and node
			SELECT ST_Distance(arc.the_geom, rec_node.the_geom) as d, arc.arc_id INTO v_closest_arc_distance, v_closest_arc_id 
			FROM arc WHERE arc.state = 1 ORDER BY arc.the_geom <-> rec_node.the_geom  LIMIT 1;
		
			INSERT INTO anl_node (node_id, state, expl_id, fid, the_geom, nodecat_id,arc_id,arc_distance)
			VALUES (rec_node.node_id, rec_node.state, rec_node.expl_id, 107, rec_node.the_geom, rec_node.nodecat_id,v_closest_arc_id,v_closest_arc_distance);
		END LOOP;
	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=107 order by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fid, the_geom
  	FROM  anl_node WHERE cur_user="current_user"() AND fid=107) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point","features":',v_result, '}'); 


	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=107;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fid=107 AND cur_user=current_user;
		INSERT INTO selector_audit (fid,cur_user) VALUES (107, current_user);
	END IF;
		
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json, 2110);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 