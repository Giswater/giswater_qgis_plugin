/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)
*/

-- FUNCTION CODE: 3336

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_macrominsector(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_macrominsector(p_data json)
RETURNS json AS
$BODY$

/* EXAMPLE OF CALL
    SELECT SCHEMA_NAME.gw_fct_grafanalytics_macrominsector('{"data":{"parameters":{}}}');
*/

DECLARE

    v_version TEXT;
    v_project_type TEXT;
    v_fid INTEGER = 532;
    v_result JSON;
    v_result_info JSON;


BEGIN

    SET search_path = "SCHEMA_NAME", public;

    SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

    CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

    -- Starting process
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MACROMINSECTOR DYNAMIC SECTORITZATION'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('---------------------------------------------------'));

    UPDATE node SET macrominsector_id = 0 WHERE macrominsector_id <> 0;
    UPDATE arc SET macrominsector_id = 0 WHERE macrominsector_id <> 0;
    UPDATE connec SET macrominsector_id = 0 WHERE macrominsector_id <> 0;
    UPDATE link SET macrominsector_id = 0 WHERE macrominsector_id <> 0;

    IF v_project_type = 'UD' THEN
        UPDATE gully SET macrominsector_id = 0 WHERE macrominsector_id <> 0;
    ELSIF v_project_type = 'WS' THEN
        UPDATE minsector_graph SET macrominsector_id = 0 WHERE macrominsector_id <> 0;
    END IF;


    UPDATE node n SET macrominsector_id = c.component
    FROM pgr_connectedcomponents('
            SELECT arc_id::int AS id, node_1::int AS source, node_2::int AS target, 1 AS cost 
            FROM arc WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND state = 1
        ') c
    WHERE n.node_id::int = c.node;

    UPDATE arc a SET macrominsector_id = n.macrominsector_id
    FROM node n
    WHERE a.node_2 = n.node_id AND n.macrominsector_id <> 0 AND a.state = 1;

    UPDATE connec c SET macrominsector_id = a.macrominsector_id
    FROM arc a
    WHERE c.arc_id = a.arc_id AND a.macrominsector_id <> 0 AND c.state = 1;


    UPDATE link l SET macrominsector_id = c.macrominsector_id
    FROM connec c
    WHERE c.connec_id = l.feature_id AND c.feature_type = 'CONNEC' AND c.macrominsector_id <> 0 AND l.state = 1;

    IF v_project_type = 'UD' THEN
        UPDATE gully g SET macrominsector_id = a.macrominsector_id
        FROM arc a
        WHERE g.arc_id = a.arc_id AND a.macrominsector_id <> 0 AND g.state = 1;

        UPDATE link l SET macrominsector_id = g.macrominsector_id
        FROM gully g
        WHERE g.gully_id = l.feature_id AND g.feature_type = 'GULLY' AND g.macrominsector_id <> 0 AND l.state = 1;
     ELSIF v_project_type = 'WS' THEN
        UPDATE minsector_graph m SET macrominsector_id = n.macrominsector_id
        FROM node n
        WHERE m.node_id = n.node_id AND n.macrominsector_id <> 0;
    END IF;

    -- Message
    INSERT INTO temp_audit_check_data (fid, error_message)
    VALUES (v_fid, CONCAT('INFO-', v_fid, ': Macrominsector attribute on arc/node/connec/gully features have been updated by this process'));


	-- Info
    SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
    FROM (
        SELECT id, error_message AS message FROM temp_audit_check_data WHERE cur_user = current_user AND fid = v_fid ORDER BY id
    ) row;
    v_result := COALESCE(v_result, '{}');
    v_result_info := CONCAT('{"geometryType":"", "values":', v_result, '}');

    DROP TABLE IF EXISTS temp_audit_check_data;

    RETURN  gw_fct_json_create_return(('{
        "status":"Accepted", 
        "message":{
            "level":1, 
            "text":"Macrominsector analysis done successfully"
        }, 
        "version":"'||v_version||'",
        "body":{
            "form":{},
            "data":{
                "info":'||v_result_info||',
                "point":{},
                "line":{},
                "polygon":{}
            }
        }
    }')::json, 3336, NULL, ('{"visible": ["'||NULL||'"]}')::json, NULL)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;