/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2806


--DROP FUNCTION SCHEMA_NAME.gw_fct_admin_test_ci();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_test_ci()
  RETURNS json AS
$BODY$


/*
SELECT SCHEMA_NAME.gw_fct_admin_test_ci()
*/

DECLARE 

	rec_role record;
	rec_table record;
	rec_node_type record;
	rec_state integer;
	rec_fct record;

	v_result text;
	v_schemaname text;
	v_query text;
	v_query_result text;
	v_function text;
	v_feature_id text;
	v_project_type text;
	v_version text;
	v_result_info json;
	v_error_context text;
	v_state_type integer;
	v_nodecat text;
	v_node_arcdivide text;
	v_node_not_arcdivide text;
	v_psector_id integer;

DECLARE

BEGIN
	SET search_path = SCHEMA_NAME, public;
	
	v_schemaname = 'SCHEMA_NAME';
	
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;

	--set permisions for each role
	UPDATE config_param_system SET value = TRUE WHERE parameter = 'sys_role_permissions';
	
	PERFORM gw_fct_admin_role_permissions();
	
	GRANT ALL ON TABLE node_type TO role_basic;
	GRANT ALL ON TABLE audit_check_data TO role_basic;

	--remove previous results 
	DELETE FROM audit_check_data where fprocesscat_id = 115;
	
	--set configuration for gw_fct_pg2epa_main
	IF v_project_type = 'WS'  THEN
		DELETE FROM config_param_user WHERE cur_user=current_user AND parameter IN ('inp_options_patternmethod', 
		'inp_options_demandtype', 'inp_options_rtc_period_id','inp_options_networkmode');
		INSERT INTO config_param_user(parameter, value, cur_user) VALUES ('inp_options_patternmethod', 27, current_user);
		INSERT INTO config_param_user(parameter, value, cur_user) VALUES ('inp_options_demandtype', 2, current_user);
		INSERT INTO config_param_user(parameter, value, cur_user) VALUES ('inp_options_rtc_period_id', 5, current_user);
		INSERT INTO config_param_user(parameter, value, cur_user) VALUES ('inp_options_networkmode', 4, current_user);
					
	END IF;

	FOR rec_role IN (SELECT * FROM sys_role WHERE id !='role_crm') LOOP

		--set role and insert values into exploitation selector
		EXECUTE 'SET ROLE '||rec_role.id||';';

		INSERT INTO selector_expl (expl_id,cur_user) SELECT DISTINCT expl_id, current_user FROM exploitation ON CONFLICT (expl_id, cur_user) DO NOTHING;
		

		FOR rec_fct IN (SELECT function_name, sample_query FROM audit_cat_function WHERE isdeprecated != TRUE AND sample_query IS NOT NULL
		ORDER BY id) LOOP

			IF rec_fct.function_name = 'gw_fct_arc_divide' THEN

				FOR rec_state IN 1..2 LOOP
				--rec_state =1;
					IF (rec_state = 1 AND rec_role.id NOT IN ('role_basic','role_om','role_crm')) OR (rec_state=2 AND rec_role.id IN ('role_master', 'role_admin')) THEN

						INSERT INTO selector_state (state_id,cur_user) VALUES (1, current_user) ON CONFLICT (state_id, cur_user) DO NOTHING;

						--set default values of states
						INSERT INTO  config_param_user (parameter, value, cur_user) VALUES ('state_vdefault', rec_state, current_user)
						ON CONFLICT (parameter, cur_user)  DO
						UPDATE SET value = rec_state;

						SELECT id INTO v_state_type FROM value_state_type WHERE state=rec_state;
						
						INSERT INTO  config_param_user (parameter, value, cur_user) VALUES ('statetype_vdefault', v_state_type,current_user)
						ON CONFLICT (parameter, cur_user)  DO
						UPDATE SET value = v_state_type;

						--select 2 node types - one that divides arc and one that doesnt
						SELECT id INTO v_node_arcdivide FROM node_type WHERE active IS TRUE AND isarcdivide IS TRUE LIMIT 1;
						
						SELECT id INTO v_node_not_arcdivide FROM node_type WHERE active IS TRUE AND isarcdivide IS FALSE LIMIT 1;

						IF v_node_not_arcdivide IS NULL THEN
							UPDATE node_type  SET isarcdivide = FALSE WHERE id =(SELECT id FROM node_type ORDER BY ID LIMIT 1 );
							SELECT id INTO v_node_not_arcdivide FROM node_type WHERE active IS TRUE AND isarcdivide IS FALSE LIMIT 1;
						END IF;
						
						FOR rec_node_type IN (SELECT * FROM node_type JOIN cat_feature ON node_type.id= cat_feature.id 
							WHERE node_type.id IN (v_node_arcdivide, v_node_not_arcdivide)) LOOP
							
				
							--set default values of node catalog
							IF v_project_type = 'WS' THEN
								SELECT id INTO v_nodecat FROM cat_node WHERE nodetype_id = rec_node_type.id LIMIT 1;
								INSERT INTO  config_param_user (parameter, value, cur_user)
								VALUES (concat(lower(rec_node_type.id), '_vdefault'), v_nodecat, current_user) 
								ON CONFLICT (parameter, cur_user) DO
								UPDATE SET value = v_nodecat;
							ELSIF v_project_type = 'UD' THEN
								SELECT id INTO v_nodecat FROM cat_node LIMIT 1;
								INSERT INTO  config_param_user (parameter, value, cur_user)
								VALUES ('nodecat_vdefault', v_nodecat, current_user) 
								ON CONFLICT (parameter, cur_user) DO
								UPDATE SET value = v_nodecat;
							END IF;


							IF (v_project_type = 'WS' and (SELECT value FROM config_param_user WHERE cur_user = current_user 
								AND parameter = concat(lower(rec_node_type.id), '_vdefault')) is not null) OR
								(v_project_type = 'UD' AND 
								(SELECT value FROM config_param_user WHERE cur_user = current_user 
								AND parameter = 'nodecat_vdefault') is not null) THEN
								
								IF rec_state=1 THEN
									--insert new nodes with state 1
									IF rec_node_type.isarcdivide IS TRUE THEN	
										UPDATE node_type SET isarcdivide=FALSE WHERE id=rec_node_type.id;
									END IF;
											
									IF v_project_type = 'WS' THEN
										EXECUTE 'INSERT INTO '||rec_node_type.child_layer||'(the_geom) 
										VALUES (st_setsrid(st_point(419049.60815202154,4576503.991683105),25831)) RETURNING node_id ;'
										INTO v_feature_id;

									ELSIF v_project_type = 'UD' THEN
										EXECUTE 'INSERT INTO '||rec_node_type.child_layer||'(the_geom) 
										VALUES (st_setsrid(st_point(419041.021099364, 4576512.66540741),25831)) RETURNING node_id ;'
										INTO v_feature_id;
										
									END IF;
									
									IF rec_node_type.isarcdivide IS TRUE THEN
										UPDATE node_type SET isarcdivide=true WHERE id=rec_node_type.id;
									END IF;	
										

								ELSIF rec_state = 2 THEN
									--set selector to  2 and sleect current_psector
									DELETE FROM selector_state WHERE current_user = cur_user;
									INSERT INTO selector_state (state_id,cur_user) VALUES (2, current_user) ON CONFLICT (state_id, cur_user) DO NOTHING;
								
									SELECT psector_id INTO v_psector_id FROM plan_psector LIMIT 1;
									INSERT INTO  config_param_user (parameter, value, cur_user) VALUES ('psector_vdefault',1, current_user)
									ON CONFLICT (parameter, cur_user)  DO
									UPDATE SET value = v_psector_id;

									--insert new nodes with state 2
									IF v_project_type = 'WS' THEN
										EXECUTE 'INSERT INTO '||rec_node_type.child_layer||'(the_geom) 
										VALUES (st_setsrid(st_point(419205.716051442,4576517.416978596),25831)) RETURNING node_id;'
										INTO v_feature_id;
									ELSIF v_project_type = 'UD' THEN
										EXECUTE 'INSERT INTO '||rec_node_type.child_layer||'(the_geom) 
										VALUES (st_setsrid(st_point(419124.612373783, 4576271.60134376),25831)) RETURNING node_id;'
										INTO v_feature_id;
									END IF;
								END IF;

								-- replace 'node_id' for id of the feature calling arc divide function
								select replace(concat(rec_fct.function_name,'($$',rec_fct.sample_query::json ->>v_project_type,'$$)')::TEXT,'node_id'::text,v_feature_id::text) 
								INTO v_function; 
												

								IF v_function IS NOT NULL THEN
									v_query = 'SELECT '||v_schemaname||'.'||v_function||';';
									EXECUTE v_query
									INTO v_query_result;
									raise notice 'result divide, %, %, %',rec_fct.function_name,rec_role.id,v_query_result

									INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, error_message) 
									VALUES (115, rec_fct.function_name,rec_role.id,v_query_result);
								END IF;					

								--fusion arcs or delete node if it's not connected to arcs (not arc divide)
								IF rec_node_type.isarcdivide is true AND rec_state = 1 then
									raise notice 'FUSION';
									EXECUTE 'SELECT gw_fct_arc_fusion ($${"client":{"device":3, "infoType":100, "lang":"ES"},
									"feature":{"id":["'||v_feature_id||'"]},"data":{"workcat_id_end":"work1",
									"enddate":"2020-02-05"}}$$);'
									INTO v_query_result;
									raise notice 'result fusion, %, %, %',rec_fct.function_name,rec_role.id,v_query_result
									INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, error_message) 
									VALUES (115, 'gw_fct_arc_fusion',rec_role.id,v_query_result);
									
								ELSE
								raise notice 'DELETE';
									EXECUTE 'SELECT gw_fct_set_delete_feature($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{"type":"NODE"}, 
									"data":{"filterFields":{}, "pageInfo":{}, "feature_id":"'||v_feature_id||'"}}$$)::text;'
									INTO v_query_result;
										
									INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, error_message) 
									VALUES (115, 'gw_fct_set_delete_feature',rec_role.id,v_query_result);

								END IF;
								
								--delete node created with state 2
								IF rec_state = 2 THEN
									DELETE FROM plan_psector_x_arc WHERE psector_id = v_psector_id 
									AND arc_id = (SELECT max(arc_id) FROM plan_psector_x_arc WHERE psector_id = v_psector_id);
								END IF;
							END IF;

						END LOOP;
					END IF;
				END LOOP;

			ELSIF rec_fct.function_name = 'gw_fct_feature_replace' THEN
				SELECT node_id INTO v_feature_id FROM v_edit_node LIMIT 1;
				-- replace 'node_id' for id of the feature calling arc divide function
				select replace(concat(rec_fct.function_name,'($$',rec_fct.sample_query::json ->>v_project_type,'$$)')::TEXT,'node_id'::text,v_feature_id::text) 
				INTO v_function; 
												

				IF v_function IS NOT NULL THEN
					v_query = 'SELECT '||v_schemaname||'.'||v_function||';';
					EXECUTE v_query
					INTO v_query_result;

					INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, error_message) 
					VALUES (115, rec_fct.function_name,rec_role.id,v_query_result);
				END IF;
			ELSE
				--concatenate fct with json input parameter
				select concat(rec_fct.function_name,'($$',rec_fct.sample_query::json ->>v_project_type,'$$)')::TEXT INTO v_function; 

				IF v_function IS NOT NULL THEN
					v_query = 'SELECT '||v_schemaname||'.'||v_function||';';
					EXECUTE v_query
					INTO v_query_result;
				END IF;
			
				INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, error_message) 
				VALUES (115, rec_fct.function_name,rec_role.id,v_query_result);
				
			END IF;

		END LOOP;
		
	END LOOP;

--set back role admin and grant basic permissions for role_basic
SET ROLE role_admin;
GRANT SELECT ON TABLE node_type TO role_basic;
GRANT SELECT ON TABLE audit_check_data TO role_basic;

--  Return
  	SELECT jsonb_build_object(
	'function_result', json_agg(row)
  	) AS feature INTO v_result
  	FROM (SELECT result_id, table_id, criticity,error_message::json
  	FROM  audit_check_data WHERE  fprocesscat_id=115) row;


	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');
	
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Test fct done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
		       '}}'||
	    '}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
