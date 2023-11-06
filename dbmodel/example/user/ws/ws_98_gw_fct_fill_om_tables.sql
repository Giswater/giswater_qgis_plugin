/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2888

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_fill_om_tables()
  RETURNS void AS
$BODY$
DECLARE

 rec_node   record;
 rec_arc   record;
 rec_connec   record;
 rec_parameter record;
 id_last   bigint;
 id_event_last bigint;



BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;


    --Delete previous
    DELETE FROM om_visit_event_photo CASCADE;
    DELETE FROM om_visit_event CASCADE;
    DELETE FROM om_visit CASCADE;
    DELETE FROM om_visit_x_arc;
    DELETE FROM om_visit_x_node;
    DELETE FROM om_visit_x_connec;
    DELETE FROM om_visit_cat CASCADE;


  --Insert Catalog of visit
    INSERT INTO om_visit_cat (id, name, startdate, enddate) VALUES(1, 'Test', now(), (now()+'1hour'::INTERVAL * ROUND(RANDOM() * 5)));
         
   --ARCS
    FOR rec_arc IN SELECT * FROM arc WHERE state=1
    LOOP
        --visit class 1. leak_arc
        INSERT INTO ve_visit_arc_leak (visit_id, arc_id, visitcat_id, startdate, enddate, user_name, expl_id, class_id, status, leak_arc, insp_observ, photo) 
        VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_arc.arc_id, 1, now(), now(), 'postgres', rec_arc.expl_id, 1, 1, 'Minor leak', 'No other problems', False);
    END LOOP;
   
   --CONNECS
    FOR rec_connec IN SELECT * from connec WHERE state=1
    LOOP
        --visit class 2. leak connec
        INSERT INTO ve_visit_connec_leak (visit_id, connec_id, visitcat_id, startdate, enddate, user_name, expl_id, class_id, status, leak_connec, insp_observ, photo) 
        VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_connec.connec_id, 1, now(), now(), 'postgres', rec_connec.expl_id, 2, 1, 'Minor leak', 'No other problems', False);
    END LOOP;       

    --NODES
    FOR rec_node IN SELECT * FROM node WHERE state=1
    LOOP    
        --visit class 3. inspection node
        INSERT INTO ve_visit_node_insp (visit_id, node_id, visitcat_id, startdate, enddate, user_name, expl_id, class_id, status, sediments_node, defect_node, clean_node, insp_observ, photo) 
        VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_node.node_id, 1, now(), now(), 'postgres', rec_node.expl_id, 3, 1, 'No sediments', 'No defects', 'Cleaning done', 'No other problems', False);
    END LOOP;
    
    --visit class 4 (incident nodes)
    FOR rec_node IN SELECT * FROM node WHERE state=1 order by random() limit 20
    LOOP
        INSERT INTO ve_visit_incid_node (visit_id, node_id, visitcat_id, startdate, enddate, user_name, expl_id, class_id, status, incident_type, incident_comment, photo) 
        VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_node.node_id, 1, now(), now(), 'postgres', rec_node.expl_id, 4, 1, 'Missing cover', 'Minor loss of water', False);
    END LOOP;    
    
   
    RETURN;

        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
