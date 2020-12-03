/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2900

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getprojectvisitforms(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getprojectvisitforms(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
-- getform for use offline
SELECT SCHEMA_NAME.gw_fct_getprojectvisitforms($${
"client":{"device":4,"infoType":1,"lang":"es"},
"data":{"projectLayers":{"v_edit_arc","v_edit_node","v_edit_connec"}}}$$)
*/

DECLARE

v_version text;
v_schemaname text;
v_featuretype text;
v_featuretablename text;
v_visitclass integer;
v_id text;
v_idname text;
v_columntype text;
v_device integer;
v_formname text;
v_tablename text;
v_fields json [];
v_fields_text text [];
v_fields_json json;
v_forminfo json;
v_formheader text;
v_formactions text;
v_formtabs text;
v_tabaux json;
v_active boolean;
v_featureid varchar ;
aux_json json;
v_tab record;
v_projecttype varchar;
v_list json;
v_activedatatab boolean;
v_activefilestab boolean;
v_client json;
v_pageinfo json;
v_layermanager json;
v_filterfields json;
v_data json;
isnewvisit boolean;
v_feature json;
v_addfile json;
v_deletefile json;
v_filefeature json;
v_fileid text;
v_message json;
v_message1 text;
v_message2 text;
v_return json;
v_currentactivetab text;
v_values json;
array_index integer DEFAULT 0;
v_fieldvalue text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

/*
TODO
Generate one form for layer and one form for visitclass=incident


	-- get project type
	SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;

	--  get parameters from input
	v_client = (p_data ->>'client')::json;
	v_device = ((p_data ->>'client')::json->>'device')::integer;
	v_id = ((p_data ->>'feature')::json->>'id')::integer;
	v_featureid = (((p_data ->>'data')::json->>'relatedFeature')::json->>'id');
	v_featuretype = (((p_data ->>'data')::json->>'relatedFeature')::json->>'type');
	v_featuretablename = (((p_data ->>'data')::json->>'relatedFeature')::json->>'tableName');


	v_activedatatab = (((p_data ->>'form')::json->>'tabData')::json->>'active')::boolean;
	v_activefilestab = (((p_data ->>'form')::json->>'tabFiles')::json->>'active')::boolean;
	v_addfile = ((p_data ->>'data')::json->>'newFile')::json;
	v_deletefile = ((p_data ->>'data')::json->>'deleteFile')::json;
	v_currentactivetab = (((p_data ->>'form')::json->>'navigation')::json->>'currentActiveTab')::text;
	v_visitclass = ((p_data ->>'data')::json->>'fields')::json->>'class_id';

	--  get visitclass
	v_visitclass := (SELECT value FROM config_param_user WHERE parameter = concat('visitclass_vdefault_', v_featuretype) AND cur_user=current_user)::integer;		
	IF v_visitclass IS NULL THEN
		v_visitclass := (SELECT id FROM config_visit_class WHERE feature_type=upper(v_featuretype) LIMIT 1);
	END IF;
	
	
	--  get formname and tablename
	v_formname := (SELECT formname FROM config_visit_class WHERE visitclass_id=v_visitclass);
	v_tablename := (SELECT tablename FROM config_visit_class WHERE visitclass_id=v_visitclass);

	RAISE NOTICE '--- VISIT PARAMETERS: newvisitform: % featuretype: %,  visitclass: %,  formname: %,  tablename: %,  device: % ---',isnewvisit, v_featuretype, v_visitclass, v_formname, v_tablename, v_device;

  
	--  Create tabs array	
	v_formtabs := '[';
       
		-- Data tab
		-----------
		RAISE NOTICE ' --- GETTING tabData DEFAULT VALUES ON NEW VISIT ---';

		SELECT gw_fct_getformfields( v_formname, 'form_visit', 'data', null, null, null, null, 'INSERT', null, v_device, null) INTO v_fields;
		v_fields_json = array_to_json (v_fields);
		v_fields_json := COALESCE(v_fields_json, '{}');	

		SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit' AND tabname='tab_data' and device = v_device LIMIT 1;

		IF v_tab IS NULL THEN 
			SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit' AND tabname='tab_data' LIMIT 1;
		END IF;

		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tooltip',v_tab.tooltip, 
			'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',true);
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs || v_tabaux::text;

		
		-- Files tab
		------------
		-- getting filterfields
		v_filterfields := ((p_data->>'data')::json->>'fields')::json;
		
		-- setting filterfields
		v_data := (p_data->>'data');
		v_filterfields := gw_fct_json_object_set_key(v_filterfields, 'visit_id', v_id);
		v_data := gw_fct_json_object_set_key(v_data, 'filterFields', v_filterfields);
		p_data := gw_fct_json_object_set_key(p_data, 'data', v_data);

		-- getting feature
		v_feature := '{"tableName":"om_visit_file"}';	

		-- setting feature
		p_data := gw_fct_json_object_set_key(p_data, 'feature', v_feature);	
			
		--refactor tabNames
		p_data := replace (p_data::text, 'tabFeature', 'feature');
			
		RAISE NOTICE '--- CALLING gw_fct_getlist USING p_data: % ---', p_data;
		SELECT gw_fct_getlist (p_data) INTO v_fields_json;

		-- getting pageinfo and list values
		v_pageinfo = ((v_fields_json->>'body')::json->>'data')::json->>'pageInfo';
		v_fields_json = ((v_fields_json->>'body')::json->>'data')::json->>'fields';
			
		v_fields_json := COALESCE(v_fields_json, '{}');

		-- building tab
		SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit' AND tabname='tab_file' and device = v_device LIMIT 1;
		
		IF v_tab IS NULL THEN 
			SELECT * INTO v_tab FROM config_form_tabs WHERE formname='visit' AND tabname='tab_file' LIMIT 1;
		END IF;
		
		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tooltip',v_tab.tooltip, 
		'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active', true);	
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);

		RAISE NOTICE ' --- BUILDING tabFiles with v_tabaux % ---', v_tabaux;

	 	-- setting pageInfo
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'pageInfo', v_pageinfo);
		v_formtabs := v_formtabs  || ',' || v_tabaux::text;
		
	--closing tabs array
	v_formtabs := (v_formtabs ||']');

	-- header form
	v_formheader :=concat('VISIT - ',v_id);	

	-- actions and layermanager
	EXECUTE 'SELECT actions, layermanager FROM config_form WHERE formname = ''visit'' AND (projecttype ='||quote_literal(LOWER(v_projecttype))||' OR projecttype=''utils'')'
			INTO v_formactions, v_layermanager;

	RAISE NOTICE 'v_layermanager %', v_layermanager;

	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formActions', v_formactions);
		
	-- Create new form
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formId', 'F11'::text);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formName', v_formheader);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formTabs', v_formtabs::json);
	

	--  Control NULL's
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_id := COALESCE(v_id, '{}');
	v_message := COALESCE(v_message, '{}');
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_tablename := COALESCE(v_tablename, '{}');
	v_layermanager := COALESCE(v_layermanager, '{}');

  */
	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "version":'||v_apiversion||
             ',"body":{"feature":{"featureType":"visit", "tableName":"'||v_tablename||'", "idName":"visit_id", "id":'||v_id||'}'||
		    ', "form":'||v_forminfo||
		    ', "data":{"layerManager":'||v_layermanager||'}}'||
		    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



