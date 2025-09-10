/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3460

CREATE OR REPLACE FUNCTION cm_audit.gw_trg_cm_log() RETURNS trigger AS $$
DECLARE
    v_feature_type TEXT := TG_ARGV[0];
    v_mission_type TEXT := TG_ARGV[1];
    v_mission_id_column TEXT := TG_ARGV[2];

    v_feature_id_column TEXT;
    v_feature_id_value INTEGER;
    v_mission_id_value INTEGER;

    old_json jsonb := '{}'::jsonb;
    new_json jsonb := '{}'::jsonb;
    col text;
    v_prev_search_path text;
BEGIN
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', 'cm_audit, public', true);

    v_feature_id_column := v_feature_type || '_id';

    -- Get mission_id from the correct column
    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        EXECUTE format('SELECT ($1).%I, ($1).%I', v_feature_id_column, v_mission_id_column) INTO v_feature_id_value, v_mission_id_value USING NEW;
    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE format('SELECT ($1).%I, ($1).%I', v_feature_id_column, v_mission_id_column) INTO v_feature_id_value, v_mission_id_value USING OLD;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        -- Loop through each column and compare OLD and NEW
        FOR col IN SELECT column_name FROM information_schema.columns WHERE table_name = TG_TABLE_NAME AND table_schema = TG_TABLE_SCHEMA
        LOOP
            IF to_jsonb(OLD) -> col IS DISTINCT FROM to_jsonb(NEW) -> col THEN
                old_json := old_json || jsonb_build_object(col, to_jsonb(OLD) -> col);
                new_json := new_json || jsonb_build_object(col, to_jsonb(NEW) -> col);
            END IF;
        END LOOP;
        IF old_json = '{}'::jsonb THEN
            PERFORM set_config('search_path', v_prev_search_path, true);
            RETURN NULL; -- No changes, do not log
        END IF;

        INSERT INTO cm_audit.log(table_name, mission_type, mission_id, feature_id, feature_type, "action", sql, old_value, new_value, insert_by, insert_at)
        VALUES (TG_TABLE_NAME, v_mission_type, v_mission_id_value, v_feature_id_value, v_feature_type, TG_OP, current_query(), old_json, new_json, current_user, clock_timestamp());
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;

    ELSIF TG_OP = 'INSERT' THEN
        new_json := to_jsonb(NEW);
        INSERT INTO cm_audit.log(table_name, mission_type, mission_id, feature_id, feature_type, "action", sql, old_value, new_value, insert_by, insert_at)
        VALUES (TG_TABLE_NAME, v_mission_type, v_mission_id_value, v_feature_id_value, v_feature_type, TG_OP, current_query(), NULL, new_json, current_user, clock_timestamp());
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        old_json := to_jsonb(OLD);
        INSERT INTO cm_audit.log(table_name, mission_type, mission_id, feature_id, feature_type, "action", sql, old_value, new_value, insert_by, insert_at)
        VALUES (TG_TABLE_NAME, v_mission_type, v_mission_id_value, v_feature_id_value, v_feature_type, TG_OP, current_query(), old_json, NULL, current_user, clock_timestamp());
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN OLD;
    END IF;

    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN NULL;
EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('search_path', v_prev_search_path, true);
    RAISE;
END;
$$ LANGUAGE plpgsql;