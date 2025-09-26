/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 1140

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_element() RETURNS trigger AS $BODY$
DECLARE
    feature_type text;
    feature_column text;
    element_table text;
    v_sql_insert text;
    v_sql_delete text;
    v_new_value int;
    v_old_value int;

    v_new_data jsonb;
    feature_uuid_column text;
    feature_uuid_value uuid;
    v_feature_id int;

    v_state int;
    v_state_type int;
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    feature_type := TG_ARGV[0];
    v_new_data := to_jsonb(NEW);
    element_table := 'element_x_'||feature_type;
    feature_column := feature_type||'_id';
    feature_uuid_column := feature_type||'_uuid';
    feature_uuid_value := v_new_data->>feature_uuid_column;

    v_sql_insert := 'INSERT INTO '||element_table||' (element_id, '||feature_column||') VALUES ($1, $2)';
    v_sql_delete := 'DELETE FROM '||element_table||' WHERE element_id = $1 AND '||feature_column||' = $2';

    -- i want to print all new. values
    RAISE NOTICE 'NEW: %', NEW;

    IF TG_OP = 'INSERT' THEN

        -- State
		IF (NEW.state IS NULL) THEN
			v_state := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_state_vdefault' AND "cur_user"="current_user"());
		END IF;

		-- State type
		IF (NEW.state_type IS NULL) THEN
			v_state_type := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_statetype_1_vdefault' AND "cur_user"="current_user"());
		END IF;

        INSERT INTO element (elementcat_id, num_elements, observ, state, state_type)
        VALUES (NEW.elementcat_id, NEW.num_elements, NEW.observ, v_state, v_state_type) RETURNING element_id INTO NEW.element_id;

        IF feature_uuid_value IS NOT NULL THEN
            EXECUTE 'SELECT '||feature_column||' FROM '||feature_type||' WHERE uuid = $1'
            INTO v_feature_id
            USING feature_uuid_value;
        END IF;

        IF v_feature_id IS NOT NULL THEN
            EXECUTE 'INSERT INTO '||element_table||' ('||feature_column||', element_id, '||feature_uuid_column||') VALUES ($1, $2, $3)'
            USING v_feature_id, NEW.element_id, feature_uuid_value;

            EXECUTE 'UPDATE element SET 
                expl_id = n.expl_id,
                sector_id = n.sector_id,
                muni_id = n.muni_id
            FROM '||feature_type||' n WHERE n.'||feature_column||' = $1
            AND element.element_id = $2'
            USING v_feature_id, NEW.element_id;
        ELSE
            EXECUTE 'SELECT ($1).' || quote_ident(feature_column)
                INTO v_new_value
                USING NEW;

            EXECUTE v_sql_insert USING NEW.element_id, v_new_value;
        END IF;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        UPDATE element SET elementcat_id = NEW.elementcat_id, num_elements = NEW.num_elements, observ = NEW.observ
        WHERE element_id = OLD.element_id;

        EXECUTE 'SELECT ($1).' || quote_ident(feature_column)
            INTO v_new_value
            USING NEW;

        EXECUTE 'SELECT ($1).' || quote_ident(feature_column)
            INTO v_old_value
            USING OLD;

        IF v_new_value <> v_old_value THEN
            EXECUTE v_sql_delete USING NEW.element_id, v_old_value;
            EXECUTE v_sql_insert USING NEW.element_id, v_new_value;
        ELSE
            -- nothing to do
        END IF;

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN

        EXECUTE 'SELECT ($1).' || quote_ident(feature_column)
            INTO v_old_value
            USING OLD;

        EXECUTE v_sql_delete USING OLD.element_id, v_old_value;

        RETURN NULL;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
