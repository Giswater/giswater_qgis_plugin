CREATE OR REPLACE FUNCTION "arbrat_viari"."gw_fct_getinfodocs"(element_type varchar, id varchar, device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_docs json;

BEGIN


--    Set search path to local schema
    SET search_path = "arbrat_viari", public;

--    Get query for docs
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat(''v_ui_doc_x_'',$1) AND device = $2'
        INTO query_result
        USING element_type, device;

--    Get docs
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || quote_ident( element_type || '_id') || ' = $1) a'
        INTO query_result_docs
        USING id;

--    Return
    RETURN ('{"status":"Accepted","docs":' || query_result_docs || '}')::json;
    RETURN query_result_docs;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

