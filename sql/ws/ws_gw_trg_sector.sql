/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_sector() RETURNS trigger LANGUAGE plpgsql  AS
$BODY$
DECLARE 
    v_sql varchar;
    geom_column varchar;
    num_sectors integer;
    r record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    --Dynamic SQL
    v_sql := 'SELECT
                 tc.table_name,
                 kcu.column_name
             FROM 
                 information_schema.table_constraints AS tc JOIN
                 information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN
                 information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name
             WHERE
                 tc.constraint_type = ' || quote_literal('FOREIGN KEY') || ' AND
                 tc.constraint_schema=' || quote_literal(TG_TABLE_SCHEMA) || ' AND
                 tc.table_schema=' || quote_literal(TG_TABLE_SCHEMA) || ' AND
                 kcu.constraint_schema=' || quote_literal(TG_TABLE_SCHEMA) || ' AND                 
                 ccu.table_schema=' || quote_literal(TG_TABLE_SCHEMA) || ' AND
                 ccu.table_name=' || quote_literal('sector') || ' AND
                 ccu.column_name=' || quote_literal('sector_id');
                 

--RAISE EXCEPTION 'v_sql=%',  v_sql;


    --Loop for all the tables with a foreign key in sector_id
    FOR r IN EXECUTE v_sql
    LOOP

        --Find the geometry column name
        v_sql := 'SELECT f_geometry_column FROM geometry_columns WHERE f_table_schema=' || quote_literal(TG_TABLE_SCHEMA) || ' AND f_table_name=' || quote_literal(r.table_name); 
        EXECUTE v_sql INTO geom_column;

        --Check orphan
        v_sql := 'SELECT COUNT(*) FROM ' || quote_ident(r.table_name) || ' WHERE (SELECT COUNT(*) FROM sector WHERE ST_Intersects(' || quote_ident(r.table_name) || '.' || quote_ident(geom_column) || ', sector.the_geom) LIMIT 1)=0';
        EXECUTE v_sql INTO num_sectors;

        IF num_sectors > 0 THEN
	    RAISE NOTICE 'num_sectors= %', num_sectors;        
--	    RAISE EXCEPTION 'There are features in table % outside of the sector polygons', r.table_name;
	END IF;

        --Update sector id       
        v_sql := 'UPDATE ' || quote_ident(r.table_name) || ' SET ' || quote_ident(r.column_name) || ' = (SELECT sector_id FROM sector WHERE ST_Intersects(' || quote_ident(r.table_name) || '.' || quote_ident(geom_column) || ', sector.the_geom) LIMIT 1)';
        EXECUTE v_sql;
    
    END LOOP;

    RETURN NEW;
    

END;
$BODY$;


CREATE TRIGGER gw_trg_sector
 AFTER INSERT OR UPDATE OR DELETE
 ON "SCHEMA_NAME"."sector"

FOR EACH ROW
  EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_sector"();
