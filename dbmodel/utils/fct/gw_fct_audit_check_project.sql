/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2464

--SELECT SCHEMA_NAME.gw_fct_audit_check_project();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_check_project(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT gw_fct_audit_check_project($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"3.3.019", "fprocesscat_id":1}}$$)::text;
*/

DECLARE 
v_querytext 	text;
v_sys_rows 	text;
v_parameter   text;
v_audit_rows 	integer;
v_compare_sign text;
v_isenabled 	boolean;
v_diference 	integer;
v_error integer;
v_count integer;
v_table_host text;
v_table_dbname text;
v_table_schema text;
v_query_string text;
v_max_seq_id int8;
v_project_type text;
v_psector_vdef text;
v_errortext text;
v_result_id text;
rec_table record;
v_om_check_result json;
v_plan_check_result json;
v_edit_check_result json;
v_admin_check_result json;
v_audit_result 		json;
v_audit_result_point		text;
v_audit_result_line 		json;
v_audit_result_polygon	json;
v_audit_result_info json;
v_version text;
v_srid integer;
v_result_layers_criticity3 json;
v_result_layers_criticity2 json;
v_missing_layers json;
v_schema text;
v_om_check_result_info json;
v_plan_check_result_info json;
v_admin_check_result_info json;
v_om_check_result_point json;
v_om_check_result_line json;
v_om_check_result_polygon json;
v_layer_list text;
v_epa_check_result json;
v_epa_check_result_info json;
v_epa_check_result_point json;
v_epa_check_result_line json;
v_epa_check_result_polygon json;
v_result_agg json;
v_audit_check_result json;
v_project_role_control boolean;
v_fprocesscat_id_aux integer;
v_qgis_version text;

BEGIN 


	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schema = 'SCHEMA_NAME';
	
	SELECT wsoftware, giswater, epsg INTO v_project_type, v_version, v_srid FROM version order by id desc limit 1;
	
	-- Get input parameters
	v_fprocesscat_id_aux := (p_data ->> 'data')::json->> 'fprocesscat_id';
	v_qgis_version := (p_data ->> 'data')::json->> 'version';
	
	SELECT value::boolean INTO v_project_role_control FROM config_param_user where parameter='project_role_control' and cur_user=current_user;
	v_project_role_control=true;
	-- init process
	v_isenabled:=FALSE;
	v_count=0;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=101 AND user_name=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 4, concat('AUDIT CHECK PROJECT'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 1, '-------');

	v_errortext=concat('INFO: Giswater version: ',v_version,'.');
	INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
	VALUES (101, 1, v_errortext);

	v_errortext=concat('INFO: Project type: ',v_project_type,'.');
	INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
	VALUES (101, 1, v_errortext);

	--REFRESH MATERIALIZED VIEW v_ui_workcat_polygon_aux;

	-- Force psector vdefault visible to current_user (only to => role_master)
	SELECT value INTO v_psector_vdef FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user=current_user;

	IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) and  v_psector_vdef is not null THEN
	  	IF (SELECT psector_id FROM plan_psector WHERE psector_id=(SELECT value FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user=current_user)::integer) IS NOT NULL THEN
			DELETE FROM selector_psector WHERE psector_id =(SELECT value FROM config_param_user 
			WHERE parameter='psector_vdefault' AND cur_user=current_user)::integer AND cur_user=current_user;
			INSERT INTO selector_psector (psector_id, cur_user) VALUES ((SELECT value FROM config_param_user 
			WHERE parameter='psector_vdefault' AND cur_user=current_user)::integer, current_user);

			v_errortext=concat('INFO: Psector ',v_psector_vdef,' set as default.');

			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, v_errortext);
		END IF;
	END IF;

	-- Reset urn sequence
	IF v_project_type='WS' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO v_max_seq_id;
	ELSIF v_project_type='UD' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(gully_id::int8) FROM gully WHERE gully_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO v_max_seq_id;
	END IF;	
	IF v_max_seq_id IS NOT null THEN
		EXECUTE 'SELECT setval(''SCHEMA_NAME.urn_id_seq'','||v_max_seq_id||', true)';

		v_errortext=concat('INFO: Reset urn id sequence.');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (101, 1, v_errortext);
	END IF;
	
	-- Special cases (doc_seq. inp_vertice_seq)
	SELECT max(id::integer) FROM doc WHERE id ~ '^\d+$' into v_max_seq_id;
	IF v_max_seq_id IS NOT null THEN
		EXECUTE 'SELECT setval(''SCHEMA_NAME.doc_seq'','||v_max_seq_id||', true)';

		v_errortext=concat('INFO: Reset doc id sequence.');

		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (101, 1, v_errortext);
	END IF;
	
	IF v_project_type='WS' THEN 
		PERFORM setval('SCHEMA_NAME.inp_vertice_id_seq', 1, true);
	ELSE 
		PERFORM setval('SCHEMA_NAME.inp_vertice_seq', 1, true);
	END IF;
	
	v_errortext=concat('INFO: Reset vertice id sequence.');
	INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
	VALUES (101, 1, v_errortext);

	--Reset the  rest of sequences
	FOR rec_table IN SELECT * FROM audit_cat_table WHERE sys_sequence IS NOT NULL AND sys_sequence_field IS NOT NULL AND sys_sequence!='urn_id_seq' AND sys_sequence!='doc_seq' AND isdeprecated IS NOT TRUE
	LOOP 
		v_query_string:= 'SELECT max('||rec_table.sys_sequence_field||') FROM '||rec_table.id||';' ;
		EXECUTE v_query_string INTO v_max_seq_id;	
		IF v_max_seq_id IS NOT NULL AND v_max_seq_id > 0 THEN 
			EXECUTE 'SELECT setval(''SCHEMA_NAME.'||rec_table.sys_sequence||' '','||v_max_seq_id||', true)';

			
		END IF;
	END LOOP;

	v_errortext=concat('INFO: Reset other sequences.');
	INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
	VALUES (101, 1, v_errortext);

	-- set mandatory values of config_param_user in case of not exists (for new users or for updates)
	FOR rec_table IN SELECT * FROM audit_cat_param_user WHERE ismandatory IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, 'member'))
	LOOP
		IF rec_table.id NOT IN (SELECT parameter FROM config_param_user WHERE cur_user=current_user) THEN
			INSERT INTO config_param_user (parameter, value, cur_user) 
			SELECT audit_cat_param_user.id, vdefault, current_user FROM audit_cat_param_user WHERE audit_cat_param_user.id = rec_table.id;	

			v_errortext=concat('INFO: Set value in config param user: ',rec_table.sys_sequence,'.');

			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, v_errortext);
		END IF;
	END LOOP;

	--If user has activated full project control, depending on user role - execute corresponding check function
	IF v_project_role_control THEN
	
		IF'role_om' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
			EXECUTE 'SELECT gw_fct_om_check_data($${
			"client":{"device":3, "infoType":100, "lang":"ES"},
			"feature":{},"data":{"parameters":{"selectionMode":"wholeSystem"}}}$$)'
			INTO v_om_check_result;
			v_om_check_result_info = ((((v_om_check_result->>'body')::json->>'data')::json->>'info')::json->>'values')::json;
			v_om_check_result_point = ((((v_om_check_result->>'body')::json->>'data')::json->>'point')::json->>'values')::json;
			v_om_check_result_line = (((v_om_check_result->>'body')::json->>'data')::json->>'line')::json;
			v_om_check_result_polygon = (((v_om_check_result->>'body')::json->>'data')::json->>'polygon')::json;

		END IF;

		IF 'role_epa' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
			EXECUTE 'SELECT gw_fct_pg2epa_check_data($${
			"client":{"device":3, "infoType":100, "lang":"ES"},
			"feature":{},"data":{"parameters":{"t1":"check_project","saveOnDatabase":true, 
			"useNetworkGeom":"TRUE", "useNetworkDemand":"TRUE"}}}$$)'
			INTO v_epa_check_result;
			v_epa_check_result_info = (((v_epa_check_result->>'body')::json->>'data')::json->>'info')::json;
			v_epa_check_result_point = ((((v_epa_check_result->>'body')::json->>'data')::json->>'point')::json->>'values')::json;
			v_epa_check_result_line = (((v_epa_check_result->>'body')::json->>'data')::json->>'line')::json;
			v_epa_check_result_polygon = (((v_epa_check_result->>'body')::json->>'data')::json->>'polygon')::json;

		END IF;

		IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
			EXECUTE 'SELECT gw_fct_plan_audit_check_data($${
			"client":{"device":3, "infoType":100, "lang":"ES"},
			"feature":{},
			"data":{"parameters":{"resultId":"check_project"},"saveOnDatabase":true}}$$)'
			INTO v_plan_check_result;
			v_plan_check_result_info = (((v_plan_check_result->>'body')::json->>'data')::json->>'info')::json;
			
		END IF;

		IF 'role_admin' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
			EXECUTE 'SELECT gw_fct_admin_check_data($${"client":
			{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, 
			"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}$$)::text'
			INTO v_admin_check_result;
			v_admin_check_result_info = ((((v_admin_check_result->>'body')::json->>'data')::json->>'info')::json->>'values')::json;
			
		END IF;
	END IF;

	-- force hydrometer_selector
	IF (select id FROM selector_hydrometer WHERE cur_user = current_user limit 1) IS NULL THEN
		INSERT INTO selector_hydrometer (state_id, cur_user) 
		SELECT id, current_user FROM ext_rtc_hydrometer_state ON CONFLICT (state_id, cur_user) DO NOTHING;
	END IF;

	-- check qgis project (1)
	IF v_fprocesscat_id_aux=1 THEN

		SELECT boot_val INTO v_table_host FROM pg_settings WHERE name='listen_addresses';
		SELECT current_database() INTO v_table_dbname;
		SELECT current_schema() INTO v_table_schema;
		
		--check layers host
		SELECT count(*), string_agg(table_id,',') INTO v_count, v_layer_list FROM audit_check_project WHERE table_host != v_table_host;
		
		IF v_count>0 THEN
			v_errortext = concat('ERROR: There is/are ',v_count,' layers that come from differen host: ',v_layer_list,'.');
		
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 3,v_errortext );
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, 'INFO: All layers come from current host');
		END IF;
		--check layers database
		SELECT count(*), string_agg(table_id,',') INTO v_count, v_layer_list FROM audit_check_project WHERE table_dbname != v_table_dbname;
		
		IF v_count>0 THEN
			v_errortext = concat('ERROR: There is/are ',v_count,' layers that come from different database: ',v_layer_list,'.');
		
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 3,v_errortext );
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, 'INFO: All layers come from current database');
		END IF;

		--check layers database
		SELECT count(*), string_agg(table_id,',') INTO v_count, v_layer_list FROM audit_check_project WHERE table_schema != v_table_schema;
		
		IF v_count>0 THEN
			v_errortext = concat('ERROR: There is/are ',v_count,' layers that come from different schema: ',v_layer_list,'.');
		
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 3,v_errortext );
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, 'INFO: All layers come from current schema');
		END IF;

		--check layers user
		SELECT count(*), string_agg(table_id,',') INTO v_count, v_layer_list FROM audit_check_project WHERE user_name != table_user;
		
		IF v_count>0 THEN
			v_errortext = concat('ERROR: There is/are ',v_count,' layers that have been added by different user: ',v_layer_list,'.');
		
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 3,v_errortext );
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, 'INFO: All layers have been added by current user');
		END IF;

		-- start process
		FOR rec_table IN SELECT * FROM audit_cat_table WHERE qgis_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member'))
		LOOP
		
			--RAISE NOTICE 'v_count % id % ', v_count, rec_table.id;
			IF rec_table.id NOT IN (SELECT table_id FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=v_fprocesscat_id_aux) THEN
				INSERT INTO audit_check_project (table_id, fprocesscat_id, criticity, enabled, message) VALUES (rec_table.id, 1, rec_table.qgis_criticity, FALSE, rec_table.qgis_message);
			--ELSE 
			--	UPDATE audit_check_project SET criticity=rec_table.qgis_criticity, enabled=TRUE WHERE table_id=rec_table.id;
			END IF;	
			v_count=v_count+1;
		END LOOP;
		
		--error 1 (criticity = 3 and false)
		SELECT count (*) INTO v_error FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=1 AND criticity=3 AND enabled=FALSE;

		--list missing layers with criticity 3 and 2

		EXECUTE 'SELECT json_agg(row_to_json(a)) FROM (SELECT table_id as layer,column_name as id,'''||v_srid||''' as srid,
		''3'' as criticity
		FROM '||v_schema||'.audit_check_project JOIN information_schema.columns ON table_name = table_id 
		AND columns.table_schema = '''||v_schema||''' and ordinal_position=1 WHERE criticity=3 and enabled IS NOT TRUE) a'
		INTO v_result_layers_criticity3;

		EXECUTE 'SELECT json_agg(row_to_json(a)) FROM (SELECT table_id as layer,column_name as id,'''||v_srid||''' as srid,
		''2'' as criticity 
		FROM '||v_schema||'.audit_check_project JOIN information_schema.columns ON table_name = table_id 
		AND columns.table_schema = '''||v_schema||''' and ordinal_position=1 WHERE criticity=2 and enabled IS NOT TRUE) a'
		INTO v_result_layers_criticity2;

		v_missing_layers = v_result_layers_criticity3::jsonb||v_result_layers_criticity2::jsonb;


	END IF;
/*
	-- Checking user value_default
	ELSIF v_fprocesscat_id_aux=19 THEN

	DELETE FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=v_fprocesscat_id_aux;

	FOR rec_table IN SELECT * FROM audit_cat_param_user WHERE dv_table IS NOT NULL AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member'))
	LOOP 
		RAISE NOTICE '%', rec_table;
		SELECT value INTO v_parameter FROM config_param_user WHERE parameter=rec_table.id AND cur_user=current_user;
		
		IF v_parameter IS NOT NULL THEN
				
			IF rec_table.dv_clause IS NOT NULL THEN
				EXECUTE rec_table.dv_clause||'''||v_parameter||''';
			ELSE 
				EXECUTE 'SELECT '||rec_table.dv_column||' FROM '||rec_table.dv_table|| ' WHERE '''||v_parameter||'''='||rec_table.dv_column INTO v_query_string;
			END IF;

			IF v_query_string IS NULL THEN

				INSERT INTO audit_check_project (table_id, fprocesscat_id, criticity, enabled, message) 
				VALUES (rec_table.id, 19, NULL, FALSE, rec_table.qgis_message);
				v_count=v_count+1;
			END IF;
			
		ELSE
			INSERT INTO audit_check_project (table_id, fprocesscat_id, criticity, enabled, message) 
			VALUES (rec_table.id, 19, NULL, FALSE, rec_table.qgis_message);
			v_count=v_count+1;
		END IF;
		
	END LOOP;

	RETURN v_count;


	-- Checking data consistency
	ELSIF v_fprocesscat_id_aux=2 THEN

	DELETE FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=v_fprocesscat_id_aux;


		-- start process
		FOR rec_table IN SELECT * FROM audit_cat_table WHERE sys_criticity>0
		LOOP	
			-- audit rows
			v_querytext:= 'SELECT count(*) FROM '||rec_table.id;
			EXECUTE v_querytext INTO v_audit_rows;
	
			-- system rows
			v_compare_sign= substring(rec_table.sys_rows from 1 for 1);
			v_sys_rows=substring(rec_table.sys_rows from 2 for 999);
			IF (v_sys_rows>='0' and v_sys_rows<'9999999') THEN
	
			ELSIF v_sys_rows like'@%' THEN 
				v_querytext=substring(rec_table.sys_rows from 3 for 999);
				IF v_querytext IS NULL THEN
					RETURN audit_function(2078,2464,(rec_table.id)::text);
				END IF;
				EXECUTE v_querytext INTO v_sys_rows;
			ELSE
				v_querytext='SELECT count(*) FROM '||v_sys_rows;
				IF v_querytext IS NULL THEN
					RETURN audit_function(2078,2464,(rec_table.id)::text);
				END IF;
				EXECUTE v_querytext INTO v_sys_rows;
			END IF;
	
			IF v_compare_sign='>'THEN 
				v_compare_sign='=>';
			END IF;
	
			v_diference=v_audit_rows-v_sys_rows::integer;
		
			-- compare audit rows & system rows
			IF v_compare_sign='=' THEN
					IF v_diference=0 THEN
					v_isenabled=TRUE;
				ELSE
					v_isenabled=FALSE;
				END IF;
					
			ELSIF v_compare_sign='=>' THEN
				IF v_diference >= 0 THEN
					v_isenabled=TRUE;
				ELSE	
					v_isenabled=FALSE;
				END IF;	
			END IF;

			
			INSERT INTO audit_check_project ( table_id, fprocesscat_id, criticity,enabled, message,user_name)
			VALUES (rec_table.id,  v_fprocesscat_id_aux, rec_table.sys_criticity, v_isenabled, 
			concat('Table needs ',v_compare_sign,' ',v_sys_rows,' rows and it has ',v_audit_rows,' rows'), (SELECT current_user));
		END LOOP;

		SELECT count(*) INTO v_error FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=2 AND enabled=FALSE;	

		RETURN v_error;
		
	END IF;
*/

-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_audit_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=101 order by criticity desc, id asc) row; 
	v_audit_result_info := COALESCE(v_audit_result, '{}'); 
	v_audit_result_info = concat ('{"geometryType":"", "values":',v_audit_result_info, '}');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, v_result_id, 4, NULL);	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, v_result_id, 3, NULL);	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, v_result_id, 2, NULL);	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, v_result_id, 1, NULL);

	--    Control null	
	v_audit_result_info:=COALESCE(v_audit_result_info,'{}');
	v_audit_result_point:=COALESCE(v_audit_result_point,'{}');
	v_audit_result_line:=COALESCE(v_audit_result_line,'{}');
	v_audit_result_polygon:=COALESCE(v_audit_result_polygon,'{}');
	v_missing_layers:=COALESCE(v_missing_layers,'{}');


	--return definition for v_audit_check_result
	v_audit_check_result= ('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		     ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_audit_result_info||','||
					'"point":'||v_audit_result_point||','||
					'"line":'||v_audit_result_line||','||
					'"polygon":'||v_audit_result_polygon||','||
					'"missingLayers":'||v_missing_layers||'}'||
			      '}}')::json;
	      
	IF v_project_role_control THEN
	--    Control null	
		v_om_check_result := COALESCE(v_om_check_result,'{}');
		v_epa_check_result := COALESCE(v_epa_check_result,'{}');
		v_plan_check_result := COALESCE(v_plan_check_result,'{}');
		v_admin_check_result:= COALESCE(v_admin_check_result,'{}');

		--concatenate returns from the executed functions
		v_result_agg = concat('[',v_audit_check_result,',',v_om_check_result::text,',',v_epa_check_result::text,',',
		v_plan_check_result::text,',',v_admin_check_result::text,']');

	ELSE
		v_result_agg = v_audit_check_result;
	END IF;
--  Return
    	   
	RETURN v_result_agg;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



--que nestor muestre la info si hay missingLayers o si hay algo de ERRORS
--en missing layer mostar el context en funcion del role de usuario (que no le va a funcionar sin la capa)