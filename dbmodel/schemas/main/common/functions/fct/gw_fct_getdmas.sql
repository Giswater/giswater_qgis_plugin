/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 3486

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getdmas(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
/*
Function for getting all DMAs from the schema.

Example:
SELECT SCHEMA_NAME.gw_fct_getdmas('{"client":{"device":5, "epsg":SRID_VALUE}, "data": {}}');
*/

DECLARE
    v_version text;
    v_epsg integer;
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

    -- Build the select statement for DMAs
    v_select = concat('SELECT dma_id as "dmaId", name as "dmaName", expl_id as "explId", macrodma_id as "macrodmaId", ',
                     'descript as "description", active, ST_AsText(the_geom) as "geometry" ',
                     'FROM dma WHERE active IS TRUE ORDER BY dma_id');

    -- Execute the query and aggregate DMAs
    EXECUTE format('SELECT array_agg(row_to_json(a)) FROM (%s) a', v_select)
    INTO v_result_array;

    v_result := array_to_json(v_result_array);
    v_result := COALESCE(v_result, '[]');

    RETURN concat('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"', v_version, '"',
                 ' ,"body":{"form":{},',
                 ' "feature":{},',
                 ' "data":{"dmas":', v_result, '}}', '}')::json;

    -- Error handling
    EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
    RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;
END;
$function$
;
