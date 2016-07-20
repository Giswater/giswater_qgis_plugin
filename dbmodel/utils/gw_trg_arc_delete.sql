/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_arc_delete() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    rec record;
    numArcs integer;
    
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Get snapping_tolerance from config table
    SELECT orphannode_delete INTO rec FROM config; 

    -- Delete orphan nodes
    IF rec.orphannode_delete THEN
    
        SELECT count(*) INTO numArcs FROM arc WHERE node_1 = OLD.node_1 OR node_2 = OLD.node_1;
        IF numArcs = 0 THEN
            DELETE FROM node WHERE node_id = OLD.node_1;
        END IF;

        SELECT count(*) INTO numArcs FROM arc WHERE node_1 = OLD.node_2 OR node_2 = OLD.node_2;
        IF numArcs = 0 THEN
            DELETE FROM node WHERE node_id = OLD.node_2;
        END IF;

    END IF;

    RETURN OLD;

END;
$$;


CREATE TRIGGER gw_trg_arc_delete AFTER DELETE ON "SCHEMA_NAME"."arc" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_arc_delete"();

