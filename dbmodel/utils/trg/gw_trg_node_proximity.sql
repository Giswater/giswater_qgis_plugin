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
    replace_node_aux boolean;
    node_id_var varchar;
    node_rec record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get parameters
    SELECT * INTO rec FROM config;


 -- Looking for state=2 control
    PERFORM gw_fct_state_control('node', NEW.node_id, NEW.state, TG_OP);
  

    -- Lookig for state=0
    IF NEW.state=0 THEN
	RAISE WARNING 'Topology is not enabled with state=0. The feature will be inserted but disconected of the network!';

    ELSE 
        IF TG_OP = 'INSERT' OR TG_OP ='UPDATE' THEN

		-- Checking number of nodes 
		numNodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0);
		IF (numNodes = 0) THEN
			RETURN NEW;
		ELSIF (numNodes >1) AND (rec.node_proximity_control IS TRUE) THEN
			RAISE EXCEPTION 'There are more than one nodes on the same position. Please, review your project data!';
		ELSIF (numNodes =1) AND (rec.node_proximity_control IS TRUE) THEN
		SELECT * INTO node_rec FROM node WHERE ST_DWithin(NEW.the_geom, node.the_geom, rec.node_proximity) AND node.node_id != NEW.node_id AND node.state!=0;
			IF (NEW.state=1 AND node_rec.state=1) OR (NEW.state=2 AND node_rec.state=1) THEN
				RAISE EXCEPTION 'To insert/move one node with state(1)or(2) over one existing node with state(1) please use the buttom replace node!';
			ELSIF (NEW.state=1 AND node.state=2) THEN
				RETURN NEW;
			ELSIF (NEW.state=2 AND node_rec.state=2) THEN
				RAISE EXCEPTION 'Insert node with state(2) over node with state(2) is not allowed. Please, review your project data!';
			END IF;
			RETURN NEW;
		END IF;
	ELSE 
		RETURN NEW;
	END IF;
	
    END IF;

    RETURN NEW;
    
END; 
$$;


DROP TRIGGER IF EXISTS gw_trg_node_proximity_insert ON "SCHEMA_NAME"."node";
CREATE TRIGGER gw_trg_node_proximity_insert BEFORE INSERT ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_proximity"();

DROP TRIGGER IF EXISTS gw_trg_node_proximity_update ON "SCHEMA_NAME"."node";
CREATE TRIGGER gw_trg_node_proximity_update BEFORE UPDATE OF the_geom, state ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_proximity"();

