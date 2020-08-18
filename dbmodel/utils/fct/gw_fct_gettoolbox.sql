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

SELECT SCHEMA_NAME.gw_fct_gettoolbox($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"filterText":""}}$$)

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
        SELECT lower(project_type) INTO v_projectype FROM sys_version LIMIT 1;

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

	IF v_projectype = 'ws' THEN
		v_nodetype = (SELECT nodetype_id FROM cat_node JOIN config_param_user ON cat_node.id = config_param_user.value
		WHERE cur_user = current_user AND parameter = 'edit_nodecat_vdefault');
		IF v_nodetype IS NULL OR (SELECT id FROM cat_node WHERE nodetype_id = v_nodetype limit 1) IS NULL THEN
			v_nodetype = (SELECT id FROM cat_feature_node JOIN cat_feature USING  (id) WHERE active IS TRUE limit 1);
		END IF;
	ELSE
		v_nodetype = (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter = 'edit_nodetype_vdefault');
		IF v_nodetype IS NULL OR (SELECT id FROM cat_node WHERE node_type = v_nodetype OR node_type IS NULL  limit 1) IS NULL THEN
			v_nodetype = (SELECT id  FROM cat_feature_node JOIN cat_feature USING  (id) WHERE active IS TRUE limit 1);
		END IF;
	END IF;

	v_nodecat = (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter = 'edit_nodecat_vdefault');

	IF v_nodecat IS NULL THEN 
		v_nodecat = (SELECT id FROM cat_node WHERE active IS true limit 1);
	END IF;

	-- get om toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname, isparametric
		 FROM sys_function 
		 JOIN config_toolbox USING (id)
		 WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_om'' AND config_toolbox.active IS TRUE
		 AND (project_type='||quote_literal(v_projectype)||' or project_type=''utils'')) a'
		USING v_filter
		INTO v_om_fields;

	-- get edit toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname, isparametric
		 FROM sys_function
 		 JOIN config_toolbox USING (id)
		 WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_edit'' AND config_toolbox.active IS TRUE
		 AND ( project_type='||quote_literal(v_projectype)||' or project_type=''utils'')) a'
		USING v_filter
		INTO v_edit_fields;

	-- get epa toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname, isparametric
		FROM sys_function
		JOIN config_toolbox USING (id)
		WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_epa'' AND config_toolbox.active IS TRUE
		AND ( project_type='||quote_literal(v_projectype)||' or project_type=''utils'')) a'
		USING v_filter
		INTO v_epa_fields;
				
		v_epa_fields = REPLACE (v_epa_fields::text, '"value":""', concat('"value":"', v_epa_user, '"'));

	-- get master toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname, isparametric
		 FROM sys_function
 		 JOIN config_toolbox USING (id)
		 WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_master'' AND config_toolbox.active IS TRUE
		 AND (project_type='||quote_literal(v_projectype)||' OR project_type=''utils'')) a'
		USING v_filter
		INTO v_master_fields;

	-- get admin toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, 
		 function_name as functionname, isparametric
		 FROM sys_function
		 JOIN config_toolbox USING (id)
		 WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_admin'' AND config_toolbox.active IS TRUE
		 AND (project_type='||quote_literal(v_projectype)||' or project_type=''utils'')) a'
		USING v_filter
		INTO v_admin_fields;

	-- refactor dvquerytext		
	FOR v_querytext in select distinct querytext from (
	SELECT id, json_array_elements_text (inputparams::json)::json->>'widgetname' as widgetname, json_array_elements_text (inputparams::json)::json->>'dvQueryText'
	as querytext FROM sys_function JOIN config_toolbox USING (id) 
	WHERE alias = v_filter  AND config_toolbox.active IS TRUE AND (project_type=v_projectype OR project_type='utils'))a
	WHERE querytext is not null
		
	LOOP
		IF v_querytext ilike '%$userNodetype%' THEN
			v_querytext_mod = REPLACE (v_querytext::text, '$userNodetype', quote_literal(v_nodetype));
		ELSE 
			v_querytext_mod = v_querytext;
		END IF;

		v_querytext_mod =  'SELECT concat (''"comboIds":'',array_to_json(array_agg(to_json(id::text))) , '', 
		"comboNames":'',array_to_json(array_agg(to_json(idval::text)))) FROM ('||v_querytext_mod||')a';
		EXECUTE v_querytext_mod INTO v_queryresult;

		v_om_fields = (REPLACE(v_om_fields::text, concat('"dvQueryText":"', v_querytext,'"') , v_queryresult))::json;
		v_edit_fields = (REPLACE(v_edit_fields::text, concat('"dvQueryText":"', v_querytext,'"') , v_queryresult))::json;
		v_epa_fields = (REPLACE(v_epa_fields::text, concat('"dvQueryText":"', v_querytext,'"') , v_queryresult))::json;
		v_master_fields = (REPLACE(v_master_fields::text, concat('"dvQueryText":"', v_querytext,'"') , v_queryresult))::json;
		v_admin_fields = (REPLACE(v_admin_fields::text, concat('"dvQueryText":"', v_querytext,'"') , v_queryresult))::json;

	END LOOP;


	--    Control NULL's
	v_om_fields := COALESCE(v_om_fields, '[]');
	v_edit_fields := COALESCE(v_edit_fields, '[]');
	v_epa_fields := COALESCE(v_epa_fields, '[]');
	v_master_fields := COALESCE(v_master_fields, '[]');
	v_admin_fields := COALESCE(v_admin_fields, '[]');

	v_expl := COALESCE(v_expl, '');
	v_state := COALESCE(v_state, '');
	v_inp_result := COALESCE(v_inp_result, '');
	v_rpt_result := COALESCE(v_rpt_result, '');
	v_nodetype := COALESCE(v_nodetype, '');
	v_nodecat := COALESCE(v_nodecat, '');
	
	-- make return
	v_return ='{"status":"Accepted", "message":{"level":1, "text":"This is a test message"}, "version":'||v_version||',"body":{"form":{}'||
		     ',"feature":{}'||
		     ',"data":{"fields":{ "om":' || v_om_fields ||
				      ' , "edit":' || v_edit_fields ||
				      ' , "epa":' || v_epa_fields ||
				      ' , "master":' || v_master_fields ||
				      ' , "admin":' || v_admin_fields ||'}}}}';

	-- manage variables ($)
	v_return = REPLACE (v_return::text, '$userExploitation', v_expl);
	v_return = REPLACE (v_return::text, '$userState', v_state);
	v_return = REPLACE (v_return::text, '$userInpResult', v_inp_result);
	v_return = REPLACE (v_return::text, '$userRptResult', v_rpt_result);
	v_return = REPLACE (v_return::text, '$userNodetype', v_nodetype);
	v_return = REPLACE (v_return::text, '$userNodecat', v_nodecat);

	RETURN v_return;
       
	--Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
