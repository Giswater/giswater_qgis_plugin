/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getevents"(element_type varchar, device int4, visit_id int8) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_visits json;
    api_version json;


BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get query for visits
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat($1,''_x_visit'') AND device = $2'
        INTO query_result
        USING element_type, device;

raise notice '1 %', query_result;

--    Add visit_id filter
    query_result := query_result || ' WHERE visit_id' || ' = ' || visit_id;
    
--    Get visits
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ') a'
        INTO query_result_visits;
raise notice '1 %', query_result;


--    Control NULL's
    query_result_visits := COALESCE(query_result_visits, '{}');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "events":' || query_result_visits || 
        '}')::json;

--    Exception handling
  --  EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;




END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

