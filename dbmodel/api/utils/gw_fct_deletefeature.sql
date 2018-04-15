CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_deletefeature"(table_id varchar, id int8) RETURNS pg_catalog.json AS $BODY$
DECLARE

    schemas_array name[];
    res_delete boolean;
    table_pkey varchar;
    column_type character varying;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;    

--    Get schema name
    schemas_array := current_schemas(FALSE);
    
--    Get id column
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
        INTO column_type;

--    Get parameter id
    EXECUTE 'SELECT EXISTS(SELECT 1 FROM ' || table_id || ' WHERE ' || quote_ident(table_pkey) || ' = CAST(' || quote_literal(id) || ' AS ' || column_type || '))'
    USING id
    INTO res_delete;

RAISE NOTICE 'Res: %', column_type;

--    Return
    IF res_delete THEN

        EXECUTE 'DELETE FROM ' || quote_ident(table_id) || ' WHERE ' || quote_ident(table_pkey) || ' = CAST(' || quote_literal(id) || ' AS ' || column_type || ')'
            USING id;

        RETURN ('{"status":"Accepted"}')::json;
    ELSE
        RETURN ('{"status":"Failed","message":"' || quote_ident(table_pkey) || ' = ' || id || ' does not exist"}')::json;
    END IF;

--    Exception handling
  --  EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

