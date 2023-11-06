/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2886

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_fill_om_tables()
  RETURNS void AS
$BODY$

DECLARE

 rec_node   record;
 rec_arc   record;
 rec_connec   record;
rec_gully record;
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
	    --visit class 1. insp arc
	    INSERT INTO ve_visit_arc_insp (visit_id, arc_id, visitcat_id, startdate, enddate, user_name, expl_id, class_id, status, sediments_arc, defect_arc, clean_arc, insp_observ, photo) 
		VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_arc.arc_id, 1, now(), now(), 'postgres', rec_arc.expl_id, 1, 1, 'Medium amount', 'Cleaned', 'No defects', 'No other problems', False);
    
		--visit class 5. incident arc
		INSERT INTO ve_visit_incid_arc (visit_id, arc_id, visitcat_id, startdate, enddate, user_name, expl_id, class_id, status, incident_type, incident_comment, photo) 
		VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_arc.arc_id, 1, now(), now(), 'postgres', rec_arc.expl_id, 5, 1, 'Minor leak', 'No other problems', False);

	END LOOP;
   
   --NODES
	FOR rec_node IN SELECT * from node WHERE state=1
	LOOP
		--visit class 2.insp nodes
 	    INSERT INTO ve_visit_node_insp (visit_id, node_id, visitcat_id, startdate, enddate, user_name, expl_id, the_geom, class_id, status, sediments_node, defect_node, clean_node, insp_observ, photo) 
		VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_node.node_id, 1, now(), now(), 'postgres', rec_node.expl_id, rec_node.the_geom, 2, 1, 'Medium amount', 'Cleaned', 'No defects', 'No other problems', False);
	END LOOP;
	
	FOR rec_node IN SELECT * from node WHERE state=1 order by random() limit 20
	LOOP
		--visit class 6. incid nodes
		INSERT INTO ve_visit_incid_node (visit_id, node_id, visitcat_id, startdate, enddate, user_name, expl_id, the_geom, class_id, status, incident_type, incident_comment, photo) 
		VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_node.node_id, 1, now(), now(), 'postgres', rec_node.expl_id, rec_node.the_geom, 6, 1, 'Broken cover', 'No other problems', False);
	END LOOP;       
   
	--CONNECS
    FOR rec_connec IN SELECT *from connec WHERE state=1 
    LOOP
	    --visit class 3. insp connecs
 	    INSERT INTO ve_visit_connec_insp (visit_id, connec_id, visitcat_id, startdate, enddate, user_name, expl_id, the_geom, class_id, status, sediments_connec, defect_connec, clean_connec, insp_observ, photo) 
		VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_connec.connec_id, 1, now(), now(), 'postgres', rec_connec.expl_id, rec_connec.the_geom, 3, 1, 'Medium amount', 'Cleaned', 'No defects', 'No other problems', False);
	
		--visit class 7. incid connecs
		INSERT INTO ve_visit_incid_connec (visit_id, connec_id, visitcat_id, startdate, enddate, user_name, expl_id, the_geom, class_id, status, incident_type, incident_comment, photo) 
		VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_connec.connec_id, 1, now(), now(), 'postgres', rec_connec.expl_id, rec_connec.the_geom, 7, 1, 'Minor leak', 'No other problems', False);       
	END LOOP;  

   --GULLYS
    FOR rec_gully IN SELECT *from gully WHERE state=1 
    LOOP
	    --visit class 4. insp gullys
 	    INSERT INTO ve_visit_gully_insp (visit_id, gully_id, visitcat_id, startdate, enddate, user_name, expl_id, the_geom, class_id, status, sediments_gully, defect_gully, clean_gully, insp_observ, photo) 
		VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_gully.gully_id, 1, now(), now(), 'postgres', rec_gully.expl_id, rec_gully.the_geom, 4, 1, 'Medium amount', 'Cleaned', 'No defects', 'No other problems', False);
	
		--visit class 8. incident gullys
		INSERT INTO ve_visit_incid_gully (visit_id, gully_id, visitcat_id, startdate, enddate, user_name, expl_id, the_geom, class_id, status, incident_type, incident_comment, photo) 
		VALUES(nextval('SCHEMA_NAME.om_visit_id_seq'), rec_gully.gully_id, 1, now(), now(), 'postgres', rec_gully.expl_id, rec_gully.the_geom, 8, 1, 'Full of leaves', 'Urgent cleaning', False);         
	END LOOP;

    RETURN;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
