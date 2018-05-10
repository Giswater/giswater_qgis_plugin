CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getvisitsfromfeature"(element_type varchar, id varchar, device int4, visit_start timestamp, visit_end timestamp) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_visits json;
    api_version json;



BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get query for visits
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat($1,''_x_visit_manager'') AND device = $2'
        INTO query_result
        USING element_type, device;

    

--    Add id filter
    query_result := query_result || ' WHERE ' || quote_ident( element_type || '_id') || ' = ' || quote_literal(id);

--    Add visit_start filter
    IF visit_start IS NOT NULL THEN
        query_result := query_result || ' AND visit_start > ' || quote_literal(visit_start::TIMESTAMP(6));
    END IF;

--    Add visit_end filter
--    IF visit_end IS NOT NULL THEN
--        query_result := query_result || ' AND visit_end < ' || quote_literal(visit_end::TIMESTAMP(6));
--    END IF;
    
--    Get visits
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ') a'
        INTO query_result_visits
        USING id;


RAISE NOTICE 'Res: % ', query_result_visits;


--    Control NULL's
    query_result_visits := COALESCE(query_result_visits, '{}');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||'"' ||
        ', "visits":' || query_result_visits || 
        '}')::json;    

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

