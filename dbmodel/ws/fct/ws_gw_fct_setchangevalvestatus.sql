/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3026

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setchangevalvestatus(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setchangevalvestatus(p_data json) RETURNS json AS $BODY$

DECLARE

v_mincut_id integer;
v_node text;
v_error_context text;
v_level integer;
v_status text;
v_message text;
v_version text;
v_usepsectors text;
v_getmessage JSON;
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_mincut_id := ((p_data ->>'data')::json->>'mincutId')::integer;
	v_node := ((p_data ->>'data')::json->>'nodeId')::text;
	v_usepsectors := ((p_data ->>'data')::json->>'usePsectors')::text;
	
	IF (SELECT count(*) FROM man_valve WHERE node_id  = v_node) > 0 THEN

		UPDATE man_valve SET closed = NOT closed WHERE node_id = v_node;
		--v_message = 'Change valve status done successfully. You can continue by clicking on more valves or finish the process by executing Refresh Mincut';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3176", "function":"3026","debug_msg":"", "is_process":true}}$$)'
		INTO v_getmessage;
	ELSE
		--v_message = 'No valve has been choosen. You can continue by clicking on more valves or finish the process by clicking again on Change Valve Status';
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3174", "function":"3026","debug_msg":"", "is_process":true}}$$)'
		INTO v_getmessage;
	END IF;
	
	v_message = json_extract_path(v_getmessage,'body','data','info','message');
	v_status = 'Accepted';
	v_level = 3;
	

	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":'||v_message||'}}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;