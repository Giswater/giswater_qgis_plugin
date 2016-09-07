/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-- Audit functions

CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_log_code_id int4) RETURNS "pg_catalog"."int2" AS $BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN audit_function($1, null, null);
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;
  
  
CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_log_code_id int4, p_debug_info text) RETURNS "pg_catalog"."int2" AS $BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN audit_function($1, null, $2);
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;


CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_log_function_id int4, p_log_code_id int4) RETURNS "pg_catalog"."int2" AS $BODY$
BEGIN
    SET search_path = "SCHEMA_NAME", public;
    RETURN audit_function($1, $2, null); 
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;
  

CREATE OR REPLACE FUNCTION SCHEMA_NAME.audit_function(p_log_code_id int4, p_log_function_id int4, p_debug_info text) RETURNS "pg_catalog"."int2" AS $BODY$
BEGIN

    SET search_path = "SCHEMA_NAME", public;
    
    BEGIN
        INSERT INTO log_detail (log_code_id, log_function_id, debug_info, query, user_name, addr) 
        VALUES (p_log_code_id, p_log_function_id, p_debug_info, current_query(), session_user, inet_client_addr());
        IF p_log_code_id >= 100 AND p_log_code_id < 200 THEN
            RETURN null;
        ELSE
            RETURN p_log_code_id;
        END IF;
    EXCEPTION WHEN foreign_key_violation THEN
        INSERT INTO log_detail (log_code_id, log_function_id, debug_info, query, user_name, addr) 
        VALUES (999, p_log_function_id, p_debug_info, current_query(), session_user, inet_client_addr());
        RETURN 999;
    END;
    
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

