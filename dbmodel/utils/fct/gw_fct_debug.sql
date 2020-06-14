/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2830

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_debug( p_data json)
  RETURNS json AS
$BODY$

/*
PERFORM SCHEMA_NAME.gw_fct_debug(concat('{"data":{"msg":"Toolbar", "variables":"',v_point,'"}}')::json);
SELECT SCHEMA_NAME.gw_fct_debug(concat('{"data":{"msg":"Toolbar", "variables":"a"}}')::json);

UPDATE config_param_system SET value = '{"status":true}' WHERE parameter = 'admin_transaction_db'
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
v_schemaname text;
v_fullmessage text;
v_systranstaction_db boolean;

BEGIN
    
	SET search_path = "SCHEMA_NAME", public; 
	
	v_schemaname = 'SCHEMA_NAME';

	v_message = lower(((p_data ->>'data')::json->>'msg')::text);
	v_variables = lower(((p_data ->>'data')::json->>'variables')::text);
	
	-- get system parameters
	v_systranstaction_db = (SELECT value::json->>'status' FROM config_param_system WHERE parameter = 'admin_transaction_db')::boolean;
	SELECT giswater, project_type INTO v_version, v_projectype FROM sys_version order by 1 desc limit 1;
	
	-- get parameters from user
	v_debug = (SELECT value::boolean FROM config_param_user WHERE parameter = 'debug_mode' AND cur_user=current_user);

	-- debug process
	IF v_debug THEN

		-- create message
		v_fullmessage = concat(v_message,' ',v_variables);
		
		-- sending to postgreSQL console	
	   	RAISE NOTICE ' % ', v_fullmessage;
		
		-- sending notify
		IF v_systranstaction_db THEN
		
			-- using additional db for transactions
			--INSERT INTO notify (channel, cur_user, message) VALUES (replace(current_user,'.','_'), current_user, v_message);
			
			INSERT INTO audit (fid, log_message) VALUES (998, v_message);
			--raise exception 'adshadsfhadfhbdasfhdfh';
				
		ELSE 
			-- using normal notify with personal channel
			PERFORM pg_notify(replace(current_user,'.','_'), '{"functionAction":{"functions":[{"name":"debug", "parameters":{"message":'||v_fullmessage||
			'}]},"user":"'||current_user||'","schema":"'||v_schemaname||'"}');
		END IF;
	END IF;
			
	--    Control nulls
	v_version := COALESCE(v_version, '{}'); 
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