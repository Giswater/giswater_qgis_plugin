CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_geteventform"(parameter_id varchar, arc_id varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    formToDisplay character varying;
    position json;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--    Get form:
    SELECT form_type INTO query_result FROM om_visit_parameter WHERE id = parameter_id;

--    Case
    CASE query_result

    WHEN 'event_standard' THEN

        formToDisplay := 'F22';

    WHEN 'event_ud_arc_standard' THEN

        formToDisplay := 'F23';

    WHEN  'event_ud_arc_rehabit' THEN

        formToDisplay := 'F24';

    ELSE
        RETURN ('{"status":"Failed","message":"Form does not exist"}')::json;
    END CASE;

--    Position
    IF arc_id IS NOT NULL THEN

--        Get node_1
        EXECUTE 'SELECT array_to_json(ARRAY[node_1, node_2]) FROM SCHEMA_NAME.arc WHERE arc_id = $1'
            INTO position
            USING arc_id;

    END IF;
    


--    Control NULL's
    formToDisplay := COALESCE(formToDisplay, '');
    position := COALESCE(position, '[]');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "formToDisplay":"' || formToDisplay || '"' ||
        ', "position":' || position ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

