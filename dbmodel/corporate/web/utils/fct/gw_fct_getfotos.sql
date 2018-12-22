/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getfotos"(arg_id int4, element_type varchar) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--  Harmonize element_type
    element_type := lower (element_type);
    IF RIGHT (element_type,1)=':' THEN
        element_type := reverse(substring(reverse(element_type) from 2 for 99));
    END IF;

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
        ', "apiVersion":'|| api_version ||
        ', "photos":' || query_result || 
        '}')::json;    

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

