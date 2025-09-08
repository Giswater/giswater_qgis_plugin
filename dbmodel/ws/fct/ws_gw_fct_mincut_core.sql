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

The mincut arcs:

SELECT p.*, a.the_geom
FROM ws_github.temp_pgr_arc p
JOIN ws_github.arc a on p.arc_id =a.arc_id
WHERE p.mapzone_id <>0;

The mincut valves MINCUT:

SELECT a.*, n.the_geom
FROM ws_github.temp_pgr_arc a
JOIN ws_github.node n ON n.node_id = COALESCE(a.node_1, a.node_2)
WHERE a.graph_delimiter = 'MINSECTOR' AND a.mapzone_id <>0;

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
v_message text;
v_level integer;
v_response jsonb;
v_result jsonb;
v_result_init jsonb;
v_result_valve jsonb;
v_result_node jsonb;
v_result_connec jsonb;
v_result_arc jsonb;


-- MINCUT VARIABLES
v_mapzone_name text ='MINSECTOR';
v_mincut_id INTEGER;
v_water_source int[];

-- general variables
v_query_text TEXT;

-- parameters
v_pgr_distance INTEGER;
v_pgr_root_vids int[];
v_ignore_check_valves BOOLEAN;


-- core variables
v_pgr_root_vids_chk int[];
v_pgr_root_vids_chk_dry int[];
v_pgr_root_vids_chk_water int[];
v_valve_water int[];
v_valve_chk int[];
v_cost_field TEXT;
v_reverse_cost_field TEXT;

-- !SECTION

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Get project version
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Parameters
	v_pgr_distance = (SELECT (p_data::json->>'data')::json->>'pgrDistance');
	v_pgr_root_vids = ARRAY(SELECT json_array_elements_text(((p_data::json->>'data')::json->>'pgrRootVids')::json))::int[];
	v_ignore_check_valves = (SELECT (p_data::json->>'data')::json->>'ignoreCheckValvesMincut');

    -- STEP 1 flood with INVERTED cost_mincut/reverse_cost_mincut for finding the borders
    -- the flood is reversed; the one-way valves that don't stop the water will stay inside the minsector, they cannot be borders because they cannot be closed
    v_query_text='SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, reverse_cost_mincut as cost, cost_mincut as reverse_cost
    FROM temp_pgr_arc
    ';
    TRUNCATE temp_pgr_drivingdistance;
    INSERT INTO  temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
    (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost
    FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
    );

    -- update mapzone_id with value 1
    -- for the nodes
    UPDATE temp_pgr_node n SET mapzone_id = 1
    FROM temp_pgr_drivingdistance d
    WHERE n.pgr_node_id =d.node;

   	-- for the arcs that connect with the nodes;
    UPDATE temp_pgr_arc a set mapzone_id = 1
    FROM temp_pgr_drivingdistance d
    WHERE d.node IN  (a.pgr_node_1, a.pgr_node_2);

    -- open valves (if v_ignore_check_valves =FALSE, check_valves also)
    SELECT COALESCE(array_agg(n.pgr_node_id), ARRAY[]::int[])
    INTO v_pgr_root_vids
    FROM temp_pgr_node n
    WHERE n.graph_delimiter = 'MINSECTOR'
    AND n.mapzone_id = 0
    AND EXISTS
        (SELECT 1 FROM temp_pgr_arc a
        WHERE a.mapzone_id = 1 -- from STEP 1
        AND a.graph_delimiter ='MINSECTOR'
        AND a.closed = FALSE
        AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        );

    -- STEP 2 flood with DIRECT cost/reverse_cost without considering the checkvalves (using pgr_drivingdistance with UNDIRECTED GRAPH, a check valve is an open valve)
    IF cardinality(v_pgr_root_vids) >0 THEN

        v_query_text='SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, 
                cost, reverse_cost
                FROM temp_pgr_arc a 
                WHERE a.mapzone_id = 0
                AND a.graph_delimiter <> ''SECTOR''
                ';
        TRUNCATE temp_pgr_drivingdistance;
        INSERT INTO temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
        (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance, directed => false)
        );

        -- border valves that have on the other side a water source
        SELECT  COALESCE(array_agg(DISTINCT start_vid), ARRAY[]::int[])
        INTO v_valve_water
        FROM temp_pgr_drivingdistance d
        JOIN temp_pgr_arc a ON d.node IN (a.pgr_node_1, a.pgr_node_2)
        WHERE a.graph_delimiter ='SECTOR'
        AND (d.node = a.pgr_node_1 AND a.reverse_cost = 0 OR d.node = a.pgr_node_2 AND a."cost" = 0);

        -- the water source
        SELECT COALESCE(array_agg(DISTINCT node), ARRAY[]::int[])
        INTO v_water_source
        FROM temp_pgr_drivingdistance d
        JOIN temp_pgr_arc a ON d.node IN (a.pgr_node_1, a.pgr_node_2)
        WHERE a.graph_delimiter ='SECTOR'
        AND (d.node = a.pgr_node_1 AND a.reverse_cost = 0 OR d.node = a.pgr_node_2 AND a."cost" = 0);

        -- border valves that have on the other side a checkvalve
        SELECT COALESCE(array_agg(DISTINCT start_vid), ARRAY[]::int[])
        INTO v_valve_chk
        FROM temp_pgr_drivingdistance d
        JOIN temp_pgr_arc a ON d.node IN (a.pgr_node_1, a.pgr_node_2)
        WHERE a.graph_delimiter ='MINSECTOR'
        AND a.cost <> a.reverse_cost;

        -- close the valves (not the border checkvalves) for the zones with water and without checkvalves
        UPDATE temp_pgr_arc a SET proposed = TRUE
        WHERE a.graph_delimiter = 'MINSECTOR'
        AND a.mapzone_id = 1
        AND closed = FALSE and to_arc IS NULL
        AND (a.pgr_node_1 = ANY (v_valve_water) OR a.pgr_node_2 = ANY (v_valve_water))
        AND a.pgr_node_1 <> ALL (v_valve_chk) AND a.pgr_node_2 <> ALL (v_valve_chk);

        -- update mapzone_id with value 2 for the zones without water and without any checkvalve (also for border checkvalves)
        UPDATE temp_pgr_node n SET mapzone_id = 2
        FROM (
            SELECT *
            FROM temp_pgr_drivingdistance
            WHERE start_vid <> ALL (v_valve_water)
            AND start_vid <> ALL (v_valve_chk)
        ) d
        WHERE n.pgr_node_id =d.node
        AND n.mapzone_id = 0;

        -- for the arcs that connect with the nodes;
        UPDATE temp_pgr_arc a set mapzone_id = 2
        FROM (
            SELECT *
            FROM temp_pgr_drivingdistance
            WHERE start_vid <> ALL (v_valve_water)
            AND start_vid <> ALL (v_valve_chk)
        ) d
        WHERE d.node IN  (a.pgr_node_1, a.pgr_node_2)
        AND a.mapzone_id = 0;

        SELECT COALESCE(array_agg(start_vid), ARRAY[]::int[])
        INTO v_pgr_root_vids_chk_water
        FROM (SELECT DISTINCT start_vid FROM temp_pgr_drivingdistance) d
        WHERE d.start_vid = ANY (v_valve_water)
        AND d.start_vid = ANY (v_valve_chk);

        SELECT COALESCE(array_agg(start_vid), ARRAY[]::int[])
        INTO v_pgr_root_vids_chk_dry
        FROM (SELECT DISTINCT start_vid FROM temp_pgr_drivingdistance) d
        WHERE d.start_vid <> ALL (v_valve_water)
        AND d.start_vid = ANY (v_valve_chk);

        -- STEP 3 DIRECT flood with cost/reverse_cost for the borders that have dry zones with checkvalves inside
        IF cardinality(v_pgr_root_vids_chk_dry) > 0 THEN
            v_pgr_root_vids = v_pgr_root_vids_chk_dry;

            v_query_text='SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, 
                        cost, reverse_cost
                        FROM temp_pgr_arc a 
                        WHERE a.mapzone_id = 0
                        AND a.graph_delimiter <> ''SECTOR''
                        ';
            TRUNCATE temp_pgr_drivingdistance;
            INSERT INTO temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
            (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
            );

            -- update mapzone_id with value 2
            -- for the nodes
            UPDATE temp_pgr_node n SET mapzone_id = 2
            FROM temp_pgr_drivingdistance d
            WHERE n.pgr_node_id =d.node
            AND n.mapzone_id = 0;

            -- for the arcs that connect with the nodes;
            UPDATE temp_pgr_arc a set mapzone_id = 2
            FROM temp_pgr_drivingdistance d
            WHERE d.node  IN (a.pgr_node_1, a.pgr_node_2)
            AND a.mapzone_id = 0;
        END IF;

        -- STEP 4 INVERTED flood with cost/reverse_cost for the borders that have wet zones with checkvalves inside
        IF  cardinality (v_pgr_root_vids_chk_water) > 0 THEN
            v_pgr_root_vids = v_pgr_root_vids_chk_water;
            -- query pgr_drivingdistance
            v_query_text='SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, 
                    reverse_cost AS cost, cost as reverse_cost
                    FROM temp_pgr_arc a 
                    WHERE a.mapzone_id = 0
                    AND a.graph_delimiter <> ''SECTOR''
                    ';
            TRUNCATE temp_pgr_drivingdistance;
            INSERT INTO temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
            (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
            );

            -- border valves that have on the other side a water source
            SELECT  COALESCE(array_agg(DISTINCT start_vid), ARRAY[]::int[])
            INTO v_valve_water
            FROM temp_pgr_drivingdistance d
            JOIN temp_pgr_arc a ON d.node IN (a.pgr_node_1, a.pgr_node_2)
            WHERE a.graph_delimiter ='SECTOR'
            AND (d.node = a.pgr_node_1 AND a.cost = 0 OR d.node = a.pgr_node_2 AND a.reverse_cost = 0);

            -- close the valves that have on the other side a water source
            UPDATE temp_pgr_arc a SET proposed = TRUE
            WHERE a.graph_delimiter = 'MINSECTOR'
            AND a.mapzone_id = 1
            AND closed = FALSE and to_arc IS NULL
            AND (a.pgr_node_1 = ANY (v_valve_water) OR a.pgr_node_2 = ANY (v_valve_water));

             /*  -- **** substituted by STEP 5 AND 6;
                --without the steps 5 and 6, the result is not the expected one if there is more then 1 checkvalve in row

            -- border valves that don't have a water source on the other side on the STEP 4 flood
            -- update mapzone_id with value 2
            -- for the nodes
            UPDATE temp_pgr_node n SET mapzone_id = 2
            FROM temp_pgr_drivingdistance d
            WHERE d.start_vid <> ALL (v_valve_water)
            AND n.pgr_node_id =d.node
            AND n.mapzone_id = 0;

            -- for the arcs that connect with the nodes;
            UPDATE temp_pgr_arc a set mapzone_id = 2
            WHERE a.mapzone_id = 0
            AND EXISTS
                (SELECT  1 FROM temp_pgr_node n
                WHERE n.mapzone_id = 2
                AND n.pgr_node_id  IN (a.pgr_node_1, a.pgr_node_2));
            */

            -- border valves that don't have a water source on the other side on the STEP 4 flood
            SELECT COALESCE(array_agg(start_vid), ARRAY[]::int[])
            INTO v_pgr_root_vids
            FROM (SELECT DISTINCT start_vid FROM temp_pgr_drivingdistance) d
            WHERE d.start_vid <> ALL (v_valve_water);

            -- STEP 5 DIRECT flood with cost/reverse_cost
            IF cardinality(v_pgr_root_vids) > 0 THEN

                v_query_text='SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, 
                            cost, reverse_cost
                            FROM temp_pgr_arc a 
                            WHERE a.mapzone_id = 0
                            AND a.graph_delimiter <> ''SECTOR''
                            ';
                TRUNCATE temp_pgr_drivingdistance;
                INSERT INTO temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
                (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
                );

                -- update mapzone_id with value 3
                -- for the nodes
                UPDATE temp_pgr_node n SET mapzone_id = 3
                FROM temp_pgr_drivingdistance d
                WHERE n.pgr_node_id =d.node
                AND n.mapzone_id = 0;

                -- for the arcs that connect with the nodes;
                UPDATE temp_pgr_arc a set mapzone_id = 3
                FROM temp_pgr_drivingdistance d
                WHERE d.node  IN (a.pgr_node_1, a.pgr_node_2)
                AND a.mapzone_id = 0;

                 -- STEP 6 DIRECT flood from the water sources saved before (STEP 1)
                 v_pgr_root_vids = v_water_source;

                 -- the query contains the arcs with mapzone_id = 3, from STEP 5
                 v_query_text='SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, 
                            cost, reverse_cost
                            FROM temp_pgr_arc a 
                            WHERE a.mapzone_id = 3
                            AND a.graph_delimiter <> ''SECTOR''
                            ';
                TRUNCATE temp_pgr_drivingdistance;
                INSERT INTO temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
                (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost FROM pgr_drivingdistance(v_query_text, v_pgr_root_vids, v_pgr_distance)
                );

                -- update mapzone_id with value 0 - remove it from the mincut area
                -- for the nodes
                UPDATE temp_pgr_node n SET mapzone_id = 0
                FROM temp_pgr_drivingdistance d
                WHERE n.pgr_node_id =d.node
                AND n.mapzone_id = 3;

                -- for the arcs that connect with the nodes;
                UPDATE temp_pgr_arc a set mapzone_id = 0
                WHERE a.mapzone_id = 3
                AND EXISTS (
                    SELECT 1 FROM temp_pgr_drivingdistance d
                    WHERE a.pgr_node_1 = d.node
                    )
                AND EXISTS (
                    SELECT 1 FROM temp_pgr_drivingdistance d
                    WHERE a.pgr_node_2 = d.node
                    );

                -- put value 3 in 2
                UPDATE temp_pgr_node n SET mapzone_id = 2
                WHERE n.mapzone_id = 3;

                UPDATE temp_pgr_arc a SET mapzone_id = 2
                WHERE a.mapzone_id = 3;
            END IF;
        END IF;
    END IF;


	-- SECTION[epic=mincut]: Controll Nulls
	v_message = COALESCE(v_message, '{}');
	v_version = COALESCE(v_version, '');
	v_mincut = COALESCE(v_mincut, 0);
	v_level = COALESCE(v_level, 0);

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


	-- RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
	-- ',"body":{"form":{}'||
	-- 		',"data":{ '||
	-- 		'  "info":'||v_result_info||
	-- 		', "geometry":"'||v_geometry||'"'||
	-- 		', "mincutDetails":'||v_mincutdetails||'}'||
	-- 		'}'
	-- '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;