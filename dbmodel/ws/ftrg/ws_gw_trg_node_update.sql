/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1334

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_node_update() RETURNS trigger AS
$BODY$
DECLARE 

    rec_node record;
    rec_arc Record; 
    rec_node1 Record; 
    rec_node2 Record; 
    v_numNodes numeric; 
	v_querystring Varchar; 
    v_xvar double precision;
    v_yvar double precision;
    v_pol_id varchar;
    v_psector_id integer;
    v_arc record;
    v_arcrecord "SCHEMA_NAME".v_edit_arc;
    v_plan_statetype_ficticius int2;
    v_querytext text;
	v_node_proximity_control boolean;
	v_node_proximity double precision;
	v_dsbl_error boolean;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Get parameters
	SELECT ((value::json)->>'activated') INTO v_node_proximity_control FROM config_param_system WHERE parameter='edit_node_proximity';
	SELECT ((value::json)->>'value') INTO v_node_proximity FROM config_param_system WHERE parameter='edit_node_proximity';
   	SELECT value::boolean INTO v_dsbl_error FROM config_param_system WHERE parameter='edit_topocontrol_disable_error' ;


    -- Lookig for state=0
    IF NEW.state=0 THEN
		RAISE WARNING 'Topology is not enabled with state=0. The feature will be inserted but disconected of the network!';
		RETURN NEW;

    ELSE 
		v_psector_id := (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter = 'plan_psector_vdefault');
	
		IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE ' THEN

			-- Checking number of nodes 
			v_numNodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, v_node_proximity) AND node.state!=0);
			
			IF (v_numNodes >1) AND (v_node_proximity_control IS TRUE) THEN
				IF v_dsbl_error IS NOT TRUE THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        			"data":{"message":"1096", "function":"1334","debug_msg":"'||NEW.node_id'"}}$$);';
				ELSE
					INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (4, NEW.node_id, 'Node is over another node with incompatible state (state 1 or 2)');
				END IF;
				
			ELSIF (v_numNodes =1) AND (v_node_proximity_control IS TRUE) THEN
				SELECT * INTO rec_node FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, v_node_proximity) AND node.node_id != NEW.node_id AND node.state!=0;
				IF (NEW.state=2 AND rec_node.state=1) THEN
				--IF (NEW.state=1 AND rec_node.state=2) OR (NEW.state=2 AND rec_node.state=1) THEN

					-- inserting on plan_psector_x_node the existing node as state=0
					INSERT INTO plan_psector_x_node (psector_id, node_id, state) VALUES (v_psector_id, rec_node.node_id, 0);

					-- looking for all the arcs (1 and 2) using existing node
					FOR v_arc IN (SELECT arc_id, node_1 as node_id FROM arc WHERE node_1=rec_node.node_id UNION SELECT arc_id, node_2 FROM arc WHERE node_2=rec_node.node_id)
					LOOP
						-- if exists some arc planified on same alternative attached to that existing node
						IF v_arc.arc_id IN (SELECT arc_id FROM plan_psector_x_arc WHERE psector_id=v_psector_id) THEN 
						
							-- reconnect the planified arc to the new planified node in spite of connected to the node state=1
							IF (SELECT node_1 FROM arc WHERE arc_id=v_arc.arc_id)=v_arc.node_id THEN
								UPDATE arc SET node_1=NEW.node_id WHERE arc_id=v_arc.arc_id AND node_1=rec_node.node_id;							
							ELSE
								UPDATE arc SET node_2=NEW.node_id WHERE arc_id=v_arc.arc_id AND node_2=rec_node.node_id;
							END IF;
							
						ELSE
							-- getting values to create new 'fictius' arc
							SELECT * INTO v_arcrecord FROM v_edit_arc WHERE arc_id = v_arc.arc_id::text;
							
							-- refactoring values fo new one
							PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
							v_arcrecord.arc_id:= (SELECT nextval('urn_id_seq'));
							v_arcrecord.code = v_arcrecord.arc_id;
							v_arcrecord.state=2;
							v_arcrecord.state_type := (SELECT value::smallint FROM config_param_system WHERE parameter='plan_statetype_ficticius');
						
							IF (SELECT node_1 FROM arc WHERE arc_id=v_arc.arc_id)=v_arc.node_id THEN
								v_arcrecord.node_1 = NEW.node_id;
							ELSE
								v_arcrecord.node_2 = NEW.node_id;
							END IF;
						
							-- Insert new records into arc table
							-- downgrade temporary the edit_state_topocontrol to prevent conflicts
							UPDATE config_param_system SET value='FALSE' where parameter='edit_state_topocontrol';
														
							INSERT INTO v_edit_arc SELECT v_arcrecord.*;

							--Copy addfields from old arc to new arcs	
							INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
							SELECT 
							v_arcrecord.arc_id,
							parameter_id,
							value_param
							FROM man_addfields_value WHERE feature_id=v_arc.arc_id;
																				
							-- restore the edit_state_topocontrol variable
							UPDATE config_param_system SET value='TRUE' where parameter='edit_state_topocontrol';
	
							-- Update doability for the new arc (false)
							UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=v_arcrecord.arc_id;

							-- insert old arc on the alternative							
							INSERT INTO plan_psector_x_arc (psector_id, arc_id, state, doable) VALUES (v_psector_id, v_arc.arc_id, 0, FALSE);
						END IF;
					END LOOP;
				
				ELSIF (NEW.state=2 AND rec_node.state=2) THEN
				
					IF v_dsbl_error IS NOT TRUE THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        				"data":{"message":"1100", "function":"1334","debug_msg":"'||NEW.node_id'"}}$$);';
					ELSE
						INSERT INTO audit_log_data (fid, feature_id, log_message) VALUES (4, NEW.node_id, 'Node is over another node with incompatible state (state = 2)');
					END IF;
				END IF;
			END IF;
			
			
		ELSIF TG_OP ='UPDATE' THEN
						
		-- Updating expl / dma
			IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
				NEW.expl_id:= (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);          
				NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
				NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);   
			END IF;
				
		-- Updating polygon geometry in case of exists it
			v_pol_id:= (SELECT pol_id FROM man_register WHERE node_id=OLD.node_id UNION SELECT pol_id FROM man_tank WHERE node_id=OLD.node_id);
			IF (v_pol_id IS NOT NULL) THEN   
				v_xvar= (st_x(NEW.the_geom)-st_x(OLD.the_geom));
				v_yvar= (st_y(NEW.the_geom)-st_y(OLD.the_geom));		
				UPDATE polygon SET the_geom=ST_translate(the_geom, v_xvar, v_yvar) WHERE pol_id=v_pol_id;
			END IF;      
				
							
		-- Select arcs with start-end on the updated node
			v_querystring := 'SELECT * FROM arc WHERE arc.node_1 = ' || quote_literal(NEW.node_id) || ' OR arc.node_2 = ' || quote_literal(NEW.node_id); 
			FOR rec_arc IN EXECUTE v_querystring
			LOOP

			-- Initial and final node of the arc
				SELECT * INTO rec_node1 FROM node WHERE node.node_id = arcrec.node_1;
				SELECT * INTO rec_node2 FROM node WHERE node.node_id = arcrec.node_2;

			-- Control de lineas de longitud 0
				IF (rec_node1.node_id IS NOT NULL) AND (rec_node2.node_id IS NOT NULL) THEN

				-- Update arc node coordinates, node_id and direction
					IF (rec_node1.node_id = NEW.node_id) THEN
						EXECUTE 'UPDATE arc SET the_geom = ST_SetPoint($1, 0, $2) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom, NEW.the_geom; 
							ELSE
							EXECUTE 'UPDATE arc SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE arc_id = ' || quote_literal(arcrec."arc_id") USING arcrec.the_geom, NEW.the_geom; 
					END IF;
				END IF;
			END LOOP; 
		END IF;
			
	END IF;
	
RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

