/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION gw_fct_utils_owner_all(    SCHEMA_NAME character varying,    cur_owner character varying,    new_owner character varying)
  RETURNS boolean AS
$BODY$
DECLARE
    rec_object  record;
	
BEGIN

	-- Tables
	FOR rec_object IN 
		SELECT * FROM pg_tables 
		WHERE schemaname = SCHEMA_NAME 
		AND tableowner = cur_owner
		ORDER BY tablename 
	LOOP
        EXECUTE 'ALTER TABLE '||SCHEMA_NAME||'.'||quote_ident(rec_object.tablename)||' OWNER TO '||quote_ident(new_owner);
	END LOOP;
	
	-- Views
	FOR rec_object IN 
		SELECT * FROM pg_views 
		WHERE schemaname = SCHEMA_NAME 
		AND viewowner = cur_owner
	LOOP
        EXECUTE 'ALTER TABLE '||SCHEMA_NAME||'.'||quote_ident(rec_object.viewname)||' OWNER TO '|| quote_ident(new_owner);
	END LOOP;

	-- Sequences
	FOR rec_object IN 
		SELECT c.relname, u.usename, n.nspname
		FROM pg_class c, pg_user u, pg_namespace n
		WHERE c.relowner = u.usesysid 
			AND n.oid = c.relnamespace
			AND c.relkind = 'S' 
			AND u.usename = cur_owner
			AND n.nspname = SCHEMA_NAME
			AND relnamespace IN (
					SELECT oid
					FROM pg_namespace
					WHERE nspname NOT LIKE 'pg_%'
					AND nspname != 'information_schema'
				)
	LOOP
        EXECUTE 'ALTER TABLE '||SCHEMA_NAME||'.'||quote_ident(rec_object.relname)||' OWNER TO '|| quote_ident(new_owner);
	END LOOP;
  
	RETURN TRUE;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;