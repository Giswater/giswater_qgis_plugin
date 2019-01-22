/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1142



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_vnode_proximity()
  RETURNS trigger AS
$BODY$
DECLARE 
    numNodes numeric;
    rec record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get node tolerance from config table
    SELECT * INTO rec FROM config;

    IF TG_OP = 'INSERT' THEN
        -- Existing nodes  
        numNodes:= (SELECT COUNT(*) FROM vnode WHERE ST_DWithin(NEW.the_geom, vnode.the_geom, rec.node_proximity) AND vnode.vnode_id != NEW.vnode_id);

    ELSIF TG_OP = 'UPDATE' THEN
        -- Existing vnodes  
       numNodes := (SELECT COUNT(*) FROM vnode WHERE ST_DWithin(NEW.the_geom, vnode.the_geom, rec.node_proximity) AND vnode.vnode_id != NEW.vnode_id);
    END IF;

    -- If there is an existing vnode closer than 'rec.node_tolerance' meters --> error
    IF (numNodes > 0) AND (rec.node_proximity_control IS TRUE) THEN
	PERFORM audit_function(2020,1142);
        RETURN NULL;
    END IF;

    RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


  DROP TRIGGER IF EXISTS gw_trg_vnode_proximity_insert ON "SCHEMA_NAME"."vnode";
CREATE TRIGGER gw_trg_vnode_proximity_insert BEFORE INSERT ON "SCHEMA_NAME"."vnode" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_vnode_proximity"();

DROP TRIGGER IF EXISTS gw_trg_vnode_proximity_update ON "SCHEMA_NAME"."vnode";
CREATE TRIGGER gw_trg_vnode_proximity_update AFTER UPDATE OF the_geom ON "SCHEMA_NAME"."vnode" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_vnode_proximity"();

