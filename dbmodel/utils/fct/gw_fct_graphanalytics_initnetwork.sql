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
    v_mode text;
    v_arc_id integer;

    -- extra variables
    v_graph_delimiter TEXT;
    v_cost INTEGER = 1;
    v_reverse_cost INTEGER = 1;

    v_query_text TEXT;
    v_query_text_components TEXT;
    v_node integer;

    -- temporary tables
    v_temp_arc_table regclass;
    v_temp_node_table regclass;
    v_temp_table regclass;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
    v_expl_id_array = string_to_array(p_data->'data'->>'expl_id_array', ',');
    v_mapzone_name = p_data->'data'->>'mapzone_name';
    v_arc_id = p_data->'data'->>'arc_id';
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

    IF v_mode = 'MINSECTOR' THEN
        v_temp_arc_table = 'temp_pgr_arc_minsector'::regclass;
        v_temp_node_table = 'temp_pgr_node_minsector'::regclass;
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

    -- prepare query used for connectedComponents
    IF v_mode = 'MINSECTOR' THEN
        v_query_text := '
            SELECT node_id AS id, minsector_1 AS source, minsector_2 AS target, 1 AS cost 
            FROM minsector_graph
            UNION ALL
            SELECT minsector_id as id, minsector_id as source, minsector_id as target, 1 as cost 
            FROM minsector m
            WHERE NOT EXISTS (
                SELECT 1 FROM minsector_graph mg 
                WHERE mg.minsector_1 = m.minsector_id OR mg.minsector_2 = m.minsector_id
            )
        ';
    ELSE
        IF v_mapzone_name = 'MINCUT' THEN
            -- the connected cluster for mincut will stop at the water source node
             v_query_text := '
                SELECT a.arc_id AS id, a.node_1 AS source, a.node_2 AS target, 1 AS cost 
                FROM v_temp_arc a
                WHERE NOT EXISTS (
                    SELECT 1 FROM v_temp_node n 
                    WHERE ''' || v_graph_delimiter ||''' = ANY (n.graph_delimiter)
                    AND a.node_1 = n.node_id
                )
                AND NOT EXISTS (
                    SELECT 1 FROM v_temp_node n 
                    WHERE '''|| v_graph_delimiter ||''' = ANY (n.graph_delimiter)
                    AND a.node_2 = n.node_id
                )
            ';
        ELSE
            v_query_text := '
                SELECT arc_id AS id, node_1 AS source, node_2 AS target, 1 AS cost FROM v_temp_arc
            ';
        END IF;
    END IF;

    -- condition for filtering connected clusters
    IF v_expl_id_array IS NOT NULL THEN
        IF v_mode = 'MINSECTOR' THEN
            v_query_text_components := '
                WHERE EXISTS (
                    SELECT 1
                    FROM v_temp_arc v
                    WHERE v.expl_id = ANY (ARRAY['||array_to_string(v_expl_id_array, ',')||']) 
                    AND v.minsector_id = c.node
                )
            ';
        ELSE
            v_query_text_components := '
                WHERE EXISTS (
                    SELECT 1
                    FROM v_temp_arc v
                    WHERE v.expl_id = ANY (ARRAY['||array_to_string(v_expl_id_array, ',')||']) 
                    AND v.node_1 = c.node
                )
            ';
        END IF;
    ELSIF v_arc_id IS NOT NULL THEN
        IF v_mode = 'MINSECTOR' THEN
            EXECUTE format('
                SELECT minsector_id FROM v_temp_arc WHERE arc_id = %L;
            ',v_arc_id)
            INTO v_node;
        ELSE
            -- v_node = one of the nodes of the arc v_arc that is not water source (SECTOR); 0 if both of the nodes are water source
            EXECUTE format('
                SELECT COALESCE(
                    (SELECT node_id
                    FROM v_temp_node n
                    JOIN v_temp_arc a ON n.node_id IN (a.node_1, node_2)
                    WHERE a.arc_id = %L
                    AND %L <> ALL(n.graph_delimiter)
                    LIMIT 1
                ), 0);
            ', v_arc_id, v_graph_delimiter)
            INTO v_node;
        END IF;
        v_query_text_components := 'WHERE c.node = '||v_node;
    ELSE
        v_query_text_components := '';
    END IF;

    EXECUTE format('
        WITH connectedcomponents AS (
            SELECT * FROM pgr_connectedcomponents($q$ %s $q$)
        ),
        components AS (
            SELECT c.component
            FROM connectedcomponents c
            %s
            GROUP BY c.component
        )
        INSERT INTO %I (node_id)
        SELECT c.node
        FROM connectedcomponents c
        WHERE EXISTS (
            SELECT 1
            FROM components cc
            WHERE cc.component = c.component
        );
    ', v_query_text, v_query_text_components, v_temp_node_table);

    IF v_mapzone_name = 'MINCUT' THEN
        IF v_mode = 'MINSECTOR' THEN
            -- update graph_delimiter for all nodes (they are MINSECTOR)
            EXECUTE format('
            UPDATE %I SET graph_delimiter = ''MINSECTOR'';
            ', v_temp_node_table);

            -- insert nodes that are graph_delimiter = 'SECTOR' (water source)
            EXECUTE format('
                INSERT INTO %I (node_id, graph_delimiter)
                SELECT n.node_id, %L
                FROM v_temp_node n
                JOIN v_temp_arc a ON n.node_id IN (a.node_1, a.node_2) 
                WHERE %L = ANY(n.graph_delimiter)
                AND EXISTS (SELECT 1 FROM %I vtn WHERE a.minsector_id = vtn.node_id);
            ', v_temp_node_table, v_graph_delimiter, v_graph_delimiter, v_temp_node_table);
        ELSE
            IF v_node = 0 THEN
                -- the arc is between 2 water source nodes, v_temp_node_table has no nodes, insert them
                EXECUTE format('
                INSERT INTO %I (node_id, graph_delimiter)
                SELECT n.node_id, %L
                FROM v_temp_node n
                JOIN v_temp_arc a ON n.node_id IN (a.node_1, a.node_2)
                WHERE a.arc_id = %L
            ', v_temp_node_table, v_graph_delimiter, v_arc_id);
            ELSE 
                -- insert nodes that are graph_delimiter = 'SECTOR' (water source) and the other node is in v_temp_node_table
                EXECUTE format('
                    INSERT INTO %I (node_id, graph_delimiter)
                    SELECT n.node_id, %L
                    FROM v_temp_node n
                    JOIN v_temp_arc a ON n.node_id IN (a.node_1, a.node_2) 
                    WHERE %L = ANY(n.graph_delimiter)
                    AND EXISTS (SELECT 1 FROM %I vtn WHERE vtn.node_id IN (a.node_1, a.node_2));
                ', v_temp_node_table, v_graph_delimiter, v_graph_delimiter, v_temp_node_table);
            END IF;    
        END IF;
    ELSE
        -- MAPZONE graph_delimiter
        EXECUTE format('
            UPDATE %I t
            SET graph_delimiter = %L
            FROM v_temp_node n
            WHERE %L = ANY(n.graph_delimiter)
            AND t.node_id = n.node_id;
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
        EXECUTE format('
            INSERT INTO %I (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost)
            SELECT a.node_id, a.minsector_1, a.minsector_2, n1.pgr_node_id, n2.pgr_node_id, %L, %L
            FROM minsector_graph a
            JOIN %I n1 ON n1.node_id = a.minsector_1
            JOIN %I n2 ON n2.node_id = a.minsector_2;
        ', v_temp_arc_table, v_cost, v_reverse_cost, v_temp_node_table, v_temp_node_table);
    ELSE
        EXECUTE format('
            INSERT INTO %I (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost)
            SELECT a.arc_id, n1.node_id, n2.node_id, n1.pgr_node_id, n2.pgr_node_id, %L, %L
            FROM v_temp_arc a
            JOIN %I n1 ON n1.node_id = a.node_1
            JOIN %I n2 ON n2.node_id = a.node_2;
        ', v_temp_arc_table, v_cost, v_reverse_cost, v_temp_node_table, v_temp_node_table);
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
            -- update to_arc, closed, broken, graph_delimiter for VALVES (valves are arcs for version 6.1, nodes if not)
            IF v_mode = 'MINSECTOR' THEN
                v_temp_table = v_temp_arc_table;
                v_query_text = 'arc_id';
            ELSE
                v_temp_table = v_temp_node_table;
                v_query_text = 'node_id';
            END IF;

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
                WHERE t.%s = v.node_id; 
            ', v_temp_table, v_query_text);

            -- update to_arc for nodes that are graph_delimiter/water source 
            -- SET TO_ARC from TANK
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

            -- SET TO_ARC from SOURCE
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

            -- SET TO_ARC from WATERWELL
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

            -- SET TO_ARC from WTP
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

            IF v_mode = 'MINSECTOR' THEN
                -- add arcs that connect the nodes 'SECTOR' with the nodes 'MINSECTOR'
                -- arcs where node_1 is 'SECTOR'
                EXECUTE format('
                    INSERT INTO %I (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost, graph_delimiter)
                    SELECT a.arc_id, n1.node_id, n2.node_id, n1.pgr_node_id, n2.pgr_node_id, %L, %L, ''SECTOR''
                    FROM v_temp_arc a
                    JOIN %I n1 ON n1.node_id = a.node_1
                    JOIN %I n2 ON n2.node_id = a.minsector_id
                    WHERE n1.graph_delimiter = ''SECTOR'';
                ', v_temp_arc_table, v_cost, v_reverse_cost, v_temp_node_table, v_temp_node_table);

                -- arcs where node_2 is 'SECTOR'
                EXECUTE format('
                    INSERT INTO %I (arc_id, node_1, node_2, pgr_node_1, pgr_node_2, cost, reverse_cost, graph_delimiter)
                    SELECT a.arc_id, n1.node_id, n2.node_id, n1.pgr_node_id, n2.pgr_node_id, %L, %L, ''SECTOR''
                    FROM v_temp_arc a
                    JOIN %I n1 ON n1.node_id = a.minsector_id
                    JOIN %I n2 ON n2.node_id = a.node_2
                    WHERE n2.graph_delimiter =  ''SECTOR'';
                ', v_temp_arc_table, v_cost, v_reverse_cost, v_temp_node_table, v_temp_node_table);
            END IF;
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
