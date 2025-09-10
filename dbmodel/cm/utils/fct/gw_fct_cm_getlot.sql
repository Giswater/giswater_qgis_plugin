/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3440

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_getlot(p_data json)
  RETURNS json AS
$BODY$

DECLARE
    v_version text;
    v_schemaname text := 'cm';
    v_id text;
    v_idname text;
    v_columntype text := 'integer';
    v_device integer;
    v_tablename text;
    v_fields json[];
    v_fields_json json;
    v_forminfo json := '{}'::json;
    v_formheader text;
    v_formtabs text;
    v_tabaux json;
    v_activedatatab boolean := TRUE;
    v_client json;
    v_message json;
    v_values json;
    array_index integer DEFAULT 0;
    v_fieldvalue text;
    v_geometry json := '{}'::json;
    aux_json json;
    v_tab record;
    v_featureinfo JSON;
    query_value text;

    -- Custom for lot types
    v_lot_mode text;
    v_formname text;
    v_input json;
    v_campaign_id text;
    v_prev_search_path text;
BEGIN
    -- Set search path transaction-locally
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', 'cm,public', true);

    -- Get version (similar to campaign version)
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM cm.config_param_system WHERE parameter=''admin_version'') row'
    INTO v_version;

    -- Clean JSON null formats
    p_data := REPLACE(p_data::text, '"NULL"', 'null');
    p_data := REPLACE(p_data::text, '"null"', 'null');
    p_data := REPLACE(p_data::text, '"cm"', 'null');

    -- Get client + feature inputs
    v_client := (p_data ->> 'client')::json;
    v_device := (v_client ->> 'device')::int;
    v_input := (p_data -> 'feature')::json;
    v_id := v_input ->> 'id';
    v_idname := v_input ->> 'idName';
    v_tablename := v_input ->> 'tableName';
    v_campaign_id := v_input ->> 'lot_id';
    v_message := (p_data -> 'data' ->> 'message');
    v_formname := 'lot';

    -- Start form tabs
    v_formtabs := '[';

    -- Get dynamic fields for lot (similar to get_campaign)
    SELECT gw_fct_cm_getformfields(
        v_formname,
        'form_feature',
        'data',
        NULL, NULL, NULL, NULL,
        'INSERT',
        NULL,
        v_device,
        NULL
    )
    INTO v_fields;

    -- If editing an existing lot
    IF v_id IS NOT NULL THEN
        -- Use dynamic SQL to get the lot data
        EXECUTE FORMAT(
            'SELECT row_to_json(a) FROM (SELECT * FROM cm.%I WHERE %I = CAST($1 AS %s)) a',
            v_tablename, v_idname, v_columntype
        )
        INTO v_values USING v_id;

        -- Loop through the fields and update them
        FOR array_index IN array_lower(v_fields, 1)..array_upper(v_fields, 1) LOOP
            aux_json := v_fields[array_index];
            v_fieldvalue := v_values ->> (aux_json ->> 'columnname');

            -- Update combo widget fields
            IF (aux_json ->> 'widgettype') = 'combo' THEN
                v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'selectedId', COALESCE(v_fieldvalue, ''));
            ELSE
                v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'value', COALESCE(v_fieldvalue, ''));
            END IF;
        END LOOP;

        v_formheader := CONCAT('Lot - ', v_id);

    ELSE
        -- If creating a new lot
        SELECT COALESCE(max(lot_id),0) + 1 FROM cm.om_campaign_lot INTO v_id;

        -- Loop through the fields and assign campaign_id if passed
        FOR array_index IN array_lower(v_fields, 1)..array_upper(v_fields, 1) LOOP
            aux_json := v_fields[array_index];
            IF (aux_json ->> 'columnname') = 'campaign_id' AND v_campaign_id IS NOT NULL THEN
                v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'value', v_campaign_id);
            END IF;
            IF (aux_json ->> 'widgettype') = 'combo' THEN
                IF (aux_json->>'widgetcontrols') IS NOT NULL THEN
					IF ((aux_json->>'widgetcontrols')::jsonb ? 'vdefault_value') THEN
						IF (aux_json->>'widgetcontrols')::json->>'vdefault_value'::text in  (select a from json_array_elements_text(json_extract_path(v_fields[array_index],'comboIds'))a) THEN
                            v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'selectedId', (aux_json->>'widgetcontrols')::json->>'vdefault_value');
						END IF;
					ELSEIF ((aux_json->>'widgetcontrols')::jsonb ? 'vdefault_querytext') THEN
						EXECUTE (aux_json->>'widgetcontrols')::json->>'vdefault_querytext' INTO query_value;
						IF query_value in  (select a from json_array_elements_text(json_extract_path(v_fields[array_index],'comboIds'))a) THEN
						    v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'selectedId', query_value);
						END iF;
					END IF;
				END IF;
            ELSE
                IF (aux_json->>'widgetcontrols') IS NOT NULL THEN
				    IF ((aux_json->>'widgetcontrols')::jsonb ? 'vdefault_value') THEN
					    v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'value', (aux_json->>'widgetcontrols')::json->>'vdefault_value');
				    ELSEIF ((aux_json->>'widgetcontrols')::jsonb ? 'vdefault_querytext') THEN
					    EXECUTE (aux_json->>'widgetcontrols')::json->>'vdefault_querytext' INTO query_value;
					    v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'value', query_value);
				    END IF;
			    END IF;
            END IF;
        END LOOP;

        v_formheader := CONCAT('New Lot - ', v_id);
    END IF;

    -- Convert fields to JSON for return
    v_fields_json := array_to_json(v_fields);
    v_featureinfo := json_build_object(
        'featureType', 'lot',
        'tableName', v_tablename,
        'idName', v_idname,
        'id', v_id
    );
    v_formtabs := v_formtabs || v_tabaux::text || ']';
    v_forminfo := json_build_object('formName','Generic','template','info_generic');

    -- Control NULLs
    v_forminfo := COALESCE(v_forminfo, '{}');
    v_featureinfo := COALESCE(v_featureinfo, '{}');
    v_fields := COALESCE(v_fields, '{}');
    v_message := COALESCE(v_message, '{}');
    v_version := COALESCE(v_version, '{}');
    v_fields_json := COALESCE(v_fields_json, '{}');

    -- Create return JSON
    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN PARENT_SCHEMA.gw_fct_json_create_return(('{"status":"Accepted", "message":'||v_message||', "version":' || v_version ||
      ',"body":{"form":' || v_forminfo ||
         ', "feature":'|| v_featureinfo ||
          ',"data":{"fields":' || v_fields_json ||'}'||
        '}'||
    '}')::json, 3388, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
