/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 3484

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeatures(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
/*
Function for getting features filtering by sys_type and mapzone, with optional ordering by parameter.

Examples:
SELECT SCHEMA_NAME.gw_fct_getfeatures('{"client":{"device":5, "epsg":SRID_VALUE}, "data": {"sysType": "PIPE"}}');
SELECT SCHEMA_NAME.gw_fct_getfeatures('{"client":{"device":5, "epsg":SRID_VALUE}, "data": {"sysType": "PIPE", "parameter": "arc_id", "order": "asc"}}');
SELECT SCHEMA_NAME.gw_fct_getfeatures('{"client":{"device":5, "epsg":SRID_VALUE}, "data": {"sysType": "PIPE", "mapzoneType": "EXPL", "mapzoneId": 1}}');
SELECT SCHEMA_NAME.gw_fct_getfeatures('{"client":{"device":5, "epsg":SRID_VALUE}, "data": {"sysType": "PIPE", "mapzoneType": "EXPL", "mapzoneId": 1, "parameter": "arc_id", "order": "asc"}}');
*/

DECLARE
    v_version text;
    v_systype text;
    v_epsg integer;
    v_mapzone_type text;
    v_mapzone_id integer;
    v_mapzone_filter text;
    v_parameter text;
    v_order text;
    v_order_clause text;
    v_feature_type text;
    v_result json;
    v_result_array json[];
    v_select text;
    v_errcontext text;
    v_msgerr json;
BEGIN
    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;
    SELECT epsg INTO v_epsg FROM sys_version order by id desc limit 1;

    -- Get parameters
    v_systype = (p_data->>'data')::json->>'sysType';
    v_mapzone_type = (p_data->>'data')::json->>'mapzoneType';
    v_mapzone_id = (p_data->>'data')::json->>'mapzoneId';
    v_parameter = (p_data->>'data')::json->>'parameter';
    v_order = lower((p_data->>'data')::json->>'order');

    -- Validate sysType
    IF v_systype IS NULL OR v_systype = '' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"4138", "function":"3484","parameters":{}}}$$);';
    END IF;

    -- Build mapzone filter if parameters are provided
    v_mapzone_filter := '';
    IF v_mapzone_type IS NOT NULL AND v_mapzone_type != '' AND v_mapzone_id IS NOT NULL THEN
        v_mapzone_filter := ' AND ' || lower(v_mapzone_type) || '_id = ' || v_mapzone_id;
    END IF;

    -- Build order clause only if parameter and valid order are provided
    IF v_parameter IS NOT NULL AND v_parameter <> '' AND v_order IS NOT NULL AND (v_order = 'asc' OR v_order = 'desc') THEN
        v_order_clause := ' ORDER BY ' || v_parameter || ' ' || v_order;
    ELSE
        v_order_clause := '';
    END IF;

    -- Get feature_type from cat_feature (NODE or ARC)
    SELECT feature_type INTO v_feature_type FROM cat_feature WHERE feature_class = v_systype;
    IF v_feature_type IS NULL THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"4140", "function":"3484","parameters":{"sysType":"'||v_systype||'"}}}$$);';
    END IF;

    -- Build the select statement with coordinates based on feature_type
    IF v_feature_type = 'NODE' THEN
        v_select = 'SELECT node_id as "nodeId", asset_id as "assetId", macrosector_id AS "macroSector", comment AS "aresepId", state, nodecat_id AS "featureClass", '
                  || 'json_build_object(''x'', ST_X(the_geom), ''y'', ST_Y(the_geom), ''epsg'', '||v_epsg||') AS coordinates '
                  || 'FROM v_edit_node WHERE sys_type = '''||v_systype||''' AND the_geom IS NOT NULL'||v_mapzone_filter||v_order_clause;
    ELSIF v_feature_type = 'ARC' THEN
        v_select = 'SELECT arc_id as "arcId", asset_id as "assetId", macrosector_id AS "macroSector", comment AS "aresepId", state, arccat_id AS "featureClass", '
                  || 'json_build_object(''x'', ST_X(ST_Centroid(the_geom)), ''y'', ST_Y(ST_Centroid(the_geom)), ''epsg'', '||v_epsg||') AS coordinates '
                  || 'FROM v_edit_arc WHERE sys_type = '''||v_systype||''' AND the_geom IS NOT NULL'||v_mapzone_filter||v_order_clause;
    ELSE
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"4142", "function":"3484","parameters":{"sysType":"'||v_systype||'", "featureType":"'||v_feature_type||'"}}}$$);';
    END IF;

    -- Execute the query and aggregate features
    EXECUTE format('SELECT array_agg(row_to_json(a)) FROM (%s) a', v_select)
    INTO v_result_array;

    v_result := array_to_json(v_result_array);
    v_result := COALESCE(v_result, '[]');

    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
             ' ,"body":{"form":{}' ||
             ',"feature":{}' ||
             ',"data":{"features":'||v_result||'}}'||'}')::json;

    EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
    RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;
END;
$function$
;
