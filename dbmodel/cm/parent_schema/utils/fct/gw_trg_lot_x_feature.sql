/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: NEW CODE FOR THIS FUNCTIN

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature()
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
BEGIN
    v_feature_id_column := v_feature_type || '_id';
    v_feature_column := v_feature_type || '_type';
   
   	EXECUTE format('SELECT ($1).%I', v_feature_id_column)
    INTO v_feature_id_value
    USING NEW;
   

    v_querytext := format(
        'SELECT %I, %I FROM SCHEMA_NAME.ve_PARENT_SCHEMA_lot_%s WHERE lot_id = $1 AND %I = $2',
        v_feature_column,
        v_feature_id_column,
        v_feature_type,
        v_feature_id_column
    );

    EXECUTE v_querytext
    INTO v_feature_child_type
    USING NEW.lot_id, v_feature_id_value;

    -- Compose the view name (be careful with naming conventions)
    v_view_name := format('ve_%s_%s', v_feature_type, lower(v_feature_child_type));

    v_querytext := format(
        'INSERT INTO SCHEMA_NAME.PARENT_SCHEMA_%I SELECT v.lot_id, vn.* FROM SCHEMA_NAME.ve_PARENT_SCHEMA_lot_%s v JOIN PARENT_SCHEMA.%I vn ON vn.node_id = v.node_id  WHERE v.lot_id = $1 AND v.%I = $2',
        lower(v_feature_child_type),
        v_feature_type,
        v_view_name,
        v_feature_id_column
    );

    -- Execute the insert
    EXECUTE v_querytext
    USING NEW.lot_id, v_feature_id_value;

    RETURN NEW;
END;
$function$;
