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
    v_fields        JSON;
    v_record        SCHEMA_NAME.om_campaign_lot%ROWTYPE;
    v_existing_id   INTEGER;
    v_result        JSON;
    v_version       TEXT;
    v_field_key     TEXT;
    v_field_value   JSON;
    v_update_stmt   TEXT;
    v_set_clauses   TEXT := '';


BEGIN
    -- Set schema search path
    SET search_path = "SCHEMA_NAME", public;

    -- Extract the fields object from JSON
    v_fields := (p_data -> 'data' -> 'fields')::json;

    -- Convert the JSON fields to a typed record
    v_record := jsonb_populate_record(NULL::SCHEMA_NAME.om_campaign_lot, v_fields::jsonb);

    -- Check if the lot already exists
    SELECT lot_id INTO v_existing_id
    FROM om_campaign_lot
    WHERE lot_id = v_record.lot_id;

    IF v_existing_id IS NULL THEN
        -- INSERT new lot using dynamic field mapping
        INSERT INTO om_campaign_lot
        SELECT * FROM jsonb_populate_record(NULL::SCHEMA_NAME.om_campaign_lot, v_fields::jsonb)
        RETURNING lot_id INTO v_existing_id;

    ELSE
        -- UPDATE existing lot using dynamic SQL from the fields
        FOR v_field_key, v_field_value IN
            SELECT key, value FROM json_each(v_fields)
        LOOP
            -- Skip primary key from SET clause
            IF v_field_key != 'lot_id' THEN
                v_set_clauses := v_set_clauses || format('%I = %L, ', v_field_key, v_field_value::text);
            END IF;
        END LOOP;

        -- Trim final comma and build the UPDATE statement
        v_set_clauses := left(v_set_clauses, length(v_set_clauses) - 2);
        v_update_stmt := format('UPDATE SCHEMA_NAME.om_campaign_lot SET %s WHERE lot_id = %L', v_set_clauses, v_record.lot_id);

        -- Execute the dynamic UPDATE
        EXECUTE v_update_stmt;
    END IF;

    -- If workorder exists, update associated fields
    IF v_record.workorder_id IS NOT NULL THEN
        UPDATE SCHEMA_NAME.workorder
        SET
            observ = v_fields ->> 'observations',
            address = v_fields ->> 'adress',
            serie = v_fields ->> 'serie'
        WHERE workorder_id = v_record.workorder_id;
    END IF;

    -- Retrieve admin version if defined
    SELECT value INTO v_version
    FROM config_param_system
    WHERE parameter = 'admin_version';

    -- Build successful return JSON
    v_result := json_build_object(
        'status', 'Accepted',
        'message', format('Lot %s saved successfully', v_existing_id),
        'version', v_version,
        'body', json_build_object(
            'feature', json_build_object('id', v_existing_id),
            'data', json_build_object('info', 'Lot saved correctly')
        )
    );

    RETURN v_result;

-- Catch and return any unexpected errors
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
