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
v_worklayer text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_array text;
v_partcount integer = 0;
v_totcount integer = 0;
v_version text;
v_error_context text;
v_count_state1 integer;
v_count_state2 integer;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_arcsearchnodes := ((p_data ->>'data')::json->>'parameters')::json->>'arcSearchNodes';

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;
	-- Reset values
    DELETE FROM anl_arc_x_node WHERE cur_user="current_user"() AND fid = 103;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=103;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2102", "fid":"103", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';


	-- Init counter
	EXECUTE 'SELECT count(*) FROM '||v_worklayer
		INTO v_totcount;

	IF v_arcsearchnodes IS NULL THEN
		SELECT (value::json ->>'value')::numeric into v_arcsearchnodes FROM config_param_system WHERE parameter='edit_arc_searchnodes';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3584", "function":"2102", "fid":"103", "parameters":{"v_arcsearchnodes":"'||v_arcsearchnodes||'"}, "is_process":true}}$$)';

	END IF;

	-- Computing process
	FOR arc_rec IN EXECUTE 'SELECT * FROM '||v_worklayer||''
	LOOP

		v_partcount = v_partcount +1;
		IF arc_rec.state = 1 THEN
			SELECT * INTO nodeRecord1 FROM node WHERE ST_DWithin(ST_startpoint(arc_rec.the_geom), node.the_geom, v_arcsearchnodes) AND (node.state=1)
			ORDER BY ST_Distance(node.the_geom, ST_startpoint(arc_rec.the_geom)) LIMIT 1;
			IF nodeRecord1 IS NULL 	THEN
				INSERT INTO anl_arc_x_node (arc_id, state, expl_id, fid, the_geom, the_geom_p, arccat_id)
				SELECT arc_rec.arc_id, arc_rec.state, arc_rec.expl_id, 103, arc_rec.the_geom, st_startpoint(arc_rec.the_geom), arc_rec.arccat_id;
			END IF;

			SELECT * INTO nodeRecord2 FROM node WHERE ST_DWithin(ST_endpoint(arc_rec.the_geom), node.the_geom, v_arcsearchnodes) AND (node.state=1)
			ORDER BY ST_Distance(node.the_geom, ST_endpoint(arc_rec.the_geom)) LIMIT 1;
			IF nodeRecord2 IS NULL 	THEN
				INSERT INTO anl_arc_x_node (arc_id, state, expl_id, fid, the_geom, the_geom_p, arccat_id)
				SELECT arc_rec.arc_id, arc_rec.state, arc_rec.expl_id, 103, arc_rec.the_geom, st_endpoint(arc_rec.the_geom), arc_rec.arccat_id;
			END IF;
		ELSIF arc_rec.state = 2 THEN

			SELECT * INTO nodeRecord1 FROM node WHERE ST_DWithin(ST_startpoint(arc_rec.the_geom), node.the_geom, v_arcsearchnodes) AND
			(node.state=2 or node.state=1)
			ORDER BY ST_Distance(node.the_geom, ST_startpoint(arc_rec.the_geom)) LIMIT 1;
			IF nodeRecord1 IS NULL 	THEN
				INSERT INTO anl_arc_x_node (arc_id, state, expl_id, fid, the_geom, the_geom_p, arccat_id)
				SELECT arc_rec.arc_id, arc_rec.state, arc_rec.expl_id, 103, arc_rec.the_geom, st_startpoint(arc_rec.the_geom), arc_rec.arccat_id;
			END IF;

			SELECT * INTO nodeRecord2 FROM node WHERE ST_DWithin(ST_endpoint(arc_rec.the_geom), node.the_geom, v_arcsearchnodes) AND
			(node.state=2 or node.state=1)
			ORDER BY ST_Distance(node.the_geom, ST_endpoint(arc_rec.the_geom)) LIMIT 1;
			IF nodeRecord2 IS NULL 	THEN
				INSERT INTO anl_arc_x_node (arc_id, state, expl_id, fid, the_geom, the_geom_p, arccat_id)
				SELECT arc_rec.arc_id, arc_rec.state, arc_rec.expl_id, 103, arc_rec.the_geom, st_endpoint(arc_rec.the_geom), arc_rec.arccat_id;
			END IF;
		END IF;


	END LOOP;

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
  	FROM (SELECT id, node_id, arccat_id, state, expl_id, descript,fid, ST_Transform(the_geom_p, 4326) as the_geom_p
  	FROM  anl_arc_x_node WHERE cur_user="current_user"() AND fid = 103) row) features;

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
  	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript,fid, ST_Transform(the_geom, 4326) as the_geom
  	FROM  anl_arc_x_node WHERE cur_user="current_user"() AND fid = 103) row) features;

	v_result_line := COALESCE(v_result, '{}');

	SELECT count(*) INTO v_count_state1 FROM anl_arc_x_node WHERE cur_user="current_user"() AND fid=103 AND state = 1;
	SELECT count(*) INTO v_count_state2 FROM anl_arc_x_node WHERE cur_user="current_user"() AND fid=103 AND state = 2;

	IF v_count_state1 = 0 AND v_count_state2 = 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3582", "function":"2102", "fid":"103", "fcount":"0", "is_process":true}}$$)';
	ELSE
		IF v_count_state1 > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3586", "function":"2102", "fid":"103", "parameters":{"v_count_state1":"'||v_count_state1||'"}, "fcount":"'||v_count_state1||'", "is_process":true}}$$)';

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 103,  concat ('Arc_id: ',string_agg(arc_id::text, ', '), '.' ), v_count_state1
			FROM anl_arc_x_node WHERE cur_user="current_user"() AND fid=103 AND state=1;
		END IF;

		IF v_count_state2 > 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3588", "function":"2102", "fid":"103", "parameters":{"v_count_state2":"'||v_count_state2||'"}, "fcount":"'||v_count_state2||'", "is_process":true}}$$)';

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 103,  concat ('Arc_id: ',string_agg(arc_id::text, ', '), '.' ), v_count_state2
			FROM anl_arc_x_node WHERE cur_user="current_user"() AND fid=103 AND state=2;
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
