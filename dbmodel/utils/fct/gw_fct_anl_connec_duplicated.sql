/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2106

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_connec_duplicated(p_data json) RETURNS json AS
$BODY$
/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_connec_duplicated($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"ve_man_wjoin", "id":["1004","1005"]},
"data":{"selectionMode":"previousSelection",	"parameters":{"connecTolerance":1},	"parameters":{}}}$$)

-- fid: 105

*/

DECLARE

v_id json;
v_selectionmode text;
v_connectolerance float;
v_worklayer text;
v_result json;
v_result_info json;
v_result_point json;
v_array text;
v_version text;
v_error_context text;
v_count integer;
v_msgerr json;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_connectolerance := ((p_data ->>'data')::json->>'parameters')::json->>'connecTolerance';

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- Reset values
    DELETE FROM anl_connec WHERE cur_user="current_user"() AND fid=105;
    DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=105;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2106", "fid":"105", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		EXECUTE 'INSERT INTO anl_connec (connec_id, conneccat_id, state, expl_id, fid, descript, the_geom)
		with subquery as (
		SELECT DISTINCT t1.connec_id as c1, t1.conneccat_id as cc1, t1.state as state1, t2.connec_id as c2, t2.conneccat_id, t2.state as state2, t1.expl_id, 105, t1.the_geom
		FROM '||v_worklayer||' AS t1 JOIN '||v_worklayer||' AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,('||v_connectolerance||')) 
		WHERE t1.connec_id != t2.connec_id AND t1.connec_id IN ('||v_array||') AND t1.state > 0 AND t2.state > 0
		)
		select distinct (c1) c1, cc1, state1, expl_id, 105, concat(''Dupl. connecs: '', count(c2)), the_geom from subquery 
		group by c1, cc1, state1, expl_id, the_geom;
		';
	ELSE
		EXECUTE 'INSERT INTO anl_connec (connec_id, conneccat_id, state, expl_id, fid, descript, the_geom)
		with subquery as (
		SELECT DISTINCT t1.connec_id as c1, t1.conneccat_id as cc1, t1.state as state1, t2.connec_id as c2, t2.conneccat_id, t2.state as state2, t1.expl_id, 105, t1.the_geom
		FROM '||v_worklayer||' AS t1 JOIN '||v_worklayer||' AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,(0.01)) 
		WHERE t1.connec_id != t2.connec_id and t1.state > 0 and t2.state > 0
		ORDER BY t1.connec_id
		)
		select distinct (c1) c1, cc1, state1, expl_id, 105, concat(''Dupl. connecs: '', count(c2)), the_geom from subquery 
		group by c1, cc1, state1, expl_id, the_geom;
		';
	END IF;

	-- set selector
	DELETE FROM selector_audit WHERE fid=105 AND cur_user=current_user;
	INSERT INTO selector_audit (fid,cur_user) VALUES (105, current_user);

	-- get results
	--points
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
  	FROM (SELECT id, connec_id, conneccat_id, state, expl_id, descript, ST_Transform(the_geom, 4326) as the_geom, fid
  	FROM  anl_connec WHERE cur_user="current_user"() AND fid=105) row) features;

	v_result_point := COALESCE(v_result, '{}');

	SELECT count(*) INTO v_count FROM anl_connec WHERE cur_user="current_user"() AND fid=105;

	IF v_count = 0 THEN

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3590", "function":"2106", "fid":"105", "fcount":"'||v_count||'", "is_process":true}}$$)';
	ELSE
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3592", "function":"2106", "parameters":{"v_count":"'||v_count||'"}, "fid":"105", "fcount":"'||v_count||'", "is_process":true}}$$)';

		INSERT INTO audit_check_data(fid,  error_message, fcount)
		SELECT 105,  concat ('Connec_id: ',array_agg(connec_id), '.' ), v_count
		FROM anl_connec WHERE cur_user="current_user"() AND fid=105;

	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=105 order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||
			'}}'||
	    '}')::json, 2106, null, null, null);


	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;