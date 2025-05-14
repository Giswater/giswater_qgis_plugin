CREATE OR REPLACE FUNCTION cm.gw_fct_getlot(p_data json)
RETURNS json
LANGUAGE plpgsql
AS $function$
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

    -- Custom for lot types
    v_lot_mode text;
    v_formname text;
BEGIN
    -- Set search path
    SET search_path = "cm", public;

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
    v_id := (p_data -> 'feature' ->> 'id')::text;
    v_idname := (p_data -> 'feature' ->> 'idName')::text;
    v_tablename := (p_data -> 'feature' ->> 'tableName')::text;
    v_message := (p_data -> 'data' ->> 'message');

    -- Start form tabs
    v_formtabs := '[';

    -- Get dynamic fields for lot (similar to get_campaign)
    SELECT gw_fct_getformfieldscm(
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
                v_fields[array_index] := gw_fct_json_object_set_key_cm(aux_json, 'selectedId', COALESCE(v_fieldvalue, ''));
            ELSE
                v_fields[array_index] := gw_fct_json_object_set_key_cm(aux_json, 'value', COALESCE(v_fieldvalue, ''));
            END IF;
        END LOOP;

        v_formheader := CONCAT('Lot - ', v_id);

    ELSE
        -- If creating a new lot
        SELECT nextval('cm.om_campaign_lot_id_seq') INTO v_id;

        -- Set campaign_id to new ID
        FOR array_index IN array_lower(v_fields, 1)..array_upper(v_fields, 1) LOOP
            aux_json := v_fields[array_index];
            IF (aux_json ->> 'columnname') = 'campaign_id' THEN
                v_fields[array_index] := gw_fct_json_object_set_key_cm(aux_json, 'value', v_id::text);
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

    -- Control NULL's
    v_forminfo := COALESCE(v_forminfo, '{}');
    v_featureinfo := COALESCE(v_featureinfo, '{}');
    v_fields := COALESCE(v_fields, '{}');
    v_message := COALESCE(v_message, '{}');
    v_version := COALESCE(v_version, '{}');
    v_fields_json := COALESCE(v_fields_json, '{}');

    -- Create return JSON
    RETURN abr25_ws.gw_fct_json_create_return(('{"status":"Accepted", "message":'||v_message||', "version":' || v_version ||
      ',"body":{"form":' || v_forminfo ||
         ', "feature":'|| v_featureinfo ||
          ',"data":{"fields":' || v_fields_json ||'}'||
        '}'||
    '}')::json, 3388, null, null, null);

END;
$function$
;
