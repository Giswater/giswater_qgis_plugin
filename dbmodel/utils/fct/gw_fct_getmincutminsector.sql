/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getmincutminsector(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

-- Function id: 3536

/*
EXAMPLE:

SELECT gw_fct_getmincutminsector($${"client":{"device":4, "lang":"es_ES", "version":"4.0.001", "infoType":1, "epsg":25831},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"mincutId":"10"}}}$$);

*/

DECLARE
v_mincut_id INTEGER;
v_minsector_affected INTEGER;
v_minsector_dependent_arcs JSON;
v_proposed_valves JSON;
v_arc_id INTEGER;
v_version TEXT;

v_status TEXT;
v_message JSON;
v_data JSON;
v_error_context TEXT;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- Get input parameters
    v_mincut_id := (p_data->'data'->'parameters'->>'mincutId')::INTEGER;

	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT anl_feature_id INTO v_arc_id FROM om_mincut WHERE id = v_mincut_id;

    -- Minsector affected
	SELECT minsector_id INTO v_minsector_affected FROM arc WHERE arc_id = v_arc_id;

    -- Dependent arcs from the minsector
	SELECT json_agg(arc_id) INTO v_minsector_dependent_arcs FROM arc WHERE minsector_id IN (
		SELECT mincut_minsector_id FROM minsector_mincut WHERE minsector_id = v_minsector_affected
	);

    -- Proposed valves
	SELECT json_agg(js) FROM (
		SELECT json_build_object('toOpen', proposed, 'node_id', json_agg(node_id)) AS js 
		FROM om_mincut_valve WHERE result_id = v_mincut_id GROUP BY proposed
	) INTO v_proposed_valves;


	-- Control NULLs
	v_minsector_affected := COALESCE(v_minsector_affected, 0);
	v_minsector_dependent_arcs := COALESCE(v_minsector_dependent_arcs, '{}');
	v_proposed_valves := COALESCE(v_proposed_valves, '{}');

   	v_status := COALESCE(v_status, '');
   	v_message := COALESCE(v_message, '{}');
	v_version := COALESCE(v_version, '');
    v_data := COALESCE(v_data, '{}');

    SELECT JSONB_BUILD_OBJECT(
        'minsectorAffected', v_minsector_affected,
        'minsectorDependentArcs', v_minsector_dependent_arcs,
        'proposedValves', v_proposed_valves
    ) INTO v_data;

   	--  Return
	RETURN ('{"status":"'||v_status||'", "message":'||v_message||', "version":"'||v_version||'","body":{"form":{},"data":'||v_data||'}}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$function$
;
