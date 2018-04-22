CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfovisits"(element_type varchar, id varchar, device int4, visit_start timestamp, visit_end timestamp, parameter_type varchar, parameter_id varchar, visit_id int8) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_dates character varying;
    query_result_visits json;
    query_result_visits_dates json;    
    parameter_type_options json;
    parameter_id_options json;
    
BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get query for visits
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat(''v_ui_om_visit_x_'',$1) AND device = $2'
        INTO query_result
        USING element_type, device;

--    Add id filter
    query_result := query_result || ' WHERE ' || quote_ident( element_type || '_id') || ' = ' || quote_literal(id);

--    Add visit_start filter
    IF visit_start IS NOT NULL THEN
        query_result := query_result || ' AND visit_start > ' || quote_literal(visit_start::TIMESTAMP(6));
    END IF;

--    Add visit_end filter
   IF visit_end IS NOT NULL THEN
        query_result := query_result || ' AND visit_end < ' || quote_literal(visit_end::TIMESTAMP(6));
    END IF;

--    Query with dates filter
    query_result_dates := query_result;

--    Add parameter_type filter
    IF parameter_type IS NOT NULL THEN
        query_result := query_result || ' AND parameter_type = ' || quote_literal(parameter_type);
    END IF;

--    Add parameter_id filter
    IF parameter_id IS NOT NULL THEN
        query_result := query_result || ' AND parameter_id = ' || quote_literal(parameter_id);
    END IF;

--    Add visit_id filter
    IF visit_id IS NOT NULL THEN
        query_result := query_result || ' AND visit_id = ' || visit_id;
    END IF;

--    Get visits with all the filters
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ') a'
        INTO query_result_visits
        USING id;

--    Get visits with just date filters
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ') a'
        INTO query_result_visits_dates
        USING id;

--    Get parameter_type_options
    IF query_result_visits_dates ISNULL THEN
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT DISTINCT parameter_type AS "id", parameter_type AS "name" FROM om_visit_parameter WHERE feature_type = UPPER($1)) a' 
            INTO parameter_type_options
            USING element_type;
    ELSE
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT DISTINCT parameter_type AS "id", parameter_type AS "name" FROM (' || query_result_dates || ') b) a'
            INTO parameter_type_options;

    END IF;
        
--    Get query_result_parameter_id_options
    IF query_result_visits_dates ISNULL THEN

        IF parameter_type ISNULL THEN
            parameter_type := json_extract_path_text( parameter_type_options->1,'id');
        END IF;
    
        EXECUTE 'SELECT array_to_json(array_agg(json_data)) FROM (SELECT row_to_json(t) AS json_data FROM (SELECT id, descript AS "name" FROM om_visit_parameter 
            WHERE  feature_type = UPPER($1) AND parameter_type = $2) t  ) r'  
            INTO parameter_id_options
            USING element_type, parameter_type;
    ELSE    
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT DISTINCT parameter_id AS "id", descript AS "name" FROM (' || query_result_dates || ') b) a'
            INTO parameter_id_options
            USING query_result_visits;
    END IF;


--    Control NULL's
    query_result_visits := COALESCE(query_result_visits, '{}');
    parameter_type_options := COALESCE(parameter_type_options, '{}');
    parameter_id_options := COALESCE(parameter_id_options, '{}');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "events":' || query_result_visits || 
        ', "parameter_type_options":' || parameter_type_options ||
        ', "parameter_id_options":' || parameter_id_options ||
        '}')::json;    


--    Exception handling
  --  EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

