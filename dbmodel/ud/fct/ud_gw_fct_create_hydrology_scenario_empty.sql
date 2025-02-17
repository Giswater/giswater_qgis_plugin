/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3134

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_hydrology_scenario_empty(p_data json)
RETURNS json AS
$BODY$


/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"target":"1", "copyFrom":"2", "action":"DELETE-COPY"}}}$$)
-- fid: 438
*/

DECLARE

object_rec record;
v_version text;
v_result json;
v_result_info json;
v_copyfrom integer;
v_target integer;
v_error_context text;
v_count integer;
v_count2 integer;
v_projecttype text;
v_fid integer = 523;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_result_id text = null;
v_name text;
v_descript text;
v_parent_id integer;
v_dscenario_type text;
v_active boolean;
v_expl_id integer;
v_scenarioid integer;
v_aux_params json;
v_infiltration text;
v_text text;
v_inp_hydrology text;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting variables
	v_inp_hydrology = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_hydrology_current' AND cur_user = current_user limit 1);

	-- getting input data
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_infiltration :=  ((p_data ->>'data')::json->>'parameters')::json->>'infiltration';
	v_text :=  ((p_data ->>'data')::json->>'parameters')::json->>'text';
	v_expl_id :=  ((p_data ->>'data')::json->>'parameters')::json->>'expl';
	v_active :=  ((p_data ->>'data')::json->>'parameters')::json->>'active';
	v_aux_params :=  ((p_data ->>'data')::json->>'aux_params')::json;


	-- Reset values
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CREATE EMPTY HYDROLOGY SCENARIO'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '--------------------------------------------------');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Name: ',v_name));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Infiltration: ',v_infiltration));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Text: ',v_text));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Expl_id: ',v_expl_id));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Active: ',v_active));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '--------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '---------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '---------');

	-- process
	-- inserting on catalog table
	PERFORM setval('SCHEMA_NAME.cat_hydrology_hydrology_id_seq'::regclass,(SELECT max(hydrology_id) FROM cat_hydrology) ,true);

	INSERT INTO cat_hydrology (name, infiltration, text, expl_id, active, log)
	VALUES (v_name, v_infiltration, v_text, v_expl_id, v_active, concat('Created by ',current_user,' on ',substring(now()::text,0,20)))
	ON CONFLICT (name) DO NOTHING
	RETURNING hydrology_id INTO v_scenarioid;

	IF v_scenarioid IS NULL THEN
		SELECT hydrology_id INTO v_scenarioid FROM cat_hydrology where name = v_name;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, null, 3, concat('ERROR: The hydrology scenario ( ',v_scenarioid,' ) already exists with proposed name ',v_name ,'. Please try another one.'));
	ELSE
		-- setting current dwf for user
		UPDATE config_param_user SET value = v_scenarioid WHERE cur_user = current_user AND parameter = 'inp_options_hydrology_current';

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'The new dscenario have been created sucessfully');
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat('This new hydrology scenario is now your current scenario.'));

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

	-- Execute aux_func
	if v_aux_params->>'aux_fct'::text = '3100' then
		EXECUTE 'SELECT gw_fct_manage_hydrology_values($${"client":{"device":4, "lang":"", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"'||v_scenarioid||'", "sector":"-999", "action":"KEEP-COPY", "copyFrom":"'||v_inp_hydrology||'"}}}$$);';
	end if;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3042, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;