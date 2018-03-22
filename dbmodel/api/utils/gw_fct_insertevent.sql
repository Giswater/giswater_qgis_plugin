CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_insertevent"(ext_code varchar, visit_id int4, position_id varchar, position_value float8, parameter_id varchar, value_arg varchar, value2 int4, geom1 float8, geom2 float8, geom3 float8, text_arg text) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    event_id integer;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Event insert
    INSERT INTO om_visit_event (ext_code, visit_id, position_id, position_value, parameter_id, value, value2, geom1, geom2, geom3, text) VALUES (ext_code, visit_id, position_id, position_value, parameter_id, value_arg, value2, geom1, geom2, geom3, text_arg) RETURNING id INTO event_id;

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "id":"' || event_id || '"}')::json;    

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

