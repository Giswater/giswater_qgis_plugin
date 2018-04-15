CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_inserteventphoto"(visit_id int8, event_id int8, hash varchar, url text, compass float8) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    event_photo_id integer;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Event insert
    INSERT INTO om_visit_event_photo (visit_id, event_id, value, text, compass) VALUES (visit_id, event_id, hash, url, compass) RETURNING id INTO event_photo_id;

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "id":"' || event_photo_id || '"}')::json;    

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

