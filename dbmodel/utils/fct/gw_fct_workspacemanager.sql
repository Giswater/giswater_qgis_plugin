/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3078

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_workspacemanager(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_workspacemanager(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
--create new workspace
SELECT SCHEMA_NAME.gw_fct_workspacemanager($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
"feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"CREATE", "name":"WS2", "descript":"test" }}$$);

--set workspace as current
SELECT SCHEMA_NAME.gw_fct_workspacemanager($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
"feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"CURRENT", "id":"9"}}$$);

--reset workspace, set previous settings
SELECT SCHEMA_NAME.gw_fct_workspacemanager($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
"feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"RESET"}}$$);

--delete selected workspace
SELECT SCHEMA_NAME.gw_fct_workspacemanager($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
"feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"DELETE", "id":"1"}}$$);
*/

DECLARE 

v_schemaname text = 'SCHEMA_NAME';
v_project_type text;

v_action text;
v_workspace_id integer;
v_workspace_name text;
v_workspace_config json;
v_selectors_config json;
v_selectors_configcompound json;
v_inp_json_config json;
v_workspace_descript text;
rec_sector json;
v_config_values json;
v_selector_name text;
v_sector_value json;
rec_inp text;
rec_selectorcomp text;
rec_selectorcolumn record;

v_return_status text = 'Failed';
v_return_msg text = 'Process finished with some errors';
v_error_context text;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get project type
	v_project_type = (SELECT project_type FROM sys_version LIMIT 1);

	-- get parameters
	v_action = json_extract_path_text(p_data,'data','action');
	v_workspace_id = json_extract_path_text(p_data,'data','id');
	v_workspace_name = json_extract_path_text(p_data,'data','name');
	v_workspace_descript = json_extract_path_text(p_data,'data','descript');

	IF v_action = 'CREATE' AND v_workspace_name IN (SELECT name FROM cat_workspace) THEN
		v_return_status = 'Failed';
		v_return_msg = 'Name already exists, please set a new one or delete existing workspace';
	END IF;
	
	IF v_action = 'CREATE' OR v_action = 'CURRENT' THEN
		--create configuration json for creating new workspace or saving the current settings as temporal in order to beeing able to reset them

		SELECT jsonb_build_object('inp',i.inp_conf) INTO v_workspace_config FROM
		(SELECT json_object_agg(parameter, value) as inp_conf
		FROM config_param_user WHERE 
		(parameter ilike 'inp_options%' OR parameter ilike 'inp_report%') AND 
		parameter NOT IN ('inp_options_buildup_supply', 'inp_options_advancedsettings','inp_options_debug','inp_options_vdefault') 
		AND cur_user=current_user) i;
		
		SELECT json_object_agg(parameter, value::JSON) as inp_conf INTO v_inp_json_config
		FROM config_param_user where parameter IN ('inp_options_buildup_supply', 'inp_options_advancedsettings','inp_options_debug','inp_options_vdefault') 
		AND cur_user=current_user;
		
		v_workspace_config = gw_fct_json_object_set_key(v_workspace_config,'inp_json', v_inp_json_config);
		
		SELECT json_agg(s.selector_conf) INTO v_selectors_config FROM (
		select jsonb_build_object('selector_expl', array_agg(expl_id))  as selector_conf
		FROM selector_expl where cur_user=current_user 
		UNION
		select jsonb_build_object('selector_sector', array_agg(sector_id)) as selector_conf 
		FROM selector_sector where cur_user=current_user 
		UNION
		select jsonb_build_object('selector_psector', array_agg(psector_id)) as selector_conf 
		FROM selector_psector where cur_user=current_user 
		UNION
		select jsonb_build_object('selector_inp_dscenario', array_agg(dscenario_id)) as selector_conf 
		FROM selector_inp_dscenario where cur_user=current_user
		UNION
		select jsonb_build_object('selector_rpt_main', array_agg(result_id)) as selector_conf 
		FROM selector_rpt_main where cur_user=current_user
		UNION
		select jsonb_build_object('selector_rpt_compare', array_agg(result_id)) as selector_conf 
		FROM selector_rpt_compare where cur_user=current_user
		UNION
		select jsonb_build_object('selector_state', array_agg(state_id)) as selector_conf 
		FROM selector_state where cur_user=current_user)s;
			
		
		IF v_project_type = 'WS' THEN
			SELECT json_agg(s.selector_conf) INTO v_selectors_configcompound FROM (
				select jsonb_build_object('selector_rpt_main_tstep_resultdate',array_agg(timestep)) as selector_conf 
				FROM selector_rpt_main_tstep where cur_user=current_user
				UNION
				select jsonb_build_object('selector_rpt_compare_tstep_resultdate',array_agg(timestep)) as selector_conf 
				FROM selector_rpt_compare_tstep where cur_user=current_user
				UNION
				select jsonb_build_object('selector_date', json_agg(selector_conf::json)) FROM (
				select json_build_object('selector_date_from_date', from_date, 'selector_date_to_date', to_date,'selector_date_context', context)::text as selector_conf 
				FROM selector_date where cur_user=current_user)a)s;
		ELSIF v_project_type = 'UD' THEN
			SELECT json_agg(s.selector_conf) INTO v_selectors_configcompound  FROM (
				select jsonb_build_object('selector_rpt_main_tstep', json_agg(a.selector_value::json))as selector_conf FROM (
				select json_build_object('resultdate', resultdate, 'resulttime', resulttime)::text as selector_value 
				FROM selector_rpt_main_tstep where cur_user=current_user)a
				UNION
				select jsonb_build_object('selector_rpt_compare_tstep', json_agg(a.selector_value::json))as selector_conf FROM (
				select json_build_object('resultdate', resultdate, 'resulttime', resulttime)::text as selector_value 
				FROM selector_rpt_compare_tstep where cur_user=current_user)a
				UNION
				select jsonb_build_object('selector_date', json_agg(a.selector_value::json)) as selector_conf FROM (
				select json_build_object('from_date', from_date, 'to_date', to_date,'context', context)::text as selector_value
				FROM selector_date where cur_user=current_user)a )s;
		END IF;
		raise notice 'v_selectors_config,%',v_selectors_config;

raise notice 'v_selectors_configcompound,%',v_selectors_configcompound;

		v_selectors_config = v_selectors_config::jsonb||v_selectors_configcompound::jsonb;
		v_workspace_config = gw_fct_json_object_set_key(v_workspace_config,'selectors', v_selectors_config);

		RAISE NOTICE 'v_workspace_config,%',v_workspace_config;

	END IF;


	IF v_action = 'DELETE' THEN

		DELETE FROM cat_workspace WHERE id=v_workspace_id;
		
		v_return_status = 'Accepted';
		v_return_msg = 'Workspace successfully deleted';
		
		
	ELSIF v_action = 'CREATE' THEN

		INSERT INTO cat_workspace (name, descript, config)
		VALUES (v_workspace_name, v_workspace_descript, v_workspace_config);

		v_return_status = 'Accepted';
		v_return_msg = 'Workspace successfully created';
		
	ELSIF v_action = 'CURRENT' THEN
		
		--save current settings in a temporal workspace in order the set it back as they were
		INSERT INTO cat_workspace (name, config, isautomatic)
		VALUES (concat('temp_',current_user), v_workspace_config, TRUE)
		ON CONFLICT (name) DO NOTHING;

		--capture config of selected workspace
		SELECT config INTO v_workspace_config FROM cat_workspace WHERE id=v_workspace_id;

		v_config_values = json_extract_path_text(v_workspace_config,'selectors');
		
		
	ELSIF v_action = 'RESET' THEN
	
		--capture previously set settings
		SELECT config INTO v_workspace_config FROM cat_workspace WHERE name=concat('temp_',current_user);

		v_config_values = json_extract_path_text(v_workspace_config,'selectors');

		DELETE FROM cat_workspace WHERE name=concat('temp_',current_user);
		
	END IF;

	IF v_action = 'RESET' OR v_action = 'CURRENT' THEN
		--set selector values
		FOR rec_sector IN SELECT * FROM json_array_elements(v_config_values) LOOP

			v_selector_name = json_object_keys(rec_sector);
			--remove values for selector
			EXECUTE 'DELETE FROM '||v_selector_name||' WHERE cur_user = current_user;';
			RAISE NOTICE 'rec_sector,%',rec_sector;
			v_sector_value = json_extract_path_text(rec_sector,v_selector_name);
			
			IF  v_project_type = 'UD' AND v_selector_name IN ('selector_rpt_compare_tstep', 'selector_rpt_main_tstep', 'selector_date')
			OR v_project_type = 'WS' AND v_selector_name IN ('selector_date') THEN
				RAISE NOTICE 'v_sector_value,%',v_sector_value;
				FOR rec_selectorcomp IN SELECT * FROM json_array_elements(v_sector_value) LOOP
				RAISE NOTICE 'rec_selectorcomp,%',rec_selectorcomp;
					SELECT string_agg(key,', ') as keys,  string_agg(quote_literal(value),', ') as values  INTO rec_selectorcolumn FROM (
					SELECT * from json_each_text(rec_selectorcomp::JSON))a;
					
					RAISE NOTICE 'rec_selectorcolumn,%',rec_selectorcolumn.keys;
					
					EXECUTE 'INSERT INTO '||v_selector_name||' ('||rec_selectorcolumn.keys||') 
					VALUES ('||rec_selectorcolumn.values||' );';
			
				END LOOP;
			ELSE 
				--SELECT * FROM json_object_keys('{"selector_rpt_compare_tstep_resultdate": "2020-12-2", "selector_rpt_compare_tstep_resulttime": "12:00"}')
				IF v_sector_value IS NOT NULL THEN
					EXECUTE 'INSERT INTO '||v_selector_name||'
					SELECT value::integer, current_user FROM json_array_elements_text('''||v_sector_value||''')';
				END IF;

			END IF;
			
		END LOOP;

		FOR rec_inp IN SELECT 'inp' UNION SELECT 'inp_json' LOOP
			v_config_values = json_extract_path_text(v_workspace_config,rec_inp);

			UPDATE config_param_user SET value = a.value,  cur_user = current_user 
			FROM  (SELECT key, value from json_each_text(v_config_values))a
			WHERE parameter=a.key;
			
			INSERT INTO config_param_user (parameter, value, cur_user) 
			SELECT key, valor, current_user FROM 
			(SELECT key, value as valor from json_each_text(v_config_values)) a
			ON CONFLICT DO NOTHING;
		END LOOP;

		v_return_status = 'Accepted';
		v_return_msg = 'Workspace successfully changed';

	END IF;
	
	--  Return
	RETURN ('{"status":"'||v_return_status||'", "message":{"level":0, "text":"'||v_return_msg||'"} '||
		',"body":{"form":{}'||
		',"data":{}}'||
		'}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
