/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3444

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_getworkorder(p_data json)
  RETURNS json AS
$BODY$

DECLARE
    v_version       text;
    v_schemaname    text := 'cm';
    v_id            text;
    v_idname        text;
    v_columntype    text := 'integer';
    v_device        integer;
    v_tablename     text;
    v_fields        json[];
    v_fields_json   json;
    v_forminfo      json := '{}'::json;
    v_formheader    text;
    v_formtabs      text;
    v_tabaux        json;
    v_activedatatab boolean := TRUE;
    v_client        json;
    v_message       json;
    v_values        json;
    array_index     integer DEFAULT 0;
    v_fieldvalue    text;
    v_geometry      json := '{}'::json;
    aux_json        json;
    v_featureinfo   json;
    v_formname      text;
    v_prev_search_path text;
BEGIN
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', 'cm,public', true);

    EXECUTE
      'SELECT row_to_json(row) FROM (SELECT value FROM cm.config_param_system WHERE parameter=''admin_version'') row'
    INTO v_version;

    p_data := REPLACE(p_data::text, '"NULL"', 'null')::json;
    p_data := REPLACE(p_data::text, '"null"', 'null')::json;
    p_data := REPLACE(p_data::text, '"cm"', 'null')::json;

    v_client    := (p_data ->> 'client')::json;
    v_device    := (v_client ->> 'device')::int;
    v_id        := (p_data -> 'feature' ->> 'id')::text;
    v_idname    := (p_data -> 'feature' ->> 'idName')::text;
    v_tablename := (p_data -> 'feature' ->> 'tableName')::text;
    v_message   := (p_data -> 'data' ->> 'message')::json;

    v_formname := 'workorder';

    SELECT cm.gw_fct_cm_getformfields(
        v_formname,
        'form_feature',
        'data',
        NULL,NULL,NULL,NULL,
        'INSERT',
        NULL,
        v_device,
        NULL
    )
    INTO v_fields;

    IF v_id IS NOT NULL THEN
        EXECUTE FORMAT(
          'SELECT row_to_json(a) FROM (SELECT * FROM %I.%I WHERE %I = CAST($1 AS %s)) a',
          v_schemaname, v_tablename, v_idname, v_columntype
        )
        INTO v_values
        USING v_id;

        FOR array_index IN array_lower(v_fields,1)..array_upper(v_fields,1) LOOP
            aux_json     := v_fields[array_index];
            v_fieldvalue := v_values ->> (aux_json ->> 'columnname');

            IF (aux_json ->> 'widgettype') = 'combo' THEN
                v_fields[array_index] := gw_fct_cm_json_object_set_key(
                    aux_json, 'selectedId', COALESCE(v_fieldvalue,'')
                );
            ELSE
                v_fields[array_index] := gw_fct_cm_json_object_set_key(
                    aux_json, 'value', COALESCE(v_fieldvalue,'')
                );
            END IF;
        END LOOP;

        v_formheader := CONCAT('Workorder - ', v_id);
    ELSE
        SELECT nextval('cm.workorder_workorder_id_seq') INTO v_id;

        FOR array_index IN array_lower(v_fields,1)..array_upper(v_fields,1) LOOP
            aux_json := v_fields[array_index];
            IF (aux_json ->> 'columnname') = v_idname THEN
                v_fields[array_index] := gw_fct_cm_json_object_set_key(
                    aux_json, 'value', v_id::text
                );
            END IF;
        END LOOP;

        v_formheader := CONCAT('New Workorder - ', v_id);
    END IF;

    v_fields_json := array_to_json(v_fields);
    v_featureinfo := json_build_object(
        'featureType','workorder',
        'tableName', v_tablename,
        'idName',    v_idname,
        'id',        v_id
    );
    v_formtabs   := '[' || v_tabaux::text || ']';
    v_forminfo   := json_build_object('formName','Generic','template','info_generic');

    --Control NULL's
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_featureinfo := COALESCE(v_featureinfo, '{}');
	v_fields := COALESCE(v_fields, '{}');
	v_message := COALESCE(v_message, '{}');
	v_version := COALESCE(v_version, '{}');
	v_fields_json := COALESCE(v_fields_json, '{}');

    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN PARENT_SCHEMA.gw_fct_json_create_return(
      (
        '{"status":"Accepted",'
       ||'"message":'||v_message||','
       ||'"version":'||v_version||','
       ||'"body":{"form":'||v_forminfo
       ||',"feature":'||v_featureinfo
       ||',"data":{"fields":'||v_fields_json||'}}}'
      )::json,
      3388, null, null, null
    );
END;

$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
