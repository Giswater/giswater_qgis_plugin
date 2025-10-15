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
    v_mapzone_field text;
    v_node_id integer;

    -- extra variables
    v_graph_delimiter TEXT;
    v_cost INTEGER = 1;
    v_reverse_cost INTEGER = 1;

    v_query_text TEXT;
    v_query_text_aux TEXT;
    v_query_text_connectedcomponents TEXT;
    v_query_text_components TEXT;

    -- temporary tables
    v_temp_arc_table regclass;
    v_temp_node_table regclass;

    v_mode text;


BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
    v_expl_id_array = string_to_array(p_data->'data'->>'expl_id_array', ',');
    v_mapzone_name = p_data->'data'->>'mapzone_name';
    v_node_id = p_data->'data'->>'node_id';
    v_mode = p_data->'data'->>'mode';

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

    IF v_mapzone_name = 'MINCUT' THEN
        v_temp_arc_table = 'temp_pgr_arc_mincut'::regclass;
        v_temp_node_table = 'temp_pgr_node_mincut'::regclass;
    ELSE
        v_temp_arc_table = 'temp_pgr_arc'::regclass;
        v_temp_node_table = 'temp_pgr_node'::regclass;
    END IF;

    IF v_project_type = 'UD' THEN v_reverse_cost = -1; END IF;

    IF v_mapzone_name IN ('MINSECTOR', 'MINCUT') THEN
        v_graph_delimiter := 'SECTOR';
    ELSE
        v_graph_delimiter := v_mapzone_name;
    END IF;
    
    IF v_mapzone_name ILIKE '%TYPE%' THEN 
        v_mapzone_field = LOWER(v_mapzone_name);
    ELSIF v_mapzone_name = 'MINCUT' THEN v_mapzone_field = NULL;
    ELSE v_mapzone_field = LOWER(v_mapzone_name) || '_id';
    END IF;

    IF v_expl_id_array IS NOT NULL THEN
        v_query_text_components := 'AND vtn.expl_id = ANY (ARRAY['||array_to_string(v_expl_id_array, ',')||'])';
    ELSIF v_node_id IS NOT NULL THEN
        v_query_text_components := 'AND vtn.node_id = '||v_node_id;
    ELSE
        v_query_text_components := '';
    END IF;

    IF v_mode = 'MINSECTOR' THEN
        v_query_text = '
            WITH connectedcomponents AS (
                SELECT * FROM pgr_connectedcomponents($q$
                    SELECT node_id AS id, minsector_1 AS source, minsector_2 AS target, 1 AS cost FROM minsector_graph
                $q$)
            ),
            components AS (
                SELECT c.component
                FROM connectedcomponents c
                WHERE EXISTS (
                    SELECT 1
                    FROM v_temp_node vtn
                    WHERE c.node = vtn.minsector_id
                    '||v_query_text_components||'
                )
                GROUP BY c.component
            )
            INSERT INTO ' || v_temp_node_table || ' (node_id, graph_delimiter)
            SELECT c.node, ''MINSECTOR''
            FROM connectedcomponents c
            WHERE EXISTS (
                SELECT 1
                FROM components cc
                WHERE cc.component = c.component
            );
        ';
    ELSE
        v_query_text = '
            WITH connectedcomponents AS (
                SELECT * FROM pgr_connectedcomponents($q$
                    SELECT arc_id AS id, node_1 AS source, node_2 AS target, 1 AS cost FROM v_temp_arc
                $q$)
            ),
            components AS (
                SELECT c.component
                FROM connectedcomponents c
                WHERE EXISTS (
                    SELECT 1
                    FROM v_temp_node vtn
                    WHERE c.node = vtn.node_id
                    '||v_query_text_components||'
                )
                GROUP BY c.component
            )
            INSERT INTO ' || v_temp_node_table || ' (node_id)
            SELECT c.node
            FROM connectedcomponents c
            WHERE EXISTS (
                SELECT 1
                FROM components cc
                WHERE cc.component = c.component
            );
        ';
    END IF;
    EXECUTE v_query_text;

    IF v_mode = 'MINSECTOR' THEN
        -- insert nodes that are graph_delimiter = 'SECTOR' (water source)
        INSERT INTO v_temp_node_table (node_id, graph_delimiter)
        SELECT n.node_id, v_graph_delimiter
        FROM v_temp_node n 
        JOIN v_temp_arc a ON COALESCE(a.node_1, a.node_2) = n.node_id
        WHERE v_graph_delimiter = ANY(n.graph_delimiter)
        AND EXISTS (SELECT 1 FROM v_temp_node_table vtn WHERE a.minsector_id = vtn.node_id);
    ELSE
        --TODO apareix v_graph_delimiter; no s'ha de posar amb %?
        -- MAPZONE graph_delimiter
        EXECUTE format('
            UPDATE %I t
            SET graph_delimiter = %L
            FROM v_temp_node n
            WHERE t.node_id = n.node_id
            AND t.graph_delimiter = ''NONE''
            AND %L = ANY(n.graph_delimiter);
        ', v_temp_node_table, v_graph_delimiter, v_graph_delimiter);

        -- water source (SECTOR) graph_delimiter
        EXECUTE format('
            UPDATE %I t
            SET graph_delimiter = ''SECTOR''
            FROM v_temp_node n
            WHERE t.node_id = n.node_id
            AND t.graph_delimiter = ''NONE''
            AND ''SECTOR'' = ANY(n.graph_delimiter);
        ', v_temp_node_table);
    END IF;

    IF v_mode = 'MINSECTOR' THEN
        -- the arcs are valves
        v_query_text = 'INSERT INTO ' || v_temp_arc_table || ' (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost)
        SELECT a.node_id, a.minsector_1, a.minsector_2, n1.pgr_node_id, n2.pgr_node_id, ' || v_cost || ', ' || v_reverse_cost || '
        FROM minsector_graph a
        JOIN ' || v_temp_node_table || ' n1 ON n1.node_id = a.minsector_1
        JOIN ' || v_temp_node_table || ' n2 ON n2.node_id = a.minsector_2';
    ELSE
        v_query_text = 'INSERT INTO ' || v_temp_arc_table || ' (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost)
        SELECT a.arc_id, n1.node_id, n2.node_id, n1.pgr_node_id, n2.pgr_node_id, ' || v_cost || ', ' || v_reverse_cost || '
        FROM v_temp_arc a
        JOIN ' || v_temp_node_table || ' n1 ON n1.node_id = a.node_1
        JOIN ' || v_temp_node_table || ' n2 ON n2.node_id = a.node_2';
    END IF;
    EXECUTE v_query_text;

    IF v_mode = 'MINSECTOR' THEN
        -- add arcs that connect the nodes 'SECTOR' with the nodes 'MINSECTOR'
        -- arcs where node_1 is 'SECTOR'
        v_query_text = 'INSERT INTO ' || v_temp_arc_table || ' (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost, graph_delimiter)
        SELECT a.arc_id, n1.node_id, n2.node_id, n1.pgr_node_id, n2.pgr_node_id, ' || v_cost || ', ' || v_reverse_cost || ', ' || v_graph_delimiter || '
        FROM v_temp_arc a
        JOIN ' || v_temp_node_table || ' n1 ON n1.node_id = a.node_1
        JOIN ' || v_temp_node_table || ' n2 ON n2.node_id = a.minsector_id
        WHERE n1.graph_delimiter = ' || v_graph_delimiter;
        EXECUTE v_query_text;

        -- arcs where node_2 is 'SECTOR'
        v_query_text = 'INSERT INTO ' || v_temp_arc_table || ' (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost, graph_delimiter)
        SELECT a.arc_id, n1.node_id, n2.node_id, n1.pgr_node_id, n2.pgr_node_id, ' || v_cost || ', ' || v_reverse_cost || ', ' || v_graph_delimiter || '
        FROM v_temp_arc a
        JOIN ' || v_temp_node_table || ' n1 ON n1.node_id = a.minsector_id
        JOIN ' || v_temp_node_table || ' n2 ON n2.node_id = a.node_2
        WHERE n2.graph_delimiter = ' || v_graph_delimiter;
        EXECUTE v_query_text;
    END IF;

    IF v_mapzone_name ILIKE '%TYPE%' THEN
        v_query_text = 'UPDATE ' || v_temp_node_table || ' n SET mapzone_id = t.' || v_mapzone_field || ', old_mapzone_id = t.' || v_mapzone_field || ' 
            FROM v_temp_node t WHERE n.node_id = t.node_id';
        EXECUTE v_query_text;
        v_query_text = 'UPDATE ' || v_temp_arc_table || ' a SET mapzone_id = t.' || v_mapzone_field || ', old_mapzone_id = t.' || v_mapzone_field || '
             FROM v_temp_arc t WHERE a.arc_id = t.arc_id';
        EXECUTE v_query_text;
    ELSE 
        IF v_mapzone_name <> 'MINCUT' THEN
            v_query_text = 'UPDATE ' || v_temp_node_table || ' n SET old_mapzone_id = t.' || v_mapzone_field || ' 
                FROM v_temp_node t WHERE n.node_id = t.node_id';
            EXECUTE v_query_text;
            v_query_text = 'UPDATE ' || v_temp_arc_table || ' a SET old_mapzone_id = t.' || v_mapzone_field || ' 
                FROM v_temp_arc t WHERE a.arc_id = t.arc_id';
            EXECUTE v_query_text;
        END IF;    

        IF v_project_type = 'WS' THEN
            -- VALVES
            IF v_mode = 'MINSECTOR' THEN
                EXECUTE format('
                    UPDATE %I t
                    SET
                        graph_delimiter = ''MINSECTOR'',
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
                        WHERE ''MINSECTOR'' = ANY(n.graph_delimiter)
                    ) v
                    WHERE t.arc_id = v.node_id; 
                ', v_temp_arc_table);
            ELSE 
                EXECUTE format('
                    UPDATE %I t
                    SET
                        graph_delimiter = ''MINSECTOR'',
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
                        WHERE ''MINSECTOR'' = ANY(n.graph_delimiter)
                    ) v
                    WHERE t.node_id = v.node_id;
                ', v_temp_node_table);
            END IF;
        END IF;

        IF v_project_type = 'WS' THEN
            EXECUTE format('
                UPDATE %I t
                SET to_arc = a.to_arc
                FROM  (
                    SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                    FROM man_tank m
                    JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                    WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                    GROUP BY m.node_id
                ) a
                WHERE t.graph_delimiter IN (%L, ''SECTOR'') AND t.node_id = a.node_id;
            ', v_temp_node_table, v_graph_delimiter);

            EXECUTE format('
                UPDATE %I t
                SET to_arc = a.to_arc
                FROM
                    (SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                    FROM man_source m
                    JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                    WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                    GROUP BY m.node_id
                    )a
                WHERE t.graph_delimiter IN (%L, ''SECTOR'') AND t.node_id = a.node_id;
            ', v_temp_node_table, v_graph_delimiter);

            EXECUTE format('
                UPDATE %I t
                SET to_arc = a.to_arc
                FROM
                    (SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                    FROM man_waterwell m
                    JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                    WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                    GROUP BY m.node_id
                    )a
                WHERE t.graph_delimiter IN (%L, ''SECTOR'') AND t.node_id = a.node_id;
            ', v_temp_node_table, v_graph_delimiter);

            EXECUTE format('
                UPDATE %I t
                SET to_arc = a.to_arc
                FROM
                    (SELECT m.node_id, array_agg(a.arc_id) AS to_arc
                    FROM man_wtp m
                    JOIN v_temp_arc a ON m.node_id IN (a.node_1, a.node_2)
                    WHERE m.inlet_arc IS NULL OR a.arc_id <> ALL(m.inlet_arc)
                    GROUP BY m.node_id
                    )a
                WHERE t.graph_delimiter IN (%L, ''SECTOR'') AND t.node_id = a.node_id;
            ', v_temp_node_table, v_graph_delimiter);

            -- SET TO_ARC from METER
            EXECUTE format('
                UPDATE %I t
                SET to_arc = a.to_arc
                FROM
                    (SELECT node_id,
                        CASE WHEN to_arc IS NULL THEN NULL
                        ELSE ARRAY[to_arc]
                        END AS to_arc
                    FROM man_meter m
                    ) a
                WHERE t.graph_delimiter = %L AND t.node_id = a.node_id;
            ', v_temp_node_table, v_graph_delimiter);

            -- SET TO_ARC from PUMP
            EXECUTE format('
                UPDATE %I t
                SET to_arc = a.to_arc
                FROM
                    (SELECT node_id,
                        CASE WHEN to_arc IS NULL THEN NULL
                        ELSE ARRAY[to_arc]
                        END AS to_arc
                    FROM man_pump m
                    ) a
                WHERE t.graph_delimiter = %L AND t.node_id = a.node_id;
            ', v_temp_node_table, v_graph_delimiter);
        END IF;

        IF v_project_type = 'UD' THEN
            EXECUTE format('
                UPDATE %I t
                SET to_arc = a.to_arc
                FROM (
                        SELECT pgr_node_1, array_agg(arc_id) AS to_arc
                        FROM %I
                        GROUP BY pgr_node_1
                    )a
                WHERE t.graph_delimiter = %L AND t.pgr_node_id = a.pgr_node_1;
            ', v_temp_node_table, v_temp_arc_table, v_graph_delimiter);
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
