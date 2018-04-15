CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getfotos"(arg_id int4, element_type varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;


--    Visit or event
    IF element_type = 'visit' THEN
        SELECT array_to_json((array_agg(value))) INTO query_result FROM om_visit_event_photo WHERE visit_id = arg_id;
    ELSIF element_type = 'event' THEN
        SELECT array_to_json((array_agg(value))) INTO query_result FROM om_visit_event_photo WHERE event_id = arg_id;
    END IF;


--    Control NULL's
    query_result := COALESCE(query_result, '[]');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "photos":' || query_result || 
        '}')::json;    

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

