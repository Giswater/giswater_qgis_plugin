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
v_isembebed boolean;
v_verified_exceptions boolean = true;
v_return json;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';
	
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- getting input parameters
	v_fid :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'fid';
	v_isembebed :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'isEmbebed';
	v_verified_exceptions :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'verifiedExceptions';

	-- init variables
	v_count=0;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid'::text;
	
	IF v_fid is null then v_fid = 195; end if;

	IF v_isembebed IS false of v_isembebed is null then -- create temporal tables if function is not embebed
		-- create log tables		
		EXECUTE 'SELECT gw_fct_create_logtables($${"data":{"parameters":{"fid":'||v_fid||'}}}$$::json)';
		-- create query tables
		EXECUTE 'SELECT gw_fct_create_querytables($${"data":{"parameters":{"fid":'||v_fid||', "epaCheck":true, "verifiedExceptions":'||v_verified_exceptions||'}}}$$::json)';
	END IF;

	-- getting sys_fprocess to be executed
	v_querytext = 'select * from sys_fprocess where project_type in (lower('||quote_literal(v_project_type)||'), ''utils'') 
	and addparam is null and query_text is not null and function_name ilike ''%admin_check%'' and active order by fid asc';

	-- loop for checks
	for v_rec in execute v_querytext		
	loop
		EXECUTE 'select gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	    "form":{},"feature":{},"data":{"parameters":{"functionFid":'||v_fid||', "checkFid":"'||v_rec.fid||'"}}}$$)';
	end loop;

	--  Return
	EXECUTE 'SELECT gw_fct_create_return($${"data":{"parameters":{"functionId":3364, "isEmbebed":'||v_isembebed||'}}}$$::json)' INTO v_return;
	RETURN v_return;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;