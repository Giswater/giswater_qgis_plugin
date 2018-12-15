-- Function: ws_sample.gw_api_getvisit(json)

-- DROP FUNCTION ws_sample.gw_api_getvisit(json);

CREATE OR REPLACE FUNCTION ws_sample.gw_api_getlistadd(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT ws_sample.gw_api_getlistadd($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"tablename":"v_ui_"},
"data":{}}$$)
*/

DECLARE
	v_apiversion text;
	v_tablename text;
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
    v_tablename = ((p_data ->>'feature')::json->>'tableName')::text;


--  get form fields
    IF v_id IS NULL THEN
	SELECT gw_api_get_formfields( v_tablename, 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;
	
	-- define the text of header
	v_formheader := 'VISIT';	
    ELSE 
	SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'UPDATE', null, v_device) INTO v_fields;

		
	-- define the text of header
	v_formheader :=concat('VISIT - ',v_id);	
    END IF;

       v_fields_json = array_to_json (v_fields);

       RAISE NOTICE 'v_fields_json %', v_fields_json;

   
-- building the form     
    	v_formtabid = array_to_json('{tabInfo,tabFile}'::text[]);
	v_formtablabel = array_to_json('{Info,Files}'::text[]);
	v_formtabtext = array_to_json('{Info,Files}'::text[]);
	v_formtabtablename = array_to_json('{null,v_ui_om_visit_x_doc}'::text[]);
	v_formtabidname = array_to_json('{null,id}'::text[]);
	
    	
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
ALTER FUNCTION ws_sample.gw_api_getvisit(json)
  OWNER TO geoadmin;
