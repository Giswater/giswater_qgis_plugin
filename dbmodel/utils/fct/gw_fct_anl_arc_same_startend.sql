/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2104

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_arc_same_startend();
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_same_startend(p_data json) RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_arc_same_startend($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"ve_man_pipe", "id":["1004","1005"]},
"data":{"selectionMode":"previousSelection","parameters":{}}}$$)

-- fid: 104

*/

DECLARE

v_id json;
v_selectionmode	text;
v_connectolerance float;
v_worklayer text;
v_result json;
v_result_info json;
v_result_line json;
v_array text;
v_version text;
v_error_context text;
v_count integer;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;
	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid = 104;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=104;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2104", "fid":"104", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		EXECUTE 'INSERT INTO anl_arc (arc_id, state, expl_id, fid, the_geom, arccat_id)
				SELECT arc_id, state, expl_id, 104, the_geom, arccat_id
				FROM '||v_worklayer||' WHERE node_1::text=node_2::text AND arc_id IN ('||v_array||');';
	ELSE
		EXECUTE 'INSERT INTO anl_arc (arc_id, state, expl_id, fid, the_geom, arccat_id)
				SELECT arc_id, state, expl_id, 104, the_geom, arccat_id
				FROM '||v_worklayer||' WHERE node_1::text=node_2::text;';
	END IF;

	-- set selector
	DELETE FROM selector_audit WHERE fid = 104 AND cur_user=current_user;
	INSERT INTO selector_audit (fid,cur_user) VALUES (104, current_user);

	-- get results
	--lines
	v_result = null;
	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, ST_Transform(the_geom, 4326) as the_geom, fid
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid = 104) row) features;

	v_result_line := COALESCE(v_result, '{}');

	SELECT count(*) INTO v_count FROM anl_arc WHERE cur_user="current_user"() AND fid=104;

	IF v_count = 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3578", "function":"2104", "fid":"104", "fcount":"'||v_count||'", "is_process":true}}$$)';

	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3580", "function":"2104", "fid":"104", "parameters":{"v_count":"'||v_count||'"}, "fcount":"'||v_count||'", "is_process":true}}$$)';

		INSERT INTO audit_check_data(fid,  error_message, fcount)
		SELECT 104,  concat ('Arc_id: ',string_agg(arc_id, ', '), '.' ), v_count
		FROM anl_arc WHERE cur_user="current_user"() AND fid=104;
	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=104 order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

--  Return
    RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"line":'||v_result_line||
		       '}}'||
	    '}')::json, 2104, null, null, null);

	-- Exception control
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM,  'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE,
	'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
