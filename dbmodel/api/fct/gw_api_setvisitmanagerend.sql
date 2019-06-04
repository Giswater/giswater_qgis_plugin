/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2642

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setvisitmanagerend(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
--new call
SELECT SCHEMA_NAME.gw_api_setvisitmanagerend($${
"client":{"device":3,"infoType":100,"lang":"es"},
"feature":{"featureType":"visit","tableName":"v_visit_lot_user","idName":"user_id","id":"efuste"},
"data":{"fields":{"user_id":"geoadmin","date":"2020-01-20 11:38:27","team_id":"1","lot_id":"4"},"deviceTrace":{"xcoord":null,"ycoord":null,"compass":null}}}$$) AS result
*/

DECLARE
	v_message json;
	v_data json;
	v_user text;
	v_date text;
	v_team text;
	v_lot text;
	v_thegeom public.geometry;
	v_x float;
	v_y float;
	v_result text;
	v_apiversion text;

BEGIN

-- 	Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;
		
-- 	fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
	p_data = REPLACE (p_data::text, '''''', 'null');


	-- setting values on table om_visit_lot_x_user 

	v_user := (((p_data ->>'data')::json->>'fields')::json->>'user_id');
	v_date := (((p_data ->>'data')::json->>'fields')::json->>'date');
	v_team = (((p_data ->>'data')::json->>'fields')::json->>'team_id')::integer;
	v_lot = (((p_data ->>'data')::json->>'fields')::json->>'lot_id')::integer;
	v_x = (((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord')::float;
	v_y = (((p_data ->>'data')::json->>'deviceTrace')::json->>'ycoord')::float;
	v_thegeom = ST_SetSRID(ST_MakePoint(v_x, v_y), (SELECT st_srid(the_geom) from arc limit 1));


	-- Check if exist some other workday opened, and close
	EXECUTE 'SELECT endtime FROM (SELECT * FROM SCHEMA_NAME.om_visit_lot_x_user WHERE user_id=''' || v_user ||''' ORDER BY id DESC) a LIMIT 1' INTO v_result;
	
	IF v_result IS NULL THEN
		UPDATE om_visit_lot_x_user SET endtime = ("left"((date_trunc('second'::text, now()))::text, 19))::timestamp without time zone
		WHERE id = (SELECT id FROM (SELECT * FROM om_visit_lot_x_user WHERE user_id=v_user ORDER BY id DESC) a LIMIT 1);
	END IF;

	
	-- message
	SELECT gw_api_getmessage(null, 80) INTO v_message;
	v_data = p_data->>'data';
	v_data = gw_fct_json_object_set_key (v_data, 'message', v_message);
	v_data = gw_fct_json_object_set_key (v_data, 'widget_actions', '{"widget_disabled":"data_endbutton"}'::json);
	p_data = gw_fct_json_object_set_key (p_data, 'data', v_data);	

	RAISE NOTICE 'RETURN => gw_api_getvisitmanager(%)',p_data;
	
	-- Return
	RETURN gw_api_getvisitmanager(p_data);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



