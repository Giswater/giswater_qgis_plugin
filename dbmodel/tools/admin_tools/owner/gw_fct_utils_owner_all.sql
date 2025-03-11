/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

/*
SELECT ws_36.gw_fct_utils_owner_all('ws', 'role_system')
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