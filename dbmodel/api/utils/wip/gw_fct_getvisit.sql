-- Function: ws_sample.gw_api_getvisit(json)

-- DROP FUNCTION ws_sample.gw_api_getvisit(json);

CREATE OR REPLACE FUNCTION ws_sample.gw_api_getvisit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

SELECT ws_sample.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"arc", "visit_id":null},
"data":{"visitclass_id":null}}$$)
*/

DECLARE
	v_apiversion text;
	v_schemaname text;
	v_featuretype text;
	v_visitclass integer;
	v_visit integer;
	v_device integer;
	v_formname text;
	v_tablename text;
	v_fields json [];
	v_fields_json json;

BEGIN

-- Set search path to local schema
    SET search_path = "ws_sample", public;
    v_schemaname := 'ws_sample';

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

--  get parameters from input
    v_device = ((p_data ->>'client')::json->>'device')::integer;
    v_featuretype = ((p_data ->>'feature')::json->>'featureType');
    v_visit = ((p_data ->>'feature')::json->>'visit_id')::integer;
    v_visitclass = ((p_data ->>'data')::json->>'visitclass_id')::integer;



    IF v_visitclass IS NULL THEN
	--  get visitclass vdefault
	v_visitclass := (SELECT value FROM config_param_user WHERE parameter = concat('visitclass_vdefault_', v_featuretype) AND cur_user=current_user)::integer;
    END IF;

    IF v_visitclass IS NULL THEN
	v_visitclass := 6;
    END IF;


--  get formname and tablename
    v_formname := (SELECT formname FROM config_api_visit WHERE visitclass_id=v_visitclass);
    v_tablename := (SELECT tablename FROM config_api_visit WHERE visitclass_id=v_visitclass);

    RAISE NOTICE 'featuretype:%,  visitclass:%,  visitclass:%,  formname:%,  tablename:%,  device:%',v_featuretype, v_visitclass, v_visit, v_formname, v_tablename, v_device;
    
--  get form fields
    IF v_visit IS NULL THEN
	SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'INSERT', null, v_device) INTO v_fields;
    ELSE 
	SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'UPDATE', null, v_device) INTO v_fields;
    END IF;

    v_fields_json = array_to_json (v_fields);

--  Control NULL's
    v_fields_json := COALESCE(v_fields_json, '{}');
    v_apiversion := COALESCE(v_apiversion, '{}');
    v_tablename := COALESCE(v_tablename, '{}');
  
--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"form":{"formName":"", "formHeaderText":"", "formBodyText":""}'||
			',"feature":{"featureType":"'||v_featuretype||'", "tableName":"'||v_tablename||'", "id":'||v_visit||'"}'||
			',"data":{"fields":' || v_fields_json || '}'||
			'}'||
	    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_sample.gw_api_getvisit(json)
  OWNER TO geoadmin;
