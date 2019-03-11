/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 1138



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_doc() RETURNS trigger AS $BODY$
DECLARE 
    doc_table varchar;
    v_sql varchar;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    doc_table:= TG_ARGV[0];

    IF TG_OP = 'INSERT' THEN
        IF doc_table = 'doc_x_arc' THEN
            INSERT INTO doc_x_arc (arc_id,doc_id) VALUES (NEW.arc_id,NEW.doc_id);
        ELSIF doc_table = 'doc_x_node' THEN
            INSERT INTO doc_x_node (node_id,doc_id)  VALUES (NEW.node_id,NEW.doc_id);
        ELSIF doc_table = 'doc_x_connec' THEN
            INSERT INTO doc_x_connec (connec_id,doc_id)  VALUES (NEW.connec_id,NEW.doc_id);
        ELSIF doc_table = 'doc_x_gully' THEN
            INSERT INTO doc_x_gully (gully_id,doc_id)  VALUES (NEW.gully_id,NEW.doc_id);
        ELSIF doc_table = 'doc_x_visit' THEN
            INSERT INTO doc_x_gully (visit_id,doc_id)  VALUES (NEW.visit_id,NEW.doc_id);
         -- PERFORM audit_function(1); 
        END IF;
        --	PERFORM audit_function(1); 
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        --	PERFORM audit_function(2); 
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

            v_sql:= 'DELETE FROM '||doc_table||' WHERE id = '||quote_literal(OLD.id)||';';
            EXECUTE v_sql;  

        RETURN NULL; 
          --    PERFORM audit_function(3); 
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  

      