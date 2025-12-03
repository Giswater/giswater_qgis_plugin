/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3030
-- DROP FUNCTION SCHEMA_NAME.gw_fct_debugsql(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_debugsql(p_data json)
  RETURNS json AS
$BODY$
/*EXAMPLE:
SELECT gw_fct_debugsql({"querystring" : "SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = 've_arc_pipe'::regclass AND i.indisprimary",
					"vars" : {"v_tablename" : "ve_arc_pipe", "null_example" : null}, "funcname" : "gw_fct_getlist", "flag" : 10});
*/

DECLARE
v_version text;
v_status text;
v_level integer = 1;
v_message text;
v_querystring text;
v_funcname text;
v_flag int;
v_vars json;
v_records json;
v_key text;
v_value text;
v_msgerr text;
v_error_context text;
v_error boolean = False;

BEGIN
	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	--  get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	
	v_querystring := (p_data ->> 'querystring');
	v_funcname := (p_data ->> 'funcname');
	v_flag := (p_data ->> 'flag');
	v_vars :=(p_data ->> 'vars')::json;
	v_msgerr := concat('The next query ''', v_querystring, ''' was executed with NULL values: ');
	FOR v_key, v_value IN SELECT  var.key, var.value FROM  json_each_text(v_vars) var LOOP
		IF v_value IS NULL THEN
			v_error = True;
			v_msgerr := concat(v_msgerr, v_key, ', ' );
		END IF;
	END LOOP;

	IF v_error IS True THEN
		v_msgerr := concat(v_msgerr, 'in function ''', v_funcname, ''' in flag ', v_flag);
		RETURN ('{"status":"Accepted", "MSGERR":'|| to_json(v_msgerr) ||' }')::json;
	END IF;
	-- Return
	RETURN ('{"status":"Accepted", "MSGERR":"" }')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
