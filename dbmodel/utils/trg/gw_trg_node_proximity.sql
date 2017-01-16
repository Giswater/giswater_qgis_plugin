/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_node_proximity() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    numNodes numeric;
    rec record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get node tolerance from config table
    SELECT * INTO rec FROM config;

    IF TG_OP = 'INSERT' THEN
        -- Existing nodes  
        numNodes:= (SELECT COUNT(*) FROM node WHERE node.the_geom && ST_Expand(NEW.the_geom, rec.node_proximity));

    ELSIF TG_OP = 'UPDATE' THEN
        -- Existing nodes  
       numNodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id);
    END IF;

    -- If there is an existing node closer than 'rec.node_tolerance' meters --> error
    IF (numNodes > 0) AND (rec.node_proximity_control IS TRUE) THEN
        PERFORM audit_function(190,170);
        RETURN NULL;
    END IF;

    RETURN NEW;
    
END; 
$$;


DROP TRIGGER IF EXISTS gw_trg_node_proximity_insert ON "SCHEMA_NAME"."node";
CREATE TRIGGER gw_trg_node_proximity_insert BEFORE INSERT ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_proximity"();

DROP TRIGGER IF EXISTS gw_trg_node_proximity_update ON "SCHEMA_NAME"."node";
CREATE TRIGGER gw_trg_node_proximity_update BEFORE UPDATE OF the_geom ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_proximity"();

