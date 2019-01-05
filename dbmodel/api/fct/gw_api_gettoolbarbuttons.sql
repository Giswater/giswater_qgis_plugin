/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2592

-- Function: ws_sample.gw_api_getlist(json)

-- DROP FUNCTION ws_sample.gw_api_getlist(json);

CREATE OR REPLACE FUNCTION ws_sample.gw_api_gettoolbarbuttons(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT ws_sample.gw_api_gettoolbarbuttons($${
"client":{"device":3, "infoType":100, "lang":"ES"}
"data":"projectButtons":{"a", "b", "c", "d", "e", "f", "g", "h", "i"}}$$)
*/


DECLARE
	v_apiversion text;
		
BEGIN

-- Set search path to local schema
    SET search_path = "ws_sample", public;
  
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

-- get role of user

-- get project type

--    Control NULL's
	v_featuretype := COALESCE(v_featuretype, '{}');
	v_layermanager := COALESCE(v_layermanager, '{}');
	v_filter_fields := COALESCE(v_filter_fields, '{}');
	v_result_list := COALESCE(v_result_list, '{}');
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_actions := COALESCE(v_actions, '{}');

--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"form":{}'||
		     ',"feature":{"featureType":"' || v_featuretype || '","tableName":"' || v_tablename ||'","idName":"'|| v_idname ||'", "actions":'||v_actions||'}'||
		     ',"data":{"layerManager":' || v_layermanager ||
			     ',"filterFields":' || v_filter_fields_json ||
			     ',"listValues":' || v_result_list ||'}}'||
	    '}')::json;
       
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



