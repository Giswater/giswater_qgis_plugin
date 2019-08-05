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
	"client":{"device":3, "infoType":100, "lang":"ES"},
	"feature":{"tableName":"v_edit_man_manhole", "id":["240"]},
	"data":{"selectionMode":"previousSelection",  "parameters":{"saveOnDatabase":true}}}$$)
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
	v_selectionmode text;
	v_id json;
	rec_node record;
BEGIN

	SET search_path = "SCHEMA_NAME", public;

    	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=13;

	-- getting input data 	
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_array :=  replace(replace(replace (v_id::text, ']', ')'),'"', ''''), '[', '(');
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_saveondatabase :=  (((p_data ->>'data')::json->>'parameters')::json->>'saveOnDatabase')::boolean;

	-- Computing process
	IF v_array != '()' THEN
		v_sql := 'SELECT * FROM '||v_worklayer||' AS a WHERE state=1 
					AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_2 = a.node_id) > 0)  
					AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_1 = a.node_id) = 0)
					AND node_id IN '||v_array||';';
	ELSE
		v_sql := 'SELECT * FROM '||v_worklayer||' AS a WHERE state=1 
					AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_2 = a.node_id) > 0)  
					AND ((SELECT COUNT(*) FROM arc AS b WHERE b.node_1 = a.node_id) = 0);';
	END IF;

	FOR rec_node IN  EXECUTE v_sql
	LOOP
		-- Insert in analytics table
		INSERT INTO anl_node (node_id, expl_id, num_arcs, fprocesscat_id, the_geom, nodecat_id, state) 
		VALUES(rec_node.node_id, rec_node.expl_id, 
			(SELECT COUNT(*) FROM arc WHERE state = 1 AND (node_1 = rec_node.node_id OR node_2 = rec_node.node_id)), 
			13, rec_node.the_geom, rec_node.nodecat_id, rec_node.state);
	END LOOP;
	    
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=13 order by id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=13) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}'); 

	IF v_saveondatabase IS FALSE THEN 
		-- delete previous results
		DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=13;
	ELSE
		-- set selector
		DELETE FROM selector_audit WHERE fprocesscat_id=13 AND cur_user=current_user;    
		INSERT INTO selector_audit (fprocesscat_id,cur_user) VALUES (13, current_user);
	END IF;
		
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json;

    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;