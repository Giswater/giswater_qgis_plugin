/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3102

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_manage_dwf_values(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_manage_dwf_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "target":"2", "sector":"1", "action":"INSERT-ONLY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_dwf_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "target":"2", "sector":"1", "action":"KEEP-COPY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_dwf_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "target":"2", "sector":"1", "action":"DELETE-COPY"}}}$$);
SELECT SCHEMA_NAME.gw_fct_manage_dwf_values($${"client":{}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "target":"2", "sector":"1", "action":"DELETE-ONLY"}}}$$);


-- fid: 399

*/


DECLARE

object_rec record;
v_version text;
v_result json;
v_result_info json;
v_result_point json;
v_copyfrom integer;
v_target integer;
v_error_context text;
v_count integer;
v_count2 integer;
v_projecttype text;
v_fid integer = 399;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_sector integer;
v_result_id text = null;
v_sector_name text;

BEGIN

	SET search_path = "ud_sample", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data 	
	v_copyfrom :=  ((p_data ->>'data')::json->>'parameters')::json->>'copyFrom';
	v_target :=  ((p_data ->>'data')::json->>'parameters')::json->>'target';
	v_sector :=  ((p_data ->>'data')::json->>'parameters')::json->>'sector';
	v_action :=  ((p_data ->>'data')::json->>'parameters')::json->>'action';
	
	-- getting scenario name
	v_source_name := (SELECT idval FROM cat_dwf_scenario WHERE id = v_copyfrom);
	v_target_name := (SELECT idval FROM cat_dwf_scenario WHERE id = v_target);
	v_sector_name := (SELECT name FROM sector WHERE sector_id = v_sector);
	
	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('MANAGE DWF VALUES'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '--------------------------------------------------');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Target scenario: ',v_target_name));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Action: ',v_action));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Sector: ',v_sector_name));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Copy from scenario: ',v_source_name));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '--------');
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '---------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '---------');
    
	IF v_copyfrom = v_target AND v_action NOT IN ('INSERT-ONLY','DELETE-ONLY') THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 3, concat('PROCESS HAS FAILED......'));	
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 3, concat('ERROR-403: Target and source are the same.'));	
	ELSE
		FOR object_rec IN SELECT json_array_elements_text('["dwf"]'::json) as table,
					json_array_elements_text('["node_id"]'::json) as pk,
					json_array_elements_text('["node_id, value, pat1, pat2, pat3, pat4"]'::json) as column
		
		LOOP
			IF v_action = 'DELETE-COPY' THEN

				EXECUTE 'DELETE FROM inp_'||object_rec.table||' WHERE dwfscenario_id = '||v_target;

				-- get message
				GET DIAGNOSTICS v_count = row_count;
				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 2, concat('WARNING: ',v_count,' row(s) have been removed from inp_',object_rec.table,' table.'));
				END IF;
			END IF;
				
			IF v_action = 'KEEP-COPY' OR  v_action = 'DELETE-COPY' THEN

				-- get message
				EXECUTE 'SELECT count(*) FROM inp_'||object_rec.table||' WHERE dwfscenario_id = '||v_target INTO v_count;
				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been keep from inp_',object_rec.table,' table.'));
				END IF;	

				v_querytext = 'INSERT INTO inp_'||object_rec.table||' SELECT '||object_rec.column||', '||v_target||' FROM inp_'||object_rec.table||' t JOIN node USING (node_id)
				WHERE dwfscenario_id = '||v_copyfrom||' AND sector_id = '||v_sector||
				' ON CONFLICT (dwfscenario_id, '||object_rec.pk||') DO NOTHING';
				RAISE NOTICE 'v_querytext %', v_querytext;
				EXECUTE v_querytext;	
							
				-- get message
				GET DIAGNOSTICS v_count2 = row_count;
				IF v_count > 0 AND v_count2 = 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 1, concat('INFO: No rows have been inserted on inp_',object_rec.table,' table.'));
				ELSIF v_count2 > 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count2,' row(s) have been inserted on inp_',object_rec.table,' table.'));
				END IF;		
				
			ELSIF v_action = 'DELETE-ONLY' THEN

				EXECUTE 'DELETE FROM inp_'||object_rec.table||' WHERE dwfscenario_id = '||v_target;

				-- get message
				GET DIAGNOSTICS v_count = row_count;
				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
					VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been removed from inp_',object_rec.table,' table.'));
				END IF;

			ELSIF v_action = 'INSERT-ONLY' THEN

				INSERT INTO inp_dwf (node_id, dwfscenario_id) SELECT node_id, v_target FROM v_edit_inp_junction
				ON CONFLICT (node_id, dwfscenario_id) DO NOTHING;

				-- get message
				GET DIAGNOSTICS v_count = row_count;
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
				VALUES (v_fid, v_result_id, 1, concat('INFO: ',v_count,' row(s) have been inserted into inp_dwf table from v_edit_inp_junction table.'));
			END IF;
		END LOOP;		

		-- set selector
		UPDATE config_param_user SET value = v_target WHERE parameter = 'inp_options_dwfscenario' AND cur_user = current_user;

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

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3102, null, null, null); 

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;