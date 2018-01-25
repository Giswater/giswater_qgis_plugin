/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2320


SET search_path="SCHEMA_NAME",public;

DROP FUNCTION IF EXISTS gw_fct_repair_arc_searchnodes();
CREATE OR REPLACE FUNCTION gw_fct_repair_arc_searchnodes() RETURNS void AS
$BODY$
DECLARE 
    arcrec Record;
    nodeRecord1 Record; 
    nodeRecord2 Record;
    optionsRecord Record;
    rec Record;

BEGIN 

   SET search_path= 'SCHEMA_NAME','public';

    -- Get data from config table
    SELECT * INTO rec FROM config;    
	
	DELETE FROM audit_log_data WHERE fprocesscat_id=17 AND user_name=current_user;

	-- Starting loop process
    FOR arcrec IN SELECT * FROM v_edit_arc
    LOOP
    
		SELECT * INTO nodeRecord1 FROM v_edit_node WHERE ST_DWithin(ST_startpoint(arcrec.the_geom), node.the_geom, rec.arc_searchnodes)
		ORDER BY ST_Distance(node.the_geom, ST_startpoint(arcrec.the_geom)) desc LIMIT 1;

		SELECT * INTO nodeRecord2 FROM v_edit_node WHERE ST_DWithin(ST_endpoint(arcrec.the_geom), node.the_geom, rec.arc_searchnodes)
		ORDER BY ST_Distance(node.the_geom, ST_endpoint(arcrec.the_geom)) desc LIMIT 1;
	
	
		-- Repair node1
		IF (nodeRecord1.node_id IS NOT NULL) AND nodeRecord1.node_id!=arcrec.node_1
		
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, message) VALUES (17,  'arc', arcrec.arc_id, FALSE, 
			'Impossible to repair because node detected close the startpoint of arc its diferent of arc.node_1 ') ;
				
		ELSIF (nodeRecord1.node_id IS NOT NULL) AND nodeRecord1.node_id=arcrec.node_1
		
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, message) VALUES (17,  'arc', arcrec.arc_id, TRUE, 
			concat('Connected on starpoint to the same node of node_1 with a desplacement of (m):',ST_Distance(node.the_geom, ST_endpoint(arcrec.the_geom))) ;
		
			arcrec.the_geom := ST_SetPoint(arcrec.the_geom, 0, nodeRecord1.the_geom);
			UPDATE arc SET the_geom=arcrec.the_geom  where arc_id=arcrec.arc_id;    
				
		ELSIF (nodeRecord1.node_id IS NOT NULL) AND arcrec.node_1 IS NULL
	
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, message) VALUES (17,  'arc', arcrec.arc_id, TRUE, 
			concat('Connected on starpoint to new (node_1 was null) with a desplacement of (m):',ST_Distance(node.the_geom, ST_endpoint(arcrec.the_geom))) ;
	
	        arcrec.the_geom := ST_SetPoint(arcrec.the_geom, 0, nodeRecord1.the_geom);
            UPDATE arc SET node_1=nodeRecord1.node_id, the_geom=arcrec.the_geom  where arc_id=arcrec.arc_id;    
		
		END IF:	
	
	
	
		-- Repair node2
		IF (nodeRecord2.node_id IS NOT NULL) AND nodeRecord2.node_id!=arcrec.node_2
	
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, message) VALUES (17,  'arc', arcrec.arc_id, FALSE, 
			'Impossible to repair because node detected close the startpoint of arc its diferent of arc.node_2 ') ;
			
		ELSIF (nodeRecord2.node_id IS NOT NULL) AND nodeRecord2.node_id=arcrec.node_2
	
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, message) VALUES (17,  'arc', arcrec.arc_id, TRUE, 
			concat('Connected on starpoint to the same node of node_2 with a desplacement of (m):',ST_Distance(node.the_geom, ST_endpoint(arcrec.the_geom))) ;
	
			arcrec.the_geom := ST_SetPoint(arcrec.the_geom, 0, nodeRecord2.the_geom);
            UPDATE arc SET the_geom=arcrec.the_geom  where arc_id=arcrec.arc_id;    
			
		ELSIF (nodeRecord2.node_id IS NOT NULL) AND arcrec.node_2 IS NULL
	
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, message) VALUES (17,  'arc', arcrec.arc_id, TRUE, 
			concat('Connected on starpoint to new (node_2 was null) with a desplacement of (m):',ST_Distance(node.the_geom, ST_endpoint(arcrec.the_geom))) ;
	
	        arcrec.the_geom := ST_SetPoint(arcrec.the_geom, 0, nodeRecord2.the_geom);
            UPDATE arc SET node_2=nodeRecord2.node_id, the_geom=arcrec.the_geom  where arc_id=arcrec.arc_id;    
		END IF:
		
	END LOOP;

  RETURN;
    	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;