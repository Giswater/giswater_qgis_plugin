/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfoelements"(element_type varchar, tab_type varchar, id varchar, device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_elements json;
    type_element_arg json;
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

--    Get query for elements
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat($1,''_x_'', substring(lower($2) from 4 for 99)) AND device = $3'
        INTO query_result
        USING element_type, tab_type, device;

    raise notice 'query_result %', query_result;

--    Get elements
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || quote_ident(element_type) || '_id' || '::text = $1) a'
        INTO query_result_elements
        USING id;

    raise notice 'query_result_elements %', query_result_elements;

--    Control NULL's
    type_element_arg := COALESCE(type_element_arg, '{}');
    query_result_elements := COALESCE(query_result_elements, '{}');
    
--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||
    ', "elements":' || query_result_elements || '}')::json;
          

--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
  --      RETURN ('{"status":"Failed","SQLERR":' || to_json('Please check the coherence againts config_web_forms table, (*)_x_element/hydro and the primary key (*) for this element'::text) || ', "apiVersion":'|| api_version ||', "SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

