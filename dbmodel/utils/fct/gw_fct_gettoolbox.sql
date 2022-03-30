/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2770

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_gettoolbox(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_gettoolbox(p_data json)
  RETURNS json AS
$BODY$
	
/*EXAMPLE:
SELECT SCHEMA_NAME.gw_fct_gettoolbox($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"isToolbox":false, "function":2522, "filterText":"Import inp epanet file"}}$$)

SELECT SCHEMA_NAME.gw_fct_gettoolbox($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"filterText":"Import inp epanet file"}}$$)

SELECT SCHEMA_NAME.gw_fct_gettoolbox($${"client":{"device":4, "lang":"CA", "infoType":1, "epsg":25831}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "isToolbox":true}}$$);


*/

DECLARE

v_version text;
v_role text;
v_projectype text;
v_filter text;
v_om_fields json;
v_edit_fields json;
v_epa_fields json;
v_master_fields json;
v_admin_fields json;
v_isepa boolean = false;
v_epa_user text;
rec record;
v_querytext text;
v_querytext_mod text;
v_queryresult text;
v_expl text;
v_state text;
v_inp_result text; 
v_rpt_result text;
v_return json;
v_return2 text;
v_nodetype text;
v_nodecat text;
v_function integer;
v_arrayresult text[];
v_selectedid text;
v_rec_replace json;
v_errcontext text;
v_querystring text;
v_debug_vars json;
v_debug json;
v_msgerr json;
v_value text;
v_reports json;
v_reports_basic json;
v_reports_edit json;
v_reports_epa json;
v_reports_master json;
v_reports_admin json;
v_inp_hydrology text;
v_inp_dwf text;
v_inp_dscenario text;
v_sector text;
v_process json;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
  
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	-- get input parameter
	v_filter := (p_data ->> 'data')::json->> 'filterText';
	v_function := (p_data ->> 'data')::json->> 'function';

	-- get project type
	SELECT lower(project_type) INTO v_projectype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- convert v_function to alias
	IF v_function IS NOT NULL THEN
		SELECT alias FROM config_toolbox WHERE id = v_function INTO v_filter;
	END IF;

	v_filter := COALESCE(v_filter, '');

	-- get epa results
	IF (SELECT result_id FROM rpt_cat_result LIMIT 1) IS NOT NULL THEN
		v_isepa = true;
		v_epa_user = (SELECT result_id FROM rpt_cat_result WHERE cur_user=current_user LIMIT 1);
		IF v_epa_user IS NULL THEN
			v_epa_user = (SELECT result_id FROM rpt_cat_result LIMIT 1);
		END IF;
	END IF;

	-- get variables
	v_expl  = (SELECT expl_id FROM selector_expl WHERE cur_user = current_user limit 1);
	v_state  = (SELECT expl_id FROM selector_expl WHERE cur_user = current_user limit 1);
	v_inp_result = (SELECT result_id FROM selector_inp_result WHERE cur_user = current_user limit 1);
	v_rpt_result = (SELECT result_id FROM selector_rpt_main WHERE cur_user = current_user limit 1);
	v_inp_hydrology = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_hydrology_scenario' AND cur_user = current_user limit 1);
	v_inp_dwf = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_dwfscenario' AND cur_user = current_user limit 1);
	v_inp_dscenario = (SELECT dscenario_id FROM selector_inp_dscenario WHERE cur_user = current_user limit 1);
	v_sector = (SELECT sector_id FROM selector_sector WHERE cur_user = current_user AND sector_id > 0 limit 1 );


	IF v_projectype = 'ws' THEN
		v_nodetype = (SELECT nodetype_id FROM cat_node JOIN config_param_user ON cat_node.id = config_param_user.value
		WHERE cur_user = current_user AND parameter = 'edit_nodecat_vdefault');
		IF v_nodetype IS NULL OR (SELECT id FROM cat_node WHERE nodetype_id = v_nodetype limit 1) IS NULL THEN
			v_nodetype = (SELECT ctn.id FROM cat_feature_node ctn JOIN cat_feature USING  (id)
			join cat_node cn ON cn.nodetype_id=ctn.id  WHERE cat_feature.active IS TRUE and cn.active IS TRUE limit 1);
		END IF;
	ELSE
		v_nodetype = (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter = 'edit_nodetype_vdefault');
		IF v_nodetype IS NULL OR (SELECT id FROM cat_node WHERE node_type = v_nodetype OR node_type IS NULL limit 1) IS NULL THEN
			v_nodetype = (SELECT id  FROM cat_feature_node JOIN cat_feature USING  (id) WHERE active IS TRUE limit 1);
		END IF;
	END IF;

	v_nodecat = (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter = 'edit_nodecat_vdefault');

	IF v_nodecat IS NULL THEN 
		IF v_projectype = 'ws' THEN
			v_nodecat = (SELECT id FROM cat_node WHERE active IS true AND nodetype_id = v_nodetype limit 1);
		ELSIF  v_projectype = 'ud' THEN
			v_nodecat = (SELECT id FROM cat_node WHERE active IS true AND node_type = v_nodetype limit 1);
		END IF;

		IF v_nodecat IS NULL and v_projectype = 'ud' THEN 
			v_nodecat = (SELECT id FROM cat_node WHERE active IS true limit 1);
		END IF;
		
	END IF;

	-- get om toolbox parameters
	v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
			 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname
			 FROM sys_function 
			 JOIN config_toolbox USING (id)
			 WHERE alias ILIKE ''%', v_filter ,'%'' AND sys_role =''role_om'' AND config_toolbox.active IS TRUE
			 AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
			 AND (project_type=',quote_literal(v_projectype),' or project_type=''utils'')) a');
	v_debug_vars := json_build_object('v_filter', v_filter, 'v_projectype', v_projectype);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_gettoolbox', 'flag', 10);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_om_fields;

	-- get edit toolbox parameters
	v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
			 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname
			 FROM sys_function
			 JOIN config_toolbox USING (id)
			 WHERE alias ILIKE ''%', v_filter ,'%'' AND sys_role =''role_edit'' AND config_toolbox.active IS TRUE
			 AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
			 AND ( project_type=',quote_literal(v_projectype),' or project_type=''utils'')) a');
	v_debug_vars := json_build_object('v_filter', v_filter, 'v_projectype', v_projectype);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_gettoolbox', 'flag', 20);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_edit_fields;

	-- get epa toolbox parameters
	v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
			 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname
			FROM sys_function
			JOIN config_toolbox USING (id)
			WHERE alias ILIKE ''%', v_filter ,'%'' AND sys_role =''role_epa'' AND config_toolbox.active IS TRUE
			AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
			AND ( project_type=',quote_literal(v_projectype),' or project_type=''utils'')) a');
	v_debug_vars := json_build_object('v_filter', v_filter, 'v_projectype', v_projectype);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_gettoolbox', 'flag', 30);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_epa_fields;
	
	-- get master toolbox parameters
	v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
			 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname
			 FROM sys_function
			 JOIN config_toolbox USING (id)
			 WHERE alias ILIKE ''%', v_filter ,'%'' AND sys_role =''role_master'' AND config_toolbox.active IS TRUE
			 AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
			 AND (project_type=',quote_literal(v_projectype),' OR project_type=''utils'')) a');
	v_debug_vars := json_build_object('v_filter', v_filter, 'v_projectype', v_projectype);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_gettoolbox', 'flag', 40);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_master_fields;

	-- get admin toolbox parameters
	v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
			 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, 
			 function_name as functionname
			 FROM sys_function
			 JOIN config_toolbox USING (id)
			 WHERE alias ILIKE ''%', v_filter ,'%'' AND sys_role =''role_admin'' AND config_toolbox.active IS TRUE
			 AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
			 AND (project_type=',quote_literal(v_projectype),' or project_type=''utils'')) a');
			 
	v_debug_vars := json_build_object('v_filter', v_filter, 'v_projectype', v_projectype);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_gettoolbox', 'flag', 50);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	EXECUTE v_querystring INTO v_admin_fields;

	IF v_function IS NULL THEN
		-- get reports toolbox parameters
		v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
				 SELECT id as listname, alias
				 FROM config_report
				 WHERE sys_role = ''role_basic'' 
				 AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
				 AND alias ILIKE ''%', v_filter ,'%'' ORDER BY id) a');
				
		EXECUTE v_querystring INTO v_reports_basic;

		v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
				 SELECT id as listname, alias
				 FROM config_report
				 WHERE sys_role = ''role_edit'' 
				 AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
				 AND alias ILIKE ''%', v_filter ,'%'' ORDER BY id) a');
				
		EXECUTE v_querystring INTO v_reports_edit;

		v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
				 SELECT id as listname, alias
				 FROM config_report
				 WHERE sys_role = ''role_epa'' 
				 AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
				 AND alias ILIKE ''%', v_filter ,'%'' ORDER BY id) a');
				
		EXECUTE v_querystring INTO v_reports_epa;

		v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
				 SELECT id as listname, alias
				 FROM config_report
				 WHERE sys_role = ''role_master'' 
				 AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
				 AND alias ILIKE ''%', v_filter ,'%'' ORDER BY id) a');
				
		EXECUTE v_querystring INTO v_reports_master;

		v_querystring = concat('SELECT array_to_json(array_agg(row_to_json(a))) FROM (
				 SELECT id as listname, alias
				 FROM config_report
				 WHERE sys_role = ''role_admin'' 
				 AND sys_role IN  (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))
				 AND alias ILIKE ''%', v_filter ,'%'' ORDER BY id) a');
				
		EXECUTE v_querystring INTO v_reports_admin;
	END IF;

	SELECT json_strip_nulls(json_build_object('basic', v_reports_basic, 
	'edit', v_reports_edit,
	'epa', v_reports_epa,
	'master', v_reports_master,
	'admin', v_reports_admin)) INTO v_reports;

	-- refactor dvquerytext			
	FOR rec IN SELECT json_array_elements(inputparams::json) as inputparams
	FROM sys_function JOIN config_toolbox USING (id) 
	WHERE alias = v_filter  AND config_toolbox.active IS TRUE AND (project_type=v_projectype OR project_type='utils')
	LOOP
		v_querytext = rec.inputparams::json->>'dvQueryText';

		v_value =  rec.inputparams::json->>'value';

		IF v_querytext IS NOT NULL THEN

			IF v_querytext ilike '%$userNodetype%' THEN
				v_querytext_mod = REPLACE (v_querytext::text, '$userNodetype', quote_literal(v_nodetype));
			ELSE 
				v_querytext_mod = v_querytext;
			END IF;
		
			v_selectedid = rec.inputparams::json->>'selectedId';

			v_querytext = concat('SELECT array_agg(id::text) FROM (',v_querytext_mod,')a');
			v_debug_vars := json_build_object('v_querytext_mod', v_querytext_mod);
			v_debug := json_build_object('querystring', v_querytext, 'vars', v_debug_vars, 'funcname', 'gw_fct_gettoolbox', 'flag', 60);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
	 
			EXECUTE v_querytext INTO v_arrayresult;
	
			IF (rec.inputparams::json->>'isNullValue')::boolean IS TRUE THEN
				v_arrayresult = array_prepend('',v_arrayresult);
			END IF;

			IF v_selectedid ~ '^[0-9]+$'THEN
				
				v_selectedid = concat('"selectedId":"',v_arrayresult[v_selectedid::integer],'"');

			ELSIF v_selectedid ilike '$user%' then

				IF v_selectedid = '$userExploitation' THEN
					v_selectedid = concat('"selectedId":"',v_expl,'"');
				ELSIF v_selectedid = '$userState' THEN
					v_selectedid = concat('"selectedId":"',v_state,'"');
				ELSIF v_selectedid = '$userSector' THEN
					v_selectedid = concat('"selectedId":"',v_sector,'"');
				ELSIF v_selectedid = '$userHydrology' THEN
					v_selectedid = concat('"selectedId":"',v_inp_hydrology,'"');
				ELSIF v_selectedid = '$userDwf' THEN
					v_selectedid = concat('"selectedId":"',v_inp_dwf,'"');
				ELSIF v_selectedid = '$userDscenario' THEN
					v_selectedid = concat('"selectedId":"',v_inp_dscenario,'"');
				ELSIF v_selectedid = '$userInpResult' THEN
					v_selectedid = concat('"selectedId":"',v_inp_result,'"');
				ELSIF v_selectedid = '$userRptResult' THEN
					v_selectedid = concat('"selectedId":"',v_rpt_result,'"');
				ELSIF v_selectedid = '$userNodetype' THEN
					v_selectedid = concat('"selectedId":"',v_nodetype,'"');
				ELSIF v_selectedid = '$userNodecat' THEN
					IF v_nodecat = any(v_arrayresult) THEN
						v_selectedid = concat('"selectedId":"',v_nodecat,'"');
					ELSE
						v_selectedid = concat('"selectedId":"',v_arrayresult[1],'"');
					END IF;
				END IF;
			END IF;

			IF v_selectedid IS NULL OR  v_selectedid = '' THEN v_selectedid = '"selectedId":""';END IF;

			EXECUTE v_querytext INTO v_queryresult;	

			IF v_queryresult IS NOT NULL THEN
				v_querytext = concat('SELECT concat (''"comboIds":'',array_to_json(array_agg(to_json(id::text))) , '', 
					"comboNames":'',array_to_json(array_agg(to_json(idval::text)))) FROM (',v_querytext_mod,')a');
				v_debug_vars := json_build_object('v_querytext_mod', v_querytext_mod);
				v_debug := json_build_object('querystring', v_querytext, 'vars', v_debug_vars, 'funcname', 'gw_fct_gettoolbox', 'flag', 70);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
				EXECUTE v_querytext INTO v_queryresult;	
			ELSE
				v_queryresult = '"comboIds":[], "comboNames":[]';
			END IF;
			
			v_rec_replace = (REPLACE(rec.inputparams::text, concat('"dvQueryText":"', rec.inputparams::json->>'dvQueryText','"') , v_queryresult))::json;
			v_rec_replace = (REPLACE(v_rec_replace::text, concat('"selectedId":"', rec.inputparams::json->>'selectedId','"'), v_selectedid))::json;
		
			v_om_fields = (REPLACE(v_om_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
			v_edit_fields = (REPLACE(v_edit_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
			v_epa_fields = (REPLACE(v_epa_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
			v_master_fields = (REPLACE(v_master_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
			v_admin_fields = (REPLACE(v_admin_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
									
		ELSIF v_value ilike '$user%' THEN
			IF v_value = '$userExploitation' THEN
				v_value = concat('"value":"',v_expl,'"');
			ELSIF v_value = '$userState' THEN
				v_value = concat('"value":"',v_state,'"');
			ELSIF v_value = '$userInpResult' THEN
				v_value = concat('"value":"',v_inp_result,'"');
			END IF;			
			v_rec_replace = (REPLACE(rec.inputparams::text, concat('"value":"', rec.inputparams::json->>'value','"'), v_value))::json;
			
			v_om_fields = (REPLACE(v_om_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
			v_edit_fields = (REPLACE(v_edit_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
			v_epa_fields = (REPLACE(v_epa_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
			v_master_fields = (REPLACE(v_master_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
			v_admin_fields = (REPLACE(v_admin_fields::text::text,  rec.inputparams::text , v_rec_replace::text))::json;
		END IF;

	END LOOP;

--    Control NULL's
	SELECT json_strip_nulls(json_build_object('om', v_om_fields, 
	'edit', v_edit_fields,
	'epa', v_epa_fields,
	'master', v_master_fields,
	'admin', v_admin_fields)) INTO v_process;

	v_process := COALESCE(v_process, '[]');
	v_reports := COALESCE(v_reports, '[]');

	-- make return
	v_return ='{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":'||v_version||',"body":{"form":{}'||
		     ',"feature":{}'||
		     ',"data":{"processes":{"fields": '|| v_process ||'}'||
				', "reports":{"fields":'||v_reports||'}}}}';

	RETURN v_return;
       
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || ',"MSGERR": '|| to_json(v_msgerr::json ->> 'MSGERR') ||'}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

