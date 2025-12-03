/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3388

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getcampaign(p_data json)
  RETURNS json AS
$BODY$

DECLARE
	v_version text;
	v_schemaname text := 'SCHEMA_NAME';
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

	-- Custom for campaign types
	v_campaign_mode text;
	v_formname text;
BEGIN
	-- Set search path
	SET search_path = "SCHEMA_NAME", public;

	-- Get version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM PARENT_SCHEMA.config_param_system WHERE parameter=''admin_version'') row'
	INTO v_version;

	-- Clean JSON null formats
	p_data := REPLACE(p_data::text, '"NULL"', 'null');
	p_data := REPLACE(p_data::text, '"null"', 'null');
	p_data := REPLACE(p_data::text, '"SCHEMA_NAME"', 'null');

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
	ELSE
		v_formname := 'campaign_review';
	END IF;

	-- Start form tabs
	v_formtabs := '[';

	-- Get dynamic fields
	SELECT PARENT_SCHEMA.gw_fct_getformfields(
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
				v_fields[array_index] := gw_fct_json_object_set_key(aux_json, 'selectedId', COALESCE(v_fieldvalue, ''));
			ELSE
				v_fields[array_index] := gw_fct_json_object_set_key(aux_json, 'value', COALESCE(v_fieldvalue, ''));
			END IF;
		END LOOP;

		v_formheader := CONCAT('Campaign - ', v_id);

	ELSE
		-- If creating a new campaign
		SELECT nextval('SCHEMA_NAME.om_campaign_id_seq') INTO v_id;

		FOR array_index IN array_lower(v_fields, 1)..array_upper(v_fields, 1) LOOP
		    aux_json := v_fields[array_index];
		    IF (aux_json ->> 'columnname') = 'id' THEN
		        v_fields[array_index] := gw_fct_json_object_set_key(aux_json, 'value', v_id::text);
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
	v_version := COALESCE(v_version, '');
	v_fields_json := COALESCE(v_fields_json, '{}');

    -- Create return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":'||v_message||', "version":' || v_version ||
      ',"body":{"form":' || v_forminfo ||
	     ', "feature":'|| v_featureinfo ||
	      ',"data":{"fields":' || v_fields_json ||'}'||
		'}'||
	'}')::json, 3388, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
