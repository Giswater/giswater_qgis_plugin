/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2762

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_odbc2pg_main(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_odbc2pg_main(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_odbc2pg_main($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"exploitation":"557", "period":"4T", "year":"2019"}}}$$)

*/

DECLARE

v_expl integer;
v_period text;
v_year integer;
v_project_type text;
v_version text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_querytext text;
v_count integer;
v_error_context text;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_expl := (((p_data ->>'data')::json->>'parameters')::json->>'exploitation')::integer;
	v_year := (((p_data ->>'data')::json->>'parameters')::json->>'year')::integer;
	v_period := (((p_data ->>'data')::json->>'parameters')::json->>'period')::text;
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;
	
	-- data2gis
	PERFORM gw_fct_odbc2pg_hydro_filldata(p_data);

	-- check data and get result
	SELECT gw_fct_odbc2pg_check_data(p_data) INTO v_result;

	-- process data
	v_result_info = (((v_result->>'body')::json->>'data')::json->>'info')::json;	
	v_result_point = (((v_result->>'body')::json->>'data')::json->>'point')::json;	
	v_result_line = (((v_result->>'body')::json->>'data')::json->>'line')::json;	

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	
	--  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"ODBC import/export process done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||
		     '}}}')::json;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
