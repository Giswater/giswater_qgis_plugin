/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2102

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_arc_no_startend_node(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_anl_arc_no_startend_node(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_arc_no_startend_node($${ "client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"ve_arc", "featureType":"ARC", "id":[]}, "data":{"parameters":{"arcSearchNodes":"0.1"}}}$$)::text

WARNINGS: This function only works with node with state = 1


-- fid: 103

*/

DECLARE

arc_rec record;
nodeRecord1 record;
nodeRecord2 record;
rec record;

v_id json;
v_arcsearchnodes float;
v_selectionmode text;
v_worklayer text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_array integer[];
v_partcount integer = 0;
v_version text;
v_error_context text;
v_count_state1 integer;
v_count_state2 integer;

-- query variables
v_query_text text;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_arcsearchnodes := ((p_data ->>'data')::json->>'parameters')::json->>'arcSearchNodes';

	v_array := (SELECT array_agg(a::integer) FROM json_array_elements_text(v_id) a);

	-- Reset values
	DROP TABLE IF EXISTS temp_anl_node;
	DROP TABLE IF EXISTS temp_anl_arc_x_node;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=103;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2102", "fid":"103", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';


	IF v_arcsearchnodes IS NULL THEN
		SELECT (value::json ->>'value')::numeric into v_arcsearchnodes FROM config_param_system WHERE parameter='edit_arc_searchnodes';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3584", "function":"2102", "fid":"103", "parameters":{"v_arcsearchnodes":"'||v_arcsearchnodes||'"}, "is_process":true}}$$)';

	END IF;

	CREATE TEMP TABLE temp_anl_node AS
	SELECT n.node_id, n.state, n.the_geom
	FROM node n
	JOIN vf_node vn USING (node_id);

	CREATE INDEX IF NOT EXISTS temp_anl_node_node_id_idx ON temp_anl_node (node_id);
	CREATE INDEX IF NOT EXISTS temp_anl_node_the_geom_idx ON temp_anl_node USING gist (the_geom);
	CREATE INDEX IF NOT EXISTS temp_anl_node_state_idx ON temp_anl_node (state);

	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		v_query_text := 'AND a.arc_id = ANY(' || quote_literal(v_array) || ')';
	ELSE
		v_query_text := '';
	END IF;
	
	EXECUTE format($sql$
		CREATE TEMP TABLE temp_anl_arc_x_node AS
		SELECT a.arc_id, a.node_1, a.node_2, a.state, a.expl_id, a.the_geom, ST_StartPoint(a.the_geom) AS the_geom_p, 'startPoint' as descript, a.arccat_id 
		FROM ve_arc a
		WHERE NOT EXISTS (
			SELECT 1
			FROM temp_anl_node n
			WHERE ST_DWithin(ST_StartPoint(a.the_geom), n.the_geom, %s)
			AND (
				(a.state = 1 AND n.state = 1)
				OR (a.state = 2 AND n.state IN (1, 2))
				OR (a.state = 0 AND n.state IN (0, 1, 2))
			)
		)
		%s
		UNION ALL
		SELECT a.arc_id, a.node_1, a.node_2, a.state, a.expl_id, a.the_geom, ST_EndPoint(a.the_geom) AS the_geom_p, 'endPoint' as descript, a.arccat_id 
		FROM ve_arc a
		WHERE NOT EXISTS (
			SELECT 1
			FROM temp_anl_node n
			WHERE ST_DWithin(ST_EndPoint(a.the_geom), n.the_geom, %s)
			AND (
				(a.state = 1 AND n.state = 1)
				OR (a.state = 2 AND n.state IN (1, 2))
				OR (a.state = 0 AND n.state IN (0, 1, 2))
			)
		)
		%s
	$sql$, v_arcsearchnodes, v_query_text, v_arcsearchnodes, v_query_text);

	-- set selector
	DELETE FROM selector_audit WHERE fid = 103 AND cur_user=current_user;
	INSERT INTO selector_audit (fid,cur_user) VALUES (103, current_user);

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
    'geometry',   ST_AsGeoJSON(the_geom_p)::jsonb,
    'properties', to_jsonb(row) - 'the_geom_p'
  	) AS feature
  	FROM (SELECT arc_id, node_1, node_2, arccat_id, state, expl_id, ST_Transform(the_geom_p, 4326) as the_geom_p, descript
  	FROM  temp_anl_arc_x_node) row) features;

	v_result_point := COALESCE(v_result, '{}');


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
  	FROM (SELECT arc_id, node_1, node_2, arccat_id, state, expl_id, ST_Transform(the_geom, 4326) as the_geom, descript
  	FROM  temp_anl_arc_x_node) row) features;

	v_result_line := COALESCE(v_result, '{}');

	SELECT count(*) INTO v_count_state1 FROM temp_anl_arc_x_node WHERE  state = 1;
	SELECT count(*) INTO v_count_state2 FROM temp_anl_arc_x_node WHERE state = 2;

	IF v_count_state1 = 0 AND v_count_state2 = 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3582", "function":"2102", "fid":"103", "fcount":"0", "is_process":true}}$$)';
	ELSE
		IF v_count_state1 > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3586", "function":"2102", "fid":"103", "parameters":{"v_count_state1":"'||v_count_state1||'"}, "fcount":"'||v_count_state1||'", "is_process":true}}$$)';

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 103,  concat('Arc_id: ', array_agg(arc_id), '.'), v_count_state1
			FROM temp_anl_arc_x_node WHERE state=1;
		END IF;

		IF v_count_state2 > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3588", "function":"2102", "fid":"103", "parameters":{"v_count_state2":"'||v_count_state2||'"}, "fcount":"'||v_count_state2||'", "is_process":true}}$$)';

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 103,  concat('Arc_id: ', array_agg(arc_id), '.'), v_count_state2
			FROM temp_anl_arc_x_node WHERE state=2;
		END IF;
	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=103 order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	--  Return
    RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||
		       '}}'||
	    '}')::json, 2102, null, null, null);

	-- Exception control
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM,  'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE,
	'SQLCONTEXT', v_error_context)::json;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
