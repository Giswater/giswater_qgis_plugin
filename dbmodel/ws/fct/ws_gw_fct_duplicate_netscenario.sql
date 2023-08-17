/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3262

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_duplicate_netscenario(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_duplicate_netscenario($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"target":"1", "copyFrom":"2", "action":"DELETE-COPY"}}}$$)

-- fid: 510

*/


DECLARE

object_rec record;

v_version text;
v_result json;
v_result_info json;
v_copyfrom integer;
v_target integer;
v_error_context text;
v_projecttype text;
v_fid integer = 510;

v_name text;
v_descript text;
v_parent_id integer;
v_netscenario_type text;
v_active boolean;
v_scenarioid integer;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data 
	v_copyfrom := ((p_data ->>'data')::json->>'parameters')::json->>'copyFrom';
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_descript :=  ((p_data ->>'data')::json->>'parameters')::json->>'descript';
	v_parent_id :=  ((p_data ->>'data')::json->>'parameters')::json->>'parent';
	v_active :=  ((p_data ->>'data')::json->>'parameters')::json->>'active';

	SELECT netscenario_type INTO v_netscenario_type from plan_netscenario WHERE netscenario_id= v_copyfrom;
		
	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CREATE EMPTY NETSCENARIO'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '--------------------------------------------------');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Name: ',v_name));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Descript: ',v_descript));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Parent: ',v_parent_id));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Type: ',v_netscenario_type));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('active: ',v_active));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '--------');
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '---------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '---------');

	-- process
	-- inserting on catalog table
	PERFORM setval('SCHEMA_NAME.plan_netscenario_netscenario_id_seq'::regclass,(SELECT max(netscenario_id) FROM plan_netscenario) ,true);

	INSERT INTO plan_netscenario (name, descript, parent_id, netscenario_type, active, expl_id,log) 
	SELECT v_name, v_descript, v_parent_id, netscenario_type, v_active, expl_id, concat('Created by ',current_user,' on ',substring(now()::text,0,20))
	FROM plan_netscenario WHERE netscenario_id= v_copyfrom
	ON CONFLICT (name) DO NOTHING
	RETURNING netscenario_id INTO v_scenarioid;

	IF v_scenarioid IS NULL THEN
		SELECT netscenario_id INTO v_scenarioid FROM plan_netscenario where name = v_name;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, null, 3, concat('ERROR: The netscenario ( ',v_scenarioid,' ) already exists with proposed name ',v_name ,'. Please try another one.'));
	ELSE 
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'The new netscenario have been created sucessfully');

		IF v_netscenario_type = 'DMA' THEN
			INSERT INTO plan_netscenario_dma (netscenario_id, dma_id, pattern_id, graphconfig, the_geom) 
			SELECT v_scenarioid, dma_id, pattern_id, graphconfig, the_geom FROM plan_netscenario_dma WHERE netscenario_id= v_copyfrom
			ON CONFLICT (netscenario_id, dma_id) DO NOTHING;
		ELSIF v_netscenario_type = 'PRESSZONE' THEN
			INSERT INTO plan_netscenario_presszone (netscenario_id, presszone_id, head, graphconfig, the_geom) 
			SELECT v_scenarioid, presszone_id, head, graphconfig, the_geom FROM plan_netscenario_presszone WHERE netscenario_id= v_copyfrom
			ON CONFLICT (netscenario_id, presszone_id) DO NOTHING;
		END IF;

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'Mapzones configuration (graphconfig) related to selected exploitation has been copied to new netscenario.');
	END IF;

	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3262, null, null, null); 

	-- manage exceptions
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;