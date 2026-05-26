/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2202

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_arc_intersection(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_intersection(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_arc_intersection($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"ve_man_conduit", "id":["138","139"]},
"data":{"selectionMode":"previousSelection", "parameters":{}
}}$$)

-- fid: 109

*/

DECLARE

v_version text;
v_result json;
v_result_info json;
v_result_line json;
v_id json;
v_selectionmode text;
v_worklayer text;
v_array text;
v_count integer;
v_msgerr json;
v_errcontext text;

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
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid=109;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=109;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2202", "fid":"109", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';


	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, arc_id_aux, the_geom_p, the_geom, arccat_id, state)
		SELECT a.arc_id AS arc_id_1, a.expl_id, 109, b.arc_id AS arc_id_2, 
		(ST_Dumppoints(ST_Multi(ST_Intersection(a.the_geom, b.the_geom)))).geom AS the_geom_p,a.the_geom, a.arccat_id, a.state
		FROM '||v_worklayer||' AS a, '||v_worklayer||' AS b 
		WHERE a.state=1 AND b.state=1 AND ST_Intersects(a.the_geom, b.the_geom) AND a.arc_id != b.arc_id AND NOT ST_Touches(a.the_geom, b.the_geom)
		AND a.the_geom is not null and b.the_geom is not null AND a.arc_id IN ('||v_array||');';
	ELSE
		EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, arc_id_aux, the_geom_p,the_geom, arccat_id, state)
		SELECT a.arc_id AS arc_id_1, a.expl_id, 109, b.arc_id AS arc_id_2, 
		(ST_Dumppoints(ST_Multi(ST_Intersection(a.the_geom, b.the_geom)))).geom AS the_geom_p,a.the_geom, a.arccat_id, a.state
		FROM '||v_worklayer||' AS a, '||v_worklayer||' AS b 
		WHERE a.state=1 AND b.state=1 AND ST_Intersects(a.the_geom, b.the_geom) AND a.arc_id != b.arc_id AND NOT ST_Touches(a.the_geom, b.the_geom)
		AND a.the_geom is not null and b.the_geom is not null;';
	END IF;

	-- set selector
	DELETE FROM selector_audit WHERE fid=109 AND cur_user=current_user;
	INSERT INTO selector_audit (fid,cur_user) VALUES (109,current_user);

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
  	FROM (SELECT DISTINCT ON (arc_id,arc_id_aux) id, arc_id, arccat_id,arc_id_aux, state, expl_id, descript, ST_Transform(the_geom, 4326) as the_geom, fid
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid=109) row) features;

	v_result_line := COALESCE(v_result, '{}');

	SELECT count(*) INTO v_count FROM anl_arc WHERE cur_user="current_user"() AND fid=109;

	IF v_count = 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3964", "function":"2202", "fid":"109", "fcount":"'||v_count||'", "is_process":true}}$$)';
	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3966", "function":"2202", "parameters":{"v_count":"'||v_count||'"}, "fid":"109", "fcount":"'||v_count||'", "is_process":true}}$$)';

		INSERT INTO audit_check_data(fid,  error_message, fcount)
		SELECT 113,  concat ('Arc_id: ',string_agg(node_id, ', '), '.' ), v_count
		FROM anl_node WHERE cur_user="current_user"() AND fid=109;
	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=109 order by  id asc) row;
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
	    '}')::json, 2202, null, null, null);


	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;