/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_trg_arc_searchnodes_update"() RETURNS "pg_catalog"."trigger" AS $BODY$
DECLARE 
    nodeRecord1 record; 
    nodeRecord2 record; 
    rec record;  
    vnoderec record;
    newPoint geometry;    
    connecPoint geometry;

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Get snapping_tolerance from config table
    SELECT arc_searchnodes INTO rec FROM config;    

    SELECT * INTO nodeRecord1 FROM node WHERE ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, rec.arc_searchnodes)
	    ORDER BY ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;

    SELECT * INTO nodeRecord2 FROM node WHERE ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, rec.arc_searchnodes)
    ORDER BY ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;

    -- Control of length line
    IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN
    
        -- Control of same node initial and final
        IF (nodeRecord1.node_id = nodeRecord2.node_id) THEN
            RAISE EXCEPTION '[%]: One or more features has the same Node as Node1 and Node2. Please check your project and repair it!', TG_NAME;
        ELSE
            -- Update coordinates
            NEW.the_geom:= ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
            NEW.the_geom:= ST_SetPoint(NEW.the_geom, ST_NumPoints(NEW.the_geom) - 1, nodeRecord2.the_geom);
            NEW.node_1:= nodeRecord1.node_id; 
            NEW.node_2:= nodeRecord2.node_id;

            -- Select arcs with start-end on the updated node
            FOR vnoderec IN SELECT * FROM vnode WHERE ST_DWithin(OLD.the_geom, the_geom, 0.01)
            LOOP

                -- Update vnode geometry
                newPoint := ST_LineInterpolatePoint(NEW.the_geom, ST_LineLocatePoint(OLD.the_geom, vnoderec.the_geom));
                UPDATE vnode SET the_geom = newPoint WHERE vnode_id = vnoderec.vnode_id;

                -- Update link
                connecPoint := (SELECT the_geom FROM connec WHERE connec_id IN (SELECT a.connec_id FROM link AS a WHERE a.vnode_id = vnoderec.vnode_id));
                UPDATE link SET the_geom = ST_MakeLine(connecPoint, newPoint) WHERE vnode_id = vnoderec.vnode_id;

            END LOOP; 
            RETURN NEW;
 
        END IF;
        
    ELSE
        RAISE EXCEPTION '[%]: Arc was not inserted', TG_NAME;
        RETURN NULL;
    END IF;

END; 
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100;



CREATE TRIGGER gw_trg_arc_searchnodes_update BEFORE UPDATE OF the_geom ON "SCHEMA_NAME"."arc" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_arc_searchnodes_update"();

