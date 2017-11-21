/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_audit_cat_function_id integer, p_audit_cat_error_id integer) RETURNS "pg_catalog"."int2" AS $BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN audit_function($1, $2, null); 
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;
  


CREATE OR REPLACE FUNCTION audit_function(    p_audit_cat_error_id integer,    p_audit_cat_function_id integer,    p_debug_text text)
RETURNS smallint AS

$BODY$
DECLARE
    function_rec record;
    cat_error_rec record;

BEGIN
    
    SET search_path = "ud30", public; 
    SELECT * INTO cat_error_rec FROM audit_cat_error WHERE audit_cat_error.id=p_audit_cat_error_id;  

    BEGIN
    
        
        -- log_level of type 'INFO' or 'SUCCESS'
        IF cat_error_rec.log_level = 0 OR cat_error_rec.log_level = 3 THEN 
            RETURN p_audit_cat_error_id;

        -- log_level of type 'WARNING' (mostly applied to functions)
        ELSIF cat_error_rec.log_level = 1 THEN
            RAISE WARNING 'Function: [%] - %, (%)', function_rec.name, cat_error_rec.error_message, p_debug_text USING HINT = cat_error_rec.hint_message ;
            RETURN p_audit_cat_error_id;
        
        -- log_level of type 'ERROR' (mostly applied to trigger functions) 
        ELSIF cat_error_rec.log_level = 2 THEN
            SELECT * INTO function_rec 
            FROM audit_cat_function WHERE audit_cat_function.id=p_audit_cat_function_id; 
            RAISE EXCEPTION 'Function: [%] - %, (%)', function_rec.name, cat_error_rec.error_message, p_debug_text USING HINT = cat_error_rec.hint_message ;
        
        END IF;
        
    END;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  

