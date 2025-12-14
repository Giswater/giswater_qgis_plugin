/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3326

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_arrangenetwork();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_arrangenetwork(p_data json)
RETURNS json AS
$BODY$

/* Example:
SELECT gw_fct_graphanalytics_arrangenetwork('{"data":{"mapzone_name":"MINSECTOR"}}');
It is an auxiliary process used by macro_minsector, minsector, or mapzone that generates additional arcs.
*/

DECLARE

    -- configuration
	v_version TEXT;
    v_project_type TEXT;

    -- parameters
    v_mapzone_name TEXT;
    -- extra variables
    v_graph_delimiter TEXT;
    v_record RECORD;
    v_pgr_node_id INTEGER;
    v_cost integer; -- for the new arcs the cost/reverse_cost is 0 and not 1 so the inundation will be seen correct
    v_reverse_cost integer;
    v_query_text TEXT;
    v_pgr_root_vids INT[];
    v_pgr_distance INTEGER;
    v_source TEXT;
    v_target TEXT;
    v_mode TEXT;

    v_temp_arc_table regclass;
    v_temp_node_table regclass;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
    v_mapzone_name = (SELECT (p_data::json->>'data')::json->>'mapzone_name');
    v_mode = p_data->'data'->>'mode';
    v_cost = p_data->'data'->>'cost';
    v_reverse_cost = p_data->'data'->>'reverse_cost';

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
                'feature', jsonb_build_object(),
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

    IF v_mapzone_name IN ('MINSECTOR', 'MINCUT') THEN
        v_graph_delimiter := 'SECTOR';
    ELSE
        v_graph_delimiter := v_mapzone_name;
    END IF;

    -- ARCS TO MODIFY - Depending on the nodes with modif = TRUE
     IF v_project_type = 'WS' THEN
        -- ARCS VALVES
    	-- for the valves with to_arc NULL, one of the arcs that connect to the valve is modif = TRUE
        EXECUTE format('
            WITH arcs_selected AS (
                SELECT DISTINCT ON (n.pgr_node_id)
                    a.pgr_arc_id,
                    n.pgr_node_id,
                    a.pgr_node_1,
                    a.pgr_node_2
                FROM %I n
                JOIN %I a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
                WHERE n.modif = TRUE
                AND n.graph_delimiter = ''MINSECTOR''
                AND n.to_arc IS NULL
                ORDER BY n.pgr_node_id, a.pgr_arc_id
            )
            UPDATE %I t
            SET modif1 = TRUE
            FROM arcs_selected s
            WHERE s.pgr_node_id = s.pgr_node_1
            AND t.pgr_arc_id = s.pgr_arc_id;
        ', v_temp_node_table, v_temp_arc_table, v_temp_arc_table);

        EXECUTE format('
            WITH arcs_selected AS (
                SELECT DISTINCT ON (n.pgr_node_id)
                    a.pgr_arc_id,
                    n.pgr_node_id,
                    a.pgr_node_1,
                    a.pgr_node_2
                FROM %I n
                JOIN %I a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
                WHERE n.modif = TRUE
                AND n.graph_delimiter = ''MINSECTOR''
                AND n.to_arc IS NULL
                ORDER BY n.pgr_node_id, a.pgr_arc_id
            )
            UPDATE %I t
            SET modif2 = TRUE
            FROM arcs_selected s
            WHERE s.pgr_node_id = s.pgr_node_2
            AND t.pgr_arc_id = s.pgr_arc_id;
        ', v_temp_node_table, v_temp_arc_table, v_temp_arc_table);

        -- for the valves with to_arc NOT NULL, the arc that is not to_arc is modif = TRUE
        EXECUTE format('
            WITH arcs_selected AS (
            SELECT
                a.pgr_arc_id,
                n.pgr_node_id,
                a.pgr_node_1,
                a.pgr_node_2
            FROM  %I n
            JOIN %I a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
            WHERE n.modif = TRUE AND n.graph_delimiter = ''MINSECTOR'' AND n.to_arc IS NOT NULL AND a.arc_id <> ALL(n.to_arc)
            )
            UPDATE %I t
            SET modif1 = TRUE
            FROM arcs_selected s
            WHERE s.pgr_node_id = s.pgr_node_1
            AND t.pgr_arc_id = s.pgr_arc_id;
        ', v_temp_node_table, v_temp_arc_table, v_temp_arc_table);

        EXECUTE format('
            WITH arcs_selected AS (
            SELECT
                a.pgr_arc_id,
                n.pgr_node_id,
                a.pgr_node_1,
                a.pgr_node_2
            FROM  %I n
            JOIN %I a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
            WHERE n.modif = TRUE AND n.graph_delimiter = ''MINSECTOR'' AND n.to_arc IS NOT NULL AND a.arc_id <> ALL(n.to_arc)
            )
            UPDATE %I t
            SET modif2 = TRUE
            FROM arcs_selected s
            WHERE s.pgr_node_id = s.pgr_node_2
            AND t.pgr_arc_id = s.pgr_arc_id;
        ', v_temp_node_table, v_temp_arc_table, v_temp_arc_table);

        -- ARCS watersource (SECTOR WHEN v_graph_delimiter <> 'SECTOR'), only the inletArcs
        EXECUTE format('
            WITH arcs_selected AS (
            SELECT
                a.pgr_arc_id,
                n.pgr_node_id,
                a.pgr_node_1,
                a.pgr_node_2
            FROM  %I n
            JOIN %I a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
            WHERE n.modif = TRUE AND n.graph_delimiter = ''SECTOR'' AND n.graph_delimiter <> %L
            AND n.to_arc IS NOT NULL AND a.arc_id <> ALL(n.to_arc)
            )
            UPDATE %I t
            SET modif1 = TRUE
            FROM arcs_selected s
            WHERE s.pgr_node_id = s.pgr_node_1
            AND t.pgr_arc_id = s.pgr_arc_id;
        ', v_temp_node_table, v_temp_arc_table, v_graph_delimiter, v_temp_arc_table);

        EXECUTE format('
            WITH arcs_selected AS (
            SELECT
                a.pgr_arc_id,
                n.pgr_node_id,
                a.pgr_node_1,
                a.pgr_node_2
            FROM %I n
            JOIN %I a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
            WHERE n.modif = TRUE AND n.graph_delimiter = ''SECTOR'' AND n.graph_delimiter <> %L
            AND n.to_arc IS NOT NULL AND a.arc_id <> ALL(n.to_arc)
            )
            UPDATE %I t
            SET modif2 = TRUE
            FROM arcs_selected s
            WHERE s.pgr_node_id = s.pgr_node_2
            AND t.pgr_arc_id = s.pgr_arc_id;
        ', v_temp_node_table, v_temp_arc_table, v_graph_delimiter, v_temp_arc_table);
    END IF;

    -- for the nodes with v_graph_delimiter - all the arcs
    EXECUTE format('
        WITH arcs_selected AS (
        SELECT
            a.pgr_arc_id,
            n.pgr_node_id,
            a.pgr_node_1,
            a.pgr_node_2
        FROM %I n
        JOIN %I a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        WHERE n.modif = TRUE AND n.graph_delimiter = %L
        )
        UPDATE %I t
        SET modif1 = TRUE
        FROM arcs_selected s
        WHERE s.pgr_node_id = s.pgr_node_1
        AND t.pgr_arc_id = s.pgr_arc_id;
    ', v_temp_node_table, v_temp_arc_table, v_graph_delimiter, v_temp_arc_table);

    EXECUTE format('
        WITH arcs_selected AS (
        SELECT
            a.pgr_arc_id,
            n.pgr_node_id,
            a.pgr_node_1,
            a.pgr_node_2
        FROM %I n
        JOIN %I a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        WHERE n.modif = TRUE AND n.graph_delimiter = %L
        )
        UPDATE %I t
        SET modif2 = TRUE
        FROM arcs_selected s
        WHERE s.pgr_node_id = s.pgr_node_2
        AND t.pgr_arc_id = s.pgr_arc_id;
    ', v_temp_node_table, v_temp_arc_table, v_graph_delimiter, v_temp_arc_table);

    -- for the nodes with graph_delimiter = 'FORCECLOSED' - all the arcs
    EXECUTE format('
        WITH arcs_selected AS (
            SELECT
                a.pgr_arc_id,
                n.pgr_node_id,
                a.pgr_node_1,
                a.pgr_node_2
            FROM %I n
            JOIN %I a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
            WHERE n.modif = TRUE AND n.graph_delimiter = ''FORCECLOSED''
            )
        UPDATE %I t
        SET modif2 = TRUE
        FROM arcs_selected s
        WHERE s.pgr_node_id = s.pgr_node_2
        AND t.pgr_arc_id = s.pgr_arc_id;
    ', v_temp_node_table, v_temp_arc_table, v_temp_arc_table);

    EXECUTE format('
        WITH arcs_selected AS (
        SELECT
            a.pgr_arc_id,
            n.pgr_node_id,
            a.pgr_node_1,
            a.pgr_node_2
        FROM %I n
        JOIN %I a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        WHERE n.modif = TRUE AND n.graph_delimiter = ''FORCECLOSED''
        )
        UPDATE %I t
        SET modif1 = TRUE
        FROM arcs_selected s
        WHERE s.pgr_node_id = s.pgr_node_1
        AND t.pgr_arc_id = s.pgr_arc_id;
    ', v_temp_node_table, v_temp_arc_table, v_temp_arc_table);


    -- Disconnect arcs with modif = TRUE at nodes with modif1 = TRUE; a new arc N_new->N_original is created with the v_cost and v_reverse_cost
    v_query_text = format('
        SELECT n.graph_delimiter AS n_graph_delimiter, n.node_id, a.graph_delimiter AS a_graph_delimiter, 
            a.pgr_arc_id, a.arc_id, a.pgr_node_1, a.node_1, n.to_arc
	    FROM %I n
	    JOIN %I a ON n.pgr_node_id = a.pgr_node_1
	    WHERE n.modif AND a.modif1
    ', v_temp_node_table, v_temp_arc_table);

    FOR v_record IN EXECUTE v_query_text
    LOOP
        EXECUTE format('
            INSERT INTO %I (old_node_id, modif, graph_delimiter, to_arc) 
            VALUES (%L, FALSE, %L, %L) RETURNING pgr_node_id;
        ', v_temp_node_table, v_record.node_id, v_record.n_graph_delimiter, v_record.to_arc)
        INTO v_pgr_node_id;

        EXECUTE format('
            UPDATE %I SET pgr_node_1 = %L, node_1 = NULL
            WHERE pgr_arc_id = %L;
        ', v_temp_arc_table, v_pgr_node_id, v_record.pgr_arc_id);

        EXECUTE format('
            INSERT INTO %I (old_arc_id, pgr_node_1, pgr_node_2, node_1, graph_delimiter, cost, reverse_cost, to_arc)
            VALUES (%L, %L, %L, %L, %L, %L, %L, %L);
        ', v_temp_arc_table, v_record.arc_id, v_record.pgr_node_1, v_pgr_node_id, v_record.node_1,
        v_record.n_graph_delimiter, v_cost, v_reverse_cost, v_record.to_arc);
    END LOOP;

    -- Disconnect arcs with modif = TRUE at nodes with modif2 = TRUE; a new arc N_new->N_original is created with the v_cost and v_reverse_cost
    v_query_text = format('
	    SELECT n.graph_delimiter AS n_graph_delimiter, n.node_id, a.graph_delimiter AS a_graph_delimiter, a.pgr_arc_id, a.arc_id, a.pgr_node_2, a.node_2, n.to_arc
	    FROM %I n
	    JOIN %I a ON n.pgr_node_id = a.pgr_node_2
	    WHERE n.modif AND a.modif2
    ', v_temp_node_table, v_temp_arc_table);

    FOR v_record IN EXECUTE v_query_text
    LOOP
        EXECUTE format('
            INSERT INTO %I (old_node_id, modif, graph_delimiter, to_arc) 
            VALUES (%L, FALSE, %L, %L) RETURNING pgr_node_id;
        ', v_temp_node_table, v_record.node_id, v_record.n_graph_delimiter, v_record.to_arc)
        INTO v_pgr_node_id;

        EXECUTE format('
            UPDATE %I SET pgr_node_2 = %L, node_2 = NULL
            WHERE pgr_arc_id = %L;
        ', v_temp_arc_table, v_pgr_node_id, v_record.pgr_arc_id);

        EXECUTE format('
            INSERT INTO %I (old_arc_id, pgr_node_1, pgr_node_2, node_2, graph_delimiter, cost, reverse_cost, to_arc)
            VALUES (%L, %L, %L, %L, %L, %L, %L, %L);
        ', v_temp_arc_table, v_record.arc_id, v_pgr_node_id, v_record.pgr_node_2, v_record.node_2,
        v_record.n_graph_delimiter, v_cost, v_reverse_cost, v_record.to_arc);
    END LOOP;

    IF v_project_type = 'WS' THEN
        -- UPDATE values for the NEW arcs and nodes
        EXECUTE format('
            UPDATE %I t
            SET closed = n.closed, broken = n.broken
            FROM %I n
            WHERE n.modif = TRUE
            AND t.graph_delimiter = ''MINSECTOR''
            AND COALESCE(t.node_1, t.node_2) = n.node_id;
        ', v_temp_arc_table, v_temp_node_table);

        EXECUTE format('
            UPDATE %I t
            SET closed = n.closed, broken = n.broken
            FROM %I n
            WHERE n.modif = TRUE
            AND t.graph_delimiter = ''MINSECTOR''
            AND t.old_node_id = n.node_id
            ;
        ', v_temp_node_table, v_temp_node_table);

        -- UPDATE cost/reverse_cost
        -- closed valves
        EXECUTE format('
            UPDATE %I a
            SET cost = -1, reverse_cost = -1
            WHERE a.graph_delimiter  = ''MINSECTOR''
            AND a.closed = TRUE;
        ', v_temp_arc_table);

        -- checkvalves
        IF v_mode = 'MINSECTOR' THEN
            EXECUTE format('
				UPDATE %I a
                SET cost = CASE WHEN EXISTS (SELECT 1 FROM v_temp_arc v WHERE v.arc_id = a.to_arc[1] AND v.minsector_id = a.node_1) THEN -1 ELSE a.cost END,
                    reverse_cost = CASE WHEN EXISTS (SELECT 1 FROM v_temp_arc v WHERE v.arc_id = a.to_arc[1] AND v.minsector_id = a.node_2) THEN -1 ELSE a.reverse_cost END
                WHERE a.graph_delimiter  = ''MINSECTOR''
                AND a.closed = FALSE
                AND a.to_arc IS NOT NULL;
                ', v_temp_arc_table);
        ELSE
            EXECUTE format('
                UPDATE %I a
                SET cost = CASE WHEN a.node_1 IS NOT NULL THEN -1 ELSE a.cost END,
                    reverse_cost = CASE WHEN a.node_2 IS NOT NULL THEN -1 ELSE a.reverse_cost END
                WHERE a.graph_delimiter  = ''MINSECTOR''
                AND a.to_arc IS NOT NULL
                AND a.closed = FALSE;
            ', v_temp_arc_table);
        END IF;

        -- for the watersources (SECTOR) - the inlet arcs behave like checkvalves
        EXECUTE format('
            UPDATE %I a
            SET cost = CASE WHEN a.node_1 IS NOT NULL THEN -1 ELSE a.cost END,
                reverse_cost = CASE WHEN a.node_2 IS NOT NULL THEN -1 ELSE a.reverse_cost END
            WHERE a.graph_delimiter = ''SECTOR''
            AND a.old_arc_id <> ALL (a.to_arc);
        ', v_temp_arc_table);
    END IF;

    RETURN jsonb_build_object(
        'status', 'Accepted',
        'message', jsonb_build_object(
            'level', 1,
            'text', 'The network has been arranged successfully.'
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'feature', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

    EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'status', 'Failed',
        'message', jsonb_build_object(
            'level', 3,
            'text', 'An error occurred while arranging the network:' || SQLERRM
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
