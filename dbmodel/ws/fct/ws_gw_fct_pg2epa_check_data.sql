/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2670

CREATE OR REPLACE FUNCTION ws40000.gw_fct_pg2epa_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT ws40000.gw_fct_pg2epa_check_data($${"data":{"parameters":{"ignoreVerifiedExceptions":true}}}$$);
-- v_fid: 604 check from checkproject

-- v_fid: 227 check from pg2epa
*/

DECLARE
v_rec record;
v_project_type text;
v_querytext text;
v_verified_exceptions boolean = true;
v_fid integer = 225;
v_isembebed boolean;
v_return json;

BEGIN

	--  Search path
	SET search_path = "ws40000", public;

	-- select config values
	SELECT project_type INTO v_project_type FROM sys_version order by id desc limit 1;

	-- getting input parameters
	v_fid :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'fid';
	v_isembebed :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'isEmbebed';
	v_verified_exceptions :=  ((p_data ->> 'data')::json->>'parameters')::json->> 'verifiedExceptions';

	IF v_isembebed is null then v_isembebed = false; end if;
	IF v_fid is null then v_fid = 225; end if;
	
	IF v_isembebed IS false then -- create temporal tables if function is not embebed
		-- create log tables		
		EXECUTE 'SELECT gw_fct_create_logtables($${"data":{"parameters":{"fid":'||v_fid||'}}}$$::json)';
		-- create query tables
		EXECUTE 'SELECT gw_fct_create_querytables($${"data":{"parameters":{"fid":'||v_fid||', "epaCheck":true, "ignoreVerifiedExceptions":'||v_verified_exceptions||'}}}$$::json)';
	END IF;

	-- getting sys_fprocess to be executed
	v_querytext = 'select * from sys_fprocess where project_type in (lower('||quote_literal(v_project_type)||'), ''utils'') 
	and addparam is null and query_text is not null and function_name ilike ''%pg2epa_check%'' and active order by fid asc';

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