/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_trg_audit()
  RETURNS trigger AS
$BODY$


DECLARE
v_old_data json;
v_new_data json;
v_feature_id text;
v_feature_idname text;
BEGIN

    --	Set search path to local schema
	SET search_path = PARENT_SCHEMA, public;

    -- Get primary key column name
    SELECT a.attname::text
    INTO v_feature_idname
    FROM pg_index i
    JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
    WHERE i.indrelid = TG_RELID AND i.indisprimary
    LIMIT 1;

    -- Extract the primary key value dynamically
    IF TG_OP = 'INSERT' THEN
        EXECUTE format('SELECT ($1).%I::text', v_feature_idname) INTO v_feature_id USING NEW;
    ELSIF TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        EXECUTE format('SELECT ($1).%I::text', v_feature_idname) INTO v_feature_id USING OLD;
    END IF;

    IF (SELECT value::boolean FROM config_param_system WHERE parameter='admin_skip_audit') IS FALSE THEN

        IF (TG_OP = 'INSERT') THEN
            v_new_data := row_to_json(NEW.*);
            INSERT INTO audit.log (schema,table_name,user_name,action,newdata,query,id_name,feature_id)
            VALUES (TG_TABLE_SCHEMA::TEXT, TG_TABLE_NAME::TEXT ,session_user::TEXT,substring(TG_OP,1,1),v_new_data, current_query(),v_feature_idname, v_feature_id);
            RETURN NEW;

        ELSIF (TG_OP = 'UPDATE') THEN
            v_old_data := row_to_json(OLD.*);
            v_new_data := row_to_json(NEW.*);
            INSERT INTO audit.log (schema,table_name,user_name,action,olddata,newdata,query,id_name,feature_id)
            VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data,v_new_data, current_query(),v_feature_idname,v_feature_id);
            RETURN NEW;

        ELSIF (TG_OP = 'DELETE') THEN
            v_old_data := row_to_json(OLD.*);
            INSERT INTO audit.log (schema,table_name,user_name,action,olddata,query,id_name,feature_id)
            VALUES (TG_TABLE_SCHEMA::TEXT,TG_TABLE_NAME::TEXT,session_user::TEXT,substring(TG_OP,1,1),v_old_data, current_query(),v_feature_idname,v_feature_id);
            RETURN OLD;

        END IF;

    END IF;

    RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
