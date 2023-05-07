/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3238

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_getnodeborder(p_data json) RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getnodeborder($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},"feature":{}, "data":{}}$$)::JSON
-- fid: v_fid

SELECT array_agg(node_id) FROM (SELECT DISTINCT node_id FROM node_border_sector WHERE sector_id IN (1,2,3)) row
SELECT array_agg(node_id) FROM (SELECT DISTINCT node_id FROM node_border_sector WHERE sector_id IN (1,2,3)) row
*/

DECLARE
    
v_sector text;
v_result text;
v_result_info json;
v_result_line json;
v_version text;
v_error_context text;
v_fid integer=387;
v_querytext text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;
	
	
	-- Computing process
	v_querytext = 'SELECT array_agg(node_id) FROM (SELECT DISTINCT node_id FROM node_border_sector 
	               WHERE sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user = current_user)) row';

	EXECUTE v_querytext INTO v_result;
	v_result = REPLACE(REPLACE(v_result, '{','['),'}',']');

	-- info
	v_result := COALESCE(v_result, '[]'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
		     ',"data":{ "nodes":'||v_result||'}}'||
	    '}')::json;

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;