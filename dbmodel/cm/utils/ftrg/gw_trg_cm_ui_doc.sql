/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = cm, public, pg_catalog;

CREATE OR REPLACE FUNCTION cm.gw_trg_ui_doc()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
DECLARE
    feature_type text;
    feature_column text;
    doc_table text;
    v_sql_insert text;
    v_sql text;
    v_new_value int;
    v_old_value int;
    v_new_data jsonb;
    feature_uuid_column text;
    feature_uuid_value uuid;
    v_feature_id int;
BEGIN
    EXECUTE 'SET search_path TO ' || quote_literal(TG_TABLE_SCHEMA) || ', public';
    feature_type := TG_ARGV[0];
    v_new_data := to_jsonb(NEW);
    doc_table := 'doc_x_' || feature_type;
    feature_column := feature_type || '_id';
    feature_uuid_column := feature_type || '_uuid';
    feature_uuid_value := v_new_data->>feature_uuid_column;

    IF TG_OP = 'INSERT' THEN
        INSERT INTO doc(path, name, doc_type, observ)
        VALUES (NEW.path, NEW.name, NEW.doc_type, NEW.observ)
        RETURNING id INTO NEW.doc_id;

        EXECUTE 'INSERT INTO ' || doc_table || ' (doc_id, ' || feature_uuid_column || ') VALUES ($1, $2)'
        USING NEW.doc_id, feature_uuid_value;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE format('SELECT ($1).%I', feature_column)
        INTO v_old_value
        USING OLD;

        v_sql := 'DELETE FROM ' || doc_table || ' WHERE doc_id = ' || quote_literal(OLD.doc_id) ||
                 ' AND ' || feature_column || ' = ' || quote_literal(v_old_value) || ';';
        EXECUTE v_sql;

        RETURN NULL;
    END IF;
END;
$function$
;

GRANT ALL ON FUNCTION cm.gw_trg_ui_doc() TO role_cm_manager;
GRANT ALL ON FUNCTION cm.gw_trg_ui_doc() TO role_cm_field;

