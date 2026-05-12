/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3362

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_logtables (p_data json)
  RETURNS json AS
$BODY$

/*
SELECT gw_fct_create_logtables('{"client":{}, "form":{}, "feature":{}, "data":{"parameters":{"fid":604}}}');

*/

DECLARE
v_fid integer;
v_fprocessname text;
v_filter text;
v_project_type text;

v_patternmethod integer;
v_period text;
v_networkmode integer;
v_dscenario integer;
v_patternmethodval text;
v_periodval text;
v_dscenarioval text;
v_networkmodeval text;
v_hydrologyscenario text;
v_qualitymode text;
v_qualmodeval text;
v_buildupmode int2;
v_buildmodeval text;
v_usenetworkgeom boolean;
v_usenetworkdemand boolean;
v_defaultdemand	float;
v_doublen2a integer;
v_curvedefault text;
v_options json;
v_workspace text;
v_dscenarioused integer;
v_psectorused integer;
v_values text;
v_default boolean;
v_defaultval text;
v_debug boolean;
v_debugval text;
v_advanced boolean;
v_advancedval text;


BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_fid := (((p_data ->>'data')::json->>'parameters')::json->>'fid');

	-- get system parameters
	v_fprocessname = (SELECT UPPER(fprocess_name) FROM sys_fprocess where fid = v_fid);
	v_project_type = (SELECT project_type FROM sys_version order by id desc limit 1);

	IF v_project_type  = 'UD' THEN
		DROP TABLE IF EXISTS t_anl_gully;CREATE TEMP TABLE t_anl_gully (LIKE SCHEMA_NAME.anl_gully INCLUDING ALL);
	END IF;

	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 2, NULL);
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 1, NULL);


	IF v_fid = 604 THEN -- check dbproject

		-- fill log table
        INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, v_fprocessname);
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3142", "fid":"'||v_fid||'","criticity":"3", "tempTable":"t_", "cur_user":"current_user", "is_process":true, "is_header":true, "label_id":"1004"}}$$)';-- CRITICAL ERRORS
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3142", "fid":"'||v_fid||'","criticity":"2", "tempTable":"t_", "cur_user":"current_user", "is_process":true, "is_header":true, "label_id":"3002"}}$$)';-- WARNINGS
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3142", "fid":"'||v_fid||'","criticity":"1", "tempTable":"t_", "cur_user":"current_user", "is_process":true, "is_header":true, "label_id":"3001"}}$$)';-- INFO
        INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, '-------------------------------');
        INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, '');     
       	
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4442", "function":"3142", "fid":"'||v_fid||'","criticity":"4", "tempTable":"t_", "cur_user":"current_user", "is_process":true}}$$)'; -- instructions
        INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, '');

	ELSIF v_fid = 227 THEN -- go2epa

		-- get user parameters
		SELECT row_to_json(row) FROM (SELECT inp_options_interval_from, inp_options_interval_to
				FROM crosstab('SELECT cur_user, parameter, value
				FROM config_param_user WHERE parameter IN (''inp_options_interval_from'',''inp_options_interval_to'') 
				AND cur_user = current_user'::text) as ct(cur_user varchar(50), inp_options_interval_from text, inp_options_interval_to text))row
		INTO v_options;

		IF v_project_type = 'WS' THEN
			SELECT count(*) INTO v_doublen2a FROM ve_inp_pump WHERE pump_type = 'HEADPUMP';
		END IF;

		SELECT value INTO v_patternmethod FROM config_param_user WHERE parameter = 'inp_options_patternmethod' AND cur_user=current_user;
		SELECT value INTO v_dscenario FROM config_param_user WHERE parameter = 'inp_options_dscenario_priority' AND cur_user=current_user;
		SELECT value INTO v_networkmode FROM config_param_user WHERE parameter = 'inp_options_networkmode' AND cur_user=current_user;
		SELECT value INTO v_qualitymode FROM config_param_user WHERE parameter = 'inp_options_quality_mode' AND cur_user=current_user;
		SELECT value INTO v_buildupmode FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' AND cur_user=current_user;
		SELECT name INTO v_workspace FROM config_param_user c JOIN cat_workspace ON value = id::text WHERE parameter = 'utils_workspace_current' AND c.cur_user=current_user;

		SELECT idval INTO v_dscenarioval FROM inp_typevalue WHERE id=v_dscenario::text AND typevalue ='inp_options_dscenario_priority';
		SELECT idval INTO v_patternmethodval FROM inp_typevalue WHERE id=v_patternmethod::text AND typevalue ='inp_value_patternmethod';
		SELECT idval INTO v_networkmodeval FROM inp_typevalue WHERE id=v_networkmode::text AND typevalue ='inp_options_networkmode';
		SELECT idval INTO v_qualmodeval FROM inp_typevalue WHERE id=v_qualitymode::text AND typevalue ='inp_value_opti_qual';
		SELECT idval INTO v_buildmodeval FROM inp_typevalue WHERE id=v_buildupmode::text AND typevalue ='inp_options_buildup_mode';

		-- get buildup mode parameters
		IF v_buildupmode = 1 THEN
			v_values = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user);
		ELSIF v_buildupmode = 2 THEN
			v_values = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_buildup_transport' AND cur_user=current_user);
		END IF;

		-- get settings values
		v_default = (SELECT value::json->>'status' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user=current_user);
		v_defaultval = (SELECT value::json->>'parameters' FROM config_param_user WHERE parameter = 'inp_options_vdefault' AND cur_user=current_user);

		v_advanced = (SELECT value::json->>'status' FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user);
		v_advancedval = (SELECT value::json->>'parameters' FROM config_param_user WHERE parameter = 'inp_options_advancedsettings' AND cur_user=current_user);

		v_debug = (SELECT value::json->>'showLog' FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);
		v_debugval = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);
		v_dscenarioused = (SELECT count(dscenario_id) FROM selector_inp_dscenario WHERE cur_user = current_user);
		v_psectorused = (SELECT count(psector_id) FROM selector_psector WHERE cur_user = current_user);


		-- Header
		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-12, current_user, v_fid, 4, concat('CHECK RESULT WITH CURRENT USER-OPTIONS ACORDING EPA RULES'));
		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-13, current_user, v_fid, 4, '-------------------------------------------------------------------------------------');
		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-14, current_user, v_fid, 4, '');

		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-9, current_user, v_fid, 3, 'CRITICAL ERRORS');
		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-10, current_user, v_fid, 3, '----------------------');
		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-11, current_user, v_fid, 3, '');

		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-6, current_user, v_fid, 2, 'WARNINGS');
		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-7, current_user, v_fid, 2, '--------------');
		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-8, current_user, v_fid, 2, '');

		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-3, current_user, v_fid, 1, 'INFO');
		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-4, current_user, v_fid, 1, '-------');
		INSERT INTO t_audit_check_data (id, cur_user, fid, criticity, error_message) VALUES (-5, current_user, v_fid, 1, '');

		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Result id: '));
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Created by: ', current_user, ', on ', to_char(now(),'YYYY/MM/DD - HH:MM:SS')));
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Network export mode: ', v_networkmodeval));
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Pattern method: ', v_patternmethodval));
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Quality mode: ', v_qualmodeval));
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Number of Presspump (Double-n2a): ', v_doublen2a));
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Buildup mode: ', v_buildmodeval, '. Parameters:', v_values));
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Active Workspace: ', v_workspace));
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Number of dscenarios used: ', v_dscenarioused));
		IF v_dscenarioused > 0 THEN
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Demand dscenario priority: ', v_dscenarioval));
		END IF;
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Number of psectors used: ', v_psectorused));

		IF v_default::boolean THEN
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Default values: ', v_defaultval));
		ELSE
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Default values: No default values used'));
		END IF;

		IF v_advanced::boolean THEN
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Advanced settings: ', v_advancedval));
		ELSE
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Advanced settings: No advanced settings used'));
		END IF;

		IF v_debug::boolean THEN
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, concat('Debug: ', v_defaultval));
		END IF;

	END IF;

	--  Return
	RETURN '{"status":"ok"}';

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;