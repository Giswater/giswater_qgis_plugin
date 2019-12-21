/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2464

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_audit_check_project(INTEGER);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_check_project(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_audit_check_project($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "version":"3.3.019", "fprocesscat_id":1}}$$);
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
v_version text;
v_srid integer;
v_result_layers_criticity3 json;
v_result_layers_criticity2 json;
v_return json;
v_missing_layers json;
v_schema text;
v_layer_list text;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result json;
v_result_info json;
v_fprocesscat_id_aux integer;
v_qgis_version text;
v_qmlpointpath	text = '';
v_qmllinepath	text = '';
v_qmlpolpath	text = '';
v_user_control boolean = false;


BEGIN 


	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schema = 'SCHEMA_NAME';

	SELECT wsoftware, giswater, epsg INTO v_project_type, v_version, v_srid FROM version order by id desc limit 1;
	
	-- Get input parameters
	v_fprocesscat_id_aux := (p_data ->> 'data')::json->> 'fprocesscat_id';
	v_qgis_version := (p_data ->> 'data')::json->> 'version';

	-- get user parameters
	SELECT value INTO v_qmlpointpath FROM config_param_user WHERE parameter='qgis_qml_pointlayer_path' AND cur_user=current_user;
	SELECT value INTO v_qmllinepath FROM config_param_user WHERE parameter='qgis_qml_linelayer_path' AND cur_user=current_user;
	SELECT value INTO v_qmlpolpath FROM config_param_user WHERE parameter='qgis_qml_pollayer_path' AND cur_user=current_user;
	SELECT value INTO v_user_control FROM config_param_user where parameter='audit_project_user_control' AND cur_user=current_user;

	-- init process
	v_isenabled:=FALSE;
	v_count=0;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id=101 AND user_name=current_user;
	DELETE FROM audit_check_data WHERE fprocesscat_id IN (14,15,25,95) AND user_name=current_user;

	
	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 4, 'AUDIT CHECK PROJECT');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 1, '-------');

	IF v_user_control is true and 'role_epa' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) then
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 0, 'NETWORK ANALYTICS');
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, null, 0, '-------');
	END IF;

	IF v_qgis_version = v_version THEN
		v_errortext=concat('INFO: Giswater version: ',v_version,'.');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (101, 1, v_errortext);
	ELSE
		v_errortext=concat('ERROR: Version of plugin is different than the database version. DB: ',v_version,', plugin: ',v_qgis_version,'.');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (101, 3, v_errortext);
	END IF;

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

			v_errortext=concat('INFO: Set value in config param user: ',rec_table.id,'.');

			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, v_errortext);
		END IF;
	END LOOP;

	--If user has activated full project control, depending on user role - execute corresponding check function
	IF v_user_control THEN
		
		IF'role_om' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
			EXECUTE 'SELECT gw_fct_om_check_data($${
			"client":{"device":3, "infoType":100, "lang":"ES"},
			"feature":{},"data":{"parameters":{"selectionMode":"wholeSystem"}}}$$)';
			-- insert results 
			INSERT INTO audit_check_data  (fprocesscat_id, criticity, error_message) 
			SELECT 101, criticity, replace(error_message,':', ' (DB OM):') FROM audit_check_data 
			WHERE fprocesscat_id=25 AND criticity < 4 AND error_message !='' AND user_name=current_user OFFSET 6 ;

		END IF;

		IF 'role_epa' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
			EXECUTE 'SELECT gw_fct_pg2epa_check_data($${
			"client":{"device":3, "infoType":100, "lang":"ES"},
			"feature":{},"data":{"parameters":{"resultId":"gw_check_project","saveOnDatabase":true, 
			"useNetworkGeom":"FALSE", "useNetworkDemand":"FALSE"}}}$$)';
			-- insert results 
			INSERT INTO audit_check_data  (fprocesscat_id, criticity, error_message) 
			SELECT 101, criticity, replace(error_message,':', ' (DB EPA):') FROM audit_check_data 
			WHERE fprocesscat_id=14 AND criticity < 4 AND error_message !='' AND result_id ='gw_check_project' OFFSET 8;

		END IF;

		IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
			EXECUTE 'SELECT gw_fct_plan_check_data($${
			"client":{"device":3, "infoType":100, "lang":"ES"},
			"feature":{},
			"data":{"parameters":{"resultId":"gw_check_project"},"saveOnDatabase":true}}$$)';
			-- insert results 
			INSERT INTO audit_check_data  (fprocesscat_id, criticity, error_message) 
			SELECT 101, criticity, replace(error_message,':', ' (DB PLAN):') FROM audit_check_data 
			WHERE fprocesscat_id=15 AND criticity < 4 AND error_message !=''  AND result_id ='gw_check_project' OFFSET 6;
			
		END IF;

		IF 'role_admin' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) THEN
			EXECUTE 'SELECT gw_fct_admin_check_data($${"client":
			{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{}, 
			"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}$$)::text';
			-- insert results 
			INSERT INTO audit_check_data  (fprocesscat_id, criticity, error_message) 
			SELECT 101, criticity, replace(error_message,':', ' (DB ADMIN):') FROM audit_check_data 
			WHERE fprocesscat_id=95 AND criticity < 4 AND error_message !='' AND user_name=current_user OFFSET 6;
			
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
		SELECT count(*), string_agg(table_id,',') INTO v_count, v_layer_list 
		FROM audit_check_project WHERE table_host != v_table_host AND user_name=current_user;
		
		IF v_count>0 THEN
			v_errortext = concat('ERROR( QGIS PROJ): There is/are ',v_count,' layers that come from differen host: ',v_layer_list,'.');
		
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 3,v_errortext );
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, 'INFO (QGIS PROJ): All layers come from current host');
		END IF;
		
		--check layers database
		SELECT count(*), string_agg(table_id,',') INTO v_count, v_layer_list 
		FROM audit_check_project WHERE table_dbname != v_table_dbname AND user_name=current_user;
		
		IF v_count>0 THEN
			v_errortext = concat('ERROR (QGIS PROJ): There is/are ',v_count,' layers that come from different database: ',v_layer_list,'.');
		
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 3,v_errortext );
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, 'INFO (QGIS PROJ): All layers come from current database');
		END IF;

		--check layers database
		SELECT count(*), string_agg(table_id,',') INTO v_count, v_layer_list 
		FROM audit_check_project WHERE table_schema != v_table_schema AND user_name=current_user;
		
		IF v_count>0 THEN
			v_errortext = concat('ERROR (QGIS PROJ): There is/are ',v_count,' layers that come from different schema: ',v_layer_list,'.');
		
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 3,v_errortext );
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, 'INFO (QGIS PROJ): All layers come from current schema');
		END IF;

		--check layers user
		SELECT count(*), string_agg(table_id,',') INTO v_count, v_layer_list 
		FROM audit_check_project WHERE user_name != table_user AND table_user != 'None' AND user_name=current_user;
		
		IF v_count>0 THEN
			v_errortext = concat('ERROR (QGIS PROJ): There is/are ',v_count,' layers that have been added by different user: ',v_layer_list,'.');
		
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 3,v_errortext );
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
			VALUES (101, 1, 'INFO (QGIS PROJ): All layers have been added by current user');
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
		''3'' as criticity, qgis_message
		FROM '||v_schema||'.audit_check_project JOIN information_schema.columns ON table_name = table_id 
		AND columns.table_schema = '''||v_schema||''' and ordinal_position=1 
		LEFT JOIN '||v_schema||'.audit_cat_table ON audit_cat_table.id=audit_check_project.table_id
		WHERE criticity=3 and enabled IS NOT TRUE) a'
		INTO v_result_layers_criticity3;

		EXECUTE 'SELECT json_agg(row_to_json(a)) FROM (SELECT table_id as layer,column_name as id,'''||v_srid||''' as srid,
		''2'' as criticity, qgis_message
		FROM '||v_schema||'.audit_check_project JOIN information_schema.columns ON table_name = table_id 
		AND columns.table_schema = '''||v_schema||''' and ordinal_position=1 
		LEFT JOIN '||v_schema||'.audit_cat_table ON audit_cat_table.id=audit_check_project.table_id
		WHERE criticity=2 and enabled IS NOT TRUE) a'
		INTO v_result_layers_criticity2;

		v_result_layers_criticity3 := COALESCE(v_result_layers_criticity3, '{}'); 
		v_result_layers_criticity2 := COALESCE(v_result_layers_criticity2, '{}'); 

		v_missing_layers = v_result_layers_criticity3::jsonb||v_result_layers_criticity2::jsonb;


	END IF;


	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, v_result_id, 4, NULL);	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, v_result_id, 3, NULL);	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, v_result_id, 2, NULL);	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (101, v_result_id, 1, NULL);


	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=101 order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (
	SELECT id, node_id, nodecat_id, state, expl_id, descript, fprocesscat_id, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id IN (7,14,64,66,70,71,98) -- epa
	UNION
	SELECT id, node_id, nodecat_id, state, expl_id, descript, fprocesscat_id, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id IN (4,76,79,80,81,82,87,96,97,102,103)  -- om
	UNION
	SELECT id, connec_id, connecat_id, state, expl_id, descript,fprocesscat_id, the_geom FROM anl_connec WHERE cur_user="current_user"() AND fprocesscat_id IN (101,102,104,105,106) -- om
	) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "qmlPath":"',v_qmlpointpath,'", "values":',v_result, ',"category_field":"descript"}');

	--lines
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (
	SELECT id, arc_id, arccat_id, state, expl_id, descript, fprocesscat_id, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id IN (3, 14, 39)  -- epa
	UNION
	SELECT id, arc_id, arccat_id, state, expl_id, descript, fprocesscat_id, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id IN (4, 88, 102) -- om 
	) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "qmlPath":"',v_qmllinepath,'", "values":',v_result, ',"category_field":"descript"}');


	--    Control null
	v_version:=COALESCE(v_version,'{}');
	v_result_info:=COALESCE(v_result_info,'{}');
	v_result_point:=COALESCE(v_result_point,'{}');
	v_result_line:=COALESCE(v_result_line,'{}');
	v_result_polygon:=COALESCE(v_result_polygon,'{}');
	v_missing_layers:=COALESCE(v_missing_layers,'{}');


	--return definition for v_audit_check_result
	v_return= ('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		     ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"point":'||v_result_point||','||
					'"line":'||v_result_line||','||
					'"polygon":'||v_result_polygon||','||
					'"missingLayers":'||v_missing_layers||'}'||
			      '}}')::json;
	--  Return	   
	RETURN v_return;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


