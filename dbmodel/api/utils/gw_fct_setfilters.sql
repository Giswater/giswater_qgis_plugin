CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_setfilters"(id_arg int4, status bool, tabname varchar, tabidname varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    event_id integer;
    existing_record integer;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;


--      Check exists and set
    EXECUTE format('SELECT COUNT(*) FROM %I WHERE %I = $1 AND cur_user = current_user', tabName, tabIdName)
    USING id_arg
    INTO existing_record;

    IF status = FALSE THEN
        EXECUTE format('DELETE FROM %I WHERE %I = $1 AND cur_user = current_user', tabName, tabIdName) USING id_arg;
    ELSIF (existing_record) = 0 THEN
        EXECUTE format('INSERT INTO  %I (%I, cur_user) VALUES ($1, current_user);', tabName, tabIdName) USING id_arg;
    END IF;
    
--    Return
    RETURN ('{"status":"Accepted"' ||
        '}')::json;

--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
--        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

