/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2862

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setlot(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setlot(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
--new call
SELECT SCHEMA_NAME.gw_fct_setlot($${
"client":{"device":4,"infoType":1,"lang":"es"},
"feature":{"featureType":"lot", "tableName":"om_visit_lot", "idName":"id", "id":"1"},
"form":{},
"data":{"fields":{}}}$$)
*/

DECLARE

v_message json;
v_data json;
v_version text;
v_id text;
v_idname text;
v_device integer;
v_tablename text;
v_client json;
v_descript text;
v_status text;
v_result text;
v_visitclass_id text;
v_team text;
v_real_enddate text;
v_error_context text;

BEGIN

	-- search_path
	SET search_path='SCHEMA_NAME';

	-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '"SCHEMA_NAME"', 'null');

	--  get parameters from input
	v_client = (p_data ->>'client')::json;
	v_device = ((p_data ->>'client')::json->>'device')::integer;
	v_id = ((p_data ->>'feature')::json->>'id')::text;
	v_idname = ((p_data ->>'feature')::json->>'idName')::text;
	v_tablename = (p_data ->>'feature')::json->>'tableName'::text;
	v_message = ((p_data ->>'data')::json->>'message');
	v_descript = ((p_data ->>'data')::json->>'fields')::json->>'descript'::text;
	v_status = ((p_data ->>'data')::json->>'fields')::json->>'status'::text;
	v_visitclass_id = ((p_data ->>'data')::json->>'fields')::json->>'visitclass_id'::text;
	v_team = ((p_data ->>'data')::json->>'fields')::json->>'team_id'::text;
	
	-- Control NULL's
	v_tablename := COALESCE(v_tablename, '');
	v_descript := COALESCE(v_descript, '');
	v_status := COALESCE(v_status, '');
	v_visitclass_id := COALESCE(v_visitclass_id, '');
	v_id := COALESCE(v_id, '');

	-- setting values on table om_visit_lot_x_user 
	-- TOD DO: set lot
	
	-- Check if is new lot
	EXECUTE 'SELECT * FROM om_visit_lot WHERE id =' || v_id ||'' INTO v_result;

	-- Get current user team id
	--EXECUTE 'SELECT team_id FROM om_visit_lot_x_user WHERE user_id = current_user ORDER BY starttime DESC' INTO v_team;
	

	IF v_result IS NOT NULL THEN

		--EXECUTE 'UPDATE ' || quote_ident(v_tablename) ||' SET idval = ' || quote_literal(v_lot_id) ||', descript = ' || quote_literal(v_descript) ||', status = ' || quote_literal(v_status) ||' WHERE id = ' || quote_literal(v_id) ||'' ;
		EXECUTE 'UPDATE ' || quote_ident(v_tablename) ||' SET descript = ' || quote_literal(v_descript) ||', status = ' || quote_literal(v_status) ||', visitclass_id = ' || quote_literal(v_visitclass_id) ||' WHERE id = ' || quote_literal(v_id) ||'' ;

		-- message
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3120", "function":"2862","debug_msg":""}}$$);'INTO v_message;
		v_data = p_data->>'data';
		v_data = gw_fct_json_object_set_key (v_data, 'message', v_message);
		p_data = gw_fct_json_object_set_key (p_data, 'data', v_data);
	ELSE
		--EXECUTE 'INSERT INTO ' || quote_ident(v_tablename) ||' (id, idval, descript, status) VALUES (' || quote_literal(v_id) ||', ' || quote_literal(v_lot_id) ||', ' || quote_literal(v_descript) ||', ' || quote_literal(v_status) ||')';
		EXECUTE 'INSERT INTO ' || quote_ident(v_tablename) ||' (id, descript, status, visitclass_id, team_id) VALUES (' || quote_literal(v_id) ||', ' || quote_literal(v_descript) ||', ' || quote_literal(v_status) ||', ' || quote_literal(v_visitclass_id) ||', ' || quote_literal(v_team) ||')';

		-- Update selector_lot for qgisserver user
		EXECUTE 'INSERT INTO selector_lot (lot_id, cur_user) VALUES ('|| v_id ||', ''qgisserver'')';
		
		-- message
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3118", "function":"2862","debug_msg":""}}$$);'INTO v_message;
		v_data = p_data->>'data';
		v_data = gw_fct_json_object_set_key (v_data, 'message', v_message);
		p_data = gw_fct_json_object_set_key (p_data, 'data', v_data);
	
	END IF;

	-- Get real_enddate value from lot
	EXECUTE 'SELECT real_enddate FROM om_visit_lot WHERE id = ' || quote_literal(v_id) ||'' INTO v_real_enddate;

	-- If new status is not executed, delete if exists real_enddate
	IF v_status != '5' AND v_real_enddate IS NOT NULL THEN
		UPDATE om_visit_lot SET real_enddate = NULL WHERE id=v_id::INTEGER;
	END IF;

	-- IF new status is executed, set real_enddate with current date
	IF v_status = '5' THEN
		UPDATE om_visit_lot SET real_enddate = NOW() WHERE id=v_id::INTEGER;
		--Add geometry to unexpected lots
		IF (SELECT the_geom FROM om_visit_lot WHERE id=v_id::INTEGER) IS NULL THEN
			PERFORM gw_fct_lot_psector_geom(v_id::INTEGER);
		END IF; 
	END IF;
	

	raise notice 'RETURN => %','SELECT SCHEMA_NAME.gw_fct_getlot('|| p_data || ')';
	
	-- Return
	RETURN gw_fct_getlot(p_data);
	
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;