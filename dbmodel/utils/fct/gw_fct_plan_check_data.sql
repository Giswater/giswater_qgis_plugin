/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2436


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_audit_check_data(integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_check_data(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_plan_check_data($${}$$)

SELECT * FROM anl_arc WHERE fid=v_fid AND cur_user=current_user;
SELECT * FROM anl_node WHERE fid=v_fid AND cur_user=current_user;

-- fid: v_fid, 252,354,355,452,467

*/

DECLARE

v_record record;
v_project_type 	text;
v_table_count integer;
v_count integer;
v_global_count	integer;
v_return json;
v_version text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_saveondatabase boolean;
v_error_context text;
v_query text;
v_comment text;
v_querytext text;
v_fid integer;
v_sql text;
v_rec record;
v_addschema text;
v_isembebed boolean;
v_verified_exceptions boolean = true;

BEGIN

	-- init function
	SET search_path="SCHEMA_NAME", public;

	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid'::text;
	v_isembebed :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'isEmbebed';
	v_verified_exceptions :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'verifiedExceptions';

	-- init variables
	v_return := 0;
	v_global_count := 0;

	IF v_fid IS NULL THEN v_fid = 115; END IF;
	IF v_verified_exceptions IS NULL THEN v_verified_exceptions = FALSE; END IF;

	IF v_isembebed IS FALSE OR v_isembebed IS NULL THEN -- create temporal tables if function is not embebed
		v_isembebed = FALSE;
		-- create temporal tables
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":'||v_project_type||', "action":"CREATE", "group":"PLANCHECK", "verifiedExceptions":'||v_verified_exceptions||'}}}$$::json)';
	END IF;

	-- getting sys_fprocess to be executed
	v_querytext = '
		SELECT * FROM sys_fprocess 
		WHERE project_type IN (LOWER('||quote_literal(v_project_type)||'), ''utils'') 
		AND addparam IS NULL 
		AND query_text IS NOT NULL 
		AND function_name ILIKE ''%plan_check_data%'' 
		AND active ORDER BY fid ASC
	';

	-- loop for checks
	FOR v_rec IN EXECUTE v_querytext LOOP
		EXECUTE 'SELECT gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	    "form":{},"feature":{},"data":{"parameters":{"functionFid":'||v_fid||', "checkFid":"'||v_rec.fid||'"}}}$$)';
	END LOOP;

	IF v_isembebed IS FALSE OR v_isembebed IS NULL THEN -- drop temporal tables if function is not embebed
		EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":'||v_project_type||', "action":"DROP", "group":"PLANCHECK"}}}$$)';
	END IF;

	--  Return
	EXECUTE 'SELECT gw_fct_create_return($${"data":{"parameters":{"functionId":3364, "isEmbebed":'||v_isembebed||'}}}$$::json)' INTO v_return;
	RETURN v_return;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":'||v_project_type||', "action":"DROP", "group":"PLANCHECK"}}}$$)';
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE',
	SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;

