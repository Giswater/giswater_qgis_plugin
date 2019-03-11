/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1234


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_node_update()
  RETURNS trigger AS
$BODY$
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
	top_elev_aux double precision;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get parameters
    SELECT * INTO rec FROM config;
	--SELECT * INTO optionsRecord FROM inp_options LIMIT 1;


	-- For state=0
    IF NEW.state=0 THEN
		RAISE WARNING 'Topology is not enabled with state=0. The feature will be inserted but disconected of the network!';
		RETURN NEW;

-- For state=1,2
    ELSE 
        IF TG_OP = 'INSERT' THEN
		
		-- Checking number of nodes 
			numNodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0);
			
			IF (numNodes >1) AND (rec.node_proximity_control IS TRUE) THEN
				PERFORM audit_function(1096,1234);
				
			ELSIF (numNodes =1) AND (rec.node_proximity_control IS TRUE) THEN
				SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0;
				IF (NEW.state=1 AND node_rec.state=1) OR (NEW.state=2 AND node_rec.state=1) THEN
				
					/*
					TO DO: MAKE PROCEDURE:
					------------------------------------------------------------------------------------------
					INSERT INTO plan_psector_x_node (psector_id, node_id, state_id) VALUES (psector, node_id, 0);
					LOOP ALS ARCS QUE ARRIBEN AL NODE
						IF arc pertany alternativa
							es reconnecta al nou node planificat
						ELSIF arc no pertany a alternativa 
							INSERT INTO plan_psector_x_arc OLD ARC (psector_id, arc_id, state_id) VALUES (psector, node_id, 0);
							CREATE NEW ARC connectant al nou node
							INSERT INTO plan_psector_x_arc NEW ARC (psector_id, arc_id, state_id) VALUES (psector, node_id, 1, state_type='ficitius');
						END IF;
					END LOOP;
					----------------------------------------------------------------------------------------------
					*/
				
					PERFORM audit_function(1098,1234);
				ELSIF (NEW.state=2 AND node_rec.state=2) THEN
					PERFORM audit_function(1100,1234);
				END IF;
			END IF;
			
			
		ELSIF TG_OP ='UPDATE' THEN
		
		-- Checking number of nodes 
			numNodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0);
			
			IF (numNodes >1) AND (rec.node_proximity_control IS TRUE) THEN
				PERFORM audit_function(1096,1234);
				
			ELSIF (numNodes =1) AND (rec.node_proximity_control IS TRUE) THEN
				SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0;
				IF (NEW.state=1 AND node_rec.state=1) OR (NEW.state=2 AND node_rec.state=1) THEN
					PERFORM audit_function(1098,1234);
				ELSIF (NEW.state=2 AND node_rec.state=2) THEN
					PERFORM audit_function(1100,1234);
				END IF;
			END IF;
			
			
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
	
			FOR arcrec IN EXECUTE querystring
			LOOP
		
				-- Initial and final node of the arc
				SELECT * INTO nodeRecord1 FROM node WHERE node.node_id = arcrec.node_1;
				SELECT * INTO nodeRecord2 FROM node WHERE node.node_id = arcrec.node_2;

				-- Control de lineas de longitud 0
				IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN
		
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

					-- Force a simple update on arc in order to update direction if necessary
                    EXECUTE 'UPDATE arc SET observ = ' || quote_literal(arcrec.observ) || ' WHERE arc_id = ' || quote_literal(arcrec."arc_id"); 
					
				END IF;
			END LOOP; 
		END IF;
    END IF;

RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
