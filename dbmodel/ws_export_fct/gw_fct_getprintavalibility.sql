CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getprintavalibility"(device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    formTabs text;
    api_version json;
    v_firsttab boolean=true;

BEGIN


-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

-- Start the construction of the tabs array
    formTabs := '[';

-- Finish the construction of the tabs array
    formTabs := formTabs ||']';


-- Check null
    formTabs := COALESCE(formTabs, '[]');    

-- Return
    IF v_firsttab IS FALSE THEN
        -- Return not implemented
        RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "enabled":false'||
        '}')::json;
    ELSE 
        -- Return formtabs
        RETURN ('{"status":"Accepted"' ||
            ', "apiVersion":'|| api_version ||
            ', "enabled":true'||
            '}')::json;
    END IF;

-- Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

