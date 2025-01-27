/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_disabletrg(doenable boolean)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
mytables RECORD;
BEGIN
  FOR mytables IN SELECT distinct table_name FROM information_schema.tables t
join pg_class c on t.table_name=c.relname 
WHERE relhastriggers is true and t.table_schema='SCHEMA_NAME' and table_type='BASE TABLE'
  LOOP
    IF DoEnable THEN
      EXECUTE 'ALTER TABLE SCHEMA_NAME.' || mytables.table_name || ' ENABLE TRIGGER ALL';
    ELSE
      EXECUTE 'ALTER TABLE SCHEMA_NAME.' || mytables.table_name || ' DISABLE TRIGGER ALL';
    END IF;  
  END LOOP;

  RETURN 1;

END;
$function$
;