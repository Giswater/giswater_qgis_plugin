/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
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

select * FROM temp_audit_check_data WHERE fid=v_fid AND cur_user=current_user; 

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
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- select config values
	v_sector  := (SELECT (value::json->>'SECTOR')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');
	v_dma  := (SELECT (value::json->>'DMA')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');
	v_dqa  := (SELECT (value::json->>'DQA')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');
	v_presszone  := (SELECT (value::json->>'PRESSZONE')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');
	v_minsector  := (SELECT (value::json->>'MINSECTOR')::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status');

	-- init variables
	v_count=0;

	IF v_fid is null THEN
		v_fid = 211;
	END IF;

	-- set v_edit_ variable
	IF v_selectionmode='wholeSystem' THEN
		v_edit = '';
	ELSIF v_selectionmode='userSelectors' THEN
		v_edit = 'v_edit_';
	END IF;

	IF v_fid = 211 OR v_fid = 101 THEN
		CREATE TEMP TABLE temp_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
		CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
	END IF;

	-- Starting process
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('DATA QUALITY ANALYSIS ACORDING graph ANALYTICS RULES'));
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');

	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'CRITICAL ERRORS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '----------------------');

	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '--------------');

	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '-------');


	v_sql = 'select*from sys_fprocess where 
		project_type in (lower('||quote_literal(v_project_type)||'), ''utils'')
				and addparam is null
		and query_text is not null
		and function_name ilike ''%graphanalytics%''
		and (parameters::text ilike ''%'||v_graphclass||'%'' or parameters is null)';
	

	for v_rec in execute v_sql		
	loop
		
		-- check que los addschemas existan
		select (addparam::json ->>'addSchema')::text into v_addschema from sys_fprocess where fid = v_rec.fid;

		if v_addschema is not null then
		
			-- check if exists
			select count(*) into v_count from information_schema.tables where table_catalog = current_catalog and table_schema = v_addschema;
		
			if v_count = 0 then
			
				continue;
			
			end if;
		
		end if;

		--raise notice 'v_rec.fid %', v_rec.fid;
		execute 'select gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	    "form":{},"feature":{},"data":{"parameters":{"functionFid": '||v_fid||', 
		"prefixTable": "'||v_edit||'", "checkFid":"'||v_rec.fid||'", "graphClass":"'||lower(v_graphclass)||'"}}}$$)';
		
   	end loop;


	update temp_audit_check_data set criticity = 1 where error_message ilike 'INFO:%';
   	update temp_audit_check_data set criticity = 2 where error_message ilike 'WARNING-%';
   	update temp_audit_check_data set criticity = 3 where error_message ilike 'ERROR-%';



	-- Removing isaudit false sys_fprocess
	FOR v_record IN SELECT * FROM sys_fprocess WHERE isaudit is false
	LOOP
		-- remove anl tables
		DELETE FROM temp_anl_node WHERE fid = v_record.fid AND cur_user = current_user;

		DELETE FROM temp_audit_check_data WHERE result_id::text = v_record.fid::text AND cur_user = current_user AND fid = v_fid;
	END LOOP;


	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 3, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 2, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, '');

	IF v_fid = 211 THEN

		-- delete old values on result table
		DELETE FROM audit_check_data WHERE fid=211 AND cur_user=current_user;
		DELETE FROM anl_node WHERE cur_user=current_user AND fid IN (176,180,181,182,208,209);

		INSERT INTO anl_node SELECT * FROM temp_anl_node;
		INSERT INTO audit_check_data SELECT * FROM temp_audit_check_data;

	ELSIF  v_fid = 101 THEN
		UPDATE temp_audit_check_data SET fid = 211;

		INSERT INTO project_temp_audit_check_data SELECT * FROM temp_audit_check_data;
		INSERT INTO project_temp_anl_node SELECT * FROM temp_anl_node;

	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND
	fid=211 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, node_id as feature_id, nodecat_id as feature_catalog, state, expl_id, descript,fid, the_geom
  	FROM  temp_anl_node WHERE cur_user="current_user"() AND fid IN (176,180,181,182,208,209)) row) features;

	v_result := COALESCE(v_result, '{}');


	IF v_result = '{}' THEN
		v_result_point = '{"geometryType":"", "values":[]}';
	ELSE
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');
	END IF;

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');
	v_result_polygon := COALESCE(v_result_polygon, '{}');

	IF v_fid = 211 OR v_fid = 101 THEN
		--DROP temp tables
		DROP TABLE IF EXISTS temp_anl_node ;
		DROP TABLE IF EXISTS temp_audit_check_data;
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

