/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

-- DROP FUNCTION SCHEMA_NAME.gw_fct_user_check_data(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_user_check_data(p_data json)
  RETURNS json AS
$BODY$

	/*EXAMPLE
	

	SELECT SCHEMA_NAME.gw_fct_user_check_data($${"client":
	{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
	"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}$$)::text

-- fid: 251

*/

DECLARE

v_schemaname text;
rec_count record;
v_count text;
v_project_type text;
v_version text;
v_criticity integer;
v_error_val integer;
v_warning_val integer;
v_groupby text;
json_result json[];
rec_result text;

v_result_id text;
v_result text;
v_result_info json;

v_view_list text;
v_errortext text;
v_definition text;
v_querytext text;
v_feature_list text;
v_param_list text;
rec_fields text;
v_field_array text[];

rec record;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

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

	FOR rec IN (SELECT * FROM config_fprocess WHERE fid::text ILIKE '9%' ORDER BY orderby) LOOP
		

		SELECT (rec.addparam::json ->> 'criticityLimits')::json->> 'warning' INTO v_warning_val;
		SELECT (rec.addparam::json ->> 'criticityLimits')::json->> 'error' INTO v_error_val;
		SELECT (rec.addparam::json ->> 'groupBy') INTO v_groupby;

		
raise notice 'v_groupby,%',v_groupby;

		IF v_groupby IS NULL THEN
			EXECUTE rec.querytext
			INTO v_count;

		ELSE 	
			EXECUTE 'SELECT array_agg(features.feature) FROM (
			SELECT jsonb_build_object(
			''count'',   a.count,
			''groupBy'', a.'||v_groupby||') AS feature
			FROM ('||rec.querytext||')a) features;'
			INTO json_result;
			raise notice 'json_result,%',json_result;
		END IF;

		
		IF rec.target::integer = 1 THEN
			IF v_count::integer < v_warning_val THEN
				v_criticity = 1;
			ELSIF  v_count::integer >= v_warning_val AND  v_count::integer < v_error_val THEN
				v_criticity = 2;
			ELSE
				v_criticity = 3;
			END IF;
		ELSE
			v_criticity = 0;
		END IF;
		
		IF v_groupby IS NULL THEN
			INSERT INTO audit_fid_log (fid, count, criticity)
			VALUES (rec.fid,  v_count, v_criticity);
		ELSE 
			FOREACH rec_result IN ARRAY(json_result) LOOP
			raise notice 'v_groupby,%',v_groupby;
				INSERT INTO audit_fid_log (fid, count, criticity, groupby)
				VALUES (rec.fid,  (rec_result::json ->> 'count'), v_criticity, (rec_result::json ->>'groupBy'));
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
				'"setVisibleLayers":[]'||','||
				'"point":{"geometryType":"", "values":[]}'||','||
				'"line":{"geometryType":"", "values":[]}'||','||
				'"polygon":{"geometryType":"", "values":[]}'||
			   '}}'||
		'}')::json, 2776);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_user_check_data(json)
  OWNER TO postgres;
