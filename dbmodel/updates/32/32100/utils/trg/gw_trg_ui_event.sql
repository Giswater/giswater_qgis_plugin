/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_event() RETURNS trigger AS $BODY$
DECLARE 
    event_table varchar;
    v_sql varchar;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    event_table:= TG_ARGV[0];


    IF TG_OP = 'INSERT' THEN


   -- ELSIF TG_OP = 'UPDATE' THEN
        --  PERFORM audit_function(2); 
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

            v_sql:= 'DELETE FROM '||event_table||' WHERE id = '||quote_literal(OLD.event_id)||';';
            EXECUTE v_sql;
    --  PERFORM audit_function(3); 
        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  

  
DROP TRIGGER IF EXISTS gw_trg_ui_event_x_node ON "SCHEMA_NAME".ve_ui_event_x_node;
CREATE TRIGGER gw_trg_ui_event_x_node INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_event_x_node
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_event(om_visit_event);

DROP TRIGGER IF EXISTS gw_trg_ui_event_x_arc ON "SCHEMA_NAME".ve_ui_event_x_arc;
CREATE TRIGGER gw_trg_ui_event_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_event_x_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_event(om_visit_event);

DROP TRIGGER IF EXISTS gw_trg_ui_event_x_connec ON "SCHEMA_NAME".ve_ui_event_x_connec;
CREATE TRIGGER gw_trg_ui_event_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_event_x_connec
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_event(om_visit_event);

DROP TRIGGER IF EXISTS gw_trg_ui_event ON "SCHEMA_NAME".ve_ui_event;
CREATE TRIGGER gw_trg_ui_event INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_ui_event
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_ui_event(om_visit_event);
