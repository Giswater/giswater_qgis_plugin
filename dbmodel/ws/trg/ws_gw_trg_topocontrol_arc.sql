/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_topocontrol_arc() RETURNS trigger AS $BODY$
DECLARE 
    nodeRecord1 record; 
    nodeRecord2 record; 
    rec record;  
    vnoderec record;
    newPoint public.geometry;    
    connecPoint public.geometry;
	
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
 -- Get data from config table
    SELECT * INTO rec FROM config;  

 -- Looking for state control
    PERFORM gw_fct_state_control('arc', NEW.arc_id, NEW.state, TG_OP);
  
	
-- Lookig for state=0
    IF NEW.state=0 THEN
		RAISE WARNING 'Topology is not enabled with state=0. The feature will be disconected of the network';
		RETURN NEW;
	
--  Starting process
    ELSE 
		SELECT * INTO nodeRecord1 FROM v_edit_node WHERE node_id=gw_fct_state_searchnodes(NEW.arc_id, NEW.state, 'StartPoint'::varchar, NEW.the_geom, TG_OP);
		SELECT * INTO nodeRecord2 FROM v_edit_node WHERE node_id=gw_fct_state_searchnodes(NEW.arc_id, NEW.state, 'EndPoint'::varchar, NEW.the_geom, TG_OP);
	

    -- Control of length line
		IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN
    
        -- Control of same node initial and final
			IF (nodeRecord1.node_id = nodeRecord2.node_id) AND (rec.samenode_init_end_control IS TRUE) THEN
				RETURN audit_function (180,330);
			
			ELSE
				-- Update coordinates
				NEW.the_geom:= ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
				NEW.the_geom:= ST_SetPoint(NEW.the_geom, ST_NumPoints(NEW.the_geom) - 1, nodeRecord2.the_geom);
				NEW.node_1:= nodeRecord1.node_id; 
				NEW.node_2:= nodeRecord2.node_id;

				-- Update vnode/link
				IF TG_OP = 'UPDATE' THEN
	
					-- Select arcs with start-end on the updated node
					FOR vnoderec IN SELECT * FROM vnode JOIN link ON vnode_id::text=exit_id WHERE exit_type='VNODE' 
					AND ST_DWithin(OLD.the_geom, vnode.the_geom, rec.vnode_update_tolerance) AND (userdefined_geom=false OR userdefined_geom is null)
					LOOP
							-- Update vnode geometry
						newPoint := ST_LineInterpolatePoint(NEW.the_geom, ST_LineLocatePoint(OLD.the_geom, vnoderec.the_geom));
						UPDATE vnode SET the_geom = newPoint WHERE vnode_id = vnoderec.vnode_id;

					END LOOP; 
				END IF;
				RETURN NEW;
			END IF;

-- Check auto insert end nodes
		ELSIF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NULL) AND (SELECT nodeinsert_arcendpoint FROM config) THEN
			IF TG_OP = 'INSERT' THEN

			INSERT INTO node (node_id, sector_id, epa_type, nodecat_id, dma_id, the_geom) 
				VALUES (
                (SELECT nextval('urn_id_seq')),
                (SELECT sector_id FROM sector WHERE (ST_endpoint(NEW.the_geom) @ sector.the_geom) LIMIT 1), 
				'JUNCTION'::text,
				(SELECT "value" FROM config_param_user WHERE "parameter"='nodecat_vdefault' AND "cur_user"="current_user"()),
                (SELECT dma_id FROM dma WHERE (ST_endpoint(NEW.the_geom) @ dma.the_geom) LIMIT 1), 
                ST_endpoint(NEW.the_geom)
				);

				INSERT INTO inp_junction (node_id) VALUES ((SELECT currval('urn_id_seq')));
				INSERT INTO man_junction (node_id) VALUES ((SELECT currval('urn_id_seq')));

			-- Update coordinates
			NEW.the_geom:= ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
			NEW.node_1:= nodeRecord1.node_id; 
			NEW.node_2:= (SELECT currval('urn_id_seq'));  
			RETURN NEW;
			END IF;
		
	--	Error, no existing nodes
		ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (rec.arc_searchnodes_control IS TRUE) THEN
			PERFORM audit_function (182,330);
		
	--	Not existing nodes but accepted insertion
		ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (rec.arc_searchnodes_control IS FALSE) THEN
			RETURN NEW;
			
		ELSE
			PERFORM audit_function (182,330);
		END IF;

END IF;
		
RETURN NEW;
		
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_topocontrol_arc ON "SCHEMA_NAME"."arc";
CREATE TRIGGER gw_trg_topocontrol_arc BEFORE INSERT OR UPDATE OF the_geom, "state" ON SCHEMA_NAME.arc
FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_topocontrol_arc();

