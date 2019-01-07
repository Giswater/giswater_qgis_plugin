/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_visit() RETURNS trigger AS $BODY$
DECLARE 
    visit_table varchar;
    v_sql varchar;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    visit_table:= TG_ARGV[0];


    IF TG_OP = 'INSERT' THEN
        IF visit_table = 'visit_x_arc' THEN
            INSERT INTO om_visit_x_arc (arc_id,visit_id) VALUES (NEW.arc_id,NEW.visit_id);
        ELSIF visit_table = 'visit_x_node' THEN
            INSERT INTO om_visit_x_node (node_id,visit_id)  VALUES (NEW.node_id,NEW.visit_id);
        ELSIF visit_table = 'visit_x_connec' THEN
            INSERT INTO om_visit_x_connec (connec_id,visit_id)  VALUES (NEW.connec_id,NEW.visit_id);
        ELSIF visit_table = 'visit_x_gully' THEN
            INSERT INTO om_visit_x_gully (gully_id,visit_id)  VALUES (NEW.gully_id,NEW.visit_id);
         -- PERFORM audit_function(1); 
        END IF;


   -- ELSIF TG_OP = 'UPDATE' THEN
        --  PERFORM audit_function(2); 
        ---RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        IF visit_table='visit' THEN
            v_sql:= 'DELETE FROM '||visit_table||' WHERE id = '||quote_literal(OLD.id)||';';
            EXECUTE v_sql;
        ELSE
            v_sql:= 'DELETE FROM '||visit_table||' WHERE visit_id = '||quote_literal(OLD.id)||';';
            EXECUTE v_sql;
         END IF;
    --  PERFORM audit_function(3); 
        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  

  

