/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2204

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_anl_arc_inverted(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_inverted(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_anl_arc_inverted($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"ve_man_conduit", "id":["138","139"]},
"data":{"selectionMode":"previousSelection", "parameters":{"saveOnDatabase":true}
}}$$)

-- fid: 110

*/

DECLARE

v_version text;
v_result json;
v_result_info json;
v_result_line json;
v_id json;
v_selectionmode text;
v_saveondatabase boolean;
v_worklayer text;
v_array text;
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
	v_saveondatabase :=  (((p_data ->>'data')::json->>'parameters')::json->>'saveOnDatabase')::boolean;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid=110;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=110;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2204", "fid":"110", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3968", "function":"2204", "fid":"110", "criticity":"4", "prefix_id":"1001", "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3970", "function":"2204", "fid":"110", "criticity":"4", "is_process":true}}$$)';

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (110, null, 4, '');

	-- Computing process
	IF v_selectionmode = 'previousSelection' THEN
		EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state)
	 			SELECT arc_id, expl_id, 110, the_geom, arccat_id, state FROM '||v_worklayer||' 
	 			WHERE ((sys_elev1-sys_elev2)/st_length('||v_worklayer||'.the_geom) * 100::numeric) < 0 AND arc_id IN ('||v_array||') 
	 			AND (inverted_slope IS FALSE OR inverted_slope IS NULL);';
	ELSE
		EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state)
	 			SELECT arc_id, expl_id, 110, the_geom, arccat_id, state FROM '||v_worklayer||' WHERE ((sys_elev1-sys_elev2)/st_length('||v_worklayer||'.the_geom) * 100::numeric) < 0
	 			AND (inverted_slope IS FALSE OR inverted_slope IS NULL);';
	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=110 order by id) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

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
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid=110) row) features;

	v_result_line := COALESCE(v_result, '{}');

	-- set selector
	DELETE FROM selector_audit WHERE fid=110 AND cur_user=current_user;
	INSERT INTO selector_audit (fid,cur_user) VALUES (110, current_user);


	SELECT count(*) INTO v_count FROM anl_arc WHERE cur_user="current_user"() AND fid=110;

	IF v_count = 0 THEN
		INSERT INTO audit_check_data(fid,  error_message, fcount)
		VALUES (110,  'There are no inverted arcs', v_count);
	ELSE
		INSERT INTO audit_check_data(fid,  error_message, fcount)
		SELECT 110,  concat ('There are ',v_count,' inverted arcs. Arc_id: ',string_agg(arc_id, ', ') ), v_count
		FROM anl_arc WHERE cur_user="current_user"() AND fid=110;
	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=110 order by  id asc) row;
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
	    '}')::json, 2204, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;