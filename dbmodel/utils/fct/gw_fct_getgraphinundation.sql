/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3336

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getgraphinundation();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getgraphinundation()
  RETURNS json AS
$BODY$

DECLARE
    geojson_result json;
	v_version text;
BEGIN

	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    SELECT jsonb_build_object(
        'type', 'FeatureCollection',
        'features', jsonb_agg(jsonb_build_object(
            'type', 'Feature',
            'geometry', ST_AsGeoJSON(b.the_geom)::jsonb,
            'properties', jsonb_build_object(
                'arc_id', a.arc_id,
                'node_1', a.node_1,
                'node_2', a.node_2,
                'arc_type', b.arc_type,
                'state', b.state,
                'state_type', b.state_type,
                'is_operative', b.is_operative,
                'timestep', (concat('2001-01-01 01:', a.checkf / 60, ':', a.checkf % 60))::timestamp
            )
        ))
    ) INTO geojson_result
    FROM temp_anlgraph a
    JOIN v_edit_arc b ON a.arc_id = b.arc_id
    WHERE a.cur_user = current_user;

    RETURN gw_fct_json_create_return((
        '{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"' || v_version || '", "body":{"form":{},"data":{"line":' || geojson_result || '}}}'
    )::json, 3336, null, null, null);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
