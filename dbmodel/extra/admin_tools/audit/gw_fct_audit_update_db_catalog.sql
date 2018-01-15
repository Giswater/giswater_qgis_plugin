/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_schema_update_db_catalog()  RETURNS void AS $BODY$ 
DECLARE
int_max_views integer;
int_max_columns integer;
int_max_tables integer;


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
    

    INSERT INTO audit_cat_table (id)
	SELECT schema_table_name FROM v_audit_schema_catalog_compare_table WHERE schema_table_name NOT LIKE 'v%';

/*
    INSERT INTO audit_cat_table_x_column (id, table_id, column_id)
	SELECT DISTINCT concat(audit_cat_table.id,'_',audit_column),audit_cat_table.id, audit_column
	FROM v_audit_schema_catalog_compare_column
	JOIN audit_cat_table ON id=audit_table
	JOIN v_audit_schema_column ON column_name=audit_column;
*/
   RETURN;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;;

