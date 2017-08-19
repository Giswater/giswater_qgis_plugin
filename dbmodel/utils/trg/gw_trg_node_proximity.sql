/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_node_proximity() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
    numNodes numeric;
    rec record;
    psector_vdefault_var integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get node tolerance from config table
    SELECT * INTO rec FROM config;


 -- Looking for state=2 control
    PERFORM gw_fct_state_control('node', NEW.node_id, NEW.state, TG_OP);
    

    -- Lookig for state=0
    IF NEW.state=0 THEN
	RAISE WARNING 'Topology is not enabled with state=0. The feature will be disconected of the network';

    ELSE 
        IF TG_OP = 'INSERT' THEN
		-- Existing nodes  
		numNodes:= (SELECT COUNT(*) FROM v_edit_node WHERE ST_DWithin(NEW.the_geom, v_edit_node.the_geom, rec.node_proximity)) ;

	ELSIF TG_OP = 'UPDATE' THEN
		-- Existing nodes  
		numNodes := (SELECT COUNT(*) FROM v_edit_node WHERE ST_DWithin(NEW.the_geom, v_edit_node.the_geom, rec.node_proximity));
	END IF;

	-- If there is an existing node closer than 'rec.node_tolerance' meters --> error
	IF (numNodes > 0) AND (rec.node_proximity_control IS TRUE) THEN
		PERFORM audit_function(190,170);
		RETURN NULL;
	END IF;

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

