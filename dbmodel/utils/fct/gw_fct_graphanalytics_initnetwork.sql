/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

The code of this inundation function has been provided by Claudia Dragoste (Aigues de Manresa, S.A.)
*/

-- FUNCTION CODE: 3328

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_initnetwork(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_initnetwork(p_data json)
RETURNS json AS
$BODY$

/* Example:

SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"-9"}}'); -- For all explotations
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"1,2"}}'); -- For explotations 1 and 2
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"2"}}'); -- For explotation 2

It is an auxiliary process used by macro_minsector, minsector, or mapzone that generates the tables temp_pgr_node and temp_pgr_arc.
*/

DECLARE

    v_project_type TEXT;
    v_expl_id TEXT; -- -9 for all explotations
    v_cost INTEGER = 1;
    v_reverse_cost INTEGER = 1;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    EXECUTE 'SELECT LOWER(project_type) FROM sys_version ORDER BY "date" DESC LIMIT 1' INTO v_project_type;

    v_expl = (SELECT (p_data::json->>'data')::json->>'expl_id');

    IF v_project_type = 'ud' THEN
        v_reverse_cost = -1;
    END IF;

    IF v_expl = '-9' THEN
        v_expl = (SELECT string_agg(expl_id::TEXT, ',') FROM exploitation);
    END IF;

    INSERT INTO temp_pgr_node (pgr_node_id, node_id)
    (
        SELECT node_id::INT, node_id
        FROM
        (
            SELECT node_id, state, state_type FROM node
        ) n
        JOIN value_state_type s ON s.id = n.state_type
        WHERE n.state = 1 AND s.is_operative = TRUE
        AND n.expl_id IN (v_expl)
    );

    INSERT INTO temp_pgr_arc (pgr_arc_id, arc_id, pgr_node_1, pgr_node_2, node_1, node_2, cost, reverse_cost, the_geom)
    (
        SELECT a.arc_id::INT, a.arc_id, a.node_1::INT, a.node_2::INT, a.node_1, a.node_2, v_cost, v_reverse_cost, a.the_geom
        FROM arc a
        JOIN value_state_type s ON s.id = a.state_type
        WHERE a.state = 1 AND s.is_operative = TRUE
        AND a.node_1 IS NOT NULL AND a.node_2 IS NOT NULL -- Avoids the crash of pgrouting functions
        AND a.expl_id IN (v_expl)
    );

	RETURN ('{"status":"Accepted"}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
