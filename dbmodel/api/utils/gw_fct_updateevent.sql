CREATE OR REPLACE FUNCTION "arbrat_viari"."gw_fct_updateevent"(event_id int8, column_name varchar, value_new varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    column_type character varying;
    schemas_array name[];
    sql_query varchar;

BEGIN


--    Set search path to local schema
    SET search_path = "arbrat_viari", public;

--    Get schema name
    schemas_array := current_schemas(FALSE);

--    Get column type
    EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ''om_visit_event'' AND column_name = $2'
        USING schemas_array[1], column_name
        INTO column_type;

--    Error control
    IF column_type ISNULL THEN
        RETURN ('{"status":"Failed","SQLERR":"Column ' || column_name || ' does not exist in table om_visit_event"}')::json;
    END IF;
    

--    Value update
    sql_query := 'UPDATE om_visit_event SET ' || quote_ident(column_name) || ' = CAST(' || quote_literal(value_new) || ' AS ' || column_type || ') WHERE id = ' || event_id::INT;
    EXECUTE sql_query;

--    Return
    RETURN ('{"status":"Accepted"}')::json;    

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

