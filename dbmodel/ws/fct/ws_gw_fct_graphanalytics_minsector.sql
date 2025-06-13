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
	v_data := '{"data":{"expl_id_array":"' || v_expl_id_array || '", "mapzone_name":"MINSECTOR"}}';
    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

    -- Nodes at the limits of minsectors: nodes with "graph_delimiter" = 'MINSECTOR' or "graph_delimiter" = 'SECTOR'

    -- Set modif = TRUE for nodes where "graph_delimiter" = 'minsector'
    -- NODES VALVES
    UPDATE temp_pgr_node t
    SET graph_delimiter = 'minsector'
	FROM v_temp_node n
	WHERE t.node_id = n.node_id AND 'MINSECTOR' = ANY(n.graph_delimiter);

	-- UPDATE "closed", "broken", "to_arc" only if the values make sense - check the explanations/rules for the possible valve scenarios MINSECTOR/to_arc/closed/broken

	-- CLOSED valves with or without to_arc
	UPDATE temp_pgr_node t
    SET closed = v.closed,
        broken = v.broken,
        modif = TRUE
	FROM man_valve v
	WHERE t.node_id = v.node_id
        AND t.graph_delimiter = 'minsector'
        AND v.closed = TRUE;

	-- OPEN valves without to_arc
    IF v_ignorebrokenvalves THEN
        UPDATE temp_pgr_node t
        SET closed = v.closed,
            broken = v.broken,
            modif = TRUE
        FROM man_valve v
        WHERE t.node_id = v.node_id
            AND t.graph_delimiter = 'minsector'
            AND v.closed = FALSE
            AND v.to_arc IS NULL
            AND v.broken = FALSE ; -- only broken = false
    ELSE
        UPDATE temp_pgr_node t
        SET closed = v.closed,
            broken = v.broken,
            modif = TRUE
        FROM man_valve v
        WHERE t.node_id = v.node_id
            AND t.graph_delimiter = 'minsector'
            AND v.closed = FALSE
            AND v.to_arc IS NULL;
    END IF;

    -- OPEN valves WITH to_arc; only if broken = false
	UPDATE temp_pgr_node t
    SET closed = v.closed,
        broken = v.broken,
        to_arc = v.to_arc,
        modif = TRUE
	FROM man_valve v
	WHERE t.node_id = v.node_id
        AND t.graph_delimiter = 'minsector'
        AND v.closed = FALSE
        AND v.to_arc IS NOT NULL
        AND v.broken = FALSE;

	-- cost/reverse_cost for the valves with to_arc will be update after gw_fct_graphanalytics_arrangenetwork with the correct values

    -- Set modif = TRUE for nodes where "graph_delimiter" = 'sector'
    UPDATE temp_pgr_node t
    SET graph_delimiter = 'sector', modif = TRUE
    FROM v_temp_node n
    WHERE t.node_id = n.node_id AND t.graph_delimiter = 'none' AND 'SECTOR' = ANY(n.graph_delimiter);

    -- set inlet_arc
    UPDATE temp_pgr_node t
    SET inlet_arc = n.inlet_arc
    FROM man_tank n
    WHERE t.node_id = n.node_id AND t.graph_delimiter = 'sector' AND n.inlet_arc IS NOT NULL;

    UPDATE temp_pgr_node t
    SET inlet_arc = n.inlet_arc
    FROM man_source n
    WHERE t.node_id = n.node_id AND t.graph_delimiter = 'sector' AND n.inlet_arc IS NOT NULL;

    UPDATE temp_pgr_node t
    SET inlet_arc = n.inlet_arc
    FROM man_waterwell n
    WHERE t.node_id = n.node_id AND t.graph_delimiter = 'sector' AND n.inlet_arc IS NOT NULL;

    -- ARCS to be disconnected:
    -- ARCS VALVES
	-- for the valves without to_arc, one of the arcs that connect to the valve
	WITH
	arcs_selected AS (
		SELECT DISTINCT ON (n.pgr_node_id)
			a.pgr_arc_id,
			n.pgr_node_id,
			a.pgr_node_1,
			a.pgr_node_2
		FROM temp_pgr_node n
		JOIN temp_pgr_arc a ON n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
		WHERE n.graph_delimiter = 'minsector' AND n.modif = TRUE AND n.to_arc IS NULL
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
	SET
		modif1 = s.modif1,
		modif2 = s.modif2
	FROM arcs_modif s
	WHERE t.pgr_arc_id = s.pgr_arc_id;

    -- for the valves with to_arc NOT NULL, the InletArc - the one that is not to_arc
	WITH
	arcs_selected AS (
		SELECT
			a.pgr_arc_id,
			n.pgr_node_id,
			a.pgr_node_1,
			a.pgr_node_2
		FROM  temp_pgr_node n
		JOIN temp_pgr_arc a on n.pgr_node_id in (a.pgr_node_1, a.pgr_node_2)
		WHERE n.graph_delimiter = 'minsector' AND n.modif = TRUE AND n.to_arc IS NOT NULL AND a.arc_id <> n.to_arc
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

    -- update cost/reverse_cost for minsectors(to_arc) anf sector(inlet_arc); are used for massive mincut

    -- for closed valves
    UPDATE temp_pgr_arc a
	SET cost = -1, reverse_cost = -1
	FROM temp_pgr_node n
	WHERE n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
    AND a.graph_delimiter = 'minsector'
	AND n.closed = TRUE;

    -- for open valves with to_arc
    UPDATE temp_pgr_arc a
	SET cost = CASE WHEN a.pgr_node_1=n.pgr_node_id THEN -1 ELSE a.cost END,
		reverse_cost = CASE WHEN a.pgr_node_2=n.pgr_node_id THEN -1 ELSE a.reverse_cost END
	FROM temp_pgr_node n
	WHERE n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
	AND a.graph_delimiter = 'minsector'
    AND n.to_arc IS NOT NULL;

    -- for SECTORS - only the inlet arcs
    UPDATE temp_pgr_arc a
	SET cost = CASE WHEN a.pgr_node_1=n.pgr_node_id THEN -1 ELSE a.cost END,
		reverse_cost = CASE WHEN a.pgr_node_2=n.pgr_node_id THEN -1 ELSE a.reverse_cost END
	FROM temp_pgr_node n
	WHERE n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
	AND a.graph_delimiter = 'sector'
    AND a.old_arc_id = ANY (n.inlet_arc);

    -- Generate the minsectors
    v_query :=
    'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, 1 as cost 
    FROM temp_pgr_arc a
    WHERE a.arc_id IS NOT NULL';
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node FROM pgr_connectedcomponents(v_query);

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

    -- table used for Massive Mincut; for SECTORS, mapzone_id=0 is replaced for node_id; the node_id for Sectors don't exist in temp_pgr_minsector)
    INSERT INTO temp_pgr_minsector_edges (pgr_arc_id, graph_delimiter, minsector_1, minsector_2, cost, reverse_cost)
    SELECT a.pgr_arc_id, a.graph_delimiter,
    COALESCE (NULLIF(n1.mapzone_id,0), a.node_1) AS minsector_1,
    COALESCE (NULLIF(n2.mapzone_id,0), a.node_2) AS minsector_2,
    a.cost, a.reverse_cost
    FROM temp_pgr_arc a
    JOIN temp_pgr_node n1 ON n1.pgr_node_id = a.pgr_node_1
    JOIN temp_pgr_node n2 ON n2.pgr_node_id = a.pgr_node_2
    WHERE arc_id IS NULL
    AND  n1.mapzone_id <> n2.mapzone_id;

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
                    num_border, num_connec, num_hydro, length, the_geom, ''v_edit_minsector'' AS layer 
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
                    num_border, num_connec, num_hydro, length, the_geom, ''v_edit_minsector_mincut'' AS layer 
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

        v_visible_layer ='"v_edit_minsector", "v_edit_minsector_mincut"';

        -- Message
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4022", "function":"2706", "fid":"'||v_fid||'", "prefix_id": "1001",	 "is_process":true}}$$)';

    END IF;

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

    -- Return
    RETURN gw_fct_json_create_return(
        ('{"status":"Accepted", "message":{"level":1, "text":"Mapzones dynamic analysis done successfully"}, "version":"' || v_version || '"' ||
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
