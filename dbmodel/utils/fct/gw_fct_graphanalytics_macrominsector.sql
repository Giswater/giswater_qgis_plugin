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
    SELECT SCHEMA_NAME.gw_fct_graphanalytics_macrominsector('{"data":{"parameters":{}}}');
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
            FROM arc 
            WHERE state = 1  
            AND node_1 IS NOT NULL AND node_2 IS NOT NULL
            UNION ALL
            SELECT a.arc_id::int AS id, a.node_1::int AS source, a.node_2::int AS target, 1 AS cost 
            FROM arc a 
            JOIN plan_psector_x_arc pa ON pa.arc_id = a.arc_id 
            JOIN plan_psector p ON p.psector_id = pa.psector_id 
            WHERE p.active = TRUE AND a.state = 2
            AND a.node_1 IS NOT NULL AND a.node_2 IS NOT NULL
        ') c
    WHERE n.node_id::int = c.node;

    WITH selected_arcs AS 
    (SELECT arc_id, node_1
    FROM arc 
    WHERE state = 1  
    AND node_1 IS NOT NULL AND node_2 IS NOT NULL
    UNION ALL
    SELECT a.arc_id, a.node_1
    FROM arc a 
    JOIN plan_psector_x_arc pa ON pa.arc_id = a.arc_id 
    JOIN plan_psector p ON p.psector_id = pa.psector_id 
    WHERE p.active = TRUE AND a.state = 2
    AND a.node_1 IS NOT NULL AND a.node_2 IS NOT NULL
    )
    UPDATE arc a SET macrominsector_id =n.macrominsector_id
    FROM selected_arcs sa 
    JOIN node n ON sa.node_1 = n.node_id 
    WHERE a.arc_id = sa.arc_id AND n.macrominsector_id <> 0
    ;

    WITH selected_connec AS 
    (SELECT connec_id, arc_id
    FROM connec 
    WHERE state = 1  
    UNION ALL
    SELECT c.connec_id, c.arc_id
    FROM connec c 
    JOIN plan_psector_x_connec pc ON pc.connec_id = c.connec_id 
    JOIN plan_psector p ON p.psector_id = pc.psector_id 
    WHERE p.active = TRUE AND c.state = 2
    )
    UPDATE connec c SET macrominsector_id = a.macrominsector_id
    FROM selected_connec sa 
    JOIN arc a ON sa.arc_id = a.arc_id
    WHERE c.connec_id = sa.connec_id AND a.macrominsector_id <> 0
    ;

    WITH selected_link AS 
    (SELECT l.link_id, c.arc_id
    FROM link l
    JOIN connec c ON l.feature_id = c.connec_id 
    WHERE l.state = 1 AND l.feature_type = 'CONNEC' 
    UNION ALL
    SELECT l.link_id, pc.arc_id
    FROM link l 
    JOIN plan_psector_x_connec pc ON pc.link_id = l.link_id 
    JOIN plan_psector p ON p.psector_id = pc.psector_id 
    WHERE p.active = TRUE AND l.state = 2 AND l.feature_type = 'CONNEC'
    )
    UPDATE link l SET macrominsector_id = a.macrominsector_id
    FROM selected_link sa 
    JOIN arc a ON sa.arc_id = a.arc_id
    WHERE l.link_id = sa.link_id AND a.macrominsector_id <> 0
    ;

    IF v_project_type = 'UD' THEN
        WITH selected_gully AS 
        (SELECT gully_id, arc_id
        FROM gully 
        WHERE state = 1  
        UNION ALL
        SELECT c.gully_id, c.arc_id
        FROM gully c 
        JOIN plan_psector_x_gully pc ON pc.gully_id = c.gully_id 
        JOIN plan_psector p ON p.psector_id = pc.psector_id 
        WHERE p.active = TRUE AND c.state = 2
        )
        UPDATE gully c SET macrominsector_id = a.macrominsector_id
        FROM selected_gully sa 
        JOIN arc a ON sa.arc_id = a.arc_id
        WHERE c.gully_id = sa.gully_id AND a.macrominsector_id <> 0
        ;

        WITH selected_link AS 
        (SELECT l.link_id, c.arc_id
        FROM link l
        JOIN gully c ON l.feature_id = c.gully_id 
        WHERE l.state = 1 AND l.feature_type = 'GULLY' 
        UNION ALL
        SELECT l.link_id, pc.arc_id
        FROM link l 
        JOIN plan_psector_x_gully pc ON pc.link_id = l.link_id 
        JOIN plan_psector p ON p.psector_id = pc.psector_id 
        WHERE p.active = TRUE AND l.state = 2 AND l.feature_type = 'GULLY'
        )
        UPDATE link l SET macrominsector_id = a.macrominsector_id
        FROM selected_link sa 
        JOIN arc a ON sa.arc_id = a.arc_id
        WHERE l.link_id = sa.link_id AND a.macrominsector_id <> 0
        ;
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