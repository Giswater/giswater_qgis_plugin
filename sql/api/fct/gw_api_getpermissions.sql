/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2596

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getpermissions(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
 'SELECT gw_api_getpermissions($${"tableName":"v_arc_pipe"}$$::json)'
*/

DECLARE

--	Variables
	api_version json;
	v_permissions json;
	v_permissions_array json[];
	schemas_array name[];
	v_table text;	
	v_iseditable boolean;
	v_select text;
	

BEGIN


-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO api_version;

--    Get schema name
    schemas_array := current_schemas(FALSE);

    -- table to search
    v_table := p_data->>'tableName';

-- 
    EXECUTE 'select array_agg(row_to_json(a)) FROM (SELECT privilege_type FROM information_schema.role_table_grants where table_name=$1 and table_schema=$2 and grantee=current_user)a'
	INTO v_permissions_array
	USING v_table, schemas_array[1];

    EXECUTE 'SELECT privilege_type FROM information_schema.role_table_grants where table_name=$1 and table_schema=$2 and grantee=current_user LIMIT 1'
	INTO v_select
	USING v_table, schemas_array[1];

    IF v_select='SELECT' OR v_permissions_array IS NULL THEN 
	v_iseditable=false;
    ELSE
       	v_iseditable=true;
    END IF;

    v_permissions = array_to_json (v_permissions_array);

    api_version := COALESCE(api_version, '{}');
    v_permissions := COALESCE(v_permissions, '{}');


 
-- Return
	RETURN ('{"status":"Accepted"' ||
		', "apiVersion":'|| api_version ||
		', "tableName":"'|| v_table ||'"'||
		', "isEditable":' || v_iseditable ||
		', "permissions":'|| v_permissions||
		'}')::json;


-- Exception handling
--	EXCEPTION WHEN OTHERS THEN 
		--RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
