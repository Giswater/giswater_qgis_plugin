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

SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"-901"}}'); -- For all user selected exploitations
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"-902"}}'); -- For all exploitations
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"0"}}'); -- For exploitations 0
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"1"}}'); -- For exploitation 1
SELECT SCHEMA_NAME.gw_fct_graphanalytics_initnetwork('{"data":{"expl_id":"2"}}'); -- For exploitation 2

It is an auxiliary process used by macro_minsector, minsector, or mapzone that generates the tables temp_pgr_node and temp_pgr_arc.
*/

DECLARE

	v_version TEXT;
    v_project_type TEXT;
    v_expl_id TEXT;
    v_macrominsector_id_node TEXT;
    v_macrominsector_id_arc TEXT;
    v_macrominsector_id_connec TEXT;
    v_macrominsector_id_gully TEXT;
    v_cost INTEGER = 1;
    v_reverse_cost INTEGER = 1;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT giswater, UPPER(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get variables from input JSON
    v_expl_id = (SELECT (p_data::json->>'data')::json->>'expl_id');

    IF v_project_type = 'UD' THEN v_reverse_cost = -1; END IF;

    -- For user selected exploitations
    IF v_expl_id = '-901' THEN
        SELECT string_agg(DISTINCT macrominsector_id::TEXT, ',') INTO v_macrominsector_id_arc
        FROM v_edit_arc a
        WHERE a.minsector_id <> '0'
        AND a.macrominsector_id <> '0';
    -- For all exploitations
    ELSIF v_expl_id = '-902' THEN
        SELECT string_agg(DISTINCT macrominsector_id::TEXT, ',') INTO v_macrominsector_id_arc
        FROM arc a
        WHERE a.minsector_id <> '0'
        AND a.macrominsector_id <> '0';
    -- For a specific exploitation/s
    ELSE
        SELECT string_agg(DISTINCT macrominsector_id::TEXT, ',') INTO v_macrominsector_id_arc
        FROM arc a
        WHERE a.minsector_id <> '0'
        AND a.macrominsector_id <> '0'
        AND a.expl_id::TEXT = ANY(string_to_array(v_expl_id, ','));
    END IF;

    INSERT INTO temp_pgr_arc (pgr_arc_id, arc_id, pgr_node_1, pgr_node_2, node_1, node_2, cost, reverse_cost)
    (
        SELECT a.arc_id::INT, a.arc_id, a.node_1::INT, a.node_2::INT, a.node_1, a.node_2, v_cost, v_reverse_cost
        FROM arc a
        JOIN value_state_type s ON s.id = a.state_type
        WHERE a.state = 1 AND s.is_operative = TRUE
        AND a.node_1 IS NOT NULL AND a.node_2 IS NOT NULL -- Avoids the crash of pgrouting functions
        AND a.macrominsector_id::TEXT = ANY(string_to_array(v_macrominsector_id_arc, ','))
    );

    -- TODO: add macrominsector_id 0 with the logic of the exploitation (to catch isolated nodes)
    INSERT INTO temp_pgr_node (pgr_node_id, node_id)
    (
        SELECT DISTINCT node_id::INT, node_id
        FROM node n
        JOIN temp_pgr_arc a ON n.node_id IN (a.node_1, a.node_2)
        JOIN value_state_type s ON s.id = n.state_type
        WHERE n.state = 1 AND s.is_operative = TRUE
    );

    INSERT INTO temp_pgr_connec (connec_id, arc_id)
    (
        SELECT c.connec_id, c.arc_id
        FROM connec c
        JOIN temp_pgr_arc a ON c.arc_id = a.arc_id
        JOIN value_state_type s ON s.id = c.state_type
        WHERE c.state = 1 AND s.is_operative = TRUE
    );

    INSERT INTO temp_pgr_link (link_id, feature_id, feature_type)
    (
        SELECT link_id, feature_id, feature_type
        FROM link l
        JOIN temp_pgr_connec c ON l.feature_id=c.connec_id
        WHERE l.state = 1 AND l.feature_type = 'CONNEC'
    );

    IF v_project_type = 'UD' THEN
        INSERT INTO temp_pgr_gully (gully_id, arc_id)
        (
            SELECT g.gully_id, g.arc_id
            FROM gully g
            JOIN temp_pgr_arc a ON g.arc_id = a.arc_id
            JOIN value_state_type s ON s.id = g.state_type
            WHERE g.state = 1 AND s.is_operative = TRUE
        );

        INSERT INTO temp_pgr_link (link_id, feature_id, feature_type)
        (
            SELECT link_id, feature_id, feature_type
            FROM link l
            JOIN temp_pgr_gully g ON l.feature_id = g.gully_id
            WHERE l.state = 1 AND l.feature_type = 'GULLY'
        );
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
