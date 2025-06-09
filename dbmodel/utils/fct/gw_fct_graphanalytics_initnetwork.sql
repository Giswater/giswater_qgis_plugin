/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3400

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_initnetwork(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_initnetwork(p_data json)
RETURNS json AS
$BODY$

/* NOTE Example query:

SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"-901"}}'); -- For all user selected exploitations
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"-902"}}'); -- For all exploitations
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"0"}}'); -- For exploitation 0
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"1"}}'); -- For exploitation 1
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"2"}}'); -- For exploitation 2

-- NOTE It is an auxiliary process used by macro_minsector, minsector, or mapzone that generates the tables temp_pgr_node and temp_pgr_arc.
*/

DECLARE

    -- configuration
	v_version TEXT;
    v_project_type TEXT;

    -- parameters
    v_expl_id_array TEXT;
    v_mapzone_name TEXT;

    -- extra variables
    v_cost INTEGER = 1;
    v_reverse_cost INTEGER = 1;
    v_querytext TEXT;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
    v_expl_id_array = (SELECT (p_data::json->>'data')::json->>'expl_id_array');
    v_mapzone_name = (SELECT (p_data::json->>'data')::json->>'mapzone_name');

    IF v_mapzone_name IS NULL OR v_mapzone_name = '' THEN
        RETURN jsonb_build_object(
            'status', 'Failed',
            'message', jsonb_build_object(
                'level', 3,
                'text', 'v_mapzone_name is null or empty'
            ),
            'version', v_version,
            'body', jsonb_build_object(
                'form', jsonb_build_object(),
                'data', jsonb_build_object()
            )
        );
    END IF;

    IF v_project_type = 'UD' THEN v_reverse_cost = -1; END IF;

    v_querytext = '
    WITH connectedcomponents AS (
        SELECT * FROM pgr_connectedcomponents($q$
            SELECT arc_id::int AS id, node_1::int AS source, node_2::int AS target, 1 AS cost
            FROM v_temp_arc
        $q$)
    ),
    components AS (
        SELECT c.component
        FROM connectedcomponents c
        WHERE EXISTS (
            SELECT 1
            FROM v_temp_node vtn
            WHERE c.node = vtn.node_id::int
            AND vtn.expl_id::text = ANY (''' || v_expl_id_array || ''')
        )
        GROUP BY c.component
    )
    INSERT INTO temp_pgr_node (node_id)
    SELECT c.node::int4
    FROM connectedcomponents c
    WHERE EXISTS (
        SELECT 1
        FROM components cc
        WHERE cc.component = c.component
    );
    ';

    EXECUTE v_querytext;

    IF lower(v_mapzone_name) = 'fluidtype' THEN
        v_querytext = 'INSERT INTO temp_pgr_arc (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, fluid_type)
	         SELECT a.arc_id, a.node_1, a.node_2, n1.pgr_node_id, n2.pgr_node_id, a.fluid_type
	         FROM v_temp_arc a
	         JOIN temp_pgr_node n1 ON n1.node_id = a.node_1
	         JOIN temp_pgr_node n2 ON n2.node_id = a.node_2';

	    EXECUTE v_querytext;
    ELSE
        -- Dynamic column name for old_mapzone_id: %I_id -> dma_id, presszone_id, etc.
        -- node because we need to inform old mapzone_id for this nodes that is_operative is false.
        v_querytext = 'UPDATE temp_pgr_node n SET old_mapzone_id = t.' || v_mapzone_name || '_id FROM node t WHERE n.node_id = t.node_id';
        EXECUTE v_querytext;

        v_querytext = 'INSERT INTO temp_pgr_arc (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost, old_mapzone_id)
            SELECT a.arc_id, a.node_1, a.node_2, n1.pgr_node_id, n2.pgr_node_id, ' || v_cost || ', ' || v_reverse_cost || ', ' || v_mapzone_name || '_id
            FROM v_temp_arc a
            JOIN temp_pgr_node n1 ON n1.node_id = a.node_1
            JOIN temp_pgr_node n2 ON n2.node_id = a.node_2';

        EXECUTE v_querytext;

        -- NOTE: Not used in the current version
        -- v_querytext = '
        --     INSERT INTO temp_pgr_connec (connec_id, arc_id, old_mapzone_id)
        --     (
        --         SELECT DISTINCT ON (c.connec_id) c.connec_id, a.pgr_arc_id, ' || v_mapzone_name || '_id
        --         FROM v_temp_connec c
        --         JOIN temp_pgr_arc a ON c.arc_id = a.arc_id
        --     )';

        -- EXECUTE v_querytext;

        -- v_querytext = '
        --     INSERT INTO temp_pgr_link (link_id, feature_id, feature_type, old_mapzone_id)
        --     (
        --         SELECT DISTINCT ON (l.link_id) l.link_id, l.feature_id, l.feature_type, ' || v_mapzone_name || '_id
        --         FROM v_temp_link_connec l
        --         JOIN temp_pgr_connec c ON l.feature_id=c.connec_id
        --     )';

        -- EXECUTE v_querytext;

        -- IF v_project_type = 'UD' THEN
        --     v_querytext = '
        --         INSERT INTO temp_pgr_gully (gully_id, arc_id, old_mapzone_id)
        --         (
        --             SELECT DISTINCT ON (g.gully_id) g.gully_id, a.pgr_arc_id, ' || v_mapzone_name || '_id
        --             FROM v_temp_gully g
        --             JOIN temp_pgr_arc a ON g.arc_id = a.arc_id
        --         )';

        --     EXECUTE v_querytext;

        --     v_querytext = '
        --         INSERT INTO temp_pgr_link (link_id, feature_id, feature_type, old_mapzone_id)
        --         (
        --             SELECT DISTINCT ON (l.link_id) l.link_id, l.feature_id, l.feature_type, ' || v_mapzone_name || '_id
        --             FROM v_temp_link_gully l
        --             JOIN temp_pgr_gully g ON l.feature_id = g.gully_id
        --         )';

        --     EXECUTE v_querytext;
        -- END IF;
    END IF;



    RETURN jsonb_build_object(
        'status', 'Accepted',
        'message', jsonb_build_object(
            'level', 1,
            'text', 'The temporary tables have been initialized successfully'
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

    EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'status', 'Failed',
        'message', jsonb_build_object(
            'level', 3,
            'text', 'An error occurred while initializing temporary tables: ' || SQLERRM
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
