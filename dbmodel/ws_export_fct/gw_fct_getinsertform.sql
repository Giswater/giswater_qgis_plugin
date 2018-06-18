CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinsertform"(table_id varchar, lang varchar, id varchar) RETURNS pg_catalog.json AS $BODY$
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
    formToDisplayName character varying;
    table_pkey varchar;
    schemas_array name[];
    array_index integer DEFAULT 0;
    field_value character varying;
    formtodisplay text;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get schema name
    schemas_array := current_schemas(FALSE);

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

    --  Take form_id 
    EXECUTE 'SELECT formid FROM config_web_layer WHERE layer_id = $1 LIMIT 1'
        INTO formtodisplay
        USING table_id; 
            
--    Check generic
    IF formtodisplay ISNULL THEN
        formtodisplay := 'F16';
    END IF;


    

--    Get fields
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT label, name, type, "dataType", placeholder FROM config_web_fields WHERE table_id = $1 order by orderby) a'
        INTO fields_array
        USING table_id;    

--    Get combo rows
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT id, name, type, dv_table, dv_id_column, dv_name_column, ROW_NUMBER() OVER() AS rownum 
        FROM config_web_fields WHERE table_id = $1) a WHERE type = $2'
    INTO combo_rows
    USING table_id, 'combo';
    combo_rows := COALESCE(combo_rows, '{}');


--    Update combos
    FOREACH aux_json IN ARRAY combo_rows
    LOOP

--      Get combo id's
        EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'dv_id_column') || ')) FROM (SELECT ' || quote_ident(aux_json->>'dv_id_column') || ' FROM ' 
        || quote_ident(aux_json->>'dv_table') || ' ORDER BY '||quote_ident(aux_json->>'dv_name_column') || ') a'
        INTO combo_json; 
     

--        Update array
        fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboIds', COALESCE(combo_json, '[]'));
        IF combo_json IS NOT NULL THEN
            fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'selectedId', combo_json->0);
        ELSE
            fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'selectedId', to_json('Fred said "Hi."'::text));        
        END IF;

--        Get combo values
        EXECUTE 'SELECT array_to_json(array_agg(' || quote_ident(aux_json->>'dv_name_column') || ')) FROM (SELECT ' || quote_ident(aux_json->>'dv_name_column') ||  ' FROM '
        || quote_ident(aux_json->>'dv_table') || ' ORDER BY '||quote_ident(aux_json->>'dv_name_column') || ') a'
        INTO combo_json; 
        combo_json := COALESCE(combo_json, '[]');
    
--      Update array
        fields_array[(aux_json->>'rownum')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'rownum')::INT], 'comboNames', combo_json);

    END LOOP;


--    Get existing values for the element
    IF id IS NOT NULL THEN

--        Get id column
        EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
            INTO table_pkey
            USING table_id;

--        For views is the first column
        IF table_pkey ISNULL THEN
            EXECUTE 'SELECT column_name FROM information_schema.columns WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND ordinal_position = 1'
            INTO table_pkey
            USING schemas_array[1];
        END IF;

--        Get column type
        EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND column_name = $2'
            USING schemas_array[1], table_pkey
            INTO column_type;


--        Fill every value
        FOREACH aux_json IN ARRAY fields_array
        LOOP

--            Index
            array_index := array_index + 1;

--            Get values
            EXECUTE 'SELECT ' || quote_ident(aux_json->>'name') || ' FROM ' || quote_ident(table_id) || ' WHERE ' || quote_ident(table_pkey) || ' = CAST(' || quote_literal(id) || ' AS ' || column_type || ')' 
                INTO field_value; 
            field_value := COALESCE(field_value, '');


--            Update array
            IF aux_json->>'type' = 'combo' THEN
                fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'selectedId', field_value);
            ELSE            
                fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'value', field_value);
            END IF;
            
        END LOOP;

    END IF;    
    
--    Convert to json
    fields := array_to_json(fields_array);

raise notice 'fields %', fields;


--    Control NULL's
    formtodisplay := COALESCE(formtodisplay, '');
    fields := COALESCE(fields, '[]');    
    position := COALESCE(position, '[]');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "formToDisplay":"' || formtodisplay || '"' ||
        ', "fields":' || fields ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

