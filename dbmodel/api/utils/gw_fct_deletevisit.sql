CREATE OR REPLACE FUNCTION "arbrat_viari"."gw_fct_deletevisit"(visit_id int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

    res_delete boolean;

BEGIN


--    Set search path to local schema
    SET search_path = "arbrat_viari", public;    


--    Get parameter id
    EXECUTE 'SELECT EXISTS(SELECT 1 FROM om_visit WHERE id = $1)'
    USING visit_id
    INTO res_delete;

--    Return
    IF res_delete THEN

        EXECUTE 'DELETE FROM om_visit WHERE id = $1'
            USING visit_id;

        RETURN ('{"status":"Accepted"}')::json;
    ELSE
        RETURN ('{"status":"Failed","message":"visit_id ' || visit_id || ' does not exist"}')::json;
    END IF;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

