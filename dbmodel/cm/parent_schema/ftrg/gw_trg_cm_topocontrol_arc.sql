/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: xxxx

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_topocontrol_arc()
RETURNS json AS
$BODY$

DECLARE
    -- Configuration
    v_search_tolerance double precision := 0.1;

    -- State
    v_node_start RECORD;
    v_node_end RECORD;
BEGIN
    -- This trigger runs on the 'om_campaign_x_arc' table.
    -- If the geometry is not being changed, there is nothing to do.
    IF NEW.the_geom IS NULL THEN
        RETURN NEW;
    END IF;


    -- === TOPOLOGY LOGIC - SELF-CONTAINED ===

    -- Find the nearest start and end nodes for the new geometry
    SELECT * INTO v_node_start FROM cm.node
    WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), node.the_geom, v_search_tolerance)
    ORDER BY (CASE WHEN COALESCE(node.isarcdivide, FALSE) IS TRUE THEN 1 ELSE 2 END),
             ST_Distance(ST_StartPoint(NEW.the_geom), node.the_geom) LIMIT 1;

    SELECT * INTO v_node_end FROM cm.node
    WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), node.the_geom, v_search_tolerance)
    ORDER BY (CASE WHEN COALESCE(node.isarcdivide, FALSE) IS TRUE THEN 1 ELSE 2 END),
             ST_Distance(ST_EndPoint(NEW.the_geom), node.the_geom) LIMIT 1;

    -- Validate the nodes found
    IF v_node_start.node_id IS NULL OR v_node_end.node_id IS NULL THEN
        RAISE EXCEPTION 'Topology Error: Campaign arc endpoints must be within % units of a node.', v_search_tolerance;
    END IF;
    IF v_node_start.node_id = v_node_end.node_id THEN
        RAISE EXCEPTION 'Topology Error: Campaign arc cannot start and end at the same node (ID: %)', v_node_start.node_id;
    END IF;


    -- ACTION - MODIFY THE INCOMING RECORD
    NEW.node_1 := v_node_start.node_id;
    NEW.node_2 := v_node_end.node_id;
    NEW.the_geom := ST_SetPoint(ST_SetPoint(NEW.the_geom, 0, v_node_start.the_geom), ST_NumPoints(NEW.the_geom) - 1, v_node_end.the_geom);


    -- RETURN VALUE - SAVE THE CHANGES
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;