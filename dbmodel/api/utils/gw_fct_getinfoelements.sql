CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfoelements"(element_type varchar, id varchar, device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_elements json;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get query for elements
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat(''v_ui_element_x_'',$1) AND device = $2'
        INTO query_result
        USING element_type, device;

--    Get elements
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || quote_ident( element_type || '_id') || '::text = $1) a'
        INTO query_result_elements
        USING id;

--    Control NULL's
    query_result_elements := COALESCE(query_result_elements, '{}');
    
--    Return
    RETURN ('{"status":"Accepted","elements":' || query_result_elements || '}')::json;
--    RETURN query_result_elements;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

