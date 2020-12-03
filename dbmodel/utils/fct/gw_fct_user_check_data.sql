/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2998

-- DROP FUNCTION SCHEMA_NAME.gw_fct_user_check_data(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_user_check_data(p_data json)
  RETURNS json AS
$BODY$

	/*EXAMPLE
		

	SELECT SCHEMA_NAME.gw_fct_user_check_data($${"client":
	{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
	"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"checkType":"Stats"}}}$$)::text

	--Project - audit_check_project - only errors
	--User - errors and info
	--Stats - errors and info for statistics (data copied to audit_fid_log)

-- fid: 251

*/

DECLARE

v_schemaname text;
v_count integer;
v_countquery text;
v_project_type text;
v_version text;
v_criticity integer;
v_error_val integer;
v_warning_val integer;
v_groupby text;
json_result json[];
rec_result text;
v_log_project text;
rec record;
v_target text;
v_infotext text;

v_result_id text;
v_result text;
v_result_info json;
v_error_context text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	v_log_project = ((((p_data::JSON ->> 'data')::json ->> 'parameters')::json) ->>'checkType')::text;
	
	IF v_log_project = 'Project' THEN
		v_target= '''ERROR''';
	ELSE
		v_target = '''ERROR'',''INFO''';
	END IF;

	-- init variables
	v_count=0;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid=251 AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, null, 4, concat('CHECK USER DATA'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, null, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, null, 3, '----------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, null, 1, '-------');

	
	INSERT INTO selector_state (state_id) SELECT id FROM value_state ON conflict(state_id, cur_user) DO NOTHING; 
	INSERT INTO selector_expl (expl_id) SELECT expl_id FROM exploitation ON conflict(expl_id, cur_user) DO NOTHING; 

	FOR rec IN EXECUTE 'SELECT * FROM config_fprocess WHERE fid::text ILIKE ''9%'' AND target IN ('||v_target||') ORDER BY orderby' LOOP
		
		SELECT (rec.addparam::json ->> 'criticityLimits')::json->> 'warning' INTO v_warning_val;
		SELECT (rec.addparam::json ->> 'criticityLimits')::json->> 'error' INTO v_error_val;
		SELECT (rec.addparam::json ->> 'groupBy') INTO v_groupby;

		IF v_groupby IS NULL THEN
			EXECUTE rec.querytext
			INTO v_countquery;

		ELSE 	
			EXECUTE 'SELECT array_agg(features.feature) FROM (
			SELECT jsonb_build_object(
			''fcount'',   a.count,
			''groupBy'', a.'||v_groupby||') AS feature
			FROM ('||rec.querytext||')a) features;'
			INTO json_result;
					raise notice 'json_result,%',json_result;
		END IF;

		v_count = round(v_countquery::float);
		
		IF rec.target = 'ERROR' THEN
			IF v_count::integer < v_warning_val THEN
				v_criticity = 1;
				v_infotext = 'INFO: ';
			ELSIF  v_count::integer >= v_warning_val AND  v_count::integer < v_error_val THEN
				v_criticity = 2;
				v_infotext = concat('WARNING-',rec.fid,':');
			ELSE
				v_criticity = 3;
				v_infotext = concat('ERROR-',rec.fid,':');
			END IF;
		ELSE
			v_criticity = 0;
			v_infotext  = 'INFO: ';
		END IF;
		
		IF v_groupby IS NULL THEN
			IF v_log_project = 'Stats' THEN
				INSERT INTO audit_fid_log (fid, fcount, criticity)
				VALUES (rec.fid,  v_count::integer, v_criticity);
			END IF;
			INSERT INTO audit_check_data(fid, result_id, criticity, error_message,  fcount)
			SELECT 251,rec.fid, v_criticity, concat(v_infotext,sys_fprocess.fprocess_name, ': ',v_count), v_count::integer
			FROM sys_fprocess WHERE sys_fprocess.fid = rec.fid;

		ELSIF json_result IS NOT NULL AND v_groupby IS NOT NULL THEN
			FOREACH rec_result IN ARRAY(json_result) LOOP
			
				IF v_log_project = 'Stats'  THEN
					INSERT INTO audit_fid_log (fid, fcount, criticity, groupby)
					VALUES (rec.fid,  (rec_result::json ->> 'fcount')::integer, v_criticity, (rec_result::json ->>'groupBy'));
				END IF;

				INSERT INTO audit_check_data(fid, result_id, criticity, error_message, fcount)
				SELECT 251,rec.fid, v_criticity, concat(v_infotext,sys_fprocess.fprocess_name,' - ',(rec_result::json ->>'groupBy'),': ',(rec_result::json ->> 'fcount')), (rec_result::json ->> 'fcount')::integer
				FROM sys_fprocess WHERE sys_fprocess.fid = rec.fid;

			END LOOP;
			
		END IF;

	END LOOP;
	

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=251 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (251, v_result_id, 1, '');
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	
	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{ "info":'||v_result_info||','||
				'"point":{"geometryType":"", "values":[]}'||','||
				'"line":{"geometryType":"", "values":[]}'||','||
				'"polygon":{"geometryType":"", "values":[]}'||
			   '}}'||
		'}')::json, 2998);


		--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
