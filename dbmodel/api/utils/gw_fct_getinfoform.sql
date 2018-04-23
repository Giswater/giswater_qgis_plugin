CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfoform"(table_id varchar, lang varchar, id varchar, formToDisplay text) RETURNS pg_catalog.json AS $BODY$
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
    class_id_var text;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get schema name
    schemas_array := current_schemas(FALSE);
    

   raise notice 'table_id %, id %, formToDisplay %', table_id, id, formToDisplay;
        
--    Get form fields
    EXECUTE 'SELECT array_agg(row_to_json(a)) FROM 
    (SELECT column_name as label, column_name as name, ''text'' as type, ''string'' as "dataType", null as placeholder, false as "disabled" 
    FROM information_schema.columns WHERE columns.table_schema = ''SCHEMA_NAME'' AND table_name= $1) a'
        INTO fields_array
        USING table_id;    

--    Get id column
    EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO table_pkey
        USING table_id;

--    For views it suposse pk is the first column
    IF table_pkey ISNULL THEN
        EXECUTE 'SELECT column_name FROM information_schema.columns WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND ordinal_position = 1'
        INTO table_pkey
        USING schemas_array[1];
    END IF;


--    Get column type
    EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND column_name = $2'
        USING schemas_array[1], table_pkey
        INTO column_type;


--    Fill every value
    FOREACH aux_json IN ARRAY fields_array
    LOOP
--        Index
        array_index := array_index + 1;

--        Get field values
        EXECUTE 'SELECT ' || quote_ident(aux_json->>'name') || ' FROM ' || quote_ident(table_id) || ' WHERE ' || quote_ident(table_pkey) || ' = CAST(' || quote_literal(id) || ' AS ' || column_type || ')' 
        INTO field_value; 
        field_value := COALESCE(field_value, '');

--        Update array
        fields_array[array_index] := gw_fct_json_object_set_key(fields_array[array_index], 'value', field_value);
            
    END LOOP;

    
--    Convert to json
    fields := array_to_json(fields_array);

--    Control NULL's
    formToDisplay := COALESCE(formToDisplay, '');
    fields := COALESCE(fields, '[]');    
    position := COALESCE(position, '[]');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "formToDisplay":"' || formToDisplay || '"' ||
        ', "fields":' || fields ||
        '}')::json;

--    Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
 --       RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

