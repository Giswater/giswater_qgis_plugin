/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_db_columns() RETURNS void AS $BODY$ 

DECLARE
    rec_tables  	record;
    rec_columns  	record;
   
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    --Delete previous
    DELETE FROM audit_db_columns;
    
    -- Loop into schema
    FOR rec_tables IN SELECT * FROM pg_tables WHERE schemaname = 'SCHEMA_NAME'
    LOOP
	-- Loop into table
		FOR rec_columns IN SELECT * From pg_namespace, pg_attribute, pg_type, pg_class
		Where pg_type.oid = atttypid 
		AND pg_class.oid = attrelid 
		AND pg_namespace.nspname ='SCHEMA_NAME' 
		AND relname =rec_tables.tablename 
		AND relnamespace = pg_namespace.oid 
		AND attnum >= 1
		AND (atttypid > 29 or atttypid < 26)
		LOOP
			INSERT INTO audit_db_columns (table_name, column_name, column_type) VALUES (rec_tables.tablename, rec_columns.attname, rec_columns.typname);
		END LOOP;
    END LOOP;
    RETURN;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  
  

