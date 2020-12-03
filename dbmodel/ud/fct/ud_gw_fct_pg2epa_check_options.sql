/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2860

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_options(p_data json)
  RETURNS json AS
$BODY$


/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_options($${"data":{"parameters":{"resultId":"gw_check_project","fid":127}}}$$) --when is called from go2epa_main from toolbox
*/


DECLARE
v_fid integer;
v_version text;
v_record record;
v_project_type text;
v_count	integer;
v_count_2 integer;
v_result_id text;
v_error_context text;
v_return text = '{"status":"accepted"}';

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid';

	-- select system values
	SELECT project_type, giswater  INTO v_project_type, v_version FROM sys_version order by 1 desc limit 1 ;
	
	--  Return
	RETURN gw_fct_json_create_return(v_return, 2860);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
	
