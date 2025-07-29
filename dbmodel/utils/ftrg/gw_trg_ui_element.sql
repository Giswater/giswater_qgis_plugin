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
    v_new_value text;
    v_old_value text;
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    feature_type := TG_ARGV[0];
    element_table := 'element_x_'||feature_type;
    feature_column := feature_type||'_id';

    v_sql_insert := 'INSERT INTO '||element_table||' (element_id, '||feature_column||') VALUES ($1, $2)';
    v_sql_delete := 'DELETE FROM '||element_table||' WHERE element_id = $1 AND '||feature_column||'::text = $2';

    -- i want to print all new. values
    RAISE NOTICE 'NEW: %', NEW;

    IF TG_OP = 'INSERT' THEN

        EXECUTE 'SELECT ($1).' || quote_ident(feature_column)
            INTO v_new_value
            USING NEW;

        EXECUTE v_sql_insert USING NEW.element_id, v_new_value;

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

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
