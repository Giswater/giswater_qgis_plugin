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

    EXECUTE format($sql$
		SELECT jsonb_build_object(
			'type', 'FeatureCollection',
            'layerName', 'Graphanalytics tstep process',
			'features', COALESCE(jsonb_agg(f.feature), '[]'::jsonb)
		)
		FROM (
			SELECT jsonb_build_object(
			'type',       'Feature',
			'geometry',   ST_AsGeoJSON(ST_Transform(r.the_geom, 4326))::jsonb,
			'properties', to_jsonb(r) - 'the_geom'
			) AS feature
			FROM (
			SELECT
				SELECT a.arc_id, d.start_vid, a.node_1, a.node_2, a.arccat_id, a.state, a.expl_id,
				array_to_string(m.mapzone_ids, ',') AS %I,
				(a.%I)::text AS %I,
				a.the_geom,
				m.name AS descript
			FROM temp_pgr_arc ta
            JOIN temp_pgr_drivingdistance d ON ta.pgr_arc_id = d.node
			JOIN arc a ON a.arc_id = ta.pgr_arc_id
			JOIN temp_pgr_mapzone m ON m.component = ta.component
			WHERE ta.mapzone_id IN (0, -1)
			%s
			) r
		) f
		$sql$,
		v_mapzone_field, v_mapzone_field, 'old_' || v_mapzone_field,
		v_query_text_aux
		) INTO geojson_result;

    RETURN gw_fct_json_create_return((
        '{"status":"Accepted", 
        "message":{
            "level":1, 
            "text":"Process done successfully"
        }, 
        "version":"' || v_version || '", 
        "body":{
            "form":{},
            "data":{
                "line":' || geojson_result || '
            }
        }
    }'
    )::json, 3336, null, null, null);

    EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
		RETURN json_build_object(
		'status', 'Failed',
		'NOSQLERRM', SQLERRM,
		'message', json_build_object(
			'level', right(SQLSTATE, 1),
			'text', SQLERRM
		),
		'SQLSTATE', SQLSTATE,
		'SQLCONTEXT', v_error_context
	);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
