/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2912

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setvehicleload(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setvehicleload(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_setvehicleload($${"client":{"device":4,"infoType":0,"lang":"es"},"form":{},"feature":{},
"data":{"fields":{"vehicle_id":"2","load":"1234","hash":"5de7a2e92995b7455a7fe3c7",
"photo_url":"https:\/\/bmaps.bgeo.es\/dev\/demo\/external.image.php?img="},"deviceTrace":{"xcoord":null,"ycoord":null,"compass":null},"pageInfo":null}}$$) AS result
*/

DECLARE

v_version text;
v_message json;
v_geometry json;
v_client json;
v_team_id text;
v_load text;
v_vehicle_id integer;
v_hash text;
v_photo_url text;
v_error_context text;
v_message_aux text;
v_return json;

BEGIN

	-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

	--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

	--  get input values
    v_client = (p_data ->>'client')::json;
    v_vehicle_id = ((p_data ->>'data')::json->>'fields')::json->>'vehicle_id';
    v_team_id = ((p_data ->>'data')::json->>'fields')::json->>'team_id';
    v_load = ((p_data ->>'data')::json->>'fields')::json->>'load';
    v_hash = ((p_data ->>'data')::json->>'fields')::json->>'hash';
    v_photo_url = ((p_data ->>'data')::json->>'fields')::json->>'photo_url';

	-- don't allow to add a load without related photo
	IF v_hash IS NULL THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3199", "function":"2912","debug_msg":""}}$$);'INTO v_message;
		v_message = (((v_message->>'body')::json->>'data')::json->>'info')::json;
		RETURN ('{"status":"Accepted", "message":'||v_message||', "version":"'|| v_version ||'",
		"body": {}}')::json;

	END IF;

	-- Inserting data (doesn't matter if lot is started or not)
	EXECUTE 'INSERT INTO om_vehicle_x_parameters (vehicle_id, team_id, image, load, cur_user, tstamp) 
	VALUES('''||v_vehicle_id||''','||v_team_id::integer||', '''|| COALESCE(v_photo_url, '') ||COALESCE(v_hash, '') ||''','''||COALESCE(v_load, '0')||''', current_user,'''||NOW()||''')';

	-- message
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	"data":{"message":"3118", "function":"2912","debug_msg":""}}$$);'INTO v_message;

	v_message = (((v_message->>'body')::json->>'data')::json->>'info')::json;

	--  Control NULL's
	v_version := COALESCE(v_version, '');
	v_message := COALESCE(v_message, '{}');
	v_geometry := COALESCE(v_geometry, '{}');

	-- Return form to refresh
	SELECT gw_fct_getvisitmanager(('{"client":'||v_client||',
								  "feature":{"featureType":"visit","tableName":"v_visit_lot_user","idName":"user_id","id":"'||current_user||'"},
								  "form":{"tabData":{"active":false},"tabLots":{"active":false},"tabDone":{"active":false},"tabTeam":{"active":true},"navigation":{"currentActiveTab":"tab_data"}},
								  "data":{"relatedFeature":{"type":"", "id":""},
								  "fields":{"user_id":"'||current_user||'","date":"'||current_date||'","team_id":"'||v_team_id||'","vehicle_id":"'||v_vehicle_id||'","lot_id":""},
								  "deviceTrace":{"xcoord":null,"ycoord":null,"compass":null},"pageInfo":null}}')::json) INTO v_return;
--    Return
      RETURN v_return;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
