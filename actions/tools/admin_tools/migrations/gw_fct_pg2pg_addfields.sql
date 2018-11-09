/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2pg_addfields(table_aux text)
RETURNS void AS $BODY$


/*

Basics:
The goal of this function is to transform data of elements from one table to the element tables (element and element_x_feature)
Element catalog MUST HAVE ALL THE REGISTERS THAT WE NEED 
At maximum four parameters can be passed from feature table to element table

Procedure:
1- We need a table (or view) called 'table_aux' according with one of the four feature_type of Giswater 'tabletype_aux' (arc, node, connec, gully)
- 'table_aux' needs five fields (all of them text type)
feature_id
pg2pg_parameter_id
pg2pg_value_param
Data from this fields will be stored on the element table using the same fields

2- We need the catalog of elements fullfilled

4- A new element with serial id will be created with data provided by the table_aux:

EXAMPLE: SELECT gw_fct_pg2pg_om_event('v_pgp_node', 'node')

*/

DECLARE
 v_sql 		text;
 rec_table 	record;
 id_last  	bigint;
 

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    --Initiation of the process
	v_sql := 'SELECT * FROM '||table_aux||';';
	FOR rec_table IN EXECUTE v_sql

        LOOP

				INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) VALUES
				(rec_table.feature_id, rec_table.pg2pg_parameter_id, rec_table.pg2pg_value_param);
				
		END LOOP;


    RETURN;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;