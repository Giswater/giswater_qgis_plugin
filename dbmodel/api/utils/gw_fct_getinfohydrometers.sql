
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfohydrometers(
    element_type character varying,
    id character varying,
    device integer)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_hydrometers json;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get query for elements
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat($1,''_x_hydrometer'') AND device = $2'
        INTO query_result
        USING element_type, device;

--    Get elements
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || quote_ident( element_type || '_id') || '::text = $1) a'
        INTO query_result_hydrometers
        USING id;

--    Control NULL's
    query_result_hydrometers := COALESCE(query_result_hydrometers, '{}');
    
--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||',"hydrometers":' || query_result_hydrometers || '}')::json;
--    RETURN query_result_hydrometers;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
