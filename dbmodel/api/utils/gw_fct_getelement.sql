CREATE OR REPLACE FUNCTION "arbrat_viari"."gw_fct_getelement"(element_id varchar, device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_element json;

BEGIN


--    Set search path to local schema
    SET search_path = "arbrat_viari", public;

--    Get query for elements
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''v_ui_element'' AND device = $1'
        INTO query_result
        USING device;

--    Get elements
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE element_id = $1) a'
        INTO query_result_element
        USING element_id;

--    Control NULL's
    query_result_element := COALESCE(query_result_element, '{}');
    
--    Return
    RETURN ('{"status":"Accepted","element":' || query_result_element || '}')::json;
--    RETURN query_result_elements;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

