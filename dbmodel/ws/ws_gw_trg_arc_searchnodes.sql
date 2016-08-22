/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION gw_trg_arc_searchnodes() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    nodeRecord1 record; 
    nodeRecord2 record; 
    rec record;    

BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    SET LC_MESSAGES TO 'es_ES.UTF-8';
    
    -- Get data from config table
    SELECT * INTO rec FROM config; 

    SELECT * INTO nodeRecord1 FROM node WHERE ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, rec.arc_searchnodes)
    ORDER BY ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;

    SELECT * INTO nodeRecord2 FROM node WHERE ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, rec.arc_searchnodes)
    ORDER BY ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;

    -- Control of start/end node
    IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL)  THEN

        -- Control of same node initial and final
        IF (nodeRecord1.node_id = nodeRecord2.node_id) AND (rec.samenode_init_end_control IS TRUE) THEN
            RETURN audit_function (180,330);

        ELSE
        
            -- Update coordinates
            NEW.the_geom:= ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
            NEW.the_geom:= ST_SetPoint(NEW.the_geom, ST_NumPoints(NEW.the_geom) - 1, nodeRecord2.the_geom);
            NEW.node_1:= nodeRecord1.node_id; 
            NEW.node_2:= nodeRecord2.node_id;
            
            RETURN NEW;
            
        END IF;

    -- Check auto insert end nodes
    ELSIF (nodeRecord1.node_id IS NOT NULL) AND (SELECT nodeinsert_arcendpoint FROM config) THEN

        INSERT INTO node (node_id, sector_id, epa_type, nodecat_id, dma_id, the_geom) 
            VALUES (
                (SELECT nextval('test_ws_0817.node_id_seq')),
                (SELECT sector_id FROM sector WHERE (ST_endpoint(NEW.the_geom) @ sector.the_geom) LIMIT 1), 
                'JUNCTION', 
                (SELECT nodeinsert_catalog_vdefault FROM config), 
                (SELECT dma_id FROM dma WHERE (ST_endpoint(NEW.the_geom) @ dma.the_geom) LIMIT 1), 
                ST_endpoint(NEW.the_geom)
            );

        INSERT INTO inp_junction (node_id) VALUES ((SELECT currval('test_ws_0817.node_id_seq')));
        INSERT INTO man_junction (node_id) VALUES ((SELECT currval('test_ws_0817.node_id_seq')));

        -- Update coordinates
        NEW.the_geom:= ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
        NEW.node_1:= nodeRecord1.node_id; 
        NEW.node_2:= (SELECT currval('test_ws_0817.node_id_seq'));
                
        RETURN NEW;

    -- Error, no existing nodes
       
    ELSIF ((nodeRecord1.node_id IS NULL) OR (nodeRecord2.node_id IS NULL)) AND (rec.arc_searchnodes_control IS TRUE) THEN
        PERFORM audit_function (182,330);
        RETURN NULL;

    ELSE
        INSERT INTO anl_arc_no_startend_node (arc_id, the_geom) VALUES (NEW.arc_id, NEW.the_geom);
        RETURN NEW;

    END IF;

END;
$$;


DROP TRIGGER IF EXISTS gw_trg_arc_searchnodes ON "SCHEMA_NAME"."arc";
CREATE TRIGGER gw_trg_arc_searchnodes BEFORE INSERT OR UPDATE ON "SCHEMA_NAME"."arc" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_arc_searchnodes"();

