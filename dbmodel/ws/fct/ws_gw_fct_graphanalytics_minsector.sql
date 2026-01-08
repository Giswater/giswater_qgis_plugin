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

    v_fid INTEGER = 134;
    v_query_text TEXT;
    v_query_text_components TEXT;

    v_version TEXT;
    v_srid INTEGER;

    v_concavehull FLOAT = 0.85;
    v_visible_layer TEXT;
    v_ignore_broken_valves BOOLEAN;
    v_ignore_check_valves BOOLEAN;

    v_response JSON;
    v_error_context TEXT;
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
    v_ignore_unaccess_valves BOOLEAN;
    v_ignore_changestatus_valves BOOLEAN;
    v_mincut_plannified_state integer := 0; -- Plannified mincut state
    v_mincut_in_progress_state integer := 1; -- In progress mincut state
    v_mincut_network_class integer := 1; -- Network mincut class

    v_day_start TIMESTAMP;
    v_day_end TIMESTAMP;


    -- parameters
    v_pgr_distance float;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME";

    -- Select configuration values
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

    -- Get variables from input JSON
	v_expl_id = p_data->'data'->'parameters'->>'exploitation';
    v_usepsector = (p_data->'data'->'parameters'->>'usePlanPsector')::BOOLEAN;
	v_commitchanges = (p_data->'data'->'parameters'->>'commitChanges')::BOOLEAN;
	v_updatemapzgeom = p_data->'data'->'parameters'->>'updateMapZone';
	v_geomparamupdate = p_data->'data'->'parameters'->>'geomParamUpdate';
    v_ignore_broken_valves = (SELECT value::boolean FROM config_param_system WHERE parameter = 'ignoreBrokenOnlyMassiveMincut');
    v_ignore_check_valves = (SELECT value::boolean FROM config_param_system WHERE parameter = 'ignoreCheckValvesMincut');
    v_execute_massive_mincut = (p_data->'data'->'parameters'->>'executeMassiveMincut')::BOOLEAN;
    v_ignore_unaccess_valves = (p_data->'data'->'parameters'->>'ignoreUnaccessValvesMincut')::BOOLEAN;
    v_ignore_changestatus_valves = (p_data->'data'->'parameters'->>'ignoreChangeStatusValvesMincut')::BOOLEAN;

    v_day_start = (p_data->'data'->'parameters'->>'dayStart')::TIMESTAMP;
    v_day_end = (p_data->'data'->'parameters'->>'dayEnd')::TIMESTAMP;

    IF v_day_start IS NULL THEN
        v_day_start = now()::TIMESTAMP;
    END IF;
    IF v_day_end IS NULL THEN
        v_day_end = (now() + interval '1 day')::TIMESTAMP;
    END IF;

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
    v_query_text := '
        SELECT arc_id AS id, node_1 AS source, node_2 AS target, 1 AS cost 
        FROM v_temp_arc
    ';

    IF v_expl_id_array IS NOT NULL THEN
        v_query_text_components := '
                WHERE EXISTS (
                    SELECT 1
                    FROM v_temp_arc v
                    WHERE v.expl_id = ANY (ARRAY['||array_to_string(v_expl_id_array, ',')||']) 
                    AND v.node_1 = c.node
                )
            ';
    ELSE
        v_query_text_components := '';
    END IF;

    EXECUTE format('
        WITH connectedcomponents AS (
            SELECT * FROM pgr_connectedcomponents($q$ %s $q$)
        ),
        components AS (
            SELECT c.component
            FROM connectedcomponents c
            %s
            GROUP BY c.component
        )
        INSERT INTO temp_pgr_node (pgr_node_id)
        SELECT c.node
        FROM connectedcomponents c
        WHERE EXISTS (
            SELECT 1
            FROM components cc
            WHERE cc.component = c.component
        );
    ', v_query_text, v_query_text_components);

    INSERT INTO temp_pgr_arc (pgr_arc_id, pgr_node_1, pgr_node_2)
    SELECT a.arc_id, a.node_1, a.node_2
    FROM v_temp_arc a
    WHERE EXISTS (SELECT 1 FROM temp_pgr_node n WHERE n.pgr_node_id = a.node_1)
    AND EXISTS (SELECT 1 FROM temp_pgr_node n WHERE n.pgr_node_id = a.node_2);

    -- Preparing minsectors
    -- =======================

    UPDATE temp_pgr_node n
    SET old_mapzone_id = t.minsector_id
    FROM v_temp_node t
    WHERE n.pgr_node_id = t.node_id;

    UPDATE temp_pgr_arc a
    SET old_mapzone_id = t.minsector_id 
    FROM v_temp_arc t
    WHERE a.pgr_arc_id = t.arc_id;

    -- nodes water sources (SECTOR)
    -- tank, source, waterwell, wtp
    UPDATE temp_pgr_node t
    SET graph_delimiter = 'SECTOR'
    FROM v_temp_node n
    JOIN (
        SELECT node_id FROM man_tank
        UNION ALL
        SELECT node_id FROM man_source
        UNION ALL
        SELECT node_id FROM man_waterwell
        UNION ALL
        SELECT node_id FROM man_wtp
    ) m ON m.node_id = n.node_id
    WHERE 'SECTOR' = ANY(n.graph_delimiter) 
    AND t.pgr_node_id = n.node_id;

    -- nodes valves (MINSECTOR)
    UPDATE temp_pgr_node t
    SET graph_delimiter = 'MINSECTOR'
    FROM v_temp_node n
    JOIN man_valve m USING (node_id)
    WHERE 'MINSECTOR' = ANY(n.graph_delimiter)
    AND t.pgr_node_id = n.node_id; 

    -- generate lineGraph (pgr_node_1 and pgr_node_2 are arc_id)
    INSERT INTO temp_pgr_arc_linegraph (
        pgr_arc_id, pgr_node_1, pgr_node_2, cost, reverse_cost
    )
    SELECT seq, source, target, cost, -1
    FROM pgr_linegraph(
        'SELECT pgr_arc_id AS id,
                pgr_node_1 AS source,
                pgr_node_2 AS target,
                1 AS cost
        FROM temp_pgr_arc',
        directed => FALSE
    );

    -- update cost = -1 for graph_delimiter = SECTOR, MINSECTOR
    --checking node_1 for arc_1
    UPDATE temp_pgr_arc_linegraph t
    SET cost = -1
    FROM temp_pgr_arc_linegraph ta
    JOIN temp_pgr_arc a1 ON ta.pgr_node_1 = a1.pgr_arc_id
    JOIN temp_pgr_arc a2 ON ta.pgr_node_2 = a2.pgr_arc_id
    WHERE EXISTS (
        SELECT 1
        FROM temp_pgr_node n
        WHERE n.graph_delimiter <> 'NONE'
        AND n.pgr_node_id = a1.pgr_node_1
    )
    AND (a1.pgr_node_1 = a2.pgr_node_1 OR a1.pgr_node_1 = a2.pgr_node_2)
    AND ta.pgr_arc_id = t.pgr_arc_id;

    --checking node_2 for arc_1
    UPDATE temp_pgr_arc_linegraph t
    SET cost = -1
    FROM temp_pgr_arc_linegraph ta
    JOIN temp_pgr_arc a1 ON ta.pgr_node_1 = a1.pgr_arc_id
    JOIN temp_pgr_arc a2 ON ta.pgr_node_2 = a2.pgr_arc_id
    WHERE EXISTS (
        SELECT 1
        FROM temp_pgr_node n
        WHERE n.graph_delimiter <> 'NONE'
        AND n.pgr_node_id = a1.pgr_node_2
    )
    AND (a1.pgr_node_2 = a2.pgr_node_1 OR a1.pgr_node_2 = a2.pgr_node_2)
    AND ta.pgr_arc_id = t.pgr_arc_id;

    -- Generate the minsectors
    v_query_text :=
    'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost 
    FROM temp_pgr_arc_linegraph';

    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node FROM pgr_connectedcomponents(v_query_text);

    -- Update the mapzone_id field for arcs (mapzone_id = min(arc_id) for the connected arcs)
    UPDATE temp_pgr_arc a 
    SET mapzone_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE a.pgr_arc_id = c.node;

    -- update mapzone_id for arcs that have node_1 and node_2 graph_delimiters 
    UPDATE temp_pgr_arc 
    SET mapzone_id = pgr_arc_id
    WHERE mapzone_id = 0;

    -- Update the mapzone_id field for nodes, except nodes that are graph_delimiter = 'SECTOR' or are in between minsectors (valves)
    UPDATE temp_pgr_node t
    SET mapzone_id = n.mapzone_id
    FROM (
        SELECT n.pgr_node_id, min(a.mapzone_id) AS mapzone_id
        FROM temp_pgr_node n
        JOIN temp_pgr_arc a ON n.pgr_node_id = a.pgr_node_1 OR n.pgr_node_id = a.pgr_node_2
        WHERE n.graph_delimiter <> 'SECTOR'
        GROUP BY n.pgr_node_id
        HAVING count(DISTINCT a.mapzone_id) = 1
    ) n
    WHERE t.pgr_node_id = n.pgr_node_id;

    -- fill temp_pgr_minsector_graph
    INSERT INTO temp_pgr_minsector_graph (node_id, minsector_1, minsector_2)
    SELECT n.pgr_node_id, min(a.mapzone_id) AS minsector_1, max(a.mapzone_id) AS minsector_2
    FROM temp_pgr_node n
    JOIN temp_pgr_arc a ON n.pgr_node_id = a.pgr_node_1 OR n.pgr_node_id = a.pgr_node_2
    WHERE n.graph_delimiter = 'MINSECTOR'
    GROUP BY n.pgr_node_id
    HAVING count(DISTINCT a.mapzone_id) = 2;

    -- fill temp_pgr_minsector
    INSERT INTO temp_pgr_minsector(minsector_id)
    SELECT DISTINCT mapzone_id
    FROM temp_pgr_arc
    WHERE mapzone_id > 0;

    -- Update minsector temporary num_border
    UPDATE temp_pgr_minsector t
    SET num_border = a.num_border 
    FROM (
        SELECT m.minsector_id, count(*) AS num_border
        FROM temp_pgr_minsector m
        JOIN temp_pgr_minsector_graph g ON m.minsector_id = g.minsector_1 OR m.minsector_id = minsector_2
        GROUP BY m.minsector_id
    ) a
    WHERE t.minsector_id = a.minsector_id;

    UPDATE temp_pgr_minsector SET num_border = 0 WHERE num_border IS NULL;

    -- Update minsector temporary num_connec
    UPDATE temp_pgr_minsector t SET num_connec = c.num_connec
    FROM (
        SELECT a.mapzone_id, COUNT(*) AS num_connec
        FROM temp_pgr_arc a 
        JOIN v_temp_connec v on v.arc_id = a.pgr_arc_id
        WHERE a.mapzone_id > 0
        GROUP BY a.mapzone_id
    ) c WHERE c.mapzone_id = t.minsector_id;

    UPDATE temp_pgr_minsector SET num_connec = 0 WHERE num_connec IS NULL;

    -- Update minsector temporary num_hydro
    WITH
        hydrometer AS (
            SELECT h.hydrometer_id, a.mapzone_id
            FROM rtc_hydrometer_x_connec h
            JOIN v_temp_connec c USING (connec_id)
            JOIN temp_pgr_arc a ON a.pgr_arc_id = c.arc_id
            WHERE a.mapzone_id > 0
            UNION
            SELECT h.hydrometer_id, n.mapzone_id
            FROM rtc_hydrometer_x_node h
            JOIN temp_pgr_node n ON n.pgr_node_id = h.node_id
            WHERE n.mapzone_id > 0
        ),
        hydrometer_result AS (
            SELECT h.mapzone_id, count(*) AS num_hydro
            FROM hydrometer h
            JOIN ext_rtc_hydrometer e ON e.hydrometer_id = h.hydrometer_id
            WHERE e.state_id IN (
                SELECT (json_array_elements_text((value::json->>'1')::json))::INTEGER 
                FROM config_param_system where parameter  = 'admin_hydrometer_state'
            )
            GROUP BY h.mapzone_id
        )
    UPDATE temp_pgr_minsector t
    SET num_hydro = h.num_hydro
    FROM hydrometer_result h
    WHERE t.minsector_id = h.mapzone_id;

    UPDATE temp_pgr_minsector SET num_hydro = 0 WHERE num_hydro IS NULL;

    -- Update minsector temporary length
    UPDATE temp_pgr_minsector SET length = b.length 
    FROM (
        SELECT ta.mapzone_id AS minsector_id, SUM(st_length2d(va.the_geom)::NUMERIC(12,2)) AS length
        FROM temp_pgr_arc ta
        JOIN v_temp_arc va ON va.arc_id = ta.pgr_arc_id
        WHERE ta.mapzone_id > 0
        GROUP BY ta.mapzone_id
    ) b
    WHERE b.minsector_id = temp_pgr_minsector.minsector_id;

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
                        JOIN v_temp_arc v ON v.arc_id = t.pgr_arc_id
                        GROUP BY t.mapzone_id
                    )
                    SELECT 
                        minsector_id, 
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
                JOIN v_temp_arc v ON v.arc_id = t.pgr_arc_id
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
                    JOIN v_temp_arc v ON v.arc_id = t.pgr_arc_id
                    WHERE mapzone_id::integer > 0
                    GROUP BY t.mapzone_id 
                    UNION
                    SELECT t.mapzone_id AS minsector_id, ST_Collect(ext_plot.the_geom) AS geom 
                    FROM temp_pgr_arc t 
                    JOIN v_temp_connec vc ON vc.arc_id = t.pgr_arc_id
                    LEFT JOIN ext_plot ON vc.plot_code = ext_plot.plot_code AND ST_DWithin(vc.the_geom, ext_plot.the_geom, 0.001)
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
            ta.mapzone_id AS minsector_id,
            array_agg(DISTINCT va.expl_id) AS expl_id_arr,
            array_agg(DISTINCT va.dma_id) AS dma_id_arr,
            array_agg(DISTINCT va.dqa_id) AS dqa_id_arr,
            array_agg(DISTINCT va.muni_id) AS muni_id_arr,
            array_agg(DISTINCT va.sector_id) AS sector_id_arr,
            array_agg(DISTINCT va.supplyzone_id) AS supplyzone_id_arr
        FROM temp_pgr_arc ta
        JOIN v_temp_arc va ON va.arc_id = ta.pgr_arc_id
        GROUP BY ta.mapzone_id
    ) sub
    WHERE sub.minsector_id = t.minsector_id;

    IF v_commitchanges IS FALSE THEN
        -- (sin cambios aquí: no hay referencias a temp_pgr_node/temp_pgr_arc con campos antiguos)

        v_visible_layer = NULL;

        -- Message
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4020", "function":"2706", "fid":"'||v_fid||'", "prefix_id": "1001", "is_process":true}}$$)';

    ELSE

        -- SET minsector_id = 0
        UPDATE arc a SET minsector_id = 0
        WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old m
            WHERE a.minsector_id = m.old_mapzone_id
        )
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_arc ta 
            WHERE ta.pgr_arc_id = a.arc_id
        )
        AND a.minsector_id IS DISTINCT FROM 0;

        UPDATE node n SET minsector_id = 0
        WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old m
            WHERE n.minsector_id = m.old_mapzone_id
        )
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_node tn
            WHERE tn.pgr_node_id = n.node_id
        )
        AND n.minsector_id IS DISTINCT FROM 0;

        UPDATE connec c SET minsector_id = 0
        WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old m
            WHERE c.minsector_id = m.old_mapzone_id
        )
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_arc ta 
            JOIN v_temp_connec vc ON ta.pgr_arc_id = vc.arc_id
            WHERE vc.connec_id = c.connec_id
        )
        AND c.minsector_id IS DISTINCT FROM 0;

        UPDATE link l SET minsector_id = 0
        WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old m
            WHERE l.minsector_id = m.old_mapzone_id
        )
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_arc ta 
            JOIN v_temp_link_connec vl ON ta.pgr_arc_id = vl.arc_id
            WHERE vl.link_id = l.link_id
        )
        AND l.minsector_id IS DISTINCT FROM 0;

        -- Avoid crashing the foreign key table(minsector_id) by setting minsector_id = 0 before deleting the minsector from the parent table
        UPDATE arc a SET minsector_id = 0
        WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old m
            WHERE a.minsector_id = m.old_mapzone_id
        )
        AND EXISTS (
            SELECT 1 FROM temp_pgr_arc ta 
            WHERE ta.pgr_arc_id = a.arc_id
        )
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_minsector tpm
            WHERE tpm.minsector_id = a.minsector_id
        )
        AND a.minsector_id IS DISTINCT FROM 0;

        UPDATE node n SET minsector_id = 0
        WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old m
            WHERE n.minsector_id = m.old_mapzone_id
        )
        AND EXISTS (
            SELECT 1 FROM temp_pgr_node tn
            WHERE tn.pgr_node_id = n.node_id
        )
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_minsector tpm
            WHERE tpm.minsector_id = n.minsector_id
        )
        AND n.minsector_id IS DISTINCT FROM 0;

        UPDATE connec c SET minsector_id = 0
        WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old m
            WHERE c.minsector_id = m.old_mapzone_id
        )
        AND EXISTS (
            SELECT 1 FROM temp_pgr_arc ta 
            JOIN v_temp_connec vc ON ta.pgr_arc_id = vc.arc_id
            WHERE ta.mapzone_id = c.minsector_id
        )
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_minsector tpm
            WHERE tpm.minsector_id = c.minsector_id
        )
        AND c.minsector_id IS DISTINCT FROM 0;

        UPDATE link l SET minsector_id = 0
        WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old m
            WHERE l.minsector_id = m.old_mapzone_id
        )
        AND EXISTS (
            SELECT 1 FROM temp_pgr_arc ta 
            JOIN v_temp_link_connec vl ON ta.pgr_arc_id = vl.arc_id
            WHERE ta.mapzone_id = l.minsector_id
        )
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_minsector tpm
            WHERE tpm.minsector_id = l.minsector_id
        )
        AND l.minsector_id IS DISTINCT FROM 0;

        -- Update minsector
        DELETE FROM minsector m
        WHERE EXISTS (
            SELECT 1 FROM v_temp_pgr_mapzone_old mo
            WHERE m.minsector_id = mo.old_mapzone_id
        )
        AND NOT EXISTS (
            SELECT 1 FROM temp_pgr_minsector tpm
            WHERE m.minsector_id = tpm.minsector_id
        );

        INSERT INTO minsector (minsector_id)
        SELECT tpm.minsector_id
        FROM temp_pgr_minsector tpm
        WHERE NOT EXISTS (
            SELECT 1 
            FROM minsector m 
            WHERE tpm.minsector_id = m.minsector_id
        );

        UPDATE minsector m
        SET num_border = tpm.num_border,
            num_connec = tpm.num_connec,
            num_hydro = tpm.num_hydro,
            length = tpm.length,
            the_geom = tpm.the_geom,
            expl_id = tpm.expl_id,
            dma_id = tpm.dma_id,
            dqa_id = tpm.dqa_id,
            muni_id = tpm.muni_id,
            sector_id = tpm.sector_id,
            supplyzone_id = tpm.supplyzone_id
        FROM temp_pgr_minsector tpm
        WHERE tpm.minsector_id = m.minsector_id;

        -- update minsector_graph
        DELETE FROM minsector_graph mg
        WHERE EXISTS (
            SELECT 1 FROM temp_pgr_minsector m WHERE mg.minsector_1 = m.minsector_id
        )
        OR EXISTS (
            SELECT 1 FROM temp_pgr_minsector m WHERE mg.minsector_2 = m.minsector_id
        );

        INSERT INTO minsector_graph (node_id, minsector_1, minsector_2)
        SELECT node_id, minsector_1, minsector_2 FROM temp_pgr_minsector_graph;

        -- update arc, node, connec, link
        UPDATE arc a
        SET minsector_id = t.mapzone_id
        FROM temp_pgr_arc t
        WHERE a.arc_id = t.pgr_arc_id
        AND a.minsector_id IS DISTINCT FROM t.mapzone_id;

        UPDATE node n 
        SET minsector_id = t.mapzone_id
        FROM temp_pgr_node t
        WHERE n.node_id = t.pgr_node_id
        AND n.minsector_id IS DISTINCT FROM t.mapzone_id;

        UPDATE connec c
        SET minsector_id = t.mapzone_id
        FROM temp_pgr_arc t
        JOIN v_temp_connec vc ON vc.arc_id = t.pgr_arc_id
        WHERE c.connec_id = vc.connec_id
        AND c.minsector_id IS DISTINCT FROM t.mapzone_id;

        UPDATE link l
        SET minsector_id = t.mapzone_id
        FROM temp_pgr_arc t
        JOIN v_temp_link_connec vl ON vl.arc_id = t.pgr_arc_id
        WHERE l.link_id = vl.link_id
        AND l.minsector_id IS DISTINCT FROM t.mapzone_id;

        v_visible_layer = '"ve_minsector"';

    END IF;

    IF v_execute_massive_mincut THEN
        -- PREPARE tables for Massive Mincut
        -- Initialize process
        -- =======================
        TRUNCATE temp_pgr_arc_linegraph;

        -- insert MINSECTOR nodes
        INSERT INTO temp_pgr_node_minsector (pgr_node_id, graph_delimiter)
        SELECT minsector_id, 'MINSECTOR' FROM temp_pgr_minsector;

        -- MINSECTORS that contain an arc that connects to a water source and is not inlet_arc WILL BE A WATER SECTOR (graph_delimiter as 'SECTOR')
        -- TANK, SOURCE, WATERWELL, WTP
        WITH 
            sector_water AS ( 
                SELECT m.node_id, m.inlet_arc
                FROM man_tank m
                JOIN temp_pgr_node n USING (node_id)
                WHERE 'SECTOR' = n.graph_delimiter
                UNION ALL  
                SELECT m.node_id, m.inlet_arc
                FROM man_source m
                JOIN temp_pgr_node n USING (node_id)
                WHERE 'SECTOR' = n.graph_delimiter
                UNION ALL
                SELECT m.node_id, m.inlet_arc
                FROM man_waterwell m
                JOIN temp_pgr_node n USING (node_id)
                WHERE 'SECTOR' = n.graph_delimiter 
                UNION ALL
                SELECT m.node_id, m.inlet_arc
                FROM man_wtp m
                JOIN temp_pgr_node n USING (node_id)
                WHERE 'SECTOR' = n.graph_delimiter
            )
        UPDATE temp_pgr_node_minsector t
        SET graph_delimiter = 'SECTOR'
        WHERE EXISTS (
            SELECT 1
            FROM temp_pgr_arc a
            LEFT JOIN sector_water s1 ON a.node_1 = s1.node_id
            LEFT JOIN sector_water s2 ON a.node_2 = s2.node_id
            WHERE t.pgr_node_id = a.mapzone_id
            AND (
                (s1.node_id IS NOT NULL AND a.pgr_arc_id <> ALL(COALESCE(s1.inlet_arc,ARRAY[]::int[])))
                OR
                (s2.node_id IS NOT NULL AND a.pgr_arc_id <> ALL(COALESCE(s2.inlet_arc,ARRAY[]::int[])))
            )
        );

        -- insert the valves as arcs;
        -- the table that is used: temp_pgr_arc_linegraph where pgr_node_id is the valve and pgr_node_1/pgr_node_2 are the connected minsectors
        INSERT INTO temp_pgr_arc_linegraph (pgr_node_id, pgr_node_1, pgr_node_2, graph_delimiter, cost, reverse_cost, cost_mincut, reverse_cost_mincut, closed, broken, to_arc)
        SELECT t.node_id, t.minsector_1, t.minsector_2, 'MINSECTOR', 1, 1, -1, -1, m.closed, m.broken,
            CASE
                WHEN m.to_arc IS NULL THEN NULL
                ELSE ARRAY[m.to_arc]
            END AS to_arc
        FROM temp_pgr_minsector_graph t
        JOIN man_valve m ON t.node_id = m.node_id;

        -- UPDATE cost/reverse_cost
        -- close valves
        UPDATE temp_pgr_arc_linegraph t
        SET cost = -1, reverse_cost = -1
        WHERE t.closed = TRUE;

        -- operative checkvalves
        UPDATE temp_pgr_arc_linegraph t
        SET cost = CASE WHEN EXISTS (SELECT 1 FROM temp_pgr_arc a WHERE t.to_arc[1] = a.pgr_arc_id  AND t.pgr_node_2 = a.mapzone_id) THEN 1 ELSE -1 END,
            reverse_cost = CASE WHEN EXISTS (SELECT 1 FROM temp_pgr_arc a WHERE t.to_arc[1] = a.pgr_arc_id AND t.pgr_node_2 = a.mapzone_id) THEN -1 ELSE 1 END
        WHERE t.closed = FALSE 
        AND t.broken = FALSE
        AND t.to_arc IS NOT NULL;

        -- UPDATE cost_mincut/reverse_cost_mincut
        -- ignore_broken_valves 
        IF v_ignore_broken_valves THEN
            UPDATE temp_pgr_arc_linegraph t
            SET cost_mincut = 0, reverse_cost_mincut = 0
            WHERE t.closed = FALSE
            AND t.broken = TRUE;
        END IF;

        -- operative checkvalves
        IF v_ignore_check_valves THEN
            UPDATE temp_pgr_arc_linegraph t
            SET cost_mincut = 0, reverse_cost_mincut = 0
            WHERE t.closed = FALSE
            AND t.broken = FALSE
            AND t.to_arc IS NOT NULL;
        ELSE
            UPDATE temp_pgr_arc_linegraph t
            SET cost_mincut = cost, reverse_cost_mincut = reverse_cost
            WHERE t.closed = FALSE
            AND t.broken = FALSE
            AND t.to_arc IS NOT NULL;
        END IF;

        -- the unaccess valves
        IF v_ignore_unaccess_valves = FALSE THEN
            EXECUTE format('
                WITH today_mincuts AS (
                    SELECT o.id AS result_id
                    FROM om_mincut o
                    JOIN om_mincut_cat_type c ON o.mincut_type = c.id
                    WHERE o.mincut_state IN (%s, %s)
                        AND o.mincut_class = %s
                        AND c.virtual = FALSE
                        AND o.forecast_start <= o.forecast_end
                        AND tsrange(o.forecast_start, o.forecast_end, ''[]'') && tsrange(%L, %L, ''[]'')
                )
                UPDATE temp_pgr_arc_linegraph tpa
                SET unaccess = TRUE, cost_mincut = 0, reverse_cost_mincut = 0
                WHERE tpa.closed = FALSE
                AND tpa.to_arc IS NULL
                AND EXISTS (
                    SELECT 1
                    FROM om_mincut_valve omv
                    JOIN today_mincuts tm USING (result_id)
                    WHERE omv.unaccess = TRUE
                        AND omv.node_id = tpa.pgr_node_id
                );',
                v_mincut_plannified_state, v_mincut_in_progress_state,
                v_mincut_network_class,
                v_day_start, v_day_end
            );
        END IF;

        -- the changestatus valves
        IF v_ignore_changestatus_valves = FALSE THEN
            EXECUTE format('
                WITH today_mincuts AS (
                    SELECT o.id AS result_id
                    FROM om_mincut o
                    JOIN om_mincut_cat_type c ON o.mincut_type = c.id
                    WHERE o.mincut_state IN (%s, %s)
                        AND o.mincut_class = %s
                        AND c.virtual = FALSE
                        AND o.forecast_start <= o.forecast_end
                        AND tsrange(o.forecast_start, o.forecast_end, ''[]'') && tsrange(%L, %L, ''[]'')
                )
                UPDATE temp_pgr_arc_linegraph tpa
                SET changestatus = TRUE, cost = 0, reverse_cost = 0
                WHERE tpa.closed = TRUE AND tpa.broken = FALSE AND tpa.to_arc IS NULL
                AND EXISTS (
                    SELECT 1
                    FROM om_mincut_valve omv
                    JOIN today_mincuts tm USING (result_id)
                    WHERE omv.changestatus = TRUE
                        AND omv.node_id = tpa.pgr_node_id
                );',
                v_mincut_plannified_state, v_mincut_in_progress_state,
                v_mincut_network_class,
                v_day_start, v_day_end
            );
        END IF;

        -- FINISH preparing

        -- CORE MASSIVE MINCUT
        -- insert minsectors with num_border = 0
        INSERT INTO temp_pgr_minsector_mincut (minsector_id, mincut_minsector_id)
        SELECT minsector_id, minsector_id
        FROM temp_pgr_minsector
        WHERE num_border = 0;

        v_query_text = '
            SELECT minsector_id AS pgr_node_id
            FROM temp_pgr_minsector
            WHERE num_border > 0
        ';

        SELECT count(*)::float INTO v_pgr_distance FROM temp_pgr_arc_linegraph;

        FOR v_record_minsector IN EXECUTE v_query_text LOOP

            UPDATE temp_pgr_arc_linegraph SET mapzone_id = 0 WHERE mapzone_id <> 0;
            UPDATE temp_pgr_node_minsector SET mapzone_id = 0 WHERE mapzone_id <> 0;
            UPDATE temp_pgr_arc_linegraph SET proposed = FALSE WHERE proposed;

            v_data := jsonb_build_object(
                'data', jsonb_build_object(
                    'pgrDistance', v_pgr_distance,
                    'pgrRootVids', ARRAY[v_record_minsector.pgr_node_id],
                    'ignoreCheckValvesMincut', v_ignore_check_valves,
                    'mode', 'MINSECTOR'
                )
            )::text;

            v_response := gw_fct_mincut_core(v_data);

            IF v_response->>'status' <> 'Accepted' THEN
                RETURN v_response;
            END IF;

            -- insert the mincut_minsector_id
            INSERT INTO temp_pgr_minsector_mincut (minsector_id, mincut_minsector_id)
            SELECT v_record_minsector.pgr_node_id, n.pgr_node_id
            FROM temp_pgr_node_minsector n
            WHERE n.graph_delimiter = 'MINSECTOR'
            AND n.mapzone_id <> 0;

            INSERT INTO temp_pgr_minsector_mincut_valve
                (minsector_id, node_id, proposed, closed, broken, unaccess, to_arc, changestatus)
            SELECT v_record_minsector.pgr_node_id, a.pgr_node_id, a.proposed, a.closed, a.broken, a.unaccess, a.to_arc[1], changestatus
            FROM temp_pgr_arc_linegraph a
            WHERE a.graph_delimiter = 'MINSECTOR'
            AND a.mapzone_id <> 0;

        END LOOP;

        IF v_commitchanges THEN
            INSERT INTO minsector_mincut (minsector_id, mincut_minsector_id)
            SELECT minsector_id, mincut_minsector_id
            FROM temp_pgr_minsector_mincut;

            INSERT INTO minsector_mincut_valve (minsector_id, node_id, proposed, closed, broken, unaccess, to_arc, changestatus)
            SELECT minsector_id, node_id, proposed, closed, broken, unaccess, to_arc, changestatus
            FROM temp_pgr_minsector_mincut_valve;
        END IF;

    END IF;

    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4354", "function":"2706", "fid":"'||v_fid||'", "is_process":true, "tempTable":"temp_"}}$$)';

    -- Info
    SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
    FROM (
        SELECT id, error_message AS message FROM temp_audit_check_data WHERE cur_user = current_user AND fid = v_fid ORDER BY id
    ) row;
    v_result := COALESCE(v_result, '{}');
    v_result_info := CONCAT('{"values":', v_result, '}');

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

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
