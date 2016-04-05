/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_connec_proximity() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    numNodes numeric;
    rec record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get node tolerance from config table
    SELECT node_tolerance INTO rec FROM config;
    
    -- Existing nodes
    numNodes:= (SELECT COUNT(*) FROM connec WHERE connec.the_geom && ST_Expand(NEW.the_geom, rec.node_tolerance));

    -- If there is an existing node closer than 'rec.node_tolerance' meters --> error
    IF (numNodes > 0) THEN
        RAISE EXCEPTION '[%]: Please, check your project or modify the configuration properties. Exists one o more nodes closer than minimum configured, connec_id', TG_NAME;
    END IF;

    RETURN NEW;
    
END; 
$$;


--CREATE TRIGGER gw_trg_connec_insert_proximity BEFORE INSERT ON "SCHEMA_NAME"."connec" 
--FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_proximity"();

--CREATE TRIGGER gw_trg_connec_update_proximity BEFORE UPDATE ON "SCHEMA_NAME"."connec" 
--FOR EACH ROW WHEN (((old.the_geom IS DISTINCT FROM new.the_geom))) EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_proximity"();

