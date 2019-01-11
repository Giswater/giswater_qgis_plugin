/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2612

CREATE OR REPLACE FUNCTION "ws_sample"."gw_api_setfileinsert"(p_data json) RETURNS pg_catalog.json AS 
$BODY$

/*
SELECT ws_sample.gw_api_setfileinsert($${"client":{"device":3, "infoType":100, "lang":"ES"}, 
	"feature":{"featureType":"file", "tableName":"om_visit_file", "id":10004, "idName": "id"}, 
	"data":{"fields":{"visit_id":10004, "hash":"testhash", "url":"urltest", "filetype":"png"},
		"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)	
*/

DECLARE
	-- variables
	v_id int8;
	v_apiversion json;
	v_outputparameter json;
	v_insertresult json;
	v_message json;
	v_feature json;

BEGIN

	-- set search path to local schema
	SET search_path = "ws_sample", public;
    
	-- get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;
	
	-- set output parameter
	v_outputparameter := concat('{"client":',((p_data)->>'client'),', "feature":',((p_data)->>'feature'),', "data":',((p_data)->>'data'),'}')::json;

	-- set insert
	SELECT gw_api_setinsert (v_outputparameter) INTO v_insertresult;

	-- set new id
	v_id=(((v_insertresult->>'body')::json->>'feature')::json->>'id')::integer;

	-- update table with device parameters
	UPDATE om_visit_file SET xcoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord')::float,
				  ycoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'ycoord')::float,
				  compass=(((p_data ->>'data')::json->>'deviceTrace')::json->>'compass')::float
				  WHERE id=v_id;

	-- get message
	v_message = (v_insertresult->>'message')::json;

	--    Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "apiVersion":'|| v_apiversion ||
		', "body": {"feature":{"id":"'||v_id||'"}}}')::json;    

	--  Exception handling
	--EXCEPTION WHEN OTHERS THEN 
--		RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

