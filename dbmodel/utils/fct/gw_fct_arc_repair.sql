/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2496

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_repair_arc();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_arc_repair(p_data json) RETURNS json AS
$BODY$

/*EXAMPLE

-- fid: 103, 104

-- MODE 1: individual
SELECT gw_fct_arc_repair($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, "feature":{"tableName":"ve_arc",
"featureType":"ARC", "id":["2094"]},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"previousSelection",
"parameters":{}}}$$);

-- MODE 2: massive using id as array
SELECT gw_fct_arc_repair($${"client":{"device":4, "infoType":1,"lang":"ES"},"feature":{"id":
"SELECT array_to_json(array_agg(arc_id::text)) FROM ve_arc WHERE expl_id='||v_expl||' AND (node_1 IS NULL OR node_2 IS NULL)"},
"data":{}}$$);';

-- MODE 3: massive usign pure SQL
SELECT gw_fct_arc_repair(concat('
{"client":{"device":4, "infoType":1, "lang":"ES"},"form":{}, "feature":{"tableName":"ve_arc","featureType":"ARC", "id":["',arc_id,'"]},
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}')::json) FROM ve_arc WHERE expl_id=v_expl AND (node_1 IS NULL OR node_2 IS NULL);

*/

DECLARE

arcrec text;
v_count integer;
v_count_partial integer=0;
v_result text;
v_version text;
v_projecttype text;
v_saveondatabase boolean;
v_feature_text text;
v_feature_array text[];

v_id json;
v_selectionmode text;
v_worklayer text;
v_array text;
v_result_info json;
v_result_point json;
v_result_line json;
v_msgerr json;
v_error_context text;

BEGIN

	SET search_path= 'SCHEMA_NAME','public';

	-- Get parameters from input json
	v_feature_text = ((p_data ->>'feature')::json->>'id'::text);

    IF v_feature_text ILIKE '[%]' THEN
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_text::json));
    ELSE
		EXECUTE v_feature_text INTO v_feature_text;
		v_feature_array = ARRAY(SELECT json_array_elements_text(v_feature_text::json));
    END IF;

	-- Delete previous log results
	DELETE FROM anl_arc WHERE fid=118 AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fid=103 AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=118 AND cur_user=current_user;

	-- select config values
	SELECT project_type, giswater  INTO v_projecttype, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- Set config parameter
	UPDATE config_param_system SET value=TRUE WHERE parameter='edit_topocontrol_disable_error' ;

	-- execute
	IF v_selectionmode != 'previousSelection' THEN
		INSERT INTO anl_arc(fid, arc_id, the_geom, descript)
		SELECT 103, arc_id, the_geom, 'b' FROM arc WHERE arc_id IN (SELECT arc_id FROM ve_arc WHERE state=1 AND (node_1 IS NULL OR node_2 IS NULL ));

		EXECUTE 'UPDATE arc SET the_geom=the_geom WHERE arc_id IN (SELECT arc_id FROM ve_arc WHERE state=1)';

		INSERT INTO anl_arc(fid, arc_id, the_geom, descript)
		SELECT 103, arc_id, the_geom, 'a' FROM arc WHERE arc_id IN (SELECT arc_id FROM ve_arc WHERE state=1 AND (node_1 IS NULL OR node_2 IS NULL));

		INSERT INTO anl_arc(fid, arc_id, the_geom) SELECT 118, arc_id, the_geom FROM (SELECT arc_id, the_geom FROM anl_arc WHERE fid=103 AND descript='b'
		AND cur_user=current_user AND arc_id NOT IN (SELECT arc_id FROM anl_arc WHERE fid=103 AND descript ='a' AND cur_user=current_user))a;
	ELSE
		EXECUTE 'INSERT INTO anl_arc(fid, arc_id, the_geom, descript) 
		SELECT 103, arc_id, the_geom, ''b'' FROM ve_arc WHERE arc_id IN (' ||v_array || ') AND state=1 AND node_1 IS NULL OR node_2 IS NULL';

		EXECUTE 'UPDATE arc SET the_geom=the_geom WHERE arc_id IN (' ||v_array || ') AND state=1';

		EXECUTE 'INSERT INTO anl_arc(fid, arc_id, the_geom, descript) 
		SELECT 103, arc_id, the_geom, ''a'' FROM ve_arc WHERE arc_id IN (' ||v_array || ') AND state=1 AND node_1 IS NULL OR node_2 IS NULL';

		INSERT INTO anl_arc(fid, arc_id, the_geom) SELECT 118, arc_id, the_geom FROM (SELECT arc_id, the_geom FROM anl_arc WHERE fid=103 AND descript='b'
		AND cur_user=current_user AND arc_id NOT IN (SELECT arc_id FROM anl_arc WHERE fid=103 AND descript ='a' AND cur_user=current_user))a;
	END IF;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2496", "fid":"118", "is_process":true, "is_header":"true"}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3528", "function":"2496", "fid":"118", "is_process":true, "parameters":{"arc_ids":"'||concat((SELECT array_agg(arc_id) FROM (SELECT arc_id FROM anl_arc WHERE fid=118 AND cur_user=current_user)a ))||'"}}}$$)';

	-- Set config parameter
	UPDATE config_param_system SET value=FALSE WHERE parameter='edit_topocontrol_disable_error' ;

	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result FROM (SELECT id, error_message AS message FROM audit_check_data WHERE cur_user="current_user"() AND ( fid=118)) row;
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
  	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript,fid, ST_Transform(the_geom, 4326) as the_geom
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid = 118) row) features;

	v_result_line := COALESCE(v_result, '{}');

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
	    '}')::json, 2496, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
