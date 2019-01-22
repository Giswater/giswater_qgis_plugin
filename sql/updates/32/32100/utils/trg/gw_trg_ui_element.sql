/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1140

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_element() RETURNS trigger AS $BODY$
DECLARE 
    element_table varchar;
    v_sql varchar;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    element_table:= TG_ARGV[0];


    IF TG_OP = 'INSERT' THEN
        IF element_table = 'element_x_arc' THEN
            INSERT INTO element_x_arc (arc_id,element_id) VALUES (NEW.arc_id,NEW.element_id);
        ELSIF element_table = 'element_x_node' THEN
            INSERT INTO element_x_node (node_id,element_id)  VALUES (NEW.node_id,NEW.element_id);
        ELSIF element_table = 'element_x_connec' THEN
            INSERT INTO element_x_connec (connec_id,element_id)  VALUES (NEW.connec_id,NEW.element_id);
        ELSIF element_table = 'element_x_gully' THEN
            INSERT INTO element_x_gully (gully_id,element_id)  VALUES (NEW.gully_id,NEW.element_id);
         -- PERFORM audit_function(1); 
        END IF;


   -- ELSIF TG_OP = 'UPDATE' THEN
        --  PERFORM audit_function(2); 
        ---RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        IF element_table='element' THEN
            v_sql:= 'DELETE FROM '||element_table||' WHERE element_id = '||quote_literal(OLD.id)||';';
            EXECUTE v_sql;
        ELSE
            v_sql:= 'DELETE FROM '||element_table||' WHERE id = '||quote_literal(OLD.id)||';';
            EXECUTE v_sql;
         END IF;
    --  PERFORM audit_function(3); 
        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  

  


