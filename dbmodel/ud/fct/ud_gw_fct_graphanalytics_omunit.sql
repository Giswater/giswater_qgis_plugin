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

SELECT gw_fct_graphanalytics_omunit('
	{
		"data":{
			"parameters":{
				"graphClass":"OMUNIT",
				"exploitation":"1",
				"updateMapZone":2,
				"geomParamUpdate":15,
				"commitChanges":true,
				"usePlanPsector":false
			}
		}
	}
');

--fid: 640

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

    v_fid INTEGER = 640;

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
	v_data := '{"data":{"expl_id_array":"' || array_to_string(v_expl_id_array, ',') || '", "mapzone_name":"OMUNIT"}}';
    SELECT gw_fct_graphanalytics_initnetwork(v_data) INTO v_response;

    IF v_response->>'status' <> 'Accepted' THEN
        RETURN v_response;
    END IF;

	-- -- =======================
    -- v_data := '{"data":{"mapzone_name":"OMUNIT"}}';
    -- SELECT gw_fct_graphanalytics_arrangenetwork(v_data) INTO v_response;

    -- IF v_response->>'status' <> 'Accepted' THEN
    --     RETURN v_response;
    -- END IF;

    --------------------------------------------------
    -- SECTION: Create omunits and macrounits
    --------------------------------------------------

    -- fill table temp_pgr_linegraph using pgr_lineGraph for oriented graphs 
    -- in the result, reverse_cost will be always -1
    -- source and target are connected arcs
    -- FOR SIMPLICITY WE USE ARC_ID, NODE_1, NODE_2 AND NOT PGR_ARC_ID, PGR_NODE_1, PGR_NODE_2
    INSERT INTO temp_pgr_linegraph (seq, source, target, COST, reverse_cost)
    SELECT seq, source, target, cost, reverse_cost
    FROM pgr_lineGraph(
    'SELECT arc_id as id, node_1 as source, node_2 as target, cost, reverse_cost
        FROM temp_pgr_arc',
    true);

    -- CATCHMENTS
    -- choose the best candidate among target arcs; the ones that are not the best candidate will have graph_delimiter = 'CATCHMENT'; the best candidate will keep graph_delimiter = 'NONE'
    -- TODO improve the condition, add section and elevation (F_FACTOR)
    WITH 
        pair_arcs AS (
            SELECT 
                l.SOURCE, l.seq, l.target, l.graph_delimiter,
                CASE
                    WHEN a1.initoverflowpath = a2.initoverflowpath THEN 0  -- the same: first
                    ELSE 1                                        -- not the same: after
                END AS initoverflowpath,
                abs(st_azimuth(st_lineinterpolatepoint(a1.the_geom,0.99),st_endpoint(a1.the_geom))
                - st_azimuth(st_startpoint(a2.the_geom),st_lineinterpolatepoint(a2.the_geom,0.01)) 
                ) AS azimuth_difference
            FROM temp_pgr_linegraph l
            JOIN v_temp_arc a1 ON l."source" = a1.arc_id
            JOIN v_temp_arc a2 ON l."target" = a2.arc_id
        ),
        best_pair AS (
            SELECT DISTINCT ON (SOURCE) SOURCE, target, seq
            FROM pair_arcs
            ORDER BY SOURCE, initoverflowpath, azimuth_difference, target
        )
    UPDATE temp_pgr_linegraph l
    SET graph_delimiter = 'CATCHMENT'
    WHERE NOT EXISTS (SELECT 1 FROM best_pair bp WHERE bp.seq = l.seq);

    -- MACROUNITS
    -- choose the best candidate among SOURCE arcs; the ones that are not the best candidate will have graph_delimiter = 'MACROUNIT'; 
    -- every macrounit will be a chain, the relation between arcs-in and arcs-out of a node is 1:1
    -- TODO improve the condition, add section and elevation - if it's needed
    WITH 
        pair_arcs AS (
            SELECT 
                l.SOURCE,l.seq, l.target, l.graph_delimiter,
                CASE
                    WHEN a1.initoverflowpath = a2.initoverflowpath THEN 0  -- the same: first
                    ELSE 1                                        -- not the same: after
                END AS initoverflowpath,
                abs(st_azimuth(st_lineinterpolatepoint(a1.the_geom,0.99),st_endpoint(a1.the_geom))
                - st_azimuth(st_startpoint(a2.the_geom),st_lineinterpolatepoint(a2.the_geom,0.01)) 
                ) AS azimuth_difference
            FROM temp_pgr_linegraph l
            JOIN v_temp_arc a1 ON l."source" = a1.arc_id
            JOIN v_temp_arc a2 ON l."target" = a2.arc_id
            WHERE graph_delimiter = 'NONE'
        ),
        best_pair AS (
            SELECT DISTINCT ON (target) target, source, seq
            FROM pair_arcs
            ORDER BY target, initoverflowpath, azimuth_difference, source
        )
    UPDATE temp_pgr_linegraph l
    SET graph_delimiter = 'MACROUNIT'
    WHERE l.graph_delimiter = 'NONE'
    AND NOT EXISTS (SELECT 1 FROM best_pair bp WHERE bp.seq = l.seq);

    -- OMUNITS
    -- =======================
    --TODO maybe should be good checking the accessibility of the node with graph_delimiter = 'OMUNIT'
    UPDATE temp_pgr_linegraph l
    SET graph_delimiter = 'OMUNIT'
    FROM temp_pgr_arc a
    WHERE l.graph_delimiter ='NONE'
        AND l.source = a.arc_id
        AND EXISTS (
            SELECT 1 FROM temp_pgr_node n WHERE n.graph_delimiter = 'OMUNIT'
            AND a.pgr_node_2 = n.pgr_node_id   
        );

    -- generate omunit_id applying connectedComponents over temp_pgr_linegraph filtering graph_delimiter = 'OMUNIT', 'MACROUNIT' AND 'CATCHMENT'
    TRUNCATE temp_pgr_connectedcomponents;
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node 
    FROM pgr_connectedcomponents(
        'SELECT seq AS id, source, target, cost 
        FROM temp_pgr_linegraph
        WHERE graph_delimiter <> ''OMUNIT'' 
            AND graph_delimiter <> ''MACROUNIT'' 
            AND graph_delimiter <> ''CATCHMENT'' 
        '
    );

    -- Update the mapzone_id (omunit) for arcs
    UPDATE temp_pgr_arc a
    SET
        mapzone_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE a.arc_id = c.node;

    -- fill table temp_pgr_omunit
    INSERT INTO temp_pgr_omunit (omunit_id)
    SELECT DISTINCT mapzone_id
    FROM temp_pgr_arc
    WHERE mapzone_id <> 0;

    WITH 
        vertices AS (
            SELECT id, in_edges, out_edges
            FROM pgr_extractvertices('
                SELECT seq AS id, source, target, cost, reverse_cost 
                FROM temp_pgr_linegraph 
                WHERE graph_delimiter <> ''OMUNIT'' 
                    AND graph_delimiter <> ''MACROUNIT'' 
                    AND graph_delimiter <> ''CATCHMENT'' 
            ')
        )
    UPDATE temp_pgr_omunit o
    SET node_1 = a.node_1
    FROM temp_pgr_arc a 
    WHERE EXISTS (SELECT 1 FROM vertices v WHERE v.in_edges IS NULL AND v.id = a.arc_id)
    AND o.omunit_id = a.mapzone_id;

    WITH 
        vertices AS (
            SELECT id, in_edges, out_edges
            FROM pgr_extractvertices('
                SELECT seq AS id, source, target, cost, reverse_cost 
                FROM temp_pgr_linegraph 
                WHERE graph_delimiter <> ''OMUNIT'' 
                    AND graph_delimiter <> ''MACROUNIT'' 
                    AND graph_delimiter <> ''CATCHMENT'' 
            ')
        )
    UPDATE temp_pgr_omunit o
    SET node_2 = a.node_2
    FROM temp_pgr_arc a 
    WHERE EXISTS (SELECT 1 FROM vertices v WHERE v.out_edges IS NULL AND v.id = a.arc_id)
    AND o.omunit_id = a.mapzone_id;

    -- insert the arcs with omunit = 0 as independent omunits
    INSERT INTO temp_pgr_omunit (omunit_id, node_1, node_2)
    SELECT arc_id, node_1, node_2
    FROM temp_pgr_arc a
    WHERE mapzone_id = 0;

    -- update omunit_id (mapzone_id) for these arcs
    UPDATE temp_pgr_arc a
    SET mapzone_id = arc_id
    WHERE mapzone_id = 0;

    -- MACROUNITS
    -- =======================
    -- generate macrounit_id applying connectedComponents over temp_pgr_linegraph filtering graph_delimiter = 'MACROUNIT' and 'CATCHMENT'
    TRUNCATE temp_pgr_connectedcomponents;
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node 
    FROM pgr_connectedcomponents(
        'SELECT seq AS id, source, target, cost 
        FROM temp_pgr_linegraph
        WHERE graph_delimiter <> ''MACROUNIT''
        AND graph_delimiter <> ''CATCHMENT'' 
        '
    );

    -- Update the macrounit_id  for arcs
    UPDATE temp_pgr_arc a
    SET
        macromapzone_id = c.component
    FROM temp_pgr_connectedcomponents c
    WHERE a.arc_id = c.node;

    -- update macrounit_id for the isolated arcs
    UPDATE temp_pgr_arc a
    SET macromapzone_id = arc_id
    WHERE macromapzone_id = 0;

     -- Update the macrounit_id for omunit_id
    UPDATE temp_pgr_omunit o
    SET
        macrounit_id = a.macrounit_id
    FROM 
        (SELECT DISTINCT mapzone_id as omunit_id, macromapzone_id AS macrounit_id
        FROM  temp_pgr_arc
        ) a
    WHERE o.omunit_id = a.omunit_id;

    INSERT INTO temp_pgr_macrounit (macrounit_id)
    SELECT DISTINCT macromapzone_id
    FROM temp_pgr_arc;

    -- ORDER SECTION
    --==================================

    -- choose the arcs from where starts 
    WITH 
        vertices AS (
            SELECT id, in_edges, out_edges
            FROM pgr_extractvertices('
                SELECT seq AS id, source, target, cost, reverse_cost 
                FROM temp_pgr_linegraph 
                WHERE graph_delimiter <> ''CATCHMENT'' 
                ' 
            )
        )
    SELECT array_agg(DISTINCT id)::INT[] INTO v_root_vids
    FROM vertices 
    WHERE out_edges IS NULL; 

    -- use pgr_depthFirstSearch for the lineGraph of the network, from target to source 
    -- TODO order using elev2 instead of macromapzone_id for a better ordering, could be faster
    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, node, edge, "cost", agg_cost)
    (
        SELECT seq, "depth", start_vid, node, edge, "cost", agg_cost
        FROM pgr_depthFirstSearch(
            'SELECT l.seq AS id, l.target AS source, l.source AS target, l.cost, l.reverse_cost 
            FROM temp_pgr_linegraph l
            JOIN temp_pgr_arc a ON l. target = a.arc_id
            WHERE l.graph_delimiter <> ''CATCHMENT''
            ORDER BY a.macromapzone_id',
        v_root_vids, directed => true)
    );

    -- order macrounits and update their catchment_node
    WITH 
	root_vids AS (
		SELECT DISTINCT start_vid 
		FROM temp_pgr_drivingdistance
	),
	root_nodes AS (
		SELECT v.start_vid, a.node_2
		FROM root_vids v
		JOIN temp_pgr_arc a ON v.start_vid = a.arc_id
	),
	macrounits AS (
		SELECT n.node_2 AS catchment_node, a.macromapzone_id AS macrounit_id, min(d.seq) AS min_seq
		FROM temp_pgr_drivingdistance d
		JOIN root_nodes n ON d.start_vid = n.start_vid
		JOIN temp_pgr_arc a ON d.node = a.arc_id
		GROUP BY n.node_2, a.macromapzone_id
	),
	macrounits_ordered AS (
		SELECT  catchment_node, macrounit_id, ROW_NUMBER() OVER (PARTITION BY catchment_node ORDER BY catchment_node, min_seq desc) AS order_number
	FROM macrounits
	)
	UPDATE temp_pgr_macrounit m
	SET 
		catchment_node = mo.catchment_node,
		order_number = mo.order_number
	FROM macrounits_ordered mo 
	WHERE m.macrounit_id = mo.macrounit_id;

    --update catchment_node and order_number for isolated arcs
    UPDATE temp_pgr_macrounit m
    SET catchment_node = a.node_2, order_number = 1
    FROM temp_pgr_arc a 
    WHERE m.order_number = 0 
    AND m.macrounit_id = a.arc_id;

    -- order omunits
    WITH 
	omunits AS (
		SELECT a.macromapzone_id AS macrounit_id, a.mapzone_id as omunit_id, min(d.seq) AS min_seq
		FROM temp_pgr_drivingdistance d
		JOIN temp_pgr_arc a ON d.node = a.arc_id
		GROUP BY a.macromapzone_id, a.mapzone_id
	),
	omunits_ordered AS (
		SELECT  macrounit_id, omunit_id, ROW_NUMBER() OVER (PARTITION BY macrounit_id ORDER BY macrounit_id, min_seq desc) AS order_number
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
