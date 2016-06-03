-- Function created to add defined rows into timeseries in order to import (using GIS joint table) timeseries data from csv file
-- To use
-- 1. Load using SQL FILE LAUNCHER of Giswater
-- 2. Write into sql console: SELECT insert_timser_rows (number of rows, 'timeseries_id')
--	  number of rows: number of rows you like create
--    timeseries_id: Name of the timeseries you like. If you don't have it, please create the timeseries first

CREATE or REPLACE FUNCTION SCHEMA_NAME.insert__PARAMTABLENAME__rows(row_number integer) returns void LANGUAGE plpgsql AS $$
DECLARE
    max_number integer;

BEGIN
    SELECT max(id) INTO max_number FROM "SCHEMA_NAME"._PARAMTABLENAME_;
    PERFORM setval('SCHEMA_NAME._PARAMTABLENAME__id_seq',max_number);
    -- Loop
    FOR i IN 1..row_number 
    LOOP
        i = i+1;
        -- Insert new registres into _PARAMTABLENAME_ table
        INSERT INTO SCHEMA_NAME._PARAMTABLENAME_ VALUES(nextval('SCHEMA_NAME._PARAMTABLENAME__id_seq'::regclass),'');
    END LOOP;
        
END;
$$;