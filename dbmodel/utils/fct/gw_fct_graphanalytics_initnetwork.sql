/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

The code of this inundation function has been provided by Claudia Dragoste (Aigues de Manresa, S.A.)
*/

-- FUNCTION CODE: 3328

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_initnetwork();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_initnetwork()
RETURNS json
LANGUAGE plpgsql
AS $function$

/* Example:

SELECT SCHEMA_NAME.gw_fct_graphanalytics_minsector('{"data":{"parameters":{"exploitation":"[1,2]", "MaxMinsectors":0, "checkData": false, "usePsectors":"TRUE", "updateFeature":"TRUE", "updateMinsectorGeom":2 ,"geomParamUpdate":10}}}');

SELECT * FROM temp_pgr_node;
SELECT * FROM temp_pgr_arc;
SELECT * FROM temp_pgr_minsector;
SELECT * FROM temp_pgr_connectedcomponents;
SELECT * FROM temp_pgr_drivingdistance;

DROP TABLE IF EXISTS temp_pgr_node;
DROP TABLE IF EXISTS temp_pgr_arc;
DROP TABLE IF EXISTS temp_pgr_minsector;
DROP TABLE IF EXISTS temp_pgr_connectedcomponents;
DROP TABLE IF EXISTS temp_pgr_drivingdistance;

It is an auxiliary process used by macro_minsector, minsector, or mapzone that generates the tables temp_pgr_node and temp_pgr_arc.
*/

DECLARE

    v_project_type TEXT;
    v_cost INTEGER = 1;
    v_reverse_cost INTEGER = 1;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    EXECUTE 'SELECT LOWER(project_type) FROM sys_version ORDER BY "date" DESC LIMIT 1' INTO v_project_type;

    IF v_project_type = 'ud' THEN
        v_reverse_cost = -1;
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
    );

    INSERT INTO temp_pgr_arc (pgr_arc_id, arc_id, pgr_node_1, pgr_node_2, node_1, node_2, cost, reverse_cost, the_geom)
    (
        SELECT a.arc_id::INT, a.arc_id, a.node_1::INT, a.node_2::INT, a.node_1, a.node_2, v_cost, v_reverse_cost, a.the_geom
        FROM arc a
        JOIN value_state_type s ON s.id = a.state_type
        WHERE a.state = 1 AND s.is_operative = TRUE
        AND a.node_1 IS NOT NULL AND a.node_2 IS NOT NULL -- Avoids the crash of pgrouting functions
    );

	RETURN ('{"status":"Accepted"}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
