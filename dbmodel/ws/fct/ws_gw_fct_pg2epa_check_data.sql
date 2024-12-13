/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2430

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_check_data(character varying);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_data($${"data":{"parameters":{"fid":227}}}$$)-- when is called from go2epa_main
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_data($${"data":{"parameters":{"fid":101}}}$$)-- when is called from checkproject
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_data('{"parameters":{}}')-- when is called from toolbox

-- fid: main: 225
		other: 107,153,164,165,166,167,169,170,171,188,198,227,229,230,292,294,295,371,379,433,411,412,430,432,480,482,524

*/


DECLARE

v_rec record;
v_record record;
v_project_type text;
v_count	integer;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext text;
v_result json;
v_defaultdemand	float;
v_error_context text;
v_fid integer;
v_nodetolerance float;
v_minlength float;
v_nodeproximity float;
v_addschema text;
v_sql text;

BEGIN
	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid'::text;

	-- select config values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	v_nodetolerance :=  (SELECT value::json->>'value' FROM config_param_system WHERE parameter = 'edit_node_proximity');
	v_minlength := (SELECT value FROM config_param_system WHERE parameter = 'epa_arc_minlength');
	v_nodeproximity := (SELECT value::json->>'value' FROM config_param_system WHERE parameter = 'edit_node_proximity');

	-- init variables
	v_count=0;
	IF v_fid is null THEN v_fid = 225; END IF;

	IF v_fid IN (101,225) THEN
		--create temp tables
		CREATE TEMP TABLE temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_connec (LIKE SCHEMA_NAME.anl_connec INCLUDING ALL);
		CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

		CREATE TEMP TABLE temp_t_arc (LIKE temp_arc INCLUDING ALL);

		-- Header
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  4, 'CHECK GIS DATA QUALITY ACORDING EPA RULES');
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  4, '----------------------------------------------------------');

		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, 'CRITICAL ERRORS');
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, '----------------------');

		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  2, 'WARNINGS');
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  2, '--------------');

		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, 'INFO');
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, '-------');
	END IF;


	v_sql = 'select*from sys_fprocess where 
		project_type in (lower('||quote_literal(v_project_type)||'), ''utils'')
		and addparam is null
		and query_text is not null
		and function_name ilike ''%pg2epa%'' ';



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
	    "form":{},"feature":{},"data":{"parameters":{"functionFid": '||v_fid||', "prefixTable": "", "checkFid":"'||v_rec.fid||'"}}}$$)';

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
		DELETE FROM anl_node WHERE fid = v_record.fid AND cur_user = current_user;

		DELETE FROM temp_audit_check_data WHERE result_id::text = v_record.fid::text AND cur_user = current_user AND fid = v_fid;
	END LOOP;

	-- 101 - checkproject
	-- 127 - go2epa main
	-- 225 - triggered alone

	IF v_fid = 225 THEN

		INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '');
		INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 3, '');
		INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 2, '');
		INSERT INTO temp_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, '');

		DELETE FROM anl_arc WHERE fid =225 AND cur_user=current_user;
		DELETE FROM anl_node WHERE fid =225 AND cur_user=current_user;
		DELETE FROM anl_connec WHERE fid =225 AND cur_user=current_user;
		DELETE FROM audit_check_data WHERE fid =225 AND cur_user=current_user;

		INSERT INTO anl_arc SELECT * FROM temp_anl_arc;
		INSERT INTO anl_node SELECT * FROM temp_anl_node;
		INSERT INTO anl_connec SELECT * FROM temp_anl_connec;
		INSERT INTO audit_check_data SELECT * FROM temp_audit_check_data;

	ELSIF  v_fid = 101 THEN

		UPDATE temp_audit_check_data SET fid = 225;

		INSERT INTO project_temp_anl_arc SELECT * FROM temp_anl_arc;
		INSERT INTO project_temp_anl_node SELECT * FROM temp_anl_node;
		INSERT INTO project_temp_anl_connec SELECT * FROM temp_anl_connec;
		INSERT INTO project_temp_audit_check_data SELECT * FROM temp_audit_check_data;
	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (
	SELECT error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc
	) row;
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
	FROM (SELECT node_id, nodecat_id, state, expl_id, descript,fid, the_geom
	FROM temp_anl_node WHERE cur_user="current_user"() AND fid IN (107, 164, 165, 166, 167, 170, 171, 187, 198, 294, 379, 411, 412, 432)) row) features;
	v_result := COALESCE(v_result, '{}');
	v_result_point = concat ('{"geometryType":"Point",  "features":',v_result, '}');

	--lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
	SELECT jsonb_build_object(
	'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT arc_id, arc_id, arccat_id, state, expl_id, descript, the_geom, fid
	FROM  temp_anl_arc WHERE cur_user="current_user"() AND fid IN (188, 169, 229, 230, 295)) row) features;

	v_result := COALESCE(v_result, '{}');
	v_result_line = concat ('{"geometryType":"LineString",  "features":',v_result,'}');

	--drop temporal tables
	IF v_fid IN (101,225) THEN

		DROP TABLE IF EXISTS temp_anl_arc;
		DROP TABLE IF EXISTS temp_anl_node ;
		DROP TABLE IF EXISTS temp_anl_connec;
		DROP TABLE IF EXISTS temp_audit_check_data;
	END IF;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');
	v_result_polygon := COALESCE(v_result_polygon, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		',"body":{"form":{}'||
			',"data":{"info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
			'}'||
		'}')::json, 2430, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

