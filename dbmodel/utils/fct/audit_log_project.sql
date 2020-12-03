/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3000

-- DROP FUNCTION SCHEMA_NAME.gw_fct_audit_log_project(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_log_project(p_data json)
  RETURNS json AS
$BODY$

	/*EXAMPLE
	

	SELECT SCHEMA_NAME.gw_fct_audit_log_project($${"client":
	{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
	"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}$$)::text


*/

DECLARE

v_schemaname text;
rec_count record;
v_count text;
v_project_type text;
v_version text;
v_criticity integer;
v_error_val integer;
v_warning_val integer;
v_groupby text;
json_result json[];
rec_result text;

v_result_id text;
v_result text;
v_result_info json;

v_view_list text;
v_errortext text;
v_definition text;
v_querytext text;
v_feature_list text;
v_param_list text;
rec_fields text;
v_field_array text[];

rec record;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	PERFORM gw_fct_user_check_data($${"client":
	{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
	"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"checkType":"Stats"}}}$$)::text;

	EXECUTE 'SELECT gw_fct_setcheckproject($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
	"feature":{}, "data":{"filterFields":{}, "addSchema":"ud_sample", "qgisVersion":"3.10.003.1", 
	"initProject":"false", "pageInfo":{}, "version":"'||v_version||'", "fid":1}}$$)';

	INSERT INTO audit_fid_log (fid,fcount,criticity,tstamp)
	SELECT result_id::integer, fcount, criticity, tstamp FROM audit_check_data WHERE fid IN (125, 211, 115, 195) AND cur_user = current_user
	AND result_id IS NOT NULL;

	-- get results
	-- info
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	
	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{ "info":'||v_result_info||','||
				'"point":{"geometryType":"", "values":[]}'||','||
				'"line":{"geometryType":"", "values":[]}'||','||
				'"polygon":{"geometryType":"", "values":[]}'||
			   '}}'||
		'}')::json, 3000);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
