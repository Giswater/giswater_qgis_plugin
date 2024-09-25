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

    v_record record;
    v_node_id integer = 0;
    v_arc_id integer = 0;
    v_id integer = 0;
    v_project_type text;
    v_cost integer=1;
    v_reverse_cost integer=1;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

	EXECUTE 'SELECT lower(project_type) FROM sys_version ORDER BY "date" DESC LIMIT 1' INTO v_project_type;
	IF v_project_type='ud' THEN v_reverse_cost=-1; END IF;

    EXECUTE 'SELECT MAX(pgr_node_id) FROM temp_pgr_node' INTO v_node_id;
    EXECUTE 'SELECT MAX(pgr_arc_id) FROM temp_pgr_arc' INTO v_arc_id;

    IF v_node_id > v_arc_id THEN
        v_id = v_node_id;
    ELSE
        v_id = v_arc_id;
    END IF;

    -- Disconnect arcs with modif=true at nodes with modif=true; a new arc N_new->N_original is created with the cost and reverse cost of the arc
    FOR v_record IN
        SELECT n.pgr_node_id, n.graph_delimiter as n_graph_delimiter, a.graph_delimiter as a_graph_delimiter, a.pgr_arc_id, a.pgr_node_1, a.pgr_node_2, a.cost, a.reverse_cost
        FROM temp_pgr_node n
        JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        WHERE n.modif = true AND a.modif = true
    LOOP
        v_id = v_id + 2;
        INSERT INTO temp_pgr_node(pgr_node_id, node_id, modif, graph_delimiter)
        VALUES (v_id, v_record.pgr_node_id::text, false, v_record.n_graph_delimiter);

        IF v_record.pgr_node_id = v_record.pgr_node_1 THEN
            UPDATE temp_pgr_arc SET pgr_node_1 = v_id
            WHERE pgr_arc_id = v_record.pgr_arc_id;

            INSERT INTO temp_pgr_arc(pgr_arc_id, arc_id, pgr_node_1, pgr_node_2, node_1, node_2, modif, graph_delimiter, cost, reverse_cost)
            VALUES (v_id + 1, v_record.pgr_arc_id::text, v_record.pgr_node_id, v_id, v_record.pgr_node_id, v_record.pgr_node_id, false, COALESCE(v_record.a_graph_delimiter,v_record.n_graph_delimiter), v_record.cost, v_record.reverse_cost);
        ELSE
            UPDATE temp_pgr_arc SET pgr_node_2 = v_id
            WHERE pgr_arc_id = v_record.pgr_arc_id;

            INSERT INTO temp_pgr_arc(pgr_arc_id, arc_id, pgr_node_1, pgr_node_2, node_1, node_2, modif, graph_delimiter, cost, reverse_cost)
            VALUES (v_id + 1, v_record.pgr_arc_id::text, v_id, v_record.pgr_node_id, v_record.pgr_node_id, v_record.pgr_node_id, false, COALESCE(v_record.a_graph_delimiter,v_record.n_graph_delimiter), v_record.cost, v_record.reverse_cost);
        END IF;

        UPDATE temp_pgr_arc SET cost = v_cost, reverse_cost = v_reverse_cost WHERE pgr_arc_id = v_record.pgr_arc_id; -- The new arc has the cost and reverse cost
    END LOOP;

	RETURN ('{"status":"Accepted"}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
