/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2210

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_node_sink(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_sink(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_node_sink($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_man_manhole", "id":["240"]},
"data":{"parameters":{"saveOnDatabase":true}}}$$)

-- fid: 113

*/


DECLARE

v_version text;
v_saveondatabase boolean;
v_result json;
v_result_info json;
v_result_point json;
v_sql text;
v_worklayer text;
v_array text;
v_id json;
v_error_context text;

rec_node record;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

    	-- select version
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=113;

	-- getting input data 	
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_saveondatabase :=  (((p_data ->>'data')::json->>'parameters')::json->>'saveOnDatabase')::boolean;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;
	
	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		v_sql := 'SELECT * FROM '||v_worklayer||' AS a WHERE state=1 
					AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_2 = a.node_id) > 0)  
					AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_1 = a.node_id) = 0)
					AND node_id IN ('||v_array||');';
	ELSE
		v_sql := 'SELECT * FROM '||v_worklayer||' AS a WHERE state=1 
					AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_2 = a.node_id) > 0)  
					AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_1 = a.node_id) = 0);';
	END IF;

	FOR rec_node IN  EXECUTE v_sql
	LOOP
		-- Insert in analytics table  (note: expl_id have been removed because not all tables node have exp_id defined)
		INSERT INTO anl_node (node_id, num_arcs, fid, the_geom, nodecat_id, state)
		VALUES(rec_node.node_id, (SELECT COUNT(*) FROM arc WHERE state = 1 AND (node_1 = rec_node.node_id OR node_2 = rec_node.node_id)), 
		113, rec_node.the_geom, rec_node.nodecat_id, rec_node.state);
		
	END LOOP;
	    
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=113 order by id) row;
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
  	FROM  anl_node WHERE cur_user="current_user"() AND fid=113) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=113;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fid=113 AND cur_user=current_user;
		INSERT INTO selector_audit (fid,cur_user) VALUES (113, current_user);
	END IF;
		
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json, 2210);

   
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;