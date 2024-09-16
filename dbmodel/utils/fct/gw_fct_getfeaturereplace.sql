/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3324

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeaturereplace(p_data json)
RETURNS json AS
$BODY$

/*
-- Button GwFeatureTypeChangeButton

SELECT gw_fct_getfeaturereplace($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
"form":{},
"feature":{"tableName":"v_edit_node", "id":"1058"},
"data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$);

fid = 216

*/

DECLARE
    v_device integer;
	v_current_featurecat_id text;
	v_feature_type text;
	v_new_featurecat_id_default text;
	v_feature_id text;
	v_table_name text;
	v_form text;
	v_addparam json;
	v_featurecat_ids text[];
	v_catalogs_ids text[];
	v_fluids text[];
	v_locations text[];
	v_categories text[];
	v_functions text[];
	v_sql text;
	v_layouts text[];
	v_layout text;
	v_tiled boolean=false;
	v_version json;
	v_fields_array json[];
	v_querystring text;
	array_index integer DEFAULT 0;
	field_value character varying;
	v_debug_vars json;
	v_fieldsjson jsonb := '[]';
	v_response json;
	aux_json json;
	v_debug json;
	v_msgerr json;
	v_querytext text;
    v_result_info json;
    v_selected_id text;
    v_selected_idval text;
    v_current_id text;
    v_new_id text;
    v_widgetcontrols json;
    v_values_array json;
	v_error_context text;

BEGIN
    -- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    -- Get input data
    v_device := p_data -> 'client' ->> 'device';
    v_tiled := p_data ->'client' ->> 'tiled';

	-- variables needed
    v_feature_id := ((p_data ->>'feature')::json->>'id')::text;
	v_table_name := ((p_data ->>'feature')::json->>'tableName')::text;

	SELECT DISTINCT LOWER(feature_type) INTO v_feature_type FROM cat_feature WHERE parent_layer = v_table_name;

    -- Get api version
    v_version := row_to_json(row) FROM (
    SELECT value FROM config_param_system WHERE parameter='admin_version'
    ) row;

    SELECT gw_fct_getformfields(
    'generic',
    'form_featuretype_change',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    v_device,
    NULL
    ) INTO v_fields_array;
		-- get current feature type
		v_sql := concat('SELECT ', v_feature_type, '_type FROM v_edit_', v_feature_type, ' WHERE ', v_feature_type, '_id = ''', v_feature_id, '''');
		EXECUTE v_sql INTO v_current_featurecat_id;

		-- get default new feature type
		SELECT id into v_new_featurecat_id_default FROM cat_feature WHERE parent_layer = v_table_name AND active is True AND id != v_current_featurecat_id  order by 1 limit 1;

		-- SELECT array_agg( layoutname) into v_layouts FROM config_form_fields  WHERE formtype = 'form_featuretype_change';
		SELECT array_agg(distinct layoutname) into v_layouts FROM config_form_fields  WHERE formtype = 'form_featuretype_change';

		v_form:= '"layouts": {';

		FOREACH v_layout IN ARRAY v_layouts
		LOOP
			select addparam into v_addparam from config_typevalue where id = v_layout;
			if v_layout = 'lyt_main_4' then
				v_form:= concat(v_form,  '"', v_layout, '":',v_addparam);
			else
				v_form:= concat(v_form,  '"', v_layout, '":',v_addparam,',');
			end if;

		END LOOP;

		v_form:= concat(v_form,'}' );


        FOREACH aux_json IN ARRAY v_fields_array
        LOOP
            array_index := array_index + 1;

            field_value := (v_values_array->>(aux_json->>'columnname'));
            IF (aux_json->>'columnname') = 'feature_type' THEN
				field_value := v_current_featurecat_id;
            END IF;

            IF (aux_json->>'columnname') = 'feature_type_new' THEN
				SELECT array_agg(id) into v_featurecat_ids FROM cat_feature WHERE parent_layer = v_table_name AND active is True group by parent_layer order by 1;
				-- fill combo values
				v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_featurecat_ids, '{}'));
				v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_featurecat_ids, '{}'));

				-- set selectedId in combo box
				field_value = v_new_featurecat_id_default;
            END IF;

            IF (aux_json->>'columnname') = 'featurecat_id' THEN
		       v_sql := concat('SELECT array_agg(id) FROM cat_', v_feature_type, ' WHERE ', v_feature_type, 'type_id = ''', v_new_featurecat_id_default, ''' AND active is True OR active is null ORDER BY 1');
			   EXECUTE v_sql INTO v_catalogs_ids;

               v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_catalogs_ids, '{}'));
               v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_catalogs_ids, '{}'));
            END IF;

			IF (aux_json->>'columnname') = 'fluid' THEN

				 select array_agg(fluid_type) into v_fluids from man_type_fluid where lower(feature_type) = v_feature_type;
                 v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_fluids, '{}'));
               	 v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_fluids, '{}'));

            END IF;

			IF (aux_json->>'columnname') = 'location' THEN

				 select array_agg(location_type) into v_locations from man_type_location where lower(feature_type) = v_feature_type;
                 v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_locations, '{}'));
               	 v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_locations, '{}'));

            END IF;

			IF (aux_json->>'columnname') = 'category' THEN

				 select array_agg(category_type) into v_categories from man_type_category where lower(feature_type) = v_feature_type;
                 v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_categories, '{}'));
               	 v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_categories, '{}'));

            END IF;

			IF (aux_json->>'columnname') = 'function' THEN

				 select array_agg(function_type) into v_functions from man_type_function where lower(feature_type) = v_feature_type;
                 v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_functions, '{}'));
               	 v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_functions, '{}'));

            END IF;

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
                        raise notice 'MISSING v_new_id1,%',v_new_id;
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
            ELSIF (aux_json->>'widgettype')='button' and json_extract_path_text(aux_json,'widgetcontrols','text') IS NOT NULL THEN
                v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'value', json_extract_path_text(aux_json,'widgetcontrols','text'));
            ELSE
                v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'value', COALESCE(field_value, ''));
            END IF;

        END LOOP;

    v_fieldsjson := to_json(v_fields_array);
    v_result_info := COALESCE(v_result_info, '{}');

    v_response := '{
    "status": "Accepted",
    "version": ' || v_version || ',
    "body": {
        "form": {' || v_form || '
		},
        "feature": {},
        "data": {
            "fields": ' || v_fieldsjson || '
        }
    }
	}';
    RETURN v_response;

    -- Exception handling
    EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
    RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
