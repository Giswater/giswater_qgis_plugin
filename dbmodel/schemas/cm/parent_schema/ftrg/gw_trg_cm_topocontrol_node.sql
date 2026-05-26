/*
This file is part of Giswater
*/

--FUNCTION CODE: 3501

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_topocontrol_node()
RETURNS trigger AS
$BODY$
DECLARE
    v_tol double precision;
    v_campaign_id integer;
    v_node_geom geometry;
    v_count integer;
    v_has_arc boolean := false;
    v_disable_topocontrol boolean := FALSE;
    v_prev_search_path text;
BEGIN
    -- Set transaction-local search_path and remember previous
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', format('%I, cm, PARENT_SCHEMA, public', TG_TABLE_SCHEMA), true);

    -- tolerance: reuse arc searchnodes if no node-specific param
    SELECT COALESCE(((value::json)->>'value')::double precision, 0.1)
    INTO v_tol
    FROM PARENT_SCHEMA.config_param_system
    WHERE parameter IN ('edit_node_proximity','edit_arc_searchnodes')
    ORDER BY CASE WHEN parameter='edit_node_proximity' THEN 0 ELSE 1 END
    LIMIT 1;

    -- Check per-user flag to disable CM topology control
    SELECT COALESCE((SELECT value::boolean FROM cm.config_param_user WHERE parameter='edit_disable_topocontrol' AND cur_user = current_user), FALSE)
    INTO v_disable_topocontrol;

    IF v_disable_topocontrol IS TRUE THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;
    END IF;

    IF TG_TABLE_NAME = 'om_campaign_x_node' THEN
        -- use edited campaign node geometry when available, fallback to parent node
        IF NEW.the_geom IS NOT NULL THEN
            v_node_geom := NEW.the_geom;
        ELSE
            SELECT the_geom INTO v_node_geom FROM PARENT_SCHEMA.node WHERE node_id = NEW.node_id;
        END IF;
        v_campaign_id := NEW.campaign_id;
        -- 1) duplicate nodes within campaign
        SELECT COUNT(*) INTO v_count
        FROM PARENT_SCHEMA.node n
        JOIN cm.om_campaign_x_node cx ON cx.node_id = n.node_id AND cx.campaign_id = v_campaign_id
        WHERE n.node_id <> NEW.node_id AND ST_DWithin(n.the_geom, v_node_geom, 0.0001);
        IF v_count > 0 THEN
            IF TG_OP = 'INSERT' THEN
                RAISE WARNING 'Topology Warning: Duplicate node near existing node(s) in campaign % within tolerance.', v_campaign_id;
                PERFORM set_config('search_path', v_prev_search_path, true);
                RETURN NEW;
            ELSE
                PERFORM set_config('search_path', v_prev_search_path, true);
                RAISE EXCEPTION 'Topology Error: Duplicate node near existing node(s) in campaign % within tolerance.', v_campaign_id;
            END IF;
        END IF;

        -- 2) ensure node is near some campaign arc
        SELECT EXISTS (
            SELECT 1 FROM cm.om_campaign_x_arc a
            JOIN PARENT_SCHEMA.arc pa ON pa.arc_id = a.arc_id
            WHERE a.campaign_id = v_campaign_id AND ST_DWithin(pa.the_geom, v_node_geom, v_tol)
        ) INTO v_has_arc;
        IF NOT v_has_arc THEN
            IF TG_OP = 'INSERT' THEN
                RAISE WARNING 'Topology Warning: Node % is not near any campaign arc (tol=%).', NEW.node_id, v_tol;
                PERFORM set_config('search_path', v_prev_search_path, true);
                RETURN NEW;
            ELSE
                PERFORM set_config('search_path', v_prev_search_path, true);
                RAISE EXCEPTION 'Topology Error: Node % is not near any campaign arc (tol=%).', NEW.node_id, v_tol;
            END IF;
        END IF;

        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;

    ELSIF TG_TABLE_NAME = 'om_campaign_lot_x_node' THEN
        -- get node geom from parent table
        SELECT the_geom INTO v_node_geom FROM PARENT_SCHEMA.node WHERE node_id = NEW.node_id;
        -- campaign from lot
        SELECT campaign_id INTO v_campaign_id FROM cm.om_campaign_lot WHERE lot_id = NEW.lot_id;

        -- 1) duplicate nodes within lot
        SELECT COUNT(*) INTO v_count
        FROM PARENT_SCHEMA.node n
        JOIN cm.om_campaign_lot_x_node lx ON lx.node_id = n.node_id AND lx.lot_id = NEW.lot_id
        WHERE n.node_id <> NEW.node_id AND ST_DWithin(n.the_geom, v_node_geom, 0.0001);
        IF v_count > 0 THEN
            IF TG_OP = 'INSERT' THEN
                RAISE WARNING 'Topology Warning: Duplicate node near existing node(s) in lot % within tolerance.', NEW.lot_id;
                PERFORM set_config('search_path', v_prev_search_path, true);
                RETURN NEW;
            ELSE
                PERFORM set_config('search_path', v_prev_search_path, true);
                RAISE EXCEPTION 'Topology Error: Duplicate node near existing node(s) in lot % within tolerance.', NEW.lot_id;
            END IF;
        END IF;

        -- 2) ensure node is near some lot arc; fallback to campaign arcs if none in lot
        SELECT EXISTS (
            SELECT 1 FROM cm.om_campaign_lot_x_arc la
            JOIN PARENT_SCHEMA.arc pa ON pa.arc_id = la.arc_id
            WHERE la.lot_id = NEW.lot_id AND ST_DWithin(pa.the_geom, v_node_geom, v_tol)
        ) INTO v_has_arc;

        IF NOT v_has_arc AND v_campaign_id IS NOT NULL THEN
            SELECT EXISTS (
                SELECT 1 FROM cm.om_campaign_x_arc a
                JOIN PARENT_SCHEMA.arc pa ON pa.arc_id = a.arc_id
                WHERE a.campaign_id = v_campaign_id AND ST_DWithin(pa.the_geom, v_node_geom, v_tol)
            ) INTO v_has_arc;
        END IF;

        IF NOT v_has_arc THEN
            IF TG_OP = 'INSERT' THEN
                RAISE WARNING 'Topology Warning: Node % is not near any lot/campaign arc (tol=%).', NEW.node_id, v_tol;
                PERFORM set_config('search_path', v_prev_search_path, true);
                RETURN NEW;
            ELSE
                PERFORM set_config('search_path', v_prev_search_path, true);
                RAISE EXCEPTION 'Topology Error: Node % is not near any lot/campaign arc (tol=%).', NEW.node_id, v_tol;
            END IF;
        END IF;

        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;
    END IF;

    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN NEW;
EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('search_path', v_prev_search_path, true);
    RAISE;
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;


