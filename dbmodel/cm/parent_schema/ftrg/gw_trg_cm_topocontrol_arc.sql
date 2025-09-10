/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3500

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_topocontrol_arc()
RETURNS trigger AS
$BODY$

DECLARE
    -- Configuration
    v_search_tolerance double precision;
    v_state_filter boolean := TRUE;
    v_disable_topocontrol boolean := FALSE;

    -- State
    v_node_start RECORD;
    v_node_end RECORD;
    v_campaign_id integer;
    v_campaign_geom geometry;
    v_working_geom geometry;
    v_prev_search_path text;
BEGIN
    -- Set transaction-local search_path (ensure cm and parent available) and remember previous
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', format('%I, cm, PARENT_SCHEMA, public', TG_TABLE_SCHEMA), true);

    -- Get configurable tolerance from system parameters
    SELECT ((value::json)->>'value') INTO v_search_tolerance 
    FROM PARENT_SCHEMA.config_param_system 
    WHERE parameter='edit_arc_searchnodes';
    
    -- Check per-user flag to disable CM topology control
    SELECT COALESCE((SELECT value::boolean FROM cm.config_param_user WHERE parameter='edit_disable_topocontrol' AND cur_user = current_user), FALSE)
    INTO v_disable_topocontrol;

    IF v_disable_topocontrol IS TRUE THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;
    END IF;
    
    -- Fallback to default if not configured
    IF v_search_tolerance IS NULL THEN
        v_search_tolerance := 0.1;
    END IF;

    -- This trigger can run on both 'om_campaign_x_arc' and 'om_campaign_lot_x_arc' tables.
    -- For campaign_x_arc table, use NEW.the_geom directly
    -- For lot_x_arc table, get geometry from campaign_x_arc table
    
    IF TG_TABLE_NAME = 'om_campaign_x_arc' THEN
        -- Campaign table has the_geom
        IF NEW.the_geom IS NULL THEN
            PERFORM set_config('search_path', v_prev_search_path, true);
            RETURN NEW;
        END IF;
        
        -- Skip topology control for temporary geometries (like selection areas)
        -- Check if this is likely a temporary geometry by looking at the geometry properties
        IF ST_NumPoints(NEW.the_geom) < 2 THEN
            PERFORM set_config('search_path', v_prev_search_path, true);
            RETURN NEW;
        END IF;
        
        -- Skip if the geometry hasn't actually changed (prevents unnecessary processing)
        IF TG_OP = 'UPDATE' AND OLD.the_geom IS NOT NULL AND ST_Equals(NEW.the_geom, OLD.the_geom) THEN
            PERFORM set_config('search_path', v_prev_search_path, true);
            RETURN NEW;
        END IF;
        
        v_working_geom := NEW.the_geom;
    ELSIF TG_TABLE_NAME = 'om_campaign_lot_x_arc' THEN
        -- Lot table doesn't have the_geom, get it from campaign table
        SELECT campaign_id INTO v_campaign_id 
        FROM cm.om_campaign_lot 
        WHERE lot_id = NEW.lot_id;
        
        SELECT the_geom INTO v_campaign_geom
        FROM cm.om_campaign_x_arc 
        WHERE campaign_id = v_campaign_id AND arc_id = NEW.arc_id;
        
        IF v_campaign_geom IS NULL THEN
            PERFORM set_config('search_path', v_prev_search_path, true);
            RETURN NEW;
        END IF;
        v_working_geom := v_campaign_geom;
    ELSE
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;
    END IF;


    -- === TOPOLOGY LOGIC - SELF-CONTAINED ===

    -- Additional safety checks to prevent crashes
    IF v_working_geom IS NULL OR ST_IsEmpty(v_working_geom) OR NOT ST_IsValid(v_working_geom) THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;
    END IF;
    
    -- For INSERT operations, be more lenient with topology control
    -- Skip topology control for INSERT if the geometry seems problematic
    IF TG_OP = 'INSERT' AND (ST_NumPoints(v_working_geom) < 2 OR ST_Length(v_working_geom) < 0.001) THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;
    END IF;

    -- Find the nearest start and end nodes for the working geometry
    SELECT node.*, cfn.isarcdivide INTO v_node_start 
    FROM PARENT_SCHEMA.node
    JOIN PARENT_SCHEMA.cat_node ON cat_node.id = node.nodecat_id
    JOIN PARENT_SCHEMA.cat_feature_node cfn ON cfn.id = cat_node.node_type
    WHERE ST_DWithin(ST_StartPoint(v_working_geom), node.the_geom, v_search_tolerance)
      AND (node.state = 1 OR v_state_filter = FALSE) -- Only active nodes unless disabled
    ORDER BY (CASE WHEN COALESCE(cfn.isarcdivide, FALSE) IS TRUE THEN 1 ELSE 2 END),
             ST_Distance(ST_StartPoint(v_working_geom), node.the_geom) LIMIT 1;

    SELECT node.*, cfn.isarcdivide INTO v_node_end 
    FROM PARENT_SCHEMA.node
    JOIN PARENT_SCHEMA.cat_node ON cat_node.id = node.nodecat_id
    JOIN PARENT_SCHEMA.cat_feature_node cfn ON cfn.id = cat_node.node_type
    WHERE ST_DWithin(ST_EndPoint(v_working_geom), node.the_geom, v_search_tolerance)
      AND (node.state = 1 OR v_state_filter = FALSE) -- Only active nodes unless disabled
    ORDER BY (CASE WHEN COALESCE(cfn.isarcdivide, FALSE) IS TRUE THEN 1 ELSE 2 END),
             ST_Distance(ST_EndPoint(v_working_geom), node.the_geom) LIMIT 1;

    -- Validate the nodes found
    IF v_node_start.node_id IS NULL OR v_node_end.node_id IS NULL THEN
        -- For INSERT operations, be more lenient - just log a warning instead of raising exception
        IF TG_OP = 'INSERT' THEN
            RAISE WARNING 'Topology Warning: Campaign arc endpoints not within % units of a node. Arc will be inserted without topology control.', v_search_tolerance;
            PERFORM set_config('search_path', v_prev_search_path, true);
            RETURN NEW;
        ELSE
            PERFORM set_config('search_path', v_prev_search_path, true);
            RAISE EXCEPTION 'Topology Error: Campaign arc endpoints must be within % units of a node.', v_search_tolerance;
        END IF;
    END IF;
    IF v_node_start.node_id = v_node_end.node_id THEN
        -- For INSERT operations, be more lenient - just log a warning instead of raising exception
        IF TG_OP = 'INSERT' THEN
            RAISE WARNING 'Topology Warning: Campaign arc starts and ends at the same node (ID: %). Arc will be inserted without topology control.', v_node_start.node_id;
            PERFORM set_config('search_path', v_prev_search_path, true);
            RETURN NEW;
        ELSE
            PERFORM set_config('search_path', v_prev_search_path, true);
            RAISE EXCEPTION 'Topology Error: Campaign arc cannot start and end at the same node (ID: %)', v_node_start.node_id;
        END IF;
    END IF;


    -- ACTION - MODIFY THE INCOMING RECORD
    NEW.node_1 := v_node_start.node_id;
    NEW.node_2 := v_node_end.node_id;
    
    -- Update geometry based on which table we're working with
    IF TG_TABLE_NAME = 'om_campaign_x_arc' THEN
        NEW.the_geom := ST_SetPoint(ST_SetPoint(NEW.the_geom, 0, v_node_start.the_geom), ST_NumPoints(NEW.the_geom) - 1, v_node_end.the_geom);
    ELSIF TG_TABLE_NAME = 'om_campaign_lot_x_arc' THEN
        -- Update the campaign_x_arc table with the corrected geometry and nodes
        UPDATE cm.om_campaign_x_arc 
        SET node_1 = v_node_start.node_id,
            node_2 = v_node_end.node_id,
            the_geom = ST_SetPoint(ST_SetPoint(v_campaign_geom, 0, v_node_start.the_geom), ST_NumPoints(v_campaign_geom) - 1, v_node_end.the_geom)
        WHERE campaign_id = v_campaign_id AND arc_id = NEW.arc_id;
    END IF;


    -- RETURN VALUE - SAVE THE CHANGES
    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN NEW;
EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('search_path', v_prev_search_path, true);
    RAISE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;