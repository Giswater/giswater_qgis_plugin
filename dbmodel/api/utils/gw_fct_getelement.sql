
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_getelement(
    p_element_type character varying,
    element_id character varying,
    device integer)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_element json;
    api_version json;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
 
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get query for elements
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = $1 AND device = $2'
        INTO query_result
        USING p_element_type, device;

--    Get elements
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE id = $1) a'
        INTO query_result_element
        USING element_id;

--    Control NULL's
    query_result_element := COALESCE(query_result_element, '{}');
    
--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||',"element":' || query_result_element || '}')::json;
--    RETURN query_result_elements;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_getelement(character varying, character varying, integer)
  OWNER TO geoadmin;
