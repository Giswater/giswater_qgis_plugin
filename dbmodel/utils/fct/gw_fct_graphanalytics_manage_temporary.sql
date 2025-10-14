/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3402

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_manage_temporary(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_manage_temporary(p_data json)
RETURNS json AS
$BODY$

/*
SELECT gw_fct_graphanalytics_manage_temporary('{"data":{"action": "CREATE", "fct_name":"MINSECTOR", "usePsector": "true", "expl_id": "1"}}');
SELECT gw_fct_graphanalytics_manage_temporary('{"data":{"action": "CREATE", "fct_name":"MINSECTOR", "usePsector": "false", "expl_id": "1, 2, 3, 4"}}');
SELECT gw_fct_graphanalytics_manage_temporary('{"data":{"action": "DROP", "fct_name":"MINSECTOR"}}');
*/

DECLARE

    -- configuration
    v_project_type TEXT;
    v_version TEXT;

    -- parameters
    v_fct_name TEXT;
    v_action TEXT;
    v_use_psector TEXT;
    v_netscenario TEXT;

    -- extra variables
    v_return_message TEXT;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
    v_fct_name = (SELECT (p_data::json->>'data')::json->>'fct_name');
    v_action = (SELECT (p_data::json->>'data')::json->>'action');
    v_use_psector = (SELECT (p_data::json->>'data')::json->>'use_psector');
    v_netscenario = (SELECT (p_data::json->>'data')::json->>'netscenario');

    IF v_action = 'CREATE' THEN
        -- Create temporary tables
        CREATE TEMP TABLE IF NOT EXISTS temp_pgr_mapzone (
            id SERIAL NOT NULL,
            component int4,
            mapzone_id _int4,
            name VARCHAR(50),
            the_geom geometry(Geometry, SRID_VALUE),
            CONSTRAINT temp_pgr_mapzone_pkey PRIMARY KEY (id)
        );
        CREATE INDEX IF NOT EXISTS temp_pgr_mapzone_component_idx ON temp_pgr_mapzone USING btree (component);


        CREATE TEMP TABLE IF NOT EXISTS temp_pgr_node (
            pgr_node_id SERIAL NOT NULL,
            node_id int4,
            old_node_id int4,
            mapzone_id INTEGER DEFAULT 0,
            old_mapzone_id INTEGER DEFAULT 0,
            modif BOOL DEFAULT FALSE,  -- True if nodes have to be disconnected - closed valves, starts of mapzones
            graph_delimiter VARCHAR(30) DEFAULT 'NONE',
            to_arc _int4,
            CONSTRAINT temp_pgr_node_pkey PRIMARY KEY (pgr_node_id)
        );
        CREATE INDEX IF NOT EXISTS temp_pgr_node_node_id_idx ON temp_pgr_node USING btree (node_id);
        CREATE INDEX IF NOT EXISTS temp_pgr_node_old_node_id_idx ON temp_pgr_node USING btree (old_node_id);


        CREATE TEMP TABLE IF NOT EXISTS temp_pgr_arc (
            pgr_arc_id SERIAL NOT NULL,
            arc_id int4,
            old_arc_id int4,
            pgr_node_1 INT,
            pgr_node_2 INT,
            node_1 int4,
            node_2 int4,
            mapzone_id INTEGER DEFAULT 0,
            old_mapzone_id INTEGER DEFAULT 0,
            graph_delimiter VARCHAR(30) DEFAULT 'NONE',
            modif1 BOOL DEFAULT FALSE,  -- True if arcs have to be disconnected on node_1
            modif2 BOOL DEFAULT FALSE,  -- True if arcs have to be disconnected on node_2
            cost INT DEFAULT 1,
            reverse_cost INT DEFAULT 1,
            to_arc _int4,
            CONSTRAINT temp_pgr_arc_pkey PRIMARY KEY (pgr_arc_id)
        );
        CREATE INDEX IF NOT EXISTS temp_pgr_arc_arc_id_idx ON temp_pgr_arc USING btree (arc_id);
        CREATE INDEX IF NOT EXISTS temp_pgr_arc_old_arc_id_idx ON temp_pgr_arc USING btree (old_arc_id);
        CREATE INDEX IF NOT EXISTS temp_pgr_arc_pgr_node1_idx ON temp_pgr_arc USING btree (pgr_node_1);
        CREATE INDEX IF NOT EXISTS temp_pgr_arc_pgr_node2_idx ON temp_pgr_arc USING btree (pgr_node_2);
        CREATE INDEX IF NOT EXISTS temp_pgr_arc_node1_idx ON temp_pgr_arc USING btree (node_1);
        CREATE INDEX IF NOT EXISTS temp_pgr_arc_node2_idx ON temp_pgr_arc USING btree (node_2);

        CREATE TEMP TABLE IF NOT EXISTS temp_pgr_drivingdistance (
                seq INT8 NOT NULL,
                "depth" INT8 NULL,
                start_vid INT8 NULL,
                pred INT8 NULL,
                node INT8 NULL,
                edge INT8 NULL,
                "cost" FLOAT8 NULL,
                agg_cost FLOAT8 NULL,
                CONSTRAINT temp_pgr_drivingdistance_pkey PRIMARY KEY (seq)
            );
        CREATE INDEX IF NOT EXISTS temp_pgr_drivingdistance_start_vid_idx ON temp_pgr_drivingdistance USING btree (start_vid);
        CREATE INDEX IF NOT EXISTS temp_pgr_drivingdistance_node_idx ON temp_pgr_drivingdistance USING btree (node);
        CREATE INDEX IF NOT EXISTS temp_pgr_drivingdistance_edge_idx ON temp_pgr_drivingdistance USING btree (edge);

        -- Create other additional temporary tables
        CREATE TEMP TABLE IF NOT EXISTS temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

        CREATE TEMP TABLE IF NOT EXISTS temp_pgr_connectedcomponents (
            seq INT8 NOT NULL,
            component INT8 NULL,
            node INT8 NULL,
            CONSTRAINT temp_pgr_connectedcomponents_pkey PRIMARY KEY (seq)
        );
        CREATE INDEX IF NOT EXISTS temp_pgr_connectedcomponents_component_idx ON temp_pgr_connectedcomponents USING btree (component);
        CREATE INDEX IF NOT EXISTS temp_pgr_connectedcomponents_node_idx ON temp_pgr_connectedcomponents USING btree (node);
        -- Create temporary tables depending on the project type
        IF v_project_type = 'WS' THEN
            ALTER TABLE temp_pgr_node ADD COLUMN IF NOT EXISTS closed BOOL;
            ALTER TABLE temp_pgr_node ADD COLUMN IF NOT EXISTS broken BOOL;

            ALTER TABLE temp_pgr_arc ADD COLUMN IF NOT EXISTS closed BOOL;
            ALTER TABLE temp_pgr_arc ADD COLUMN IF NOT EXISTS broken BOOL;

            -- for specific functions
            IF v_fct_name = 'MINCUT' OR v_fct_name = 'MINSECTOR' THEN
                ALTER TABLE temp_pgr_arc ADD COLUMN IF NOT EXISTS unaccess BOOL DEFAULT FALSE; -- if TRUE, it means the valve is not accessible
                ALTER TABLE temp_pgr_arc ADD COLUMN IF NOT EXISTS proposed BOOL DEFAULT FALSE;
                ALTER TABLE temp_pgr_arc ADD COLUMN IF NOT EXISTS cost_mincut INT DEFAULT 1;
                ALTER TABLE temp_pgr_arc ADD COLUMN IF NOT EXISTS reverse_cost_mincut INT DEFAULT 1;

                -- used for MASSIVE MINCUT or mincut v6.1 with minsector algorithm
                CREATE TEMP TABLE IF NOT EXISTS temp_pgr_node_minsector (LIKE temp_pgr_node INCLUDING ALL);
                CREATE TEMP TABLE IF NOT EXISTS temp_pgr_arc_minsector (LIKE temp_pgr_arc INCLUDING ALL);
            END IF;
            IF v_fct_name = 'MINSECTOR' THEN
                CREATE TEMP TABLE IF NOT EXISTS temp_pgr_minsector_graph (LIKE SCHEMA_NAME.minsector_graph INCLUDING ALL);
                CREATE TEMP TABLE IF NOT EXISTS temp_pgr_minsector (LIKE SCHEMA_NAME.minsector INCLUDING ALL);
                CREATE TEMP TABLE IF NOT EXISTS temp_pgr_minsector_mincut (LIKE SCHEMA_NAME.minsector_mincut INCLUDING ALL);
                CREATE TEMP TABLE IF NOT EXISTS temp_pgr_minsector_mincut_valve (LIKE SCHEMA_NAME.minsector_mincut_valve INCLUDING ALL);
            END IF;
            IF v_fct_name = 'DMA' AND v_netscenario IS NOT NULL THEN
                ALTER TABLE temp_pgr_mapzone ADD COLUMN IF NOT EXISTS pattern_id varchar(16);
                CREATE TEMP TABLE IF NOT EXISTS temp_pgr_om_waterbalance_dma_graph (LIKE SCHEMA_NAME.om_waterbalance_dma_graph INCLUDING ALL);
            END IF;
        ELSE 
            IF v_fct_name = 'DWFZONE' THEN
                ALTER TABLE temp_pgr_mapzone ADD COLUMN  IF NOT EXISTS min_node int4;
                ALTER TABLE temp_pgr_mapzone ADD COLUMN  IF NOT EXISTS drainzone_id INTEGER DEFAULT 0;
                CREATE TEMP TABLE IF NOT EXISTS temp_pgr_drivingdistance_initoverflowpath (
                    seq INT8 NOT NULL,
                    "depth" INT8 NULL,
                    start_vid INT8 NULL,
                    pred INT8 NULL,
                    node INT8 NULL,
                    edge INT8 NULL,
                    "cost" FLOAT8 NULL,
                    agg_cost FLOAT8 NULL,
                    CONSTRAINT temp_pgr_drivingdistance_initoverflowpath_pkey PRIMARY KEY (seq)
                );
            CREATE INDEX IF NOT EXISTS temp_pgr_drivingdistance_initoverflowpath_start_vid_idx ON temp_pgr_drivingdistance_initoverflowpath USING btree (start_vid);
            CREATE INDEX IF NOT EXISTS temp_pgr_drivingdistance_initoverflowpath_node_idx ON temp_pgr_drivingdistance_initoverflowpath USING btree (node);
            CREATE INDEX IF NOT EXISTS temp_pgr_drivingdistance_initoverflowpath_edge_idx ON temp_pgr_drivingdistance_initoverflowpath USING btree (edge);
            END IF;
        END IF;


        -- Create temporary views
        CREATE OR REPLACE TEMPORARY VIEW v_temp_pgr_mapzone_old AS
        SELECT DISTINCT t.old_mapzone_id
        FROM temp_pgr_node t
        WHERE t.old_mapzone_id > 0;
        IF v_use_psector = 'true' THEN
            -- with psectors
            IF v_project_type = 'WS' THEN

                CREATE OR REPLACE TEMPORARY VIEW v_temp_arc AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ), arc_psector AS (
                    SELECT
                        pp.arc_id,
                        pp.state AS p_state
                    FROM plan_psector_x_arc pp
                    WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                ), arc_selector AS (
                    SELECT
                        a.arc_id
                    FROM arc a
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM arc_psector ap
                        WHERE ap.arc_id::text = a.arc_id::text AND ap.p_state = 0
                    ) AND a.state = 1
                    UNION ALL
                    SELECT arc_psector.arc_id
                    FROM arc_psector
                    WHERE arc_psector.p_state = 1
                ), arc_selected AS (
                    SELECT
                        a.arc_id,
                        a.node_1,
                        a.node_2,
                        a.expl_id,
                        a.sector_id,
                        a.presszone_id,
                        a.dma_id,
                        a.dqa_id,
                        a.supplyzone_id,
                        a.muni_id,
                        a.minsector_id,
                        a.arccat_id,
                        a.state,
                        a.the_geom
                    FROM arc_selector
                    JOIN arc a USING (arc_id)
                    JOIN value_state_type vst ON vst.id = a.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM arc_selected
                WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_node AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ), node_psector AS (
                    SELECT pp.node_id, pp.state AS p_state
                    FROM plan_psector_x_node pp
                    WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                ), node_selector AS (
                    SELECT n.node_id
                    FROM node n
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM node_psector np
                        WHERE np.node_id::text = n.node_id::text AND np.p_state = 0
                    ) AND n.state = 1
                    UNION ALL
                    SELECT np.node_id
                    FROM node_psector np
                    WHERE np.p_state = 1
                ), node_selected AS (
                    SELECT DISTINCT ON (node_id) node.node_id,
                    cf.graph_delimiter,
                    node.expl_id,
                    node.sector_id,
                    node.presszone_id,
                    node.dma_id,
                    node.dqa_id,
                    node.supplyzone_id,
                    node.muni_id,
                    node.minsector_id,
                    cn.node_type,
                    node.the_geom
                    FROM node_selector
                    JOIN node ON node.node_id::text = node_selector.node_id::text
                    JOIN cat_node cn ON cn.id = node.nodecat_id
                    JOIN cat_feature_node cf ON cf.id = cn.node_type
                    JOIN value_state_type vst ON vst.id = node.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM node_selected n;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_connec AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ), connec_psector AS (
                    SELECT DISTINCT ON (pp.connec_id, pp.state) pp.connec_id,
                        pp.state AS p_state,
                        pp.psector_id,
                        pp.arc_id,
                        pp.link_id
                    FROM plan_psector_x_connec pp
                    WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                    ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
                ), connec_selector AS (
                    SELECT
                        connec.connec_id,
                        connec.arc_id,
                        NULL::integer AS link_id
                    FROM connec
                    WHERE NOT EXISTS (
                    SELECT 1
                    FROM connec_psector cp
                    WHERE cp.connec_id::text = connec.connec_id::text AND cp.p_state = 0
                    ) AND connec.state = 1
                    UNION ALL
                    SELECT
                        connec_psector.connec_id,
                        connec_psector.arc_id,
                        connec_psector.link_id
                    FROM connec_psector
                    WHERE connec_psector.p_state = 1
                ), connec_selected AS (
                    SELECT DISTINCT ON (connec_id) connec.connec_id,
                        connec.arc_id,
                        connec.customer_code,
                        connec.expl_id,
                        connec.sector_id,
                        connec.presszone_id,
                        connec.dma_id,
                        connec.dqa_id,
                        connec.supplyzone_id,
                        connec.plot_code,
                        connec.muni_id,
                        connec.conneccat_id,
                        connec.state,
                        connec.minsector_id,
                        connec.the_geom
                    FROM connec_selector
                    JOIN connec ON connec.connec_id::text = connec_selector.connec_id::text
                    JOIN value_state_type vst ON vst.id = connec.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM connec_selected;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_link_connec AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ), link_psector AS (
                    SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC'::text AS feature_type,
                        pp.connec_id AS feature_id,
                        pp.state AS p_state,
                        pp.psector_id,
                        pp.link_id,
                        pp.arc_id
                    FROM plan_psector_x_connec pp
                    WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                    ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
                ), link_selector AS (
                    SELECT
                        l.link_id,
                        c.arc_id
                    FROM link l
                    JOIN connec c ON l.feature_id = c.connec_id
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM link_psector lp
                        WHERE lp.link_id::text = l.link_id::text AND lp.p_state = 0
                    )
                    AND l.state = 1
                    AND l.feature_type = 'CONNEC'
                    UNION ALL
                    SELECT
                        lp.link_id,
                        lp.arc_id
                    FROM link_psector lp
                    WHERE lp.p_state = 1
                ), link_selected AS (
                    SELECT l.link_id,
                        link_selector.arc_id,
                        l.feature_id,
                        l.feature_type,
                        l.expl_id,
                        l.sector_id,
                        l.presszone_id,
                        l.dma_id,
                        l.dqa_id,
                        l.supplyzone_id,
                        l.muni_id,
                        l.minsector_id,
                        l.the_geom
                    FROM link_selector
                    JOIN link l USING (link_id)
                    JOIN value_state_type vst ON vst.id = l.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM link_selected;

            ELSIF v_project_type = 'UD' THEN

                CREATE OR REPLACE TEMPORARY VIEW v_temp_arc AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ), arc_psector AS (
                    SELECT
                        pp.arc_id,
                        pp.state AS p_state
                    FROM plan_psector_x_arc pp
                    WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                ), arc_selector AS (
                    SELECT
                        a.arc_id
                    FROM arc a
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM arc_psector ap
                        WHERE ap.arc_id::text = a.arc_id::text AND ap.p_state = 0
                    ) AND a.state = 1
                    UNION ALL
                    SELECT arc_psector.arc_id
                    FROM arc_psector
                    WHERE arc_psector.p_state = 1
                ), arc_selected AS (
                    SELECT
                        a.arc_id,
                        a.node_1,
                        a.node_2,
                        a.initoverflowpath,
                        a.expl_id,
                        a.sector_id,
                        a.dwfzone_id,
                        a.omzone_id,
                        a.fluid_type,
                        a.muni_id,
                        a.minsector_id,
                        a.arccat_id,
                        a.state,
                        a.the_geom
                    FROM arc_selector
                    JOIN arc a USING (arc_id)
                    JOIN value_state_type vst ON vst.id = a.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM arc_selected
                WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_node AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ), node_psector AS (
                    SELECT pp.node_id, pp.state AS p_state
                    FROM plan_psector_x_node pp
                    WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                ), node_selector AS (
                    SELECT n.node_id
                    FROM node n
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM node_psector np
                        WHERE np.node_id::text = n.node_id::text AND np.p_state = 0
                    ) AND n.state = 1
                    UNION ALL
                    SELECT np.node_id
                    FROM node_psector np
                    WHERE np.p_state = 1
                ), node_selected AS (
                    SELECT DISTINCT ON (node_id) node.node_id,
                    cf.graph_delimiter,
                    node.expl_id,
                    node.sector_id,
                    node.dwfzone_id,
                    node.omzone_id,
                    node.fluid_type,
                    node.muni_id,
                    node.minsector_id,
                    node.node_type,
                    node.the_geom
                    FROM node_selector
                    JOIN node ON node.node_id::text = node_selector.node_id::text
                    JOIN cat_node cn ON cn.id = node.nodecat_id
                    JOIN cat_feature_node cf ON cf.id = cn.node_type
                    JOIN value_state_type vst ON vst.id = node.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM node_selected;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_connec AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ), connec_psector AS (
                    SELECT DISTINCT ON (pp.connec_id, pp.state) pp.connec_id,
                        pp.state AS p_state,
                        pp.psector_id,
                        pp.arc_id,
                        pp.link_id
                    FROM plan_psector_x_connec pp
                    WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                    ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
                ), connec_selector AS (
                    SELECT
                        connec.connec_id,
                        connec.arc_id
                    FROM connec
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM connec_psector cp
                        WHERE cp.connec_id::text = connec.connec_id::text AND cp.p_state = 0
                    ) AND connec.state = 1
                    UNION ALL
                    SELECT
                        connec_psector.connec_id,
                        connec_psector.arc_id
                    FROM connec_psector
                    WHERE connec_psector.p_state = 1
                ), connec_selected AS (
                    SELECT DISTINCT ON (connec_id) connec.connec_id,
                        connec.arc_id,
                        connec.customer_code,
                        connec.expl_id,
                        connec.sector_id,
                        connec.dwfzone_id,
                        connec.omzone_id,
                        connec.fluid_type,
                        connec.plot_code,
                        connec.muni_id,
                        connec.conneccat_id,
                        connec.state,
                        connec.minsector_id,
                        connec.the_geom
                    FROM connec_selector
                    JOIN connec ON connec.connec_id::text = connec_selector.connec_id::text
                    JOIN value_state_type vst ON vst.id = connec.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM connec_selected;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_gully AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ), gully_psector AS (
                    SELECT DISTINCT ON (pp.gully_id, pp.state) pp.gully_id,
                        pp.state AS p_state,
                        pp.psector_id,
                        pp.arc_id,
                        pp.link_id
                    FROM plan_psector_x_gully pp
                    WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                    ORDER BY pp.gully_id, pp.state, pp.link_id DESC NULLS LAST
                ), gully_selector AS (
                    SELECT
                        gully.gully_id,
                        gully.arc_id,
                        NULL::integer AS link_id
                    FROM gully
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM gully_psector gp
                        WHERE gp.gully_id::text = gully.gully_id::text AND gp.p_state = 0
                    ) AND gully.state = 1
                    UNION ALL
                    SELECT
                        gully_psector.gully_id,
                        gully_psector.arc_id,
                        gully_psector.link_id
                    FROM gully_psector
                    WHERE gully_psector.p_state = 1
                ), gully_selected AS (
                    SELECT DISTINCT ON (gully_id) gully.gully_id,
                        gully.arc_id,
                        gully.expl_id,
                        gully.sector_id,
                        gully.dwfzone_id,
                        gully.omzone_id,
                        gully.fluid_type,
                        gully.muni_id,
                        gully.minsector_id,
                        gully.gullycat_id,
                        gully.state,
                        gully.the_geom
                    FROM gully_selector
                    JOIN gully ON gully.gully_id::text = gully_selector.gully_id::text
                    JOIN value_state_type vst ON vst.id = gully.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM gully_selected;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_link_connec AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ),link_psector AS (
                        SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC'::text AS feature_type,
                            pp.connec_id AS feature_id,
                            pp.state AS p_state,
                            pp.psector_id,
                            pp.link_id,
                            pp.arc_id
                        FROM plan_psector_x_connec pp
                        WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                        ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
                ), link_selector AS (
                    SELECT
                        l.link_id,
                        c.arc_id
                    FROM link l
                    JOIN connec c ON l.feature_id = c.connec_id
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM link_psector lp
                        WHERE lp.link_id::text = l.link_id::text AND lp.p_state = 0
                    )
                    AND l.state = 1
                    AND l.feature_type = 'CONNEC'
                    UNION ALL
                    SELECT
                        lp.link_id,
                        lp.arc_id
                    FROM link_psector lp
                    WHERE lp.p_state = 1
                ), link_selected AS (
                    SELECT l.link_id,
                        link_selector.arc_id,
                        l.feature_id,
                        l.feature_type,
                        l.expl_id,
                        l.sector_id,
                        l.dwfzone_id,
                        l.omzone_id,
                        l.fluid_type,
                        l.muni_id,
                        l.the_geom
                    FROM link_selector
                    JOIN link l USING (link_id)
                    JOIN value_state_type vst ON vst.id = l.state_type
                    WHERE vst.is_operative = TRUE

                )
                SELECT * FROM link_selected;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_link_gully AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ),link_psector AS (
                        SELECT DISTINCT ON (pp.gully_id, pp.state) 'GULLY'::text AS feature_type,
                            pp.gully_id AS feature_id,
                            pp.state AS p_state,
                            pp.psector_id,
                            pp.link_id,
                            pp.arc_id
                        FROM plan_psector_x_gully pp
                        WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                        ORDER BY pp.gully_id, pp.state, pp.link_id DESC NULLS LAST
                ), link_selector AS (
                    SELECT
                        l.link_id,
                        g.arc_id
                    FROM link l
                    JOIN gully g ON l.feature_id = g.gully_id
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM link_psector lp
                        WHERE lp.link_id::text = l.link_id::text AND lp.p_state = 0
                    )
                    AND l.state = 1
                    AND l.feature_type = 'GULLY'
                    UNION ALL
                    SELECT
                        lp.link_id,
                        lp.arc_id
                    FROM link_psector lp
                    WHERE lp.p_state = 1
                ), link_selected AS (
                    SELECT l.link_id,
                        link_selector.arc_id,
                        l.feature_id,
                        l.feature_type,
                        l.expl_id,
                        l.sector_id,
                        l.dwfzone_id,
                        l.omzone_id,
                        l.fluid_type,
                        l.muni_id,
                        l.the_geom
                    FROM link_selector
                    JOIN link l USING (link_id)
                    JOIN value_state_type vst ON vst.id = l.state_type
                    WHERE vst.is_operative = TRUE

                )
                SELECT * FROM link_selected;

            END IF;

        ELSE
            -- without psectors
            IF v_project_type = 'WS' THEN

                CREATE OR REPLACE TEMPORARY VIEW v_temp_arc AS
                SELECT
                    a.arc_id,
                    a.node_1,
                    a.node_2,
                    a.expl_id,
                    a.sector_id,
                    a.minsector_id,
                    a.presszone_id,
                    a.dma_id,
                    a.dqa_id,
                    a.supplyzone_id,
                    a.muni_id,
                    a.arccat_id,
                    a.state,
                    a.the_geom
                FROM arc a
                JOIN value_state_type vst ON vst.id = a.state_type
                WHERE a.state = 1 AND vst.is_operative = TRUE
                AND node_1 IS NOT NULL AND node_2 IS NOT NULL;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_node AS
                SELECT
                    n.node_id,
                    cf.graph_delimiter,
                    n.expl_id,
                    n.sector_id,
                    n.presszone_id,
                    n.dma_id,
                    n.dqa_id,
                    n.supplyzone_id,
                    n.muni_id,
                    n.minsector_id,
                    cn.node_type,
                    n.the_geom
                FROM node n
                JOIN value_state_type vst ON vst.id = n.state_type
                JOIN cat_node cn ON cn.id = n.nodecat_id
                JOIN cat_feature_node cf ON cf.id = cn.node_type
                WHERE n.state = 1 AND vst.is_operative = TRUE;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_connec AS
                SELECT
                    c.connec_id,
                    c.arc_id,
                    c.customer_code,
                    c.expl_id,
                    c.sector_id,
                    c.presszone_id,
                    c.dma_id,
                    c.dqa_id,
                    c.plot_code,
                    c.supplyzone_id,
                    c.muni_id,
                    c.minsector_id,
                    c.conneccat_id,
                    c.state,
                    c.the_geom
                FROM connec c
                JOIN value_state_type vst ON vst.id = c.state_type
                WHERE c.state = 1 AND vst.is_operative = TRUE;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_link_connec AS
                SELECT
                    l.link_id,
                    c.arc_id,
                    l.feature_id,
                    l.feature_type,
                    l.expl_id,
                    l.sector_id,
                    l.presszone_id,
                    l.dma_id,
                    l.dqa_id,
                    l.supplyzone_id,
                    l.muni_id,
                    l.minsector_id,
                    l.the_geom
                FROM link l
                JOIN connec c ON l.feature_id = c.connec_id
                JOIN value_state_type vst ON vst.id = l.state_type
                WHERE l.state = 1
                AND vst.is_operative = TRUE
                AND l.feature_type = 'CONNEC';

            ELSIF v_project_type = 'UD' THEN

                CREATE OR REPLACE TEMPORARY VIEW v_temp_arc AS
                SELECT
                    a.arc_id,
                    a.node_1,
                    a.node_2,
                    a.initoverflowpath,
                    a.expl_id,
                    a.sector_id,
                    a.dwfzone_id,
                    a.omzone_id,
                    a.fluid_type,
                    a.muni_id,
                    a.minsector_id,
                    a.arccat_id,
                    a.state,
                    a.the_geom
                FROM arc a
                JOIN value_state_type vst ON vst.id = a.state_type
                WHERE a.state = 1 AND vst.is_operative = TRUE;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_node AS
                SELECT
                    n.node_id,
                    cf.graph_delimiter,
                    n.expl_id,
                    n.sector_id,
                    n.dwfzone_id,
                    n.omzone_id,
                    n.fluid_type,
                    n.muni_id,
                    n.minsector_id,
                    n.node_type,
                    n.the_geom
                FROM node n
                JOIN value_state_type vst ON vst.id = n.state_type
                JOIN cat_node cn ON cn.id = n.nodecat_id
                JOIN cat_feature_node cf ON cf.id = cn.node_type
                WHERE n.state = 1 AND vst.is_operative = TRUE;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_connec AS
                SELECT
                    c.connec_id,
                    c.arc_id,
                    c.customer_code,
                    c.expl_id,
                    c.sector_id,
                    c.dwfzone_id,
                    c.omzone_id,
                    c.fluid_type,
                    c.plot_code,
                    c.muni_id,
                    c.minsector_id,
                    c.conneccat_id,
                    c.state,
                    c.the_geom
                FROM connec c
                JOIN value_state_type vst ON vst.id = c.state_type
                WHERE c.state = 1 AND vst.is_operative = TRUE;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_gully AS
                SELECT
                    g.gully_id,
                    g.arc_id,
                    g.expl_id,
                    g.sector_id,
                    g.dwfzone_id,
                    g.omzone_id,
                    g.fluid_type,
                    g.muni_id,
                    g.minsector_id,
                    g.gullycat_id,
                    g.state,
                    g.the_geom
                FROM gully g
                JOIN value_state_type vst ON vst.id = g.state_type
                WHERE g.state = 1 AND vst.is_operative = TRUE;

                CREATE OR REPLACE TEMPORARY VIEW v_temp_link_connec AS
                SELECT
                    l.link_id,
                    c.arc_id,
                    l.feature_id,
                    l.feature_type,
                    l.expl_id,
                    l.sector_id,
                    l.dwfzone_id,
                    l.omzone_id,
                    l.fluid_type,
                    l.muni_id,
                    l.the_geom
                FROM link l
                JOIN connec c ON l.feature_id = c.connec_id
                JOIN value_state_type vst ON vst.id = l.state_type
                WHERE l.state = 1
                AND vst.is_operative = TRUE
                AND l.feature_type = 'CONNEC';

                CREATE OR REPLACE TEMPORARY VIEW v_temp_link_gully AS
                SELECT
                    l.link_id,
                    g.arc_id,
                    l.feature_id,
                    l.feature_type,
                    l.expl_id,
                    l.sector_id,
                    l.dwfzone_id,
                    l.omzone_id,
                    l.fluid_type,
                    l.muni_id,
                    l.the_geom
                FROM link l
                JOIN gully g ON l.feature_id = g.gully_id
                JOIN value_state_type vst ON vst.id = l.state_type
                WHERE l.state = 1
                AND vst.is_operative = TRUE
                AND l.feature_type = 'GULLY';

            END IF;

        END IF;

        -- For specific functions
        IF v_project_type = 'WS' THEN
            IF v_fct_name = 'MINSECTOR' THEN
                CREATE OR REPLACE TEMPORARY VIEW v_temp_minsector_mincut AS
                WITH minsector_mapzones AS (
                    SELECT
                        t.mincut_minsector_id AS minsector_id,
                        array_agg(DISTINCT t.dma_id) AS dma_id,
                        array_agg(DISTINCT t.dqa_id) AS dqa_id,
                        array_agg(DISTINCT t.presszone_id) AS presszone_id,
                        array_agg(DISTINCT t.expl_id) AS expl_id,
                        array_agg(DISTINCT t.sector_id) AS sector_id,
                        array_agg(DISTINCT t.muni_id) AS muni_id,
                        array_agg(DISTINCT t.supplyzone_id) AS supplyzone_id,
                        ST_Union(t.the_geom) AS the_geom
                    FROM (
                        SELECT
                            m.minsector_id,
                            mm.minsector_id AS mincut_minsector_id,
                            unnest(m.dma_id) AS dma_id,
                            unnest(m.dqa_id) AS dqa_id,
                            unnest(m.presszone_id) AS presszone_id,
                            unnest(m.expl_id) AS expl_id,
                            unnest(m.sector_id) AS sector_id,
                            unnest(m.muni_id) AS muni_id,
                            unnest(m.supplyzone_id) AS supplyzone_id,
                            m.the_geom
                        FROM temp_pgr_minsector m
                        JOIN temp_pgr_minsector_mincut mm ON mm.mincut_minsector_id = m.minsector_id
                    ) t
                    GROUP BY t.mincut_minsector_id
                ),
                minsector_sums AS (
                    SELECT
                        mm.minsector_id,
                        SUM(m.num_border) AS num_border,
                        SUM(m.num_connec) AS num_connec,
                        SUM(m.num_hydro) AS num_hydro,
                        SUM(m.length) AS length
                    FROM temp_pgr_minsector_mincut mm
                    JOIN temp_pgr_minsector m ON m.minsector_id = mm.mincut_minsector_id
                    GROUP BY mm.minsector_id
                )
                SELECT
                    m.minsector_id,
                    m.dma_id,
                    m.dqa_id,
                    m.presszone_id,
                    m.expl_id,
                    m.sector_id,
                    m.muni_id,
                    m.supplyzone_id,
                    s.num_border,
                    s.num_connec,
                    s.num_hydro,
                    s.length,
                    m.the_geom
                FROM minsector_mapzones m
                JOIN minsector_sums s ON s.minsector_id = m.minsector_id;
            END IF;

        END IF; 

        v_return_message = 'The temporary tables/views have been created successfully';
    ELSIF v_action = 'DROP' THEN

        -- Drop temporary views
        DROP VIEW IF EXISTS v_temp_pgr_mapzone_old;
        DROP VIEW IF EXISTS v_temp_minsector_mincut;
        DROP VIEW IF EXISTS v_temp_node;
        DROP VIEW IF EXISTS v_temp_arc;
        DROP VIEW IF EXISTS v_temp_connec;
        DROP VIEW IF EXISTS v_temp_gully;
        DROP VIEW IF EXISTS v_temp_link_connec;
        DROP VIEW IF EXISTS v_temp_link_gully;

        -- Drop temporary tables
        DROP TABLE IF EXISTS temp_pgr_mapzone;
        DROP TABLE IF EXISTS temp_pgr_node_mincut;
        DROP TABLE IF EXISTS temp_pgr_arc_mincut;
        DROP TABLE IF EXISTS temp_pgr_node;
        DROP TABLE IF EXISTS temp_pgr_arc;
        DROP TABLE IF EXISTS temp_audit_check_data;
        DROP TABLE IF EXISTS temp_pgr_connectedcomponents;
        DROP TABLE IF EXISTS temp_pgr_minsector_graph;
        DROP TABLE IF EXISTS temp_pgr_minsector;
        DROP TABLE IF EXISTS temp_pgr_drivingdistance;
        DROP TABLE IF EXISTS temp_pgr_drivingdistance_initoverflowpath;
        DROP TABLE IF EXISTS temp_pgr_minsector_mincut;

        DROP TABLE IF EXISTS temp_pgr_om_waterbalance_dma_graph;

        v_return_message = 'The temporary tables/views have been dropped successfully';
    END IF;

    RETURN jsonb_build_object(
        'status', 'Accepted',
        'message', jsonb_build_object(
            'level', 1,
            'text', v_return_message
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

 -- TODO: TO BE REMOVED
    EXCEPTION WHEN OTHERS THEN

    RETURN jsonb_build_object(
        'status', 'Failed',
        'message', jsonb_build_object(
            'level', 3,
            'text', 'An error occurred while managing temporary tables: ' || SQLERRM
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100

