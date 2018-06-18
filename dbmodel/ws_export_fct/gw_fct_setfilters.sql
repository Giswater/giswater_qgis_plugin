CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_setfilters"(id_arg int4, status bool, tabname varchar, tabidname varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    event_id integer;
    existing_record integer;
    api_version text;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    --  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


--      Check exists and set
    EXECUTE format('SELECT COUNT(*) FROM %I WHERE %I = $1 AND cur_user = current_user', tabName, tabIdName)
    USING id_arg
    INTO existing_record;

    IF status = FALSE THEN
        EXECUTE format('DELETE FROM %I WHERE %I = $1 AND cur_user = current_user', tabName, tabIdName) USING id_arg;
    ELSIF (existing_record) = 0 THEN
        EXECUTE format('INSERT INTO  %I (%I, cur_user) VALUES ($1, current_user);', tabName, tabIdName) USING id_arg;
    END IF;
    
  --Return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||'}')::json;    


--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

