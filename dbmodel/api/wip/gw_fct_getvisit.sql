/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION ws_sample.gw_api_getvisit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT ws_sample.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "visit_id":null},
"data":{"type":"arc"}}$$)

SELECT ws_sample.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "visit_id":1001},
"data":{}}$$)
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
	v_formtabid json;
	v_formtablabel json;
	v_formtabtext json;	
	v_formtabtable json;
	v_formheader text;
	v_formtabtablename json;
	v_formtabidname json;
	v_formactions json;

BEGIN

-- Set search path to local schema
    SET search_path = "ws_sample", public;
    v_schemaname := 'ws_sample';

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

--  get parameters from input
    v_device = ((p_data ->>'client')::json->>'device')::integer;
    v_id = ((p_data ->>'feature')::json->>'visit_id')::integer;
    v_featuretype = ((p_data ->>'data')::json->>'type');

--  get visitclass
    IF v_id IS NULL THEN
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

    RAISE NOTICE 'featuretype:%,  visitclass:%,  v_visit:%,  formname:%,  tablename:%,  device:%',v_featuretype, v_visitclass, v_id, v_formname, v_tablename, v_device;

    v_formactions = '[	{"actionName":"actionAdd","actionTooltip":"Add"},
			{"actionName":"actionDelete","actionTooltip":"Delete"}]';
    
--  get form fields
    IF v_id IS NULL THEN
	SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;
	-- define the text of header
	v_formheader := 'VISIT';	
    ELSE 
	SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'UPDATE', null, v_device) INTO v_fields;	
	-- define the text of header
	v_formheader :=concat('VISIT - ',v_id);	
    END IF;
   
-- building the form     
    IF v_visitclass=0 THEN
    	v_formtabid = array_to_json('{tabInfo,tabEvent,tabFile}'::text[]);
	v_formtablabel = array_to_json('{Info,Events,Files}'::text[]);
	v_formtabtext = array_to_json('{Info,Events,Files}'::text[]);
	v_formtabtablename = array_to_json('{null,v_ui_om_event,v_ui_om_visit_x_doc}'::text[]);
	v_formtabidname = array_to_json('{null,id,id}'::text[]);

    ELSE 
    	v_formtabid = array_to_json('{tabInfo,tabFile}'::text[]);
	v_formtablabel = array_to_json('{Info,Files}'::text[]);
	v_formtabtext = array_to_json('{Info,Files}'::text[]);
	v_formtabtablename = array_to_json('{null,v_ui_om_visit_x_doc}'::text[]);
	v_formtabidname = array_to_json('{null,id}'::text[]);
	
    END IF;
    	
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formName', v_formheader);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formTabs', v_formtabid);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'tabLabel', v_formtablabel);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'tabText', v_formtabtext);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'tabTableName', v_formtabtablename);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'tabIdName', v_formtabidname);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formActions', v_formactions);




--  Control NULL's
	v_fields_json := COALESCE(v_fields_json, '{}');
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_tablename := COALESCE(v_tablename, '{}');
	v_id := COALESCE(v_id, '{}');
  
--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"form":'||v_forminfo||
			',"feature":{"featureType":"visit", "tableName":"'||v_tablename||'", "idname":"visit_id", "id":'||v_id||'}'||
			',"data":{"fields":' || v_fields_json || '}'||
			'}'||
	    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

