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
    v_expl_id_id TEXT;
    v_macrominsector_id_node TEXT;
    v_macrominsector_id_arc TEXT;
    v_macrominsector_id_connec TEXT;
    v_macrominsector_id_link TEXT;
    v_macrominsector_id_gully TEXT;
    v_cost INTEGER = 1;
    v_reverse_cost INTEGER = 1;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

    v_expl_id = (SELECT (p_data::json->>'data')::json->>'expl_id');

    IF v_expl_id = '-9' THEN
        SELECT string_agg(expl_id::TEXT, ',') INTO v_expl_id FROM exploitation;
    END IF;

    SELECT string_agg(DISTINCT macrominsector_id::TEXT, ',') INTO v_macrominsector_id_node FROM node n WHERE n.expl_id IN (v_expl_id);
    SELECT string_agg(DISTINCT macrominsector_id::TEXT, ',') INTO v_macrominsector_id_arc FROM arc a WHERE a.expl_id IN (v_expl_id);
    SELECT string_agg(DISTINCT macrominsector_id::TEXT, ',') INTO v_macrominsector_id_connec FROM connec c WHERE c.expl_id IN (v_expl_id);
    SELECT string_agg(DISTINCT macrominsector_id::TEXT, ',') INTO v_macrominsector_id_link FROM link l WHERE l.expl_id IN (v_expl_id);

    IF v_project_type = 'UD' THEN
        v_reverse_cost = -1;
        SELECT string_agg(DISTINCT macrominsector_id::TEXT, ',') INTO v_macrominsector_id_gully FROM gully g WHERE g.expl_id IN (v_expl_id);
    END IF;

    INSERT INTO temp_pgr_node (pgr_node_id, node_id)
    (
        SELECT node_id::INT, node_id
        FROM
        (
            SELECT node_id, state, state_type, macrominsector_id FROM node
        ) n
        JOIN value_state_type s ON s.id = n.state_type
        WHERE n.state = 1 AND s.is_operative = TRUE
        AND n.macrominsector_id IN (v_macrominsector_id_node)
    );

    INSERT INTO temp_pgr_arc (pgr_arc_id, arc_id, pgr_node_1, pgr_node_2, node_1, node_2, cost, reverse_cost, the_geom)
    (
        SELECT a.arc_id::INT, a.arc_id, a.node_1::INT, a.node_2::INT, a.node_1, a.node_2, v_cost, v_reverse_cost, a.the_geom
        FROM arc a
        JOIN value_state_type s ON s.id = a.state_type
        WHERE a.state = 1 AND s.is_operative = TRUE
        AND a.node_1 IS NOT NULL AND a.node_2 IS NOT NULL -- Avoids the crash of pgrouting functions
        AND a.macrominsector_id IN (v_macrominsector_id_arc)
    );

    INSERT INTO temp_pgr_connec (connec_id, arc_id, the_geom)
    (
        SELECT c.connec_id, c.arc_id, c.the_geom
        FROM
        (
            SELECT connec_id, arc_id, state, state_type, the_geom FROM connec
        ) c
        JOIN temp_pgr_arc a ON c.arc_id::INT = a.pgr_arc_id
        JOIN value_state_type s ON s.id = c.state_type
        WHERE c.state = 1 AND s.is_operative = TRUE
        AND c.macrominsector_id IN (v_macrominsector_id_connec)
    );

    INSERT INTO temp_pgr_link (link_id, feature_id, feature_type, the_geom)
    (
        SELECT link_id, feature_id, feature_type, the_geom
        FROM
        (
            SELECT link_id, feature_id, feature_type, state, the_geom FROM link
        ) l
        JOIN temp_pgr_connec c ON l.feature_id=c.connec_id
        WHERE l.state = 1 AND l.feature_type = 'CONNEC'
        AND l.macrominsector_id IN (v_macrominsector_id_link)
    );

    IF v_project_type = 'UD' THEN
        INSERT INTO temp_pgr_gully (gully_id, arc_id, the_geom)
        (
            SELECT g.gully_id, g.arc_id, g.the_geom
            FROM (
                SELECT gully_id, arc_id, state, state_type, the_geom FROM gully
            ) g
            JOIN temp_pgr_arc a ON g.arc_id::INT = a.pgr_arc_id
            JOIN value_state_type s ON s.id = g.state_type
            WHERE g.state = 1 AND s.is_operative = TRUE
            AND g.macrominsector_id IN (v_macrominsector_id_gully)
        );

        INSERT INTO temp_pgr_link (link_id, feature_id, feature_type, the_geom)
        (
            SELECT link_id, feature_id, feature_type, the_geom
            FROM (
                SELECT link_id, feature_id, feature_type, state, the_geom FROM link
            ) l
            JOIN temp_pgr_gully g ON l.feature_id = g.gully_id
            WHERE l.state = 1 AND l.feature_type = 'GULLY'
            AND l.macrominsector_id IN (v_macrominsector_id_link)
        );
    END IF;

	RETURN ('{"status":"Accepted"}')::JSON;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
