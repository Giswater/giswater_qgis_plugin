/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2670

DROP FUNCTION IF EXISTS ws40000.gw_fct_om_check_data(json);
CREATE OR REPLACE FUNCTION ws40000.gw_fct_om_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT ws40000.gw_fct_setcheckdatabase($${"data":{"parameters":{"omCheck":true, "graphCheck":false, "epaCheck":false, "planCheck":false, "adminCheck":false, "ignoreVerifiedExceptions":false}}}$$);
*/

DECLARE

v_rec record;
v_project_type text;
v_querytext text;
v_ignore_verified_exceptions boolean = true;
v_fid integer;

BEGIN

	--  Search path
	SET search_path = "ws40000", public;

	-- select config values
	SELECT project_type INTO v_project_type FROM sys_version order by id desc limit 1;

	-- getting input parameters
	v_fid :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'fid';

	-- getting sys_fprocess to be executed
	v_querytext = 'select * from sys_fprocess where project_type in (lower('||quote_literal(v_project_type)||'), ''utils'') 
	and addparam is null and query_text is not null and function_name ilike ''%om_check%'' and active order by fid asc';

	-- loop for checks
	for v_rec in execute v_querytext		
	loop
		EXECUTE 'select gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	    "form":{},"feature":{},"data":{"parameters":{"functionFid":'||v_fid||', "checkFid":"'||v_rec.fid||'"}}}$$)';
	end loop;

	--  Return
	RETURN '{"status":"ok"}';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;