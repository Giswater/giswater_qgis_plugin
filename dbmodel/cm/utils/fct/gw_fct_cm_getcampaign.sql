/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3432

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_getcampaign(p_data json)
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

	-- Custom for campaign types
	v_campaign_mode text;
	v_formname text;
	v_prev_search_path text;
BEGIN
	-- Set search path transaction-locally
	v_prev_search_path := current_setting('search_path');
	PERFORM set_config('search_path', 'cm,public', true);

	-- Get version
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

	-- Get campaign_mode (review or visit)
	v_campaign_mode := COALESCE(p_data -> 'feature' ->> 'campaign_mode', 'review');

	-- Set formname based on mode
	IF v_campaign_mode = 'visit' THEN
		v_formname := 'campaign_visit';
	ELSEIF v_campaign_mode = 'inventory' THEN
		v_formname := 'campaign_inventory';
	ELSE
		v_formname := 'campaign_review';
	END IF;

	-- Start form tabs
	v_formtabs := '[';

	-- Get dynamic fields
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

	-- If editing an existing campaign
	IF v_id IS NOT NULL THEN
		EXECUTE FORMAT(
			'SELECT row_to_json(a) FROM (SELECT * FROM cm.%I WHERE %I = CAST($1 AS %s)) a',
			v_tablename, v_idname, v_columntype
		)
		INTO v_values USING v_id;

		FOR array_index IN array_lower(v_fields, 1)..array_upper(v_fields, 1) LOOP
			aux_json := v_fields[array_index];
			v_fieldvalue := v_values ->> (aux_json ->> 'columnname');

			IF (aux_json ->> 'widgettype') = 'combo' THEN
				-- Special handling for reviewclass_id
				IF (aux_json ->> 'columnname') = 'reviewclass_id' THEN
					SELECT reviewclass_id::text INTO v_fieldvalue FROM om_campaign_review WHERE campaign_id = v_id::integer;
				END IF;
				v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'selectedId', COALESCE(v_fieldvalue, ''));
			ELSE
				v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'value', COALESCE(v_fieldvalue, ''));
			END IF;
		END LOOP;

		v_formheader := CONCAT('Campaign - ', v_id);

	ELSE
		-- If creating a new campaign
		SELECT COALESCE(max(campaign_id),0) + 1 FROM cm.om_campaign INTO v_id;

		FOR array_index IN array_lower(v_fields, 1)..array_upper(v_fields, 1) LOOP
		    aux_json := v_fields[array_index];
		    IF (aux_json ->> 'columnname') = 'campaign_id' THEN
		        v_fields[array_index] := gw_fct_cm_json_object_set_key(aux_json, 'value', v_id::text);
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

		v_formheader := CONCAT('New Campaign - ', v_id);
	END IF;

	-- Convert fields to JSON
	v_fields_json := array_to_json(v_fields);
	v_featureinfo := json_build_object(
	    'featureType', 'campaign',
	    'tableName', v_tablename,
	    'idName', v_idname,
	    'id', v_id
	);
	v_formtabs := v_formtabs || v_tabaux::text || ']';
	v_forminfo := json_build_object('formName','Generic','template','info_generic');

	--Control NULL's
	v_forminfo := COALESCE(v_forminfo, '{}');
	v_featureinfo := COALESCE(v_featureinfo, '{}');
	v_fields := COALESCE(v_fields, '{}');
	v_message := COALESCE(v_message, '{}');
	v_version := COALESCE(v_version, '{}');
	v_fields_json := COALESCE(v_fields_json, '{}');

    -- Create return
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
