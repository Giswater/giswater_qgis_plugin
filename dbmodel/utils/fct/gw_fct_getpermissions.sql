/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2596

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getpermissions(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getpermissions(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
 'SELECT gw_fct_getpermissions($${"tableName":"v_arc_pipe"}$$::json)'
*/

DECLARE

v_version text;
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
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	--    Get schema name
    schemas_array := current_schemas(FALSE);

    -- table to search
    v_table := p_data->>'tableName';

    EXECUTE 'select array_agg(row_to_json(a)) FROM (SELECT privilege_type FROM information_schema.role_table_grants where table_name=$1 and table_schema=$2 and grantee IN (SELECT rolname FROM pg_roles WHERE pg_has_role( current_user, oid, ''member'')) LIMIT 1)a'
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

    v_version := COALESCE(v_version, '');
    v_permissions := COALESCE(v_permissions, '{}');
 
	-- Return
	RETURN ('{"status":"Accepted"' ||
		', "version":"'|| v_version ||'"'||
		', "tableName":"'|| v_table ||'"'||
		', "isEditable":' || v_iseditable ||
		', "permissions":'|| v_permissions||
		'}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
