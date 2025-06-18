/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_core(p_data JSON)
RETURNS JSON AS
$BODY$

/*EXAMPLE

SELECT gw_fct_mincut_core('{"data":{
	"pgrDistance":1000,
	"pgrRootVids":[1,2,3],
	"ignoreCheckValvesMincut":true
}}') INTO v_response;

*/

DECLARE

-- SECTION 01: Variables

-- parameters
v_client_epsg varchar;
v_cur_user varchar;
v_device integer;
v_tiled boolean;
v_mincut integer;
v_mincut_class integer;
v_node integer;
v_arc integer;
v_use_psectors boolean;

-- coordinates parameters
v_xcoord float;
v_ycoord float;
v_zoomratio float;

-- config parameters
v_epsg integer;
v_mincut_version integer;
v_vdefault json;
v_sensibility_f float;

-- extra variables
v_point geometry;
v_connec integer;

-- controls
v_version varchar;
v_srid integer;
v_project_type varchar;

-- result variables
v_result jsonb;
v_result_init jsonb;
v_result_valve jsonb;
v_result_node jsonb;
v_result_connec jsonb;
v_result_arc jsonb;


-- MINCUT VARIABLES
v_record record;
v_pgr_node_id INTEGER;
v_id integer=0;
v_return_text text;
v_cost integer=1;
v_reverse_cost integer=1;
v_mapzone_name text ='minsector';

-- general variables
v_query_text TEXT;

-- parameters
v_pgr_distance INTEGER;
v_pgr_root_vids int[];
v_ignore_check_valves BOOLEAN;


v_vids_checkvalve int[];
v_arc_id INTEGER;
v_mincut_id INTEGER;
v_flood INTEGER;






-- !SECTION

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Get project version
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Parameters
	v_pgr_distance = (SELECT (p_data::json->>'data')::json->>'pgrDistance');
	v_pgr_root_vids = (SELECT (p_data::json->>'data')::json->>'pgrRootVids');
	v_ignore_check_valves = (SELECT (p_data::json->>'data')::json->>'ignoreCheckValvesMincut');

	v_query_text = '
		SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, reverse_cost_mincut AS cost, cost_mincut AS reverse_cost
		FROM temp_pgr_arc
	';
    TRUNCATE temp_pgr_drivingdistance;

    INSERT INTO  temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
    (
		SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
   		FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
    );

	-- update mapzone_id with value 1
    -- for the nodes
    UPDATE temp_pgr_node n SET mapzone_id = 1
    FROM temp_pgr_drivingdistance d
    WHERE n.pgr_node_id = d.node;

   	-- for the arcs that connect with the nodes;
    UPDATE temp_pgr_arc a SET mapzone_id = 1
    WHERE a.mapzone_id = 0
    AND EXISTS (
		SELECT 1 FROM temp_pgr_node n
    	WHERE n.mapzone_id = 1
    	AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
	);

   -- STEP 2 flood with INVERTED cost/reverse_cost without considering the cost of the checkvalves, the valves from STEP 1 that are not closed
    -- open valves
    SELECT array_agg(n.pgr_node_id)::INT[]
    INTO v_pgr_root_vids
    FROM temp_pgr_node n
    WHERE n.mapzone_id = 0
    AND EXISTS (
		SELECT 1 FROM temp_pgr_arc a
        WHERE a.mapzone_id = 1 -- from STEP 1
        AND a.graph_delimiter = 'MINSECTOR'
        AND a.closed = FALSE
        AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        );
    IF v_ignore_check_valves = TRUE THEN
        v_query_text = '
			SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, 
        	CASE WHEN a.graph_delimiter = ''MINSECTOR'' AND a.cost <> a.reverse_cost THEN 0 ELSE a.reverse_cost END AS cost,
        	CASE WHEN a.graph_delimiter = ''MINSECTOR'' AND a.cost <> a.reverse_cost THEN 0 ELSE a.cost END AS reverse_cost
        	FROM temp_pgr_arc a 
        	WHERE a.mapzone_id = 0
		';
    ELSE
        v_query_text = '
			SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, 
			reverse_cost AS cost, cost AS reverse_cost
			FROM temp_pgr_arc a 
			WHERE a.mapzone_id = 0
		';
    END IF;

    TRUNCATE temp_pgr_drivingdistance;

    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
    (
		SELECT seq, "depth", start_vid, pred,node, edge, "cost", agg_cost
		FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
    );

    -- close the valves where arrives the water
    WITH wet_valve AS (
		SELECT DISTINCT start_vid
		FROM temp_pgr_drivingdistance d
		WHERE d.edge <> -1 AND
		EXISTS (
			SELECT 1 FROM temp_pgr_node n
			WHERE d.node = n.pgr_node_id
			AND n.graph_delimiter = 'SECTOR'
			AND n.node_id IS NOT NULL
		)
	)

    UPDATE temp_pgr_arc a SET proposed = TRUE
    FROM wet_valve t
    WHERE t.start_vid IN (a.pgr_node_1, a.pgr_node_2)
    AND a.graph_delimiter = 'MINSECTOR'
    AND a.cost_mincut = a.reverse_cost_mincut ; -- only the open ones, not the checkvalves (there are checkvalves if v_ignorecheckvalves = FALSE)

    -- only if v_ignorecheckvalves = TRUE
    -- check if there are start_vids with checkvalves inside the flooded area;
    --STEP 3 flood again with INVERTED cost/reverse_cost for these start_vids, considering the cost for checkvalves too
    IF v_ignore_check_valves THEN

        SELECT array_agg(DISTINCT d.start_vid)::INT[]
        INTO v_vids_checkvalve
        FROM temp_pgr_drivingdistance d
        JOIN temp_pgr_node n ON n.pgr_node_id = d.node
        WHERE d.edge <> -1
        AND n.graph_delimiter = 'MINSECTOR'
        AND EXISTS (
			SELECT 1
			FROM temp_pgr_arc a
			WHERE a.graph_delimiter = 'MINSECTOR'
			AND a.cost <> a.reverse_cost
			AND COALESCE(a.node_1, a.node_2) = n.node_id
        );

        IF v_vids_checkvalve IS NOT NULL THEN
            v_query_text = '
				SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, 
				reverse_cost AS cost, cost AS reverse_cost
				FROM temp_pgr_arc a 
				WHERE a.mapzone_id = 0
			';
            TRUNCATE temp_pgr_drivingdistance;

            INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
            (
				SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
				FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
            );
        END IF;
    END IF;

    -- before updating the mapzone_id for the nodes, remove the "wet" start_vids
    WITH wet_valve AS (
		SELECT DISTINCT start_vid
		FROM temp_pgr_drivingdistance d
		WHERE d.edge <> -1 AND
    EXISTS (
			SELECT 1
			FROM temp_pgr_node n
			WHERE d.node = n.pgr_node_id
			AND n.graph_delimiter = 'SECTOR'
			AND n.node_id IS NOT NULL
        )
    )
    DELETE FROM temp_pgr_drivingdistance t
    WHERE EXISTS (
		SELECT 1
		FROM wet_valve v
		WHERE t.start_vid = v.start_vid
	);

    -- update mapzone_id with value 2 - just for control, to separate from the nodes/arcs from STEP 1
    -- for the nodes
    UPDATE temp_pgr_node n SET mapzone_id = 2
    FROM temp_pgr_drivingdistance d
    WHERE n.mapzone_id = 0
    AND n.pgr_node_id = d.node;

    -- for the arcs that connect with the nodes;
    UPDATE temp_pgr_arc a SET mapzone_id = 2
    WHERE a.mapzone_id = 0
    AND EXISTS (
		SELECT 1
		FROM temp_pgr_node n
		WHERE n.mapzone_id = 2
		AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
	);

    --STEP 4 flood  with DIRECT cost/reverse_cost for the start_vids that exists in temp_pgr_drivingdistance, considering the cost for checkvalves too
    SELECT array_agg(DISTINCT d.start_vid)::INT[]
    INTO v_pgr_root_vids
    from temp_pgr_drivingdistance d;
    TRUNCATE temp_pgr_drivingdistance;
    v_query_text = '
		SELECT pgr_arc_id AS id, pgr_node_1 AS source, pgr_node_2 AS target, 
		cost, reverse_cost
		FROM temp_pgr_arc a 
		WHERE a.mapzone_id <> 1 -- exclude the minsector generetated at STEP 1
		AND (a.graph_delimiter <> ''SECTOR'')
	'; -- exclude InletArcs

    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
    (
		SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
		FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
    );

    -- update mapzone_id with value 3 - just for control, to separate from the nodes/arcs from STEP 1;
    -- for the nodes
    UPDATE temp_pgr_node n SET mapzone_id = 3
    FROM temp_pgr_drivingdistance d
    WHERE n.mapzone_id = 0
    AND n.pgr_node_id = d.node;

    -- for the arcs that connect with the nodes;
    UPDATE temp_pgr_arc a SET mapzone_id = 3
    WHERE a.mapzone_id = 0
    AND EXISTS (
		SELECT 1
		FROM temp_pgr_node n
        WHERE n.mapzone_id > 1
        AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
	);

    -- check if some flood arrives at some water source and run again the same flood from these water source nodes
    SELECT array_agg(DISTINCT d.node)::INT[]
    INTO v_pgr_root_vids
    FROM temp_pgr_drivingdistance d
    WHERE d.edge <> -1
	AND EXISTS (
		SELECT 1
		FROM temp_pgr_node n
		WHERE d.node = n.pgr_node_id
		AND n.graph_delimiter = 'SECTOR'
    );

    TRUNCATE temp_pgr_drivingdistance;

    INSERT INTO temp_pgr_drivingdistance(seq, "depth", start_vid, pred, node, edge, "cost", agg_cost)
    (
		SELECT seq, "depth", start_vid, pred, node, edge, "cost", agg_cost
		FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
    );

    -- if the mapzone = 3 from the previews flood, put it in 0 again; it means that the water arrives
    -- for the nodes
    UPDATE temp_pgr_node n SET mapzone_id = 0
    FROM temp_pgr_drivingdistance d
    WHERE n.mapzone_id = 3
    AND n.pgr_node_id = d.node;

    -- for the arcs that connect with the nodes;
    UPDATE temp_pgr_arc a SET mapzone_id = 0
    WHERE a.mapzone_id = 3
    AND EXISTS (
		SELECT 1
		FROM temp_pgr_node n
        JOIN temp_pgr_drivingdistance d ON d.node = n.pgr_node_id
        WHERE n.mapzone_id = 0
        AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
	);

  	-- STEP 5 FINISHING
    -- update mapzone_id for the nodes that are not updated
	UPDATE temp_pgr_node n SET mapzone_id = 4 -- 4 is used for control
    WHERE n.mapzone_id = 0
    AND EXISTS (
		SELECT 1
		FROM temp_pgr_arc a
		WHERE a.mapzone_id > 0
		AND a.arc_id IS NULL -- border arcs
		AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
	);















	-- SECTION[epic=mincut]: Controll Nulls
	v_message = COALESCE(v_message, '{}');
	v_version = COALESCE(v_version, '');
	v_mincut = COALESCE(v_mincut, 0);
	v_result_info = COALESCE(v_result_info, '{}');
	v_result_point = COALESCE(v_result_point, '{}');
	v_result_line = COALESCE(v_result_line, '{}');
	v_result_polygon = COALESCE(v_result_polygon, '{}');
	v_level = COALESCE(v_level, 0);
	v_netscenario = COALESCE(v_netscenario, '');

	-- SECTION[epic=mincut]: Return result
		v_response := jsonb_build_object(
			'status', 'Accepted',
			'message', v_message,
			'version', v_version,
			'body', jsonb_build_object(
				'form', jsonb_build_object(),
				'feature', jsonb_build_object(),
				'data', jsonb_build_object(
					'mincutId', v_mincut,
					'mincutInit', v_result_init,
					'valve', v_result_valve,
					'mincutNode', v_result_node,
					'mincutConnec', v_result_connec,
					'mincutArc', v_result_arc,
					'tiled', v_tiled
				)
			)
		);
		return v_response;


	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
	',"body":{"form":{}'||
			',"data":{ '||
			'  "info":'||v_result_info||
			', "geometry":"'||v_geometry||'"'||
			', "mincutDetails":'||v_mincutdetails||'}'||
			'}'
	'}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;