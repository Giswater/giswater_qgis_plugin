/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getfeaturesfrompolygon(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeaturesfrompolygon(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
EXAMPLE:

SELECT gw_fct_getfeaturesfrompolygon($${"client":{"device":4, "lang":"es_ES", "version":"4.0.001", "infoType":1, "epsg":25831},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"functionFid": 3532, "featureType":"arc", "polygonGeom":"MULTIPOLYGON (((419617.361558083 4576465.809154497, 419618.8569710209 4576468.246374115, 419622.2276227002 4576466.157956117, 419620.73944153683 4576463.628078675, 419617.361558083 4576465.809154497)))"}}}$$);

*/

DECLARE
v_message JSON;
v_version TEXT;
v_srid INTEGER;
v_status TEXT = 'Accepted';
v_error_context TEXT;
v_feature_type TEXT;
v_sql TEXT;
v_data TEXT;
v_polygon_geom TEXT;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- Get input parameters
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

    v_feature_type := (p_data->'data'->'parameters'->>'featureType')::TEXT;
    v_polygon_geom := (p_data->'data'->'parameters'->>'polygonGeom')::TEXT;
   
    -- Build key "data" with ids of intersected features
    EXECUTE FORMAT(
        'SELECT json_build_object(
            ''featureType'', %L,
            ''featureId'', json_agg(%I)
            ) FROM (SELECT %I FROM %I WHERE state = 1 AND ST_Intersects(the_geom, %L)
        )',
        LOWER(v_feature_type),
        LOWER(v_feature_type) || '_id',
        LOWER(v_feature_type) || '_id',
        LOWER(v_feature_type),
        ST_GeomFromText(v_polygon_geom, v_srid)
    ) INTO v_data;
 

    -- Create return
    SELECT jsonb_build_object('level', log_level,'text', error_message) INTO v_message FROM sys_message WHERE id = 3700;

	-- Control NULLs
   	v_status := COALESCE(v_status, '');
   	v_message := COALESCE(v_message, '{}');
	v_version := COALESCE(v_version, '');
    v_data := COALESCE(v_data, '{}');


	--  Return
	RETURN ('{"status":"'||v_status||'", "message":'||v_message||', "version":"'||v_version||'","body":{"form":{},"data":'||v_data||'}}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$function$
;