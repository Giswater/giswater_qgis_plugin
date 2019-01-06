/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2604

-- Function: SCHEMA_NAME.gw_api_getvisit(json)

-- DROP FUNCTION SCHEMA_NAME.gw_api_getvisit(json);

CREATE OR REPLACE FUNCTION ws_sample.gw_api_getvisit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT ws_sample.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "visit_id":null},
"data":{"type":"arc", "id":"2001"}}$$)

SELECT ws_sample.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "visit_id":null},
"data":{"type":"", "id":""}}$$)

SELECT ws_sample.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "visit_id":1001},
"data":{"type":"arc"}}$$)

SELECT ws_sample.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "visit_id":1},
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
	v_bottom json [];
	v_bottom_json json;
	v_projecttype varchar;

BEGIN

	-- Set search path to local schema
	SET search_path = "ws_sample", public;
	v_schemaname := 'ws_sample';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

	-- get project type
	SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

	--  get parameters from input
	v_device = ((p_data ->>'client')::json->>'device')::integer;
	v_id = ((p_data ->>'feature')::json->>'visit_id')::integer;
	v_featureid = ((p_data ->>'data')::json->>'id');
	v_featuretype = ((p_data ->>'data')::json->>'type');

	--  get visitclass
	IF v_id IS NULL THEN
		-- TODO: for new visit enhance the visit type using the feature_id
		v_visitclass := (SELECT value FROM config_param_user WHERE parameter = concat('visitclass_vdefault_', v_featuretype) AND cur_user=current_user)::integer;
		IF v_visitclass IS NULL THEN
			v_visitclass := 6;
		END IF;
	ELSE 
		v_visitclass := (SELECT class_id FROM ws_sample.om_visit WHERE id=v_id::bigint);
		IF v_visitclass IS NULL THEN
			v_visitclass := 0;
		END IF;
	END IF;

	--  get formname and tablename
	v_formname := (SELECT formname FROM config_api_visit WHERE visitclass_id=v_visitclass);
	v_tablename := (SELECT tablename FROM config_api_visit WHERE visitclass_id=v_visitclass);

	RAISE NOTICE 'featuretype: %,  visitclass: %,  v_visit: %,  formname: %,  tablename: %,  device: %',v_featuretype, v_visitclass, v_id, v_formname, v_tablename, v_device;
   
	--  Create tabs array
	v_formtabs := '[';
       
		-- Data tab
		IF v_id IS NULL THEN
			SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;

			FOREACH aux_json IN ARRAY v_fields
			LOOP
				-- setting feature id value
				IF (aux_json->>'column_id') = 'arc_id' OR (aux_json->>'column_id')='node_id' OR (aux_json->>'column_id')='connec_id' OR (aux_json->>'column_id') ='gully_id' THEN
					v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'value', v_featureid);
				END IF;

				-- setting visit id value
				IF (aux_json->>'column_id') = 'visit_id' THEN
					PERFORM setval('ws_sample.audit_check_project_id_seq', (SELECT max(id)+1 FROM om_visit), true);
					v_id = nextval('ws_sample.audit_check_project_id_seq');
					v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'value', v_id);	
				END IF;
			END LOOP;
		ELSE 
			SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'UPDATE', null, v_device) INTO v_fields;
		END IF;	
		v_fields_json = array_to_json (v_fields);
		
		-- building tab
		SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visit' AND tabname='tabData';
		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',false);
				v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs || v_tabaux::text;

		-- Events tab
		IF v_visitclass=0 THEN
			-- building tab
			v_tabaux := json_build_object('tabName','tabEvent','tabLabel','Events','tabText','Test text for tab','active',false);
			v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
			v_formtabs := v_formtabs || ',' || v_tabaux::text;
		END IF;

	-- Files tab
		-- building tab
		SELECT * INTO v_tab FROM config_api_form_tabs WHERE formname='visit' AND tabname='tabFiles';
		v_tabaux := json_build_object('tabName',v_tab.tabname,'tabLabel',v_tab.tablabel, 'tabText',v_tab.tabtext, 'tabFunction', v_tab.tabfunction::json, 'tabActions', v_tab.tabactions::json, 'active',false);
		--'{"name":"gwGetList()", "parameters"{"tableName":"om_visit"_file"}}'::json, 'actions', '{"sg":"sag"}'::jso);

		v_formtabs := v_formtabs  || ',' || v_tabaux::text;

		v_formtabs := (v_formtabs ||']');

	-- header form
	v_formheader :=concat('VISIT - ',v_id);	

	-- actions form (ignored on devices =1,2,3)
        EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT formaction as "actionName" FROM config_api_form_actions WHERE formname = ''visit''
		AND (project_type =''utils'' or project_type='||quote_literal(LOWER(v_projecttype))||')
		order by orderby desc) a'
		INTO v_formactions;
	v_formactions = array_to_json (v_formactions::text[]);

	-- bottom form
	SELECT gw_api_get_formfields( 'generic', 'editbuttons', 'bottom', null, null, null, null, 'INSERT', null, v_device) INTO v_bottom;
	v_bottom_json = array_to_json (v_bottom);


	-- Create new form
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formId', 'F11'::text);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formName', v_formheader);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formTabs', v_formtabs::json);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formActions', v_formactions);

	--  Control NULL's
	v_fields_json := COALESCE(v_fields_json, '{}');
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_tablename := COALESCE(v_tablename, '{}');
	v_id := COALESCE(v_id, '{}');
	v_bottom_json := COALESCE(v_bottom_json, '{}');

  
	-- Return
	RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"feature":{"featureType":"visit", "tableName":"'||v_tablename||'", "idname":"visit_id", "id":'||v_id||'}'||
		    ', "form":'||v_forminfo||
		     ',"data":{}}'||
	     ',"bottom":'|| v_bottom_json ||
	    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
