/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2640

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getvisitmanager(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
--new call
SELECT SCHEMA_NAME.gw_api_getvisitmanager($${
"client":{"device":3,"infoType":100,"lang":"es"},
"form":{},
"data":{}}$$)

SELECT SCHEMA_NAME.gw_api_getvisitmanager($${"client":{"device":3,"infoType":100,"lang":"es"},
     "feature":{"featureType":"visit","tableName":"ve_visit_user_manager","idName":"user_id","id":"xtorret"},"form":{"tabData":{"active":false},"tabLots":{"active":true},"navigation":{"currentActiveTab":"tabData"}},
       "data":{"relatedFeature":{"type":"arc", "id":"2079"},"fields":{"user_id":"xtorret","date":"2019-01-28","team_id":"1","vehicle_id":"3"},"pageInfo":null}}$$) AS result


-- change from tab data to tab files (upserting data on tabData)
SELECT SCHEMA_NAME.gw_api_getvisitmanager($${
"client":{"device":3,"infoType":100,"lang":"es"},
"feature":{"featureType":"visit","tableName":"ve_visit_user_manager","idName":"user_id","id":"xtorret"},
"form":{"tabData":{"active":false}, "tabLots":{"active":true},"navigation":{"currentActiveTab":"tabData"}},
"data":{"fields":{"user_id":"xtorret","team_id":1,"vehicle_id":1,"date":"2019-01-01"}}}$$)

--tab activelots
SELECT SCHEMA_NAME.gw_api_getvisitmanager($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},
"form":{"tabData":{"active":false}, "tabLots":{"active":true}}, "navigation":{"currentActiveTab":"tabLots"}, 
"data":{"filterFields":{"limit":10},
	"pageInfo":{"currentPage":1}
	}}$$)

*/

DECLARE
	v_apiversion text;
	v_schemaname text;
	v_featuretype text;
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
	v_activelotstab boolean;
	v_activetodotab boolean;
	v_activedonetab boolean;
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
	v_disabled boolean = true;
	v_firstcall boolean = false;
	v_team text;
	v_vehicle integer;

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
	v_id = ((p_data ->>'feature')::json->>'id')::text;
	v_data = (p_data ->>'data')::text;

	---
	v_featureid = (((p_data ->>'data')::json->>'relatedFeature')::json->>'id');
	v_featuretype = (((p_data ->>'data')::json->>'relatedFeature')::json->>'type');
	v_activedatatab = (((p_data ->>'form')::json->>'tabData')::json->>'active')::boolean;
	v_activelotstab = (((p_data ->>'form')::json->>'tabLots')::json->>'active')::boolean;
	v_addfile = ((p_data ->>'data')::json->>'newFile')::json;
	v_deletefile = ((p_data ->>'data')::json->>'deleteFile')::json;
	v_currentactivetab = (((p_data ->>'form')::json->>'navigation')::json->>'currentActiveTab')::text;
	v_team = ((p_data ->>'data')::json->>'fields')::json->>'team'::text;
	v_vehicle = ((p_data ->>'data')::json->>'fields')::json->>'vehicle'::text;


	-- setting values
	v_tablename := 've_visit_user_manager';
	v_idname := 'user_id';
	v_columntype := 'varchar(30)';
	
	-- Set firstcall
	IF v_currentactivetab IS NULL THEN 
		v_firstcall := TRUE;
		v_activedatatab := TRUE;
		v_activelotstab := FALSE;
	END IF;

	-- upserting data on tabData
	IF v_currentactivetab = 'tabData' THEN
		--SELECT gw_api_setvisitmanager (p_data) INTO v_return;
		v_id = ((v_return->>'body')::json->>'feature')::json->>'id';
		v_message = (v_return->>'message');
		RAISE NOTICE '--- UPSERT USER MANAGER CALLING gw_api_setvisitmnager WITH MESSAGE: % ---', v_message;
	END IF;

	--  Create tabs array	
	v_formtabs := '[';
       
		-- Data tab
		-----------
		IF v_activedatatab THEN
		
			SELECT gw_api_get_formfields( 'visitManager', 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;

			-- getting values from feature
			EXECUTE 'SELECT (row_to_json(a)) FROM 
				(SELECT * FROM '||v_tablename||' WHERE '||v_idname||' = CAST($1 AS '||v_columntype||'))a'
				INTO v_values
				USING current_user;
	
			raise notice 'v_values %', v_values;
				
			-- setting values
			FOREACH aux_json IN ARRAY v_fields 
			LOOP          
				array_index := array_index + 1;
				v_fieldvalue := (v_values->>(aux_json->>'column_id'));
		
				IF (aux_json->>'widgettype')='combo' THEN 
					v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'selectedId', COALESCE(v_fieldvalue, ''));
				ELSE 
					v_fields[array_index] := gw_fct_json_object_set_key(v_fields[array_index], 'value', COALESCE(v_fieldvalue, ''));
				END IF;
			END LOOP;			

			v_fields_json = array_to_json (v_fields);
			v_fields_json := COALESCE(v_fields_json, '{}');	
		END IF;	
		
		-- building tab
		SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visitManager' AND tabname='tabData' and device = v_device LIMIT 1;
		IF v_tab IS NULL THEN 
			SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visitManager' AND tabname='tabData' LIMIT 1;			
		END IF;

		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 
			'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activedatatab);
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs || v_tabaux::text;

		-- Active lots tab
		------------------
		IF v_activelotstab THEN

			-- setting table feature
			v_feature := '{"tableName":"userLotList"}';		
			
			-- setting feature
			p_data := gw_fct_json_object_set_key(p_data, 'feature', v_feature);

			--refactor tabNames
			p_data := replace (p_data::text, 'tabFeature', 'feature');
			
			RAISE NOTICE '--- CALLING gw_api_getlist USING p_data: % ---', p_data;
			SELECT gw_api_getlist (p_data) INTO v_fields_json;

			-- getting pageinfo and list values
			v_pageinfo = ((v_fields_json->>'body')::json->>'data')::json->>'pageInfo';
			v_fields_json = ((v_fields_json->>'body')::json->>'data')::json->>'fields';
			
			v_fields_json := COALESCE(v_fields_json, '{}');
			
		END IF;

		-- building tab
		SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visitManager' AND tabname='tabLots' and device = v_device LIMIT 1;

		IF v_tab IS NULL THEN 
			SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visitManager' AND tabname='tabLots' LIMIT 1;			
		END IF;

		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 
		'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activelotstab);
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs || ',' || v_tabaux::text;
	

		-- Todo visits tab
		---------------------
		IF v_activetodotab THEN
			SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visitManager' AND tabname='tabToDo' and device = v_device LIMIT 1;

			IF v_tab IS NULL THEN 
				SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visitManager' AND tabname='tabToDo' LIMIT 1;			
			END IF;

			v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 
			'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activetodotab);
			v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
			v_formtabs := v_formtabs || ',' || v_tabaux::text;
	
			RAISE NOTICE ' --- BUILDING tabToDo with v_tabaux % ---', v_tabaux;
		END IF;
	
		
		-- Done visits tab
		------------------
		IF v_activedonetab THEN
			SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visitManager' AND tabname='tabDone' and device = v_device LIMIT 1;

			IF v_tab IS NULL THEN 	
				SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visitManager' AND tabname='tabDone' LIMIT 1;			
			END IF;

			v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 
				'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',v_activedonetab);
			--v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
			v_formtabs := v_formtabs || ',' || v_tabaux::text;

			RAISE NOTICE ' --- BUILDING tabDone with v_tabaux % ---', v_tabaux;
		END IF;

	--closing tabs array
	v_formtabs := (v_formtabs ||']');

	RAISE NOTICE 'v_formtabs %', v_formtabs;

	-- header form
	v_formheader :=concat('VISIT MANAGER - ',UPPER(current_user));	

	-- actions and layermanager
	EXECUTE 'SELECT actions, layermanager FROM config_api_form WHERE formname = ''visitManager'' AND (projecttype ='||quote_literal(LOWER(v_projecttype))||' OR projecttype = ''utils'')'
			INTO v_formactions, v_layermanager;

	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formActions', v_formactions);
		
	-- Create new form
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formId', 'F11'::text);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formName', v_formheader);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formTabs', v_formtabs::json);
	

	--  Control NULL's
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_message := COALESCE(v_message, '{}');
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_tablename := COALESCE(v_tablename, '{}');
	v_layermanager := COALESCE(v_layermanager, '{}');
  
	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "apiVersion":'||v_apiversion||
             ',"body":{"feature":{"featureType":"visit", "tableName":"'||v_tablename||'", "idName":"user_id", "id":"'||current_user||'"}'||
		    ', "form":'||v_forminfo||
		    ', "data":{"layerManager":'||v_layermanager||'}}'||
		    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



