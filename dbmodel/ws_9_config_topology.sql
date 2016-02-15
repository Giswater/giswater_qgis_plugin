/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-----------------------------
-- NODE PROXIMITY
-----------------------------


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".node_proximity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE 
	numNodes numeric;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

 --		Existing nodes
		numNodes := (SELECT COUNT(*) FROM node nodeOld WHERE nodeOld.the_geom && ST_Expand(NEW.the_geom, 0.1));

--		If there is an existing node closer than 0.1 meters --> error
		IF (numNodes > 0) THEN
			RAISE EXCEPTION 'Please, check your project or modify the configuration propierties. Exists one o more nodes closer than minimum configured, node_id = (%)', node_ID;
		END IF;
		RETURN NEW;
END;
$$;


CREATE TRIGGER node_proximity_insert BEFORE INSERT ON "SCHEMA_NAME"."node" FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."node_proximity"();
CREATE TRIGGER node_proximity_update AFTER UPDATE ON "SCHEMA_NAME"."node" FOR EACH ROW WHEN (((old.the_geom IS DISTINCT FROM new.the_geom) )) EXECUTE PROCEDURE "SCHEMA_NAME"."node_proximity"();







-----------------------------
-- ARC-NODE TOPOLOGY
-----------------------------

CREATE OR REPLACE FUNCTION SCHEMA_NAME.arc_searchnodes() RETURNS trigger LANGUAGE plpgsql AS $$

DECLARE 
	nodeRecord1 Record; 
	nodeRecord2 Record; 

 BEGIN 

 	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	SELECT * INTO nodeRecord1 FROM node WHERE node.the_geom && ST_Expand(ST_startpoint(NEW.the_geom), 0.5)
		ORDER BY ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;

	SELECT * INTO nodeRecord2 FROM node WHERE node.the_geom && ST_Expand(ST_endpoint(NEW.the_geom), 0.5)
		ORDER BY ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;

--  Control of length line
    IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN
		
--  Control of same node initial and final
    IF (nodeRecord1.node_id = nodeRecord2.node_id) THEN
	RAISE EXCEPTION 'One or more features has the same Node as Node1 and Node2. Please check your project and repair it!';
	ELSE
		
--  Update coordinates
			NEW.the_geom := ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
			NEW.the_geom := ST_SetPoint(NEW.the_geom, ST_NumPoints(NEW.the_geom) - 1, nodeRecord2.the_geom);
			NEW.node_1 := nodeRecord1.node_id; 
			NEW.node_2 := nodeRecord2.node_id;
			RETURN NEW;
	END IF;
	ELSE
	RETURN NULL;
	END IF;

END; 
$$;



CREATE TRIGGER arc_searchnodes_insert BEFORE INSERT ON "SCHEMA_NAME"."arc" FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."arc_searchnodes"();
CREATE TRIGGER arc_searchnodes_update AFTER UPDATE ON "SCHEMA_NAME"."arc" FOR EACH ROW WHEN (((old.the_geom IS DISTINCT FROM new.the_geom) )) EXECUTE PROCEDURE "SCHEMA_NAME"."arc_searchnodes"();





