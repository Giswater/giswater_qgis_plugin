/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2122


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".clone_schema(source_schema text, dest_schema text) RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    rec_view record;
    rec_fk record;
    rec_table text;
    tablename text;
    default_ text;
    column_ text;
    msg text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Create destination schema
    EXECUTE 'CREATE SCHEMA ' || dest_schema ;
     
    -- Sequences
    FOR rec_table IN
        SELECT sequence_name FROM information_schema.SEQUENCES WHERE sequence_schema = source_schema
    LOOP
        EXECUTE 'CREATE SEQUENCE ' || dest_schema || '.' || rec_table;
    END LOOP;
     
    -- Tables
    FOR rec_table IN
        SELECT table_name FROM information_schema.TABLES WHERE table_schema = source_schema AND table_type = 'BASE TABLE' ORDER BY table_name
    LOOP
      
        -- Create table in destination schema
        tablename := dest_schema || '.' || rec_table;
        EXECUTE 'CREATE TABLE ' || tablename || ' (LIKE ' || source_schema || '.' || rec_table || ' INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS)';
        
        -- Set contraints
        FOR column_, default_ IN
            SELECT column_name, REPLACE(column_default, source_schema, dest_schema) 
            FROM information_schema.COLUMNS 
            WHERE table_schema = dest_schema AND table_name = rec_table AND column_default LIKE 'nextval(%' || source_schema || '%::regclass)'
        LOOP
            EXECUTE 'ALTER TABLE ' || tablename || ' ALTER COLUMN ' || column_ || ' SET DEFAULT ' || default_;
        END LOOP;
        
        -- Copy table contents to destination schema
        EXECUTE 'INSERT INTO ' || tablename || ' SELECT * FROM ' || source_schema || '.' || rec_table; 	
        
    END LOOP;
        
    -- Views
    FOR rec_view IN
        SELECT table_name, REPLACE(view_definition, source_schema, dest_schema) as definition FROM information_schema.VIEWS WHERE table_schema = source_schema
    LOOP
        EXECUTE 'CREATE VIEW ' || dest_schema || '.' || rec_view.table_name || ' AS ' || rec_view.definition;
    END LOOP;

    PERFORM audit_function(0,2122);
    RETURN;
    
END;
$$;   
  
   