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
    
    -- parameters
    v_pgr_distance INTEGER;
    v_root_vids int[];

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

    -- SECTION: Create omunits
    -- TODO: Add Core function to create omunits

    -- save as graph_delimiter the arcs 'INITOVERFLOWPATH' and put cost = -1
    UPDATE temp_pgr_arc t
    SET graph_delimiter = 'INITOVERFLOWPATH', cost = -1
    FROM v_temp_arc v
    WHERE v.arc_id = t.arc_id AND v.initoverflowpath;

    -- fill table temp_pgr_linegraph using pgr_lineGraph for oriented graphs with cost = 1 and reverse_cost = -1 
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
    -- choose the best candidate among target arcs; the ones that are not the best candidate will have cost = -1;  only the best candidate will have cost 1
    -- the result will be a tree; the relation between arcs-in and arcs-out of a node is n:1
    -- TODO improve the condition 0.1, add section and elevation - if it's needed
    WITH 
        arcs AS (
            SELECT l.SOURCE,l.seq, l.target, 
            abs(st_azimuth(st_lineinterpolatepoint(a1.the_geom,0.99),st_endpoint(a1.the_geom))
            - st_azimuth(st_startpoint(a2.the_geom),st_lineinterpolatepoint(a2.the_geom,0.01)) 
            ) AS azimuth_difference
            FROM temp_pgr_linegraph l
            JOIN v_temp_arc a1 ON l."source" = a1.arc_id
            JOIN v_temp_arc a2 ON l."target" = a2.arc_id
        ),
        best_pair AS (
            SELECT DISTINCT ON (SOURCE) SOURCE, target, seq
            FROM arcs
            ORDER BY SOURCE, azimuth_difference, target
        )
    UPDATE temp_pgr_linegraph l
    SET COST = -1
    WHERE NOT EXISTS (SELECT 1 FROM best_pair bp WHERE bp.seq = l.seq)
    ;

    -- generate catchment_id applying connectedComponents over temp_pgr_linegraph 
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node 
    FROM pgr_connectedcomponents(
        'SELECT seq AS id, source, target, cost 
        FROM temp_pgr_linegraph
        '
    );

    -- Update the catchment_id field for arcs
    UPDATE temp_pgr_linegraph l
    SET catchment_id = c.component
    FROM temp_pgr_connectedcomponents AS c
    WHERE l.source = c.node AND l.cost = 1;

    -- MACROUNITS
    -- choose the best candidate among SOURCE arcs; the ones that are not the best candidate will have graph_delimiter = 'MACROUNIT'; 
    -- every macrounit will be a chain, the relation between arcs-in and arcs-out of a node is 1:1
    -- TODO improve the condition 0.1, add section and elevation - if it's needed
    WITH 
        arcs AS (
            SELECT l.SOURCE,l.seq, l.target, 
            abs(st_azimuth(st_lineinterpolatepoint(a1.the_geom,0.99),st_endpoint(a1.the_geom))
            - st_azimuth(st_startpoint(a2.the_geom),st_lineinterpolatepoint(a2.the_geom,0.01)) 
            ) AS azimuth_difference
            FROM temp_pgr_linegraph l
            JOIN v_temp_arc a1 ON l."source" = a1.arc_id
            JOIN v_temp_arc a2 ON l."target" = a2.arc_id
        ),
        best_pair AS (
            SELECT DISTINCT ON (target) target, source, seq
            FROM arcs
            ORDER BY target, azimuth_difference, source
        )
    UPDATE temp_pgr_linegraph l
    SET graph_delimiter = 'MACROUNIT'
    WHERE NOT EXISTS (SELECT 1 FROM best_pair bp WHERE bp.seq = l.seq)
    ;

    -- generate macrounit_id applying connectedComponents over temp_pgr_linegraph filtering graph_delimiter = 'MACROUNIT'
    TRUNCATE temp_pgr_connectedcomponents;
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node 
    FROM pgr_connectedcomponents(
        'SELECT seq AS id, source, target, cost 
        FROM temp_pgr_linegraph
        WHERE graph_delimiter <> ''MACROUNIT''
        '
    );

    -- Update the macrounit_id field for arcs
    UPDATE temp_pgr_linegraph l
    SET macrounit_id = c.component
    FROM temp_pgr_connectedcomponents AS c
    WHERE l.source = c.node AND l.cost = 1;

    -- the init of every catchment using pgr_depthFirstSearch and macrounits tree
    WITH 
        vertices AS (
            SELECT id, in_edges, out_edges
            FROM pgr_extractvertices('SELECT seq AS id, source, target, cost, reverse_cost FROM temp_pgr_linegraph')
        )
    SELECT array_agg(l.target) INTO v_root_vids
    FROM temp_pgr_linegraph l
    WHERE EXISTS (SELECT 1 FROM vertices v WHERE v.out_edges IS NULL AND v.id = l.target);

    -- Update the catchment_id field for arcs
    UPDATE temp_pgr_arc a
    SET catchment_id = c.component
    FROM temp_pgr_connectedcomponents AS c
    WHERE a.arc_id = c.node;

    -- update catchment_id with arc_id when catchment_id is still 0 (these arcs are isolated arcs)
   UPDATE temp_pgr_arc a
   SET catchment_id = arc_id
    WHERE catchment_id = 0;

    -- TODO update macrounit_id for nodes if it's necessarily - (filter cost = 1 in temp_pgr_linegraph)

   -- repeating the same process for omunit_id - from connectedComponents, filtering graph_delimiter = 'OMUNIT'

   -- update with graph_delimiter = 'OMUNIT' the couple of arcs connected by an OMUNIT node
    -- TODO don't put as 'OMUNIT' if they are no accesible - how we could know it?
    /*UPDATE temp_pgr_linegraph l
    SET graph_delimiter = 'OMUNIT'
    FROM temp_pgr_arc a
    WHERE 
    EXISTS (
        SELECT 1 FROM temp_pgr_node n WHERE n.graph_delimiter = 'OMUNIT'
        AND a.pgr_node_2 = n.pgr_node_id   
    )
    AND l.source = a.pgr_arc_id;

   -- generate omunit_id applying connectedComponents over temp_pgr_linegraph 
    -- this time without the rows with graph_delimiter = 'OMUNIT'
    TRUNCATE temp_pgr_connectedcomponents;
    INSERT INTO temp_pgr_connectedcomponents(seq, component, node)
    SELECT seq, component, node 
    FROM pgr_connectedcomponents(
        'SELECT seq AS id, source, target, cost 
        FROM temp_pgr_linegraph
        WHERE graph_delimiter <> ''OMUNIT''
        '
    );

    -- Update the mapzone_id field for arcs
    UPDATE temp_pgr_arc a
    SET mapzone_id = agg.min_arc
    FROM temp_pgr_connectedcomponents AS c
    JOIN (
    	SELECT c.component, MIN(a.arc_id) AS min_arc
      FROM temp_pgr_connectedcomponents c
      JOIN temp_pgr_arc a on a.pgr_arc_id = c.node
      GROUP BY c.component
    ) agg ON c.component = agg.component
    WHERE a.pgr_arc_id = c.node;

    -- update mapzone_id with arc_id when mapzone_id is still 0
   UPDATE temp_pgr_arc a
   SET mapzone_id = arc_id
   WHERE mapzone_id = 0;
    */
   -- TODO update mapzone_id (omunit_id) for nodes if it's necessarily - it can be used pgr_degree (filter cost = 1 in temp_pgr_linegraph and graph_delimiter <> 'OMUNIT')

    -------------------------------------------------------
    -- prepare way_in and way_out for omunit
    -------------------------------------------------------
    /*
    -- when mapzone_id = arc_id -> way_in and way_out are node_1 and node_2 of the arc
    -- for the mapzones that contain more then 1 arc, use this query: 
    -- using pgr_extractvertices for temp_pgr_linegraph filtering for cost = 1 and graph_delimiter <>'OMUNIT'
    WITH 
        vertices AS (
            SELECT id AS pgr_arc_id, in_edges, out_edges FROM pgr_extractvertices (
                'SELECT l.seq as id, source, target 
                FROM temp_pgr_linegraph l
                WHERE l.cost = 1 and l.graph_delimiter <>''OMUNIT''
            ')
        ),
        mapzones AS (
            SELECT DISTINCT a.mapzone_id
            FROM vertices v
            JOIN temp_pgr_arc a USING (pgr_arc_id)
        ),
        way_in AS (
            SELECT a.mapzone_id, n.node_id, n.graph_delimiter
            FROM vertices v
            JOIN temp_pgr_arc a USING (pgr_arc_id)
            JOIN temp_pgr_node n ON n.pgr_node_id = a.pgr_node_1
            WHERE v.in_edges IS NULL 
        ),
        way_out AS (
            SELECT a.mapzone_id, n.node_id, n.graph_delimiter
            FROM vertices v
            JOIN temp_pgr_arc a USING (pgr_arc_id)
            JOIN temp_pgr_node n ON n.pgr_node_id = a.pgr_node_2
            WHERE v.out_edges IS NULL 
        )
    SELECT 
        m.mapzone_id, 
        i.node_id AS node_1,
        CASE WHEN i.graph_delimiter = 'OMUNIT' THEN TRUE
        ELSE FALSE 
        END AS is_way_in, 
        o.node_id AS node_2,
        CASE WHEN o.graph_delimiter = 'OMUNIT' THEN TRUE
        ELSE FALSE 
        END AS is_way_out
    FROM mapzones m
    JOIN way_in i USING (mapzone_id)
    JOIN way_out o USING (mapzone_id)
    ORDER BY m.mapzone_id;
    */

    -------------------------------------------------------
    -- prepare start node and end node for macrounit - if it's needed
    -------------------------------------------------------
    -- when macromapzone_id = arc_id -> way_in and way_out are node_1 and node_2 of the arc
    -- for the macromapzones that contain more then 1 arc, use this query 
    -- using pgr_extractvertices for temp_pgr_linegraph filtering only for cost = 1
    /*
   WITH 
        vertices AS (
            SELECT id AS pgr_arc_id, in_edges, out_edges FROM pgr_extractvertices (
                'SELECT l.seq as id, source, target 
                FROM temp_pgr_linegraph l
                WHERE l.cost = 1
            ')
        ),
        macromapzones AS (
            SELECT DISTINCT a.macromapzone_id
            FROM vertices v
            JOIN temp_pgr_arc a USING (pgr_arc_id)
        ),
        way_in AS (
            SELECT a.macromapzone_id, n.node_id, n.graph_delimiter
            FROM vertices v
            JOIN temp_pgr_arc a USING (pgr_arc_id)
            JOIN temp_pgr_node n ON n.pgr_node_id = a.pgr_node_1
            WHERE v.in_edges IS NULL 
        ),
        way_out AS (
            SELECT a.macromapzone_id, n.node_id, n.graph_delimiter
            FROM vertices v
            JOIN temp_pgr_arc a USING (pgr_arc_id)
            JOIN temp_pgr_node n ON n.pgr_node_id = a.pgr_node_2
            WHERE v.out_edges IS NULL 
        )
    SELECT 
        m.macromapzone_id, 
        i.node_id AS node_1,
        CASE WHEN i.graph_delimiter = 'OMUNIT' THEN TRUE
        ELSE FALSE 
        END AS is_way_in, 
        o.node_id AS node_2,
        CASE WHEN o.graph_delimiter = 'OMUNIT' THEN TRUE
        ELSE FALSE 
        END AS is_way_out
    FROM macromapzones m
    JOIN way_in i USING (macromapzone_id)
    JOIN way_out o USING (macromapzone_id)
    ORDER BY m.macromapzone_id;
    */

    -- ENDSECTION

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
