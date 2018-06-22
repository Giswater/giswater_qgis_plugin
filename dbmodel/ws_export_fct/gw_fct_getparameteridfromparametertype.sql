CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getparameteridfromparametertype"(parameter_type varchar, element_type varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result_parameter_id_options json;
    api_version json;



BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;    
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


--    COMMON TASKS:


--    Get parameter id
    EXECUTE 'SELECT array_to_json(array_agg(json_data)) FROM (SELECT row_to_json(t) AS json_data FROM (SELECT id, descript AS "name" FROM om_visit_parameter 
    WHERE parameter_type = ' || quote_literal(parameter_type) || ' AND LOWER(feature_type) = '|| quote_literal(element_type) || ') t  ) r'   
    INTO query_result_parameter_id_options;


--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "parameter_id_options":' || query_result_parameter_id_options ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
        

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

