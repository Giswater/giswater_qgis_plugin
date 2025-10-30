/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3200

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_node_values()
RETURNS trigger AS
$BODY$
DECLARE
    v_nodecat               text;
    v_message               text;

    v_nodetype1             text;
    v_elevation1            double precision;
    v_depth1                double precision;
    v_staticpressure1       double precision;
    v_nodetype2             text;
    v_elevation2            double precision;
    v_depth2                double precision;
    v_staticpressure2       double precision;
BEGIN
    EXECUTE 'SET search_path TO ' || quote_literal(TG_TABLE_SCHEMA) || ', public';

    IF (SELECT value::boolean FROM config_param_user WHERE parameter = 'edit_disable_update_nodevalues' AND cur_user = current_user) IS NOT FALSE THEN

        -- Node 1 values
        WITH
        sel_state AS (
            SELECT selector_state.state_id
            FROM selector_state
            WHERE selector_state.cur_user = CURRENT_USER
        ),
        sel_sector AS (
            SELECT selector_sector.sector_id
            FROM selector_sector
            WHERE selector_sector.cur_user = CURRENT_USER
        ),
        sel_expl AS (
            SELECT selector_expl.expl_id
            FROM selector_expl
            WHERE selector_expl.cur_user = CURRENT_USER
        ),
        sel_muni AS (
            SELECT selector_municipality.muni_id
            FROM selector_municipality
            WHERE selector_municipality.cur_user = CURRENT_USER
        ),
        sel_ps AS (
            SELECT selector_psector.psector_id
            FROM selector_psector
            WHERE selector_psector.cur_user = CURRENT_USER
        ),
        node_psector AS (
            SELECT DISTINCT ON (pp.node_id, pp.state) pp.node_id, pp.state AS p_state
            FROM plan_psector_x_node pp
            WHERE EXISTS (
                SELECT 1
                FROM sel_ps s
                WHERE s.psector_id = pp.psector_id
            )
            ORDER BY pp.node_id, pp.state
        ),
        node_selector AS (
            SELECT n_1.node_id, NULL::smallint AS p_state
            FROM node n_1
            WHERE EXISTS (
                    SELECT 1 FROM sel_state s WHERE s.state_id = n_1.state
                )
                AND EXISTS (
                    SELECT 1 FROM sel_sector s WHERE s.sector_id = n_1.sector_id
                )
                AND EXISTS (
                    SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY(array_append(n_1.expl_visibility, n_1.expl_id))
                )
                AND EXISTS (
                    SELECT 1 FROM sel_muni s WHERE s.muni_id = n_1.muni_id
                )
                AND NOT EXISTS (
                    SELECT 1 FROM node_psector np WHERE np.node_id = n_1.node_id
                )
            UNION ALL
            SELECT np.node_id, np.p_state
            FROM node_psector np
            WHERE EXISTS (
                SELECT 1 FROM sel_state s WHERE s.state_id = np.p_state
            )
        )
        SELECT
            c.node_type,
            COALESCE(n.custom_top_elev, n.top_elev),
            n.depth,
            n.staticpressure
        INTO v_nodetype1, v_elevation1, v_depth1, v_staticpressure1
        FROM node_selector
        JOIN node n ON n.node_id = node_selector.node_id
        JOIN cat_node c ON n.nodecat_id = c.id
        WHERE n.node_id = NEW.node_1;

        -- Node 2 values
        WITH
        sel_state AS (
            SELECT selector_state.state_id
            FROM selector_state
            WHERE selector_state.cur_user = CURRENT_USER
        ),
        sel_sector AS (
            SELECT selector_sector.sector_id
            FROM selector_sector
            WHERE selector_sector.cur_user = CURRENT_USER
        ),
        sel_expl AS (
            SELECT selector_expl.expl_id
            FROM selector_expl
            WHERE selector_expl.cur_user = CURRENT_USER
        ),
        sel_muni AS (
            SELECT selector_municipality.muni_id
            FROM selector_municipality
            WHERE selector_municipality.cur_user = CURRENT_USER
        ),
        sel_ps AS (
            SELECT selector_psector.psector_id
            FROM selector_psector
            WHERE selector_psector.cur_user = CURRENT_USER
        ),
        node_psector AS (
            SELECT DISTINCT ON (pp.node_id, pp.state) pp.node_id, pp.state AS p_state
            FROM plan_psector_x_node pp
            WHERE EXISTS (
                SELECT 1
                FROM sel_ps s
                WHERE s.psector_id = pp.psector_id
            )
            ORDER BY pp.node_id, pp.state
        ),
        node_selector AS (
            SELECT n_1.node_id, NULL::smallint AS p_state
            FROM node n_1
            WHERE EXISTS (
                    SELECT 1 FROM sel_state s WHERE s.state_id = n_1.state
                )
                AND EXISTS (
                    SELECT 1 FROM sel_sector s WHERE s.sector_id = n_1.sector_id
                )
                AND EXISTS (
                    SELECT 1 FROM sel_expl s WHERE s.expl_id = ANY(array_append(n_1.expl_visibility, n_1.expl_id))
                )
                AND EXISTS (
                    SELECT 1 FROM sel_muni s WHERE s.muni_id = n_1.muni_id
                )
                AND NOT EXISTS (
                    SELECT 1 FROM node_psector np WHERE np.node_id = n_1.node_id
                )
            UNION ALL
            SELECT np.node_id, np.p_state
            FROM node_psector np
            WHERE EXISTS (
                SELECT 1 FROM sel_state s WHERE s.state_id = np.p_state
            )
        )
        SELECT
            c.node_type,
            COALESCE(n.custom_top_elev, n.top_elev),
            n.depth,
            n.staticpressure
        INTO v_nodetype2, v_elevation2, v_depth2, v_staticpressure2
        FROM node_selector
        JOIN node n ON n.node_id = node_selector.node_id
        JOIN cat_node c ON n.nodecat_id = c.id
        WHERE n.node_id = NEW.node_2;

        -- Update arc with obtained node values
        UPDATE arc SET
            nodetype_1 = v_nodetype1,
            elevation1 = v_elevation1,
            depth1 = v_depth1,
            staticpressure1 = v_staticpressure1,
            nodetype_2 = v_nodetype2,
            elevation2 = v_elevation2,
            depth2 = v_depth2,
            staticpressure2 = v_staticpressure2
        WHERE arc_id = NEW.arc_id;
    END IF;

    RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql
VOLATILE
COST 100;