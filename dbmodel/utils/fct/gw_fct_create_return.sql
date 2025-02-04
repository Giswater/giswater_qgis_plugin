/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
--FUNCTION CODE: 3370

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_return(p_data json)
RETURNS json AS
$BODY$

DECLARE
v_function_id integer;
v_isembebed boolean;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result json;
v_result_info json;
v_project_type text;
v_epsg integer;
v_version text;

BEGIN
	-- Search path
	SET search_path = 'SCHEMA_NAME', public;

	-- get system variables
	SELECT project_type, epsg, giswater INTO v_project_type, v_epsg, v_version FROM sys_version order by id desc limit 1;

	-- get input variables
	v_function_id :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'fid';
	v_isembebed :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'isEmbebed';

	IF v_isembebed THEN
		RETURN '{"status":"ok"}';
	END IF;

	-- materialize tables
	PERFORM gw_fct_create_logreturn($${"data":{"parameters":{"type":"fillExcepTables"}}}$$::json);

	-- create json return to send client
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"line"}}}$$::json)' INTO v_result_line;
	EXECUTE 'SELECT gw_fct_create_logreturn($${"data":{"parameters":{"type":"polygon"}}}$$::json)' INTO v_result_polygon;

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"epsg":'||v_epsg||','||
			    '"info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||
		       '}}'||
	    '}')::json, v_function_id, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;