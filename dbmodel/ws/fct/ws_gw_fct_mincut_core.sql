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
v_count integer;
v_mode TEXT;

-- parameters
v_pgr_distance float;
v_root_vids int[];

-- temporary tables for core

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

    -- STEP 1 flood with INVERTED cost_mincut/reverse_cost_mincut for finding the borders
    -- the flood is reversed; the one-way valves that don't stop the water will stay inside the minsector, they cannot be borders because they cannot be closed
    v_query_text='
        SELECT pgr_arc_id as id, pgr_node_2 as source, pgr_node_1 as target, cost_mincut as cost, reverse_cost_mincut as reverse_cost
        FROM temp_pgr_arc_linegraph
    ';
    TRUNCATE temp_pgr_drivingdistance;
    INSERT INTO  temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
    (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost
    FROM pgr_drivingdistance(v_query_text, v_root_vids, v_pgr_distance)
    );

    -- update mapzone_id with value 1
    -- for the nodes
    UPDATE temp_pgr_node_minsector n
    SET mapzone_id = 1
    FROM temp_pgr_drivingdistance d
    WHERE n.pgr_node_id = d.node;

   	-- for the arcs that connect with the nodes;
    UPDATE temp_pgr_arc_linegraph a 
    SET mapzone_id = 1
    WHERE EXISTS (
        SELECT 1 
        FROM temp_pgr_drivingdistance d
        WHERE d.node IN  (a.pgr_node_1, a.pgr_node_2)
    );

    -- v_root_vids - for open valves + chk valves (if v_ignore_check_valves =FALSE)
    SELECT COALESCE(array_agg(n.pgr_node_id), ARRAY[]::int[])
    INTO v_root_vids
    FROM temp_pgr_node_minsector n
    WHERE n.mapzone_id = 0
    AND EXISTS (
        SELECT 1
        FROM temp_pgr_arc_linegraph a
        WHERE a.mapzone_id = 1
        AND (a.cost >= 0 OR a.reverse_cost >= 0)
        AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
    );

    -- STEP 2 flood with DIRECT cost/reverse_cost without considering the checkvalves (using pgr_drivingdistance with UNDIRECTED GRAPH, a check valve is an open valve)
    IF cardinality(v_root_vids) >0 THEN

        TRUNCATE temp_pgr_drivingdistance;
        
        SELECT count(*) INTO v_count FROM temp_pgr_arc_linegraph WHERE mapzone_id = 0;

        IF v_count = 0 THEN

            INSERT INTO temp_pgr_drivingdistance("depth",start_vid,pred,node,edge,"cost",agg_cost)
            SELECT 0, n.pgr_node_id, n.pgr_node_id, n.pgr_node_id, -1, 0, 0
            FROM temp_pgr_node_minsector n
            WHERE n.pgr_node_id = ANY (v_root_vids);
        
        ELSE 
             v_query_text = '
                SELECT pgr_arc_id as id, pgr_node_1 as source, pgr_node_2 as target, cost, reverse_cost
                FROM temp_pgr_arc_linegraph  
                WHERE mapzone_id = 0
            ';
            INSERT INTO temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
            (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost FROM pgr_drivingdistance(v_query_text, v_root_vids, v_pgr_distance, directed => false)
            );

        END IF;

        -- border valves (open + chk) that have on the other side a water source
        SELECT COALESCE(array_agg(DISTINCT d.start_vid), ARRAY[]::int[])
        INTO v_root_with_water
        FROM temp_pgr_drivingdistance d
        JOIN temp_pgr_node_minsector n ON d.node = n.pgr_node_id
        WHERE n.graph_delimiter = 'SECTOR';

        -- border valves (open + chk) that have on the other side a checkvalve
        SELECT COALESCE(array_agg(DISTINCT d.start_vid), ARRAY[]::int[])
        INTO v_root_with_chk
        FROM temp_pgr_drivingdistance d
        JOIN temp_pgr_arc_linegraph a ON d.node IN (a.pgr_node_1, a.pgr_node_2)
        WHERE a.cost <> a.reverse_cost
        AND a.mapzone_id = 0;

        -- close the border open valves (not the border checkvalves) when the zones are with water and without checkvalves
        UPDATE temp_pgr_arc_linegraph a
        SET proposed = TRUE
        FROM (
            SELECT DISTINCT start_vid
            FROM temp_pgr_drivingdistance
            WHERE start_vid = ANY (v_root_with_water)
            AND NOT (start_vid = ANY (v_root_with_chk))
        ) d
        WHERE a.mapzone_id = 1
        AND a.cost >= 0
        AND a.reverse_cost >= 0
        AND d.start_vid IN (a.pgr_node_1, a.pgr_node_2);


        -- update mapzone_id with value 2 for the border open valves and check valves when the zones are without water and without checkvalves
        UPDATE temp_pgr_node_minsector n
        SET mapzone_id = 2
        FROM (
            SELECT DISTINCT node
            FROM temp_pgr_drivingdistance
            WHERE start_vid <> ALL (v_root_with_water)
        ) d
        WHERE n.pgr_node_id = d.node
        AND n.mapzone_id = 0;

        -- for the arcs that connect with the nodes;
        UPDATE temp_pgr_arc_linegraph a
        SET mapzone_id = 2
        WHERE a.mapzone_id = 0
        AND EXISTS (
            SELECT 1
            FROM temp_pgr_node_minsector n
            WHERE n.mapzone_id = 2
            AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
        );

        -- v_root_vids - for the border open valves that have zones with water and with checkvalves
        SELECT COALESCE(array_agg(d.start_vid), ARRAY[]::int[])
        INTO v_root_vids
        FROM (
            SELECT DISTINCT start_vid
            FROM temp_pgr_drivingdistance
            WHERE start_vid = ANY (v_root_with_water)
            AND start_vid = ANY (v_root_with_chk)
        ) d
        JOIN temp_pgr_arc_linegraph a
        ON d.start_vid IN (a.pgr_node_1, a.pgr_node_2)
        WHERE a.mapzone_id = 1
        AND a.cost >= 0
        AND a.reverse_cost >= 0;

        -- STEP 3 INVERTED flood with cost/reverse_cost for the borders that have wet zones with checkvalves inside

        IF  cardinality (v_root_vids) > 0 THEN

            TRUNCATE temp_pgr_drivingdistance;
    
            SELECT count(*) INTO v_count FROM temp_pgr_arc_linegraph WHERE mapzone_id = 0;

            IF v_count = 0 THEN

                INSERT INTO temp_pgr_drivingdistance("depth",start_vid,pred,node,edge,"cost",agg_cost)
                SELECT 0, n.pgr_node_id, n.pgr_node_id, n.pgr_node_id, -1, 0, 0
                FROM temp_pgr_node_minsector n
                WHERE n.pgr_node_id = ANY (v_root_vids);
            
            ELSE 

                -- query pgr_drivingdistance
                v_query_text = 
                    'SELECT pgr_arc_id as id, pgr_node_2 as source, pgr_node_1 as target, cost, reverse_cost
                    FROM temp_pgr_arc_linegraph a 
                    WHERE a.mapzone_id = 0
                ';

                TRUNCATE temp_pgr_drivingdistance;
                INSERT INTO temp_pgr_drivingdistance(seq,"depth",start_vid,pred,node,edge,"cost",agg_cost)
                (SELECT seq,"depth",start_vid,pred,node,edge,"cost",agg_cost FROM pgr_drivingdistance(v_query_text, v_root_vids, v_pgr_distance)
                );
            END IF;

            -- border valves that have on the other side a water source
            SELECT COALESCE(array_agg(DISTINCT d.start_vid), ARRAY[]::int[])
            INTO v_root_with_water
            FROM temp_pgr_drivingdistance d
            JOIN temp_pgr_node_minsector n ON d.node = n.pgr_node_id
            WHERE n.graph_delimiter = 'SECTOR';

            -- close the valves that have on the other side a water source
            UPDATE temp_pgr_arc_linegraph a
            SET proposed = TRUE
            FROM (
                SELECT DISTINCT start_vid
                FROM temp_pgr_drivingdistance
                WHERE start_vid = ANY (v_root_with_water)
            ) d
            WHERE a.mapzone_id = 1
            AND a.cost >= 0
            AND a.reverse_cost >= 0
            AND d.start_vid IN (a.pgr_node_1, a.pgr_node_2);

            -- si v_ignore_check_valves is TRUE, close also the valves that seem without water because of a checkvalve
            IF v_ignore_check_valves THEN
                UPDATE temp_pgr_arc_linegraph a
                SET proposed = TRUE
                FROM (
                    SELECT DISTINCT start_vid
                    FROM temp_pgr_drivingdistance
                    WHERE start_vid <> ALL (v_root_with_water)
                ) d
                WHERE a.mapzone_id = 1
                AND a.cost >= 0
                AND a.reverse_cost >= 0
                AND d.start_vid IN (a.pgr_node_1, a.pgr_node_2);
            END IF;

            -- update mapzone_id with value 2 for the border open valves when the zones are without water
            -- for the nodes
            UPDATE temp_pgr_node_minsector n
            SET mapzone_id = 2
            FROM (
                SELECT DISTINCT node
                FROM temp_pgr_drivingdistance
                WHERE start_vid <> ALL (v_root_with_water)
            ) d
            WHERE n.pgr_node_id = d.node
            AND n.mapzone_id = 0;

            -- for the arcs that connect with the nodes
            UPDATE temp_pgr_arc_linegraph a
            SET mapzone_id = 2
            WHERE a.mapzone_id = 0
            AND EXISTS (
                SELECT 1
                FROM temp_pgr_node_minsector n
                WHERE n.mapzone_id = 2
                AND n.pgr_node_id IN (a.pgr_node_1, a.pgr_node_2)
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