/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- FUNCTION CODE: 3414

CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_trg_audit()
  RETURNS trigger AS
$BODY$

DECLARE

v_old_data json;
v_new_data json;
v_feature_id text;
v_feature_idname text;
v_geometry text;
v_geometry_type text;
v_sql text;
v_columns text;
v_values text;
v_child_table text;
v_feature_types text[];

BEGIN

    --	Set search path to local schema
	SET search_path = PARENT_SCHEMA, public;

    -- Get the first column of view (assuming is primary key of the table)
    SELECT column_name
    INTO v_feature_idname
    FROM information_schema.columns
    WHERE table_schema = TG_TABLE_SCHEMA
      AND table_name = TG_TABLE_NAME
    ORDER BY ordinal_position
    LIMIT 1;

    -- Extract the primary key value dynamically
    IF v_feature_idname IS NOT NULL THEN
        IF TG_OP = 'INSERT' THEN
            EXECUTE format('SELECT ($1).%I::text', v_feature_idname) INTO v_feature_id USING NEW;
        ELSIF TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
            EXECUTE format('SELECT ($1).%I::text', v_feature_idname) INTO v_feature_id USING OLD;
        END IF;
    ELSE
        v_feature_id := 'unknown';
    END IF;

    -- Get feature types
    SELECT ARRAY(SELECT lower(id) FROM sys_feature_type) INTO v_feature_types;

    -- Set v_child_table variable
    v_child_table := TG_TABLE_NAME::TEXT;

    -- Get child
    IF v_child_table = ANY(v_feature_types) THEN

        IF (TG_OP = 'UPDATE') AND (NEW.the_geom IS DISTINCT FROM OLD.the_geom) THEN

            -- Update v_child_table if TG_TABLE_NAME is a parent layer (getting the child layer)
            EXECUTE ('SELECT cf.child_layer FROM '|| TG_TABLE_NAME::TEXT ||' n
            JOIN cat_'|| TG_TABLE_NAME::TEXT ||' cn ON n.'|| TG_TABLE_NAME::TEXT ||'cat_id = cn.id
            JOIN cat_feature cf ON cn.'|| TG_TABLE_NAME::TEXT ||'_type = cf.id
            WHERE '|| v_feature_idname ||' = '''|| v_feature_id ||'''') INTO v_child_table;

        ELSE
            IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
                RETURN NEW;
            ELSE
                RETURN OLD;
            END IF;
        END IF;

    END IF;

    -- Set geometry type
    v_geometry_type := CASE
                            WHEN v_child_table ILIKE '%node%' OR v_child_table ILIKE '%connec%' THEN
                                'Point'
                        ELSE
                            'LineString'
                        END;

    IF row_to_json(NEW.*)::text != '{}' THEN

        v_new_data := row_to_json(NEW.*);
        v_new_data := gw_fct_columns_to_labels(TG_TABLE_NAME::TEXT, v_new_data);
        v_geometry := ST_AsText(NEW.the_geom);
        v_new_data := jsonb_set(v_new_data::jsonb, '{the_geom}', to_jsonb(v_geometry))::json;

    END IF;

    IF row_to_json(OLD.*)::text != '{}' THEN

        v_old_data := row_to_json(OLD.*);
        v_old_data := gw_fct_columns_to_labels(TG_TABLE_NAME::TEXT, v_old_data);
        v_geometry := ST_AsText(OLD.the_geom);
        v_old_data := jsonb_set(v_old_data::jsonb, '{the_geom}', to_jsonb(v_geometry))::json;

    END IF;

    IF (TG_OP = 'INSERT') OR row_to_json(NEW.*)::text = row_to_json(OLD.*)::text THEN

        -- Build sql
        v_columns := string_agg(quote_ident(key), ', ') FROM json_each(v_new_data);
        v_values := string_agg(quote_literal(value), ', ') FROM json_each(v_new_data);

        v_sql := format('INSERT INTO temp_PARENT_SCHEMA_%I (%s) VALUES (%s)', v_child_table, v_columns, v_values);
        v_sql := REPLACE(regexp_replace(v_sql, '''(null|true|false|[0-9]+(\\.[0-9]+)?)''', '\1', 'g'), '"', '');

        INSERT INTO audit.log (schema, table_name, insert_by, action, new_value, query, sql, id_name, feature_id)
        VALUES (TG_TABLE_SCHEMA::TEXT, v_child_table, session_user::TEXT, 'I', v_new_data, current_query(), v_sql, v_feature_idname, v_feature_id);
        RETURN NEW;

    ELSIF (TG_OP = 'UPDATE') THEN

        -- Get different values between old and new json
        SELECT string_agg(quote_ident(n.key) || ' = ' || quote_literal(n.value), ', ')
        INTO v_sql FROM json_each(v_new_data) n
        LEFT JOIN json_each(v_old_data) o ON n.key = o.key
        WHERE n.value::text IS DISTINCT FROM o.value::text;

        IF v_sql IS NOT NULL THEN
            v_sql := format('UPDATE temp_PARENT_SCHEMA_%I SET %s WHERE %I = ''%L''', v_child_table, v_sql, v_feature_idname, v_feature_id);
            v_sql := REPLACE(regexp_replace(v_sql, '''(null|true|false|[0-9]+(\\.[0-9]+)?)''', '\1', 'g'), '"', '');
        END IF;

        INSERT INTO audit.log (schema, table_name, insert_by, action, old_value, new_value, query, sql, id_name, feature_id)
        VALUES (TG_TABLE_SCHEMA::TEXT, v_child_table, session_user::TEXT, 'U', v_old_data, v_new_data, current_query(), v_sql, v_feature_idname, v_feature_id);
        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN

        v_sql := format('DELETE FROM temp_PARENT_SCHEMA_%I WHERE %I = %L', v_child_table, v_feature_idname, v_feature_id);

        INSERT INTO audit.log (schema, table_name, insert_by, action, old_value, query, sql, id_name, feature_id)
        VALUES (TG_TABLE_SCHEMA::TEXT, v_child_table, session_user::TEXT, 'D', v_old_data, current_query(), v_sql, v_feature_idname, v_feature_id);
        RETURN OLD;

    END IF;


    RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
