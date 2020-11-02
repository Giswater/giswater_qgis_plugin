
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_audit() RETURNS TRIGGER AS $body$
DECLARE
    v_old_data json;
    v_new_data json;
    v_log_id integer;
    v_foreign_audit boolean;
BEGIN

--  Set search path to local schema
    SET search_path = SCHEMA_NAME, public;

    select TRUE INTO v_foreign_audit  from information_schema.tables where table_schema = 'foreign_audit' LIMIT 1;

    IF v_foreign_audit IS TRUE THEN
        IF (SELECT count(id) FROM foreign_audit.log) = 0 THEN
            v_log_id = 1;
        ELSE
            SELECT (max(id)+1) INTO v_log_id FROM foreign_audit.log;
        END IF;
    END IF;

    IF (TG_OP = 'INSERT') THEN
        v_new_data := row_to_json(NEW.*);
        
        IF v_foreign_audit IS TRUE THEN
            INSERT INTO foreign_audit.log (id,schema,table_name,user_name,action,newdata,query, tstamp)
            VALUES (v_log_id,TG_TABLE_SCHEMA::TEXT, TG_TABLE_NAME::TEXT ,session_user::TEXT,substring(TG_OP,1,1),v_new_data, current_query(), now());
        ELSE
            INSERT INTO audit.log (schema,table_name,user_name,action,newdata,query)
            VALUES (TG_TABLE_SCHEMA::TEXT, TG_TABLE_NAME::TEXT ,session_user::TEXT,substring(TG_OP,1,1),v_new_data, current_query());
        END IF;
        RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
        v_old_data := row_to_json(OLD.*);
        v_new_data := row_to_json(NEW.*);
        
        IF v_foreign_audit IS TRUE THEN
            INSERT INTO foreign_audit.log (id,schema,table_name,user_name,action,olddata,newdata,query, tstamp) 
            VALUES (v_log_id,TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query(),now());
        ELSE
            INSERT INTO audit.log (schema,table_name,user_name,action,olddata,newdata,query) 
            VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query());
        END IF;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        v_old_data := row_to_json(OLD.*);
        IF v_foreign_audit IS TRUE THEN
            INSERT INTO foreign_audit.log (id,schema,table_name,user_name,action,olddata,query, tstamp)
            VALUES (v_log_id,TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data, current_query(),now());
        ELSE
            INSERT INTO audit.log (schema,table_name,user_name,action,olddata,query)
            VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data, current_query());
        END IF;
        RETURN OLD;
    END IF;

END;
$body$
LANGUAGE plpgsql;

