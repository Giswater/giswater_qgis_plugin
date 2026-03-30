/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_hydraulic_trace(p_data json)
RETURNS json
LANGUAGE plpgsql
AS $function$

/*
SELECT gw_fct_cm_hydraulic_trace($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"header": 1081,"stoppers": [1080]}}}$$);
*/


DECLARE

-- Init
v_version text;
v_srid integer;

-- Inputs
v_header bigint;
v_stoppers bigint[];
v_table_stoppers text[];

-- SQL
v_sql text;
v_agg bigint[];
tblname text;

-- Control
v_exists boolean;

-- Return
v_result json;
v_result_line json;
v_result_info json;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    -- Version
    SELECT giswater, epsg INTO v_version, v_srid 
    FROM sys_version ORDER BY id DESC LIMIT 1;

    -- Params from JSON
    v_header := (p_data -> 'data' -> 'parameters' ->> 'nodeId')::bigint;

    SELECT array_agg(value::bigint)
    INTO v_stoppers
    FROM json_array_elements_text(p_data -> 'data' -> 'parameters' -> 'stoppers');

    IF v_stoppers IS NULL THEN
        SELECT array_agg(concat('PARENT_SCHEMA_', lower(cat_feature.id))) INTO v_table_stoppers
        FROM PARENT_SCHEMA.cat_feature_node
			JOIN PARENT_SCHEMA.cat_feature ON cat_feature.id = cat_feature_node.id
        WHERE 'MINSECTOR' = ANY(graph_delimiter) AND cat_feature.feature_class = 'VALVE';
    END IF;

    IF v_table_stoppers IS NOT NULL THEN
        v_table_stoppers := ARRAY(
            SELECT tbl
            FROM unnest(v_table_stoppers) AS tbl
            WHERE EXISTS (
                SELECT 1
                FROM information_schema.columns
                WHERE table_name = tbl
                  AND column_name = 'closed'
                  AND table_schema = 'SCHEMA_NAME'
            )
			AND EXISTS (
                SELECT 1
                FROM information_schema.columns
                WHERE table_name = tbl
                  AND column_name = 'node_id'
                  AND table_schema = 'SCHEMA_NAME'
            )
        );
    END IF;

    -- Closed node ids from MINSECTOR feature tables -> v_stoppers
    IF v_table_stoppers IS NOT NULL THEN
        v_stoppers := ARRAY[]::bigint[];
        FOR tblname IN SELECT unnest(v_table_stoppers)
        LOOP
            EXECUTE format(
                'SELECT array_agg(node_id) FROM "SCHEMA_NAME".%I WHERE closed IS TRUE',
                tblname
            ) INTO v_agg;
            IF v_agg IS NOT NULL THEN
                v_stoppers := v_stoppers || v_agg;
            END IF;
        END LOOP;
    END IF;

    IF v_stoppers IS NULL THEN
        v_stoppers := ARRAY[]::bigint[];
    END IF;

    CREATE TEMP TABLE IF NOT EXISTS t_audit_check_data (LIKE audit_check_data INCLUDING ALL);

    -- Core query (adapted from original SQL function)
    v_sql := format($sql$

        WITH
        valid_header AS (
            SELECT %s AS header
            WHERE NOT (%s = ANY(%L::bigint[]))
        ),
        cc AS (
            SELECT *
            FROM pgr_connectedComponents(
                format(
                    $inner$
                    SELECT
                        arc_id AS id,
                        node_1 AS source,
                        node_2 AS target,
                        1.0::float8 AS cost,
                        1.0::float8 AS reverse_cost
                    FROM om_campaign_x_arc
                    WHERE node_1 <> ALL(%%L::bigint[])
                      AND node_2 <> ALL(%%L::bigint[])
						AND node_1 IS NOT NULL AND node_2 IS NOT NULL
                    $inner$,
                    %L,
                    %L
                )
            )
        ),
        header_component AS (
            SELECT c.component
            FROM cc c
            JOIN valid_header vh
              ON c.node = vh.header
        ),
        reachable_nodes AS (
            SELECT c.node
            FROM cc c
            JOIN header_component hc
              ON c.component = hc.component
        )
        SELECT DISTINCT
            a.arc_id,
            a.node_1,
            a.node_2,
            a.the_geom
        FROM om_campaign_x_arc a
        WHERE
			  (larc.action IS NULL OR larc.action <> 3)
		  AND ((
                a.node_1 IN (SELECT node FROM reachable_nodes)
                AND a.node_2 IN (SELECT node FROM reachable_nodes)
              )
           OR (
                a.node_1 IN (SELECT node FROM reachable_nodes)
                AND a.node_2 = ANY(%L)
              )
           OR (
                a.node_2 IN (SELECT node FROM reachable_nodes)
                AND a.node_1 = ANY(%L)
              ))
        ORDER BY a.arc_id

    $sql$,
    v_header, v_header, v_stoppers,
    v_stoppers, v_stoppers,
    v_stoppers, v_stoppers
    );

    -- Check results
    EXECUTE 'SELECT EXISTS(' || v_sql || ')' INTO v_exists;

    IF v_exists IS NOT TRUE THEN
        INSERT INTO t_audit_check_data (fid, criticity, error_message)
        SELECT 999, log_level, concat(error_message, ' ', hint_message)
        FROM PARENT_SCHEMA.sys_message WHERE id = 4444;
    END IF;

    -- GeoJSON output
    EXECUTE format(
        'SELECT jsonb_build_object(
            ''type'', ''FeatureCollection'',
            ''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
        )
        FROM (
            SELECT jsonb_build_object(
                ''type'', ''Feature'',
                ''geometry'', ST_Transform(the_geom, 4326),
                ''properties'', to_jsonb(row) - ''the_geom''
            ) AS feature
            FROM (%s) row
        ) features',
        v_sql
    ) INTO v_result;

    v_result_line := COALESCE(v_result, '{}');

    -- Info
    INSERT INTO t_audit_check_data (fid, criticity, error_message)
    VALUES (999, 1, concat('Hydraulic trace executed from header ', v_header));

    SELECT array_to_json(array_agg(row_to_json(row)))
    INTO v_result
    FROM (
        SELECT id, error_message as message 
        FROM t_audit_check_data WHERE fid = 999
    ) row;

    v_result := COALESCE(v_result, '{}');
    v_result_info := concat('{"values":', v_result, '}');

    DROP TABLE IF EXISTS t_audit_check_data;

    v_result_info := COALESCE(v_result_info, '{}');
    v_result_line := COALESCE(v_result_line, '{}');

    -- Final return (IDENTICAL STRUCTURE)
    RETURN PARENT_SCHEMA.gw_fct_json_create_return(
        (
            '{"status":"Accepted",
              "message":{"level":1, "text":"Analysis done successfully"},
              "version":"' || v_version || '",
              "body":{
                  "form":{},
                  "data":{
                      "info":' || v_result_info || ',
                      "line":' || v_result_line || '
                  }
              }
            }'
        )::json,
        2110, null, null, null
    );

END;
$function$;