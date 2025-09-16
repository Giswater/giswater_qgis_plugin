/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3052

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_length(p_data json) RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_arc_length($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"tableName":"ve_arc", "featureType":"ARC", "id":[]},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
"parameters":{"arcLength":"3"}}}$$)::JSON
-- fid: v_fid

*/

DECLARE

v_id json;
v_selectionmode text;
v_worklayer text;
v_result json;
v_result_info json;
v_result_line json;
v_array text;
v_version text;
v_error_context text;
v_count integer;
v_shorterthan numeric;
v_fid integer=387;
v_biggerthan numeric;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_shorterthan := ((p_data ->>'data')::json->>'parameters')::json->>'shorterThan';
	v_biggerthan := ((p_data ->>'data')::json->>'parameters')::json->>'biggerThan';


	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3052", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

		-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		EXECUTE 'INSERT INTO anl_arc (arc_id, arccat_id, state, node_1, node_2, expl_id, fid, the_geom, length)
		SELECT arc_id, arccat_id, state, node_1, node_2, expl_id, '||v_fid||', the_geom, st_length(the_geom) 
		FROM  '||v_worklayer||' WHERE arc_id IN ('||v_array||') AND  (st_length(the_geom)  < '||v_shorterthan||' OR st_length(the_geom) > '||v_biggerthan||');';
	ELSE
		EXECUTE 'INSERT INTO anl_arc (arc_id, arccat_id, state, node_1, node_2, expl_id, fid, the_geom, length)
		SELECT arc_id, arccat_id, state, node_1, node_2, expl_id, '||v_fid||', the_geom, st_length(the_geom) 
		FROM  '||v_worklayer||' WHERE  (st_length(the_geom)  < '||v_shorterthan||' OR st_length(the_geom) > '||v_biggerthan||');';
	END IF;

	-- get results
	--lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
	  	) AS feature
	  	FROM (SELECT id, arc_id, arccat_id, state,  node_1, node_2, expl_id, fid, st_length(the_geom) as length, the_geom
	  	FROM  anl_arc WHERE cur_user="current_user"() AND fid=v_fid) row) features;

	v_result := COALESCE(v_result, '{}');
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}');

	SELECT count(*) INTO v_count FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid;

	IF v_count = 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                "data":{"message":"3570", "function":"3052", "parameters":null, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "is_process":true}}$$)';
	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                "data":{"message":"3572", "function":"3052", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "fcount":"'||v_count||'", "is_process":true}}$$)';

		INSERT INTO audit_check_data(fid,  error_message, fcount)
		SELECT v_fid,  concat ('Arc_id: ',array_agg(arc_id), '.' ), v_count
		FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid;

	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
			'"line":'||v_result_line||
		'}}'||
	    '}')::json, 3052, null, null, null);

	-- Exception control
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM,  'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE,
	'SQLCONTEXT', v_error_context)::json;


END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;