/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2820

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getmessage(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_getmessage($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{"message":"2", "function":"1312","parameters":{"feature_id": 1, "expl_id": 2}, "variables":"value", "is_process":true}}$$)
*/

DECLARE

rec_function record;
rec_cat_error record;
    
v_return_text text;
v_level integer;
v_error_context text;
v_result_info json;
v_projectype text;
v_version text;
v_status text;
v_parameters json;
v_message_id integer;
v_function_id integer;
v_variables text;
v_debug Boolean;
v_isprocess boolean = false;

_key text;
_value text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- Get debug variable
	SELECT value::boolean INTO v_debug FROM config_param_system WHERE parameter='admin_message_debug';

	-- Get parameters from input json
	v_message_id = lower(((p_data ->>'data')::json->>'message')::text);
	v_function_id = lower(((p_data ->>'data')::json->>'function')::text);
	v_parameters = lower(((p_data ->>'data')::json->>'parameters')::text);
	v_variables = lower(((p_data ->>'data')::json->>'variables')::text);
	v_isprocess = lower(((p_data ->>'data')::json->>'is_process')::text);

	SELECT giswater, project_type INTO v_version, v_projectype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get flow parameters
	SELECT * INTO rec_cat_error FROM sys_message WHERE sys_message.id=v_message_id;
	

	SELECT * INTO rec_function
	FROM sys_function WHERE sys_function.id=v_function_id;

	IF rec_function IS NULL THEN
		RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', 1, 'text', 'Function does not exist'))::json;
	END IF;


	-- compare parameters in message with parameters recieved
	IF rec_cat_error IS NOT NULL THEN
		IF (select (select array(SELECT key FROM json_each_text(v_parameters) order by key)) =
		(select array(select split_part(token, '%', 2) as msg_parameters
		from string_to_table(rec_cat_error.error_message, ' ') token where token like '%\%%\%%'
		order by msg_parameters))) THEN
			-- replace parameter names in message with parameter values recieved
			FOR _key, _value IN
				SELECT * FROM json_each_text(v_parameters)
			LOOP
				rec_cat_error.error_message = replace(rec_cat_error.error_message, concat('%', _key, '%'), _value);
			END LOOP;
		ELSE
			-- return error parameters aren't the same
			RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', 1, 'text', 'Error in message parameters'))::json;
		END IF;
	END IF;
	
	-- message process
	if v_isprocess then

		IF rec_cat_error IS NULL THEN
			v_return_text = 'The process has returned an error code, but this error code is not present on the sys_message table. Please contact with your system administrator in order to update your sys_message table';
			v_level = 2;
			v_status = 'Failed';

		-- log_level of type 'WARNING' (mostly applied to functions)
		ELSIF rec_cat_error.log_level = 1 THEN
			SELECT * INTO rec_function
			FROM sys_function WHERE sys_function.id=v_function_id;
		
			IF v_debug THEN
				SELECT  concat('Function: ',function_name,' - ',upper(rec_cat_error.error_message),'. HINT: ', upper(rec_cat_error.hint_message),'.')  INTO v_return_text
				FROM sys_function WHERE sys_function.id=v_function_id;
			END IF;
		
			RAISE 'Function: [%] - %. HINT: % - %', rec_function.function_name, upper(rec_cat_error.error_message), upper(rec_cat_error.hint_message), v_variables
			USING ERRCODE  = concat('GW00', rec_cat_error.log_level);

		-- log_level of type 'ERROR' (mostly applied to trigger functions)
		ELSIF rec_cat_error.log_level = 2 THEN
			SELECT * INTO rec_function
			FROM sys_function WHERE sys_function.id=v_function_id;

			RAISE 'Function: [%] - %. HINT: % - %', rec_function.function_name, upper(rec_cat_error.error_message), upper(rec_cat_error.hint_message), v_variables 
			USING ERRCODE  = concat('GW00', rec_cat_error.log_level);
		ELSIF rec_cat_error.log_level = 3 THEN
			IF v_debug THEN
				SELECT  concat('Function: ',function_name,' - ',upper(rec_cat_error.error_message),'. HINT: ', upper(rec_cat_error.hint_message),'.')  INTO v_return_text
				FROM sys_function WHERE sys_function.id=v_function_id;
			ELSE
				SELECT  upper(rec_cat_error.error_message)  INTO v_return_text
				FROM sys_function WHERE sys_function.id=v_function_id;
			END IF;

			v_level = 2;
			v_status = 'Failed';
		
        -- log_level Accepted just to show message when fct is called from another function
		ELSIF rec_cat_error.log_level = 0 THEN

			SELECT  upper(rec_cat_error.error_message)  INTO v_return_text
			FROM sys_function WHERE sys_function.id=v_function_id;

			v_level = 3;
			v_status = 'Accepted';
		
			SELECT jsonb_build_object
			('level', v_level,
			'status', v_status,
			'message', v_return_text,
			'text', v_return_text) INTO v_result_info;
		
			RETURN v_result_info::json;

		END IF;

	ELSE

		IF rec_cat_error IS NULL THEN
		    RAISE EXCEPTION 'The process has returned and error code, but this error code is not present on the sys_message table. Please contact with your system administrator in order to update your sys_message table';
		END IF;

		-- log_level of type 'WARNING' (mostly applied to functions)
		IF rec_cat_error.log_level = 1 THEN

			SELECT * INTO rec_function
			FROM sys_function WHERE sys_function.id=v_function_id;
			RAISE WARNING 'Function: [%] - %. HINT: %', rec_function.function_name, upper(rec_cat_error.error_message), upper(rec_cat_error.hint_message) ;

		-- log_level of type 'ERROR' (mostly applied to trigger functions)
		ELSIF rec_cat_error.log_level = 2 THEN
			SELECT * INTO rec_function
			FROM sys_function WHERE sys_function.id=v_function_id;

			IF v_variables IS NOT NULL and v_variables != '<NULL>' THEN
				RAISE EXCEPTION 'Function: [%] - %. HINT: % - %', rec_function.function_name, upper(rec_cat_error.error_message), upper(rec_cat_error.hint_message), v_variables ;
			ELSE
				RAISE EXCEPTION 'Function: [%] - %. HINT: %', rec_function.function_name, upper(rec_cat_error.error_message), upper(rec_cat_error.hint_message);
			END IF;
		ELSIF rec_cat_error.log_level = 3 THEN

			SELECT * INTO rec_function
			FROM sys_function WHERE sys_function.id=v_function_id;

			IF v_debug THEN
				SELECT  concat('Function: ',function_name,' - ',upper(rec_cat_error.error_message),'. HINT: ', upper(rec_cat_error.hint_message),'.')  INTO v_return_text
				FROM sys_function WHERE sys_function.id=v_function_id;
			ELSE
				SELECT  upper(rec_cat_error.error_message)  INTO v_return_text
				FROM sys_function WHERE sys_function.id=v_function_id;
			END IF;
			v_level = 2;
			v_status = 'Error';


		ELSIF rec_cat_error.log_level = 0 THEN

			IF v_debug THEN
				SELECT  concat('Function: ',function_name,' - ',upper(rec_cat_error.error_message),'. HINT: ', upper(rec_cat_error.hint_message),'.')  INTO v_return_text
				FROM sys_function WHERE sys_function.id=v_function_id;
			ELSE
				SELECT  upper(rec_cat_error.error_message)  INTO v_return_text
				FROM sys_function WHERE sys_function.id=v_function_id;
			END IF;
			v_level = 3;
			v_status = 'Accepted';
		END IF;

	END IF;

	SELECT jsonb_build_object
	('level', v_level,
	'status', v_status,
	'message', v_return_text,
	'text', v_return_text) INTO v_result_info;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Message passed successfully"}, "version":"'||v_version||'"'||
       ',"body":{"form":{}'||
           ',"data":{"info":'||v_result_info||' }}'||
            '}')::json;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;