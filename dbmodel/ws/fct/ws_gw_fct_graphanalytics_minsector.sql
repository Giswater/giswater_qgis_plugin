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
    v_expl_id_array TEXT[];
    v_usepsector BOOLEAN;
    v_updatemapzgeom INTEGER;
    v_geomparamupdate FLOAT;
    v_commitchanges BOOLEAN;

    v_data JSON;

    v_hydrometer_service INT[];
    v_fid INTEGER = 134;
    v_query_text TEXT;

    v_version TEXT;
    v_srid INTEGER;

    v_concavehull FLOAT = 0.85;
    v_visible_layer TEXT;
    v_ignore_broken_valves BOOLEAN;
    v_ignore_check_valves BOOLEAN;

    -- CHECKS
    v_arc_list TEXT;

    v_response JSON;

    v_result_info JSON;
    v_result_point JSON;
    v_result_line JSON;
    v_result_polygon JSON;
    v_result TEXT;

	-- LOCK LEVEL LOGIC
	v_original_disable_locklevel json;

    -- MINCUT VARIABLES
    v_record_minsector RECORD;
    v_execute_massive_mincut BOOLEAN;

    -- parameters
    v_pgr_distance INTEGER;
    v_pgr_root_vids int[];
    v_cost_field TEXT;
    v_reverse_cost_field TEXT;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME";

    -- Select configuration values
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

    -- Get variables from input JSON
	v_expl_id = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
    v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector')::BOOLEAN;
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges')::BOOLEAN;
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
    v_ignore_broken_valves = (SELECT value::boolean FROM config_param_system WHERE parameter = 'ignoreBrokenOnlyMassiveMincut');
    v_ignore_check_valves = (SELECT value::boolean FROM config_param_system WHERE parameter = 'ignoreCheckValvesMincut');
    v_execute_massive_mincut = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'executeMassiveMincut')::BOOLEAN;

    -- it's not allowed to commit changes when psectors are used
 	IF v_usepsector THEN
		v_commitchanges := FALSE;
	END IF;

    -- Get exploitation ID array
    v_expl_id_array = gw_fct_get_expl_id_array(v_expl_id);

	-- Get user variable for disabling lock level
    SELECT value::json INTO v_original_disable_locklevel FROM config_param_user
    WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;
    -- Set disable lock level to true for this operation
    UPDATE config_param_user SET value = '{"update":true, "delete":true}'
    WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;

    -- CHECKS
    -- =======================

	-- Check for arcs with missing node_1 or node_2
    SELECT string_agg(arc_id::text, ',') INTO v_arc_list FROM arc
    JOIN value_state_type vst ON vst.id = arc.state_type
    WHERE vst.is_operative = TRUE
    AND (arc.node_1 IS NULL OR arc.node_2 IS NULL)
    AND arc.state > 0;

    IF v_arc_list IS NOT NULL THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4022", "function":"2706", "fid":"'||v_fid||'", "is_process":true,
		"parameters":{"v_arc_list":"'||v_arc_list||'"}}}$$)';
	END IF;


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
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2706", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true", "separator_id":"2049", "tempTable":"temp_"}}$$)';
    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4018", "function":"2706", "fid":"'||v_fid||'", "criticity":"4", "is_process":true,
    "parameters":{"v_usepsector":"'||upper(v_usepsector::text)||'"}, "separator_id":"2000", "tempTable":"temp_"}}$$)';

    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2706", "fid":"'||v_fid||'","criticity":"3", "tempTable":"temp_", "is_process":true, "is_header":"true", "label_id":"3003", "separator_id":"2011"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2706", "fid":"'||v_fid||'", "criticity":"2", "is_process":true, "separator_id":"2000", "tempTable":"temp_"}}$$)';
    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2706", "fid":"'||v_fid||'","criticity":"2", "tempTable":"temp_", "is_process":true, "is_header":"true", "label_id":"3002", "separator_id":"2014"}}$$)';
    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2706", "fid":"'||v_fid||'","criticity":"1", "tempTable":"temp_", "is_process":true, "is_header":"true", "label_id":"3001", "separator_id":"2007"}}$$)';
    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2706", "fid":"'||v_fid||'","criticity":"0", "tempTable":"temp_", "is_process":true, "is_header":"true", "label_id":"3012", "separator_id":"2010"}}$$)';

    -- Initialize process
	-- =======================
	v_data := '{"data":{"expl_id_array":"' || array_to_string(v_expl_id_array, ',') || '", "mapzone_name":"MINSECTOR"}}';
    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

    UPDATE temp_pgr_node t
    SET modif = TRUE
	WHERE graph_delimiter = 'MINSECTOR'
	OR graph_delimiter = 'SECTOR';

    -- Generate new arcs when n.modif = TRUE AND (a.modif1 = TRUE OR a.modif2 = TRUE)
    -- cost i reverse cost for new arcs is 0, arc_id is NULL, old_arc_id = arc_id of the old arc
	-- =======================
    v_data := '{"data":{"mapzone_name":"MINSECTOR"}}';
    SELECT gw_fct_graphanalytics_arrangenetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

    -- the broken valves
     IF v_ignore_broken_valves THEN
        UPDATE temp_pgr_arc a
        SET cost = 0, reverse_cost = 0
        WHERE a.graph_delimiter = 'MINSECTOR'
        AND a.closed = FALSE
        AND a.to_arc IS NOT NULL
        AND a.broken = TRUE;
    END IF;

    -- establishing the borders of the mincut (update cost_mincut/reverse_cost_mincut for the new arcs)
    -- new arcs MINSECTOR AND SECTOR
    UPDATE temp_pgr_arc a
    SET cost_mincut = -1, reverse_cost_mincut = -1
    WHERE graph_delimiter IN ('MINSECTOR', 'SECTOR') ;

    -- check valves
    IF v_ignore_check_valves THEN
        v_cost_field = '0';
        v_reverse_cost_field = '0';
    ELSE
        v_cost_field = 'cost';
        v_reverse_cost_field = 'reverse_cost';
    END IF;

    v_query_text = 'UPDATE temp_pgr_arc a
        SET cost_mincut = ' || v_cost_field || ', reverse_cost_mincut = ' || v_reverse_cost_field || '
        WHERE a.graph_delimiter = ''MINSECTOR''
        AND a.closed = FALSE 
        AND a.to_arc IS NOT NULL';
    EXECUTE v_query_text;

    -- Generate the minsectors
    v_query_text :=
    'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, 1 as cost 
    FROM temp_pgr_arc a
    WHERE a.arc_id IS NOT NULL';
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node FROM pgr_connectedcomponents(v_query_text);

    -- Update the mapzone_id field for arcs and nodes
    UPDATE temp_pgr_node AS n
    SET mapzone_id = agg.min_node
    FROM (
        SELECT c.component, MIN(n.node_id) AS min_node
        FROM temp_pgr_connectedcomponents c
        JOIN temp_pgr_node n on n.pgr_node_id = c.node
        GROUP BY c.component
    ) AS agg
    JOIN temp_pgr_connectedcomponents AS c ON c.component = agg.component
    WHERE n.pgr_node_id = c.node;

    UPDATE temp_pgr_arc a SET mapzone_id = n.mapzone_id
    FROM temp_pgr_node n
    WHERE a.pgr_node_1 = n.pgr_node_id
    AND a.arc_id IS NOT NULL;

    INSERT INTO temp_pgr_minsector_graph (node_id, minsector_1, minsector_2)
    SELECT COALESCE(n1.node_id, n2.node_id), n1.mapzone_id, n2.mapzone_id
    FROM temp_pgr_arc a
    JOIN temp_pgr_node n1 ON a.pgr_node_1 = n1.pgr_node_id
    JOIN temp_pgr_node n2 ON a.pgr_node_2 = n2.pgr_node_id
    WHERE a.arc_id IS NULL
    AND n1.mapzone_id <> 0 AND n2.mapzone_id <> 0
    AND n1.mapzone_id <> n2.mapzone_id;

    -- Insert into minsector temporary table
    INSERT INTO temp_pgr_minsector
    SELECT DISTINCT mapzone_id
    FROM temp_pgr_arc
    WHERE mapzone_id > 0;

    -- Set mapzone_id to 0 for nodes at the border of minsectors
    UPDATE temp_pgr_node n SET mapzone_id = 0
    FROM temp_pgr_minsector_graph s
    WHERE n.node_id = s.node_id;

    -- Update minsector temporary num_border
    UPDATE temp_pgr_minsector t SET num_border = a.num
    FROM (
        SELECT a.mapzone_id, COUNT(*) AS num
        FROM temp_pgr_node n
        JOIN v_temp_node vn ON vn.node_id = n.node_id -- real nodes
        JOIN v_temp_arc va ON vn.node_id IN (va.node_1, va.node_2)
        JOIN temp_pgr_arc a ON va.arc_id = a.arc_id -- real arcs
        WHERE n.mapzone_id = 0 AND a.mapzone_id > 0
        GROUP BY a.mapzone_id
    ) a WHERE a.mapzone_id = t.minsector_id;
    UPDATE temp_pgr_minsector SET num_border = 0 WHERE num_border IS NULL;

    -- Update minsector temporary num_connec
    UPDATE temp_pgr_minsector t SET num_connec = c.num_connec
    FROM (
        SELECT a.mapzone_id, COUNT(*) AS num_connec
        FROM v_temp_connec v
        JOIN temp_pgr_arc a on v.arc_id = a.arc_id
        WHERE a.mapzone_id > 0
        GROUP BY a.mapzone_id
    ) c WHERE c.mapzone_id = t.minsector_id;
    UPDATE temp_pgr_minsector SET num_connec = 0 WHERE num_connec IS NULL;

    -- Update minsector temporary num_hydro
    SELECT ARRAY(SELECT jsonb_array_elements_text(value::jsonb->'1')::integer)
    INTO v_hydrometer_service
    FROM config_param_system
    WHERE parameter = 'admin_hydrometer_state';

    WITH
    	hydrometer AS (
    		SELECT h.hydrometer_id, a.mapzone_id
			FROM rtc_hydrometer_x_connec h
			JOIN v_temp_connec c USING (connec_id)
			JOIN temp_pgr_arc a USING (arc_id)
			WHERE a.mapzone_id >0
			UNION
			SELECT h.hydrometer_id, n.mapzone_id
			FROM rtc_hydrometer_x_node h
			JOIN temp_pgr_node n USING (node_id)
			WHERE n.mapzone_id >0
		),
		hydrometer_result AS (
			SELECT h.mapzone_id, count(*) AS num_hydro
			FROM hydrometer h
			JOIN ext_rtc_hydrometer e ON e.id::TEXT = h.hydrometer_id::TEXT
			JOIN selector_hydrometer s ON s.cur_user = CURRENT_USER AND s.state_id = e.state_id
			WHERE s.state_id = ANY (v_hydrometer_service)
			GROUP BY h.mapzone_id
		)
	UPDATE temp_pgr_minsector t
	SET num_hydro = h.num_hydro
	FROM hydrometer_result h
	WHERE t.minsector_id = h.mapzone_id;
    UPDATE temp_pgr_minsector SET num_hydro = 0 WHERE num_hydro IS NULL;

	-- Update minsector temporary length
    UPDATE temp_pgr_minsector SET length = b.length FROM (
        SELECT mapzone_id AS minsector_id, SUM(st_length2d(va.the_geom)::NUMERIC(12,2)) AS length
		FROM temp_pgr_arc ta
		JOIN v_temp_arc va USING (arc_id)
		WHERE ta.mapzone_id > 0
        GROUP BY ta.mapzone_id
    ) b WHERE b.minsector_id = temp_pgr_minsector.minsector_id;

    -- update geometry of mapzones
    IF v_updatemapzgeom = 0 OR v_updatemapzgeom IS NULL THEN
        -- do nothing

    ELSIF  v_updatemapzgeom = 1 THEN

        -- concave polygon
        v_query_text = '
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
        EXECUTE v_query_text;

    ELSIF  v_updatemapzgeom = 2 THEN

        -- pipe buffer
        v_query_text = '
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
        EXECUTE v_query_text;

    ELSIF  v_updatemapzgeom = 3 THEN

        -- use plot and pipe buffer
        v_query_text = '
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
        EXECUTE v_query_text;
    END IF;

	-- Update minsector temporary exploitation
    UPDATE temp_pgr_minsector t
    SET expl_id = sub.expl_id_arr,
    dma_id = sub.dma_id_arr,
    dqa_id = sub.dqa_id_arr,
    muni_id = sub.muni_id_arr,
    sector_id = sub.sector_id_arr,
    supplyzone_id = sub.supplyzone_id_arr
    FROM (
        SELECT
            tn.mapzone_id AS minsector_id,
            array_agg(DISTINCT vn.expl_id) AS expl_id_arr,
            array_agg(DISTINCT vn.dma_id) AS dma_id_arr,
            array_agg(DISTINCT vn.dqa_id) AS dqa_id_arr,
            array_agg(DISTINCT vn.muni_id) AS muni_id_arr,
            array_agg(DISTINCT vn.sector_id) AS sector_id_arr,
            array_agg(DISTINCT vn.supplyzone_id) AS supplyzone_id_arr
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
            FROM (
                SELECT 
                    minsector_id, dma_id, dqa_id, presszone_id, expl_id, sector_id, muni_id, supplyzone_id, 
                    num_border, num_connec, num_hydro, length, the_geom, ''ve_minsector'' AS layer 
                FROM temp_pgr_minsector
            ) row
            UNION
            SELECT jsonb_build_object(
                ''type'',       ''Feature'',
                ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
                ''properties'', to_jsonb(row) - ''the_geom''
            ) AS feature
            FROM (
                SELECT 
                    minsector_id, dma_id, dqa_id, presszone_id, expl_id, sector_id, muni_id, supplyzone_id, 
                    num_border, num_connec, num_hydro, length, the_geom, ''ve_minsector_mincut'' AS layer 
                FROM v_temp_minsector_mincut
            ) row
        ) features' INTO v_result;

        v_result := COALESCE(v_result, '{}');
        v_result_polygon := CONCAT('{"geometryType":"Polygon", "layerName": "Minsector Analysis", "features":', v_result, '}');

        v_visible_layer = NULL;

        -- Message
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4020", "function":"2706", "fid":"'||v_fid||'", "prefix_id": "1001",	 "is_process":true}}$$)';

    ELSE

        -- Update minsector
        DELETE FROM minsector WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old
            WHERE minsector.minsector_id = v_temp_pgr_mapzone_old.old_mapzone_id
        );
        INSERT INTO minsector SELECT * FROM temp_pgr_minsector;

        INSERT INTO minsector_graph (node_id, minsector_1, minsector_2)
        SELECT node_id, minsector_1, minsector_2 FROM temp_pgr_minsector_graph;

        v_query_text = '
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
        EXECUTE v_query_text;

        v_query_text = '
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
        EXECUTE v_query_text;

        v_query_text = '
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
        EXECUTE v_query_text;

        v_query_text = '
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
        EXECUTE v_query_text;

        v_query_text = '
            UPDATE arc SET minsector_id = 0
            WHERE EXISTS (
                SELECT 1 FROM v_temp_pgr_mapzone_old
                WHERE arc.minsector_id = v_temp_pgr_mapzone_old.old_mapzone_id
            )
            AND NOT EXISTS (
                SELECT 1 FROM temp_pgr_arc tpa WHERE tpa.mapzone_id = arc.minsector_id
            )
            AND arc.minsector_id IS DISTINCT FROM 0;
        ';
        EXECUTE v_query_text;

        v_query_text = '
            UPDATE node SET minsector_id = 0
            WHERE EXISTS (
                SELECT 1 FROM v_temp_pgr_mapzone_old
                WHERE node.minsector_id = v_temp_pgr_mapzone_old.old_mapzone_id
            )
            AND NOT EXISTS (
                SELECT 1 FROM temp_pgr_node tpn WHERE tpn.mapzone_id = node.minsector_id
            )
            AND node.minsector_id IS DISTINCT FROM 0;
        ';
        EXECUTE v_query_text;

        v_query_text = '
            UPDATE connec SET minsector_id = 0
            WHERE EXISTS (
                SELECT 1 FROM v_temp_pgr_mapzone_old
                WHERE connec.minsector_id = v_temp_pgr_mapzone_old.old_mapzone_id
            )
            AND NOT EXISTS (
                SELECT 1 FROM temp_pgr_arc ta JOIN v_temp_connec vc USING (arc_id) WHERE vc.connec_id = connec.connec_id
            )
            AND connec.minsector_id IS DISTINCT FROM 0;
        ';
        EXECUTE v_query_text;

        v_query_text = '
            UPDATE link SET minsector_id = 0
            WHERE EXISTS (
                SELECT 1 FROM v_temp_pgr_mapzone_old
                WHERE link.minsector_id = v_temp_pgr_mapzone_old.old_mapzone_id
            )
            AND NOT EXISTS (
                SELECT 1 FROM temp_pgr_arc ta JOIN v_temp_link_connec vc USING (arc_id) WHERE vc.link_id = link.link_id
            )
            AND link.minsector_id IS DISTINCT FROM 0;
        ';
        EXECUTE v_query_text;

        v_visible_layer ='"ve_minsector", "ve_minsector_mincut"';

    END IF;


    IF v_execute_massive_mincut THEN
        -- PREPARE tables for Massive Mincut

        --ARCS - keep only the new arcs
        DELETE FROM temp_pgr_arc WHERE graph_delimiter = 'NONE';

        -- ARCS-VALVE (MINSECTOR)
        -- delete the valves that are not minsector borders
        DELETE FROM temp_pgr_arc a
        WHERE
        a.graph_delimiter = 'MINSECTOR'
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_minsector_graph g
            WHERE g.node_id = COALESCE (a.node_1 , a.node_2)
        );

        -- change pgr_node_1 and pgr_node_2 for their minsector value
        UPDATE temp_pgr_arc a
        SET pgr_node_1 = g.minsector_1, pgr_node_2 = g.minsector_2
        FROM temp_pgr_minsector_graph g
        WHERE g.node_id = COALESCE (a.node_1 , a.node_2);

        -- ARCS-SECTOR
        UPDATE temp_pgr_arc a
        SET pgr_node_1 = COALESCE( NULLIF(n.mapzone_id,0), n.node_id)
        FROM temp_pgr_node n
        WHERE a.graph_delimiter = 'SECTOR'
        AND n.graph_delimiter = 'SECTOR'
        AND n.pgr_node_id = a.pgr_node_1;

        UPDATE temp_pgr_arc a
        SET pgr_node_2 =COALESCE( NULLIF(n.mapzone_id,0), n.node_id)
        FROM temp_pgr_node n
        WHERE a.graph_delimiter = 'SECTOR'
        AND n.graph_delimiter = 'SECTOR'
        AND n.pgr_node_id = a.pgr_node_2;

        -- NODES - keep only the nodes-SECTOR that have mapzone_id = 0 (node_id is not NULL); they don't exist in the table temp_pgr_minsector
        DELETE FROM temp_pgr_node tpn
        WHERE graph_delimiter <> 'SECTOR' OR mapzone_id > 0;

        -- update mapzone_id with the node_id
        UPDATE temp_pgr_node SET pgr_node_id = node_id;

        -- insert the MINSECTORS as nodes
        INSERT INTO temp_pgr_node (pgr_node_id, mapzone_id, graph_delimiter)
        SELECT minsector_id, 0, 'MINSECTOR'
        FROM temp_pgr_minsector m;

        -- FINISH preparing

        -- CORE MASSIVE MINCUT
        v_query_text = '
            SELECT minsector_id FROM temp_pgr_minsector
        ';

        SELECT count(*) INTO v_pgr_distance FROM temp_pgr_arc;

        FOR v_record_minsector IN EXECUTE v_query_text LOOP
            v_pgr_root_vids := ARRAY[v_record_minsector.minsector_id];

            UPDATE temp_pgr_arc SET mapzone_id = 0 WHERE mapzone_id <> 0;
            UPDATE temp_pgr_node SET mapzone_id = 0 WHERE mapzone_id <> 0;
            UPDATE temp_pgr_arc SET proposed = FALSE WHERE proposed;

            v_data := '{"data":{"pgrDistance":'||v_pgr_distance||', "pgrRootVids":['||array_to_string(v_pgr_root_vids, ',')||'], "ignoreCheckValvesMincut":'||v_ignore_check_valves||'}}';
            RAISE NOTICE 'v_data: %', v_data;
            v_response := gw_fct_mincut_core(v_data);

            IF v_response->>'status' <> 'Accepted' THEN
                RETURN v_response;
            END IF;

            -- insert the mincut_minsector_id
            INSERT INTO temp_pgr_minsector_mincut (minsector_id, mincut_minsector_id)
            SELECT v_record_minsector.minsector_id, n.pgr_node_id
            FROM temp_pgr_node n
            WHERE n.graph_delimiter = 'MINSECTOR'
            AND n.mapzone_id <> 0;
        END LOOP;

        IF v_commitchanges THEN
            DELETE FROM minsector_mincut;

            INSERT INTO minsector_mincut (minsector_id, mincut_minsector_id)
            SELECT minsector_id, mincut_minsector_id
            FROM temp_pgr_minsector_mincut;
        END IF;

    END IF;

    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4354", "function":"2706", "fid":"'||v_fid||'", "is_process":true, "tempTable":"temp_"}}$$)';

    -- Info
    SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
    FROM (
        SELECT id, error_message AS message FROM temp_audit_check_data WHERE cur_user = current_user AND fid = v_fid ORDER BY id
    ) row;
    v_result := COALESCE(v_result, '{}');
    v_result_info := CONCAT('{"geometryType":"", "values":', v_result, '}');

    -- Control nulls
    v_result_info := COALESCE(v_result_info, '{}');
    v_result_point := COALESCE(v_result_point, '{}');
    v_result_line := COALESCE(v_result_line, '{}');
    v_result_polygon := COALESCE(v_result_polygon, '{}');



	-- Restore original disable lock level
    UPDATE config_param_user SET value = v_original_disable_locklevel WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;

    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4354", "function":"2706", "fid":"'||v_fid||'", "is_process":true, "tempTable":"temp_"}}$$)';

    -- Return
    RETURN gw_fct_json_create_return(
        ('{"status":"Accepted", "message":{"level":1, "text":"Minsector dynamic analysis done successfully"}, "version":"' || v_version || '"' ||
        ',"body":{"form":{}' ||
        ',"data":{"info":' || v_result_info || ',' ||
        '"point":' || v_result_point || ',' ||
        '"line":' || v_result_line || ',' ||
        '"polygon":' || v_result_polygon || '}' ||
        '}' ||
        '}')::json, 2706, NULL, ('{"visible": [' || v_visible_layer || ']}')::json, NULL
    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
