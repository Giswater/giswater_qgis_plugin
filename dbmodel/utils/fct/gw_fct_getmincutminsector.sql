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

-- Function id: 3536


/*
EXAMPLE:

SELECT gw_fct_getfeaturesfrompolygon($${"client":{"device":4, "lang":"es_ES", "version":"4.0.001", "infoType":1, "epsg":25831},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"mincutMinsectorId":"12345"}}}$$);

*/

DECLARE
v_mincut_minsector_id INTEGER;
v_minsector_affected JSON;
v_minsector_dependent_arcs JSON;
v_proposed_valves JSON;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- Get input parameters
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    v_mincut_minsector_id := (p_data->'data'->'parameters'->>'mincutMinsectorId')::INTEGER;


    -- minsector affected


    -- dependent arcs from the minsector


    -- proposed valves




    SELECT JSONB_BUILD_OBJECT(
        'minsectorAffected', v_minsector_affected,
        'minsectorDependentArcs', v_minsector_dependent_arcs,
        'proposedValves', v_proposed_valves
    ) INTO v_data;

   
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