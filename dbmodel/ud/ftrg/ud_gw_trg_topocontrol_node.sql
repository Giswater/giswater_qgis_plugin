/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1136


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_topocontrol_node()
  RETURNS trigger AS
$BODY$
DECLARE 
    numNodes numeric;
    psector_vdefault_var integer;
    replace_node_aux boolean;
    node_id_var varchar;
    node_rec record;
    querystring Varchar; 
    arcrec Record; 
    nodeRecord1 Record; 
    nodeRecord2 Record; 
    optionsRecord Record;
    z1 double precision;
    z2 double precision;
    xvar double precision;
    yvar double precision;
    pol_id_var varchar;
    top_elev_aux double precision;
    v_arc record;
    v_arcrecord "SCHEMA_NAME".v_edit_arc;
    v_arcrecordtb "SCHEMA_NAME".arc;
    v_node_proximity_control boolean;
    v_node_proximity double precision;
    v_dsbl_error boolean;
    v_psector_id integer;
    v_tempvalue text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Get parameters
	SELECT ((value::json)->>'activated') INTO v_node_proximity_control FROM config_param_system WHERE parameter='node_proximity';
	SELECT ((value::json)->>'value') INTO v_node_proximity FROM config_param_system WHERE parameter='node_proximity';
   	SELECT value::boolean INTO v_dsbl_error FROM config_param_system WHERE parameter='edit_topocontrol_dsbl_error' ;
	SELECT value INTO v_psector_id FROM config_param_user WHERE cur_user=current_user AND parameter = 'psector_vdefault';

	-- For state=0
    IF NEW.state=0 THEN
		RAISE WARNING 'Topology is not enabled with state=0. The feature will be inserted but disconected of the network!';
		RETURN NEW;

	-- For state=1,2
    ELSE

		-- State control (permissions to work with state=2 and possibility to downgrade feature to state=0)
		PERFORM gw_fct_state_control('NODE', NEW.node_id, NEW.state, TG_OP);
    	
		IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE ' THEN
		

			-- Checking conflict state=1 nodes (exiting vs new one)
			IF (NEW.state=1) AND (v_node_proximity_control IS TRUE) THEN

				-- check existing state=1 nodes
				SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, v_node_proximity) AND node.node_id != NEW.node_id AND node.state=1;
				IF node_rec.node_id IS NOT NULL THEN
		
					IF v_dsbl_error IS NOT TRUE THEN
						PERFORM audit_function (1097,1334, NEW.node_id);	
					ELSE
						INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message) 
						VALUES (4, NEW.node_id, 'Node with state 1 over another node with state=1 it is not allowed');
					END IF;
				END IF;		

			-- Checking conflict state=2 nodes (exitings on same alternative vs new one)
			ELSIF (NEW.state=2) AND (v_node_proximity_control IS TRUE) THEN

				-- check existing state=2 nodes on same alternative
				SELECT * INTO node_rec FROM node JOIN plan_psector_x_node USING (node_id) WHERE ST_DWithin(NEW.the_geom, node.the_geom, v_node_proximity) 
				AND node.node_id != NEW.node_id AND node.state=2 AND psector_id=v_psector_id;
			
				IF node_rec.node_id IS NOT NULL THEN
			
					IF v_dsbl_error IS NOT TRUE THEN
						PERFORM audit_function (1096,1334, NEW.node_id);	
					ELSE
						INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message) VALUES (4, 
						NEW.node_id, 'Node with state 2 over another node with state=2 on same alternative it is not allowed');
					END IF;
				END IF;		
			END IF;


			-- check for existing node (1)
			SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, v_node_proximity) AND node.node_id != NEW.node_id AND node.state=1;

			IF (NEW.state=2 AND node_rec.node_id IS NOT NULL) THEN
				
				-- inserting on plan_psector_x_node the existing node as state=0
				INSERT INTO plan_psector_x_node (psector_id, node_id, state) VALUES (v_psector_id, node_rec.node_id, 0);

				-- looking for all the arcs (1 and 2) using existing node
				FOR v_arc IN (SELECT arc_id, node_1 as node_id FROM v_edit_arc WHERE node_1=node_rec.node_id 
				AND state >0 UNION SELECT arc_id, node_2 FROM v_edit_arc WHERE node_2=node_rec.node_id AND state >0)
				LOOP

					-- if exists some arc planified on same alternative attached to that existing node
					IF v_arc.arc_id IN (SELECT arc_id FROM plan_psector_x_arc JOIN arc USING (arc_id) WHERE psector_id=v_psector_id AND arc.state=2) THEN 
							
						-- reconnect the planified arc to the new planified node in spite of connected to the node state=1
						IF (SELECT node_1 FROM arc WHERE arc_id=v_arc.arc_id)=v_arc.node_id THEN
							UPDATE arc SET node_1=NEW.node_id WHERE arc_id=v_arc.arc_id AND node_1=node_rec.node_id;							
						ELSE
							UPDATE arc SET node_2=NEW.node_id WHERE arc_id=v_arc.arc_id AND node_2=node_rec.node_id;
						END IF;
					ELSE
						-- getting values to create new 'fictius' arc
						SELECT * INTO v_arcrecordtb FROM arc WHERE arc_id = v_arc.arc_id::text;
							
						-- refactoring values fo new one
						PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
						v_arcrecordtb.arc_id:= (SELECT nextval('urn_id_seq'));
						v_arcrecordtb.code = v_arcrecordtb.arc_id;
						v_arcrecordtb.state=2;
						v_arcrecordtb.state_type := (SELECT value::smallint FROM config_param_system WHERE parameter='plan_statetype_ficticius' LIMIT 1);
						IF (SELECT node_1 FROM arc WHERE arc_id=v_arc.arc_id)=v_arc.node_id THEN
							v_arcrecordtb.node_1 = NEW.node_id;
						ELSE
							v_arcrecordtb.node_2 = NEW.node_id;
						END IF;
						
						-- set temporary values for config variables
						SELECT value INTO v_tempvalue FROM config_param_system WHERE parameter='edit_enable_arc_nodes_update';
						UPDATE config_param_system SET value=gw_fct_json_object_set_key(value::json,'activated',false) where parameter='arc_searchnodes';
						UPDATE config_param_system  SET value='TRUE' WHERE parameter='edit_enable_arc_nodes_update';
						
						-- Insert new records into arc table
						INSERT INTO arc SELECT v_arcrecordtb.*;
						
						-- restore temporary value for config variables
						UPDATE config_param_system SET value=gw_fct_json_object_set_key(value::json,'activated',true) where parameter='arc_searchnodes';
						UPDATE config_param_system SET value=v_tempvalue WHERE parameter='edit_enable_arc_nodes_update';

						--Copy addfields from old arc to new arcs	
						INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
						SELECT 
						v_arcrecordtb.arc_id,
						parameter_id,
						value_param
						FROM man_addfields_value WHERE feature_id=v_arc.arc_id;
																			
						-- Update doability for the new arc (false)
						UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=v_arcrecordtb.arc_id;

						-- insert old arc on the alternative							
						INSERT INTO plan_psector_x_arc (psector_id, arc_id, state, doable) VALUES (v_psector_id, v_arc.arc_id, 0, FALSE);

					END IF;
				END LOOP;				
			END IF;
			
		ELSIF TG_OP ='UPDATE' THEN			
			
		-- Updating expl / dma
			IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
				NEW.expl_id:= (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);          
				NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
				NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          				
			END IF;
			
		-- Updating polygon geometry in case of exists it
			pol_id_var:= (SELECT pol_id FROM man_storage WHERE node_id=OLD.node_id UNION SELECT pol_id FROM man_chamber WHERE node_id=OLD.node_id 
			UNION SELECT pol_id FROM man_wwtp WHERE node_id=OLD.node_id UNION SELECT pol_id FROM man_netgully WHERE node_id=OLD.node_id);
			IF (pol_id_var IS NOT NULL) THEN   
				xvar= (st_x(NEW.the_geom)-st_x(OLD.the_geom));
				yvar= (st_y(NEW.the_geom)-st_y(OLD.the_geom));		
				UPDATE polygon SET the_geom=ST_translate(the_geom, xvar, yvar) WHERE pol_id=pol_id_var;
			END IF;  
	   
		-- Select arcs with start-end on the updated node to modify coordinates
			querystring := 'SELECT * FROM "arc" WHERE arc.node_1 = ' || quote_literal(NEW.node_id) || ' OR arc.node_2 = ' || quote_literal(NEW.node_id); 

			IF NEW.custom_top_elev IS NULL 
				THEN top_elev_aux=NEW.top_elev;
			ELSE 
				top_elev_aux=NEW.custom_top_elev;
			END IF;

			--updating arcs
			FOR arcrec IN EXECUTE querystring
			LOOP

				-- Initial and final node of the arc
				SELECT * INTO nodeRecord1 FROM node WHERE node.node_id = arcrec.node_1;
				SELECT * INTO nodeRecord2 FROM node WHERE node.node_id = arcrec.node_2;
		
				-- Control de lineas de longitud 0
				IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) AND st_equals(NEW.the_geom, OLD.the_geom) IS FALSE THEN
		
					-- Update arc node coordinates, node_id and direction
					IF (nodeRecord1.node_id = NEW.node_id) THEN
					
						-- Coordinates
						EXECUTE 'UPDATE arc SET the_geom = ST_SetPoint($1, 0, $2) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom, NEW.the_geom; 
						
						-- Calculating new values of z1 and z2
						IF arcrec.custom_elev1 IS NULL AND arcrec.elev1 IS NULL THEN
							z1 = (top_elev_aux - arcrec.y1);
						END IF;

						IF arcrec.custom_elev2 IS NULL AND arcrec.elev2 IS NULL THEN				
							IF nodeRecord2.custom_top_elev IS NULL THEN
								z2 = (nodeRecord2.top_elev - arcrec.y2);
							ELSE
								z2 = (nodeRecord2.custom_top_elev - arcrec.y2);
							END IF;
						END IF;
							
	
					ELSIF (nodeRecord2.node_id = NEW.node_id) THEN
						-- Coordinates
						EXECUTE 'UPDATE arc SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom, NEW.the_geom; 
		
						-- Calculating new values of z1 and z2
						IF arcrec.custom_elev2 IS NULL AND arcrec.elev2 IS NULL THEN
							z2 = (top_elev_aux - arcrec.y2);
						END IF; 

						IF arcrec.custom_elev1 IS NULL AND arcrec.elev1 IS NULL THEN						
							IF nodeRecord1.custom_top_elev IS NULL THEN	
								z1 = (nodeRecord1.top_elev - arcrec.y1);
							ELSE
								z1 = (nodeRecord1.custom_top_elev - arcrec.y1);
							END IF;
						END IF;
					END IF;				
				END IF;

				-- Force a simple update on arc in order to update direction
				EXECUTE 'UPDATE arc SET the_geom = the_geom WHERE arc_id = ' || quote_literal(arcrec."arc_id");	
				
			END LOOP; 

			--updating links
			querystring := 'SELECT * FROM "link" WHERE link.exit_id= ' || quote_literal(NEW.node_id) || ' AND exit_type=''NODE''';

			FOR arcrec IN EXECUTE querystring
			LOOP
				-- Coordinates
				EXECUTE 'UPDATE link SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE link_id = ' || quote_literal(arcrec."link_id") USING arcrec.the_geom, NEW.the_geom; 					
			END LOOP; 
			
		END IF;
    END IF;

RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
