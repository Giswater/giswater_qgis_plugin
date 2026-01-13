/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getarcauditvalues(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
EXAMPLE

SELECT gw_fct_getarcauditvalues($${"client":{"device":4, "lang":"es_ES", "version":"4.0.001", "infoType":1, "epsg":25831},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"startDate":"2026-01-01", "endDate":"2025-01-01"}}}$$);


*/


DECLARE
v_message JSON;
v_version TEXT;
v_status TEXT = 'Accepted';
v_error_context TEXT;
v_startdate DATE;
v_enddate DATE;
v_data JSON;
v_stats JSON;
v_events JSON;


BEGIN


	SET search_path = "SCHEMA_NAME", public;

	-- Get input parameters
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    v_startdate := (p_data->'data'->'parameters'->>'startDate')::DATE;
    v_enddate := (p_data->'data'->'parameters'->>'endDate')::DATE;


    -- Stats
    EXECUTE format(
        'SELECT JSON_agg(json_build_object(''actionType'', "type", ''count'', count_events)) FROM (
            SELECT "type", count(*) AS count_events FROM audit_arc_traceability 
            WHERE tstamp >= %L AND tstamp <= %L 
            GROUP BY "type"
        )',
        v_startdate,
        v_enddate
    ) INTO v_stats;

    -- Events
    EXECUTE format(
        'SELECT json_agg(row_to_json(n))
            FROM audit_arc_traceability n
            WHERE n.tstamp >= %L
            AND n.tstamp <= %L',
        v_startdate,
        v_enddate
    ) INTO v_events;
   	
   	v_stats := COALESCE(v_stats, '{}');
   	v_events := COALESCE(v_events, '{}');


    -- Create return
    SELECT JSONB_BUILD_OBJECT('level', log_level,'text', error_message) INTO v_message FROM sys_message WHERE id = 3700;

    SELECT JSONB_BUILD_OBJECT('stats', v_stats, 'events', v_events) INTO v_data;

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
