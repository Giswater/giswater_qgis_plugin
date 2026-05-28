/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:2670

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_om_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_om_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_om_check_data($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}$$)
SELECT SCHEMA_NAME.gw_fct_om_check_data($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userDomain"}}}$$)
*/

DECLARE

v_rec record;
v_project_type text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext	text;
v_selection_mode text;
v_error_context text;
v_fid integer = 125;
v_verified_exceptions boolean = true;
v_checkpsectors text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- getting input data
	v_verified_exceptions := ((p_data ->>'data')::json->>'parameters')::json->>'verifiedExceptions';
	v_selection_mode := ((p_data ->>'data')::json->>'parameters')::json->>'selectionMode'::text;
	v_checkpsectors := ((p_data ->>'data')::json->>'parameters')::json->>'checkPsectors'::text;
	v_fid := (((p_data ->>'data')::json->>'parameters')::json->>'fid');

	-- control of fid
	IF v_fid is null or v_fid <> 604 THEN v_fid = 125; end if;

	-- create temp tables
	IF v_fid = 125 THEN
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"LOG"}}}$$)';
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"ANL"}}}$$)';
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"OMCHECK"}}}$$)';
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"MAPZONES", "subGroup":"ALL"}}}$$)';

		-- insert separators
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2670", "fid":"'||v_fid||'","criticity":"4", "tempTable":"t_", "is_process":true, "message":"4428"}}$$)'; -- title
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2670", "fid":"'||v_fid||'","criticity":"4", "tempTable":"t_", "is_process":true, "separator_id":"2049"}}$$)'; -- separator
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2670", "fid":"'||v_fid||'", "criticity":"3", "tempTable":"t_","is_process":true, "separator_id":"2000"}}$$)';
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2670", "fid":"'||v_fid||'","criticity":"3", "tempTable":"t_", "is_process":true, "is_header":true, "label_id":"1004", "separator_id":"2022"}}$$)';-- CRITICAL ERRORS
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2706", "fid":"'||v_fid||'", "criticity":"2", "tempTable":"t_","is_process":true, "separator_id":"2000"}}$$)';
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2670", "fid":"'||v_fid||'","criticity":"2", "tempTable":"t_", "is_process":true, "is_header":true, "label_id":"3002", "separator_id":"2014"}}$$)';-- WARNINGS
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2706", "fid":"'||v_fid||'", "criticity":"1", "tempTable":"t_", "is_process":true, "separator_id":"2000"}}$$)';
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"2670", "fid":"'||v_fid||'","criticity":"1", "tempTable":"t_", "is_process":true, "is_header":true, "label_id":"3001", "separator_id":"2007"}}$$)';-- INFO
	END IF;

	-- getting sys_fprocess to be executed
	v_querytext = '
		SELECT * FROM sys_fprocess 
		WHERE project_type IN (LOWER('||quote_literal(v_project_type)||'), ''utils'') 
		AND addparam IS NULL 
		AND query_text IS NOT NULL 
		AND function_name ILIKE ''%om_check%''
		AND active
		ORDER BY fid ASC
	';

	FOR v_rec IN EXECUTE v_querytext LOOP
		EXECUTE 'SELECT gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	    "form":{},"feature":{},"data":{"parameters":{"functionFid": '||v_fid||', "checkFid":"'||v_rec.fid||'"}}}$$)';
	END LOOP;

	-- built return
	IF v_fid = 125 THEN

		-- materialize tables
		PERFORM gw_fct_create_logreturn($${"data":{"parameters":{"type":"fillExcepTables"}}}$$::json);

		-- create json return to send client
		EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
		EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;
		EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"line"}}}$$::json)' INTO v_result_line;
		EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"polygon"}}}$$::json)' INTO v_result_polygon;

		-- drop temp tables
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"LOG"}}}$$)';
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"ANL"}}}$$)';
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"OMCHECK"}}}$$)';
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"MAPZONES", "subGroup":"ALL"}}}$$)';

		-- Return
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"point":'||v_result_point||','||
					'"line":'||v_result_line||','||
					'"polygon":'||v_result_polygon||
			       '}'||
		    '}}')::json, 2670, null, null, null);
	ELSE
		--  Return
		RETURN '{"status":"ok"}';

	END IF;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"OMCHECK"}}}$$)';
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE',
	SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;