/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2830

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_debug( p_data json)
  RETURNS json AS
$BODY$

/*
PERFORM SCHEMA_NAME.gw_fct_debug(concat('{"data":{"msg":"Toolbar", "variables":"',v_point,'"}}')::json);
SELECT SCHEMA_NAME.gw_fct_debug(concat('{"data":{"msg":"Toolbar", "variables":"a"}}')::json);

UPDATE config_param_user SET value = 'true' WHERE parameter = 'debug_mode';

*/

DECLARE

v_result_info json;
v_projectype text;
v_version text;
v_error_id integer;
v_message text;
v_variables text;
v_debug boolean;
v_schemaname text = 'SCHEMA_NAME';
v_fullmessage text;
v_tableversion text = 'sys_version';
v_columntype text = 'project_type';
	
BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- get info from version table
	IF (SELECT tablename FROM pg_tables WHERE schemaname = v_schemaname AND tablename = 'version') IS NOT NULL THEN v_tableversion = 'version'; v_columntype = 'wsoftware'; END IF;
 	EXECUTE 'SELECT '||quote_ident(v_columntype)||', giswater FROM '||quote_ident(v_tableversion)||' LIMIT 1' INTO v_projectype, v_version;

	v_message = lower(((p_data ->>'data')::json->>'msg')::text);
	v_variables = lower(((p_data ->>'data')::json->>'variables')::text);
	
	-- get parameters from user
	v_debug = (SELECT value::boolean FROM config_param_user WHERE parameter = 'debug_mode' AND cur_user=current_user);

	-- debug process
	IF v_debug THEN

		-- create message
		v_fullmessage = concat(v_message,' ',v_variables);
		
		-- sending to postgreSQL console	
	   	RAISE NOTICE ' % ', v_fullmessage;
		
		-- sending notify
		-- using normal notify with personal channel
		PERFORM pg_notify(replace(current_user,'.','_'), '{"functionAction":{"functions":[{"name":"debug", "parameters":{"message":'||v_fullmessage||
		'}]},"user":"'||current_user||'","schema":"'||v_schemaname||'"}');
	END IF;
			
	--    Control nulls
	v_version := COALESCE(v_version, ''); 
	v_result_info := COALESCE(v_result_info, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Error message passed successfully"}, "version":"'||v_version||'"'||
       ',"body":{"form":{}'||
           ',"data":{"info":'||v_result_info||' }}'||
            '}')::json;
			
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;