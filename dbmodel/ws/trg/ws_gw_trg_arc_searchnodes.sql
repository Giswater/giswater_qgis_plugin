/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_searchnodes() RETURNS trigger AS $BODY$
DECLARE 
    nodeRecord1 record; 
    nodeRecord2 record; 
    rec record;  
    vnoderec record;
    newPoint public.geometry;    
    connecPoint public.geometry;
	check_aux boolean;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Get data from config table
    SELECT * INTO rec FROM config;  
	SELECT arc_topocoh INTO check_aux FROM value_state where NEW.state=id;
	
   SELECT * INTO nodeRecord1 FROM node WHERE (ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, rec.arc_searchnodes) AND ((check_aux IS true AND NEW.state=node.state) OR check_aux IS false))
    ORDER BY ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;
	
	SELECT * INTO nodeRecord2 FROM node WHERE (ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, rec.arc_searchnodes) AND ((check_aux IS true AND NEW.state=node.state) OR check_aux IS false))
    ORDER BY ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;
   

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
                FOR vnoderec IN SELECT * FROM vnode WHERE ST_DWithin(OLD.the_geom, the_geom, 0.01)
                LOOP

                    -- Update vnode geometry
                    newPoint := ST_LineInterpolatePoint(NEW.the_geom, ST_LineLocatePoint(OLD.the_geom, vnoderec.the_geom));
                    UPDATE vnode SET the_geom = newPoint WHERE vnode_id = vnoderec.vnode_id;

                    -- Update link
                    connecPoint := (SELECT the_geom FROM connec WHERE connec_id IN (SELECT a.feature_id FROM link AS a WHERE a.vnode_id = vnoderec.vnode_id));
                    UPDATE link SET the_geom = ST_MakeLine(connecPoint, newPoint) WHERE vnode_id = vnoderec.vnode_id;

                END LOOP; 
            END IF;
            RETURN NEW;
 
        END IF;

    -- Check auto insert end nodes
    ELSIF (nodeRecord1.node_id IS NOT NULL) AND (SELECT nodeinsert_arcendpoint FROM config) THEN

        INSERT INTO node (node_id, sector_id, epa_type, nodecat_id, dma_id, the_geom) 
            VALUES (
                (SELECT nextval('urn_id_seq')),
                (SELECT sector_id FROM sector WHERE (ST_endpoint(NEW.the_geom) @ sector.the_geom) LIMIT 1), 
                (SELECT nodecat_vdefault FROM config_vdefault WHERE user=cur_user()), 
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


    -- Error, no existing nodes or there is an inchoerence of states
    ELSIF (check_aux IS true AND (nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) THEN
		RETURN audit_function (210,330);
		
    ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (rec.arc_searchnodes_control IS TRUE) THEN
        RETURN audit_function (182,330);
		
    ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (rec.arc_searchnodes_control IS FALSE) THEN
        RETURN NEW;
		
	END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_arc_searchnodes ON "SCHEMA_NAME"."arc";
CREATE TRIGGER gw_trg_arc_searchnodes BEFORE INSERT OR UPDATE OF the_geom ON SCHEMA_NAME.arc
FOR EACH ROW  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_arc_searchnodes();

