/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_fill_doc_tables()
  RETURNS void AS
$BODY$DECLARE

 rec_doc    record;
 rec_node   record;
 rec_arc   record;
 rec_connec   record;



BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;


    --Delete previous
    DELETE FROM doc_x_arc;
    DELETE FROM doc_x_connec;
    DELETE FROM doc_x_node;
    
      

        --doc
        FOR rec_doc IN SELECT * FROM doc
        LOOP

            --Insert arc
            FOR rec_arc IN SELECT * FROM arc
            LOOP
            INSERT INTO doc_x_arc (doc_id, arc_id) VALUES(rec_doc.id, rec_arc.arc_id);
            END LOOP;

            --Insert connec
            FOR rec_connec IN SELECT * FROM connec
            LOOP
            INSERT INTO doc_x_connec (doc_id, connec_id) VALUES(rec_doc.id, rec_connec.connec_id);
            END LOOP;

            --Insert node
            FOR rec_node IN SELECT * FROM node
            LOOP
            INSERT INTO doc_x_node (doc_id, node_id) VALUES(rec_doc.id, rec_node.node_id);
            END LOOP;


            
        END LOOP;


    RETURN;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
