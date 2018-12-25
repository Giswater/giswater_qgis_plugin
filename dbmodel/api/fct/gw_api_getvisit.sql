-- Function: SCHEMA_NAME.gw_api_getvisit(json)

-- DROP FUNCTION SCHEMA_NAME.gw_api_getvisit(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getvisit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "visit_id":null},
"data":{"type":"arc", "id":"2001"}}$$)

SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "visit_id":null},
"data":{"type":"", "id":""}}$$)

SELECT SCHEMA_NAME.gw_api_getvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "visit_id":1001},
"data":{"type":"arc"}}$$)

SELECT SCHEMA_NAME.gw_api_getvisit($${
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
	v_featureid varchar ;
	aux_json json;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

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
		v_visitclass := (SELECT class_id FROM SCHEMA_NAME.om_visit WHERE id=v_id::bigint);
		IF v_visitclass IS NULL THEN
			v_visitclass := 0;
		END IF;
	END IF;

	--  get formname and tablename
	v_formname := (SELECT formname FROM config_api_visit WHERE visitclass_id=v_visitclass);
	v_tablename := (SELECT tablename FROM config_api_visit WHERE visitclass_id=v_visitclass);

	RAISE NOTICE 'featuretype:%,  visitclass:%,  v_visit:%,  formname:%,  tablename:%,  device:%',v_featuretype, v_visitclass, v_id, v_formname, v_tablename, v_device;
   
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
					PERFORM setval('SCHEMA_NAME.audit_check_project_id_seq', (SELECT max(id)+1 FROM om_visit), true);
					v_id = nextval('SCHEMA_NAME.audit_check_project_id_seq');
					v_fields[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(v_fields[(aux_json->>'orderby')::INT], 'value', v_id);	
				END IF;
			END LOOP;
		ELSE 
			SELECT gw_api_get_formfields( v_formname, 'visit', 'data', null, null, null, null, 'UPDATE', null, v_device) INTO v_fields;
		END IF;	
		v_fields_json = array_to_json (v_fields);
		
		-- building tab
		v_tabaux := json_build_object('tabName','tabInfo','tabLabel','Info Basica','tabText','Test text for tab','active',true);
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
		v_tabaux := json_build_object('tabName','tabFile','tabLabel','Files','tabText','Test text for tab','active',false, 'list','{"tableName":"om_visit_file", "idName":"id"}');
		v_formtabs := v_formtabs  || ',' || v_tabaux::text;

		v_formtabs := (v_formtabs ||']');

	-- form actions
	v_formactions = '[{"actionName":"actionAdd","actionTooltip":"Add"}, {"actionName":"actionDelete","actionTooltip":"Delete"}]';

	-- define the text of header
	v_formheader :=concat('VISIT - ',v_id);	

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
  
	-- Return
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
ALTER FUNCTION SCHEMA_NAME.gw_api_getvisit(json)
  OWNER TO geoadmin;
