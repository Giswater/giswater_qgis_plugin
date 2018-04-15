CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_updatefeature"(table_id varchar, id int8, column_name varchar, value_new varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    column_type character varying;
    schemas_array name[];
    sql_query varchar;
    table_pkey varchar;
    column_type_id character varying;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get schema name
    schemas_array := current_schemas(FALSE);

--    Get column type
    EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND column_name = $2'
        USING schemas_array[1], column_name
        INTO column_type;

--    Error control
    IF column_type ISNULL THEN
        RETURN ('{"status":"Failed","SQLERR":"Column ' || column_name || ' does not exist in table om_visit_event"}')::json;
    END IF;
    
--    Get id column, for tables is the key column
    EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO table_pkey
        USING table_id;

--    For views is the first column
    IF table_pkey ISNULL THEN
        EXECUTE 'SELECT column_name FROM information_schema.columns WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND ordinal_position = 1'
        INTO table_pkey
        USING schemas_array[1];
    END IF;

--    Get column type
    EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(table_id) || ' AND column_name = $2'
        USING schemas_array[1], table_pkey
        INTO column_type_id;

--    Value update
    sql_query := 'UPDATE ' || quote_ident(table_id) || ' SET ' || quote_ident(column_name) || ' = CAST(' || quote_literal(value_new) || ' AS ' || column_type || ') WHERE ' || quote_ident(table_pkey) || ' = CAST(' || quote_literal(id) || ' AS ' || column_type_id || ')';

RAISE NOTICE 'Res: %', sql_query;
    
    EXECUTE sql_query;

--    Return
    RETURN ('{"status":"Accepted"}')::json;    

--    Exception handling
   -- EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

