/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_truncatetables()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
mytables RECORD;
BEGIN
  FOR mytables IN SELECT distinct table_name FROM information_schema.tables t
join pg_class c on t.table_name=c.relname 
WHERE t.table_schema='SCHEMA_NAME' and table_type='BASE TABLE' and t.table_name <> 'temp_table'
  LOOP
      EXECUTE 'TRUNCATE TABLE SCHEMA_NAME.' || mytables.table_name || '';
  END LOOP;

  RETURN 1;

END;
$function$
;