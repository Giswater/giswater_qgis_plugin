/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_insertevent"(value_arg varchar, visit_id int4, position_id varchar, position_value float8, parameter_id varchar, value1 int4, value2 int4, geom1 float8, geom2 float8, geom3 float8, text_arg text, client_type varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    event_id integer;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Event insert
    INSERT INTO om_visit_event (visit_id, position_id, position_value, parameter_id, value, value1, value2, geom1, geom2, geom3, text) VALUES (visit_id, position_id, position_value, parameter_id, value_arg, value1, value2, geom1, geom2, geom3, text_arg) RETURNING id INTO event_id;

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "id":"' || event_id || '"}')::json;    

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

