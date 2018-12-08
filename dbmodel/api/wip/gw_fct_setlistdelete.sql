/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION ws_sample.gw_api_setlistdelete(p_data json)
  RETURNS json AS
$BODY$

/* example
visit:
SELECT ws_sample.gw_api_setlistdelete('{"client":{"device":3, "infoType":100, "lang":"ES"}, 
		"feature":{"featureType":"visit", "tableName":"ve_visit_multievent_x_arc", "id":1130, "idname": "visit_id"}}')
*/

DECLARE
--    Variables
    v_tablename text;
    v_id  character varying;
    v_querytext varchar;
    v_apiversion json;
    v_schemaname text;
    v_featuretype text;
    v_idname text;
    v_message text;
    v_result text;
    v_messagelevel integer = 0;

BEGIN
	--  Set search path to local schema
	SET search_path = "ws_sample", public;
	v_schemaname = 'ws_sample';
	
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;
       
	-- Get input parameters:
	v_featuretype := (p_data ->> 'feature')::json->> 'featureType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_idname := (p_data ->> 'feature')::json->> 'idname';

	-- check if feature exists
	v_querytext := 'SELECT * FROM ' || quote_ident(v_tablename) ||' WHERE '|| quote_ident(v_idname) ||' = '||quote_literal(v_id);
	EXECUTE v_querytext INTO v_result ;

	-- if exists
	IF v_result IS NOT NULL THEN
		v_querytext := 'DELETE FROM ' || quote_ident(v_tablename) ||' WHERE '|| quote_ident(v_idname) ||' = '||quote_literal(v_id);
		SELECT gw_api_getmessage(p_data,20) INTO v_message;
		EXECUTE v_querytext ;
	ELSE
		SELECT gw_api_getmessage(p_data,30) INTO v_message;
	END IF;

--    Return
    RETURN ('{"status":"Accepted", "message":'||v_message||', "apiVersion":'|| v_apiversion ||
	    ', "body": {"feature":{"tableName":"'||v_tablename||'", "id":"'||v_id||'"}}}')::json;    

--    Exception handling
  --  EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || (to_json(SQLERRM)) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_sample.gw_api_setfeatureinsert(json)
  OWNER TO geoadmin;
