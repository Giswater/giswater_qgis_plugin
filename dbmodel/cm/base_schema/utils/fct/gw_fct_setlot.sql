/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: NEW CODE FOR THIS FUNCTIN

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setlot(p_data JSON)
  RETURNS json AS
$BODY$

DECLARE
    v_fields        json;
    v_record        SCHEMA_NAME.om_campaign_lot%ROWTYPE;
    v_existing_id   integer;
    v_result        json;
    v_version       text;
    v_update_fields text;
    v_update_values text;
BEGIN
    SET search_path = "SCHEMA_NAME", public;

    -- Extract fields from JSON
    v_fields := (p_data -> 'data' -> 'fields')::json;

    -- Convert the JSON fields to a typed record
    v_record := jsonb_populate_record(NULL::SCHEMA_NAME.om_campaign_lot, v_fields::jsonb);

    -- Check if the lot already exists
    SELECT lot_id INTO v_existing_id
    FROM om_campaign_lot
    WHERE lot_id = v_record.lot_id;

    IF v_existing_id IS NULL THEN
        -- INSERT new lot using jsonb_populate_record for dynamic mapping
        INSERT INTO om_campaign_lot
        SELECT * FROM jsonb_populate_record(NULL::SCHEMA_NAME.om_campaign_lot, v_fields::jsonb)
        RETURNING lot_id INTO v_existing_id;

    ELSE
        -- Dynamic update using jsonb_populate_record, updating all columns except lot_id
        -- Get all column names except 'lot_id'
        SELECT string_agg(quote_ident(attname), ', ')
        INTO v_update_fields
        FROM pg_attribute
        WHERE attrelid = 'SCHEMA_NAME.om_campaign_lot'::regclass
          AND attnum > 0
          AND NOT attisdropped
          AND attname <> 'lot_id';

        -- Build dynamic SQL to update all fields except PK in a single assignment
        EXECUTE format(
            'UPDATE SCHEMA_NAME.om_campaign_lot SET (%s) = (SELECT %s FROM jsonb_populate_record(NULL::SCHEMA_NAME.om_campaign_lot, $1::jsonb)) WHERE lot_id = $2',
            v_update_fields,
            v_update_fields
        )
        USING v_fields::jsonb, v_record.lot_id;
    END IF;

    -- Retrieve admin version if defined
    SELECT value INTO v_version
    FROM config_param_system
    WHERE parameter = 'admin_version';

    -- Update selector_lot for this user
    INSERT INTO selector_lot (lot_id, cur_user)
    VALUES (COALESCE(v_existing_id, v_record.lot_id), current_user)
    ON CONFLICT DO NOTHING;

    -- Build successful return JSON
    v_result := json_build_object(
        'status', 'Accepted',
        'message', format('Lot %s saved successfully', COALESCE(v_existing_id, v_record.lot_id)),
        'version', v_version,
        'body', json_build_object(
            'feature', json_build_object('id', COALESCE(v_existing_id, v_record.lot_id)),
            'data', json_build_object('info', 'Lot saved correctly')
        )
    );

    RETURN v_result;

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'status', 'Failed',
        'message', json_build_object('level', 3, 'text', SQLERRM),
        'SQLSTATE', SQLSTATE
    );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
