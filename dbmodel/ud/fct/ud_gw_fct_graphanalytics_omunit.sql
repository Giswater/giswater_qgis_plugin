/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3492

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_omunit(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_omunit(p_data json)
RETURNS json AS
$BODY$

/*
TO EXECUTE

SELECT gw_fct_graphanalytics_omunit($$
	{
		"data":{
			"parameters":{
				"exploitation":"1",
				"updateMapZone":2,
				"geomParamUpdate":15,
				"commitChanges":true,
				"usePlanPsector":false
			}
		}
	}
$$);

--fid: 640

*/

DECLARE

    -- dialog
    v_expl_id TEXT;
    v_expl_id_array INTEGER[];
    v_usepsector BOOLEAN;
    v_updatemapzgeom INTEGER;
    v_geomparamupdate FLOAT;
    v_commitchanges BOOLEAN;

    v_data JSON;

    v_fid INTEGER = 640;
    v_query_text TEXT;

    v_version TEXT;
    v_srid INTEGER;

    v_visible_layer TEXT;

    v_response JSON;

    v_result_info JSON;
    v_result_point JSON;
    v_result_line JSON;
    v_result_polygon JSON;
    v_result TEXT;

	-- LOCK LEVEL LOGIC
	v_original_disable_locklevel json;

    -- general variables
    v_pgr_distance INTEGER;
    v_root_vids int[];
    
    -- parameters

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

    -- it's not allowed to commit changes when psectors are used
 	IF v_usepsector AND v_commitchanges THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4542", "function":"2706", "parameters":null}}$$);';
	END IF;

    -- Get exploitation ID array
    v_expl_id_array := gw_fct_get_expl_id_array(v_expl_id);

    -- if v_expl_id_array is null, return error
    IF v_expl_id_array IS NULL THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		       	"data":{"message":"4478", "function":"3492","parameters":null}}$$);';
    END IF;

    -- Get user variable for disabling lock level
    SELECT value::json INTO v_original_disable_locklevel FROM config_param_user
    WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;
    -- Set disable lock level to true for this operation
    UPDATE config_param_user SET value = '{"update":true, "delete":true}'
    WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;

	-- Delete temporary tables
	-- =======================
	v_data := '{"data":{"action":"DROP", "fct_name":"OMUNIT"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

	IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- Create temporary tables
	-- =======================
    v_data := '{"data":{"action":"CREATE", "fct_name":"OMUNIT", "use_psector":"'|| v_usepsector ||'"}}';
	SELECT gw_fct_graphanalytics_manage_temporary(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;


	-- Starting process
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3492", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true", "separator_id":"2049", "tempTable":"temp_"}}$$)';

    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3492", "fid":"'||v_fid||'","criticity":"3", "tempTable":"temp_", "is_process":true, "is_header":"true", "label_id":"3003", "separator_id":"2011"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3492", "fid":"'||v_fid||'", "criticity":"2", "is_process":true, "separator_id":"2000", "tempTable":"temp_"}}$$)';
    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3492", "fid":"'||v_fid||'","criticity":"2", "tempTable":"temp_", "is_process":true, "is_header":"true", "label_id":"3002", "separator_id":"2014"}}$$)';
    EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"3492", "fid":"'||v_fid||'","criticity":"1", "tempTable":"temp_", "is_process":true, "is_header":"true", "label_id":"3001", "separator_id":"2007"}}$$)';

    -- Initialize process
	-- =======================
    v_query_text := $q$
        SELECT arc_id AS id, node_1 AS source, node_2 AS target, 1 AS cost
        FROM v_temp_arc
    $q$;

    -- INSERT
	EXECUTE format($sql$
        WITH connectedcomponents AS (
            SELECT *
            FROM pgr_connectedcomponents($q$%s$q$)
        ),
        components AS (
            SELECT c.component
            FROM connectedcomponents c
            WHERE cardinality($1) = 0
            OR EXISTS (
                SELECT 1
                FROM v_temp_arc v
                WHERE v.expl_id = ANY($1)
                AND v.node_1 = c.node
            )
            GROUP BY c.component
        )
        INSERT INTO temp_pgr_node (pgr_node_id)
        SELECT c.node
        FROM connectedcomponents c
        WHERE EXISTS (
            SELECT 1
            FROM components cc
            WHERE cc.component = c.component
        )
    $sql$, v_query_text)
    USING v_expl_id_array;

	INSERT INTO temp_pgr_arc (pgr_arc_id, pgr_node_1, pgr_node_2)
	SELECT a.arc_id, a.node_1, a.node_2
	FROM v_temp_arc a
	JOIN temp_pgr_node n1 ON n1.pgr_node_id = a.node_1
	JOIN temp_pgr_node n2 ON n2.pgr_node_id = a.node_2;

	INSERT INTO temp_pgr_connec (pgr_connec_id, pgr_arc_id)
	SELECT c.connec_id, c.arc_id
	FROM v_temp_connec c
	JOIN temp_pgr_arc a ON a.pgr_arc_id = c.arc_id;

    INSERT INTO temp_pgr_gully (pgr_gully_id, pgr_arc_id)
	SELECT g.gully_id, g.arc_id
	FROM v_temp_gully g
	JOIN temp_pgr_arc a ON a.pgr_arc_id = g.arc_id;

    INSERT INTO temp_pgr_old_mapzone (mapzone_id)
    SELECT DISTINCT a.omunit_id
    FROM temp_pgr_arc t
    JOIN arc a ON t.pgr_arc_id = a.arc_id
    WHERE a.omunit_id > 0;

    UPDATE temp_pgr_node t
    SET graph_delimiter = 'OMUNIT'
    FROM v_temp_node n
    WHERE 'OMUNIT' = ANY(n.graph_delimiter)
    AND t.pgr_node_id = n.node_id;

    --------------------------------------------------
    -- SECTION: Create omunits and macroomunits
    --------------------------------------------------

    -- fill table temp_pgr_arc_linegraph using pgr_lineGraph for oriented graphs 
    -- in the result, reverse_cost will be always -1
    -- pgr_node_1 and pgr_node_2 are connected arcs
    INSERT INTO temp_pgr_arc_linegraph (pgr_arc_id, pgr_node_1, pgr_node_2, COST, reverse_cost)
    SELECT seq, source, target, cost, reverse_cost
    FROM pgr_lineGraph(
        'SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, 1 as cost, -1 as reverse_cost
        FROM temp_pgr_arc',
        directed => true
    );

    -- CATCHMENTS
    -- choose the best candidate among TARGET ARCS (pgr_node_2); the ones that are not the best candidate will have graph_delimiter = 'CATCHMENT'; the best candidate will keep graph_delimiter = 'NONE'
    -- TODO improve the condition, add section and elevation (F_FACTOR)
    WITH 
        pair_arcs AS (
            SELECT 
                l.pgr_node_1, l.pgr_arc_id, l.pgr_node_2,
                CASE
                    WHEN a1.initoverflowpath = a2.initoverflowpath THEN 0  -- the same: first
                    ELSE 1                                        -- not the same: after
                END AS initoverflowpath,
                abs(st_azimuth(st_lineinterpolatepoint(a1.the_geom,0.99),st_endpoint(a1.the_geom))
                - st_azimuth(st_startpoint(a2.the_geom),st_lineinterpolatepoint(a2.the_geom,0.01)) 
                ) AS azimuth_difference
            FROM temp_pgr_arc_linegraph l
            JOIN arc a1 ON l.pgr_node_1 = a1.arc_id
            JOIN arc a2 ON l.pgr_node_2 = a2.arc_id
        ),
        best_pair AS (
            SELECT DISTINCT ON (pgr_node_1) pgr_node_1, pgr_node_2, pgr_arc_id
            FROM pair_arcs
            ORDER BY pgr_node_1, initoverflowpath, azimuth_difference, pgr_node_2
        )
    UPDATE temp_pgr_arc_linegraph l
    SET graph_delimiter = 'CATCHMENT'
    WHERE NOT EXISTS (SELECT 1 FROM best_pair bp WHERE bp.pgr_arc_id = l.pgr_arc_id);

    -- MACROOMUNITS
    -- choose the best candidate among SOURCE ARCS (pgr_node_1); the ones that are not the best candidate will have graph_delimiter = 'MACROOMUNIT'; 
    -- every macroomunit will be a chain, the relation between arcs-in and arcs-out of a node is 1:1
    -- TODO improve the condition, add section and elevation - if it's needed
    WITH 
        pair_arcs AS (
            SELECT 
                l.pgr_node_1, l.pgr_arc_id, l.pgr_node_2, l.graph_delimiter,
                CASE
                    WHEN a1.initoverflowpath = a2.initoverflowpath THEN 0  -- the same: first
                    ELSE 1                                        -- not the same: after
                END AS initoverflowpath,
                abs(st_azimuth(st_lineinterpolatepoint(a1.the_geom,0.99),st_endpoint(a1.the_geom))
                - st_azimuth(st_startpoint(a2.the_geom),st_lineinterpolatepoint(a2.the_geom,0.01)) 
                ) AS azimuth_difference
            FROM temp_pgr_arc_linegraph l
            JOIN arc a1 ON l.pgr_node_1 = a1.arc_id
            JOIN arc a2 ON l.pgr_node_2 = a2.arc_id
            WHERE graph_delimiter = 'NONE'
        ),
        best_pair AS (
            SELECT DISTINCT ON (pgr_node_2) pgr_node_2, pgr_node_1, pgr_arc_id
            FROM pair_arcs
            ORDER BY pgr_node_2, initoverflowpath, azimuth_difference, pgr_node_1
        )
    UPDATE temp_pgr_arc_linegraph l
    SET graph_delimiter = 'MACROOMUNIT'
    WHERE l.graph_delimiter = 'NONE'
    AND NOT EXISTS (SELECT 1 FROM best_pair bp WHERE bp.pgr_arc_id = l.pgr_arc_id);

    -- OMUNITS
    -- =======================
    --TODO maybe should be good checking the accessibility of the node with graph_delimiter = 'OMUNIT'
    UPDATE temp_pgr_arc_linegraph l
    SET graph_delimiter = 'OMUNIT'
    FROM temp_pgr_arc a
    WHERE l.graph_delimiter ='NONE'
        AND l.pgr_node_1 = a.pgr_arc_id
        AND EXISTS (
            SELECT 1 FROM temp_pgr_node n WHERE n.graph_delimiter = 'OMUNIT'
            AND a.pgr_node_2 = n.pgr_node_id   
        );

    -- generate omunit_id applying connectedComponents over temp_pgr_arc_linegraph filtering graph_delimiter = 'OMUNIT', 'MACROOMUNIT' AND 'CATCHMENT'
    TRUNCATE temp_pgr_connectedcomponents;
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node 
    FROM pgr_connectedcomponents(
        'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost 
        FROM temp_pgr_arc_linegraph
        WHERE graph_delimiter <> ''OMUNIT'' 
            AND graph_delimiter <> ''MACROOMUNIT'' 
            AND graph_delimiter <> ''CATCHMENT'' 
        '
    );

    -- Update the mapzone_id (omunit) for arcs
    UPDATE temp_pgr_arc a
    SET
        mapzone_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE a.pgr_arc_id = c.node;

    -- update omunit_id (mapzone_id) for arcs that have node_1 and node_2 graph_delimiters or isolated arcs
    UPDATE temp_pgr_arc a
    SET mapzone_id = pgr_arc_id
    WHERE mapzone_id = 0;

    -- fill table temp_pgr_omunit
    INSERT INTO temp_pgr_omunit (omunit_id)
    SELECT DISTINCT mapzone_id
    FROM temp_pgr_arc;

    WITH omunit_start AS (
        SELECT t.mapzone_id, t.pgr_node_1
        FROM temp_pgr_arc t
        GROUP BY t.mapzone_id, t.pgr_node_1
        HAVING NOT EXISTS (
            SELECT 1 
            FROM temp_pgr_arc t2
            WHERE t.mapzone_id = t2.mapzone_id 
            AND t.pgr_node_1 = t2.pgr_node_2
        )
    )
    UPDATE temp_pgr_omunit o
    SET node_1 = os.pgr_node_1
    FROM omunit_start os
    WHERE o.omunit_id = os.mapzone_id;

    WITH omunit_end AS (
        SELECT t.mapzone_id, t.pgr_node_2
        FROM temp_pgr_arc t
        GROUP BY t.mapzone_id, t.pgr_node_2
        HAVING NOT EXISTS (
            SELECT 1 
            FROM temp_pgr_arc t2
            WHERE t.mapzone_id = t2.mapzone_id 
            AND t.pgr_node_2 = t2.pgr_node_1
        )
    )
    UPDATE temp_pgr_omunit o
    SET node_2 = oe.pgr_node_2
    FROM omunit_end oe
    WHERE o.omunit_id = oe.mapzone_id;

    -- MACROOMUNITS
    -- =======================
    -- generate macroomunit_id applying connectedComponents over temp_pgr_arc_linegraph filtering graph_delimiter = 'MACROOMUNIT' and 'CATCHMENT'
    TRUNCATE temp_pgr_connectedcomponents;
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node 
    FROM pgr_connectedcomponents(
        'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost 
        FROM temp_pgr_arc_linegraph
        WHERE graph_delimiter <> ''MACROOMUNIT''
        AND graph_delimiter <> ''CATCHMENT'' 
        '
    );

    -- Update the macroomunit_id  for arcs
    UPDATE temp_pgr_arc a
    SET
        macromapzone_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE a.pgr_arc_id = c.node;

    -- update macroomunit_id for arcs that have node_1 and node_2 graph_delimiters or isolated arcs
    UPDATE temp_pgr_arc a
    SET macromapzone_id = pgr_arc_id
    WHERE macromapzone_id = 0;

    -- Update the macroomunit_id for omunit_id
    UPDATE temp_pgr_omunit o
    SET
        macroomunit_id = a.macroomunit_id
    FROM 
        (SELECT DISTINCT mapzone_id as omunit_id, macromapzone_id AS macroomunit_id
        FROM  temp_pgr_arc
        ) a
    WHERE o.omunit_id = a.omunit_id;

    -- fill table temp_pgr_macroomunit
    INSERT INTO temp_pgr_macroomunit (macroomunit_id)
    SELECT DISTINCT macroomunit_id
    FROM temp_pgr_omunit;

    WITH macroomunit_start AS (
        SELECT t.macromapzone_id, t.pgr_node_1
        FROM temp_pgr_arc t
        WHERE NOT EXISTS (
            SELECT 1 
            FROM temp_pgr_arc t2
            WHERE t.macromapzone_id = t2.macromapzone_id 
            AND t.pgr_node_1 = t2.pgr_node_2
        )
    )
    UPDATE temp_pgr_macroomunit o
    SET node_1 = os.pgr_node_1
    FROM macroomunit_start os
    WHERE o.macroomunit_id = os.macromapzone_id;

    WITH macroomunit_end AS (
        SELECT t.macromapzone_id, t.pgr_node_2
        FROM temp_pgr_arc t
        WHERE NOT EXISTS (
            SELECT 1 
            FROM temp_pgr_arc t2
            WHERE t.macromapzone_id = t2.macromapzone_id 
            AND t.pgr_node_2 = t2.pgr_node_1
        )
    )
    UPDATE temp_pgr_macroomunit o
    SET node_2 = oe.pgr_node_2
    FROM macroomunit_end oe
    WHERE o.macroomunit_id = oe.macromapzone_id;

    -- CATCHMENTS
    -- =======================
    -- generate catchment_id applying connectedComponents over temp_pgr_arc_linegraph filtering graph_delimiter = 'CATCHMENT'
    TRUNCATE temp_pgr_connectedcomponents;
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node 
    FROM pgr_connectedcomponents(
        'SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, cost 
        FROM temp_pgr_arc_linegraph
        WHERE graph_delimiter <> ''CATCHMENT'' 
        '
    );

    -- Update the catchment_id  for arcs
    UPDATE temp_pgr_arc a
    SET
        catchment_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE a.pgr_arc_id = c.node;

    -- update catchment_id for arcs that have node_1 and node_2 graph_delimiters or isolated arcs
    UPDATE temp_pgr_arc a
    SET catchment_id = pgr_arc_id
    WHERE catchment_id = 0;

    --update catchment_node for temp_pgr_macroomunit
    WITH 
        catchment_end AS (
            SELECT DISTINCT t.catchment_id, t.pgr_node_2
            FROM temp_pgr_arc t
            WHERE NOT EXISTS (
                SELECT 1 
                FROM temp_pgr_arc t2
                WHERE t.catchment_id = t2.catchment_id 
                AND t.pgr_node_2 = t2.pgr_node_1
            )
        )
    UPDATE temp_pgr_macroomunit m
    SET catchment_node = ce.pgr_node_2
    FROM (
        SELECT DISTINCT a.macromapzone_id, catchment_id
        FROM temp_pgr_arc a
    ) mc
    JOIN catchment_end ce ON mc.catchment_id = ce.catchment_id
    WHERE m.macroomunit_id = mc.macromapzone_id;

    -- update geometry of omunits
    v_query_text = '
        UPDATE temp_pgr_omunit o SET the_geom = b.the_geom
        FROM (
            SELECT t.mapzone_id AS omunit_id, ST_LineMerge(ST_Union(v.the_geom)) AS the_geom
            FROM temp_pgr_arc t
            JOIN arc v ON v.arc_id = t.pgr_arc_id 
            GROUP BY t.mapzone_id
        ) b 
        WHERE b.omunit_id = o.omunit_id;
    ';
    EXECUTE v_query_text;

    -- update geometry of macroomunits
    v_query_text = '
        UPDATE temp_pgr_macroomunit mo SET the_geom = b.the_geom
        FROM (
            SELECT o.macroomunit_id, ST_LineMerge(ST_Union(o.the_geom)) AS the_geom
            FROM temp_pgr_omunit o
            GROUP BY o.macroomunit_id
        ) b 
        WHERE b.macroomunit_id = mo.macroomunit_id;
    ';
    EXECUTE v_query_text;

    -- Update omunit expl_id, muni_id, sector_id
    UPDATE temp_pgr_omunit o
    SET expl_id = sub.expl_id_arr,
        muni_id = sub.muni_id_arr,
        sector_id = sub.sector_id_arr
    FROM (
        SELECT
            ta.mapzone_id AS omunit_id,
            array_agg(DISTINCT va.expl_id) AS expl_id_arr,
            array_agg(DISTINCT va.muni_id) AS muni_id_arr,
            array_agg(DISTINCT va.sector_id) AS sector_id_arr
        FROM temp_pgr_arc ta
        JOIN arc va ON va.arc_id = ta.pgr_arc_id
        GROUP BY ta.mapzone_id
    ) sub
    WHERE sub.omunit_id = o.omunit_id;

    -- Update macroomunit expl_id, muni_id, sector_id
     UPDATE temp_pgr_macroomunit mo
    SET expl_id = sub.expl_id_arr,
        muni_id = sub.muni_id_arr,
        sector_id = sub.sector_id_arr
    FROM (
        SELECT
            ta.macromapzone_id AS macroomunit_id,
            array_agg(DISTINCT va.expl_id) AS expl_id_arr,
            array_agg(DISTINCT va.muni_id) AS muni_id_arr,
            array_agg(DISTINCT va.sector_id) AS sector_id_arr
        FROM temp_pgr_arc ta
        JOIN arc va ON va.arc_id = ta.pgr_arc_id
        GROUP BY ta.macromapzone_id
    ) sub
    WHERE sub.macroomunit_id = mo.macroomunit_id;

    -- ORDER SECTION
    --==================================

    -- choose the arcs from where starts 
    
    SELECT array_agg(pgr_arc_id)::INT[] INTO v_root_vids
    FROM temp_pgr_arc a
    WHERE EXISTS (
        SELECT 1 FROM temp_pgr_macroomunit m
        WHERE m.catchment_node = a.pgr_node_2
    ); 

    -- use pgr_depthFirstSearch for the lineGraph of the network, from pgr_node_2 to pgr_node_1 
    -- TODO order using elev2 instead of macromapzone_id for a better ordering, could be faster
    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, node, edge, "cost", agg_cost)
    (
        SELECT seq, "depth", start_vid, node, edge, "cost", agg_cost
        FROM pgr_depthFirstSearch(
            'SELECT l.pgr_arc_id AS id, l.pgr_node_2 AS source, l.pgr_node_1 AS target, l.cost, l.reverse_cost 
            FROM temp_pgr_arc_linegraph l
            JOIN temp_pgr_arc a ON l. pgr_node_2 = a.pgr_arc_id
            WHERE l.graph_delimiter <> ''CATCHMENT''
            ',
        v_root_vids, directed => true)
    );

    -- order macroomunits
    WITH 
	root_vids AS (
		SELECT DISTINCT start_vid 
		FROM temp_pgr_drivingdistance
	),
	root_nodes AS (
		SELECT v.start_vid, a.pgr_node_2
		FROM root_vids v
		JOIN temp_pgr_arc a ON v.start_vid = a.pgr_arc_id
	),
	macroomunits AS (
		SELECT n.pgr_node_2 AS catchment_node, a.macromapzone_id AS macroomunit_id, min(d.seq) AS min_seq
		FROM temp_pgr_drivingdistance d
		JOIN root_nodes n ON d.start_vid = n.start_vid
		JOIN temp_pgr_arc a ON d.node = a.pgr_arc_id
		GROUP BY n.pgr_node_2, a.macromapzone_id
	),
	macroomunits_ordered AS (
		SELECT  catchment_node, macroomunit_id, ROW_NUMBER() OVER (PARTITION BY catchment_node ORDER BY catchment_node, min_seq desc) AS order_number
	FROM macroomunits
	)
	UPDATE temp_pgr_macroomunit m
	SET 
		order_number = mo.order_number
	FROM macroomunits_ordered mo 
	WHERE m.macroomunit_id = mo.macroomunit_id;

    -- order omunits
    WITH 
	omunits AS (
		SELECT a.macromapzone_id AS macroomunit_id, a.mapzone_id as omunit_id, min(d.seq) AS min_seq
		FROM temp_pgr_drivingdistance d
		JOIN temp_pgr_arc a ON d.node = a.pgr_arc_id
		GROUP BY a.macromapzone_id, a.mapzone_id
	),
	omunits_ordered AS (
		SELECT  macroomunit_id, omunit_id, ROW_NUMBER() OVER (PARTITION BY macroomunit_id ORDER BY macroomunit_id, min_seq desc) AS order_number
	FROM omunits
	)
	UPDATE temp_pgr_omunit o
	SET 
		order_number = oo.order_number
	FROM omunits_ordered oo 
	WHERE o.omunit_id = oo.omunit_id;

    --update order_number for isolated arcs
    UPDATE temp_pgr_omunit 
    SET order_number = 1
    WHERE order_number = 0;

    -- ENDSECTION

    v_result := COALESCE(v_result, '{}');
    v_result_info := CONCAT('{"values":', v_result, '}');

    -- Control nulls
    v_result_info := COALESCE(v_result_info, '{}');
    v_result_point := COALESCE(v_result_point, '{}');
    v_result_line := COALESCE(v_result_line, '{}');
    v_result_polygon := COALESCE(v_result_polygon, '{}');

	-- Restore original disable lock level
    UPDATE config_param_user SET value = v_original_disable_locklevel WHERE parameter = 'edit_disable_locklevel' AND cur_user = current_user;

    -- Return
    RETURN gw_fct_json_create_return(
        ('{"status":"Accepted", "message":{"level":1, "text":"Omunit dynamic analysis done successfully"}, "version":"' || v_version || '"' ||
        ',"body":{"form":{}' ||
        ',"data":{"info":' || v_result_info || ',' ||
        '"point":' || v_result_point || ',' ||
        '"line":' || v_result_line || ',' ||
        '"polygon":' || v_result_polygon || '}' ||
        '}' ||
        '}')::json, 3492, NULL, ('{"visible": [' || v_visible_layer || ']}')::json, NULL
    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
