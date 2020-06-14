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
"data":{"isToolbox":false, "filterText":"Import inp epanet file"}}$$)

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

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
  
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	-- get input parameter
	v_filter := (p_data ->> 'data')::json->> 'filterText';
	v_filter := COALESCE(v_filter, '');

	-- get project type
        SELECT lower(project_type) INTO v_projectype FROM sys_version LIMIT 1;

	-- get epa results
	IF (SELECT result_id FROM rpt_cat_result LIMIT 1) IS NOT NULL THEN
		v_isepa = true;
		v_epa_user = (SELECT result_id FROM rpt_cat_result WHERE cur_user=current_user LIMIT 1);
		IF v_epa_user IS NULL THEN
			v_epa_user = (SELECT id FROM rpt_cat_result LIMIT 1);
		END IF;
	END IF;

	-- get om toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname, isparametric
		 FROM sys_function 
		 JOIN config_toolbox USING (id)
		 WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_om''
		 AND (project_type='||quote_literal(v_projectype)||' or project_type=''utils'')) a'
		USING v_filter
		INTO v_om_fields;

	-- get edit toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname, isparametric
		 FROM sys_function
 		 JOIN config_toolbox USING (id)
		 WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_edit''
		 AND ( project_type='||quote_literal(v_projectype)||' or project_type=''utils'')) a'
		USING v_filter
		INTO v_edit_fields;

	-- get epa toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname, isparametric
		FROM sys_function
		JOIN config_toolbox USING (id)
		WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_epa''
		AND ( project_type='||quote_literal(v_projectype)||' or project_type=''utils'')) a'
		USING v_filter
		INTO v_epa_fields;
				
		v_epa_fields = REPLACE (v_epa_fields::text, '"value":""', concat('"value":"', v_epa_user, '"'));

	-- get master toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname, isparametric
		 FROM sys_function
 		 JOIN config_toolbox USING (id)
		 WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_master''
		 AND (project_type='||quote_literal(v_projectype)||' OR project_type=''utils'')) a'
		USING v_filter
		INTO v_master_fields;
        
	-- get admin toolbox parameters
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
		 SELECT alias, descript, functionparams AS input_params, inputparams AS return_type, observ AS isnotparammsg, sys_role, function_name as functionname, isparametric
		 FROM sys_function
		 JOIN config_toolbox USING (id)
		 WHERE alias LIKE ''%'|| v_filter ||'%'' AND sys_role =''role_admin''
		 AND (project_type='||quote_literal(v_projectype)||' or project_type=''utils'')) a'
		USING v_filter
		INTO v_admin_fields;

	-- refactor dvquerytext		
	FOR v_querytext in select distinct querytext from (
		
		SELECT id, json_array_elements_text (inputparams::json)::json->>'widgetname' as widgetname, json_array_elements_text (inputparams::json)::json->>'dvQueryText'
		as querytext FROM sys_function JOIN config_toolbox USING (id) where alias = v_filter AND (project_type=v_projectype OR project_type='utils'))a
		WHERE querytext is not null
		LOOP
		
			v_querytext_mod =  'SELECT concat (''"comboIds":'',array_to_json(array_agg(to_json(id::text))) , '', "comboNames":'',array_to_json(array_agg(to_json(idval::text)))) FROM ('||v_querytext||')a';
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

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"This is a test message"}, "apiVersion":'||v_version||
             ',"body":{"form":{}'||
		     ',"feature":{}'||
		     ',"data":{"fields":{'||
					   ' "om":' || v_om_fields ||
					 ' , "edit":' || v_edit_fields ||
					 ' , "epa":' || v_epa_fields ||
					 ' , "master":' || v_master_fields ||
					 ' , "admin":' || v_admin_fields ||'}}}'||
	    '}')::json;
       
	--Exception handling
	--EXCEPTION WHEN OTHERS THEN 
	--RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
