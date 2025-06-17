/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3480

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_lot_x_feature()
RETURNS trigger
LANGUAGE plpgsql
AS $function$
DECLARE
    v_feature_type TEXT := TG_ARGV[0];
    v_feature_id_column TEXT;
    v_feature_column TEXT;
    v_view_name TEXT;
    v_feature_child_type TEXT;
    v_querytext TEXT;
    v_feature_id_value INTEGER;
    v_lot_id INTEGER;
    v_row RECORD;
    v_dest_table_name TEXT;
    v_source_columns TEXT;
    v_dest_columns TEXT;
BEGIN
    v_feature_id_column := v_feature_type || '_id';
    v_feature_column := v_feature_type || '_type';

    -- Use NEW for INSERT, OLD for DELETE
    IF TG_OP = 'INSERT' THEN
        v_lot_id := NEW.lot_id;
        EXECUTE format('SELECT ($1).%I', v_feature_id_column) INTO v_feature_id_value USING NEW;
    ELSIF TG_OP = 'DELETE' THEN
        v_lot_id := OLD.lot_id;
        EXECUTE format('SELECT ($1).%I', v_feature_id_column) INTO v_feature_id_value USING OLD;
    ELSE
        RETURN NULL;
    END IF;

    -- Get the feature child type
    v_querytext := format(
        'SELECT c.%s_type ' ||
        'FROM PARENT_SCHEMA.%s p ' ||
        'JOIN PARENT_SCHEMA.cat_%s c ON p.%scat_id = c.id ' ||
        'WHERE p.%s_id = $1',
        v_feature_type, v_feature_type, v_feature_type, v_feature_type, v_feature_type
    );
    EXECUTE v_querytext INTO v_feature_child_type USING v_feature_id_value;

    IF v_feature_child_type IS NULL THEN
        IF TG_OP = 'INSERT' THEN RETURN NEW;
        ELSE RETURN OLD;
        END IF;
    END IF;

    -- Compose view/table name
    v_view_name := format('ve_%s_%s', v_feature_type, lower(v_feature_child_type));
    v_dest_table_name := format('PARENT_SCHEMA_%s', lower(v_feature_child_type));

    IF TG_OP = 'INSERT' THEN
        -- Get columns of the specific view, excluding the_geom
        SELECT string_agg(quote_ident(column_name), ', '), string_agg('vn.' || quote_ident(column_name), ', ')
        INTO v_dest_columns, v_source_columns
        FROM information_schema.columns
        WHERE table_schema = 'PARENT_SCHEMA'
          AND table_name = v_view_name
          AND column_name <> 'the_geom';

        IF v_dest_columns IS NULL THEN
            RETURN NEW;
        END IF;

        v_querytext := format(
            'INSERT INTO cm.%I (id, lot_id, %s) ' ||
            'SELECT nextval(''cm.%I_id_seq''::regclass), v.lot_id, %s FROM cm.om_campaign_lot_x_%s v JOIN PARENT_SCHEMA.%I vn ON vn.%I::integer = v.%I WHERE v.lot_id = $1 AND v.%I = $2',
            v_dest_table_name,
            v_dest_columns,
            v_dest_table_name,
            v_source_columns,
            v_feature_type,
            v_view_name,
            v_feature_id_column,
            v_feature_id_column,
            v_feature_id_column
        );
        EXECUTE v_querytext USING v_lot_id, v_feature_id_value;
    ELSIF TG_OP = 'DELETE' THEN
        v_querytext := format(
            'DELETE FROM cm.%I WHERE lot_id = $1 AND %I = $2',
            v_dest_table_name,
            v_feature_id_column
        );
        EXECUTE v_querytext USING v_lot_id, v_feature_id_value;
    END IF;

    -- Return correct row type depending on operation
    IF TG_OP = 'INSERT' THEN
        RETURN NEW;
    ELSE
        RETURN OLD;
    END IF;
END;
$function$;
