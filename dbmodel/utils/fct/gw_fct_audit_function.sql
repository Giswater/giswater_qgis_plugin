/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: XXXX


DROP FUNCTION IF EXISTS SCHEMA_NAME.audit_function (integer, integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_audit_cat_function_id integer, p_audit_cat_error_id integer) RETURNS "pg_catalog"."int2" AS $BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN audit_function($1, $2, null); 
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;
  



DROP FUNCTION IF EXISTS SCHEMA_NAME.audit_function (integer, integer, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(    p_audit_cat_error_id integer,    p_audit_cat_function_id integer,    p_debug_text text)
  RETURNS smallint AS
$BODY$
DECLARE
    function_rec record;
    cat_error_rec record;

BEGIN
    
    SET search_path = "SCHEMA_NAME", public; 
    SELECT * INTO cat_error_rec FROM audit_cat_error WHERE audit_cat_error.id=p_audit_cat_error_id; 
	
		IF cat_error_rec IS NULL THEN
			RAISE EXCEPTION 'The process has returned and error code, but this error code is not present on the audit_cat_error table. Please contact with your system administrator in order to update your audit_cat_error table';
		END IF;
            
        -- log_level of type 'INFO' or 'SUCCESS'
        IF cat_error_rec.log_level = 0 OR cat_error_rec.log_level = 3 THEN 
            RETURN p_audit_cat_error_id;

        -- log_level of type 'WARNING' (mostly applied to functions)
        ELSIF cat_error_rec.log_level = 1 THEN
            SELECT * INTO function_rec 
            FROM audit_cat_function WHERE audit_cat_function.id=p_audit_cat_function_id; 
            RAISE WARNING 'Function: [%] - %. HINT: %', function_rec.function_name, cat_error_rec.error_message, cat_error_rec.hint_message ;
            RETURN p_audit_cat_error_id;
        
        -- log_level of type 'ERROR' (mostly applied to trigger functions) 
        ELSIF cat_error_rec.log_level = 2 THEN
            SELECT * INTO function_rec 
            FROM audit_cat_function WHERE audit_cat_function.id=p_audit_cat_function_id; 
            RAISE EXCEPTION 'Function: [%] - %. HINT: %', function_rec.function_name, concat(cat_error_rec.error_message, ' ',p_debug_text), cat_error_rec.hint_message ;
        
        END IF;
        
		RETURN 1;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  


-- drop function gw_fct_audit_function(integer, integer, text)


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_function(
    p_audit_cat_error_id integer,
    p_audit_cat_function_id integer,
    p_debug_text text)
  RETURNS json AS
$BODY$

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

BEGIN
    
    SET search_path = "SCHEMA_NAME", public; 
    
    SELECT * INTO rec_cat_error FROM audit_cat_error WHERE audit_cat_error.id=p_audit_cat_error_id; 
    SELECT giswater, wsoftware INTO v_version, v_projectype FROM version order by 1 desc limit 1;
    
    SELECT txid_current() INTO v_txid;

    IF v_txid = (SELECT value FROM config_param_user WHERE parameter = 'cur_trans' AND cur_user = current_user) THEN
    RAISE NOTICE 'RETURN';
        IF rec_cat_error IS NULL THEN
            v_return_text = 'The process has returned and error code, but this error code is not present on the audit_cat_error table. Please contact with your system administrator in order to update your audit_cat_error table';
            v_level = 2;
            v_status = 'Failed';
        END IF;

        -- log_level of type 'WARNING' (mostly applied to functions)
        IF rec_cat_error.log_level = 1 THEN
            SELECT  concat('Function: ',function_name,' - ',rec_cat_error.error_message,'. HINT: ', rec_cat_error.hint_message,'.')  INTO v_return_text 
            FROM audit_cat_function WHERE audit_cat_function.id=p_audit_cat_function_id; 
            
            v_level = 1;
            v_status = 'Failed';

        -- log_level of type 'ERROR' (mostly applied to trigger functions) 
        ELSIF rec_cat_error.log_level = 2 THEN

            SELECT  concat('Function: ',function_name,' - ',rec_cat_error.error_message, ' ',p_debug_text,'. HINT: ', rec_cat_error.hint_message,'.')  INTO v_return_text 
            FROM audit_cat_function WHERE audit_cat_function.id=p_audit_cat_function_id; 

            v_level = 2;
            v_status = 'Failed';
        END IF;

   ELSE
        RAISE NOTICE 'EXCEPTION';
        IF rec_cat_error IS NULL THEN
            RAISE EXCEPTION 'The process has returned and error code, but this error code is not present on the audit_cat_error table. Please contact with your system administrator in order to update your audit_cat_error table';
        END IF;

        -- log_level of type 'WARNING' (mostly applied to functions)
        IF rec_cat_error.log_level = 1 THEN
                RAISE NOTICE 'log1';
            SELECT * INTO rec_function 
            FROM audit_cat_function WHERE audit_cat_function.id=p_audit_cat_function_id; 
            RAISE WARNING 'Function: [%] - %. HINT: %', rec_function.function_name, rec_cat_error.error_message, rec_cat_error.hint_message ;
        
        -- log_level of type 'ERROR' (mostly applied to trigger functions) 
        ELSIF rec_cat_error.log_level = 2 THEN
        RAISE NOTICE 'log2';
            SELECT * INTO rec_function 
            FROM audit_cat_function WHERE audit_cat_function.id=p_audit_cat_function_id; 

            RAISE EXCEPTION 'Function: [%] - %. HINT: %', rec_function.function_name, concat(rec_cat_error.error_message, ' ',p_debug_text), rec_cat_error.hint_message ;
    RETURN NULL;
        END IF;

    END IF;

        
        SELECT jsonb_build_object(
        'level', v_level,
        'status', v_status,
        'message', v_return_text) INTO v_result_info;

        RAISE NOTICE 'v_result_info,%',v_result_info;

        --    Control nulls
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