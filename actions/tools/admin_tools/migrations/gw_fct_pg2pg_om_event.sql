/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2pg_om_event(table_aux varchar, tabletype_aux varchar, visitcat_aux integer, startdate_aux date, enddate_aux date, parameter_aux varchar)
RETURNS void AS $BODY$

/*

Basics:
The goal of this function is to transform data of operations and management (o&m) from one table to the Visit catalog (om_visit_cat), Visit (om_visit) and Event (om_visit_event) strategy of giswater.
Visit catalog has startdate and enddate: i.e. 2016 clean campaign
Visit has startdate and enddate: i.e. one visit could be related to one feature or more features. One feature perharps one minute or one hour, a lot of features perhaps one month or more
Event has three basic fields: parameter, value and tstamp (to identify the real moment of the event).


Procedure:
1- We need a table (or view) called 'table_aux' according with one of the four feature_type of Giswater 'tabletype_aux' (arc, node, connec, gully)
- 'table_aux' needs three mandatory fields: 'id' 'pg2pg_value' and 'pg2pg_date'.
- 'id' must be arc_id/node_id/connec_id/gully_id in function of the feature_type choosed
- 'pg2pg_value' is the value of parameter (text type) and null values are enabled
- 'pg2pg_date' is the date of the parameter (date type) and null values are enabled
HINT: We can use a view to parse data from that pg2pg fields.....

2- We need the catalog of visits created on the table om_visit_cat
- visitcat_aux: 'id' of the catalog of visit that must exists before.
HINT: In case of migration the field name for the row of the catalog must be 'Data migration ora2pg'

3- We need the parameter created on the table om_visit_parameter
- parameter_aux: id of the parameter on table that must exists before.
HINT: In case of hydrant inspection, parameter should be: hydrant_inspection

4- A new visit with serial id will be created with:
- visitcat_id: from visitcat_aux
- startdate: from startdate_aux
- enddate: from enddate_aux

5- Related to the visit, a new event will be created with:
- parameter_id: from parameter_aux
- value: from pg2pg_value
- tstamp: from pg2pg_date

EXAMPLE: SELECT gw_fct_pg2pg_om_event('v_pgp_node', 'node', 1, '2001-01-01'::date, '2016-12-12'::date, 'hydrant_check')

*/

DECLARE
 v_sql 		text;
 rec_table 	record;
 id_last  	bigint;
 

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    --Initiation of the process
	v_sql := 'SELECT * FROM '||table_aux||' WHERE pg2pg_value IS NOT NULL AND pg2pg_date IS NOT NULL;';
	FOR rec_table IN EXECUTE v_sql

        LOOP
        -- Insert into visit table and visit_x_feature tables
        	IF tabletype_aux='arc' THEN
				INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(startdate_aux, enddate_aux, visitcat_aux, current_user) RETURNING id INTO id_last;
				INSERT INTO om_visit_x_arc (visit_id, arc_id) VALUES(id_last,rec_table.arc_id);
				
		ELSIF tabletype_aux='node' THEN 
				INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(startdate_aux, enddate_aux, visitcat_aux, current_user) RETURNING id INTO id_last;
				INSERT INTO om_visit_x_node (visit_id, node_id) VALUES(id_last,rec_table.node_id);
				
		ELSIF tabletype_aux='connec' THEN	
				INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(startdate_aux, enddate_aux, visitcat_aux, current_user) RETURNING id INTO id_last;
				INSERT INTO om_visit_x_connec (visit_id, connec_id) VALUES(id_last,rec_table.connec_id);
				
		ELSIF tabletype_aux='gully' THEN
				INSERT INTO om_visit (startdate, enddate, visitcat_id, user_name) VALUES(startdate_aux, enddate_aux, visitcat_aux, current_user) RETURNING id INTO id_last;
				INSERT INTO om_visit_x_gully (visit_id, gully_id) VALUES(id_last,rec_table.gully_id);
		END IF;	

       	-- Insert into event table				
		INSERT INTO om_visit_event (visit_id, parameter_id, value, tstamp) VALUES (id_last, parameter_aux, rec_table.pg2pg_value, rec_table.pg2pg_date);	    

        END LOOP;

    RETURN;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;