/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

The code of this inundation function has been provided by Claudia Dragoste (Aigues de Manresa, S.A.)
*/

-- FUNCTION CODE: 3326

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_arrangenetwork();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_arrangenetwork()
RETURNS json AS
$BODY$

/* Example:
SELECT gw_fct_graphanalytics_arrangenetwork();
It is an auxiliary process used by macro_minsector, minsector, or mapzone that generates additional arcs.
*/

DECLARE

	v_version TEXT;
    v_record RECORD;
    v_pgr_node_id INTEGER;
    v_project_type text;
    v_cost integer=0; -- for the new arcs the cost/reverse_cost is 0 and not 1 so the inundation will be seen correct
    v_reverse_cost integer=0;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT UPPER(project_type) INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;
    IF v_project_type = 'UD' THEN v_cost = -1;
    END IF;

    -- Disconnect arcs with modif = TRUE at nodes with modif1 = TRUE; a new arc N_new->N_original is created with the v_cost and v_reverse_cost
    FOR v_record IN
	    SELECT n.graph_delimiter AS n_graph_delimiter, a.graph_delimiter AS a_graph_delimiter, a.pgr_arc_id, a.pgr_node_1, a.node_1
	    FROM temp_pgr_node n
	    JOIN temp_pgr_arc a ON n.pgr_node_id =a.pgr_node_1
	    WHERE n.modif AND a.modif1
    LOOP
	    INSERT INTO temp_pgr_node (modif, graph_delimiter) VALUES (FALSE, v_record.n_graph_delimiter);
        SELECT LAST_VALUE INTO v_pgr_node_id FROM temp_pgr_node_pgr_node_id_seq;
	    UPDATE temp_pgr_arc SET pgr_node_1 = v_pgr_node_id, node_1 = NULL
	    WHERE pgr_arc_id = v_record.pgr_arc_id;
	    INSERT INTO temp_pgr_arc (pgr_node_1, pgr_node_2, node_1, graph_delimiter, cost, reverse_cost)
	    VALUES (v_record.pgr_node_1, v_pgr_node_id, v_record.node_1,
        CASE WHEN v_record.a_graph_delimiter = 'none' THEN v_record.n_graph_delimiter ELSE v_record.a_graph_delimiter END, v_cost, v_reverse_cost);
    END LOOP;

    -- Disconnect arcs with modif = TRUE at nodes with modif2 = TRUE; a new arc N_new->N_original is created with the v_cost and v_reverse_cost
    FOR v_record IN
	    SELECT n.graph_delimiter AS n_graph_delimiter, a.graph_delimiter AS a_graph_delimiter, a.pgr_arc_id, a.pgr_node_2, a.node_2
	    FROM temp_pgr_node n
	    JOIN temp_pgr_arc a ON n.pgr_node_id = a.pgr_node_2
	    WHERE n.modif AND a.modif2
    LOOP
	    INSERT INTO temp_pgr_node(modif, graph_delimiter) VALUES (FALSE, v_record.n_graph_delimiter);
        SELECT LAST_VALUE INTO v_pgr_node_id FROM temp_pgr_node_pgr_node_id_seq;
	    UPDATE temp_pgr_arc SET pgr_node_2 = v_pgr_node_id, node_2 = NULL
	    WHERE pgr_arc_id = v_record.pgr_arc_id;
	    INSERT INTO temp_pgr_arc(pgr_node_1, pgr_node_2, node_2, graph_delimiter, cost, reverse_cost)
	    VALUES (v_pgr_node_id, v_record.pgr_node_2, v_record.node_2,
        CASE WHEN v_record.a_graph_delimiter = 'none' THEN v_record.n_graph_delimiter ELSE v_record.a_graph_delimiter END, v_cost, v_reverse_cost);
    END LOOP;

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
