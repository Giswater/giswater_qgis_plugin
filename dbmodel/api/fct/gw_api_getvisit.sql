/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2604

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getvisit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
--tab visit
SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"featureType":"visit", "visit_id":null},
"form":{"tabData":{"active":true}, "tabFiles":{"active":false}},
"data":{"type":"arc", "id":"2001"}}$$)

SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"featureType":"visit", "visit_id":null},
"form":{"tabData":{"active":true}, "tabFiles":{"active":false}},
"data":{"type":"connec", "id":"3001"}}$$)


SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"featureType":"visit", "visit_id":null},
"form":{"tabData":{"active":true}, "tabFiles":{"active":false}},
"data":{"type":"", "id":""}}$$)

SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"featureType":"visit", "visit_id":1001},
"form":{"tabData":{"active":true}, "tabFiles":{"active":false}},
"data":{"type":"arc"}}$$)

SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"featureType":"visit", "visit_id":1},
"form":{"tabData":{"active":true}, "tabFiles":{"active":false}},
"data":{"type":"arc"}}$$)


--tab files
-- first time
SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"featureType":"visit", "visit_id":1135},
"form":{"tabData":{"active":false},
	"tabFiles":{"active":true, 
		    "feature":{"tableName":"om_visit_file"},
		    "data":{}}},
"data":{"type":"arc"}}$$)

-- not first time
SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"visit_id":1135},
"form":{"tabData":{"active":false},
	"tabFiles":{"active":true, 
		    "tabFeature":{"tabTableName":"om_visit_file"},
		    "tabData":{"filterFields":{"filetype":"doc","limit":10},
			       "pageInfo":{"orderBy":"tstamp", "orderType":"DESC", "currentPage":3}}}},
"data":{"type":"arc"}}$$)
*/

DECLARE
	v_apiversion text;
	v_schemaname text;
	v_featuretype text;
	v_visitclass integer;
	v_id text;
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

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

	-- get project type
	SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

	--  get parameters from input
	v_client = (p_data ->>'client')::json;
	v_device = ((p_data ->>'client')::json->>'device')::integer;
	v_id = ((p_data ->>'feature')::json->>'id')::integer;
	v_featureid = ((p_data ->>'data')::json->>'id');
	v_featuretype = ((p_data ->>'data')::json->>'type');
	v_list =((p_data ->>'form')::json->>'tabFiles')::json;
	v_activedatatab = (((p_data ->>'form')::json->>'tabData')::json->>'active')::boolean;
	v_activefilestab = (((p_data ->>'form')::json->>'tabFiles')::json->>'active')::boolean;

	--  get visitclass
	IF v_id IS NULL OR (SELECT id FROM SCHEMA_NAME.om_visit WHERE id=v_id::bigint) IS NULL THEN
	
		-- TODO: for new visit enhance the visit type using the feature_id
		v_visitclass := (SELECT value FROM config_param_user WHERE parameter = concat('visitclass_vdefault_', v_featuretype) AND cur_user=current_user)::integer;
		IF v_visitclass IS NULL THEN
			v_visitclass := (SELECT id FROM om_visit_class WHERE feature_type=upper(v_featuretype) LIMIT 1);
		END IF;
	ELSE 
		v_visitclass := (SELECT class_id FROM SCHEMA_NAME.om_visit WHERE id=v_id::bigint);
		IF v_visitclass IS NULL THEN
			v_visitclass := 0;
		END IF;
	END IF;

	-- getting visit id
	IF v_id IS NULL THEN
		v_id := ((SELECT max(id)+1 FROM om_visit)+1);
		isnewvisit = true;
	END IF;

	--  get formname and tablename
	v_formname := (SELECT formname FROM config_api_visit WHERE visitclass_id=v_visitclass);
	v_tablename := (SELECT tablename FROM config_api_visit WHERE visitclass_id=v_visitclass);

	RAISE NOTICE 'featuretype: %,  visitclass: %,  v_visit: %,  formname: %,  tablename: %,  device: %',v_featuretype, v_visitclass, v_id, v_formname, v_tablename, v_device;
   
	--  Create tabs array
	v_formtabs := '[';
       
		-- Data tab
		-----------
		
		--filling tab (only if it's active)
		IF v_activedatatab THEN
			IF isnewvisit IS NULL THEN

				SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;

				FOREACH aux_json IN ARRAY v_fields
				LOOP

					-- setting feature id value
					IF (aux_json->>'column_id') = 'arc_id' OR (aux_json->>'column_id')='node_id' OR (aux_json->>'column_id')='connec_id' OR (aux_json->>'column_id') ='gully_id' THEN
						v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'value', v_featureid);
					END IF;
	
					-- setting visit id value
					IF (aux_json->>'column_id') = 'visit_id' THEN
						v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'value', v_id);	
					END IF;
				END LOOP;
				ELSE 
				SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;
			END IF;	

			v_fields_json = array_to_json (v_fields);

			v_fields_json := COALESCE(v_fields_json, '{}');		

		END IF;

		-- building tab
		SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visit' AND tabname='tabData';
		
		-- switch actionAddFile for actionAddPhoto on device =1,2
		IF v_device=1 OR v_device=2 THEN
			v_tab.tabactions := (replace (v_tab.tabactions::text, 'actionAddFile', 'actionAddPhoto'));
		END IF;
		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 
			'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activedatatab);
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs || v_tabaux::text;


		-- Events tab
		-------------
		IF v_visitclass=0 THEN
		
			-- building tab
			v_tabaux := json_build_object('tabName','tabEvent','tabLabel','Events','tabText','Test text for tab','active',false);
			v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
			v_formtabs := v_formtabs || ',' || v_tabaux::text;
		END IF;

		-- Files tab
		------------
		--filling tab (only if it's active)
		IF v_activefilestab THEN

			--setting device on json
			v_list := gw_fct_json_object_set_key(v_list, 'client', v_client);

			-- setting visit_id on json
			v_filterfields := ((v_list->>'tabData')::json->>'filterFields')::json;
			v_filterfields := gw_fct_json_object_set_key(v_filterfields, 'visit_id', v_id);
			v_data := gw_fct_json_object_set_key(v_data, 'filterFields', v_filterfields);
			v_list := gw_fct_json_object_set_key(v_list, 'tabData', v_data);

			--refactor tabNames without tab on json
			v_list := replace (v_list::text, 'tabFeature', 'feature');
			v_list := replace (v_list::text, 'tabTableName', 'tableName');
			v_list := replace (v_list::text, 'tabFeature', 'feature');
			v_list := replace (v_list::text, 'tabData', 'data');

			-- calling getlist function with modified json
			SELECT gw_api_getlist (v_list) INTO v_fields_json;
			
			-- getting pageinfo and list values
			v_pageinfo = ((v_fields_json->>'body')::json->>'data')::json->>'pageInfo';
			v_fields_json = ((v_fields_json->>'body')::json->>'data')::json->>'fields';
			
		END IF;

		v_fields_json := COALESCE(v_fields_json, '{}');

		-- building tab
		SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visit' AND tabname='tabFiles';
		
		-- switch actionAddFile for actionAddPhoto on device =1,2
		IF v_device=1 OR v_device=2 THEN
			v_tab.tabactions := (replace (v_tab.tabactions::text, 'actionAddFile', 'actionAddPhoto'));
		END IF;
	
		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 
			'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active', v_activefilestab);
			
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
 		
 		-- setting pageInfo
 		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'pageInfo', v_pageinfo);
		v_formtabs := v_formtabs  || ',' || v_tabaux::text;

	--closing tabs array
	v_formtabs := (v_formtabs ||']');

	-- header form
	v_formheader :=concat('VISIT - ',v_id);	

	-- actions and layermanager
	EXECUTE 'SELECT actions, layermanager FROM config_api_form WHERE formname = ''visit'' AND projecttype ='||quote_literal(LOWER(v_projecttype))
			INTO v_formactions, v_layermanager;

	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formActions', v_formactions);
		
	-- Create new form
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formId', 'F11'::text);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formName', v_formheader);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formTabs', v_formtabs::json);

	--  Control NULL's
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_id := COALESCE(v_id, '{}');
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_tablename := COALESCE(v_tablename, '{}');
	v_layermanager := COALESCE(v_layermanager, '{}');
  
	-- Return
	RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"feature":{"featureType":"visit", "tableName":"'||v_tablename||'", "idname":"visit_id", "id":'||v_id||'}'||
		    ', "form":'||v_forminfo||
		    ', "data":{"layerManager":'||v_layermanager||'}}'||
		    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
