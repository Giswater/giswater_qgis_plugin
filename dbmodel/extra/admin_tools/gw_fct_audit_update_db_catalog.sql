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
    

    SELECT max(id) INTO int_max_views FROM db_cat_view;
    SELECT max(id) INTO int_max_columns FROM db_cat_columns;
    SELECT max(id) INTO int_max_tables FROM db_cat_table;

    PERFORM setval('SCHEMA_NAME.db_cat_view_seq', int_max_views, true);
    PERFORM setval('SCHEMA_NAME.db_cat_columns_seq', int_max_columns, true);
    PERFORM setval('SCHEMA_NAME.db_cat_table_seq', int_max_tables, true);


    INSERT INTO db_cat_table (name, project_type)
	SELECT schema_table_name, 'ud&sew' FROM v_audit_schema_catalog_compare_table WHERE schema_table_name NOT LIKE 'v%';

    INSERT INTO db_cat_view (name, project_type)
	SELECT schema_table_name, 'ud&sew' FROM v_audit_schema_catalog_compare_table WHERE schema_table_name NOT IN (SELECT name FROM db_cat_view) AND schema_table_name LIKE 'v%' ;

    INSERT INTO db_cat_columns (db_cat_table_id, column_name, column_type)
	SELECT DISTINCT db_cat_table.id, audit_column, column_type
	FROM v_audit_schema_catalog_compare_column
	JOIN db_cat_table ON name=audit_table
	JOIN v_audit_schema_column ON column_name=audit_column;

   RETURN;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;;

