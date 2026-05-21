/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- FUNCTION CODE: audit.gw_fct_columns_to_labels(text, json);

CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_fct_columns_to_labels(v_formname text, p_data json)
  RETURNS json AS 
$BODY$
DECLARE
    v_key TEXT;
    v_value TEXT;
    v_label TEXT;
    v_formtype TEXT := 'form_feature';
    v_tabname TEXT;
    v_formname_array TEXT[];
    v_result JSONB := '{}'::jsonb;
BEGIN
    -- Determine tab name
    v_formname_array := string_to_array(v_formname, '_');
    IF v_formname_array[1] = 'epa' THEN
        v_tabname := 'tab_epa';
    ELSE
        v_tabname := 'tab_data';
    END IF;

    -- Loop over each key-value pair in input JSON
    FOR v_key, v_value IN
        SELECT key, value FROM json_each_text(p_data)
    LOOP
        -- Fetch label for the column
        EXECUTE format(
            'SELECT label FROM config_form_fields 
             WHERE formname = %L AND formtype = %L AND tabname = %L AND columnname = %L',
             v_formname, v_formtype, v_tabname, v_key)
        INTO v_label;

        -- If no label found, keep original key
        IF v_label IS NULL THEN
            v_label := v_key;
        END IF;

        -- Build resulting JSONB with new key (label)
        v_result := v_result || jsonb_build_object(v_label, v_value);
    END LOOP;

    RETURN v_result::json;
END;
$BODY$
LANGUAGE plpgsql;