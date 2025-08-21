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
    v_expl_id_array text[];
    v_mapzone_name TEXT;
    v_from_zero boolean;

    -- extra variables
    v_graph_delimiter TEXT;
    v_cost INTEGER = 1;
    v_reverse_cost INTEGER = 1;
    v_query_text TEXT;
    v_pgr_root_vids INT[];
    v_pgr_distance INTEGER = 1000000;
    v_source TEXT;
    v_target TEXT;
    v_rows_affected INTEGER;
BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
    v_expl_id_array = string_to_array(p_data->'data'->>'expl_id_array', ',');
    v_mapzone_name = p_data->'data'->>'mapzone_name';
    v_from_zero = p_data->'data'->>'from_zero';

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

    IF v_mapzone_name IN ('MINSECTOR', 'MINCUT') THEN
        v_graph_delimiter := 'SECTOR';
    ELSE
        v_graph_delimiter := v_mapzone_name;
    END IF;

    IF v_project_type = 'WS' THEN
        v_source := 'pgr_node_1';
        v_target := 'pgr_node_2';
    ELSE
        v_source := 'pgr_node_2';
        v_target := 'pgr_node_1';
    END IF;

    v_query_text = '
    WITH connectedcomponents AS (
        SELECT * FROM pgr_connectedcomponents($q$
            SELECT arc_id AS id, node_1 AS source, node_2 AS target, 1 AS cost
            FROM v_temp_arc
        $q$)
    ),
    components AS (
        SELECT c.component
        FROM connectedcomponents c
        WHERE EXISTS (
            SELECT 1
            FROM v_temp_node vtn
            WHERE c.node = vtn.node_id
            AND vtn.expl_id = ANY (ARRAY['||array_to_string(v_expl_id_array, ',')||'])
            --AND vtn.node_id = -- node_1 from arc_id selected in mincut algorithm.
        )
        GROUP BY c.component
    )
    INSERT INTO temp_pgr_node (node_id)
    SELECT c.node
    FROM connectedcomponents c
    WHERE EXISTS (
        SELECT 1
        FROM components cc
        WHERE cc.component = c.component
    );
    ';

    EXECUTE v_query_text;

    IF lower(v_mapzone_name) = 'fluidtype' THEN
        v_query_text = 'INSERT INTO temp_pgr_arc (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, fluid_type)
	         SELECT a.arc_id, a.node_1, a.node_2, n1.pgr_node_id, n2.pgr_node_id, a.fluid_type
	         FROM v_temp_arc a
	         JOIN temp_pgr_node n1 ON n1.node_id = a.node_1
	         JOIN temp_pgr_node n2 ON n2.node_id = a.node_2';

	    EXECUTE v_query_text;
    ELSE
        -- Dynamic column name for old_mapzone_id: %I_id -> dma_id, presszone_id, etc.
        -- node because we need to inform old mapzone_id for this nodes that is_operative is false.
        v_query_text = 'INSERT INTO temp_pgr_arc (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost)
            SELECT a.arc_id, a.node_1, a.node_2, n1.pgr_node_id, n2.pgr_node_id, ' || v_cost || ', ' || v_reverse_cost || '
            FROM v_temp_arc a
            JOIN temp_pgr_node n1 ON n1.node_id = a.node_1
            JOIN temp_pgr_node n2 ON n2.node_id = a.node_2';
        EXECUTE v_query_text;

        IF v_mapzone_name <> 'MINCUT' THEN
            v_query_text = 'UPDATE temp_pgr_node n SET old_mapzone_id = t.' || v_mapzone_name || '_id FROM v_temp_node t WHERE n.node_id = t.node_id';
            EXECUTE v_query_text;
            v_query_text = 'UPDATE temp_pgr_arc a SET old_mapzone_id = t.' || v_mapzone_name || '_id FROM v_temp_arc t WHERE a.arc_id = t.arc_id';
            EXECUTE v_query_text;
        END IF;

        IF v_project_type = 'WS' THEN
            -- VALVES
            UPDATE temp_pgr_node t
            SET
                graph_delimiter = 'MINSECTOR',
                closed = v.closed,
                broken = v.broken,
                to_arc = v.to_arc
            FROM (
                SELECT
                n.node_id,
                v.closed,
                v.broken,
                CASE
                    WHEN to_arc IS NULL THEN NULL
                    ELSE ARRAY[to_arc]
                END AS to_arc
                FROM v_temp_node n
                JOIN man_valve v ON v.node_id = n.node_id
                WHERE 'MINSECTOR' = ANY(n.graph_delimiter)
            ) v
            WHERE t.node_id = v.node_id;
        END IF;

        -- MAPZONE graph_delimiter
        UPDATE temp_pgr_node t
        SET graph_delimiter = v_graph_delimiter
        FROM v_temp_node n
        WHERE t.node_id = n.node_id
        AND t.graph_delimiter = 'NONE'
        AND v_graph_delimiter = ANY(n.graph_delimiter);

        IF v_project_type = 'WS' THEN
            UPDATE temp_pgr_node t
            SET to_arc = a.to_arc
            FROM  (
                SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                FROM man_tank m
                JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                GROUP BY m.node_id
            ) a
            WHERE t.graph_delimiter = v_graph_delimiter AND t.node_id = a.node_id;

            UPDATE temp_pgr_node t
            SET to_arc = a.to_arc
            FROM
                (SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                FROM man_source m
                JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                GROUP BY m.node_id
                )a
            WHERE t.graph_delimiter = v_graph_delimiter AND t.node_id = a.node_id;

            UPDATE temp_pgr_node t
            SET to_arc = a.to_arc
            FROM
                (SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                FROM man_waterwell m
                JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                GROUP BY m.node_id
                )a
            WHERE t.graph_delimiter = v_graph_delimiter AND t.node_id = a.node_id;

            UPDATE temp_pgr_node t
            SET to_arc = a.to_arc
            FROM
                (SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                FROM man_wtp m
                JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                GROUP BY m.node_id
                )a
            WHERE t.graph_delimiter = v_graph_delimiter AND t.node_id = a.node_id;

            -- SET TO_ARC from METER
            UPDATE temp_pgr_node t
            SET to_arc = a.to_arc
            FROM
                (SELECT node_id,
                    CASE WHEN to_arc IS NULL THEN NULL
                    ELSE ARRAY[to_arc]
                    END AS to_arc
                FROM man_meter m
                ) a
            WHERE t.graph_delimiter = v_graph_delimiter AND t.node_id = a.node_id;

            -- SET TO_ARC from PUMP
            UPDATE temp_pgr_node t
            SET to_arc = a.to_arc
            FROM
                (SELECT node_id,
                    CASE WHEN to_arc IS NULL THEN NULL
                    ELSE ARRAY[to_arc]
                    END AS to_arc
                FROM man_pump m
                ) a
            WHERE t.graph_delimiter = v_graph_delimiter AND t.node_id = a.node_id;
        END IF;

        IF v_project_type = 'UD' THEN
            UPDATE temp_pgr_node t
            SET to_arc = a.to_arc
            FROM (
                    SELECT pgr_node_1, array_agg(arc_id) AS to_arc
                    FROM temp_pgr_arc
                    GROUP BY pgr_node_1
                )a
            WHERE t.graph_delimiter = v_graph_delimiter AND t.pgr_node_id = a.pgr_node_1;
        END IF;

        -- calculate to_arc of node parents in from zero mode
        IF v_from_zero THEN
            IF v_project_type = 'UD' AND v_mapzone_name = 'DWFZONE' THEN
                v_query_text := 'SELECT pgr_arc_id AS id, ' || v_source || ' AS source, ' || v_target || ' AS target, cost, reverse_cost 
                    FROM temp_pgr_arc
                    WHERE graph_delimiter <> ''INITOVERFLOWPATH'' AND reverse_cost < 0'; -- if pgr_node_1 or pgr_node_2 have graph_delimiter = IGNORE, the arcs will not be filtered
            ELSE
                v_query_text := 'SELECT pgr_arc_id AS id, ' || v_source || ' AS source, ' || v_target || ' AS target, cost, reverse_cost 
                    FROM temp_pgr_arc';

                EXECUTE 'SELECT array_agg(pgr_node_id)::INT[] 
                        FROM temp_pgr_node 
                        JOIN man_tank ON man_tank.node_id = temp_pgr_node.node_id'
                INTO v_pgr_root_vids;
            END IF;

            INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
            (
                SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
                FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
            );

            -- update to_arc of nodes in from zero mode
            v_query_text = '
            WITH node_parents AS (
                SELECT pgr_node_id, node_id
                FROM temp_pgr_node
                WHERE graph_delimiter = ''' || v_mapzone_name || '''
                AND to_arc IS NULL
                AND node_id IS NOT NULL
            ), nodes_to_update AS (
                SELECT node 
                FROM temp_pgr_drivingdistance tpd
                JOIN node_parents n ON tpd.pred = n.pgr_node_id
            ), correct_to_arc AS (
                SELECT *
                FROM temp_pgr_arc tpa
                JOIN nodes_to_update nu ON (tpa.pgr_node_1 = nu.node OR tpa.pgr_node_2 = nu.node)
                JOIN node_parents np ON (tpa.node_1 = np.node_id OR tpa.node_2 = np.node_id)
            )
            UPDATE temp_pgr_node t
            SET to_arc = a.to_arc
            FROM (
                SELECT pgr_node_id, array_agg(arc_id) AS to_arc
                FROM correct_to_arc
                GROUP BY pgr_node_id
            ) a
            WHERE t.pgr_node_id = a.pgr_node_id;';

            EXECUTE v_query_text;

        END IF;
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
