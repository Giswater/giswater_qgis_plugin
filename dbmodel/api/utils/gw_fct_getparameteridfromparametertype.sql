CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getparameteridfromparametertype"(parameter_type varchar, element_type varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result_parameter_id_options json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;    


--    COMMON TASKS:


--    Get parameter id
    EXECUTE 'SELECT array_to_json(array_agg(json_data)) FROM (SELECT row_to_json(t) AS json_data FROM (SELECT id, descript AS "name" FROM om_visit_parameter 
    WHERE parameter_type = ' || quote_literal(parameter_type) || ' AND LOWER(feature_type) = '|| quote_literal(element_type) || ') t  ) r'   
    INTO query_result_parameter_id_options;


--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "parameter_id_options":' || query_result_parameter_id_options ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
        

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

