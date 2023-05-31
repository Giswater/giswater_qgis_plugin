/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3242

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setinitproject (p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_setinitproject($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":5367}, "form":{}, "feature":{}, "data":{}}$$);

-- fid: 

*/

DECLARE 

v_schemaname text;
v_rectable record;
v_error_context text;
v_errortext text;
v_qgis_init_guide_map boolean;
v_isaudit text;
v_project_type text;
v_version text;
v_epsg integer;
v_return json;


BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

    SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;

	-- Get input parameters
    v_isaudit := (p_data ->> 'data')::json->> 'isAudit';

    -- get user parameters
    SELECT value INTO v_qgis_init_guide_map FROM config_param_user where parameter='qgis_init_guide_map' AND cur_user=current_user;

    -- profilactic null control
	IF v_qgis_init_guide_map IS NULL THEN v_qgis_init_guide_map = FALSE; END IF;

	-- set mandatory values of config_param_user in case of not exists (for new users or for updates)
	FOR v_rectable IN SELECT * FROM sys_param_user WHERE ismandatory IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, 'member'))
	LOOP
		IF v_rectable.id NOT IN (SELECT parameter FROM config_param_user WHERE cur_user=current_user) THEN
			INSERT INTO config_param_user (parameter, value, cur_user) 
			SELECT sys_param_user.id, vdefault, current_user FROM sys_param_user WHERE sys_param_user.id = v_rectable.id;	

			v_errortext=concat('Set value for new variable in config param user: ',v_rectable.id,'.');

			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (101, 4, v_errortext);
		END IF;
	END LOOP;

	-- delete on config_param_user fron updated values on sys_param_user
	DELETE FROM config_param_user WHERE parameter NOT IN (SELECT id FROM sys_param_user) AND cur_user = current_user;


	-- Force exploitation selector in case of null values
	IF v_qgis_init_guide_map AND (v_isaudit IS NULL OR v_isaudit = 'false') THEN
		DELETE FROM selector_expl WHERE cur_user = current_user;

		-- looking for additional schema 
		IF v_addschema IS NOT NULL AND v_addschema != v_schemaname THEN
			EXECUTE 'SET search_path = '||v_addschema||', public';
			DELETE FROM selector_expl WHERE cur_user = current_user;			
			SET search_path = 'SCHEMA_NAME', public;
		END IF;
	ELSE
		-- Force exploitation selector in case of null values
		IF (SELECT count(*) FROM selector_expl WHERE cur_user=current_user) < 1 THEN 

			IF (SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_exploitation_x_user') IS NOT TRUE THEN

				INSERT INTO selector_expl (expl_id, cur_user) 
				SELECT expl_id, current_user FROM exploitation WHERE active IS NOT FALSE AND expl_id > 0 limit 1;
				v_errortext=concat('Set visible exploitation for user ',(SELECT expl_id FROM exploitation WHERE active IS NOT FALSE AND expl_id > 0 limit 1));
				INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (101, 4, v_errortext);
			ELSE
				INSERT INTO selector_expl (expl_id, cur_user) 
				SELECT expl_id, current_user FROM config_user_x_expl WHERE username = current_user AND expl_id > 0 limit 1;
				v_errortext=concat('Set visible exploitation for user ',(SELECT expl_id FROM config_user_x_expl WHERE username = current_user AND expl_id > 0 limit 1));
				INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (101, 4, v_errortext);
			END IF;
		END IF;
	END IF;

	-- Force state selector in case of null values
	IF (SELECT count(*) FROM selector_state WHERE cur_user=current_user) < 1 THEN 
	  	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
		v_errortext=concat('Set feature state = 1 for user');
		INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (101, 4, v_errortext);
	END IF;

	-- force hydrometer_selector in case of null values
	IF (select cur_user FROM selector_hydrometer WHERE cur_user = current_user limit 1) IS NULL THEN
		INSERT INTO selector_hydrometer (state_id, cur_user) 
		SELECT id, current_user FROM ext_rtc_hydrometer_state ON CONFLICT (state_id, cur_user) DO NOTHING;
	END IF;

	--Force hydrology_selector when null values from user
	IF v_project_type='UD' THEN
		IF (SELECT hydrology_id FROM cat_hydrology LIMIT 1) IS NOT NULL THEN
			INSERT INTO config_param_user 
			SELECT 'inp_options_hydrology_scenario', hydrology_id, current_user FROM cat_hydrology LIMIT 1
			ON CONFLICT (parameter, cur_user) DO NOTHING;
			UPDATE config_param_user SET value = hydrology_id FROM (SELECT hydrology_id FROM cat_hydrology LIMIT 1) a
			WHERE parameter =  'inp_options_hydrology_scenario' and value is null;
		END IF;
	END IF;

    --    Control null
	v_return:=COALESCE(v_return,'{}');

	--  Return
	RETURN ('{"status":"Accepted", "version":"'|| v_version ||'"}')::json;
	
	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	  
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;