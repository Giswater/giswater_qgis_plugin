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

-- Function id: 3532

/*
EXAMPLE:

SELECT gw_fct_getfeaturesfrompolygon($${"client":{"device":4, "lang":"es_ES", "version":"4.0.001", "infoType":1, "epsg":25831},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"functionFid": 3532, "featureType":"arc", "polygonGeom":"MULTIPOLYGON (((419617.361558083 4576465.809154497, 419618.8569710209 4576468.246374115, 419622.2276227002 4576466.157956117, 419620.73944153683 4576463.628078675, 419617.361558083 4576465.809154497)))"}}}$$);

SELECT gw_fct_getfeaturesfrompolygon($${"client": {"device": 5, "lang": "es_ES", "infoType": 1},
"form": {}, "feature": {}, "data": {"filterFields": {}, "pageInfo": {},
"parameters": {
    "featureType": "ARC",
    "polygonGeom": "MULTIPOLYGON (((419419.13867777254 4576466.499338785, 419429.1574217372 4576487.650020488, 419537.69381468766 4576466.221040341, 419497.8971372725 4576396.368131032, 419419.13867777254 4576404.438785893, 419419.13867777254 4576466.499338785)))"
}}}$$);

*/

DECLARE
v_message JSON;
v_version TEXT;
v_srid INTEGER;
v_status TEXT = 'Accepted';
v_error_context TEXT;
v_feature_type TEXT;
v_sql TEXT;
v_features JSONB;
v_polygon_geom TEXT;
rec RECORD;
v_partialquerytext TEXT;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- Get input parameters
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;

    v_feature_type := (p_data->'data'->'parameters'->>'featureType')::TEXT;
    v_polygon_geom := (p_data->'data'->'parameters'->>'polygonGeom')::TEXT;
   
	CREATE TABLE temp_features (
		feature_type TEXT,
		feature_id INT
	);

    -- SECTION Check input params

    -- Existing feature_type
	IF (SELECT EXISTS(SELECT 1 FROM sys_feature_type WHERE id = UPPER(v_feature_type))) THEN
	
		v_partialquerytext = ' WHERE id = '||quote_literal(upper(v_feature_type))||'';
	
	ELSIF v_feature_type = 'ALL' THEN
	
		NULL;

	ELSE
			
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{}, "data":{"message":"4474", "function":"3532", "fid":999, "parameters":{}}}$$)';

	END IF;

    -- Geometry validation
    IF ST_GeometryType(v_polygon_geom) NOT IN ('ST_Polygon', 'ST_MultiPolygon') OR ST_IsValid(v_polygon_geom) IS FALSE THEN
	
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{}, "data":{"message":"4476", "function":"3532", "fid":999, "parameters":{}}}$$)';

	END IF;

    -- !SECTION 

	-- Look for intersected features and store them in temp_features
	FOR rec IN EXECUTE 'SELECT lower(id) AS feature_type FROM sys_feature_type '|| COALESCE(v_partialquerytext, '')
   	LOOP
		EXECUTE FORMAT(
   		'INSERT INTO temp_features SELECT %L, %I FROM %I WHERE ST_Intersects(the_geom, %L)',
   		rec.feature_type,
        rec.feature_type || '_id',
        've_' || rec.feature_type,
        ST_GeomFromText(v_polygon_geom, v_srid)
        );
    END LOOP;
   
    -- Build key "data" with ids of intersected features
	SELECT jsonb_object_agg (feature_type, vals) INTO v_features FROM (
	    SELECT feature_type, json_agg(feature_id) AS vals FROM temp_features GROUP BY feature_type
	);
	
    -- Create return
    SELECT jsonb_build_object('level', log_level,'text', error_message) INTO v_message FROM sys_message WHERE id = 3700;

    -- Control NULLs
   	v_status := COALESCE(v_status, '');
   	v_message := COALESCE(v_message, '{}');
	v_version := COALESCE(v_version, '');
    v_features := COALESCE(v_features, '{}');

	DROP TABLE IF EXISTS temp_features;
	--  Return
	RETURN jsonb_build_object(
	    'status', v_status,
	    'message', v_message,
	    'version', v_version,
	    'body', jsonb_build_object(
	        'form', '{}'::jsonb,
	        'data', jsonb_build_object(
                    'features', COALESCE(v_features::jsonb, '{}'::jsonb)
             )
	    )
	);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$function$
;