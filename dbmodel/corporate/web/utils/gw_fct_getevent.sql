/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getevent"(event_id int8, arc_id varchar, lang varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    form_data json;
    event_data record;
    event_data_json json;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

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
        ', "apiVersion":'|| api_version ||
        ', "event_data":' || event_data_json || 
        ', "form_data":' || form_data ||
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;



END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

