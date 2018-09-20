CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getprint"(p_active_composer text, p_device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE
    
--    Variables
    column_type character varying;
    query_result character varying;
    position json;
    fields json;
    fields_array json[];
    position_row integer;
    combo_rows json[];
    aux_json json;    
    combo_json json;
    project_type character varying;
    table_pkey varchar;
    schemas_array name[];
    array_index integer DEFAULT 0;
    field_value character varying;
    api_version json;
    v_value_vdef character varying;
    formTabs text;
    formTabs_inittab json;
    query_text text;
    formInfo json;
    

BEGIN

    -- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    -- Get schema name
    schemas_array := current_schemas(FALSE);

    -- Get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

-- Create tabs array
    formTabs := '[';
       
    -- Get fields
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT id, label, name, type, "dataType", placeholder FROM config_web_fields WHERE table_id = ''F32'' order by orderby) a'
        INTO fields_array;

    -- Get combo rows
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT id, name, type, dv_table, dv_id_column, dv_name_column, orderby AS rownum 
        FROM config_web_fields WHERE table_id = $1) a WHERE type = $2'
    INTO combo_rows
    USING 'F32', 'combo';
    combo_rows := COALESCE(combo_rows, '{}');


    -- Update combos
    FOREACH aux_json IN ARRAY combo_rows
    LOOP

--      Get combo id's
    IF aux_json->>'dv_table' = 'config_web_composer' THEN
        EXECUTE 'SELECT array_to_json(''' || p_active_composer ||'''::text[])'
            INTO combo_json; 

        RAISE NOTICE 'combo_json 11 %', combo_json;
    ELSE
        EXECUTE 'SELECT array_to_json(array_agg((' || (quote_ident(aux_json->>'dv_id_column')) || ')::text)) FROM (SELECT (' || (quote_ident(aux_json->>'dv_id_column')) ||') FROM ' 
        || quote_ident(aux_json->>'dv_table') || ' ORDER BY '||quote_ident(aux_json->>'dv_id_column') || ') a'
            INTO combo_json; 

        RAISE NOTICE 'combo_json 13 %', combo_json;

    END IF;
--      Update array
        fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboIds', COALESCE(combo_json, '[]'));
        
--      Get combo values
    IF aux_json->>'dv_table' = 'config_web_composer' THEN
        EXECUTE 'SELECT array_to_json(''' || p_active_composer ||'''::text[])'
            INTO combo_json; 

            RAISE NOTICE 'combo_json 15 %', combo_json;
    ELSE
        EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'dv_name_column') || ')) FROM (SELECT ' || quote_ident(aux_json->>'dv_name_column') ||  ' FROM '
            || quote_ident(aux_json->>'dv_table') || ' ORDER BY '||quote_ident(aux_json->>'dv_id_column') || ') a'
            INTO combo_json; 
    END IF;
    
    combo_json := COALESCE(combo_json, '[]');
    
--      Update array
        fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboNames', combo_json);

    END LOOP;

    raise notice 'fields_array %', fields_array;

--        Fill every value
        FOREACH aux_json IN ARRAY fields_array
        LOOP
        -- Index
        array_index := array_index + 1;
        
        -- Get values
        EXECUTE 'SELECT field_value FROM selector_composer WHERE field_id= '|| quote_literal(aux_json->>'name') ||' AND user_name = '||quote_literal(current_user)
                INTO field_value; 
        field_value := COALESCE(field_value, '');

        -- Update array
        IF aux_json->>'type' = 'combo' THEN
            fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'selectedId', field_value);
        ELSE 
            fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'value', field_value);
        END IF;
            
        END LOOP;

    --fields_array[array_index+1] := gw_fct_createcombojson('Escala', 'scale', 'combo', 'string', '', FALSE, 'config_web_composer_scale','id','idval',1000::text);
       

--    Inizialing the the tab
    formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'tabName', 'Menu print'::TEXT);
    formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'tabLabel', 'Menu de print'::TEXT);
    formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'tabIdName', 'print'::TEXT);
    formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'active', true);

--    Adding the fields array
    formTabs_inittab := gw_fct_json_object_set_key(formTabs_inittab, 'fields', array_to_json(fields_array));

--    Adding to the tabs structure
    formTabs := formTabs || formTabs_inittab::text;
    
--    Finish the construction of formtabs
      formTabs := formtabs ||']';

--    Create new form for mincut
      formInfo := json_build_object('formId','F41','formName','Impressio');

--    Check null
      formInfo := COALESCE(formInfo, '[]');    
      formTabs := COALESCE(formTabs, '[]'); 
      fields := COALESCE(fields, '[]');    

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version || 
        ', "formInfo":'|| formInfo || 
        ', "formTabs":' || formTabs ||
        '}')::json;


--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

