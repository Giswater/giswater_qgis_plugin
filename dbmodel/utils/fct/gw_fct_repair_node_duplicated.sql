/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3080

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_repair_node_duplicated(p_data json) RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_repair_node_duplicated($${"client":{"device":4, "lang":"ca_ES", "infoType":1, "epsg":25831}, 
"data":{"parameters":{"node":"11473", "action":"MOVE-LOSE-TOPO", "targetNode":"11474", "dx":"22", "dy":"22"}}}$$);
-- fid: 405

*/

DECLARE
    
v_result json;
v_result_info json;
v_result_line json;
v_version text;
v_error_context text;
v_count integer;
v_node text;
v_action text;
v_targetnode text;
v_dx double precision;
v_dy double precision;
v_fid integer = 405;
v_epsg integer;
v_nodetolerance float;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT epsg INTO v_epsg FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting system variable
	v_nodetolerance = (SELECT (value::json->>'value')::float FROM config_param_system WHERE parameter = 'edit_node_proximity');

	-- getting input data 	
	v_node := ((p_data ->>'data')::json->>'parameters')::json->>'node';
	v_action := ((p_data ->>'data')::json->>'parameters')::json->>'action';
	v_targetnode := ((p_data ->>'data')::json->>'parameters')::json->>'targetNode';
	v_dx := ((p_data ->>'data')::json->>'parameters')::json->>'dx';
	v_dy := ((p_data ->>'data')::json->>'parameters')::json->>'dy';

	-- profilactic control for target node
	IF v_targetnode = '' THEN v_targetnode = NULL; END IF;

	-- reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid = v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('REPAIR NODES DUPLICATED'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '------------------------------------');

	-- get target node in case of null
	IF v_targetnode IS NULL THEN
		v_targetnode = (SELECT n1.node_id FROM node n1, node n2 WHERE n1.state = 1 AND n2.state = 1 AND st_dwithin (n1.the_geom, n2.the_geom, v_nodetolerance) AND n2.node_id = v_node AND n1.node_id != v_node 
		ORDER BY st_distance (n1.the_geom, n2.the_geom) asc LIMIT 1);
	ELSE
		v_targetnode = (SELECT n1.node_id FROM node n1, node n2 WHERE n1.state = 1 AND n2.state = 1 AND st_dwithin (n1.the_geom, n2.the_geom, v_nodetolerance) AND n2.node_id = v_node AND n1.node_id = v_targetnode 
		ORDER BY st_distance (n1.the_geom, n2.the_geom) asc LIMIT 1);
	END IF;

	-- starting process
	IF (SELECT node_id FROM node WHERE node_id = v_node) IS NULL OR (SELECT node_id FROM node WHERE node_id = v_targetnode) IS NULL THEN
	
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('ERROR: Process failed'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('HINT: Check your nodes id''s because there is no duplicated scenario.'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('INFO: Value for target node is optative, If null system will try to check closest node.'));

	ELSE
		IF v_action = 'DELETE' THEN

			-- lose topology
			UPDATE arc SET node_1 = v_targetnode WHERE node_1 = v_node;
			UPDATE arc SET node_2 = v_targetnode WHERE node_2 = v_node;
		
			-- delete node
			DELETE FROM node WHERE node_id = v_node;
			
			-- log
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Removing node ',v_node,' -> Done'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Duplicated node ',v_targetnode,' exists using system node tolerance ',v_nodetolerance));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Transfer topology to node ',v_targetnode,' -> Done'));


		ELSIF v_action = 'DOWNGRADE' THEN

			-- transfer topology
			UPDATE arc SET node_1 = v_targetnode WHERE node_1 = v_node;
			UPDATE arc SET node_2 = v_targetnode WHERE node_2 = v_node;

			-- downgrade node
			UPDATE node SET state = 0 WHERE node_id = v_node;

			-- log
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Downgrade node ',v_node,' to state 0 -> Done'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Duplicated node ',v_targetnode,' exists using system node tolerance ',v_nodetolerance));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Transfer topology to node ',v_targetnode,' -> Done'));


		ELSIF v_action = 'MOVE-LOSE-TOPO' THEN
		
			-- transfer topology
			UPDATE arc SET node_1 = v_targetnode WHERE node_1 = v_node;
			UPDATE arc SET node_2 = v_targetnode WHERE node_2 = v_node;

			v_dx = (SELECT st_x(the_geom) + v_dx FROM node WHERE node_id = v_node);
			v_dy = (SELECT st_y(the_geom) + v_dy FROM node WHERE node_id = v_node);

			UPDATE node SET the_geom = st_setsrid(st_makepoint(v_dx, v_dy), v_epsg) WHERE node_id = v_node;
			
			-- log
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Moving node ',v_node,' -> Done'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Duplicated node ',v_targetnode,' exists using system node tolerance ',v_nodetolerance));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Transfer topology to node ',v_targetnode,' -> Done'));
		
		ELSIF v_action = 'MOVE-KEEP-TOPO' THEN

			v_dx = (SELECT st_x(the_geom) + v_dx FROM node WHERE node_id = v_node);
			v_dy = (SELECT st_y(the_geom) + v_dy FROM node WHERE node_id = v_node);

			UPDATE node SET the_geom = st_setsrid(st_makepoint(v_dx, v_dy), v_epsg) WHERE node_id = v_node;

			-- log
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Moving node ',v_node,' -> Done'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Duplicated node ',v_targetnode,' exists using system node tolerance ',v_nodetolerance));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Keeping topology -> Done'));

		ELSIF v_action = 'MOVE-GET-TOPO' THEN

			-- transfer topology
			UPDATE arc SET node_1 = v_node WHERE node_1 = v_targetnode;
			UPDATE arc SET node_2 = v_node WHERE node_2 = v_targetnode;

			v_dx = (SELECT st_x(the_geom) + v_dx FROM node WHERE node_id = v_node);
			v_dy = (SELECT st_y(the_geom) + v_dy FROM node WHERE node_id = v_node);

			UPDATE node SET the_geom = st_setsrid(st_makepoint(v_dx, v_dy), v_epsg) WHERE node_id = v_node;

			-- log
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Moving node ',v_node,' -> Done'));
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Transfer topology from node ',v_targetnode,' -> Done'));
		END IF;
	END IF;
		

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
	     ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3040, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;