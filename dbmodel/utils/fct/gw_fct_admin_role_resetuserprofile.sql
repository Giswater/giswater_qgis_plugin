/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2922

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_role_resetuserprofile(p_data json)
  RETURNS json AS
$BODY$

/* example
-- reset values
SELECT SCHEMA_NAME.gw_fct_admin_role_resetuserprofile($${"user":"postgres", "values":{}}$$)

-- taking values from another user
SELECT SCHEMA_NAME.gw_fct_admin_role_resetuserprofile($${"data":{"parameters":{"user":"user1", "values":{"copyFromUserSameRole":"user2"}}}}$$)
*/

DECLARE

v_copyfromuser text;
v_projecttype text;
v_user text;
  
BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  Get project type
	SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;

	--  Get input parameters:
	v_user := (((p_data ->> 'data')::json->>'parameters')::json->>'user');
	v_copyfromuser := (((p_data ->> 'data')::json->>'parameters')::json->>'values')::json->> 'copyFromUserSameRole';

	-- setting using sample values from another use
	IF v_copyfromuser IS NOT NULL THEN
	
		-- todo: improve with controls
		--IF (v_copyfromuser IS NOT NULL) AND (v_copyfromuser not exists as user) AND (v_copyfromuser not has same role than v_user) THEN

		-- config_param_user
		DELETE FROM config_param_user WHERE cur_user=v_user;
		INSERT INTO config_param_user (parameter, value, cur_user) 
		SELECT parameter, value, v_user FROM config_param_user WHERE cur_user=v_copyfromuser;

		-- selectors
		DELETE FROM selector_audit WHERE cur_user=v_user;
		DELETE FROM selector_date WHERE cur_user=v_user;
		DELETE FROM selector_expl WHERE cur_user=v_user;
		DELETE FROM selector_hydrometer WHERE cur_user=v_user;
		DELETE FROM selector_inp_result WHERE cur_user=v_user;

		DELETE FROM selector_plan_psector WHERE cur_user=v_user;
		DELETE FROM selector_plan_result WHERE cur_user=v_user;
		DELETE FROM selector_psector WHERE cur_user=v_user;

		DELETE FROM selector_rpt_compare WHERE cur_user=v_user;
		DELETE FROM selector_rpt_main WHERE cur_user=v_user;

		DELETE FROM selector_sector WHERE cur_user=v_user;
		DELETE FROM selector_state WHERE cur_user=v_user;
		DELETE FROM selector_workcat WHERE cur_user=v_user;
			

		INSERT INTO selector_audit (fid, cur_user) SELECT fid, v_user FROM selector_audit WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_date (from_date, to_date, context, cur_user) SELECT from_date, to_date, context, v_user FROM selector_date WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, v_user FROM selector_expl WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_hydrometer (state_id, cur_user) SELECT state_id, v_user FROM selector_hydrometer WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_inp_result (result_id, cur_user) SELECT result_id, v_user FROM selector_inp_result WHERE cur_user=v_copyfromuser;
		
		INSERT INTO selector_plan_psector (psector_id, cur_user) SELECT psector_id, v_user FROM selector_plan_psector WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_plan_result (result_id, cur_user) SELECT result_id, v_user FROM selector_plan_result WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_psector (psector_id, cur_user) SELECT psector_id, v_user FROM selector_psector WHERE cur_user=v_copyfromuser;

		INSERT INTO selector_rpt_compare (result_id, cur_user) SELECT result_id, v_user FROM selector_rpt_compare WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_rpt_main (result_id, cur_user) SELECT result_id, v_user FROM selector_rpt_main WHERE cur_user=v_copyfromuser;

		INSERT INTO selector_sector (sector_id, cur_user) SELECT sector_id, v_user FROM selector_sector WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_state (state_id, cur_user) SELECT state_id, v_user FROM selector_state WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_workcat (workcat_id, cur_user) SELECT workcat_id, v_user FROM selector_workcat WHERE cur_user=v_copyfromuser;		
		
		
		IF v_projecttype ='UD' THEN	
			DELETE FROM selector_inp_hydrology WHERE cur_user=v_user;
			DELETE FROM selector_rpt_compare_tstep WHERE cur_user=v_user;
			DELETE FROM selector_rpt_main_tstep WHERE cur_user=v_user;

			INSERT INTO selector_inp_hydrology (hydrology_id, cur_user) SELECT hydrology_id, v_user FROM selector_inp_hydrology WHERE cur_user=v_copyfromuser;
			INSERT INTO selector_rpt_main_tstep (resultdate, resulttime, cur_user) SELECT resultdate, resulttime, v_user FROM selector_rpt_main_tstep WHERE cur_user=v_copyfromuser;
			INSERT INTO selector_rpt_compare_tstep (resultdate, resulttime, cur_user) SELECT resultdate, resulttime, v_user FROM selector_rpt_compare_tstep WHERE cur_user=v_copyfromuser;
		ELSE
			DELETE FROM selector_inp_demand WHERE cur_user=v_user;
			DELETE FROM selector_mincut_result WHERE cur_user=v_user;
			DELETE FROM selector_rpt_compare_tstep WHERE cur_user=v_user;
			DELETE FROM selector_rpt_main_tstep WHERE cur_user=v_user;
						
			INSERT INTO selector_inp_demand (dscenario_id, cur_user) SELECT dscenario_id, v_user FROM selector_inp_demand WHERE cur_user=v_copyfromuser;
			INSERT INTO selector_mincut_result (result_id, cur_user) SELECT result_id, v_user FROM selector_mincut_result WHERE cur_user=v_copyfromuser;
			INSERT INTO selector_rpt_main_tstep (timestep, cur_user) SELECT timestep, v_user FROM selector_rpt_main_tstep WHERE cur_user=v_copyfromuser;
			INSERT INTO selector_rpt_compare_tstep (timestep, cur_user) SELECT timestep, v_user FROM selector_rpt_compare_tstep WHERE cur_user=v_copyfromuser;
		END IF;

	-- setting values wihtout user sample
	ELSE
	
		-- config_param_user, getting role parameters where ismandatory is true (forced always)
		DELETE FROM config_param_user WHERE cur_user=v_user;
		INSERT INTO config_param_user (parameter, value, cur_user)
		SELECT sys_param_user.id, vdefault, v_user FROM config_param_user RIGHT JOIN sys_param_user ON sys_param_user.id=parameter 
		WHERE ismandatory IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles WHERE pg_has_role(v_user, oid, 'member'));

		-- selectors
		DELETE FROM selector_expl WHERE cur_user=v_user;
		DELETE FROM selector_state WHERE cur_user=v_user;
		DELETE FROM selector_hydrometer WHERE cur_user=v_user;

		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, v_user FROM exploitation;
		INSERT INTO selector_state (state_id, cur_user) SELECT 1, v_user FROM value_state LIMIT 1;
		INSERT INTO selector_hydrometer (state_id, cur_user) SELECT id, v_user FROM ext_rtc_hydrometer_state;
		
	END IF;

RETURN '{"status":"ok"}';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


