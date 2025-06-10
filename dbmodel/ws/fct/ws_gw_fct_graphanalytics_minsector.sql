/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
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

    -- dialog
    v_expl_id TEXT;
    v_expl_id_array TEXT;
    v_usepsector BOOLEAN;
    v_updatemapzgeom INTEGER;
    v_geomparamupdate FLOAT;
    v_commitchanges BOOLEAN;

    v_query TEXT;
    v_data JSON;

    v_hydrometer_service INT[];
    v_fid INTEGER = 134;
    v_querytext TEXT;

    v_version TEXT;
    v_srid INTEGER;

    v_concavehull FLOAT = 0.85;
    v_visible_layer TEXT;
    v_ignorebrokenvalves BOOLEAN = TRUE;

    v_macrominsector_id_arc TEXT;

    v_response JSON;

    v_result_info JSON;
    v_result_point JSON;
    v_result_line JSON;
    v_result_polygon JSON;
    v_result TEXT;

	-- LOCK LEVEL LOGIC
	v_original_disable_locklevel json;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME";

    -- Select configuration values
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

    -- Get variables from input JSON
	v_expl_id = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
    v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector');
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');

    -- it's not allowed to commit changes when psectors are used
 	IF v_usepsector = 'true' THEN
		v_commitchanges = 'false';
	END IF;

	-- MANAGE EXPL ARR
    -- For user selected exploitations
    IF v_expl_id = '-901' THEN
        SELECT string_to_array(string_agg(DISTINCT expl_id::text, ','), ',') INTO v_expl_id_array
		FROM selector_expl;
    -- For all exploitations
    ELSIF v_expl_id = '-902' THEN
        SELECT string_to_array(string_agg(DISTINCT expl_id::text, ','), ',') INTO v_expl_id_array
        FROM exploitation
		WHERE active;
    -- For a specific exploitation/s
    ELSE
		v_expl_id_array = string_to_array(v_expl_id, ',');
    END IF;

	-- Get user variable for disabling lock level
    SELECT value::json INTO v_original_disable_locklevel FROM config_param_user
    WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;
    -- Set disable lock level to true for this operation
    UPDATE config_param_user SET value = '{"update":true, "delete":true}'
    WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;


	-- Delete temporary tables
	-- =======================
	v_data := '{"data":{"action":"DROP", "fct_name":"MINSECTOR"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

	IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Create temporary tables
	-- =======================
    v_data := '{"data":{"action":"CREATE", "fct_name":"MINSECTOR", "use_psector":"'|| v_usepsector ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Starting process
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MINSECTOR DYNAMIC SECTORITZATION'));
	INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('---------------------------------------------------'));
    INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Use psectors: ', upper(v_usepsector::text)));

    INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat(''));
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, 'ERRORS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '-----------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, 'WARNINGS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '--------------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, 'INFO');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '-------');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, 'DETAILS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, '----------');

    -- Initialize process
	-- =======================
	v_data := '{"data":{"expl_id_array":"' || v_expl_id_array || '", "mapzone_name":"MINSECTOR"}}';
    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

    -- Nodes at the limits of minsectors: nodes with "graph_delimiter" = 'MINSECTOR' or "graph_delimiter" = 'SECTOR'

    UPDATE temp_pgr_node t
    SET graph_delimiter = LOWER(gd)
    FROM (
        SELECT n.node_id, unnest(cf.graph_delimiter) AS gd
        FROM node n
        JOIN cat_node cn ON cn.id = n.nodecat_id
        JOIN cat_feature_node cf ON cf.id = cn.node_type
        WHERE ('MINSECTOR' = ANY(cf.graph_delimiter) OR 'SECTOR' = ANY(cf.graph_delimiter))
    ) sub
    WHERE t.node_id = sub.node_id;

    -- Set modif = TRUE for nodes where "graph_delimiter" = 'minsector'
    UPDATE temp_pgr_node n set closed = v.closed, broken = v.broken, to_arc = v.to_arc, modif = TRUE
    FROM man_valve v
    WHERE n.node_id = v.node_id AND n.graph_delimiter = 'minsector';

    -- If we want to ignore open but broken valves (broken = TRUE cancel toArc if toArc IS NOT NULL and cannot be closed if toArc IS NULL)
    IF v_ignorebrokenvalves THEN
        UPDATE temp_pgr_node n SET modif = FALSE
        WHERE n.graph_delimiter = 'minsector' AND n.closed = FALSE AND n.broken = TRUE;
    END IF;

    -- Set modif = TRUE for nodes where "graph_delimiter" = 'minsector'
    UPDATE temp_pgr_node n SET modif = TRUE
    WHERE n.graph_delimiter = 'sector';

    -- ARCS to be disconnected:
    --one of the two arcs that reach the valve
    WITH
    arcs_selected AS (
        SELECT DISTINCT ON (n.pgr_node_id)
            a.pgr_arc_id,
            n.pgr_node_id,
            a.pgr_node_1,
            a.pgr_node_2
        FROM temp_pgr_node n
        JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        WHERE n.modif = TRUE AND n.graph_delimiter = 'minsector'
    ),
	arcs_modif AS (
		SELECT
			pgr_arc_id,
			bool_or(pgr_node_id = pgr_node_1) AS modif1,
			bool_or( pgr_node_id = pgr_node_2) AS modif2
		FROM arcs_selected
		GROUP BY pgr_arc_id
	)
	UPDATE temp_pgr_arc t
	SET modif1= s.modif1,
		modif2= s.modif2
	FROM arcs_modif s
	WHERE t.pgr_arc_id= s.pgr_arc_id;

    -- all the arcs that connect to nodes SECTOR
    WITH
    arcs_selected AS (
        SELECT
            a.pgr_arc_id,
            n.pgr_node_id,
            a.pgr_node_1,
            a.pgr_node_2
        FROM temp_pgr_node n
        JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        WHERE n.modif = TRUE and n.graph_delimiter = 'sector'
    ),
	arcs_modif AS (
		SELECT
			pgr_arc_id,
			bool_or(pgr_node_id = pgr_node_1) AS modif1,
			bool_or( pgr_node_id = pgr_node_2) AS modif2
		FROM arcs_selected
		GROUP BY pgr_arc_id
	)
	UPDATE temp_pgr_arc t
	SET modif1= s.modif1,
		modif2= s.modif2
	FROM arcs_modif s
	WHERE t.pgr_arc_id= s.pgr_arc_id;


    -- Generate new arcs and disconnect arcs with modif1 = TRUE OR modif2 = TRUE
	-- =======================
    SELECT gw_fct_graphanalytics_arrangenetwork() INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

    -- Generate the minsectors
    v_query :=
    'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, 1 as cost 
    FROM temp_pgr_arc a
    WHERE a.arc_id IS NOT NULL
    AND a.pgr_node_1 IS NOT NULL AND a.pgr_node_2 IS NOT NULL'; -- Avoids the crash of pgrouting function
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node FROM pgr_connectedcomponents(v_query);

    -- Update the mapzone_id field for arcs and nodes
    UPDATE temp_pgr_node n SET mapzone_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE n.pgr_node_id = c.node;

    UPDATE temp_pgr_arc a SET mapzone_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE a.pgr_node_1 = c.node
    AND a.arc_id IS NOT NULL
    AND a.pgr_node_1 IS NOT NULL AND a.pgr_node_2 IS NOT NULL;

    INSERT INTO temp_pgr_minsector_graph (node_id, minsector_1, minsector_2)
    SELECT COALESCE(n1.node_id, n2.node_id), n1.mapzone_id, n2.mapzone_id
    FROM temp_pgr_arc a
    JOIN temp_pgr_node n1 ON a.pgr_node_1 = n1.pgr_node_id
    JOIN temp_pgr_node n2 ON a.pgr_node_2 = n2.pgr_node_id
    WHERE a.arc_id IS NULL
    AND n1.mapzone_id <> 0 AND n2.mapzone_id <> 0
    AND n1.mapzone_id <> n2.mapzone_id;

    -- Set mapzone_id to 0 for nodes at the border of minsectors
    UPDATE temp_pgr_node n SET mapzone_id = 0
    FROM temp_pgr_minsector_graph s
    WHERE n.node_id = s.node_id;

    -- Insert into minsector temporary table
    INSERT INTO temp_pgr_minsector
    SELECT DISTINCT mapzone_id
    FROM temp_pgr_arc
    WHERE mapzone_id > 0;

    -- Update minsector temporary num_border
    UPDATE temp_pgr_minsector SET num_border = a.num FROM (
        SELECT a.minsector_id, CASE WHEN COUNT(node_id) = 1 THEN 2 ELSE COUNT(node_id) END AS num
        FROM node n, arc a
        WHERE (a.node_1 = n.node_id OR a.node_2 = n.node_id) AND n.minsector_id = 0
        GROUP BY a.minsector_id
    ) a WHERE a.minsector_id = temp_pgr_minsector.minsector_id;

    -- Update minsector temporary num_connec
    UPDATE temp_pgr_minsector SET num_connec = b.c FROM (
        SELECT minsector_id, COALESCE(COUNT(*), 0) AS c
        FROM connec a GROUP BY minsector_id
    ) b WHERE b.minsector_id = temp_pgr_minsector.minsector_id;
    UPDATE minsector a SET num_connec = 0 WHERE num_connec IS NULL;

    -- Update minsector temporary num_hydro
    SELECT string_to_array(REPLACE(REPLACE('[1,2,3,4]', '[', ''), ']', ''), ',')::INT[]
    INTO v_hydrometer_service FROM config_param_system WHERE parameter = 'admin_hydrometer_state';

    UPDATE temp_pgr_minsector SET num_hydro = a.c FROM (
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
    ) a WHERE a.minsector_id = temp_pgr_minsector.minsector_id;
    UPDATE minsector a SET num_hydro = 0 WHERE num_hydro IS NULL;

    -- update geometry of mapzones
    IF v_updatemapzgeom = 0 OR v_updatemapzgeom IS NULL THEN
        -- do nothing

    ELSIF  v_updatemapzgeom = 1 THEN

        -- concave polygon
        v_querytext = '
            UPDATE temp_pgr_minsector SET the_geom = ST_Multi(b.the_geom) 
                FROM (
                    WITH polygon AS (
                        SELECT ST_Collect(v.the_geom) AS g, t.mapzone_id AS minsector_id
                        FROM temp_pgr_arc t
                        JOIN v_temp_arc v USING (arc_id)
                        GROUP BY t.mapzone_id
                    )
                    SELECT 
                        mapzone_id AS minsector_id, 
                        CASE WHEN ST_GeometryType(ST_ConcaveHull(g, '||v_geomparamupdate||')) = ''ST_Polygon''::text THEN ST_Buffer(ST_ConcaveHull(g, '||v_concavehull||'), 3)::geometry(Polygon,'||v_srid||')
                        ELSE ST_Expand(ST_Buffer(g, 3::double precision), 1::double precision)::geometry(Polygon, '||v_srid||') 
                        END AS the_geom 
                    FROM polygon
                ) b 
            WHERE b.minsector_id = temp_pgr_minsector.minsector_id
        ';
        EXECUTE v_querytext;

    ELSIF  v_updatemapzgeom = 2 THEN

        -- pipe buffer
        v_querytext = '
            UPDATE temp_pgr_minsector SET the_geom = ST_Multi(geom) 
            FROM (
                SELECT t.mapzone_id AS minsector_id, (ST_Buffer(ST_Collect(v.the_geom),'||v_geomparamupdate||')) AS geom 
                FROM temp_pgr_arc t
                JOIN v_temp_arc v USING (arc_id)
                WHERE mapzone_id > 0 
                GROUP BY t.mapzone_id
            ) b 
            WHERE b.minsector_id = temp_pgr_minsector.minsector_id;
        ';
        EXECUTE v_querytext;

    ELSIF  v_updatemapzgeom = 3 THEN

        -- use plot and pipe buffer
        v_querytext = '
            UPDATE temp_pgr_minsector SET the_geom = geom 
            FROM (
                SELECT minsector_id, ST_Multi(ST_Buffer(ST_Collect(geom),0.01)) AS geom 
                FROM (
                    SELECT t.mapzone_id AS minsector_id, ST_Buffer(ST_Collect(v.the_geom), '||v_geomparamupdate||') AS geom 
                    FROM temp_pgr_arc t
                    JOIN v_temp_arc v USING (arc_id)
                    WHERE mapzone_id::integer > 0
                    GROUP BY t.mapzone_id 
                    UNION
                    SELECT t.mapzone_id AS minsector_id, ST_Collect(ext_plot.the_geom) AS geom 
                    FROM temp_pgr_arc t 
                    JOIN v_temp_connec vc USING (arc_id)
                    LEFT JOIN ext_plot ON vc.plot_code = ext_plot.plot_code
					LEFT JOIN ext_plot ON ST_DWithin(vc.the_geom, ext_plot.the_geom, 0.001)
                    WHERE mapzone_id::integer > 0 
                    GROUP BY t.mapzone_id
                ) c 
                GROUP BY minsector_id
            ) b 
            WHERE b.minsector_id = temp_pgr_minsector.minsector_id
        ';
        EXECUTE v_querytext;
    END IF;

	-- Update minsector temporary length
    UPDATE temp_pgr_minsector SET length = b.length FROM (
        SELECT minsector_id, SUM(st_length2d(a.the_geom)::NUMERIC(12,2)) AS length
        FROM arc a GROUP BY minsector_id
    ) b WHERE b.minsector_id = temp_pgr_minsector.minsector_id;

	-- Update minsector temporary exploitation
    UPDATE temp_pgr_minsector t
    SET expl_id = sub.expl_id_arr
    FROM (
        SELECT tn.mapzone_id AS minsector_id, array_agg(DISTINCT vn.expl_id) AS expl_id_arr
        FROM temp_pgr_node tn
		JOIN v_temp_node vn USING (node_id)
        GROUP BY tn.mapzone_id
    ) sub
    WHERE sub.minsector_id = t.minsector_id;

	IF v_commitchanges IS FALSE THEN
        -- Polygons
        EXECUTE 'SELECT jsonb_agg(features.feature) 
        FROM (
            SELECT jsonb_build_object(
                ''type'',       ''Feature'',
                ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
                ''properties'', to_jsonb(row) - ''the_geom''
            ) AS feature
            FROM (SELECT * FROM temp_pgr_minsector) row
        ) features' INTO v_result;

        v_result := COALESCE(v_result, '{}');
        v_result_polygon := CONCAT('{"geometryType":"Polygon", "features":', v_result, '}');

        -- Message
        INSERT INTO temp_audit_check_data (fid, error_message)
        VALUES (v_fid, CONCAT('INFO-', v_fid, ': Minsector attribute on arc/node/connec/link features have NOT BEEN updated by this process'));
    ELSE

        -- Update minsector
        DELETE FROM minsector WHERE EXISTS (
            SELECT 1 FROM temp_pgr_minsector_old
            WHERE minsector.minsector_id = temp_pgr_minsector_old.minsector_id
        );
        INSERT INTO minsector SELECT * FROM temp_pgr_minsector;

        INSERT INTO minsector_graph (node_id, minsector_1, minsector_2)
        SELECT node_id, minsector_1, minsector_2 FROM temp_pgr_minsector_graph;

        v_querytext = '
            WITH arcs AS (
                SELECT 
                    arc_id,
                    CASE WHEN mapzone_id = -1 THEN 0
                    ELSE mapzone_id
                    END AS mapzone_id
                FROM temp_pgr_arc
            )
            UPDATE arc SET minsector_id = arcs.mapzone_id
            FROM arcs
            WHERE arc.arc_id = arcs.arc_id
            AND arc.minsector_id IS DISTINCT FROM arcs.mapzone_id;';
        EXECUTE v_querytext;

        v_querytext = '
            WITH nodes AS (
                SELECT 
                    node_id,
                    CASE WHEN mapzone_id = -1 THEN 0
                    ELSE mapzone_id
                    END AS mapzone_id
                FROM temp_pgr_node
            )
            UPDATE node SET minsector_id = nodes.mapzone_id
            FROM nodes
            WHERE node.node_id = nodes.node_id
            AND node.minsector_id IS DISTINCT FROM nodes.mapzone_id;';
        EXECUTE v_querytext;

        v_querytext = '
            WITH connecs AS (
                SELECT 
                    connec_id,
                    CASE WHEN mapzone_id = -1 THEN 0
                    ELSE mapzone_id
                    END AS mapzone_id
                FROM temp_pgr_arc
                JOIN v_temp_connec vc USING (arc_id)
            )
            UPDATE connec SET minsector_id = connecs.mapzone_id
            FROM connecs
            WHERE connec.connec_id = connecs.connec_id
            AND connec.minsector_id IS DISTINCT FROM connecs.mapzone_id;';
        EXECUTE v_querytext;

        v_querytext = '
            WITH links AS (
                SELECT 
                    link_id,
                    CASE WHEN mapzone_id = -1 THEN 0
                    ELSE mapzone_id
                    END AS mapzone_id
                FROM temp_pgr_arc
                JOIN v_temp_link_connec vc USING (arc_id)
            )
            UPDATE link SET minsector_id = links.mapzone_id
            FROM links
            WHERE link.link_id = links.link_id
            AND link.minsector_id IS DISTINCT FROM links.mapzone_id;';
        EXECUTE v_querytext;

        v_querytext = '
            UPDATE arc SET minsector_id = 0
            WHERE EXISTS (
                SELECT 1 FROM temp_pgr_minsector_old
                WHERE arc.minsector_id = temp_pgr_minsector_old.minsector_id
            )
            AND NOT EXISTS (
                SELECT 1 FROM temp_pgr_arc tpa WHERE tpa.mapzone_id = arc.minsector_id
            )
            AND arc.minsector_id IS DISTINCT FROM 0;
        ';
        EXECUTE v_querytext;

        v_querytext = '
            UPDATE node SET minsector_id = 0
            WHERE EXISTS (
                SELECT 1 FROM temp_pgr_minsector_old
                WHERE node.minsector_id = temp_pgr_minsector_old.minsector_id
            )
            AND NOT EXISTS (
                SELECT 1 FROM temp_pgr_node tpn WHERE tpn.mapzone_id = node.minsector_id
            )
            AND node.minsector_id IS DISTINCT FROM 0;
        ';
        EXECUTE v_querytext;

        v_querytext = '
            UPDATE connec SET minsector_id = 0
            WHERE EXISTS (
                SELECT 1 FROM temp_pgr_minsector_old
                WHERE connec.minsector_id = temp_pgr_minsector_old.minsector_id
            )
            AND NOT EXISTS (
                SELECT 1 FROM temp_pgr_arc ta JOIN v_temp_connec vc USING (arc_id) WHERE vc.connec_id = connec.connec_id
            )
            AND connec.minsector_id IS DISTINCT FROM 0;
        ';
        EXECUTE v_querytext;

        v_querytext = '
            UPDATE link SET minsector_id = 0
            WHERE EXISTS (
                SELECT 1 FROM temp_pgr_minsector_old
                WHERE link.minsector_id = temp_pgr_minsector_old.minsector_id
            )
            AND NOT EXISTS (
                SELECT 1 FROM temp_pgr_arc ta JOIN v_temp_link_connec vc USING (arc_id) WHERE vc.link_id = link.link_id
            )
            AND link.minsector_id IS DISTINCT FROM 0;
        ';
        EXECUTE v_querytext;


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


	-- Restore original disable lock level
    UPDATE config_param_user SET value = v_original_disable_locklevel WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;

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
