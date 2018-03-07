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
    update_control_bool boolean;

BEGIN 

   SET search_path= 'SCHEMA_NAME','public';

    update_control_bool:=false;

    -- Get data from config table
    SELECT * INTO rec FROM config;    
	
	DELETE FROM audit_log_data WHERE fprocesscat_id=17 AND user_name=current_user;

	-- Starting loop process
    FOR arcrec IN SELECT * FROM v_edit_arc
    LOOP
    
		SELECT * INTO nodeRecord1 FROM v_edit_node WHERE ST_DWithin(ST_startpoint(arcrec.the_geom), v_edit_node.the_geom, rec.arc_searchnodes)
		ORDER BY ST_Distance(v_edit_node.the_geom, ST_startpoint(arcrec.the_geom)) desc LIMIT 1;

		SELECT * INTO nodeRecord2 FROM v_edit_node WHERE ST_DWithin(ST_endpoint(arcrec.the_geom), v_edit_node.the_geom, rec.arc_searchnodes)
		ORDER BY ST_Distance(v_edit_node.the_geom, ST_endpoint(arcrec.the_geom)) desc LIMIT 1;
	
	
		-- Repair node1
		IF (((nodeRecord1.node_id IS NOT NULL) AND (nodeRecord1.node_id!=arcrec.node_1 AND nodeRecord1.node_id!=arcrec.node_2)) OR ((nodeRecord2.node_id IS NOT NULL) AND (nodeRecord2.node_id!=arcrec.node_2 AND nodeRecord1.node_id!=arcrec.node_1))) THEN
		
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, log_message) VALUES (17,  'arc', arcrec.arc_id, FALSE, 
			'Impossible to repair. Detected nodes are diferent from attributes arc.node_1 or arc.node_2 ') ;
				
		ELSIF nodeRecord1.node_id=arcrec.node_1 and nodeRecord2.node_id=arcrec.node_2 THEN
		
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, log_message) VALUES (17,  'arc', arcrec.arc_id, TRUE, 
			concat('Connected to same node_1(',nodeRecord1.node_id,') and same node_2(',nodeRecord2.node_id,'). Desplacement(m):',ST_Distance(nodeRecord1.the_geom, ST_startpoint(arcrec.the_geom))));
			update_control_bool=TRUE;  
				
		ELSIF (nodeRecord1.node_id IS NOT NULL) AND arcrec.node_1 IS NULL THEN 
	
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, log_message) VALUES (17,  'arc', arcrec.arc_id, TRUE, 
			concat('Connected on starpoint to new node_1(',nodeRecord1.node_id,').Previous was null. Desplacement(m):',ST_Distance(nodeRecord1.the_geom, ST_startpoint(arcrec.the_geom)))) ;
			update_control_bool=TRUE;     
				
						
		ELSIF (nodeRecord2.node_id IS NOT NULL) AND arcrec.node_2 IS NULL THEN
	
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, log_message) VALUES (17,  'arc', arcrec.arc_id, TRUE, 
			concat('Connected on endpoint to new node_2(',nodeRecord2.node_id,').Previous was null. Desplacement(m):',ST_Distance(nodeRecord2.the_geom, ST_endpoint(arcrec.the_geom)))) ; 
			update_control_bool=TRUE;  
			
		ELSIF (nodeRecord1.node_id IS NULL) OR  (nodeRecord2.node_id IS NULL) THEN
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, log_message) VALUES (17,  'arc', arcrec.arc_id, FALSE, 
			concat('impossible to repair because node_1 (',nodeRecord1.node_id,') or node_2 (',nodeRecord2.node_id,')are nulls'));
			update_control_bool=FALSE; 
			
		ELSIF nodeRecord1.node_id=nodeRecord2.node_id THEN
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, enabled, log_message) VALUES (17,  'arc', arcrec.arc_id, FALSE, 
			concat('impossible to repair because node_1 (',nodeRecord1.node_id,') and node_2 (',nodeRecord2.node_id,')are the same'));
			update_control_bool=FALSE; 
			
		END IF;

		IF update_control_bool IS TRUE THEN
			arcrec.the_geom := ST_SetPoint(arcrec.the_geom, 0, nodeRecord1.the_geom);
			arcrec.the_geom := ST_SetPoint(arcrec.the_geom, ST_NumPoints(arcrec.the_geom) - 1, nodeRecord2.the_geom);
			IF arcrec.the_geom IS NOT NULL THEN
				UPDATE arc SET node_1=nodeRecord1.node_id, node_2=nodeRecord2.node_id, the_geom=arcrec.the_geom  where arc_id=arcrec.arc_id;    
			END IF;
				
		END IF;

		
	END LOOP;

  RETURN;
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;