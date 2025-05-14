/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 3330

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

    IF v_action = 'CREATE' THEN
        -- Create temporary tables
        CREATE TEMP TABLE temp_pgr_mapzone (
            mapzone_id SERIAL NOT NULL,
            the_geom geometry(Polygon, SRID_VALUE),
            CONSTRAINT temp_pgr_mapzone_pkey PRIMARY KEY (mapzone_id)
        );


        CREATE TEMP TABLE temp_pgr_node (
            pgr_node_id SERIAL NOT NULL,
            node_id VARCHAR(16),
            mapzone_id INTEGER DEFAULT 0,
            old_mapzone_id INTEGER,
            modif BOOL DEFAULT FALSE,  -- True if nodes have to be disconnected - closed valves, starts of mapzones
            graph_delimiter VARCHAR(30) DEFAULT 'none',
            CONSTRAINT temp_pgr_node_pkey PRIMARY KEY (pgr_node_id)
        );
        CREATE INDEX temp_pgr_node_node_id ON temp_pgr_node USING btree (node_id);
        GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_node TO role_basic;


        CREATE TEMP TABLE temp_pgr_arc (
            pgr_arc_id SERIAL NOT NULL,
            arc_id VARCHAR(16),
            pgr_node_1 INT,
            pgr_node_2 INT,
            node_1 VARCHAR(16),
            node_2 VARCHAR(16),
            mapzone_id INTEGER DEFAULT 0,
            old_mapzone_id INTEGER,
            graph_delimiter VARCHAR(30) DEFAULT 'none',
            modif1 BOOL DEFAULT FALSE,  -- True if arcs have to be disconnected on node_1
            modif2 BOOL DEFAULT FALSE,  -- True if arcs have to be disconnected on node_2
            cost INT DEFAULT 1,
            reverse_cost INT DEFAULT 1,
            CONSTRAINT temp_pgr_arc_pkey PRIMARY KEY (pgr_arc_id)
        );
        CREATE INDEX temp_pgr_arc_pgr_arc_id ON temp_pgr_arc USING btree (pgr_arc_id);
        CREATE INDEX temp_pgr_arc_pgr_node1 ON temp_pgr_arc USING btree (pgr_node_1);
        CREATE INDEX temp_pgr_arc_pgr_node2 ON temp_pgr_arc USING btree (pgr_node_2);
        CREATE INDEX temp_pgr_arc_node1 ON temp_pgr_arc USING btree (node_1);
        CREATE INDEX temp_pgr_arc_node2 ON temp_pgr_arc USING btree (node_2);
        GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_arc TO role_basic;

        CREATE TEMP TABLE temp_pgr_connec (
            connec_id varchar(16),
            arc_id varchar(16),
            mapzone_id INTEGER DEFAULT 0,
            old_mapzone_id INTEGER,
            CONSTRAINT temp_pgr_connec_pkey PRIMARY KEY (connec_id)
        );
        CREATE INDEX temp_pgr_connec_connec_id ON temp_pgr_connec USING btree (connec_id);
        CREATE INDEX temp_pgr_connec_arc_id ON temp_pgr_connec USING btree (arc_id);


        CREATE TEMP TABLE temp_pgr_link (
            link_id varchar(16),
            feature_id varchar(16),
            feature_type varchar(16),
            mapzone_id INTEGER DEFAULT 0,
            old_mapzone_id INTEGER,
            CONSTRAINT temp_pgr_link_pkey PRIMARY KEY (link_id)
        );
        CREATE INDEX temp_pgr_link_link_id ON temp_pgr_link USING btree (link_id);
        CREATE INDEX temp_pgr_link_feature_id ON temp_pgr_link USING btree (feature_id);

        -- Create temporary layers depending on the project type
        IF v_project_type = 'UD' THEN
            CREATE TEMP TABLE temp_pgr_gully (
                gully_id varchar(16),
                arc_id varchar(16),
                mapzone_id INTEGER DEFAULT 0,
                old_mapzone_id INTEGER,
                CONSTRAINT temp_pgr_gully_pkey PRIMARY KEY (gully_id)
            );
            CREATE INDEX temp_pgr_gully_gully_id ON temp_pgr_gully USING btree (gully_id);
            CREATE INDEX temp_pgr_gully_arc_id ON temp_pgr_gully USING btree (arc_id);
        ELSIF v_project_type = 'WS' THEN
            ALTER TABLE temp_pgr_node ADD COLUMN closed BOOL;
            ALTER TABLE temp_pgr_node ADD COLUMN broken BOOL;
            ALTER TABLE temp_pgr_node ADD COLUMN to_arc VARCHAR(30);
            IF v_fct_name = 'MINCUT' THEN
                ALTER TABLE temp_pgr_arc ADD COLUMN cost_mapzone int default 1;
                ALTER TABLE temp_pgr_arc ADD COLUMN reverse_cost_mapzone int default 1;
                ALTER TABLE temp_pgr_arc ADD COLUMN unaccess BOOL DEFAULT FALSE; -- if TRUE, it means the valve is not accessible
                ALTER TABLE temp_pgr_arc ADD COLUMN proposed BOOL DEFAULT FALSE;
                -- "proposed"= FALSE AND mapzone_id <> '0' if it's in the mincut and it cannot be closed
                -- "proposed" = TRUE if it's in the mincut and it has to be closed
            END IF;
        END IF;

        -- Create other additional temporary tables
        CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

        -- For specific functions
        IF v_fct_name = 'MINSECTOR' THEN
            CREATE TEMP TABLE temp_pgr_connectedcomponents (
                seq INT8 NOT NULL,
                component INT8 NULL,
                node INT8 NULL,
                CONSTRAINT temp_pgr_connectedcomponents_pkey PRIMARY KEY (seq)
            );
            CREATE INDEX temp_pgr_connectedcomponents_component ON temp_pgr_connectedcomponents USING btree (component);
            CREATE INDEX temp_pgr_connectedcomponents_node ON temp_pgr_connectedcomponents USING btree (node);
            GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_connectedcomponents TO role_basic;

            CREATE TEMP TABLE temp_minsector_graph (LIKE SCHEMA_NAME.minsector_graph INCLUDING ALL);
            CREATE TEMP TABLE temp_minsector (LIKE SCHEMA_NAME.minsector INCLUDING ALL);
        ELSE
            CREATE TEMP TABLE temp_pgr_drivingdistance (
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
            CREATE INDEX temp_pgr_drivingdistance_start_vid ON temp_pgr_drivingdistance USING btree (start_vid);
            CREATE INDEX temp_pgr_drivingdistance_node ON temp_pgr_drivingdistance USING btree (node);
            CREATE INDEX temp_pgr_drivingdistance_edge ON temp_pgr_drivingdistance USING btree (edge);
            GRANT UPDATE, INSERT, REFERENCES, SELECT, DELETE, TRUNCATE, TRIGGER ON TABLE temp_pgr_drivingdistance TO role_basic;
        END IF;


        -- Create temporary views
        IF v_use_psector = 'true' THEN
            -- with psectors
            IF v_project_type = 'WS' THEN

                CREATE TEMPORARY VIEW v_temp_arc AS
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
                        a.the_geom
                    FROM arc_selector
                    JOIN arc a USING (arc_id)
                    JOIN value_state_type vst ON vst.id = a.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM arc_selected
                WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL;

                CREATE TEMPORARY VIEW v_temp_node AS
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
                    node.the_geom
                    FROM node_selector
                    JOIN node ON node.node_id::text = node_selector.node_id::text
                    JOIN cat_node cn ON cn.id = node.nodecat_id
                    JOIN cat_feature_node cf ON cf.id = cn.node_type
                    JOIN value_state_type vst ON vst.id = node.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM node_selected n;

                CREATE TEMPORARY VIEW v_temp_connec AS
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
                        connec.expl_id,
                        connec.sector_id,
                        connec.presszone_id,
                        connec.dma_id,
                        connec.dqa_id,
                        connec.the_geom
                    FROM connec_selector
                    JOIN connec ON connec.connec_id::text = connec_selector.connec_id::text
                    JOIN value_state_type vst ON vst.id = connec.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM connec_selected;

                CREATE TEMPORARY VIEW v_temp_link AS
                WITH sel_ps AS (
                    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
                ), link_psector AS (
                    SELECT DISTINCT ON (pp.connec_id, pp.state) 'CONNEC'::text AS feature_type,
                        pp.connec_id AS feature_id,
                        pp.state AS p_state,
                        pp.psector_id,
                        pp.link_id
                    FROM plan_psector_x_connec pp
                    WHERE (pp.psector_id IN (SELECT sel_ps.psector_id FROM sel_ps))
                    ORDER BY pp.connec_id, pp.state, pp.link_id DESC NULLS LAST
                ), link_selector AS (
                    SELECT l.link_id
                    FROM link l
                    WHERE NOT EXISTS (
                        SELECT 1
                        FROM link_psector lp
                        WHERE lp.link_id::text = l.link_id::text AND lp.p_state = 0
                    ) AND l.state = 1
                    UNION ALL
                    SELECT lp.link_id
                    FROM link_psector lp
                    WHERE lp.p_state = 1
                ), link_selected AS (
                    SELECT l.link_id,
                        l.feature_id,
                        l.feature_type,
                        l.expl_id,
                        l.sector_id,
                        l.presszone_id,
                        l.dma_id,
                        l.dqa_id,
                        l.the_geom
                    FROM link_selector
                    JOIN link l USING (link_id)
                    JOIN value_state_type vst ON vst.id = l.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM link_selected;

            ELSIF v_project_type = 'UD' THEN

                CREATE TEMPORARY VIEW v_temp_arc AS
                WITH sel_expl AS (
                    SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
                ), sel_ps AS (
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
                        a.drainzone_id,
                        a.dwfzone_id,
                        a.omzone_id,
                        a.the_geom
                    FROM arc_selector
                    JOIN arc a USING (arc_id)
                    JOIN value_state_type vst ON vst.id = a.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM arc_selected
                WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL;

                CREATE TEMPORARY VIEW v_temp_node AS
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
                    node.expl_id,
                    node.sector_id,
                    node.drainzone_id,
                    node.dwfzone_id,
                    node.omzone_id,
                    node.the_geom
                    FROM node_selector
                    JOIN node ON node.node_id::text = node_selector.node_id::text
                    JOIN value_state_type vst ON vst.id = node.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM node_selected;

                CREATE TEMPORARY VIEW v_temp_connec AS
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
                        connec.expl_id,
                        connec.sector_id,
                        connec.drainzone_id,
                        connec.dwfzone_id,
                        connec.omzone_id,
                        connec.the_geom
                    FROM connec_selector
                    JOIN connec ON connec.connec_id::text = connec_selector.connec_id::text
                    JOIN value_state_type vst ON vst.id = connec.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM connec_selected;

                CREATE TEMPORARY VIEW v_temp_gully AS
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
                        gully.drainzone_id,
                        gully.dwfzone_id,
                        gully.omzone_id,
                        gully.the_geom
                    FROM gully_selector
                    JOIN gully ON gully.gully_id::text = gully_selector.gully_id::text
                    JOIN value_state_type vst ON vst.id = gully.state_type
                    WHERE vst.is_operative = TRUE
                )
                SELECT * FROM gully_selected;

                CREATE TEMPORARY VIEW v_temp_link_connec AS
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
                        l.presszone_id,
                        l.dma_id,
                        l.dqa_id,
                        l.the_geom
                    FROM link_selector
                    JOIN link l USING (link_id)
                    JOIN value_state_type vst ON vst.id = l.state_type
                    WHERE vst.is_operative = TRUE

                )
                SELECT * FROM link_selected;

                CREATE TEMPORARY VIEW v_temp_link_gully AS
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
                        c.arc_id
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
                        l.presszone_id,
                        l.dma_id,
                        l.dqa_id,
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

                CREATE TEMPORARY VIEW v_temp_arc AS
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
                    a.the_geom
                FROM arc a
                JOIN value_state_type vst ON vst.id = a.state_type
                WHERE a.state = 1 AND vst.is_operative = TRUE
                AND node_1 IS NOT NULL AND node_2 IS NOT NULL;

                CREATE TEMPORARY VIEW v_temp_node AS
                SELECT
                    node_id,
                    expl_id,
                    sector_id,
                    presszone_id,
                    dma_id,
                    dqa_id,
                    the_geom
                FROM node n
                JOIN value_state_type vst ON vst.id = n.state_type
                WHERE n.state = 1 AND vst.is_operative = TRUE;

                CREATE TEMPORARY VIEW v_temp_connec AS
                SELECT
                    connec_id,
                    arc_id,
                    expl_id,
                    sector_id,
                    presszone_id,
                    dma_id,
                    dqa_id,
                    the_geom
                FROM connec c
                JOIN value_state_type vst ON vst.id = c.state_type
                WHERE c.state = 1 AND vst.is_operative = TRUE;

                CREATE TEMPORARY VIEW v_temp_link_connec AS
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
                    l.the_geom
                FROM link l
                JOIN connec c ON l.feature_id = c.connec_id
                JOIN value_state_type vst ON vst.id = l.state_type
                WHERE l.state = 1
                AND vst.is_operative = TRUE
                AND l.feature_type = 'CONNEC';

            ELSIF v_project_type = 'UD' THEN

                CREATE TEMPORARY VIEW v_temp_arc AS
                SELECT
                    arc_id,
                    node_1,
                    node_2,
                    expl_id,
                    sector_id,
                    drainzone_id,
                    dwfzone_id,
                    omzone_id,
                    the_geom
                FROM arc a
                JOIN value_state_type vst ON vst.id = a.state_type
                WHERE a.state = 1 AND vst.is_operative = TRUE;

                CREATE TEMPORARY VIEW v_temp_node AS
                SELECT
                    node_id,
                    expl_id,
                    sector_id,
                    drainzone_id,
                    dwfzone_id,
                    omzone_id,
                    the_geom
                FROM node n
                JOIN value_state_type vst ON vst.id = n.state_type
                WHERE n.state = 1 AND vst.is_operative = TRUE;

                CREATE TEMPORARY VIEW v_temp_connec AS
                SELECT
                    connec_id,
                    arc_id,
                    expl_id,
                    sector_id,
                    drainzone_id,
                    dwfzone_id,
                    omzone_id,
                    the_geom
                FROM connec c
                JOIN value_state_type vst ON vst.id = c.state_type
                WHERE c.state = 1 AND vst.is_operative = TRUE;

                CREATE TEMPORARY VIEW v_temp_gully AS
                SELECT
                    gully_id,
                    arc_id,
                    expl_id,
                    sector_id,
                    drainzone_id,
                    dwfzone_id,
                    omzone_id,
                    the_geom
                FROM gully g
                JOIN value_state_type vst ON vst.id = g.state_type
                WHERE g.state = 1 AND vst.is_operative = TRUE;

                CREATE TEMPORARY VIEW v_temp_link_connec AS
                SELECT
                    l.link_id,
                    c.arc_id,
                    l.feature_id,
                    l.feature_type,
                    l.expl_id,
                    l.sector_id,
                    drainzone_id,
                    dwfzone_id,
                    omzone_id,
                    the_geom
                FROM link l
                JOIN connec c ON l.feature_id = c.connec_id
                JOIN value_state_type vst ON vst.id = l.state_type
                WHERE l.state = 1
                AND vst.is_operative = TRUE
                AND l.feature_type = 'CONNEC';

                CREATE TEMPORARY VIEW v_temp_link_gully AS
                SELECT
                    l.link_id,
                    g.arc_id,
                    l.feature_id,
                    l.feature_type,
                    l.expl_id,
                    l.sector_id,
                    l.presszone_id,
                    l.dma_id,
                    l.dqa_id,
                    l.the_geom
                FROM link l
                JOIN gully g ON l.feature_id = g.gully_id
                JOIN value_state_type vst ON vst.id = l.state_type
                WHERE l.state = 1
                AND vst.is_operative = TRUE
                AND l.feature_type = 'GULLY';

            END IF;

        END IF;




        v_return_message = 'The temporary tables/views have been created successfully';
    ELSIF v_action = 'DROP' THEN
        -- Drop temporary tables
        DROP TABLE IF EXISTS temp_pgr_mapzone;
        DROP TABLE IF EXISTS temp_pgr_node;
        DROP TABLE IF EXISTS temp_pgr_arc;
        DROP TABLE IF EXISTS temp_pgr_connec;
        DROP TABLE IF EXISTS temp_pgr_gully;
        DROP TABLE IF EXISTS temp_pgr_link;

        -- Drop other additional temporary tables
        DROP TABLE IF EXISTS temp_audit_check_data;

        -- For specific functions
        IF v_fct_name = 'MINSECTOR' THEN
            DROP TABLE IF EXISTS temp_pgr_connectedcomponents;
            DROP TABLE IF EXISTS temp_pgr_minsector;
            DROP TABLE IF EXISTS temp_minsector_graph;
            DROP TABLE IF EXISTS temp_minsector;
        ELSE
            DROP TABLE IF EXISTS temp_pgr_drivingdistance;
        END IF;

        -- Drop temporary views
        DROP VIEW IF EXISTS v_temp_node;
        DROP VIEW IF EXISTS v_temp_arc;
        DROP VIEW IF EXISTS v_temp_connec;
        DROP VIEW IF EXISTS v_temp_gully;
        DROP VIEW IF EXISTS v_temp_link;

        v_return_message = 'The temporary tables have been dropped successfully';
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

