CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfoelements"(element_type varchar, id varchar, device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_elements json;
    type_element_arg json;
    api_version json;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
            INTO api_version;

      -- Get type_element from alias
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT type_element from config_web_layer WHERE alias_id=$1 LIMIT 1)a'
            INTO type_element_arg
            USING element_type;

    raise notice 'type_element_arg %', type_element_arg;

--    Get query for elements
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat($1,''_x_element'') AND device = $2'
        INTO query_result
        USING element_type, device;

    raise notice 'query_result %', query_result;

--    Get elements
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || quote_ident( element_type || '_id') || '::text = $1) a'
        INTO query_result_elements
        USING id;

    raise notice 'query_result_elements %', query_result_elements;


--    Control NULL's
    type_element_arg := COALESCE(type_element_arg, '{}');
    query_result_elements := COALESCE(query_result_elements, '{}');
    
--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||', "typeElement":' ||type_element_arg||', "elements":' || query_result_elements || '}')::json;
          

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||', "SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

