/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2670

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_om_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_om_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_om_check_data($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}$$)

SELECT SCHEMA_NAME.gw_fct_om_check_data($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"selectionMode":"wholeSystem"}}}$$)


SELECT * FROM audit_check_data WHERE fid = v_fid

--fid:  main: v_fid
	other: 103,104,106,187,188,196,197,201,202,203,204,205,257,372,417,418,419,421,422,423,424,442,443,461,478,479,488,480,497,498,499
*/

DECLARE

v_record record;
v_Rec record;
v_project_type text;
v_count integer;
v_saveondatabase boolean;
v_result text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext	text;
v_result_id text;
v_features text;
v_edit text;
v_config_param text;
v_error_context text;
v_feature_id text;
v_arc_array text[];
rec_arc text;
v_node_1 text;
v_partialquery text;
v_check_arcdnom integer;
v_fid integer;
v_rec_process record;
v_addschema text;
v_sql text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data
	v_features := ((p_data ->>'data')::json->>'parameters')::json->>'selectionMode'::text;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid'::text;

	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- init variables
	v_count=0;
	IF v_fid is null THEN
		v_fid = 125;
	END IF;

	-- set v_edit_ variable
	IF v_features='wholeSystem' THEN
		v_edit = '';
	ELSIF v_features='userSelectors' THEN
		v_edit = 'v_edit_';
	END IF;

	
	--create temp tables
	IF v_fid = 125 OR v_fid = 101 THEN
		CREATE TEMP TABLE temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_connec (LIKE SCHEMA_NAME.anl_connec INCLUDING ALL);
		CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
	END IF;

	CREATE TEMP TABLE temp_t_arc (LIKE SCHEMA_NAME.temp_arc INCLUDING ALL);
	
	-- Starting process
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('DATA QUALITY ANALYSIS ACORDING O&M RULES'));
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');

	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'CRITICAL ERRORS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '----------------------');

	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '--------------');

	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '-------');

		
	-- UTILS

	v_sql = 'select*from sys_fprocess where 
		project_type in (lower('||quote_literal(v_project_type)||'), ''utils'')
		and addparam is null
		and query_text is not null
		and function_name ilike ''%om_check%'' ';
	


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
	    "form":{},"feature":{},"data":{"parameters":{"functionFid": '||v_fid||', "prefixTable": "'||v_edit||'", "checkFid":"'||v_rec.fid||'"}}}$$)';
		
   	end loop;


	update temp_audit_check_data set criticity = 1 where error_message ilike 'INFO:%';
   	update temp_audit_check_data set criticity = 2 where error_message ilike 'WARNING-%';
   	update temp_audit_check_data set criticity = 3 where error_message ilike 'ERROR-%';


	-- Removing isaudit false sys_fprocess
	FOR v_record IN SELECT * FROM sys_fprocess WHERE isaudit is false
	LOOP
		-- remove anl tables
		DELETE FROM temp_anl_node WHERE fid = v_record.fid AND cur_user = current_user;
		DELETE FROM temp_anl_arc WHERE fid = v_record.fid AND cur_user = current_user;
		DELETE FROM temp_anl_connec WHERE fid = v_record.fid AND cur_user = current_user;

		DELETE FROM temp_audit_check_data WHERE result_id::text = v_record.fid::text AND cur_user = current_user AND fid = v_fid;		
	END LOOP;


	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 3, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 2, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, '');

	IF v_fid = 125 THEN
	
		-- delete old values on result table
		DELETE FROM audit_check_data WHERE fid = 125 AND cur_user=current_user;
		
		-- delete old values on anl table
		DELETE FROM anl_connec WHERE cur_user=current_user AND fid IN (210,201,202,204,205,257,291,478);
		DELETE FROM anl_arc WHERE cur_user=current_user AND fid IN (103,196,197,188,223,202,372,391,417,418,461,381, 479);
		DELETE FROM anl_node WHERE cur_user=current_user AND fid IN (106,177,187,202,442,443,461,432);

		INSERT INTO anl_arc SELECT * FROM temp_anl_arc;
		INSERT INTO anl_node SELECT * FROM temp_anl_node;
		INSERT INTO anl_connec SELECT * FROM temp_anl_connec;
		INSERT INTO audit_check_data SELECT * FROM temp_audit_check_data;

	ELSIF  v_fid = 101 THEN 
	
		UPDATE temp_audit_check_data SET fid = 125;

		INSERT INTO project_temp_anl_arc SELECT * FROM temp_anl_arc;
		INSERT INTO project_temp_anl_node SELECT * FROM temp_anl_node;
		INSERT INTO project_temp_anl_connec SELECT * FROM temp_anl_connec;
		INSERT INTO project_temp_audit_check_data SELECT * FROM temp_audit_check_data;

	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND 
	fid = 125 order by criticity desc, id asc) row;
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
  	FROM (SELECT node_id, nodecat_id as feature_catalog, state, expl_id, descript, fid, the_geom FROM temp_anl_node WHERE cur_user="current_user"()
	AND fid IN (106,177,187,202,442,443,175,432)
	UNION
	SELECT connec_id, connecat_id, state, expl_id, descript, fid, the_geom FROM temp_anl_connec WHERE cur_user="current_user"()
	AND fid IN (210,201,202,204,205,291,478,488,480)) row) features;

	v_result := COALESCE(v_result, '{}'); 

	IF v_result = '{}' THEN 
		v_result_point = '{"geometryType":"", "features":[]}';
	ELSE 
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');
	END IF;

	--lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
	'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (
  	SELECT arc_id, arccat_id, state, expl_id, descript, fid, the_geom FROM  temp_anl_arc WHERE cur_user="current_user"() AND fid IN (103, 196, 197, 188, 223, 202, 372, 391, 417, 418, 479,175)
  	) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 


	IF v_result = '{}' THEN 
		v_result_line = '{"geometryType":"", "features":[]}';
	ELSE 
		v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}');
	END IF;

	--polygons
	v_result_polygon = '{"geometryType":"", "values":[]}';
		
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 
	
	IF v_fid = 125 OR v_fid = 101 THEN
		--drop temporal tables
		DROP TABLE  IF EXISTS temp_anl_arc;
		DROP TABLE IF EXISTS temp_anl_node ;
		DROP TABLE IF EXISTS  temp_anl_connec;
		DROP TABLE  IF EXISTS temp_t_arc;
		DROP TABLE  IF EXISTS temp_audit_check_data;
	END IF;


	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||
		       '}'||
	    '}}')::json, 2670, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;