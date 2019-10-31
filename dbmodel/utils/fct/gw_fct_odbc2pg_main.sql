/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2762

DROP FUNCTION IF EXISTS proyecto_prueba.gw_fct_odbc2pg_main(json);
CREATE OR REPLACE FUNCTION proyecto_prueba.gw_fct_odbc2pg_main(p_data json)
  RETURNS json AS
$BODY$


/*EXAMPLE

SELECT proyecto_prueba.gw_fct_odbc2pg_main($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"parameters":{"exploitation":"557", "period":"4T", "year":"2019"}}}$$)

*/


DECLARE
	v_expl			integer;
	v_period		text;
	v_year			integer;
	v_project_type		text;
	v_version		text;
	v_result 		json;
	v_result_info		json;
	v_querytext		text;
	v_count			integer;

BEGIN

	--  Search path	
	SET search_path = "proyecto_prueba", public;

	-- getting input data 	
	v_expl := (((p_data ->>'data')::json->>'parameters')::json->>'exploitation')::integer;
	v_year := (((p_data ->>'data')::json->>'parameters')::json->>'year')::integer;
	v_period := (((p_data ->>'data')::json->>'parameters')::json->>'period')::text;
	
	-- select config values
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;

	-- TODO move data from audit table to other table

	-- check quality data
	SELECT gw_fct_odbc2pg_check_data(p_data) INTO v_result;

	-- process data
	v_result_info = (((v_result->>'body')::json->>'data')::json->>'info')::json;	
			
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	
--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"ODBC connection analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}'||'}}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
