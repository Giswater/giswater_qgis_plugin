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
        WITH
            mapzone AS (
                SELECT 
                    component, 
                    CASE 
                        WHEN CARDINALITY (mapzone_id) = 1 THEN mapzone_id[1]
                        ELSE -1
                    END AS mapzone_id,
                    mapzone_id as name,
                    CASE 
                        WHEN CARDINALITY (mapzone_id) = 1 THEN name
                        ELSE ''Conflict''
                    END AS descript
            FROM temp_pgr_mapzone
            ),
            drivingdistance AS (
                SELECT n.mapzone_id AS component, n.node_id AS nodeparent, a.arc_id, d.edge, d.node, d.agg_cost
                FROM temp_pgr_drivingdistance d
                JOIN temp_pgr_arc a ON d.edge = a.pgr_arc_id 
                JOIN temp_pgr_node n ON d.start_vid = n.pgr_node_id 
            ),
            arcs_drivingdistance AS (
                SELECT component, nodeparent, arc_id, agg_cost
                FROM drivingdistance
                WHERE arc_id IS NOT NULL
            ),
            arcs_add_node1_node2 AS (
                SELECT dn.component, dn.nodeparent, a.arc_id, dn.agg_cost + a.COST AS agg_cost
                FROM temp_pgr_arc a
                JOIN drivingdistance dn ON a.pgr_node_1 = dn.node
                WHERE a.arc_id IS NOT NULL 
                AND a.COST > 0
                AND NOT EXISTS (
                    SELECT 1 FROM drivingdistance da 
                    WHERE da.nodeparent = dn.nodeparent
                    AND da.edge = a.pgr_arc_id
                )
                UNION ALL
                SELECT dn.component, dn.nodeparent, a.arc_id, dn.agg_cost + a.reverse_cost AS agg_cost
                FROM temp_pgr_arc a
                JOIN drivingdistance dn ON a.pgr_node_2 = dn.node
                WHERE a.arc_id IS NOT NULL 
                AND a.reverse_cost > 0
                AND NOT EXISTS (
                    SELECT 1 FROM drivingdistance da 
                    WHERE da.nodeparent = dn.nodeparent
                    AND da.edge = a.pgr_arc_id
                )
            ),
            arcs_add AS (
                SELECT component, nodeparent, arc_id, min(agg_cost) AS agg_cost
                FROM arcs_add_node1_node2
                GROUP BY component, nodeparent, arc_id
            ),
            connected_arcs AS (
                SELECT component, nodeparent, arc_id, agg_cost 
                FROM arcs_drivingdistance
                UNION ALL 
                SELECT component, nodeparent, arc_id, agg_cost 
                FROM arcs_add
            )
        SELECT jsonb_build_object(
            ''type'', ''FeatureCollection'',
            ''layerName'', ''Graphanalytics tstep process'',
            ''features'', jsonb_agg(jsonb_build_object(
                ''type'', ''Feature'',
                ''geometry'', ST_AsGeoJSON(ST_Transform(va.the_geom, 4326))::jsonb,
                ''properties'', jsonb_build_object(
                    ''arc_id'', ca.arc_id,
                    ''nodeparent'', ca.nodeparent,
                    ''node_1'', va.node_1,
                    ''node_2'', va.node_2,
                    ''arc_type'', c.arc_type,
                    ''state'', va.state,
                    ''state_type'', va.state_type,
                    ''is_operative'', va.is_operative,
                    ''mapzone_id'', m.mapzone_id,
                    ''mapzone_name'', array_to_string(m.name, '',''),
                    ''mapzone_descript'', m.descript,
                    ''timestep'', (concat(''2001-01-01 01:'', floor(ca.agg_cost)::integer / 60, '':'', floor(ca.agg_cost)::integer % 60))::timestamp)
                )
            )
        )
        FROM connected_arcs ca
        JOIN mapzone m USING (component)
        JOIN v_temp_arc va USING (arc_id)
        JOIN cat_arc c ON va.arccat_id = c.id
        ;
    ';

    EXECUTE v_querytext INTO geojson_result;

    RETURN gw_fct_json_create_return((
        '{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"' || v_version || '", "body":{"form":{},"data":{"line":' || geojson_result || '}}}'
    )::json, 3336, null, null, null);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
