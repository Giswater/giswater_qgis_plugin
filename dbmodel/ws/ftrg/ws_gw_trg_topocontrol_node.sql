/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1136

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_topocontrol_node() RETURNS trigger AS
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
    z1 double precision;
    z2 double precision;
    xvar double precision;
    yvar double precision;
    pol_id_var varchar;
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
	SELECT ((value::json)->>'activated') INTO v_node_proximity_control FROM config_param_system WHERE parameter='node_proximity';
	SELECT ((value::json)->>'value') INTO v_node_proximity FROM config_param_system WHERE parameter='node_proximity';
   	SELECT value::boolean INTO v_dsbl_error FROM config_param_system WHERE parameter='edit_topocontrol_dsbl_error' ;


    -- Lookig for state=0
    IF NEW.state=0 THEN
	RAISE WARNING 'Topology is not enabled with state=0. The feature will be inserted but disconected of the network!';
	RETURN NEW;

    ELSE 

	-- State control (permissions to work with state=2 and possibility to downgrade feature to state=0)
	PERFORM gw_fct_state_control('NODE', NEW.node_id, NEW.state, TG_OP);
    	
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE ' THEN

		-- Checking number of nodes 
		numNodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, v_node_proximity) AND node.state!=0);
			
		IF (numNodes >1) AND (v_node_proximity_control IS TRUE) THEN
			IF v_dsbl_error IS NOT TRUE THEN
				PERFORM audit_function (1096,1334, NEW.node_id);	
			ELSE
				INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message) VALUES (4, NEW.node_id, 'There are two state > (0) nodes on same position. The maximum allowed, one with state (1) and other with state (2)');
			END IF;
				
			ELSIF (numNodes =1) AND (v_node_proximity_control IS TRUE) THEN
			
				SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, v_node_proximity) AND node.node_id != NEW.node_id AND node.state!=0;

				IF (NEW.state=1 AND node_rec.state=1) THEN

					IF v_dsbl_error IS NOT TRUE THEN
						PERFORM audit_function (1097,1334, NEW.node_id);	
					ELSE
						INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message) VALUES (4, NEW.node_id, 'Node with state 1 over another node with state=1 it is not allowed');
					END IF;
				
				ELSIF (NEW.state=2 AND node_rec.state=1) THEN

					-- the insertion it's enabled. All proces to create ficticius arcs have been developed on the trigger trg_topocontrol_node_after
								
				ELSIF (NEW.state=2 AND node_rec.state=2) THEN
				
					IF v_dsbl_error IS NOT TRUE THEN
						PERFORM audit_function (1100,1334, NEW.node_id);	
					ELSE
						INSERT INTO audit_log_data (fprocesscat_id, feature_id, log_message) VALUES (4, NEW.node_id, 'Node is over another node with incompatible state (state = 2)');
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

