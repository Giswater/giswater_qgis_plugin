/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:2964

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getprofile(p_data json)
  RETURNS json AS
$BODY$
DECLARE

/*

SELECT "SCHEMA_NAME".gw_fct_getprofile($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{},
"data":{}}$$)

*/


--    Variables
    schemas_array name[];
    v_version text;
    v_device integer;
    v_profile integer;
    v_message text;
    v_action text;
    v_load_result json;
    v_load_result_array json[];



BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- Get json parameters
	v_device := ((p_data ->>'client')::json->>'device')::text;

	-- Get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT profile_id ,values FROM om_profile ORDER BY profile_id)a' INTO v_load_result_array;
	v_message := 'Load profiles successfully';

	-- Check null
	v_version := COALESCE(v_version, '');
	v_load_result_array := COALESCE(v_load_result_array, '{}');
	v_load_result := array_to_json(v_load_result_array);

	-- Return
	RETURN ('{"status":"Accepted", "message":"'||v_message||'", "version":"' || v_version || '"' ||
	      ',"body":{"data":'||v_load_result||''||
			'}'||
		'}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE)::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
