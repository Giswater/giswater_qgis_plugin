/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2642

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setvisitmanager(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
--INSERT
SELECT SCHEMA_NAME.gw_api_setvisitmanager($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "tableName":"ve_visit_user_manager", "id":null, "idName":"visit_id"},
"data":{"fields":{"user_id":1, "date":'null', "team_id":1, "vehicle_id":1, "starttime":null, "endtime":null},
	"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}
	}$$)
	
--UPDATE
SELECT SCHEMA_NAME.gw_api_setvisitmanager($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "tableName":"ve_visit_user_manager", "id":1, "idName":"visit_id"},
"data":{"fields":{"user_id":1, "date":'null', "team_id":1, "vehicle_id":1, "starttime":null, "endtime":null},
	"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}
	}$$)
*/

DECLARE
	v_tablename text;
	v_apiversion text;
	v_id text;
	v_outputparameter json;
	v_insertresult json;
	v_message json;
	v_feature json;

BEGIN

-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

--  get input values
    v_id = ((p_data ->>'feature')::json->>'id')::text;
    v_feature = p_data ->>'feature';

-- set output parameter

	v_outputparameter := concat('{"client":',((p_data)->>'client'),', "feature":',((p_data)->>'feature'),', "data":',((p_data)->>'data'),'}')::json;
	
		--setting the update
		PERFORM gw_api_setfields (v_outputparameter);

		-- getting message
		SELECT gw_api_getmessage(v_feature, 50) INTO v_message;

		RAISE NOTICE '--- UPDATE VISIT gw_api_setfields USING v_id % WITH MESSAGE: % ---', v_id, v_message;

				  
--    Return
    RETURN ('{"status":"Accepted", "message":'||v_message||', "apiVersion":'|| v_apiversion ||
    	    ', "body": {"feature":{"id":"'||v_id||'"}}}')::json;    

--    Exception handling
   -- EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    

      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
