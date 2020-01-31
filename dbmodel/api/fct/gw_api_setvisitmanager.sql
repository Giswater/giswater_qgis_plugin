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

--ONLY UPDATE ARE POSSIBLE. 
SELECT "SCHEMA_NAME".gw_api_setvisitmanager($${"client":{"device":3, "infoType":100, "lang":"ES"}, 
"feature":{"featureType":"visit", "tableName":"ve_visit_user_manager", "idName":"id"}, 
"data":{"fields":{"user_id":"geoadmin", "team_id":"4", "lot_id":"1"},
"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)
*/

DECLARE
	v_tablename text;
	v_apiversion text;
	v_id text;
	v_outputparameter json;
	v_insertresult json;
	v_message json;
	v_feature json;
	v_lot integer;
	v_team integer;
	v_thegeom public.geometry;
	v_x float;
	v_y float;
	v_user text;
	v_date text;
	v_data json;
	v_record record;
	

BEGIN

-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;
		
-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
	p_data = REPLACE (p_data::text, '''''', 'null');

	
--  get input values
    v_user := (((p_data ->>'data')::json->>'fields')::json->>'user_id');
    v_date := (((p_data ->>'data')::json->>'fields')::json->>'date');
    v_team = (((p_data ->>'data')::json->>'fields')::json->>'team_id')::integer;
    v_lot = (((p_data ->>'data')::json->>'fields')::json->>'lot_id')::integer;
    v_x = (((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord')::float;
    v_y = (((p_data ->>'data')::json->>'deviceTrace')::json->>'ycoord')::float;
    v_thegeom = ST_SetSRID(ST_MakePoint(v_x, v_y), (SELECT st_srid(the_geom) from arc limit 1));

 	

    -- Check if exist some other workday opened, and close
	EXECUTE 'SELECT team_id, lot_id, endtime, user_id FROM (SELECT * FROM om_visit_lot_x_user WHERE user_id=''' || v_user ||''' ORDER BY id DESC) a LIMIT 1' INTO v_record;
	
	IF v_record.user_id IS NULL OR v_record.endtime IS NOT NULL THEN
	
		-- Insert start work day
		INSERT INTO om_visit_lot_x_user (team_id, lot_id , the_geom) VALUES (v_team, v_lot, v_thegeom);

		-- Update selector_lot
		EXECUTE 'DELETE FROM selector_lot WHERE cur_user='''|| v_user ||'''';
		EXECUTE 'INSERT INTO selector_lot (lot_id, cur_user) VALUES ('|| v_lot ||', '''|| v_user ||''')';
		
		-- message
		SELECT gw_api_getmessage(null, 70) INTO v_message;
		v_data = p_data->>'data';
		v_data = gw_fct_json_object_set_key (v_data, 'message', v_message);
		p_data = gw_fct_json_object_set_key (p_data, 'data', v_data);
	ELSE

		EXECUTE 'SELECT team_id, lot_id FROM (SELECT * FROM SCHEMA_NAME.om_visit_lot_x_user WHERE user_id=''' || v_user ||''' ORDER BY id DESC) a LIMIT 1' INTO v_record;

		IF v_record.team_id::text != v_team::text OR v_record.lot_id::text != v_lot::text THEN

			UPDATE om_visit_lot_x_user SET endtime = ("left"((date_trunc('second'::text, now()))::text, 19))::timestamp without time zone 
			WHERE id = (SELECT id FROM (SELECT * FROM om_visit_lot_x_user WHERE user_id=v_user ORDER BY id DESC) a LIMIT 1); 

			-- Insert start work day
			INSERT INTO om_visit_lot_x_user (team_id, lot_id , the_geom) VALUES (v_team, v_lot, v_thegeom);

			-- Update selector_lot
			EXECUTE 'DELETE FROM selector_lot WHERE cur_user='''|| v_user ||'''';
			EXECUTE 'INSERT INTO selector_lot (lot_id, cur_user) VALUES ('|| v_lot ||', '''|| v_user ||''')';
			
			-- message
			SELECT gw_api_getmessage(null, 70) INTO v_message;
			v_data = p_data->>'data';
			v_data = gw_fct_json_object_set_key (v_data, 'message', v_message);
			p_data = gw_fct_json_object_set_key (p_data, 'data', v_data);
		ELSE
			UPDATE om_visit_lot_x_user SET endtime = ("left"((date_trunc('second'::text, now()))::text, 19))::timestamp without time zone 
			WHERE id = (SELECT id FROM (SELECT * FROM om_visit_lot_x_user WHERE user_id=v_user ORDER BY id DESC) a LIMIT 1); 

			-- Update selector_lot
			EXECUTE 'DELETE FROM selector_lot WHERE cur_user='''|| v_user ||'''';
			
			-- message
			SELECT gw_api_getmessage(null, 80) INTO v_message;
			v_data = p_data->>'data';
			v_data = gw_fct_json_object_set_key (v_data, 'message', v_message);
			p_data = gw_fct_json_object_set_key (p_data, 'data', v_data);
		END IF;	
	END IF;

	
	-- Return
	RETURN gw_api_getvisitmanager(p_data); 

--    Exception handling
   -- EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    

      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
