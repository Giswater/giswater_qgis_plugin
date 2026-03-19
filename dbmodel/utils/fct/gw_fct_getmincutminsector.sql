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
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"arcId":"10"}}}$$);

*/

DECLARE

-- Init params
v_arc_id INTEGER;
v_minsector_id INTEGER;

-- Vars
v_minsector_affected INTEGER = 0;
v_minsector_dependent_arcs JSON = '{}';
v_proposed_valves JSON = '{}';


-- aux/std vars
v_sql TEXT;


-- Return and sys vars
v_version TEXT = '';
v_status TEXT = 'Accepted';
v_message JSON = '{}';
v_error_context TEXT = '';
v_result_point JSON = '{}';
v_result_connecs JSON = '{}';
v_result_valves JSON = '{}';
v_result_line JSON = '{}';
v_result_info JSON = '{}';
v_project_type TEXT;
v_fid integer = 999;


BEGIN

	SET search_path = "ws_0319_01", public;

	-- NOTE: Input parameters and init vars
    v_arc_id := (p_data->'data'->'parameters'->>'arcId')::INTEGER;

	SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT json_build_object('level', log_level, 'text', error_message) INTO v_message FROM sys_message WHERE id = 3700;

	SELECT minsector_id INTO v_minsector_id FROM arc WHERE arc_id = v_arc_id;

	SELECT json_build_object('arcId', v_arc_id, 'minsectorId', v_minsector_id) INTO v_result_info;

	-- pipes
	v_sql := FORMAT('SELECT 
    va.arc_id,
    va.minsector_id,
    the_geom
	FROM ve_arc va
	WHERE EXISTS (
	    SELECT 1 FROM minsector_mincut mm 
	    WHERE mm.minsector_id = %s
	    AND mm.mincut_minsector_id = va.minsector_id
	)', v_minsector_id);

	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"custom", "layerName":"Arcs", "queryText":"'||regexp_replace(v_sql, '\s+', ' ', 'g')||'"}}}$$)' 
	INTO v_result_line;
	
	
	-- connecs
	v_sql := FORMAT('SELECT
	    vc.connec_id,
	    vc.customer_code,
	    vc.minsector_id,
	    the_geom
	FROM ve_connec vc
	WHERE EXISTS (
	    SELECT 1 FROM minsector_mincut mm 
	    WHERE mm.minsector_id = %s
	    AND mm.mincut_minsector_id = vc.minsector_id
	)', v_minsector_id);
	
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"custom", "layerName":"Connecs","queryText":"'||regexp_replace(v_sql, '\s+', ' ', 'g')||'"}}}$$)' 
	INTO v_result_connecs;
	
	-- valves
	v_sql := FORMAT('SELECT 
	    mv.node_id,
	    mv.closed,
	    mv.broken,
	    mv.to_arc,
	    mv.proposed,
	    mv.unaccess,
	    mv.changestatus,
	    the_geom,
	    vn.minsector_id
	FROM minsector_mincut_valve mv
	JOIN ve_node vn USING (node_id) 
	WHERE mv.minsector_id = %s',
	v_minsector_id);


	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"custom", "layerName":"Valves", "queryText":"'||regexp_replace(v_sql, '\s+', ' ', 'g')||'"}}}$$)' 
	INTO v_result_valves;

	v_result_point := jsonb_build_array(
		v_result_connecs,
		v_result_valves
	)::json;


   	--  Return
	RETURN ('{"status":"'||v_status||'","message":'||v_message||',"version":"'||v_version||'","body":{"form":{},
	"data":{"info":'||v_result_info||',"point":'||v_result_point||',"line":'||v_result_line||'}}}');

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$function$
;
