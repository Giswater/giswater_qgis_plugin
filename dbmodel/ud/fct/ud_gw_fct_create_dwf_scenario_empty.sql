/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3134

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_dwf_scenario_empty(p_data json)
RETURNS json AS
$BODY$


/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_create_dwf_scenario_empty($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"parameters":{"target":"1", "copyFrom":"2", "action":"DELETE-COPY"}}}$$)
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
v_fid integer = 524;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_result_id text = null;
v_idval text;
v_startdate date;
v_enddate date;
v_observ text;
v_expl_id integer;
v_active boolean;
v_scenarioid text;
v_aux_params json;
v_inp_dwf text;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting variables
	v_inp_dwf = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_dwfscenario' AND cur_user = current_user limit 1);

	-- getting input data
	v_idval :=  ((p_data ->>'data')::json->>'parameters')::json->>'idval';
	v_startdate :=  ((p_data ->>'data')::json->>'parameters')::json->>'startdate';
	v_enddate :=  ((p_data ->>'data')::json->>'parameters')::json->>'enddate';
	v_observ :=  ((p_data ->>'data')::json->>'parameters')::json->>'observ';
	v_expl_id :=  ((p_data ->>'data')::json->>'parameters')::json->>'expl';
	v_active :=  ((p_data ->>'data')::json->>'parameters')::json->>'active';
	v_aux_params := ((p_data ->>'data')::json->>'aux_params')::json;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CREATE EMPTY DSCENARIO'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '---------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '---------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '-------');

	-- process
	-- inserting on catalog table
	PERFORM setval('SCHEMA_NAME.cat_dwf_scenario_id_seq'::regclass,(SELECT max(id) FROM cat_dwf_scenario) ,true);

	INSERT INTO cat_dwf_scenario (idval, startdate, enddate, observ, active, expl_id,log)
	VALUES (v_idval, v_startdate, v_enddate, v_observ, v_active, v_expl_id, concat('Created by ',current_user,' on ',substring(now()::text,0,20)))
	ON CONFLICT (idval) DO NOTHING
	RETURNING id INTO v_scenarioid;

	IF v_scenarioid IS NULL THEN
		SELECT id INTO v_scenarioid FROM cat_dwf_scenario where idval = v_idval;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, null, 3, concat('ERROR: The dwf scenario already exists with proposed name (',v_idval ,'). Please try another one.'));
	ELSE

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Id_val: ',v_idval));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Descript: ',v_startdate));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Parent: ',v_enddate));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Type: ',v_observ));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('active: ',v_active));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Expl_id: ',v_expl_id));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat ('The new dscenario (',v_scenarioid,') have been created sucessfully'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'The new dscenario is now your current DWF scenario');

		-- setting current dwf for user
		UPDATE config_param_user SET value = v_scenarioid WHERE cur_user = current_user AND parameter = 'inp_options_dwfscenario';
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
	if v_aux_params->>'aux_fct'::text = '3102' then
		execute 'SELECT gw_fct_manage_dwf_values($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"'||
		v_scenarioid||'", "sector":"-999", "action":"KEEP-COPY", "copyFrom":"'||v_inp_dwf||'"}}}$$);';
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