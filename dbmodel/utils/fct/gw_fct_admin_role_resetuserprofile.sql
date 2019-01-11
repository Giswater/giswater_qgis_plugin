/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2556

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_role_resetuserprofile(p_data json)
  RETURNS json AS
$BODY$

/* example
-- reset values
SELECT SCHEMA_NAME.gw_fct_admin_role_resetuserprofile($${"user":"postgres", "values":{}}$$)

-- taking values from another user
SELECT SCHEMA_NAME.gw_fct_admin_role_resetuserprofile($${"user":"postgres", "values":{"copyFromUserSameRole":"postgres"}}$$)

-- Setting specific values (todo)
SELECT SCHEMA_NAME.gw_fct_admin_role_resetuserprofile($${"user":"postgres", "values":{"exploitation":{1,2,3}, "state":{1}}}$$)
*/


DECLARE

--  Variables
	v_copyfromuser text;
	v_projecttype text;
	v_user text;
  
BEGIN

--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

--  Get project type
	SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

--  Get input parameters:
	v_user := (p_data ->> 'user');
	v_copyfromuser := (p_data ->> 'values')::json->> 'copyFromUserSameRole';

	-- setting using sample values from another use
	IF v_copyfromuser IS NOT NULL THEN
	
	-- todo: improve with controls
	--IF (v_copyfromuser IS NOT NULL) AND (v_copyfromuser not exists as user) AND (v_copyfromuser not has same role than v_user) THEN
	
		-- config_param_user
		INSERT INTO config_param_user (parameter, value, cur_user) 
		SELECT parameter, value, v_user FROM config_param_user WHERE cur_user=v_copyfromuser;

		-- selectors
		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, v_user FROM selector_expl WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_psector (psector_id, cur_user) SELECT psector_id, v_user FROM selector_psector WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_state (state_id, cur_user) SELECT state_id, v_user FROM selector_state WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_date (state_id, cur_user) SELECT state_id, v_user FROM selector_date WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_hydrometer (state_id, cur_user) SELECT state_id, v_user FROM selector_hydrometer WHERE cur_user=v_copyfromuser;
		INSERT INTO selector_workcat (state_id, cur_user) SELECT state_id, v_user FROM selector_workcat WHERE cur_user=v_copyfromuser;
	
		-- role epa
		INSERT INTO inp_selector_sector (sector_id, cur_user) SELECT sector_id, v_user FROM inp_selector_sector WHERE cur_user=v_copyfromuser;
		INSERT INTO inp_selector_result (sector_id, cur_user) SELECT sector_id, v_user FROM inp_selector_result WHERE cur_user=v_copyfromuser;
		
		IF v_projecttype ='UD' THEN
			INSERT INTO inp_selector_hydrology (hydrology_id, cur_user) SELECT hydrology_id, 'user_name' FROM inp_selector_hydrology WHERE cur_user='postgres';
		ELSE
			INSERT INTO inp_selector_dscenario (dscenario_id, cur_user) SELECT dscenario_id, 'user_name' FROM inp_selector_dscenario WHERE cur_user='postgres';
		END IF;

	-- setting values wihtout user sample
	ELSE
	
		-- config_param_user, getting role parameters where ismandatory is true (forced always)
		INSERT INTO config_param_user (parameter, value, cur_user) 
		SELECT parameter, value, v_user FROM SCHEMA_NAME.config_param_user JOIN SCHEMA_NAME.audit_cat_param_user ON audit_cat_param_user.id=parameter 
		WHERE ismandatory IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE pg_has_role(v_user, oid, 'member'));

		-- selectors
		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, v_user FROM selector_expl;
		INSERT INTO selector_state (state_id, cur_user) SELECT 1, v_user FROM selector_state LIMIT 1;
		INSERT INTO selector_hydrometer (state_id, cur_user) SELECT state_id, v_user FROM selector_hydrometer;
		
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


