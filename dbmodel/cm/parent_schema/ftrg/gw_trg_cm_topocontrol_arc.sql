/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: xxxx

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_topocontrol_arc()
RETURNS trigger AS
$BODY$

DECLARE
    -- Configuration
    v_search_tolerance double precision;
    v_state_filter boolean := TRUE;

    -- State
    v_node_start RECORD;
    v_node_end RECORD;
BEGIN
    -- Get configurable tolerance from system parameters
    SELECT ((value::json)->>'value') INTO v_search_tolerance 
    FROM PARENT_SCHEMA.config_param_system 
    WHERE parameter='edit_arc_searchnodes';
    
    -- Fallback to default if not configured
    IF v_search_tolerance IS NULL THEN
        v_search_tolerance := 0.1;
    END IF;

    -- This trigger runs on the 'om_campaign_x_arc' table.
    -- If the geometry is not being changed, there is nothing to do.
    IF NEW.the_geom IS NULL THEN
        RETURN NEW;
    END IF;


    -- === TOPOLOGY LOGIC - SELF-CONTAINED ===

    -- Find the nearest start and end nodes for the new geometry
    SELECT node.*, cfn.isarcdivide INTO v_node_start 
    FROM PARENT_SCHEMA.node
    JOIN PARENT_SCHEMA.cat_node ON cat_node.id = node.nodecat_id
    JOIN PARENT_SCHEMA.cat_feature_node cfn ON cfn.id = cat_node.node_type
    WHERE ST_DWithin(ST_StartPoint(NEW.the_geom), node.the_geom, v_search_tolerance)
      AND (node.state = 1 OR v_state_filter = FALSE) -- Only active nodes unless disabled
    ORDER BY (CASE WHEN COALESCE(cfn.isarcdivide, FALSE) IS TRUE THEN 1 ELSE 2 END),
             ST_Distance(ST_StartPoint(NEW.the_geom), node.the_geom) LIMIT 1;

    SELECT node.*, cfn.isarcdivide INTO v_node_end 
    FROM PARENT_SCHEMA.node
    JOIN PARENT_SCHEMA.cat_node ON cat_node.id = node.nodecat_id
    JOIN PARENT_SCHEMA.cat_feature_node cfn ON cfn.id = cat_node.node_type
    WHERE ST_DWithin(ST_EndPoint(NEW.the_geom), node.the_geom, v_search_tolerance)
      AND (node.state = 1 OR v_state_filter = FALSE) -- Only active nodes unless disabled
    ORDER BY (CASE WHEN COALESCE(cfn.isarcdivide, FALSE) IS TRUE THEN 1 ELSE 2 END),
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