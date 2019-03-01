/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2642

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_api_setvisitmanager(p_data json)
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
		
--  get input values
    v_team = (((p_data ->>'data')::json->>'fields')::json->>'team_id')::integer;
    v_lot = (((p_data ->>'data')::json->>'fields')::json->>'lot_id')::integer;
    v_x = (((p_data ->>'data')::json->>'deviceTrace')::json->>'xcoord')::float;
    v_y = (((p_data ->>'data')::json->>'deviceTrace')::json->>'ycoord')::float;
    v_thegeom = ST_SetSRID(ST_MakePoint(v_x, v_y), (SELECT st_srid(the_geom) from .arc limit 1));

 
    INSERT INTO om_visit_lot_x_user (team_id, lot_id , the_geom) VALUES (v_team, v_lot, v_thegeom);
    UPDATE .om_visit_lot_x_user SET endtime = ("left"((date_trunc('second'::text, now()))::text, 19))::timestamp without time zone
	WHERE id = (SELECT id FROM (SELECT * FROM .om_visit_lot_x_user WHERE user_id=current_user ORDER BY id DESC) a LIMIT 1 OFFSET 1);

	-- getting message
	SELECT gw_api_getmessage(v_feature, 50) INTO v_message;

				  
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
