CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_deleteeventphoto"(value_arg text) RETURNS pg_catalog.json AS $BODY$
DECLARE

    res_delete boolean;
    api_version json;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;    

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;
    
--    Get parameter id
    EXECUTE 'SELECT EXISTS(SELECT 1 FROM om_visit_event_photo WHERE value = $1)'
    USING value_arg
    INTO res_delete;

--    Return
    IF res_delete THEN

        EXECUTE 'DELETE FROM om_visit_event_photo WHERE value = $1'
            USING value_arg;

        RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||'}')::json;
    ELSE
        RETURN ('{"status":"Failed","message":"hash ' || value_arg || ' does not exist", "apiVersion":'|| api_version ||'}')::json;
    END IF;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

