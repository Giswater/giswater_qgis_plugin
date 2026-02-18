/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

/*
FUNCTION: gw_fct_utils_owner_all(schema_name, new_owner)

PURPOSE:
  Transfers ownership of all database objects within a specified schema to a new role.
  This utility is essential for schema administration tasks such as role migrations,
  permission restructuring, and post-import ownership corrections.

PARAMETERS:
  - schema_name (character varying): Name of the schema containing objects to reassign
  - new_owner (character varying): Name of the role that will become the owner

RETURN:
  boolean: TRUE on successful completion, raises exception on failure

HANDLES:
  - Tables
  - Views
  - Sequences
  - Functions

EXAMPLE USAGE:
  SELECT gw_fct_utils_owner_all('ws', 'role_system');

NOTES:
  - The executing user must own the objects or be a superuser
  - The target role (new_owner) must already exist in the database
  - Ownership transfer is performed in order: Tables → Views → Sequences → Functions
  - If any ALTER statement fails, the function will halt and raise an exception

COMPATIBLE VERSIONS:
  PostgreSQL 8.0+ (quote_ident support required)
*/

CREATE OR REPLACE FUNCTION gw_fct_utils_owner_all(schema_name character varying, new_owner character varying)
  RETURNS boolean AS
$BODY$

DECLARE
    rec_object  record;
	
BEGIN

	-- Tables
	FOR rec_object IN 
		SELECT * FROM pg_tables 
		WHERE schemaname = schema_name 
		ORDER BY tablename 
	LOOP
        EXECUTE 'ALTER TABLE '||schema_name||'.'||quote_ident(rec_object.tablename)||' OWNER TO '||quote_ident(new_owner);
	END LOOP;
	
	-- Views
	FOR rec_object IN 
		SELECT * FROM pg_views 
		WHERE schemaname = schema_name 
	LOOP
        EXECUTE 'ALTER TABLE '||schema_name||'.'||quote_ident(rec_object.viewname)||' OWNER TO '|| quote_ident(new_owner);
	END LOOP;

	-- Sequences
	FOR rec_object IN 
		SELECT c.relname, u.usename, n.nspname
		FROM pg_class c, pg_user u, pg_namespace n
		WHERE c.relowner = u.usesysid 
			AND n.oid = c.relnamespace
			AND c.relkind = 'S' 
			AND n.nspname = schema_name
			AND relnamespace IN (
					SELECT oid
					FROM pg_namespace
					WHERE nspname NOT LIKE 'pg_%'
					AND nspname != 'information_schema'
				)
	LOOP
        EXECUTE 'ALTER TABLE '||schema_name||'.'||quote_ident(rec_object.relname)||' OWNER TO '|| quote_ident(new_owner);
	END LOOP;
  	
	-- Functions
	FOR rec_object IN 
		SELECT 
		    routine_schema AS schema,
		    routine_name AS function_name,
		    data_type AS return_type
	    FROM 
	    	information_schema.routines
		WHERE 
		    routine_schema = schema_name
	LOOP
        EXECUTE 'ALTER FUNCTION  '||schema_name||'.'||quote_ident(rec_object.function_name)||' OWNER TO '||quote_ident(new_owner);
	END LOOP;


	RETURN TRUE;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;