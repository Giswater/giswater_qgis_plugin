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
v_ignore_check_valves boolean;

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
v_mincut_id INTEGER;

-- general variables
v_query_text TEXT;
v_mode TEXT;

-- parameters
v_pgr_distance float;
v_root_vids int[];

-- temporary tables for core
v_temp_arc_table regclass;
v_temp_node_table regclass;


-- core variables
v_root_with_water int[];
v_root_with_chk int[];

-- !SECTION

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Get project version
	SELECT giswater, epsg, UPPER(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Parameters
	v_pgr_distance := p_data->'data'->>'pgrDistance';
	v_root_vids := ARRAY(SELECT json_array_elements_text((p_data->'data'->>'pgrRootVids')::json))::int[];
    
    v_mode := p_data->'data'->>'mode';
    v_ignore_check_valves := p_data->'data'->>'ignoreCheckValvesMincut';

    v_temp_arc_table := 'temp_pgr_arc'::regclass;
    v_temp_node_table := 'temp_pgr_node'::regclass;


    -- STEP 1 flood with INVERTED cost_mincut/reverse_cost_mincut for finding the borders
    -- the flood is reversed; the one-way valves that don't stop the water will stay inside the minsector, they cannot be borders because they cannot be closed
    v_query_text='SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, reverse_cost_mincut as cost, cost_mincut as reverse_cost
    FROM ' || v_temp_arc_table;
    TRUNCATE temp_pgr_drivingdistance;
    INSERT INTO  temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
    (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost
    FROM pgr_drivingdistance(v_query_text, v_root_vids, v_pgr_distance)
    );

    -- update mapzone_id with value 1
    -- for the nodes
    EXECUTE format(
        'UPDATE %I n SET mapzone_id = 1
        FROM temp_pgr_drivingdistance d
        WHERE n.pgr_node_id =d.node;', 
        v_temp_node_table
    );

   	-- for the arcs that connect with the nodes;

    EXECUTE format(
        'UPDATE %I a set mapzone_id = 1
        FROM temp_pgr_drivingdistance d
        WHERE d.node IN  (a.pgr_node_1, a.pgr_node_2);',
        v_temp_arc_table
    );

    -- v_root_vids - for open valves + chk valves (if v_ignore_check_valves =FALSE)
    EXECUTE format(
        'SELECT COALESCE(array_agg(n.pgr_node_id), ARRAY[]::int[])
        FROM %I n
        WHERE n.graph_delimiter = ''MINSECTOR''
        AND n.mapzone_id = 0
        AND EXISTS
            (SELECT 1 FROM %I a
            WHERE a.mapzone_id = 1
            AND a.graph_delimiter =''MINSECTOR''
            AND (a.cost >= 0 OR a.reverse_cost >=0)
            AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
            );', 
        v_temp_node_table, v_temp_arc_table
    ) INTO v_root_vids;

    -- STEP 2 flood with DIRECT cost/reverse_cost without considering the checkvalves (using pgr_drivingdistance with UNDIRECTED GRAPH, a check valve is an open valve)
    IF cardinality(v_root_vids) >0 THEN

        v_query_text = format(
            'SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, 
            cost, reverse_cost
            FROM %I a 
            WHERE a.mapzone_id = 0
            AND a.graph_delimiter <> ''SECTOR'';',
            v_temp_arc_table
        );

        TRUNCATE temp_pgr_drivingdistance;
        INSERT INTO temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
        (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost FROM pgr_drivingdistance(v_query_text, v_root_vids, v_pgr_distance, directed => false)
        );

        -- border valves (open + chk) that have on the other side a water source
        EXECUTE format(
            'SELECT COALESCE(array_agg(DISTINCT d.start_vid), ARRAY[]::int[])
            FROM temp_pgr_drivingdistance d
            JOIN %I a ON d.node IN (a.pgr_node_1, a.pgr_node_2)
            WHERE a.graph_delimiter = ''SECTOR''
            AND (d.node = a.pgr_node_1 AND a.reverse_cost >= 0 OR d.node = a.pgr_node_2 AND a."cost" >= 0);',
            v_temp_arc_table
        ) INTO v_root_with_water;

        -- border valves (open + chk) that have on the other side a checkvalve
        EXECUTE format(
            'SELECT COALESCE(array_agg(DISTINCT d.start_vid), ARRAY[]::int[])
            FROM temp_pgr_drivingdistance d
            JOIN %I a ON d.node IN (a.pgr_node_1, a.pgr_node_2)
            WHERE a.graph_delimiter = ''MINSECTOR''
            AND a.cost <> a.reverse_cost
            AND d.node <> d.start_vid;',
            v_temp_arc_table
        ) INTO v_root_with_chk;

        -- close the border open valves (not the border checkvalves) when the zones are with water and without checkvalves
        EXECUTE format(
            'UPDATE %I a SET proposed = TRUE
             FROM (
                SELECT DISTINCT start_vid
                FROM temp_pgr_drivingdistance
                WHERE start_vid = ANY ($1)
                AND start_vid <> ALL ($2)
            ) d
            WHERE a.graph_delimiter = ''MINSECTOR''
            AND a.mapzone_id = 1
            AND a.cost >= 0 AND a.reverse_cost >= 0
            AND d.start_vid IN (a.pgr_node_1, a.pgr_node_2);',
            v_temp_arc_table
        )
        USING v_root_with_water, v_root_with_chk;

        -- update mapzone_id with value 2 for the border open valves and check valves when the zones are without water and without checkvalves
        EXECUTE format(
            'UPDATE %I n SET mapzone_id = 2
            FROM (
                SELECT DISTINCT node
                FROM temp_pgr_drivingdistance
                WHERE start_vid <> ALL ($1)
            ) d
            WHERE n.pgr_node_id =d.node
            AND n.mapzone_id = 0;', 
            v_temp_node_table
        )
        USING v_root_with_water;

        -- for the arcs that connect with the nodes;
        EXECUTE format(
            'UPDATE %I a set mapzone_id = 2
            WHERE a.mapzone_id = 0
            AND EXISTS (
                SELECT  1 FROM %I n
                WHERE n.mapzone_id = 2
                AND n.pgr_node_id  IN (a.pgr_node_1, a.pgr_node_2)
            );',
            v_temp_arc_table, v_temp_node_table
        );

        -- v_root_vids - for the border open valves that have zones with water and with checkvalves
        EXECUTE format(
            'SELECT COALESCE(array_agg(d.start_vid), ARRAY[]::int[])
            FROM (
                SELECT DISTINCT start_vid 
                FROM temp_pgr_drivingdistance
                WHERE start_vid = ANY ($1)
                AND start_vid = ANY ($2)
            ) d
            JOIN %I a ON d.start_vid IN (a.pgr_node_1, a.pgr_node_2)
            WHERE a.graph_delimiter = ''MINSECTOR''
            AND a.mapzone_id = 1
            AND a.cost >= 0 AND a.reverse_cost >= 0;',
            v_temp_arc_table
        )
        USING v_root_with_water, v_root_with_chk
        INTO v_root_vids;

        -- STEP 3 INVERTED flood with cost/reverse_cost for the borders that have wet zones with checkvalves inside
        IF  cardinality (v_root_vids) > 0 THEN

            -- query pgr_drivingdistance
            v_query_text = format(
                'SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, 
                reverse_cost AS cost, cost as reverse_cost
                FROM %I a 
                WHERE a.mapzone_id = 0
                AND a.graph_delimiter <> ''SECTOR'';',
                v_temp_arc_table
            );

            TRUNCATE temp_pgr_drivingdistance;
            INSERT INTO temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
            (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost FROM pgr_drivingdistance(v_query_text, v_root_vids, v_pgr_distance)
            );

            -- border valves that have on the other side a water source
            EXECUTE format(
                'SELECT COALESCE(array_agg(DISTINCT start_vid), ARRAY[]::int[])
                FROM temp_pgr_drivingdistance d
                JOIN %I a ON d.node IN (a.pgr_node_1, a.pgr_node_2)
                WHERE a.graph_delimiter = ''SECTOR''
                AND (d.node = a.pgr_node_1 AND a.cost >= 0 OR d.node = a.pgr_node_2 AND a.reverse_cost >= 0);',
                v_temp_arc_table
            ) INTO v_root_with_water;

            -- close the valves that have on the other side a water source
            EXECUTE format(
                'UPDATE %I a SET proposed = TRUE
                FROM (
                    SELECT DISTINCT start_vid
                    FROM temp_pgr_drivingdistance
                    WHERE start_vid = ANY ($1)
                ) d
                WHERE a.graph_delimiter = ''MINSECTOR''
                AND a.mapzone_id = 1
                AND a.cost >= 0 AND a.reverse_cost >= 0
                AND d.start_vid IN (a.pgr_node_1, a.pgr_node_2);',
                v_temp_arc_table
            )
            USING v_root_with_water;

            -- si v_ignore_check_valves is TRUE, close also the valves that seems without water because of a checkvalve
            IF v_ignore_check_valves THEN
                EXECUTE format(
                    'UPDATE %I a SET proposed = TRUE
                    FROM (
                        SELECT DISTINCT start_vid
                        FROM temp_pgr_drivingdistance
                        WHERE start_vid <> ALL ($1)
                    ) d
                    WHERE a.graph_delimiter = ''MINSECTOR''
                    AND a.mapzone_id = 1
                    AND a.cost >= 0 AND a.reverse_cost >= 0
                    AND d.start_vid IN (a.pgr_node_1, a.pgr_node_2);',
                    v_temp_arc_table
                )
                USING v_root_with_water;
            END IF;

            -- update mapzone_id with value 2 for the border open valves when the zones are without water
            -- for the nodes
            EXECUTE format(
                'UPDATE %I n SET mapzone_id = 2
                FROM (
                    SELECT DISTINCT node
                    FROM temp_pgr_drivingdistance
                    WHERE start_vid <> ALL ($1)
                ) d
                WHERE n.pgr_node_id =d.node
                AND n.mapzone_id = 0;', 
                v_temp_node_table
            )
            USING v_root_with_water;

            -- for the arcs that connect with the nodes
            EXECUTE format(
                'UPDATE %I a set mapzone_id = 2
                WHERE a.mapzone_id = 0
                AND EXISTS (
                    SELECT  1 FROM %I n
                    WHERE n.mapzone_id = 2
                    AND n.pgr_node_id  IN (a.pgr_node_1, a.pgr_node_2)
                );',
                v_temp_arc_table, v_temp_node_table
            );
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