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

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_mincut_id := ((p_data ->>'data')::json->>'mincutId')::integer;
	v_node := ((p_data ->>'data')::json->>'nodeId')::text;
	v_usepsectors := ((p_data ->>'data')::json->>'usePsectors')::text;

	UPDATE man_valve
	SET closed = NOT closed
	WHERE node_id = v_node;

	v_status = 'Accepted';
	v_level = 3;
	v_message = 'Change valve status done successfully';

	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;