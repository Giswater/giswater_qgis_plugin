/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 3488

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getdmahydrometers(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
/*
Function for getting all hydrometers from a specific DMA.

Example:
SELECT SCHEMA_NAME.gw_fct_getdmahydrometers('{"client":{"device":5, "epsg":SRID_VALUE}, "data": {"parameters":{"dma_id": 1}}}');
*/

DECLARE
    v_version text;
    v_epsg integer;
    v_result json;
    v_result_array json[];
    v_select text;
    v_errcontext text;
    v_msgerr json;
    v_dma_id integer;
BEGIN
    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;
    SELECT epsg INTO v_epsg FROM sys_version order by id desc limit 1;

    -- Get dma_id parameter
    v_dma_id := ((p_data->>'data')::json->>'parameters')::json->>'dma_id';

    -- Validate that dma_id is provided
    IF v_dma_id IS NULL THEN
        RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', 2, 'text', 'DMA ID parameter is required'), 'version', v_version);
    END IF;

    -- Build the select statement for hydrometers in the specified DMA
    v_select = concat('SELECT h.hydrometer_id as "hydrometerId", h.code as "hydrometerCode", h.customer_name as "customerName", ',
                     'rhxc.connec_id as "connecId", h.hydrometer_customer_code as "hydrometerCustomerCode", ',
                     'h.address1 as "address", h.hydro_number as "hydroNumber", h.state_id as "stateId", ',
                     'h.start_date as "startDate", h.end_date as "endDate", h.m3_volume as "m3Volume", ',
                     'c.dma_id as "dmaId" ',
                     'FROM ext_rtc_hydrometer h ',
                     'JOIN rtc_hydrometer_x_connec rhxc ON rhxc.hydrometer_id = h.hydrometer_id ',
                     'JOIN connec c ON c.connec_id = rhxc.connec_id ',
                     'WHERE c.dma_id = ', v_dma_id, ' ',
                     'ORDER BY h.hydrometer_id');

    -- Execute the query and aggregate hydrometers
    EXECUTE format('SELECT array_agg(row_to_json(a)) FROM (%s) a', v_select)
    INTO v_result_array;

    v_result := array_to_json(v_result_array);
    v_result := COALESCE(v_result, '[]');

    RETURN concat('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"', v_version, '"',
                 ' ,"body":{"form":{},',
                 ' "feature":{},',
                 ' "data":{"hydrometers":', v_result, '}}', '}')::json;

    -- Error handling
    EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
    RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;
END;
$function$
;
