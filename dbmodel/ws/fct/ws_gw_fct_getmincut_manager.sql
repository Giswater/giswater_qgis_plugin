/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3208

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getmincut_manager(p_data json)
RETURNS json AS
$BODY$

DECLARE
  aux_json json;
  array_index integer DEFAULT 0;
  field_value character varying;
  v_querystring text;
  v_debug_vars json;
  v_debug json;
  v_msgerr json;
  v_querytext text;
  v_selected_id text;
  v_selected_idval text;
  v_current_id text;
  v_new_id text;
  v_widgetcontrols json;
  v_values_array json;
  v_widgetvalues json;

  v_fields_array json[];
  v_fieldsjson jsonb := '[]';
  v_version text;
  v_response json;
  v_error_context text;

BEGIN
  -- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	  -- Get api version
  SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

  SELECT gw_fct_getformfields(
    'mincut_manager',
    'form_mincut',
    'tab_none',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  ) INTO v_fields_array;

 -- looping the array setting values and widgetcontrols
		FOREACH aux_json IN ARRAY v_fields_array
		LOOP
			array_index := array_index + 1;

			field_value := (v_values_array->>(aux_json->>'columnname'));

			-- setting values
			IF (aux_json->>'widgettype')='combo' THEN
				--check if selected id is on combo list
				IF field_value::text not in  (select a from json_array_elements_text(json_extract_path(v_fields_array[array_index],'comboIds'))a) AND field_value IS NOT NULL then
					--find dvquerytext for combo
					v_querystring = concat('SELECT dv_querytext FROM config_form_fields WHERE 
					columnname::text = (',quote_literal(v_fields_array[array_index]),'::json->>''columnname'')::text
					and formname = ',quote_literal(p_table_id),';');
					v_debug_vars := json_build_object('v_fields_array[array_index]', v_fields_array[array_index], 'p_table_id', p_table_id);
					v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getfeatureupsert', 'flag', 100);
					SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
					EXECUTE v_querystring INTO v_querytext;

					v_querytext = replace(lower(v_querytext),'active is true','1=1');

					--select values for missing id
					v_querystring = concat('SELECT id, idval FROM (',v_querytext,')a
					WHERE id::text = ',quote_literal(field_value),'');
					v_debug_vars := json_build_object('v_querytext', v_querytext, 'field_value', field_value);
					v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getfeatureupsert', 'flag', 110);
					SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
					EXECUTE v_querystring INTO v_selected_id,v_selected_idval;

					v_current_id =json_extract_path_text(v_fields_array[array_index],'comboIds');

					IF v_current_id='[]' THEN
						--case when list is empty
						EXECUTE 'SELECT  array_to_json(''{'||v_selected_id||'}''::text[])'
						INTO v_new_id;
						v_fields_array[array_index] = gw_fct_json_object_set_key(v_fields_array[array_index],'comboIds',v_new_id::json);
						EXECUTE 'SELECT  array_to_json(''{'||v_selected_idval||'}''::text[])'
						INTO v_new_id;
						v_fields_array[array_index] = gw_fct_json_object_set_key(v_fields_array[array_index],'comboNames',v_new_id::json);
					ELSE

						select string_agg(quote_ident(a),',') into v_new_id from json_array_elements_text(v_current_id::json) a ;
						--remove current combo Ids from return json
						v_fields_array[array_index] = v_fields_array[array_index]::jsonb - 'comboIds'::text;
						v_new_id = '['||v_new_id || ','|| quote_ident(v_selected_id)||']';
						--add new combo Ids to return json
						v_fields_array[array_index] = gw_fct_json_object_set_key(v_fields_array[array_index],'comboIds',v_new_id::json);

						v_current_id =json_extract_path_text(v_fields_array[array_index],'comboNames');
						select string_agg(quote_ident(a),',') into v_new_id from json_array_elements_text(v_current_id::json) a ;
						--remove current combo names from return json
						v_fields_array[array_index] = v_fields_array[array_index]::jsonb - 'comboNames'::text;
						v_new_id = '['||v_new_id || ','|| quote_ident(v_selected_idval)||']';
						--add new combo names to return json
						v_fields_array[array_index] = gw_fct_json_object_set_key(v_fields_array[array_index],'comboNames',v_new_id::json);
					END IF;
				END IF;
				v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'selectedId', COALESCE(field_value, ''));
			ELSIF (aux_json->>'widgettype') !='button' THEN
				v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'value', COALESCE(field_value, ''));
			END IF;

			-- setting widgetcontrols
			IF (aux_json->>'datatype')='double' OR (aux_json->>'datatype')='integer' OR (aux_json->>'datatype')='numeric' THEN
				IF v_widgetvalues IS NOT NULL THEN
					v_widgetcontrols = gw_fct_json_object_set_key ((aux_json->>'widgetcontrols')::json, 'maxMinValues' ,(v_widgetvalues->>(aux_json->>'columnname'))::json);
					v_fields_array[array_index] := gw_fct_json_object_set_key (v_fields_array[array_index], 'widgetcontrols', v_widgetcontrols);
				END IF;
			END IF;
		END LOOP;

  v_fieldsjson := to_json(v_fields_array);

  v_response := '{
    "status": "Accepted",
    "version": "'|| v_version ||'",
    "body": {
      "data": {
        "fields": '|| v_fieldsjson ||'
      },
	  "feature": {
		"idName": "",
		"id": ""
      }
    }
  }';
  RETURN v_response;

  -- Exception handling
    EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
    RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;