/*
This file is part of Giswater 3
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
    v_id INTEGER = 0;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values

    SELECT LAST_VALUE into v_id FROM urn_id_seq;

    -- Disconnect arcs with modif = TRUE at nodes with modif1 = TRUE; a new arc N_new->N_original is created with the cost and reverse cost -1, -1
    FOR v_record IN
	    SELECT n.pgr_node_id, n.graph_delimiter AS n_graph_delimiter, a.graph_delimiter AS a_graph_delimiter, a.pgr_arc_id, a.pgr_node_1, a.modif1
	    FROM temp_pgr_node n
	    JOIN temp_pgr_arc a ON n.pgr_node_id =a.pgr_node_1
	    WHERE n.modif AND a.modif1
    LOOP
	    v_id = v_id + 2;
	    INSERT INTO temp_pgr_node (pgr_node_id, node_id, modif, graph_delimiter) VALUES (v_id, v_record.pgr_node_id::TEXT, FALSE, v_record.n_graph_delimiter);
	    UPDATE temp_pgr_arc SET pgr_node_1 = v_id
	    WHERE pgr_arc_id = v_record.pgr_arc_id;
	    INSERT INTO temp_pgr_arc (pgr_arc_id, arc_id, pgr_node_1, pgr_node_2, node_1, node_2, graph_delimiter, cost, reverse_cost)
	    VALUES (v_id + 1, v_record.pgr_arc_id::TEXT, v_record.pgr_node_id, v_id, v_record.pgr_node_id, v_record.pgr_node_id,
        CASE WHEN v_record.a_graph_delimiter = 'none' THEN v_record.n_graph_delimiter ELSE v_record.a_graph_delimiter END, -1, -1);
    END LOOP;

    -- Disconnect arcs with modif = TRUE at nodes with modif2 = TRUE; a new arc N_new->N_original is created with the cost and reverse cost -1, -1
    FOR v_record IN
	    SELECT n.pgr_node_id, n.graph_delimiter AS n_graph_delimiter, a.graph_delimiter AS a_graph_delimiter, a.pgr_arc_id, a.pgr_node_2, a.modif2
	    FROM temp_pgr_node n
	    JOIN temp_pgr_arc a ON n.pgr_node_id = a.pgr_node_2
	    WHERE n.modif AND a.modif2
    LOOP
	    v_id = v_id + 2;
	    INSERT INTO temp_pgr_node(pgr_node_id, node_id, modif, graph_delimiter) VALUES (v_id, v_record.pgr_node_id::TEXT, FALSE, v_record.n_graph_delimiter);
	    UPDATE temp_pgr_arc SET pgr_node_2 = v_id
	    WHERE pgr_arc_id = v_record.pgr_arc_id;
	    INSERT INTO temp_pgr_arc(pgr_arc_id, arc_id, pgr_node_1, pgr_node_2, node_1, node_2, graph_delimiter, cost, reverse_cost)
	    VALUES (v_id + 1, v_record.pgr_arc_id::TEXT, v_id, v_record.pgr_node_id, v_record.pgr_node_id, v_record.pgr_node_id,
        CASE WHEN v_record.a_graph_delimiter = 'none' THEN v_record.n_graph_delimiter ELSE v_record.a_graph_delimiter END, -1, -1);
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
