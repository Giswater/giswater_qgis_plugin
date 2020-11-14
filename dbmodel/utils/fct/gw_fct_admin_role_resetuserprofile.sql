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
SELECT SCHEMA_NAME.gw_fct_admin_role_resetuserprofile($${"data":{"parameters":{"user":"user3", "fromUser":"user2"}}}$$)

-- fid: 358
*/

DECLARE

v_copyfromuser text;
v_projecttype text;
v_user text;
v_count1 integer;
v_count2 integer;
v_result text;
v_version text;
v_result_info json;
v_error_context text;
v_level integer = 1;
v_message text = 'Reset user profile done successfully';
  
BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  Get project type
	SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version order by 1 desc limit 1;

	--  Get input parameters:
	v_user := (((p_data ->> 'data')::json->>'parameters')::json->>'user');
	v_copyfromuser := ((p_data ->> 'data')::json->>'parameters')::json->>'fromUser';

	-- delete previous log results
	DELETE FROM audit_check_data WHERE fid=358 AND cur_user=current_user;

	INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('RESET USER PROFILE FUNCTION'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('---------------------------------------'));


	-- check if user exists
	IF (SELECT rolname FROM pg_roles WHERE rolname = v_user) IS NOT NULL THEN

		-- setting using sample values from another use (fromuser)
		IF v_copyfromuser IS NOT NULL AND v_copyfromuser !='' THEN

			-- check if fromuser exists
			IF (SELECT rolname FROM pg_roles WHERE rolname = v_copyfromuser) IS NOT NULL THEN

				-- check if user and fromuser has the same number of roles (close to has the same roles due the autocontened roles system)
				SELECT count(*) INTO v_count1 FROM pg_roles WHERE  pg_has_role( v_user, oid, 'member');
				SELECT count(*) INTO v_count2 FROM pg_roles WHERE  pg_has_role( v_copyfromuser, oid, 'member');
					
				IF v_count1 = v_count2 AND v_count1 > 0 THEN

					INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: User ',v_user,' have been copied from ',v_copyfromuser,' values'));

					-- config_param_user
					DELETE FROM config_param_user WHERE cur_user=v_user;
					INSERT INTO config_param_user (parameter, value, cur_user) 
					SELECT parameter, value, v_user FROM config_param_user WHERE cur_user=v_copyfromuser;

					-- basic selectors
					DELETE FROM selector_state WHERE cur_user=v_user;
					DELETE FROM selector_expl WHERE cur_user=v_user;
					DELETE FROM selector_hydrometer WHERE cur_user=v_user;
					DELETE FROM selector_workcat WHERE cur_user=v_user;

					INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, v_user FROM selector_expl WHERE cur_user=v_copyfromuser;
					INSERT INTO selector_hydrometer (state_id, cur_user) SELECT state_id, v_user FROM selector_hydrometer WHERE cur_user=v_copyfromuser;
					INSERT INTO selector_state (state_id, cur_user) SELECT state_id, v_user FROM selector_state WHERE cur_user=v_copyfromuser;
					INSERT INTO selector_workcat (workcat_id, cur_user) SELECT workcat_id, v_user FROM selector_workcat WHERE cur_user=v_copyfromuser;

					INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: User parameters and BASIC selectors have been copied (selector_state, selector_expl, selector_hydrometer, selector_workcat)'));
		

					-- om selectors
					IF 'role_om' IN (SELECT rolname FROM pg_roles WHERE pg_has_role(v_user, oid, 'member')) THEN


						DELETE FROM selector_audit WHERE cur_user=v_user;
						DELETE FROM selector_date WHERE cur_user=v_user;
						
						INSERT INTO selector_audit (fid, cur_user) SELECT fid, v_user FROM selector_audit WHERE cur_user=v_copyfromuser;
						INSERT INTO selector_date (from_date, to_date, context, cur_user) SELECT from_date, to_date, context, v_user FROM selector_date WHERE cur_user=v_copyfromuser;	

						INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: OM selectors have been copied (selector_audit, selector_date)'));

						IF v_projecttype ='UD' THEN	

						ELSE
							DELETE FROM selector_mincut_result WHERE cur_user=v_user;
							INSERT INTO selector_mincut_result (result_id, cur_user) SELECT result_id, v_user FROM selector_mincut_result WHERE cur_user=v_copyfromuser;

							INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: OM-WS selectors have been copied (selector_mincut_result)'));
						END IF; 
					END IF;

					IF 'role_edit' IN (SELECT rolname FROM pg_roles WHERE pg_has_role(v_user, oid, 'member')) THEN
							INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: There is no specific selectors for role_edit'));
					END IF;
					
					-- epa selectors
					IF 'role_epa' IN (SELECT rolname FROM pg_roles WHERE pg_has_role( v_user, oid, 'member')) THEN

						DELETE FROM selector_inp_result WHERE cur_user=v_user;
						DELETE FROM selector_rpt_compare WHERE cur_user=v_user;
						DELETE FROM selector_rpt_main WHERE cur_user=v_user;
						DELETE FROM selector_sector WHERE cur_user=v_user;

						INSERT INTO selector_inp_result (result_id, cur_user) SELECT result_id, v_user FROM selector_inp_result WHERE cur_user=v_copyfromuser;
						INSERT INTO selector_rpt_compare (result_id, cur_user) SELECT result_id, v_user FROM selector_rpt_compare WHERE cur_user=v_copyfromuser;
						INSERT INTO selector_rpt_main (result_id, cur_user) SELECT result_id, v_user FROM selector_rpt_main WHERE cur_user=v_copyfromuser;
						INSERT INTO selector_sector (sector_id, cur_user) SELECT sector_id, v_user FROM selector_sector WHERE cur_user=v_copyfromuser;
						
						INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: EPA selectors have been copied (selector_sector, selector_rpt_main, selector_inp_result, selector_rpt_compare)'));

						IF v_projecttype ='UD' THEN	
						
							DELETE FROM selector_inp_hydrology WHERE cur_user=v_user;
							DELETE FROM selector_rpt_compare_tstep WHERE cur_user=v_user;
							DELETE FROM selector_rpt_main_tstep WHERE cur_user=v_user;

							INSERT INTO selector_inp_hydrology (hydrology_id, cur_user) SELECT hydrology_id, v_user FROM selector_inp_hydrology WHERE cur_user=v_copyfromuser;
							INSERT INTO selector_rpt_main_tstep (resultdate, resulttime, cur_user) SELECT resultdate, resulttime, v_user FROM selector_rpt_main_tstep WHERE cur_user=v_copyfromuser;
							INSERT INTO selector_rpt_compare_tstep (resultdate, resulttime, cur_user) SELECT resultdate, resulttime, v_user FROM selector_rpt_compare_tstep WHERE cur_user=v_copyfromuser;

							INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: EPA-UD selectors have been copied (selector_inp_hydrology, selector_rpt_main_tstep, selector_rpt_compare_tstep)'));

						ELSE
							DELETE FROM selector_inp_demand WHERE cur_user=v_user;

							DELETE FROM selector_rpt_compare_tstep WHERE cur_user=v_user;
							DELETE FROM selector_rpt_main_tstep WHERE cur_user=v_user;
										
							INSERT INTO selector_inp_demand (dscenario_id, cur_user) SELECT dscenario_id, v_user FROM selector_inp_demand WHERE cur_user=v_copyfromuser;

							INSERT INTO selector_rpt_main_tstep (timestep, cur_user) SELECT timestep, v_user FROM selector_rpt_main_tstep WHERE cur_user=v_copyfromuser;
							INSERT INTO selector_rpt_compare_tstep (timestep, cur_user) SELECT timestep, v_user FROM selector_rpt_compare_tstep WHERE cur_user=v_copyfromuser;

							INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: EPA-WS selectors have been copied (selector_inp_demand, selector_rpt_compare_tstep, selector_rpt_main_tstep)'));

						END IF;

					END IF;

					-- plan selectors
					IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE pg_has_role( v_user, oid, 'member')) THEN

						DELETE FROM selector_plan_psector WHERE cur_user=v_user;
						DELETE FROM selector_plan_result WHERE cur_user=v_user;
						DELETE FROM selector_psector WHERE cur_user=v_user;
				
						INSERT INTO selector_plan_psector (psector_id, cur_user) SELECT psector_id, v_user FROM selector_plan_psector WHERE cur_user=v_copyfromuser;
						INSERT INTO selector_plan_result (result_id, cur_user) SELECT result_id, v_user FROM selector_plan_result WHERE cur_user=v_copyfromuser;
						INSERT INTO selector_psector (psector_id, cur_user) SELECT psector_id, v_user FROM selector_psector WHERE cur_user=v_copyfromuser;

						INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: Plan selectors have been copied (selector_plan_psector, selector_plan_result,selector_psector)'));

					END IF;					

				ELSE
					-- Destination user and copied user has not the same role
					INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('ERROR: User and copied User has not the same role'));
					v_level = 2;
					v_message = 'Destination user and copied user has not the same role';
				END IF;
			ELSE
				-- Destination user and copied user has not the same role
				INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('ERROR: Copied user does not exists'));
				v_level = 2;
				v_message = 'From user does not exists';
			END IF;

		-- setting values wihtout user sample
		ELSE
		
			-- config_param_user, getting role parameters where ismandatory is true (forced always)
			DELETE FROM config_param_user WHERE cur_user=v_user;
			INSERT INTO config_param_user (parameter, value, cur_user)
			SELECT sys_param_user.id, vdefault, v_user FROM config_param_user 
			RIGHT JOIN sys_param_user ON sys_param_user.id=parameter 
			WHERE ismandatory IS TRUE AND sys_role IN (SELECT rolname FROM pg_roles 
			WHERE pg_has_role(v_user, oid, 'member'));

			-- selectors
			DELETE FROM selector_expl WHERE cur_user=v_user;
			DELETE FROM selector_state WHERE cur_user=v_user;
			DELETE FROM selector_hydrometer WHERE cur_user=v_user;

			INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, v_user FROM exploitation;
			INSERT INTO selector_state (state_id, cur_user) SELECT 1, v_user FROM value_state LIMIT 1;
			INSERT INTO selector_hydrometer (state_id, cur_user) SELECT id, v_user FROM ext_rtc_hydrometer_state;

			INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: User ',v_user,' have been reset'));

			INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('INFO: User parameters and BASIC selectors have been reset (selector_state, selector_expl, selector_hydrometer, selector_workcat)'));
			
		END IF;
		
	ELSE
		-- User does not exists
		INSERT INTO audit_check_data (fid, error_message) VALUES (358, concat('ERROR: User does not exists'));
		v_level = 2;
		v_message = 'User does not exists';
	END IF;	

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=358 ORDER by id) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
		
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	
	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"setVisibleLayers":[]'||
			'}}'||
	    '}')::json;

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;