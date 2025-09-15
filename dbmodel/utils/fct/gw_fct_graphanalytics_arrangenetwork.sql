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
    v_from_zero boolean;

    -- parameters
    v_mapzone_name TEXT;
    -- extra variables
    v_graph_delimiter TEXT;
    v_record RECORD;
    v_pgr_node_id INTEGER;
    v_cost integer=0; -- for the new arcs the cost/reverse_cost is 0 and not 1 so the inundation will be seen correct
    v_reverse_cost integer=0;
    v_query_text TEXT;
    v_pgr_root_vids INT[];
    v_pgr_distance INTEGER;
    v_source TEXT;
    v_target TEXT;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
    v_mapzone_name = (SELECT (p_data::json->>'data')::json->>'mapzone_name');
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

    IF v_mapzone_name IN ('MINSECTOR', 'MINCUT') THEN
        v_graph_delimiter := 'SECTOR';
    ELSE
        v_graph_delimiter := v_mapzone_name;
    END IF;

    IF v_project_type = 'UD' THEN
        v_reverse_cost = -1;
    ELSE
        -- ARCS TO MODIFY - Depending on the nodes with modif = TRUE
        -- ARCS VALVES
    	-- for the valves with to_arc NULL, one of the arcs that connect to the valve is modif = TRUE
        WITH arcs_selected AS (
            SELECT DISTINCT ON (n.pgr_node_id)
                a.pgr_arc_id,
                n.pgr_node_id,
                a.pgr_node_1,
                a.pgr_node_2
            FROM temp_pgr_node n
            JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
            WHERE n.modif = TRUE
            AND n.graph_delimiter = 'MINSECTOR'
            AND n.to_arc IS NULL
        ), arcs_modif AS (
            SELECT
                pgr_arc_id,
                bool_or(pgr_node_id = pgr_node_1) AS modif1,
                bool_or( pgr_node_id = pgr_node_2) AS modif2
            FROM arcs_selected
            GROUP BY pgr_arc_id
        )
        UPDATE temp_pgr_arc t
        SET
            modif1 = s.modif1,
            modif2 = s.modif2
        FROM arcs_modif s
        WHERE t.pgr_arc_id = s.pgr_arc_id;

        -- for the valves with to_arc NOT NULL, the arc that is not to_arc is modif = TRUE
        WITH arcs_selected AS (
		SELECT
			a.pgr_arc_id,
			n.pgr_node_id,
			a.pgr_node_1,
			a.pgr_node_2
		FROM  temp_pgr_node n
		JOIN temp_pgr_arc a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
		WHERE n.modif = TRUE AND n.graph_delimiter = 'MINSECTOR' AND n.to_arc IS NOT NULL AND a.arc_id <> ALL(n.to_arc)
        ), arcs_modif AS (
            SELECT
                pgr_arc_id,
                bool_or(pgr_node_id = pgr_node_1) AS modif1,
                bool_or( pgr_node_id = pgr_node_2) AS modif2
            FROM arcs_selected
            GROUP BY pgr_arc_id
        )
        UPDATE temp_pgr_arc t
        SET modif1= s.modif1,
            modif2= s.modif2
        FROM arcs_modif s
        WHERE t.pgr_arc_id= s.pgr_arc_id;

        -- ARCS watersource (SECTOR WHEN v_mapzone_name <> 'SECTOR'), only the inletArcs
        WITH arcs_selected AS (
		SELECT
			a.pgr_arc_id,
			n.pgr_node_id,
			a.pgr_node_1,
			a.pgr_node_2
		FROM  temp_pgr_node n
		JOIN temp_pgr_arc a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
		WHERE n.modif = TRUE AND n.graph_delimiter = 'SECTOR' AND n.graph_delimiter <> v_mapzone_name
        AND n.to_arc IS NOT NULL AND a.arc_id <> ALL(n.to_arc)
        ), arcs_modif AS (
            SELECT
                pgr_arc_id,
                bool_or(pgr_node_id = pgr_node_1) AS modif1,
                bool_or( pgr_node_id = pgr_node_2) AS modif2
            FROM arcs_selected
            GROUP BY pgr_arc_id
        )
        UPDATE temp_pgr_arc t
        SET modif1= s.modif1,
            modif2= s.modif2
        FROM arcs_modif s
        WHERE t.pgr_arc_id= s.pgr_arc_id;
    END IF;

    -- for the nodes with v_graph_delimiter - all the arcs
    WITH arcs_selected AS (
    SELECT
        a.pgr_arc_id,
        n.pgr_node_id,
        a.pgr_node_1,
        a.pgr_node_2
    FROM temp_pgr_node n
    JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
    WHERE n.modif = TRUE AND n.graph_delimiter = v_graph_delimiter
    ), arcs_modif AS (
        SELECT
            pgr_arc_id,
            bool_or(pgr_node_id = pgr_node_1) AS modif1,
            bool_or( pgr_node_id = pgr_node_2) AS modif2
        FROM arcs_selected
        GROUP BY pgr_arc_id
    )
    UPDATE temp_pgr_arc t
    SET modif1= s.modif1,
        modif2= s.modif2
    FROM arcs_modif s
    WHERE t.pgr_arc_id= s.pgr_arc_id;

    -- for the nodes with graph_delimiter = 'FORCECLOSED' - all the arcs
    WITH arcs_selected AS (
        SELECT
            a.pgr_arc_id,
            n.pgr_node_id,
            a.pgr_node_1,
            a.pgr_node_2
        FROM temp_pgr_node n
        JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        WHERE n.modif = TRUE AND n.graph_delimiter = 'FORCECLOSED'
        ), arcs_modif AS (
            SELECT
                pgr_arc_id,
                bool_or(pgr_node_id = pgr_node_1) AS modif1,
                bool_or( pgr_node_id = pgr_node_2) AS modif2
            FROM arcs_selected
            GROUP BY pgr_arc_id
        )
    UPDATE temp_pgr_arc t
    SET modif1= s.modif1,
        modif2= s.modif2
    FROM arcs_modif s
    WHERE t.pgr_arc_id= s.pgr_arc_id;

    -- Disconnect arcs with modif = TRUE at nodes with modif1 = TRUE; a new arc N_new->N_original is created with the v_cost and v_reverse_cost
    FOR v_record IN
	    SELECT n.graph_delimiter AS n_graph_delimiter, n.node_id, a.graph_delimiter AS a_graph_delimiter, a.pgr_arc_id, a.arc_id, a.pgr_node_1, a.node_1, n.to_arc
	    FROM temp_pgr_node n
	    JOIN temp_pgr_arc a ON n.pgr_node_id = a.pgr_node_1
	    WHERE n.modif AND a.modif1
    LOOP
	    INSERT INTO temp_pgr_node (old_node_id, modif, graph_delimiter, to_arc) VALUES (v_record.node_id, FALSE, v_record.n_graph_delimiter, v_record.to_arc);
        SELECT LAST_VALUE INTO v_pgr_node_id FROM temp_pgr_node_pgr_node_id_seq;
	    UPDATE temp_pgr_arc SET pgr_node_1 = v_pgr_node_id, node_1 = NULL
	    WHERE pgr_arc_id = v_record.pgr_arc_id;
	    INSERT INTO temp_pgr_arc (old_arc_id, pgr_node_1, pgr_node_2, node_1, graph_delimiter, cost, reverse_cost, to_arc)
	    VALUES (v_record.arc_id, v_record.pgr_node_1, v_pgr_node_id, v_record.node_1,
        v_record.n_graph_delimiter, v_cost, v_reverse_cost, v_record.to_arc);
    END LOOP;

    -- Disconnect arcs with modif = TRUE at nodes with modif2 = TRUE; a new arc N_new->N_original is created with the v_cost and v_reverse_cost
    FOR v_record IN
	    SELECT n.graph_delimiter AS n_graph_delimiter, n.node_id, a.graph_delimiter AS a_graph_delimiter, a.pgr_arc_id, a.arc_id, a.pgr_node_2, a.node_2, n.to_arc
	    FROM temp_pgr_node n
	    JOIN temp_pgr_arc a ON n.pgr_node_id = a.pgr_node_2
	    WHERE n.modif AND a.modif2
    LOOP
	    INSERT INTO temp_pgr_node (old_node_id, modif, graph_delimiter, to_arc) VALUES (v_record.node_id, FALSE, v_record.n_graph_delimiter, v_record.to_arc);
        SELECT LAST_VALUE INTO v_pgr_node_id FROM temp_pgr_node_pgr_node_id_seq;
	    UPDATE temp_pgr_arc SET pgr_node_2 = v_pgr_node_id, node_2 = NULL
	    WHERE pgr_arc_id = v_record.pgr_arc_id;
	    INSERT INTO temp_pgr_arc(old_arc_id, pgr_node_1, pgr_node_2, node_2, graph_delimiter, cost, reverse_cost, to_arc)
	    VALUES (v_record.arc_id, v_pgr_node_id, v_record.pgr_node_2, v_record.node_2,
        v_record.n_graph_delimiter, v_cost, v_reverse_cost, v_record.to_arc);
    END LOOP;

    IF v_project_type = 'WS' THEN
        UPDATE temp_pgr_arc t
        SET closed = n.closed, broken = n.broken
        FROM temp_pgr_node n
        WHERE COALESCE(t.node_1, t.node_2) = n.node_id
        AND t.graph_delimiter = 'MINSECTOR';

        UPDATE temp_pgr_node t
        SET closed = n.closed, broken = n.broken
        FROM temp_pgr_node n
        WHERE t.old_node_id = n.node_id
        AND t.graph_delimiter = 'MINSECTOR';

        -- closed valves
        UPDATE temp_pgr_arc a
        SET cost = -1, reverse_cost = -1
        WHERE a.graph_delimiter  = 'MINSECTOR'
        AND a.closed = TRUE;

        -- checkvalves
        UPDATE temp_pgr_arc a
        SET cost = CASE WHEN a.node_1 IS NOT NULL THEN -1 ELSE a.cost END,
            reverse_cost = CASE WHEN a.node_2 IS NOT NULL THEN -1 ELSE a.reverse_cost END
        WHERE a.graph_delimiter  = 'MINSECTOR'
        AND a.to_arc IS NOT NULL
        AND a.closed = FALSE;

        -- for mapzone graph_delimiter and the watersources (SECTOR) - the inlet arcs behave like checkvalves
        UPDATE temp_pgr_arc a
        SET cost = CASE WHEN a.node_1 IS NOT NULL THEN -1 ELSE a.cost END,
            reverse_cost = CASE WHEN a.node_2 IS NOT NULL THEN -1 ELSE a.reverse_cost END
        WHERE a.graph_delimiter IN (v_graph_delimiter, 'SECTOR')
        AND a.old_arc_id <> ALL (a.to_arc);
    END IF;

    -- FORCECLOSED
    UPDATE temp_pgr_arc a
    SET cost = -1, reverse_cost = -1
    WHERE a.graph_delimiter  = 'FORCECLOSED';

    -- calculate to_arc of node parents in from zero mode
    IF v_from_zero AND v_project_type = 'WS' THEN
        v_query_text := 'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost, reverse_cost 
            FROM temp_pgr_arc';

        EXECUTE 'SELECT array_agg(pgr_node_id)::INT[] 
                FROM temp_pgr_node 
                JOIN v_temp_node v ON v.node_id = temp_pgr_node.node_id
                WHERE ''SECTOR'' = ANY(v.graph_delimiter)'
        INTO v_pgr_root_vids;

        EXECUTE 'SELECT COUNT(*)::INT FROM temp_pgr_arc'
        INTO v_pgr_distance;

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
            AND graph_delimiter <> ''SECTOR''
            AND to_arc IS NULL
            AND node_id IS NOT NULL
        ), 
        arc_parents AS (
            SELECT pgr_arc_id, old_arc_id
            FROM temp_pgr_arc
            WHERE graph_delimiter = ''' || v_mapzone_name || '''
            AND graph_delimiter <> ''SECTOR''
        ),
        nodes_to_update AS (
            SELECT d.pred as pgr_node_id, d.edge, a.old_arc_id
            FROM temp_pgr_drivingdistance d
            JOIN node_parents n ON d.pred = n.pgr_node_id
            JOIN arc_parents a ON d.edge = a.pgr_arc_id
        )
        UPDATE temp_pgr_node t
        SET to_arc = a.to_arc
        FROM (
            SELECT pgr_node_id, array_agg(old_arc_id) AS to_arc
            FROM nodes_to_update
            GROUP BY pgr_node_id
        ) a
        WHERE t.pgr_node_id = a.pgr_node_id';

        EXECUTE v_query_text;

        UPDATE temp_pgr_node t
        SET to_arc = n.to_arc
        FROM temp_pgr_node n
        WHERE t.old_node_id = n.node_id
        AND t.graph_delimiter = v_graph_delimiter
        AND t.to_arc IS NULL;

        UPDATE temp_pgr_arc t
        SET to_arc = n.to_arc
        FROM temp_pgr_node n
        WHERE COALESCE(t.node_1, t.node_2) = n.node_id
        AND t.graph_delimiter = v_graph_delimiter
        AND n.graph_delimiter = v_graph_delimiter
        AND t.to_arc IS NULL
        AND n.to_arc IS NOT NULL;

        -- for mapzone graph_delimiter - the inlet arcs behave like checkvalves
        UPDATE temp_pgr_arc a
        SET cost = CASE WHEN a.node_1 IS NOT NULL THEN -1 ELSE a.cost END,
            reverse_cost = CASE WHEN a.node_2 IS NOT NULL THEN -1 ELSE a.reverse_cost END
        WHERE a.graph_delimiter = v_graph_delimiter
        AND a.old_arc_id <> ALL (a.to_arc);
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
