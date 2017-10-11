/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_topocontrol_arc()
  RETURNS trigger AS
$BODY$
DECLARE 
    nodeRecord1 Record; 
    nodeRecord2 Record;
    optionsRecord Record;
    rec Record;
    z1 double precision;
    z2 double precision;
    z_aux double precision;
    vnoderec Record;
    newPoint public.geometry;    
    connecPoint public.geometry;
    value1 boolean;
    value2 boolean;
    featurecat_aux text;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

 -- Init variables
	
    value1:= true;
    value2:= true;
    IF NEW.y1 IS NULL then 
		NEW.y1=0;
		value1:=false;
    END IF;
		IF NEW.y2 IS NULL then 
		NEW.y2=0;
		value2:=false;
    END IF;
    
 -- Get data from config tables
    SELECT * INTO rec FROM config; 
    SELECT * INTO optionsRecord FROM inp_options LIMIT 1;   
	

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
	
	--  Control of start/end node
		IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN	

		-- Control de lineas de longitud 0
			IF (nodeRecord1.node_id = nodeRecord2.node_id) AND (rec.samenode_init_end_control IS TRUE) THEN
				PERFORM audit_function (180,750);
            
				ELSE
				-- Update coordinates
					NEW.the_geom := ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
					NEW.the_geom := ST_SetPoint(NEW.the_geom, ST_NumPoints(NEW.the_geom) - 1, nodeRecord2.the_geom);
		
					IF (optionsRecord.link_offsets = 'DEPTH') THEN
						z1 := (nodeRecord1.top_elev - NEW.y1);
						z2 := (nodeRecord2.top_elev - NEW.y2);
					ELSE
						z1 := NEW.y1;
						z2 := NEW.y2;
					END IF;
				
					IF value1 is false 
						then NEW.y1:= null; 
					END IF;
					IF value2 is false 
						then NEW.y2:= null; 
					END IF;
	
					IF ((z1 > z2) AND NEW.inverted_slope is not true) OR ((z1 < z2) AND NEW.inverted_slope is true) THEN
						NEW.node_1 := nodeRecord1.node_id; 
						NEW.node_2 := nodeRecord2.node_id;
					ELSE 
				
					-- Update conduit direction
						NEW.the_geom := ST_reverse(NEW.the_geom);
						z_aux := NEW.y1;
						NEW.y1 := NEW.y2;
						NEW.y2 := z_aux;
						NEW.node_1 := nodeRecord2.node_id;
						NEW.node_2 := nodeRecord1.node_id;                             
					END IF;
	
				-- Update vnode/link
					IF TG_OP = 'UPDATE' THEN
	
					-- Select arcs with start-end on the updated node
						FOR vnoderec IN SELECT * FROM vnode WHERE ST_DWithin(OLD.the_geom, the_geom, 0.01) AND (userdefined_pos=false OR userdefined_pos is null)
						LOOP
	
						-- Update vnode geometry
							newPoint := ST_LineInterpolatePoint(NEW.the_geom, ST_LineLocatePoint(OLD.the_geom, vnoderec.the_geom));
							UPDATE vnode SET the_geom = newPoint WHERE vnode_id = vnoderec.vnode_id;
			
						-- Update link
							featurecat_aux := (SELECT featurecat_id FROM link WHERE vnode_id = vnoderec.vnode_id);
				
							IF (featurecat_aux = 'connec') THEN 
								connecPoint := (SELECT the_geom FROM connec WHERE connec_id IN (SELECT a.feature_id FROM link AS a WHERE a.vnode_id = vnoderec.vnode_id));
								UPDATE link SET the_geom = ST_MakeLine(connecPoint, newPoint) WHERE vnode_id = vnoderec.vnode_id;
							ELSE
								connecPoint := (SELECT the_geom FROM gully WHERE gully_id IN (SELECT a.feature_id FROM link AS a WHERE a.vnode_id = vnoderec.vnode_id));
								UPDATE link SET the_geom = ST_MakeLine(connecPoint, newPoint) WHERE vnode_id = vnoderec.vnode_id;
							END IF;				
						END LOOP; 
					END IF; 
			END IF;

--  	Check auto insert end nodes
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

-- 		Error, no existing nodes
		ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (rec.arc_searchnodes_control IS TRUE) THEN
			PERFORM audit_function (182,750);
		
		
-- 		Not existing nodes but accepted insertion
		ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (rec.arc_searchnodes_control IS FALSE) THEN
			RETURN NEW;
        
		ELSE
			PERFORM audit_function (182,750);
		END IF;

END IF;

RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS gw_trg_topocontrol_arc ON "SCHEMA_NAME"."arc";
CREATE TRIGGER gw_trg_topocontrol_arc BEFORE INSERT OR UPDATE OF the_geom,"state" ON "SCHEMA_NAME"."arc" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_topocontrol_arc"();


