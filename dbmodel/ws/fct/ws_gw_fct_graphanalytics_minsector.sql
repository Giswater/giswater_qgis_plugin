/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

The code of this inundation function have been provided by Claudia Dragoste (Aigues de Manresa, S.A.)
*/

-- FUNCTION CODE: 2706

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_minsector(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_minsector(p_data json)
RETURNS json AS
$BODY$

/*
TO EXECUTE

SELECT SCHEMA_NAME.gw_fct_graphanalytics_minsector('{"data":{"parameters":{"commitChanges":true, "exploitation":"1,2", "updateFeature":"TRUE", "updateMapZone":2 ,"geomParamUpdate":4}}}');

--fid: 125,134


*/

DECLARE

    v_query TEXT;
    v_data JSON;
    v_hydrometer_service INT[];
    v_expl TEXT;
    v_fid INTEGER = 134;
    v_querytext TEXT;
    v_commitchanges BOOLEAN;
    v_result_info JSON;
    v_result_point JSON;
    v_result_line JSON;
    v_result_polygon JSON;
    v_result TEXT;
    v_version TEXT;
    v_updatemapzgeom INTEGER;
    v_geomparamupdate FLOAT;
    v_srid INTEGER;
    v_concavehull FLOAT = 0.85;
    v_visible_layer TEXT;
    v_ignorebrokenvalves BOOLEAN = TRUE;

    v_response JSON;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME";

    -- Get variables from input JSON
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');

    -- Select configuration values
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

    -- Create temporary tables
	-- =======================
	v_data := '{"data":{"fct_name":"MINSECTOR"}}';
	SELECT gw_fct_graphanalytics_create_temptables(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Starting process
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MINSECTOR DYNAMIC SECTORITZATION'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('---------------------------------------------------'));

    -- Initialize process
	-- =======================
	v_data := '{"data":{"expl_id":"' || v_expl || '"}}';
    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

    -- Nodes at the limits of minsectors: nodes with "graph_delimiter" = 'MINSECTOR'
    -- Also, nodes that appear as starts in the "sector" table and have "graph_delimiter" = 'SECTOR'
    -- Note: "to_arc" is in the "man_valve" table; any valve could behave as a check-valve, although this should not happen uncontrolled

    UPDATE temp_pgr_node p SET graph_delimiter = cf.graph_delimiter
    FROM node n
    JOIN cat_node cn ON cn.id = n.nodecat_id
    JOIN cat_feature_node cf ON cf.id = cn.nodetype_id
    WHERE p.node_id = n.node_id AND (cf.graph_delimiter = 'MINSECTOR' OR cf.graph_delimiter = 'SECTOR');

    -- Set modif = TRUE for nodes where "graph_delimiter" = 'MINSECTOR'
    UPDATE temp_pgr_node n SET modif = TRUE
    WHERE n.graph_delimiter = 'MINSECTOR';

    -- If we want to ignore open but broken valves
    IF v_ignorebrokenvalves THEN
        UPDATE temp_pgr_node n SET modif = FALSE
        FROM man_valve v 
        WHERE n.node_id = v.node_id AND n.graph_delimiter = 'MINSECTOR' AND v.closed = FALSE AND v.broken = TRUE;
    END IF;

    -- Arcs to be disconnected: one of the two arcs that reach the valve
    UPDATE temp_pgr_arc a SET modif = TRUE, cost = -1, reverse_cost = -1
    FROM (
        SELECT DISTINCT ON (n.pgr_node_id) n.pgr_node_id, a.pgr_arc_id
        FROM temp_pgr_node n 
        JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        WHERE n.modif = TRUE -- Nodes that are minsectors
    ) s
    WHERE a.pgr_arc_id = s.pgr_arc_id;

    -- Nodes where "graph_delimiter" = 'SECTOR' and are also in the "sector" table
    UPDATE temp_pgr_node n SET modif = TRUE
    FROM (
        SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' AS node_id
        FROM sector WHERE graphconfig IS NOT NULL AND active IS TRUE
    ) s
    WHERE n.node_id = s.node_id AND n.pgr_node_id = n.node_id::INTEGER AND n.graph_delimiter = 'SECTOR';

    -- Arcs to be disconnected: all those that connect to the nodes where "graph_delimiter" = 'SECTOR' and are also in the "sector" table
    UPDATE temp_pgr_arc p SET modif = TRUE, cost = -1, reverse_cost = -1
    FROM temp_pgr_node n
    JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
    WHERE p.pgr_arc_id = a.pgr_arc_id AND n.modif = TRUE AND n.graph_delimiter = 'SECTOR';	

    -- Generate new arcs and disconnect arcs with modif = TRUE
	-- =======================
    SELECT gw_fct_graphanalytics_arrangenetwork() INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

    -- Generate the minsectors
    v_query := 'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost, reverse_cost FROM temp_pgr_arc a';
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node FROM pgr_connectedcomponents(v_query);

    -- Update the zone_id field for arcs and nodes
    UPDATE temp_pgr_node n SET zone_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE n.pgr_node_id = c.node;

    UPDATE temp_pgr_arc a SET zone_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE a.pgr_node_1 = c.node AND (a.cost >= 0 OR a.reverse_cost >= 0);

    INSERT INTO temp_pgr_minsector (pgr_arc_id, node_id, minsector_id_1, minsector_id_2, graph_delimiter)
    SELECT a.pgr_arc_id, n1.node_id, n1.zone_id, n2.zone_id, n1.graph_delimiter
    FROM temp_pgr_arc a
    JOIN temp_pgr_node n1 ON a.pgr_node_1 = n1.pgr_node_id
    JOIN temp_pgr_node n2 ON a.pgr_node_2 = n2.pgr_node_id
    WHERE a.node_1 = a.node_2;

    -- Set zone_id to '0' for nodes at the border of minsectors
    UPDATE temp_pgr_node n SET zone_id = '0'
    FROM (
        SELECT node_id, COUNT(DISTINCT zone_id)
        FROM temp_pgr_node
        GROUP BY node_id
        HAVING COUNT(DISTINCT zone_id) > 1
    ) s
    WHERE n.node_id = s.node_id;

    -- Update feature temporary tables
    UPDATE temp_pgr_connec c SET minsector_id = a.minsector_id FROM arc a WHERE c.arc_id = a.arc_id;
    UPDATE temp_pgr_link l SET minsector_id = c.minsector_id FROM connec c WHERE c.connec_id = l.feature_id;

    -- Insert into minsector temporary table
    INSERT INTO temp_minsector SELECT DISTINCT zone_id FROM temp_pgr_arc;

    -- Update minsector temporary num_border
    UPDATE temp_minsector SET num_border = a.num FROM (
        SELECT a.minsector_id, CASE WHEN COUNT(node_id) = 1 THEN 2 ELSE COUNT(node_id) END AS num
        FROM node n, arc a
        WHERE (a.node_1 = n.node_id OR a.node_2 = n.node_id) AND n.minsector_id = 0
        GROUP BY a.minsector_id
    ) a WHERE a.minsector_id = temp_minsector.minsector_id;

    -- Update minsector temporary num_connec
    UPDATE temp_minsector SET num_connec = b.c FROM (
        SELECT minsector_id, COALESCE(COUNT(*), 0) AS c
        FROM connec a GROUP BY minsector_id
    ) b WHERE b.minsector_id = temp_minsector.minsector_id;
    UPDATE minsector a SET num_connec = 0 WHERE num_connec IS NULL;

    -- Update minsector temporary num_hydro
    SELECT string_to_array(REPLACE(REPLACE('[1,2,3,4]', '[', ''), ']', ''), ',')::INT[]
    INTO v_hydrometer_service FROM config_param_system WHERE parameter = 'admin_hydrometer_state';

    UPDATE temp_minsector SET num_hydro = a.c FROM (
        SELECT minsector_id, COALESCE(COUNT(*), 0) AS c FROM (
            SELECT hydrometer_id, minsector_id
            FROM selector_hydrometer, rtc_hydrometer
            LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::TEXT = rtc_hydrometer.hydrometer_id::TEXT
            JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
            JOIN connec a ON a.customer_code::TEXT = ext_rtc_hydrometer.connec_id::TEXT
            WHERE ext_rtc_hydrometer.state_id = ANY (v_hydrometer_service)
            UNION
            SELECT hydrometer_id, minsector_id
            FROM selector_hydrometer, rtc_hydrometer
            LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::TEXT = rtc_hydrometer.hydrometer_id::TEXT
            JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
            JOIN man_netwjoin ON man_netwjoin.customer_code::TEXT = ext_rtc_hydrometer.connec_id::TEXT
            JOIN node a ON a.node_id::TEXT = man_netwjoin.node_id::TEXT
            WHERE ext_rtc_hydrometer.state_id = ANY (v_hydrometer_service)
        ) a GROUP BY minsector_id
    ) a WHERE a.minsector_id = temp_minsector.minsector_id;
    UPDATE minsector a SET num_hydro = 0 WHERE num_hydro IS NULL;

	-- Update minsector temporary length
    UPDATE temp_minsector SET length = b.length FROM (
        SELECT minsector_id, SUM(st_length2d(a.the_geom)::NUMERIC(12,2)) AS length
        FROM arc a GROUP BY minsector_id
    ) b WHERE b.minsector_id = temp_minsector.minsector_id;

	-- Update minsector temporary exploitation
    UPDATE temp_minsector t SET expl_id = n.expl_id FROM node n WHERE n.node_id::INTEGER = t.minsector_id;

    -- Update minsector temporary geometry
	-- =======================
    v_data := json_build_object(
        'data', json_build_object(
            'fid', v_fid,
            'updatemapzgeom', v_updatemapzgeom,
            'concavehull', v_concavehull,
            'geomparamupdate', v_geomparamupdate,
            'table', 'minsector',
            'field', 'zone_id',
            'fieldmp', 'minsector_id',
            'srid', v_srid
        )
	);
    SELECT gw_fct_graphanalytics_settempgeom(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	IF v_commitchanges IS FALSE THEN
        -- Polygons
        EXECUTE 'SELECT jsonb_agg(features.feature) 
        FROM (
            SELECT jsonb_build_object(
                ''type'',       ''Feature'',
                ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
                ''properties'', to_jsonb(row) - ''the_geom''
            ) AS feature
            FROM (SELECT * FROM temp_minsector) row
        ) features' INTO v_result;

        v_result := COALESCE(v_result, '{}');
        v_result_polygon := CONCAT('{"geometryType":"Polygon", "features":', v_result, '}');

        -- Message
        INSERT INTO temp_audit_check_data (fid, error_message)
        VALUES (v_fid, CONCAT('INFO-', v_fid, ': Minsector attribute on arc/node/connec/link features have NOT BEEN updated by this process'));
    ELSE

        -- Update minsector
        TRUNCATE minsector;
        INSERT INTO minsector SELECT * FROM temp_minsector;

        -- Update minsector graph
        TRUNCATE minsector_graph;
        INSERT INTO minsector_graph (node_id, minsector_1, minsector_2)
        SELECT DISTINCT ON (node_id) node_id, minsector_id_1, minsector_id_2 FROM temp_pgr_minsector;

        -- Update values (only for objects belonging to the selected exploitations)
        EXECUTE 'UPDATE arc a SET minsector_id = t.zone_id FROM temp_pgr_arc t WHERE a.arc_id = t.arc_id AND a.expl_id IN ('||v_expl||')';
        EXECUTE 'UPDATE node n SET minsector_id = t.zone_id FROM temp_pgr_node t WHERE n.node_id = t.node_id AND n.expl_id IN ('||v_expl||')';

        EXECUTE 'UPDATE connec c SET minsector_id = t.minsector_id FROM temp_pgr_connec t WHERE c.connec_id = t.connec_id AND t.expl_id IN ('||v_expl||')';
        EXECUTE 'UPDATE link l SET minsector_id = t.minsector_id FROM temp_pgr_link t WHERE l.link_id = t.link_id AND l.expl_id IN ('||v_expl||')';

        v_result := NULL;
        v_result := COALESCE(v_result, '{}');
        v_result_polygon := CONCAT('{"geometryType":"Polygon", "features":', v_result, '}');
        v_visible_layer := NULL;

        -- Message
        INSERT INTO temp_audit_check_data (fid, error_message)
        VALUES (v_fid, CONCAT('INFO-', v_fid, ': Minsector attribute on arc/node/connec/link features have been updated by this process'));

    END IF;

    -- Control nulls
    v_result_info := COALESCE(v_result_info, '{}');
    v_result_point := COALESCE(v_result_point, '{}');
    v_result_line := COALESCE(v_result_line, '{}');
    v_result_polygon := COALESCE(v_result_polygon, '{}');

	-- Info
    SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
    FROM (
        SELECT id, error_message AS message FROM temp_audit_check_data WHERE cur_user = current_user AND fid = v_fid ORDER BY id
    ) row;
    v_result := COALESCE(v_result, '{}');
    v_result_info := CONCAT('{"geometryType":"", "values":', v_result, '}');

	-- Points
    v_result := NULL;
    v_result := COALESCE(v_result, '{}');
    v_result_point := CONCAT('{"geometryType":"Point", "features":', v_result, '}');

    -- Lines
    v_result := NULL;
    v_result := COALESCE(v_result, '{}');
    v_result_line := CONCAT('{"geometryType":"LineString", "features":', v_result, '}');


    -- Delete temporary tables
	-- =======================
	v_data := '{"data":{"fct_name":"MINSECTOR"}}';
	SELECT gw_fct_graphanalytics_delete_temptables(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

    -- Return
    RETURN gw_fct_json_create_return(
        ('{"status":"Accepted", "message":{"level":1, "text":"Mapzones dynamic analysis done successfully"}, "version":"' || v_version || '"' ||
        ',"body":{"form":{}' ||
        ',"data":{"info":' || v_result_info || ',' ||
        '"point":' || v_result_point || ',' ||
        '"line":' || v_result_line || ',' ||
        '"polygon":' || v_result_polygon || '}' ||
        '}' ||
        '}')::json, 2706, NULL, ('{"visible": ["' || v_visible_layer || '"]}')::json, NULL
    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
