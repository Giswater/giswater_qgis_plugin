CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setcheckproject_cm(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT SCHEMA_NAME.gw_fct_setcheckproject($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
"version":"3.5.021.1", "fid":101, "initProject":false, "addSchema":"NULL", "mainSchema":"NULL", "projecRole":"role_admin", "infoType":"full", "logFolderVolume":"139.56 MB",
"projectType":"ws", "qgisVersion":"3.16.6-Hannover", "osVersion":"Windows 10"}}$$);
-- fid: main: 101
*/

DECLARE

v_querytext text;
v_count integer = 0;
v_table_host text;
v_table_dbname text;
v_table_schema text;
v_project_type text;
v_errortext text;
v_version text;
v_epsg integer;
v_return json;
v_missing_layers json;
v_schemaname text;
v_layer_list text;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result json;
v_result_info json;
v_qgis_version text;
v_error_context text;
v_init_project boolean;
v_qgisversion text;
v_osversion text;
v_qgis_init_guide_map boolean;
v_qgis_layers_setpropierties boolean;
v_addschema text;
v_fid integer;
v_mainschema text;
v_projectrole text;
v_infotype text;
v_insert_fields json;
v_field json;
v_qgis_project_type text;
v_logfoldervolume text;
v_uservalues json;
v_show_versions boolean=True;
v_show_qgis_project boolean=True;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;

	-- Get input parameters
	v_fid := (p_data ->> 'data')::json->> 'fid';
	v_qgis_version := (p_data ->> 'data')::json->> 'version';
	v_init_project := (p_data ->> 'data')::json->> 'initProject';
	v_qgisversion := (p_data ->> 'data')::json->> 'qgisVersion';
	v_osversion := (p_data ->> 'data')::json->> 'osVersion';
	v_addschema := (p_data ->> 'data')::json->> 'addSchema';
	v_mainschema := (p_data ->> 'data')::json->> 'mainSchema';
	v_projectrole := (p_data ->> 'data')::json->> 'projectRole';
	v_infotype := (p_data ->> 'data')::json->> 'infoType';
	v_insert_fields := (p_data ->> 'data')::json->> 'fields';
	v_qgis_project_type := (p_data ->> 'data')::json->> 'projectType';
	v_logfoldervolume := (p_data ->> 'data')::json->> 'logFolderVolume';
	v_show_versions :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'showVersions';
	v_show_qgis_project :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'showQgisProject';

	-- profilactic control of qgis variables
	IF lower(v_mainschema) = 'none' OR v_mainschema = '' OR lower(v_mainschema) ='null' THEN v_mainschema = null; END IF;
	IF lower(v_projectrole) = 'none' OR v_projectrole = '' OR lower(v_projectrole) ='null' THEN v_projectrole = null; END IF;
	IF lower(v_infotype) = 'none' OR v_infotype = '' OR lower(v_infotype) ='null' THEN v_infotype = null; END IF;
	IF lower(v_qgis_project_type) = 'none' OR v_qgis_project_type = '' OR lower(v_qgis_project_type) ='null' THEN v_qgis_project_type = null; END IF;

	-- profilactic control of schema name
	IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null' OR v_addschema is null THEN
		 v_addschema = null;
	ELSE
		IF (select schemaname from pg_tables WHERE schemaname = v_addschema LIMIT 1) IS NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3132", "function":"2580","parameters":null, "is_process":true}}$$)';
		END IF;
	END IF;

	-- get user parameters
	SELECT value INTO v_qgis_init_guide_map FROM config_param_user where parameter='qgis_init_guide_map' AND cur_user=current_user;
	SELECT value INTO v_qgis_layers_setpropierties FROM config_param_user where parameter='qgis_layers_set_propierties' AND cur_user=current_user;
	IF v_qgis_init_guide_map IS NULL THEN v_qgis_init_guide_map = FALSE; END IF;
	IF v_qgis_layers_setpropierties IS NULL THEN v_qgis_layers_setpropierties = TRUE; END IF;

	-- create temp tables
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"CHECKPROJECT"}}}$$)';

	IF v_show_versions THEN
		--check plugin and db version and other system parameters
		IF v_qgis_version = v_version THEN
			v_errortext=concat('Giswater version: ',v_version,'.');
			INSERT INTO t_audit_check_data (fid,  criticity, error_message,fcount)
			VALUES (101, 4, v_errortext,0);
		ELSE
			v_errortext=concat('ERROR-349: Version of plugin is different than the database version. DB: ',v_version,', plugin: ',v_qgis_version,'.');
			INSERT INTO t_audit_check_data (fid,  criticity, result_id, error_message, fcount)
			VALUES (101, 3, '349',v_errortext, 1);
		END IF;

		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, concat ('PostgreSQL version: ',(SELECT version())));
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, concat ('PostGIS version: ',(SELECT postgis_version())));
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, concat ('QGIS version: ', v_qgisversion));
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, concat ('O/S version: ', v_osversion));
	END IF;

	IF v_show_qgis_project THEN
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, concat ('Log volume (User folder): ', v_logfoldervolume));
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (101, 4, concat ('QGIS variables: gwProjectType:',quote_nullable(v_qgis_project_type),', gwInfoType:',
		quote_nullable(v_infotype),', gwProjectRole:', quote_nullable(v_projectrole),', gwMainSchema:',quote_nullable(v_mainschema),', gwAddSchema:',quote_nullable(v_addschema)));
		v_errortext=concat('Logged as ', current_user,' on ', now());
		INSERT INTO t_audit_check_data (fid,  criticity, error_message) VALUES (101, 4, v_errortext);
	END IF;

	-- check layers from project and insert on log table
	v_querytext=NULL;
	FOR v_field in SELECT * FROM json_array_elements(v_insert_fields) LOOP
		select into v_querytext concat(v_querytext, 'INSERT INTO t_audit_check_project (table_schema, table_id, table_dbname, table_host, fid, table_user) ') ;
		select into v_querytext concat(v_querytext, 'VALUES('||quote_literal((v_field->>'table_schema'))||', '||quote_literal((v_field->>'table_id'))||', '||quote_literal((v_field->>'table_dbname'))||',
		'||quote_literal((v_field->>'table_host'))||'') ;
		select into v_querytext concat(v_querytext, ', '||quote_literal((v_field->>'fid'))||', '||quote_literal((v_field->>'table_user'))||');') ;
	END LOOP;
	IF v_querytext IS NOT NULL THEN EXECUTE v_querytext; END IF;

	-- Force state selector in case of null values for addschema
	IF v_addschema IS NOT NULL THEN

		EXECUTE 'SET search_path = '||v_addschema||', public';
		IF (SELECT count(*) FROM selector_state WHERE cur_user=current_user) < 1 THEN
			INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
			v_errortext=concat('Set feature state = 1 for addschema and user');
			INSERT INTO t_audit_check_data (fid,  criticity, error_message) VALUES (101, 4, v_errortext);
		END IF;
		SET search_path = 'SCHEMA_NAME';
	END IF;

	-- set uservalues
	PERFORM gw_fct_setinitproject($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{}}$$);

	-- get uservalues (to show in return)
	PERFORM gw_fct_workspacemanager($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"CHECK"}}$$);
	UPDATE config_param_user SET value = NULL WHERE parameter = 'plan_psector_current';
	v_uservalues = (SELECT to_json(array_agg(row_to_json(a))) FROM (SELECT parameter, value FROM config_param_user WHERE parameter IN ('plan_psector_current', 'utils_workspace_vdefault')
	AND cur_user = current_user ORDER BY parameter)a);
	v_uservalues := COALESCE(v_uservalues, '{}');

	/*

	SPACE TO CREATE CHECKS


	*/

	-- Check if users have a team assigned
	SELECT count(*) INTO v_count
	FROM SCHEMA_NAMEcat_user
	WHERE team_id IS NULL;

	IF v_count > 0 THEN
		v_errortext = concat('ERROR-353 (CAMPAIGN): There are some users with no team assigned.');
		INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message)
		VALUES (101, 3, '353', v_errortext);
	ELSE
		INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message)
		VALUES (101, 1, '353', 'INFO (CAMPAIGN): All users have a team assigned');
	END IF;

	-- Check if teams have users assigned
	SELECT count(*) INTO v_count 
	FROM SCHEMA_NAMEcat_team ct
	WHERE NOT EXISTS (
		SELECT 1
		FROM SCHEMA_NAMEcat_user cu
		WHERE ct.team_id = cu.team_id
	);

	IF v_count > 0 THEN
		v_errortext = concat('ERROR-353 (CAMPAIGN): There are some teams with no users assigned.');
		INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message)
		VALUES (101, 3, '353', v_errortext);
	ELSE
		INSERT INTO t_audit_check_data (fid, criticity, result_id, error_message)
		VALUES (101, 1, '353', 'INFO (CAMPAIGN): All teams have users assigned');
	END IF;
	


	-- built return
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"line"}}}$$::json)' INTO v_result_line;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"polygon"}}}$$::json)' INTO v_result_polygon;

	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"CHECKPROJECT"}}}$$)';

	-- Control null
	v_uservalues:=COALESCE(v_uservalues,'{}');
	v_missing_layers:=COALESCE(v_missing_layers,'{}');
	v_qgis_layers_setpropierties:=COALESCE(v_qgis_layers_setpropierties,true);
	v_qgis_init_guide_map:=COALESCE(v_qgis_init_guide_map,true);

	--return definition for v_audit_check_result
	v_return= ('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'" '||
		',"body":{"form":{}'||
			',"data":{ "epsg":'||v_epsg||
					',"userValues":'||v_uservalues||
			    ',"info":'||v_result_info||','||
					'"point":'||v_result_point||','||
					'"line":'||v_result_line||','||
					'"polygon":'||v_result_polygon||','||
					'"missingLayers":'||v_missing_layers||'}'||
			', "variables":{"setQgisLayers":' || v_qgis_layers_setpropierties||', "useGuideMap":'||v_qgis_init_guide_map||'}}}')::json;

	--  Return
	RETURN v_return;

	--  Exception handling
	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	--RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE',
	--SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;

$function$
;
