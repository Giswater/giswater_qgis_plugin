DROP FUNCTION SCHEMA_NAME.gw_fct_fill_doc_tables();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_fill_doc_tables()
  RETURNS void AS
$BODY$DECLARE

 rec_doc    record;
 rec_node   record;
 rec_arc   record;
 rec_connec   record;
 rec_gully   record;
 rec_visit   record;


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;


    --Delete previous
    DELETE FROM doc_x_arc;
    DELETE FROM doc_x_connec;
    DELETE FROM doc_x_node;
    DELETE FROM doc_x_gully;
    DELETE FROM doc_x_visit;
    
      

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


            --Insert gully
            FOR rec_gully IN SELECT * FROM gully
            LOOP
            INSERT INTO doc_x_gully (doc_id, gully_id) VALUES(rec_doc.id, rec_gully.gully_id);
            END LOOP;

            --Insert visit
            FOR rec_visit IN SELECT * FROM om_visit
            LOOP
            INSERT INTO doc_x_visit (doc_id, visit_id) VALUES(rec_doc.id, rec_visit.id);
            END LOOP;
            
        END LOOP;


    RETURN;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_fill_doc_tables()
  OWNER TO geoadmin;
