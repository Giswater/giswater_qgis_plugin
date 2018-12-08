/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION ws_sample.gw_api_setvisit(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
--INSERT
SELECT ws_sample.gw_api_setvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "tableName":"ve_visit_multievent_x_arc", "id":null, "idname":"visit_id"},
"data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":10, "desperfectes_arc":1, "neteja_arc":3},
	"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}
	}$$)

--UPDATE
SELECT ws_sample.gw_api_setvisit($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"visit", "tableName":"ve_visit_multievent_x_arc", "id":1135,"idname":"visit_id"},
"data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":101121200, "desperfectes_arc":1, "neteja_arc":3},
	"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}
	}$$)
*/

DECLARE
	v_tablename text;
	v_apiversion text;
	v_id integer;
	v_outputparameter json;
	v_insertresult json;
	v_message json;
	v_feature json;

BEGIN

-- Set search path to local schema
    SET search_path = "ws_sample", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

--  get input values
    v_id = ((p_data ->>'feature')::json->>'id')::integer;
    v_feature = p_data ->>'feature';

-- set output parameter
	v_outputparameter := concat('{"client":',((p_data)->>'client'),', "feature":',((p_data)->>'feature'),', "data":',((p_data)->>'data'),'}')::json;
	
	--upsert visit
	IF v_id IS NULL THEN

		-- setting the insert
		SELECT gw_api_setfeatureinsert (v_outputparameter) INTO v_insertresult;

		-- getting new id
		v_id=(((v_insertresult->>'body')::json->>'feature')::json->>'id')::integer;

		-- updating visit
		UPDATE om_visit SET startdate=now(), enddate=now() WHERE id=v_id;			

		-- updating v_feature setting new id
		v_feature =  gw_fct_json_object_set_key (v_feature, 'id', v_id);

		-- getting message
		SELECT gw_api_getmessage(v_feature, 40) INTO v_message;
	ELSE 
		--setting the update
		PERFORM gw_api_setfields (v_outputparameter);
		UPDATE om_visit SET enddate=now() WHERE id=v_id;

		-- getting message
		SELECT gw_api_getmessage(v_feature, 50) INTO v_message;
	END IF;

	-- update event with device parameters
	UPDATE om_visit_event SET xcoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord')::float,
				  ycoord=(((p_data ->>'data')::json->>'deviceTrace')::json->>'ycoord')::float,
				  compass=(((p_data ->>'data')::json->>'deviceTrace')::json->>'compass')::float
				  WHERE visit_id=v_id;
				  
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
ALTER FUNCTION ws_sample.gw_api_setvisit(json)
  OWNER TO geoadmin;
