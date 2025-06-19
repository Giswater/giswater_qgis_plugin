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
    v_cost integer=0; -- for the new arcs the cost/reverse_cost is 0 and not 1 so the inundation will be seen correct
    v_reverse_cost integer=0;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
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

    IF v_mapzone_name IN ('MINSECTOR', 'MINCUT') THEN
        v_graph_delimiter := 'SECTOR';
    ELSE
        v_graph_delimiter := v_mapzone_name;
    END IF;

    IF v_project_type = 'UD' THEN
        v_cost = -1;
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
    END IF;

    -- Disconnect arcs with modif = TRUE at nodes with modif1 = TRUE; a new arc N_new->N_original is created with the v_cost and v_reverse_cost
    FOR v_record IN
	    SELECT n.graph_delimiter AS n_graph_delimiter, n.node_id, a.graph_delimiter AS a_graph_delimiter, a.pgr_arc_id, a.arc_id, a.pgr_node_1, a.node_1
	    FROM temp_pgr_node n
	    JOIN temp_pgr_arc a ON n.pgr_node_id = a.pgr_node_1
	    WHERE n.modif AND a.modif1
    LOOP
	    INSERT INTO temp_pgr_node (old_node_id, modif, graph_delimiter) VALUES (v_record.node_id, FALSE, v_record.n_graph_delimiter);
        SELECT LAST_VALUE INTO v_pgr_node_id FROM temp_pgr_node_pgr_node_id_seq;
	    UPDATE temp_pgr_arc SET pgr_node_1 = v_pgr_node_id, node_1 = NULL
	    WHERE pgr_arc_id = v_record.pgr_arc_id;
	    INSERT INTO temp_pgr_arc (old_arc_id, pgr_node_1, pgr_node_2, node_1, graph_delimiter, cost, reverse_cost)
	    VALUES (v_record.arc_id, v_record.pgr_node_1, v_pgr_node_id, v_record.node_1,
        CASE WHEN v_record.a_graph_delimiter = 'NONE' THEN v_record.n_graph_delimiter ELSE v_record.a_graph_delimiter END, v_cost, v_reverse_cost);
    END LOOP;

    -- Disconnect arcs with modif = TRUE at nodes with modif2 = TRUE; a new arc N_new->N_original is created with the v_cost and v_reverse_cost
    FOR v_record IN
	    SELECT n.graph_delimiter AS n_graph_delimiter, n.node_id, a.graph_delimiter AS a_graph_delimiter, a.pgr_arc_id, a.arc_id, a.pgr_node_2, a.node_2
	    FROM temp_pgr_node n
	    JOIN temp_pgr_arc a ON n.pgr_node_id = a.pgr_node_2
	    WHERE n.modif AND a.modif2
    LOOP
	    INSERT INTO temp_pgr_node (old_node_id, modif, graph_delimiter) VALUES (v_record.node_id, FALSE, v_record.n_graph_delimiter);
        SELECT LAST_VALUE INTO v_pgr_node_id FROM temp_pgr_node_pgr_node_id_seq;
	    UPDATE temp_pgr_arc SET pgr_node_2 = v_pgr_node_id, node_2 = NULL
	    WHERE pgr_arc_id = v_record.pgr_arc_id;
	    INSERT INTO temp_pgr_arc(old_arc_id, pgr_node_1, pgr_node_2, node_2, graph_delimiter, cost, reverse_cost)
	    VALUES (v_record.arc_id, v_pgr_node_id, v_record.pgr_node_2, v_record.node_2,
        CASE WHEN v_record.a_graph_delimiter = 'NONE' THEN v_record.n_graph_delimiter ELSE v_record.a_graph_delimiter END, v_cost, v_reverse_cost);
    END LOOP;

    IF v_project_type = 'WS' THEN
        UPDATE temp_pgr_arc t
        SET closed = n.closed, broken = n.broken, to_arc = n.to_arc
        FROM temp_pgr_node n
        WHERE COALESCE(t.node_1, t.node_2) = n.node_id
        AND t.arc_id IS NULL;

        UPDATE temp_pgr_node t
        SET closed = n.closed, broken = n.broken, to_arc = n.to_arc
        FROM temp_pgr_node n
        WHERE t.old_node_id = n.node_id
        AND t.node_id IS NULL;

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
        END IF;

        -- for v_graph_delimiter - only the inlet arcs
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
