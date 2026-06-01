/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:2790

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_graphanalytics_check_data($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"selectionMode":"userSelectors","graphClass":"SECTOR"}}}$$)

-- fid: main:v_fid,
	other: 176,180,181,192,208,209,367

select * FROM t_audit_check_data WHERE fid=v_fid AND cur_user=current_user;

*/

DECLARE

v_record record;
v_project_type text;
v_count	integer;
v_saveondatabase boolean;
v_result text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext text;
v_result_id text;
v_selectionmode text;
v_edit text;
v_config_param text;
v_sector boolean;
v_presszone boolean;
v_dma boolean;
v_dqa boolean;
v_minsector boolean;
v_graphclass text;
v_error_context text;
rec text;
v_fid integer;
v_addschema text;
v_sql text;
v_rec record;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data
	v_selectionmode := ((p_data ->>'data')::json->>'parameters')::json->>'selectionMode'::text;
	v_graphclass := ((p_data ->>'data')::json->>'parameters')::json->>'graphClass'::text;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid'::text;

	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- select config values
	v_sector := (SELECT (value::json->>'SECTOR')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');
	v_dma := (SELECT (value::json->>'DMA')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');
	v_dqa := (SELECT (value::json->>'DQA')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');
	v_presszone := (SELECT (value::json->>'PRESSZONE')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');
	v_minsector := (SELECT (value::json->>'MINSECTOR')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');

	-- init variables
	v_count=0;

	IF v_fid IS NULL THEN
		v_fid = 211;
	END IF;

	-- set ve_ variable
	IF v_selectionmode = 'wholeSystem' THEN
		v_edit = '';
	ELSIF v_selectionmode = 'userSelectors' THEN
		v_edit = 've_';
	END IF;

	IF v_fid = 211 OR v_fid = 101 THEN
		-- create temporal tables
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"GRAPHANALYTICSCHECK", "verifiedExceptions":false}}}$$)';
	END IF;

	-- Starting process
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2790", "fid":"'||v_fid||'", "criticity":"4", "tempTable":"t_", "is_process":true, "is_header":"true"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2790", "fid":"'||v_fid||'", "criticity":"3", "tempTable":"t_", "is_process":true, "is_header":"true", "label_id":"3004", "separator_id":"2022"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2790", "fid":"'||v_fid||'", "criticity":"2", "tempTable":"t_", "is_process":true, "is_header":"true", "label_id":"3002", "separator_id":"2014"}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2790", "fid":"'||v_fid||'", "criticity":"1", "tempTable":"t_", "is_process":true, "is_header":"true", "label_id":"3001", "separator_id":"2007"}}$$)';

	v_sql = '
		SELECT * FROM sys_fprocess 
		WHERE project_type IN (LOWER('||quote_literal(v_project_type)||'), ''utils'')
		AND addparam IS NULL
		AND query_text IS NOT NULL
		AND function_name ILIKE ''%gw_fct_graphanalytics_check_data%'' 
		AND (parameters::text ILIKE ''%'||v_graphclass||'%'' OR parameters IS NULL)
		AND active
	';

	FOR v_rec IN EXECUTE v_sql
	LOOP

		-- check que los addschemas existan
		SELECT (addparam::json ->>'addSchema')::text INTO v_addschema FROM sys_fprocess WHERE fid = v_rec.fid;

		IF v_addschema IS NOT NULL THEN
			-- check if exists
			SELECT count(*) INTO v_count FROM information_schema.tables WHERE table_catalog = current_catalog AND table_schema = v_addschema;

			IF v_count = 0 THEN
				continue;
			END IF;

		END IF;

		EXECUTE 'SELECT gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	    "form":{},"feature":{},"data":{"parameters":{"functionFid": '||v_fid||', 
		"prefixTable": "'||v_edit||'", "checkFid":"'||v_rec.fid||'", "graphClass":"'||lower(v_graphclass)||'"}}}$$)';

	END LOOP;

	UPDATE t_audit_check_data SET criticity = 1 WHERE error_message ILIKE 'INFO:%';
	UPDATE t_audit_check_data SET criticity = 2 WHERE error_message ILIKE 'WARNING-%';
	UPDATE t_audit_check_data SET criticity = 3 WHERE error_message ILIKE 'ERROR-%';

	-- Removing isaudit false sys_fprocess
	FOR v_record IN SELECT * FROM sys_fprocess WHERE isaudit IS FALSE
	LOOP
		-- remove anl tables
		DELETE FROM t_anl_node WHERE fid = v_record.fid AND cur_user = current_user;

		DELETE FROM t_audit_check_data WHERE result_id::text = v_record.fid::text AND cur_user = current_user AND fid = v_fid;
	END LOOP;


	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, '');
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 3, '');
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 2, '');
	INSERT INTO t_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, '');

	IF v_fid = 211 THEN
		-- delete old values on result table
		DELETE FROM audit_check_data WHERE fid=211 AND cur_user=current_user;
		DELETE FROM anl_node WHERE cur_user=current_user AND fid IN (176,180,181,182,208,209);

		INSERT INTO anl_node SELECT * FROM t_anl_node;
		INSERT INTO audit_check_data SELECT * FROM t_audit_check_data;

	ELSIF v_fid = 101 THEN
		UPDATE t_audit_check_data SET fid = 211;

		-- TODO: check if this is correct
		INSERT INTO project_t_audit_check_data SELECT * FROM t_audit_check_data;
		INSERT INTO project_t_anl_node SELECT * FROM t_anl_node;
	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE cur_user="current_user"() AND
	fid=211 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

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
  	FROM (SELECT id, node_id as feature_id, nodecat_id as feature_catalog, state, expl_id, descript,fid, ST_Transform(the_geom, 4326) as the_geom
  	FROM  t_anl_node WHERE cur_user="current_user"() AND fid IN (176,180,181,182,208,209)) row) features;

	v_result_point = v_result;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');
	v_result_polygon := COALESCE(v_result_polygon, '{}');

	IF v_fid = 211 OR v_fid = 101 THEN
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"GRAPHANALYTICSCHECK"}}}$$)';
	END IF;

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json, 2790, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
