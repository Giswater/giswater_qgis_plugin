/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- SELECT SCHEMA_NAME.gw_fct_getgraphinundation($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"mapzone":"SECTOR"}}}$$);
-- SELECT SCHEMA_NAME.gw_fct_getgraphinundation($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"mapzone":"DMA"}}}$$);
-- SELECT SCHEMA_NAME.gw_fct_getgraphinundation($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"mapzone":"PRESSZONE"}}}$$);
-- SELECT SCHEMA_NAME.gw_fct_getgraphinundation($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"mapzone":"DQA"}}}$$);



--FUNCTION CODE: 3336

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getgraphinundation(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getgraphinundation(p_data json)
  RETURNS json AS
$BODY$

DECLARE
    geojson_result json;
	v_version text;
    v_querytext text;

    v_mapzone text;
    v_mapzone_field text;

BEGIN

	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    v_mapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'mapzone');
    v_mapzone_field = v_mapzone || '_id';

    v_querytext = '
        WITH connected_arcs AS (
            SELECT d1.start_vid,
            a.pgr_arc_id,
            d1.edge AS edge1,
            d2.edge AS edge2,
            CASE
                WHEN a.pgr_arc_id = d1.edge THEN d1.agg_cost
                WHEN a.pgr_arc_id = d2.edge THEN d2.agg_cost
                ELSE
                LEAST(
                    CASE WHEN a.cost >= 0 THEN d1.agg_cost + a.cost ELSE NULL END,
                    CASE WHEN a.reverse_cost>=0 THEN d2.agg_cost + a.reverse_cost ELSE NULL END
                )
            END AS agg_cost,
            d1.depth AS depth1,
            d2.depth AS depth2,
            d1.agg_cost AS agg_cost1,
            d2.agg_cost AS agg_cost2,
            a.arc_id,
            a.node_1,
            a.node_2,
            a.mapzone_id,
            a.cost,
            a.reverse_cost
            FROM temp_pgr_arc a
            JOIN temp_pgr_drivingdistance d1 ON a.pgr_node_1 = d1.node
            JOIN temp_pgr_drivingdistance d2 ON a.pgr_node_2 = d2.node
            WHERE d1.start_vid = d2.start_vid
            AND (
                a.cost >= 0 OR a.reverse_cost >= 0
            )
        ), relation AS (
            SELECT start_vid, start_vid_mapzone_id, start_vid_mapzone_name
            FROM connected_arcs c
            JOIN (
                SELECT dma_id AS start_vid_mapzone_id, name AS start_vid_mapzone_name, ((json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'')::integer AS node_id
                FROM dma WHERE graphconfig IS NOT NULL AND active IS TRUE
            ) s ON c.node_1 = s.node_id
        )
        SELECT jsonb_build_object(
        ''type'', ''FeatureCollection'',
        ''layerName'', ''Graphanalytics tstep process'',
        ''features'', jsonb_agg(jsonb_build_object(
            ''type'', ''Feature'',
            ''geometry'', ST_AsGeoJSON(ST_Transform(a.the_geom, 4326))::jsonb,
            ''properties'', jsonb_build_object(
                ''arc_id'', a.arc_id,
                ''start_vid'', c.start_vid,
                ''node_1'', a.node_1,
                ''node_2'', a.node_2,
                ''arc_type'', ca.arc_type,
                ''state'', a.state,
                ''state_type'', a.state_type,
                ''is_operative'', vst.is_operative,
                ''mapzone_id'', r.start_vid_mapzone_id,
                ''mapzone_name'', r.start_vid_mapzone_name,
                ''timestep'', (concat(''2001-01-01 01:'', floor(c.agg_cost)::integer / 60, '':'', floor(c.agg_cost)::integer % 60))::timestamp

            )
        ))
    )
    FROM connected_arcs c
    JOIN arc a on c.arc_id = a.arc_id
    JOIN cat_arc ca ON a.arccat_id::text = ca.id::text
    JOIN value_state_type vst ON vst.id = a.state_type
    JOIN relation r ON c.start_vid = r.start_vid;
    ';

    EXECUTE v_querytext INTO geojson_result;

    RETURN gw_fct_json_create_return((
        '{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"' || v_version || '", "body":{"form":{},"data":{"line":' || geojson_result || '}}}'
    )::json, 3336, null, null, null);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
