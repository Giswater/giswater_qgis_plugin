-- Function: ws_sample.gw_api_getvisit(json)

-- DROP FUNCTION ws_sample.gw_api_getvisit(json);

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
	v_formactions json;
	v_formtabs text;
	v_tabaux json;
	v_active boolean;

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

    RAISE NOTICE 'featuretype:%,  visitclass:%,  v_visit:%,  formname:%,  tablename:%,  device:%',v_featuretype, v_visitclass, v_id, v_formname, v_tablename, v_device;

    v_formactions = '[	{"actionName":"actionAdd","actionTooltip":"Add"}, {"actionName":"actionDelete","actionTooltip":"Delete"}]';
    
--  Create tabs array
    v_formtabs := '[';
       
		-- Data tab
		IF v_id IS NULL THEN
			SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;
		
			-- define the text of header
			v_formheader := 'VISIT';	
		ELSE 
			SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'UPDATE', null, v_device) INTO v_fields;
				
			-- define the text of header
			v_formheader :=concat('VISIT - ',v_id);	
		END IF;	
	
		v_fields_json = array_to_json (v_fields);
	
		-- building tab
		v_tabaux := json_build_object('tabName','tabInfo','tabLabel','Info Basica','tabText','Test text for tab','active',true, 'tableName', null);
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs || v_tabaux::text;

		-- Events tab
		IF v_visitclass=0 THEN
			v_active = true;
		ELSE 
			v_active = false;
		END IF;
		-- building tab
		v_tabaux := json_build_object('tabName','tabEvent','tabLabel','Events','tabText','Test text for tab','active',v_active, 'tableName', null);
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs || ',' || v_tabaux::text;

		-- Files tab
		-- building tab
		v_tabaux := json_build_object('tabName','tabFile','tabLabel','Files','tabText','Test text for tab','active',true, 'tableName', 'v_ui_om_visit_x_doc');
		v_tabaux := gw_fct_json_object_set_key(v_tabaux, 'fields', v_fields_json);
		v_formtabs := v_formtabs  || ',' || v_tabaux::text;

		v_formtabs := (v_formtabs ||']');

--	Create new form
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formId', 'F11'::text);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formName', 'Nova visita'::text);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formTabs', v_formtabs::json);
	v_forminfo := gw_fct_json_object_set_key(v_forminfo, 'formActions', v_formactions);

--  Control NULL's
	v_fields_json := COALESCE(v_fields_json, '{}');
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_tablename := COALESCE(v_tablename, '{}');
	v_id := COALESCE(v_id, '{}');
  
--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"feature":{"featureType":"visit", "tableName":"'||v_tablename||'", "idname":"visit_id", "id":'||v_id||'}'||
		    ', "form":'||v_forminfo||
		     ',"data":{}'||
			'}'||
	    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_sample.gw_api_getvisit(json)
  OWNER TO geoadmin;
