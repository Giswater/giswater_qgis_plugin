CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getevent"(event_id int8, arc_id varchar, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    form_data json;
    event_data record;
    event_data_json json;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get event data
    SELECT * INTO event_data FROM om_visit_event WHERE id = event_id;
    event_data_json := row_to_json(event_data);

--    Get form data
    form_data := gw_fct_geteventform(event_data.parameter_id, arc_id, lang);

--    Control NULL's
    event_data_json := COALESCE(event_data_json, '{}');
    form_data := COALESCE(form_data, '{}');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "event_data":' || event_data_json || 
        ', "form_data":' || form_data ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;



END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

