/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2776

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT gw_fct_admin_check_data($${"client":
{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}$$)::text

-- fid: 195

*/

DECLARE

v_schemaname text;
v_count	integer;
v_project_type text;
v_version text;
v_view_list text;
v_errortext text;
v_result text;
v_result_info json;
v_definition text;
rec record;
v_result_id text;
v_querytext text;
v_feature_list text;
v_param_list text;
rec_fields text;
v_field_array text[];
v_fid integer;
v_sql text;
v_rec record;
v_addschema text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';

	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- init variables
	v_count=0;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid'::text;

	IF v_fid is null THEN
		v_fid = 195;
	END IF;


	CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
	IF v_fid IN (101,225) THEN
		--create temp tables
		CREATE TEMP TABLE temp_anl_arc (LIKE ws_msg_trad_1.anl_arc INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_node (LIKE ws_msg_trad_1.anl_node INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_connec (LIKE ws_msg_trad_1.anl_connec INCLUDING ALL);
		
	END IF;


	-- Starting process
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CHECK ADMIN CONFIGURATION'));
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
		and function_name ilike ''%admin%'' ';
	


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
	    "form":{},"feature":{},"data":{"parameters":{"functionFid": '||v_fid||', "prefixTable": "", "checkFid":"'||v_rec.fid||'","graphClass":"SECTOR"}}}$$)';
		
   	end loop;


	update temp_audit_check_data set criticity = 1 where error_message ilike 'INFO:%';
   	update temp_audit_check_data set criticity = 2 where error_message ilike 'WARNING-%';
   	update temp_audit_check_data set criticity = 3 where error_message ilike 'ERROR-%';

	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 4, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 3, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 2, '');
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 1, '');

	IF v_fid = 195 THEN
		-- delete old values on result table
		DELETE FROM audit_check_data WHERE fid=195 AND cur_user=current_user;

		INSERT INTO audit_check_data SELECT * FROM temp_audit_check_data;

	ELSIF  v_fid = 101 THEN
		UPDATE temp_audit_check_data SET fid = 195;

		INSERT INTO project_temp_audit_check_data SELECT * FROM temp_audit_check_data;

	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=195 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

--DROP temp tables
	DROP TABLE IF EXISTS temp_audit_check_data;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{ "info":'||v_result_info||'}}'||
		'}')::json, 2776, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;