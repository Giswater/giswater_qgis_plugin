/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2820

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getmessage(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_getmessage($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{"message":"2", "function":"1312","debug_msg":null, "variables":"value"}}$$)
*/

DECLARE

rec_function record;
rec_cat_error record;
    
v_return_text text;
v_level integer;
v_error_context text;
v_txid TEXT;
v_result_info json;
v_projectype text;
v_version text;
v_status text;
v_message_id integer;
v_function_id integer;
v_message text;
v_variables text;
v_schemaname text;

BEGIN
    
	SET search_path = "SCHEMA_NAME", public; 
	
	v_schemaname = 'SCHEMA_NAME';
    
	-- Get parameters from input json
	v_message_id = lower(((p_data ->>'data')::json->>'message')::text);
	v_function_id = lower(((p_data ->>'data')::json->>'function')::text);
	v_message = lower(((p_data ->>'data')::json->>'debug_msg')::text);
	v_variables = lower(((p_data ->>'data')::json->>'variables')::text);
	
	
	SELECT giswater, project_type INTO v_version, v_projectype FROM sys_version order by 1 desc limit 1;
	
	-- get flow parameters
	SELECT * INTO rec_cat_error FROM sys_message WHERE sys_message.id=v_message_id; 
	SELECT txid_current() INTO v_txid;
				
	-- message process
	IF v_txid = (SELECT value FROM config_param_user WHERE parameter = 'utils_cur_trans' AND cur_user = current_user) THEN
		
		IF rec_cat_error IS NULL THEN 
			v_return_text = 'The process has returned an error code, but this error code is not present on the sys_message table. Please contact with your system administrator in order to update your sys_message table';
			v_level = 2;
			v_status = 'Failed';

		-- log_level of type 'WARNING' (mostly applied to functions)
		ELSIF rec_cat_error.log_level = 1 THEN
			SELECT  concat('Function: ',function_name,' - ',rec_cat_error.error_message,'. HINT: ', rec_cat_error.hint_message,'.')  INTO v_return_text 
			FROM sys_function WHERE sys_function.id=v_function_id; 
		
			v_level = 1;
			v_status = 'Failed';

		-- log_level of type 'ERROR' (mostly applied to trigger functions) 
		ELSIF rec_cat_error.log_level = 2 THEN

			IF v_message IS NOT NULL THEN
				SELECT  concat('Function: ',function_name,' - ',rec_cat_error.error_message, ' ',v_message,'. HINT: ', rec_cat_error.hint_message,'.')  INTO v_return_text 
				FROM sys_function WHERE sys_function.id=v_function_id; 
			ELSE
				SELECT  concat('Function: ',function_name,' - ',rec_cat_error.error_message,'. HINT: ', rec_cat_error.hint_message,'.')  INTO v_return_text 
				FROM sys_function WHERE sys_function.id=v_function_id; 
			END IF;

			v_level = 2;
			v_status = 'Failed';
			
		END IF;
		     	
	ELSE
			
		IF rec_cat_error IS NULL THEN
		    RAISE EXCEPTION 'The process has returned and error code, but this error code is not present on the sys_message table. Please contact with your system administrator in order to update your sys_message table';
		END IF;

		-- log_level of type 'WARNING' (mostly applied to functions)
		IF rec_cat_error.log_level = 1 THEN

			SELECT * INTO rec_function 
			FROM sys_function WHERE sys_function.id=v_function_id; 
			RAISE WARNING 'Function: [%] - %. HINT: %', rec_function.function_name, rec_cat_error.error_message, rec_cat_error.hint_message ;
		
		-- log_level of type 'ERROR' (mostly applied to trigger functions) 
		ELSIF rec_cat_error.log_level = 2 THEN

			SELECT * INTO rec_function 
			FROM sys_function WHERE sys_function.id=v_function_id; 

			IF v_message IS NOT NULL THEN
				RAISE EXCEPTION 'Function: [%] - %. HINT: % - % ', rec_function.function_name, concat(rec_cat_error.error_message, ' ',v_message), rec_cat_error.hint_message, v_variables ;
			ELSE
				RAISE EXCEPTION 'Function: [%] - %. HINT: % - %', rec_function.function_name, rec_cat_error.error_message, rec_cat_error.hint_message, v_variables ;
			END IF;

			RETURN NULL;
						
		END IF;
		
	END IF;
	      
	SELECT jsonb_build_object
	('level', v_level,
	'status', v_status,
	'message', v_return_text) INTO v_result_info;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Error message passed successfully"}, "version":"'||v_version||'"'||
       ',"body":{"form":{}'||
           ',"data":{"info":'||v_result_info||' }}'||
            '}')::json;
			
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;