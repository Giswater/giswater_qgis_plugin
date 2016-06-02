/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_arc_searchnodes() RETURNS trigger LANGUAGE plpgsql AS $BODY$
DECLARE 
    nodeRecord1 record; 
    nodeRecord2 record; 
    rec record;    

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
            
            RETURN NEW;
            
        END IF;

    -- Check auto insert end nodes
    ELSEIF (nodeRecord1.node_id IS NOT NULL) AND (SELECT nodeinsert_arcendpoint FROM config) THEN

        INSERT INTO node (node_id, sector_id, epa_type, nodecat_id, dma_id, the_geom) 
            VALUES (
                (SELECT nextval('SCHEMA_NAME.node_id_seq')),
                (SELECT sector_id FROM sector WHERE (ST_endpoint(NEW.the_geom) @ sector.the_geom) LIMIT 1), 
                'JUNCTION', 
                (SELECT nodeinsert_catalog_vdefault FROM config), 
                (SELECT dma_id FROM dma WHERE (ST_endpoint(NEW.the_geom) @ dma.the_geom) LIMIT 1), 
                ST_endpoint(NEW.the_geom)
            );

        INSERT INTO inp_junction (node_id) VALUES ((SELECT currval('SCHEMA_NAME.node_id_seq')));
        INSERT INTO man_junction (node_id) VALUES ((SELECT currval('SCHEMA_NAME.node_id_seq')));

        -- Update coordinates
        NEW.the_geom:= ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
        NEW.node_1:= nodeRecord1.node_id; 
        NEW.node_2:= (SELECT currval('SCHEMA_NAME.node_id_seq'));
                
        RETURN NEW;

    -- Error, no existing nodes
    ELSE
        RAISE EXCEPTION '[%]: Arc was not inserted', TG_NAME;
        RETURN NULL;
    END IF;

END;
$BODY$;



CREATE TRIGGER gw_trg_arc_searchnodes_insert BEFORE INSERT ON "SCHEMA_NAME"."arc" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_arc_searchnodes"();

