/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_topocontrol_node() RETURNS trigger LANGUAGE plpgsql AS $$
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

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get parameters
    SELECT * INTO rec FROM config;
	SELECT * INTO optionsRecord FROM inp_options LIMIT 1;


 -- Looking for state control
    PERFORM gw_fct_state_control('node', NEW.node_id, NEW.state, TG_OP);
  

    -- Lookig for state=0
    IF NEW.state=0 THEN
	RAISE WARNING 'Topology is not enabled with state=0. The feature will be inserted but disconected of the network!';

    ELSE 
        IF TG_OP = 'INSERT' THEN
		
		-- Checking number of nodes 
			numNodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0);
			
			IF (numNodes >1) AND (rec.node_proximity_control IS TRUE) THEN
				RAISE EXCEPTION 'There are more than one nodes on the same position. Please, review your project data!';
				
			ELSIF (numNodes =1) AND (rec.node_proximity_control IS TRUE) THEN
				SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0;
				IF (NEW.state=1 AND node_rec.state=1) OR (NEW.state=2 AND node_rec.state=1) THEN
					RAISE EXCEPTION 'Node with state(1) or(2) over one existing node with state(1) please use the buttom replace node!';
				ELSIF (NEW.state=2 AND node_rec.state=2) THEN
					RAISE EXCEPTION 'Node with state(2) over node with state(2) is not allowed. Please, review your project data!';
				END IF;
			END IF;
			
			
		ELSIF TG_OP ='UPDATE' THEN
		
		-- Checking number of nodes 
			numNodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0);
			
			IF (numNodes >1) AND (rec.node_proximity_control IS TRUE) THEN
				RAISE EXCEPTION 'There are more than one nodes on the same position. Please, review your project data!';
				
			ELSIF (numNodes =1) AND (rec.node_proximity_control IS TRUE) THEN
				SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0;
				IF (NEW.state=1 AND node_rec.state=1) OR (NEW.state=2 AND node_rec.state=1) THEN
					RAISE EXCEPTION 'Node with state(1) or(2) over one existing node with state(1) please use the buttom replace node!';
				ELSIF (NEW.state=2 AND node_rec.state=2) THEN
					RAISE EXCEPTION 'Node with state(2) over node with state(2) is not allowed. Please, review your project data!';
				END IF;
			END IF;
				
		-- Updating expl / dma
			IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
				NEW.expl_id:= (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);          
				NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
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

DROP TRIGGER IF EXISTS gw_trg_topocontrol_node ON "SCHEMA_NAME"."node";
CREATE TRIGGER gw_trg_topocontrol_node BEFORE INSERT OR UPDATE OF the_geom, "state" ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_topocontrol_node"();

