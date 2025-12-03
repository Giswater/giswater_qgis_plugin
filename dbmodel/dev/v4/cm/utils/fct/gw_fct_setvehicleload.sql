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

v_tablename text;
v_version text;
v_id integer;
v_message json;
v_feature json;
v_geometry json;
v_thegeom public.geometry;
v_client json;
v_user_id text;
v_team_id text;
v_lot_id text;
v_vehicle_name text;
v_load text;
v_vehicle_id integer;
v_hash text;
v_record record;
v_photo_url text;
v_image text;
v_error_context text;

BEGIN

	-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

	--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

    EXECUTE 'SELECT project_type FROM sys_version'
	INTO v_version;

	--  get input values
    v_client = (p_data ->>'client')::json;
    v_vehicle_name = ((p_data ->>'data')::json->>'fields')::json->>'vehicle_id';
    v_load = ((p_data ->>'data')::json->>'fields')::json->>'load';
    v_hash = ((p_data ->>'data')::json->>'fields')::json->>'hash';
    v_photo_url = ((p_data ->>'data')::json->>'fields')::json->>'photo_url';

	-- Get vehicle id
	--EXECUTE 'SELECT id FROM ext_cat_vehicle WHERE idval = '''|| v_vehicle_name ||'''' INTO v_vehicle_id;

	-- Get user_id and team_id
	EXECUTE 'SELECT user_id, team_id, lot_id, endtime FROM (SELECT * FROM om_visit_lot_x_user WHERE user_id = current_user ORDER BY id DESC) a LIMIT 1' INTO v_record;

	IF v_record.endtime IS NOT NULL THEN
		-- Inserting data (With started lot)
		EXECUTE 'INSERT INTO om_vehicle_x_parameters (vehicle_id, team_id, image, load, cur_user, tstamp) VALUES('''||v_vehicle_name||''','||v_record.team_id::integer||', '''|| COALESCE(v_photo_url, '') ||COALESCE(v_hash, '') ||''','''||COALESCE(v_load, '0')||''', current_user,'''||NOW()||''')';
	ELSE
		-- Inserting data (Without started lot)
		EXECUTE 'INSERT INTO om_vehicle_x_parameters (vehicle_id, lot_id, team_id, image, load, cur_user, tstamp) VALUES('''||COALESCE(v_vehicle_name, '')||''','||v_record.lot_id||','||v_record.team_id::integer||', '''|| COALESCE(v_photo_url, '') ||COALESCE(v_hash, '') ||''','''||COALESCE(v_load, '0')||''', current_user,'''||NOW()||''')';
	END IF;

	-- message
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	"data":{"message":"3118", "function":"2912","debug_msg":""}}$$);'INTO v_message;

	--  Control NULL's
	v_version := COALESCE(v_version, '');
	v_message := COALESCE(v_message, '{}');
	v_geometry := COALESCE(v_geometry, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "version":"'|| v_version ||'",
	"body": {}, "data":{}}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
