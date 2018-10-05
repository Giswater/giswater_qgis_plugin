/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2pg_element(table_aux text, tabletype_aux text)
RETURNS void AS $BODY$


/*

Basics:
The goal of this function is to transform data of elements from one table to the element tables (element and element_x_feature)
Element catalog MUST HAVE ALL THE REGISTERS THAT WE NEED 
At maximum four parameters can be passed from feature table to element table

Procedure:
1- We need a table (or view) called 'table_aux' according with one of the four feature_type of Giswater 'tabletype_aux' (arc, node, connec, gully)
- 'table_aux' needs five fields (all of them text type)
feature_id (it means arc_id, node_id, connec_id or gully_id, it depens...)
pg2pg_elementcat_id. Mandatory
pg2pg_observ
pg2pg_comment
pg2pg_num_elements
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
        -- Insert into element table and element_x_feature tables
        	IF tabletype_aux='arc' THEN
				INSERT INTO element (element_id, elementcat_id,observ, comment, num_elements) VALUES
				((SELECT nextval('urn_id_seq')), rec_table.pg2pg_elementcat_id, rec_table.pg2pg_observ, rec_table.pg2pg_comment, rec_table.pg2pg_num_elements) RETURNING element_id INTO id_last;
				INSERT INTO element_x_arc (element_id, arc_id) VALUES(id_last,rec_table.arc_id);
				
		ELSIF tabletype_aux='node' THEN 
				INSERT INTO element (element_id, elementcat_id,observ, comment, num_elements) VALUES
				((SELECT nextval('urn_id_seq')), rec_table.pg2pg_elementcat_id, rec_table.pg2pg_observ, rec_table.pg2pg_comment, rec_table.pg2pg_num_elements) RETURNING element_id INTO id_last;
				INSERT INTO element_x_node (element_id, node_id) VALUES(id_last,rec_table.node_id);
				
		ELSIF tabletype_aux='connec' THEN	
				INSERT INTO element (element_id, elementcat_id,observ, comment, num_elements) VALUES
				((SELECT nextval('urn_id_seq')), rec_table.pg2pg_elementcat_id, rec_table.pg2pg_observ, rec_table.pg2pg_comment, rec_table.pg2pg_num_elements) RETURNING element_id INTO id_last;
				INSERT INTO element_x_connec (element_id, connec_id) VALUES(id_last,rec_table.connec_id);
				
		ELSIF tabletype_aux='gully' THEN
				INSERT INTO element (element_id, elementcat_id,observ, comment, num_elements) VALUES
				((SELECT nextval('urn_id_seq')), rec_table.pg2pg_elementcat_id, rec_table.pg2pg_observ, rec_table.pg2pg_comment, rec_table.pg2pg_num_elements) RETURNING element_id INTO id_last;
				INSERT INTO element_x_gully (element_id, gully_id) VALUES(id_last,rec_table.gully_id);
		END IF;	

        END LOOP;

    RETURN;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;