/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1334

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_node_update() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    numNodes numeric;
    rec record;
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
    v_psector_id integer;
    v_arc record;
    v_arcrecord "SCHEMA_NAME".v_edit_arc;
    v_plan_statetype_ficticius int2;
    v_querytext text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get parameters
    SELECT * INTO rec FROM config;
    SELECT * INTO optionsRecord FROM inp_options LIMIT 1;


    -- Lookig for state=0
    IF NEW.state=0 THEN
		RAISE WARNING 'Topology is not enabled with state=0. The feature will be inserted but disconected of the network!';
		RETURN NEW;

    ELSE 
		v_psector_id := (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter = 'psector_vdefault');
	
		IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE ' THEN

			-- Checking number of nodes 
			numNodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0);
			
			IF (numNodes >1) AND (rec.node_proximity_control IS TRUE) THEN
				PERFORM audit_function(1096,1334);
				
			ELSIF (numNodes =1) AND (rec.node_proximity_control IS TRUE) THEN
				SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0;
				IF (NEW.state=1 AND node_rec.state=1) OR (NEW.state=2 AND node_rec.state=1) THEN

					-- inserting on plan_psector_x_node the existing node as state=0
					INSERT INTO plan_psector_x_node (psector_id, node_id, state) VALUES (v_psector_id, node_rec.node_id, 0);

					-- looking for all the arcs (1 and 2) using existing node
					FOR v_arc IN (SELECT arc_id, node_1 as node_id FROM arc WHERE node_1=node_rec.node_id UNION SELECT arc_id, node_2 FROM arc WHERE node_2=node_rec.node_id)
					LOOP
						-- if exists some arc planified on same alternative attached to that existing node
						IF v_arc.arc_id IN (SELECT arc_id FROM plan_psector_x_arc WHERE psector_id=v_psector_id) THEN 
						
							-- reconnect the planified arc to the new planified node in spite of connected to the node state=1
							IF (SELECT node_1 FROM arc WHERE arc_id=v_arc.arc_id)=v_arc.node_id THEN
								UPDATE arc SET node_1=NEW.node_id WHERE arc_id=v_arc.arc_id AND node_1=node_rec.node_id;							
							ELSE
								UPDATE arc SET node_2=NEW.node_id WHERE arc_id=v_arc.arc_id AND node_2=node_rec.node_id;
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
							-- downgrade temporary the state_topocontrol to prevent conflicts	
							UPDATE config_param_system SET value='FALSE' where parameter='state_topocontrol';
														
							INSERT INTO v_edit_arc SELECT v_arcrecord.*;

							--Copy addfields from old arc to new arcs	
							INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
							SELECT 
							v_arcrecord.arc_id,
							parameter_id,
							value_param
							FROM man_addfields_value WHERE feature_id=v_arc.arc_id;
																				
							-- restore the state_topocontrol variable
							UPDATE config_param_system SET value='TRUE' where parameter='state_topocontrol';
	
							-- Update doability for the new arc (false)
							UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=v_arcrecord.arc_id;

							-- insert old arc on the alternative							
							INSERT INTO plan_psector_x_arc (psector_id, arc_id, state, doable) VALUES (v_psector_id, v_arc.arc_id, 0, FALSE);
						END IF;
					END LOOP;
				
				ELSIF (NEW.state=2 AND node_rec.state=2) THEN
					PERFORM audit_function(1100,1334);
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
			pol_id_var:= (SELECT pol_id FROM man_register WHERE node_id=OLD.node_id UNION SELECT pol_id FROM man_tank WHERE node_id=OLD.node_id);
			IF (pol_id_var IS NOT NULL) THEN   
				xvar= (st_x(NEW.the_geom)-st_x(OLD.the_geom));
				yvar= (st_y(NEW.the_geom)-st_y(OLD.the_geom));		
				UPDATE polygon SET the_geom=ST_translate(the_geom, xvar, yvar) WHERE pol_id=pol_id_var;
			END IF;      
				
							
		-- Select arcs with start-end on the updated node
			querystring := 'SELECT * FROM arc WHERE arc.node_1 = ' || quote_literal(NEW.node_id) || ' OR arc.node_2 = ' || quote_literal(NEW.node_id); 
			FOR arcrec IN EXECUTE querystring
			LOOP

			-- Initial and final node of the arc
				SELECT * INTO nodeRecord1 FROM node WHERE node.node_id = arcrec.node_1;
				SELECT * INTO nodeRecord2 FROM node WHERE node.node_id = arcrec.node_2;

			-- Control de lineas de longitud 0
				IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN

				-- Update arc node coordinates, node_id and direction
					IF (nodeRecord1.node_id = NEW.node_id) THEN
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
$$;
