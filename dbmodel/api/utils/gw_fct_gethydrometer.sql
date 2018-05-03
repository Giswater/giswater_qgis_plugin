CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_gethydrometer(
    element_id character varying,
    device integer)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_hydrometers json;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get query for elements
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''v_ui_hydrometer'' AND device = $1'
        INTO query_result
        USING device;

--    Get elements
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE hydrometer_id = $1) a'
        INTO query_result_hydrometers
        USING element_id;

--    Control NULL's
    query_result_hydrometers := COALESCE(query_result_hydrometers, '{}');
    
--    Return
    RETURN ('{"status":"Accepted","hydrometers":' || query_result_hydrometers || '}')::json;
--    RETURN query_result_hydrometerss;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

