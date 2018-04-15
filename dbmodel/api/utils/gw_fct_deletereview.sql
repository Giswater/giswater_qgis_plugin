CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_deletereview"(element_type varchar, id int8) RETURNS pg_catalog.json AS $BODY$
DECLARE

    res_delete boolean;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;    


--    Get parameter id
    EXECUTE 'SELECT EXISTS(SELECT 1 FROM review_' || element_type || ' WHERE ' || element_type || '_id = $1)'
    USING id
    INTO res_delete;



--    Return
    IF res_delete THEN

        EXECUTE 'DELETE FROM review_' || element_type || ' WHERE ' || element_type || '_id = $1'
            USING id;

        RETURN ('{"status":"Accepted"}')::json;
    ELSE
        RETURN ('{"status":"Failed","message":"' || element_type || '_id ' || id || ' does not exist"}')::json;
    END IF;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

