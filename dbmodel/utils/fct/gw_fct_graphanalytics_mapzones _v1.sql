/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this have been received helpfull assistance from Claudia Dragoste (Aigues de Manresa, S.A.)

--FUNCTION CODE: 2710

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_mapzones_v1(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_mapzones_v1(p_data json)
RETURNS json AS
$BODY$

/* Example usage:

-- QUERY SAMPLE
SELECT gw_fct_graphanalytics_mapzones('
{
	"data":{
		"parameters":{
			"graphClass":"DRAINZONE",
			"exploitation":[1],
			"macroExploitation":[1],
			"commitChanges":true,
			"updateMapZone":2,
			"geomParamUpdate":15,
			"usePlanPsector":false,
			"forceOpen":[1,2,3],
			"forceClosed":[2,3,4]
		}
	}
}');
SELECT gw_fct_graphanalytics_mapzones('
{
	"data":{
		"parameters":{
			"graphClass":"PRESSZONE",
			"exploitation":[1,2],
			"commitChanges":true,
			"updateMapZone":2,
			"geomParamUpdate":15,
			"usePlanPsector":false
		}
	}
}');

Query to visualize arcs with their geometries:

SELECT p.*, a.the_geom
FROM temp_pgr_arc p JOIN arc a ON p.arc_id = a.arc_id
WHERE p.pgr_arc_id = p.arc_id::INT;

Query to visualize nodes with their geometries:

SELECT p.*, n.the_geom FROM temp_pgr_node p
JOIN node n ON p.node_id = n.node_id
WHERE p.pgr_node_id = p.node_id::INT;

Query to calculate the factor for adding/subtracting flow in a DMA:

SELECT a.zone_id AS dma_id, d.name, d.descript, n.zone_id AS node_zone_id,
CASE WHEN n.zone_id = a.zone_id THEN 1 ELSE -1 END AS flow_sign, n.node_id
FROM temp_pgr_node n
JOIN temp_pgr_arc a ON n.node_id IN (a.node_1, a.node_2)
JOIN dma d ON d.dma_id = a.zone_id::INT
WHERE n.graph_delimiter = 'dma' AND a.zone_id::INT > 0 AND a.pgr_arc_id = a.arc_id::INT AND n.pgr_node_id = n.node_id::INT
ORDER BY a.zone_id, n.zone_id;
*/

DECLARE

	v_data JSON;
    v_query TEXT;
    v_return_text TEXT;
    v_mapzone_name TEXT;
    v_mapzone_field TEXT;
    pgr_root_vids INT[];
    pgr_distance INTEGER;
    v_project_type TEXT;

	v_graph_class TEXT;
	v_exploitation TEXT;
	v_macro_exploitation JSON;
	v_commit_changes BOOLEAN;
	v_update_map_zone INTEGER;
	v_geom_param_update FLOAT;
	v_use_plan_psector BOOLEAN;
	v_force_open JSON;
	v_force_closed JSON;


BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    -- Geometry is not saved; join with the node table to recover it for results

	-- Dialog parameters (JSON)
	v_graph_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'graphClass');
	v_exploitation = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_macro_exploitation = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'macroExploitation');
	v_commit_changes = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges');
	v_update_map_zone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geom_param_update = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_use_plan_psector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector');
	v_force_open = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'forceOpen');
	v_force_closed = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'forceClosed');

	-- json_array_elements_text((v_force_open)::json)
	-- json_array_elements_text((v_force_closed)::json)

	-- v_floodonlymapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'floodOnlyMapzone');
	-- v_valuefordisconnected = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'valueForDisconnected');
	-- v_parameters = (SELECT ((p_data::json->>'data')::json->>'parameters'));
	-- v_checkdata = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'checkData');
	-- v_dscenario_valve = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'dscenario_valve');
	-- v_netscenario = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'netscenario');

	-- select system values
	SELECT upper(project_type) INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Create temporary tables
	-- =======================
	v_data := '{"data":{"fct_name":"MAPZONES"}}';
	PERFORM gw_fct_graphanalytics_temptables(v_data);

	-- Initialize process
	-- =======================
	v_data := '{"data":{"expl_id":"' || v_expl || '"}}';
    PERFORM gw_fct_graphanalytics_initnetwork(v_data);

    IF v_project_type = 'WS' THEN
        -- Closed valves: all, those that are MINSECTOR, and those that are not
        UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = 'closed_valve'
        FROM man_valve v
        WHERE n.node_id = v.node_id AND v.closed = TRUE;

        -- One of the two arcs connected to closed valves
        UPDATE temp_pgr_arc a SET modif = TRUE, cost = -1, reverse_cost = -1
        FROM
        (SELECT DISTINCT ON (n.node_id) n.node_id, a.arc_id
        FROM temp_pgr_node n
        JOIN temp_pgr_arc a ON n.node_id IN (a.node_1, a.node_2)
        WHERE n.graph_delimiter = 'closed_valve'
        ) s
        WHERE a.arc_id = s.arc_id;

        -- Valves with to_arc
        UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = 'to_arc_valve'
        FROM man_valve v
        WHERE n.node_id = v.node_id AND v.to_arc IS NOT NULL AND v.active = TRUE AND (v.closed IS NULL OR v.closed = FALSE);

        -- The arc that is the to_arc
        UPDATE temp_pgr_arc a SET modif = TRUE, cost = -1, reverse_cost = -1
        FROM man_valve v
        WHERE v.node_id IN (a.node_1, a.node_2) AND v.to_arc IS NOT NULL AND v.active = TRUE AND (v.closed IS NULL OR v.closed = FALSE);


    END IF;

    -- Mapzone
	v_mapzone_name = v_graph_class;
    v_mapzone_field = v_mapzone_name || '_id';

    -- Nodes forceClosed
    v_query =
    'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''forceClosed'' 
    FROM 
    (SELECT json_array_elements_text((graphconfig->>''forceClosed'')::json) AS node_id
    FROM ' || v_mapzone_name || ' WHERE graphconfig IS NOT NULL AND active IS TRUE ) s 
    WHERE n.node_id = s.node_id';
    EXECUTE v_query;

	-- TODO('tornar a executar amb els parametres del forceClosed')
	v_query =
    'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''forceClosed'' 
    FROM 
    (SELECT unnest('|| v_forceClosed ||') AS node_id;) s 
    WHERE n.node_id = s.node_id';
    EXECUTE v_query;

    -- Arcs forceClosed - all connected to forceClosed nodes
    v_query =
    'UPDATE temp_pgr_arc a SET modif = TRUE, cost = -1, reverse_cost = -1 
    FROM temp_pgr_node n
    WHERE n.node_id IN (a.node_1, a.node_2) AND n.graph_delimiter = ''forceClosed''';
    EXECUTE v_query;


    -- Nodes as mapzone origins
    v_query =
    'UPDATE temp_pgr_node n SET modif = TRUE, graph_delimiter = ''' || v_mapzone_name || ''', zone_id = ' || v_mapzone_field ||
    '::TEXT FROM 
    (SELECT ' || v_mapzone_field || '::TEXT, (json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'' AS node_id
    FROM ' || v_mapzone_name || ' WHERE graphconfig IS NOT NULL AND active IS TRUE
    ) AS s 
    WHERE s.node_id <> '''' AND n.node_id = s.node_id';
    EXECUTE v_query;

    -- Disconnect InletArcs (those that are not to_arc)

    v_query =
    'UPDATE temp_pgr_arc a SET modif = TRUE, cost = -1, reverse_cost = -1
    FROM
    (SELECT a.arc_id, n.node_id
    FROM temp_pgr_node n
    JOIN temp_pgr_arc a ON n.node_id IN (a.node_1, a.node_2) AND n.graph_delimiter = ''' || v_mapzone_name || '''
    LEFT JOIN 
    (SELECT json_array_elements_text(((json_array_elements_text((graphconfig->>''use'')::json))::json->>''toArc'')::json) AS to_arc
    FROM ' || v_mapzone_name || ' WHERE graphconfig IS NOT NULL AND active IS TRUE
    ) sa ON sa.to_arc = a.arc_id
    WHERE sa.to_arc IS NULL
    ) s
    WHERE a.arc_id = s.arc_id';
    EXECUTE v_query;

    -- Nodes "ignore", should not be disconnected

	-- TODO('afegir els parametres del forceOpen')

    v_query =
    'UPDATE temp_pgr_node n SET modif = FALSE, graph_delimiter = ''ignore'' 
    FROM 
    (SELECT json_array_elements_text((graphconfig->>''ignore'')::json) AS node_id
    FROM ' || v_mapzone_name || ' WHERE graphconfig IS NOT NULL AND active IS TRUE ) s 
    WHERE n.node_id = s.node_id';
    EXECUTE v_query;

	v_query =
	'';
	EXECUTE v_query;


    -- Start the process of generating new arcs

    v_return_text = amsa_fct_pgr_preparar_xarxa();

    -- Update cost/reverse_cost of to_arc_valve with correct values
    -- Note: When a.graph_delimiter is not null, node_1 = node_2; these are the new arcs generated in nodes

    IF v_project_type = 'WS' THEN
        UPDATE temp_pgr_arc a SET cost = 1
        WHERE a.graph_delimiter = 'to_arc_valve' AND pgr_node_1 = node_1::INT;

        UPDATE temp_pgr_arc a SET reverse_cost = 1
        WHERE a.graph_delimiter = 'to_arc_valve' AND pgr_node_2 = node_2::INT;
    END IF;

    EXECUTE 'SELECT COUNT(*)::INT FROM temp_pgr_arc'
    INTO pgr_distance;
    EXECUTE 'SELECT array_agg(pgr_node_id)::INT[] FROM temp_pgr_node WHERE graph_delimiter = ''' || v_mapzone_name || ''' AND pgr_node_id = node_id::INT'
    INTO pgr_root_vids;

    -- Execute pgr_drivingDistance
    TRUNCATE temp_pgr_drivingdistance;
    v_query = 'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost, reverse_cost FROM temp_pgr_arc a';
    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
    (SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost FROM pgr_drivingdistance(v_query, pgr_root_vids, pgr_distance));

    -- Update zone_id

    -- Update nodes with mapzone conflicts; nodes that are heads of conflicting mapzones are overwritten

    UPDATE temp_pgr_node n SET zone_id = '-1'
    FROM
    (SELECT d.node, array_agg(DISTINCT n.zone_id)::INT[] AS maps
    FROM temp_pgr_drivingdistance d
    JOIN temp_pgr_node n ON d.start_vid = n.pgr_node_id
    GROUP BY d.node
    HAVING COUNT(DISTINCT n.zone_id) > 1) AS s
    WHERE n.pgr_node_id = s.node;

    -- Update nodes with a single mapzone

    UPDATE temp_pgr_node n SET zone_id = s.zone_id
    FROM
    (SELECT d.node, n.zone_id
    FROM temp_pgr_drivingdistance d
    JOIN temp_pgr_node n ON d.start_vid = n.pgr_node_id
    ) AS s
    WHERE n.pgr_node_id = s.node AND n.zone_id = '0';

    -- Update arcs

    UPDATE temp_pgr_arc a SET zone_id = n.zone_id
    FROM
    temp_pgr_node n
    WHERE (a.pgr_node_1 = n.pgr_node_id AND a.cost >= 0) OR (a.pgr_node_2 = n.pgr_node_id AND reverse_cost >= 0);

    -- Now set zone_id to '0' for nodes connecting arcs with different zone_ids
    -- Note: if a closed valve, for example, is between sector 2 and sector 3, it acts as a boundary and will have '0' as zone_id; if it is between -1 and 2 it will also be '0';
    -- however, if a closed valve is between arcs with the same sector, it keeps it; if it is between 1 and 1, it keeps 1, meaning it does not act as a boundary; if it is between -1 and -1, it does not change, keeping Conflict

    -- Set zone_id to '0' for boundary nodes of mapzones

    UPDATE temp_pgr_node n SET zone_id = '0'
    FROM
    (SELECT node_id, COUNT(DISTINCT zone_id)
    FROM temp_pgr_node
    GROUP BY node_id
    HAVING COUNT(DISTINCT zone_id) > 1) s
    WHERE n.node_id = s.node_id;

    -- Connecs take the zone_id of the arc they are associated with, and link takes the zone_id of the gully

    UPDATE temp_pgr_connec c SET zone_id = a.zone_id
    FROM temp_pgr_arc a
    WHERE c.arc_id::INT = a.pgr_arc_id AND a.zone_id <> '0';

    UPDATE temp_pgr_link l SET zone_id = c.zone_id
    FROM temp_pgr_connec c
    WHERE l.feature_id = c.connec_id AND l.feature_type = 'CONNEC' AND c.zone_id <> '0';

    -- For drainage, gullies take the zone_id of the arc they are associated with, and link takes the zone_id of the gully
    IF v_project_type = 'ud' THEN
        UPDATE amsa_pgr_gully g SET zone_id = a.zone_id
        FROM temp_pgr_arc a
        WHERE g.arc_id::INT = a.pgr_arc_id AND a.zone_id <> '0';

        UPDATE temp_pgr_link l SET zone_id = g.zone_id
        FROM amsa_pgr_gully g
        WHERE l.feature_id = g.gully_id AND l.feature_type = 'GULLY' AND g.zone_id <> '0';
    END IF;

    v_return_text = CONCAT('OK: ', UPPER(v_mapzone_name));

    RETURN v_return_text;

	--  Return
	-- RETURN  gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
    --          ',"body":{"form":{}, "data":{"graphClass": "'||v_class||'", "netscenarioId": "'||v_netscenario||'", "hasConflicts": '||v_has_conflicts||', "info":'||v_result_info||','||
	-- 				  '"point":'||v_result_point||','||
	-- 				  '"line":'||v_result_line||','||
	-- 				  '"polygon":'||v_result_polygon||'}'||'}}')::json, 2710, null, ('{"visible": ['||v_visible_layer||']}')::json, null)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

