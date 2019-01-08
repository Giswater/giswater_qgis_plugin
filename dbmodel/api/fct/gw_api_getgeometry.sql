/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2632


CREATE OR REPLACE FUNCTION ws_sample.gw_api_getgeometry(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT ws_sample.gw_api_getgeometry($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"arc", "id":"2001"},
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
	v_feature json;

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
	v_id = ((p_data ->>'feature')::json->>'id')::integer;
	v_featuretype = ((p_data ->>'feature')::json->>'featureType')::varchar;
	v_feature = ((p_data ->>'feature')::json;

	-- getting geometry
	
	
	
	--  Control NULL's
	v_fields_json := COALESCE(v_fields_json, '{}');
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_tablename := COALESCE(v_tablename, '{}');
	v_id := COALESCE(v_id, '{}');
	v_bottom_json := COALESCE(v_bottom_json, '{}');

  
	-- Return
	RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"feature":'||v_feature||
					 ',"data":{"geometry":v}}'||
	    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
