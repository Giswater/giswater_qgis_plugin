/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3324

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getchangefeaturetype(p_data json)
RETURNS json AS
$BODY$

/*
-- Button GwFeatureTypeChangeButton

SELECT gw_fct_getchangefeaturetype($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE},"form":{},"feature":{"tableName":"ve_node", "id":"1058"},"data":{"newFeatureCat":"HYDRANT"}}$$);

fid = 216

*/

DECLARE
    v_device integer;
	v_curr_featurecat text;
	v_feature_type text;
	v_feature_id text;
	v_table_name text;
	v_form text;
	v_addparam json;
	v_featurecat_ids json;
	v_catalogs_ids text[];
	v_fluids text[];
	v_locations text[];
	v_categories text[];
	v_functions text[];
	v_sql text;
	v_layouts text[];
	v_layout text;
	v_tiled boolean=false;
	v_version text;
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
	v_project_type text;
	v_feature_type_values json;
	v_new_featurecat text;
    v_new_featurecat_exist bool;

BEGIN
    -- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    -- Get input data
    v_device := p_data -> 'client' ->> 'device';
    v_tiled := p_data ->'client' ->> 'tiled';

	-- variables needed
    v_feature_id := ((p_data ->>'feature')::json->>'id')::text;
	v_table_name := ((p_data ->>'feature')::json->>'tableName')::text;
	v_new_featurecat := ((p_data ->>'data')::json->>'newFeatureCat')::text;

    -- Get api version
    SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version;

   	SELECT DISTINCT LOWER(feature_type) INTO v_feature_type FROM cat_feature WHERE parent_layer = v_table_name;

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

    -- setting new featurecat as same as current
    IF v_new_featurecat IS NULL then
        -- get current feature_cat
        v_sql := concat('SELECT ', v_feature_type, '_type FROM ve_', v_feature_type, ' WHERE ', v_feature_type, '_id = ''', v_feature_id, '''');
        EXECUTE v_sql INTO v_new_featurecat;
        v_curr_featurecat = v_new_featurecat;
    else
        v_curr_featurecat = v_new_featurecat;
    END IF;

    v_sql := concat('SELECT json_build_object(
	    ''location_type'', location_type,
	    ''function_type'', function_type,
	    ''fluid_type'', fluid_type,
	    ''category_type'', category_type,
		''',v_feature_type,'cat_id'', ',v_feature_type,'cat_id
	    ) AS combined_data
	    FROM ve_', v_feature_type, ' WHERE ', v_feature_type, '_id = ''', v_feature_id, '''');

    EXECUTE v_sql INTO v_feature_type_values;

    -- SELECT array_agg( layoutname) into v_layouts FROM config_form_fields  WHERE formtype = 'form_featuretype_change';
    SELECT array_agg(distinct layoutname) into v_layouts FROM config_form_fields  WHERE formtype = 'form_featuretype_change';

    v_form:= '"layouts": {';

    FOREACH v_layout IN ARRAY v_layouts
    LOOP
        select addparam into v_addparam from config_typevalue where id = v_layout;
        v_form:= concat(v_form,  '"', v_layout, '":',coalesce(v_addparam, '{}'),',');
    END LOOP;

    v_form := left(v_form, length(v_form) - 1);
    v_form:= concat(v_form,'}' );


    FOREACH aux_json IN ARRAY v_fields_array
    LOOP
        array_index := array_index + 1;


        if v_feature_type_values is not null then
            field_value := (v_feature_type_values ->> (aux_json->>'columnname'));
        end if;

        IF (aux_json->>'columnname') = 'feature_type' THEN
            field_value := v_curr_featurecat;
        END IF;

        IF (aux_json->>'columnname') = 'feature_type_new' then

            SELECT to_json(array_agg(id ORDER BY id)) into v_featurecat_ids FROM cat_feature WHERE parent_layer = v_table_name AND active is True;
            -- fill combo values
            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_featurecat_ids, '{}'));
            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_featurecat_ids, '{}'));
            -- set selectedId in combo box
            field_value = v_new_featurecat;

        END IF;

        IF (aux_json->>'columnname') = 'featurecat_id' THEN
            v_sql := concat('SELECT array_agg(id) FROM cat_', v_feature_type, ' WHERE ', v_feature_type, '_type = ''', v_curr_featurecat, ''' AND active IS TRUE OR active IS NULL ORDER BY 1');

            EXECUTE v_sql INTO v_catalogs_ids;

			v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_catalogs_ids, '{}'));
			v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_catalogs_ids, '{}'));
			field_value = v_feature_type_values ->> concat(v_feature_type, 'cat_id');

        END IF;

        -- todo: for all *_type need to be implemented the filter of fetaurecat_id and alos the field_value

        IF (aux_json->>'columnname') = 'location_type' THEN
            SELECT array_agg(location_type ORDER BY location_type NULLS FIRST) INTO v_locations
            FROM man_type_location
            WHERE lower(v_feature_type) = ANY (SELECT lower(f) FROM unnest(feature_type) as f)
                AND (v_new_featurecat = any (featurecat_id) OR featurecat_id IS NULL)
                AND (active IS TRUE OR active IS NULL);

            -- Enable null value
            v_locations = array_prepend('',v_locations);

            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_locations, '{}'));
            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_locations, '{}'));

           	EXECUTE 'SELECT location_type FROM '||v_feature_type||' WHERE '||v_feature_type||'_id = '''||v_feature_id||''';'
            INTO field_value;

        END IF;

        IF (aux_json->>'columnname') = 'category_type' THEN
            SELECT array_agg(category_type ORDER BY category_type NULLS FIRST) INTO v_categories
            FROM man_type_category
            WHERE lower(v_feature_type) = ANY (SELECT lower(f) FROM unnest(feature_type) as f)
                AND (v_new_featurecat = any (featurecat_id) OR featurecat_id IS NULL)
                AND (active IS TRUE OR active IS NULL);

            -- Enable null value
            v_categories = array_prepend('',v_categories);

            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_categories, '{}'));
            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_categories, '{}'));

			EXECUTE 'SELECT category_type FROM '||v_feature_type||' WHERE '||v_feature_type||'_id = '''||v_feature_id||''';'
            INTO field_value;
        END IF;

        IF (aux_json->>'columnname') = 'function_type' THEN
            SELECT array_agg(function_type ORDER BY function_type NULLS FIRST) INTO v_functions
            FROM man_type_function
            WHERE lower(v_feature_type) = ANY (SELECT lower(f) FROM unnest(feature_type) as f)                AND (v_new_featurecat = any (featurecat_id) OR featurecat_id IS NULL)
                AND (active IS TRUE OR active IS NULL);

            -- Enable null value
            v_functions = array_prepend('',v_functions);

            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboIds', COALESCE(v_functions, '{}'));
            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'comboNames', COALESCE(v_functions, '{}'));

			EXECUTE 'SELECT function_type FROM '||v_feature_type||' WHERE '||v_feature_type||'_id = '''||v_feature_id||''';'
            INTO field_value;
        END IF;

        IF (aux_json->>'widgettype')='combo' THEN
            --check if selected id is on combo list
            IF field_value::text not in  (select a from json_array_elements_text(json_extract_path(v_fields_array[array_index],'comboIds'))a) AND field_value IS NOT null and v_new_featurecat_exist is false then
            	--find dvquerytext for combo
                v_querystring = concat('SELECT dv_querytext FROM config_form_fields WHERE
                columnname::text = (',quote_literal(v_fields_array[array_index]),'::json->>''columnname'')::text
                and formname = ',quote_literal(v_table_name),';');
                v_debug_vars := json_build_object('v_fields_array[array_index]', v_fields_array[array_index], 'v_table_name', v_table_name);
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
                    v_new_id = '['||v_new_id || ']';
                    --add new combo Ids to return json
                    v_fields_array[array_index] = gw_fct_json_object_set_key(v_fields_array[array_index],'comboIds',v_new_id::json);

                    v_current_id =json_extract_path_text(v_fields_array[array_index],'comboNames');
                    select string_agg(quote_ident(a),',') into v_new_id from json_array_elements_text(v_current_id::json) a ;
                    --remove current combo names from return json
                    v_fields_array[array_index] = v_fields_array[array_index]::jsonb - 'comboNames'::text;
                    v_new_id = '['||v_new_id || ']';
                    --add new combo names to return json
                    v_fields_array[array_index] = gw_fct_json_object_set_key(v_fields_array[array_index],'comboNames',v_new_id::json);
                END IF;
            END IF;
            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'selectedId', COALESCE(field_value, ''));
        ELSIF (aux_json->>'widgettype') !='button' THEN
            v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'value', COALESCE(field_value, ''));
        END IF;

    END LOOP;

    v_fieldsjson := to_json(v_fields_array);
    v_result_info := COALESCE(v_result_info, '{}');

    v_response := '{
        "status": "Accepted",
        "version": "' || v_version || '",
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
    RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
