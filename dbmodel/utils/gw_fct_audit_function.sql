/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_audit_cat_error_id int4) RETURNS "pg_catalog"."int2" AS $BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN audit_function($1, null, null);
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;
  
  
CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_audit_cat_error_id int4, p_debug_info text) RETURNS "pg_catalog"."int2" AS $BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN audit_function($1, null, $2);
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;


CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_audit_cat_function_id int4, p_audit_cat_error_id int4) RETURNS "pg_catalog"."int2" AS $BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN audit_function($1, $2, null); 
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;
  


CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_audit_cat_error_id integer, p_audit_cat_function_id integer, p_debug_info text) RETURNS smallint AS $BODY$
DECLARE
    control_rec boolean;
    function_rec record;
    audit_cat_error_rec record;
    message_rec text;

BEGIN
    
    SET search_path = "SCHEMA_NAME", public; 
    
    SELECT audit_function_control INTO control_rec FROM config;
    SELECT * INTO audit_cat_error_rec FROM audit_cat_error WHERE audit_cat_error.id=p_audit_cat_error_id;  

    BEGIN
    
        IF control_rec IS TRUE THEN
            INSERT INTO audit_function_actions (audit_cat_error_id, audit_cat_function_id, debug_info, query, user_name, addr) 
            VALUES (p_audit_cat_error_id, p_audit_cat_function_id, p_debug_info, current_query(), session_user, inet_client_addr());
        END IF;

        -- function and trigger function trace log
        IF p_audit_cat_error_id >= 1 AND p_audit_cat_error_id < 99 THEN 
            RETURN p_audit_cat_error_id;

        -- trigger function return
        ELSIF (p_audit_cat_error_id >= 100 AND p_audit_cat_error_id < 500) AND audit_cat_error_rec.log_level=0 THEN
            SELECT 'WNG:'||id::text||' - '||error_message INTO message_rec FROM audit_cat_error WHERE audit_cat_error.id=p_audit_cat_error_id;   
            SELECT * INTO function_rec FROM audit_cat_function WHERE audit_cat_function.id=p_audit_cat_function_id; 
            RAISE NOTICE '[%]:Procedure', function_rec.name USING HINT = message_rec;
            RETURN p_audit_cat_error_id;
        
        -- trigger function return        
        ELSIF (p_audit_cat_error_id >= 100 AND p_audit_cat_error_id < 500) AND audit_cat_error_rec.log_level=1 THEN
            SELECT 'ERR:'||id::text||' - '||error_message||'. '||hint_message INTO message_rec FROM audit_cat_error WHERE audit_cat_error.id=p_audit_cat_error_id;   
            SELECT * INTO function_rec FROM audit_cat_function WHERE audit_cat_function.id=p_audit_cat_function_id; 
            RAISE EXCEPTION '[%]:Procedure', function_rec.name USING HINT = message_rec;
            RETURN p_audit_cat_error_id;
        
        -- function return        
        ELSIF p_audit_cat_error_id >= 501 AND p_audit_cat_error_id < 998 THEN
            RETURN p_audit_cat_error_id;
        
        -- No errors
        ELSE
            RETURN 0;
        END IF;

        EXCEPTION WHEN foreign_key_violation THEN
        INSERT INTO audit_function_actions (audit_cat_error_id, audit_cat_function_id, debug_info, query, user_name, addr) 
        VALUES (999, p_audit_cat_function_id, p_debug_info, current_query(), session_user, inet_client_addr());
        RETURN 999;
        
    END;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
