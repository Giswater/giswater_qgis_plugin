/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2776

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getprofile(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getprofile(p_data json)
  RETURNS json AS
$BODY$
DECLARE

/*

SELECT "SCHEMA_NAME".gw_fct_getprofile($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{},
"data":{"profile_id":"1", "action":"load"}}$$)


SELECT "SCHEMA_NAME".gw_fct_getprofile($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{},
"data":{"profile_id":"1", "action":"delete"}}$$)
*/  
    
	
--    Variables
    schemas_array name[];
    v_apiversion json;
    v_device integer;
    v_profile integer;
    v_profile_id text;
    v_message text;
    v_action text;
    v_load_result json;

    

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- Get json parameters
	v_device := ((p_data ->>'client')::json->>'device')::text;
	v_profile_id := ((p_data ->>'data')::json->>'profile_id')::text;
	v_action := ((p_data ->>'data')::json->>'action')::text;
	
	

	-- Get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
	INTO v_apiversion;

	IF v_action = 'delete' THEN
		EXECUTE 'DELETE FROM om_profile WHERE profile_id = ''' || v_profile_id ||'''';
		v_message := 'Profile deleted';
	ELSE
		EXECUTE 'SELECT values FROM om_profile WHERE profile_id = ''' || v_profile_id || '''' INTO v_load_result;
		v_message := 'Load profile successfully';
	END IF;

	-- Check null
	v_apiversion := COALESCE(v_apiversion, '[]');    
	v_load_result := COALESCE(v_load_result, '{}'); 

	--    Return
	RETURN ('{"status":"Accepted", "message":"'||v_message||'", "apiVersion":' || v_apiversion ||
	      ',"body":{"data":'||v_load_result||''||
			'}'||
		'}')::json;

	--    Exception handling
	--EXCEPTION WHEN OTHERS THEN 
	--RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;