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

/*
SELECT SCHEMA_NAME.gw_fct_grafanalytics_macrominsector('{"data":{"parameters":{"commitChanges":true}}}');
*/

DECLARE

    v_version TEXT;
    v_project_type TEXT;
    v_commitchanges BOOLEAN;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

    -- TODO: use this variable to commit changes or not
    v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges');

    UPDATE node SET macrominsector_id = 0;
    UPDATE arc SET macrominsector_id = 0;
    UPDATE connec SET macrominsector_id = 0;

    UPDATE node n SET macrominsector_id = c.component
    FROM (
        SELECT seq, component, node
        FROM pgr_connectedcomponents('
            SELECT arc_id::int AS id, node_1::int AS source, node_2::int AS target, 1 AS cost 
            FROM arc WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND state = 1
        ')
    ) c
    WHERE n.node_id::int = c.node;

    UPDATE arc a SET macrominsector_id = n.macrominsector_id
    FROM (SELECT node_id, macrominsector_id FROM node) n
    WHERE a.node_2 = n.node_id AND n.macrominsector_id <> 0 AND a.state = 1;

    UPDATE connec c SET macrominsector_id = a.macrominsector_id
    FROM (SELECT arc_id, macrominsector_id FROM arc) a
    WHERE c.arc_id = a.arc_id AND a.macrominsector_id <> 0;

    IF v_project_type = 'UD' THEN
        UPDATE gully g SET macrominsector_id = a.macrominsector_id
        FROM (SELECT arc_id, macrominsector_id FROM arc) a
        WHERE g.arc_id = a.arc_id AND a.macrominsector_id <> 0;
    END IF;

    RETURN gw_fct_json_create_return(
        ('{"status":"Accepted", "message":{"level":1, "text":"Macrominsector analysis done successfully"}, "version":"' || v_version || '"' ||
        ',"body":{"form":{}' ||
        '}' ||
        '}')::json, 3334, NULL, NULL, NULL
    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;