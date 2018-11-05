/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfodocs"(element_type varchar, id varchar, device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

/*EXAMPLE QUERYS
SELECT ws_sample.gw_fct_getinfodocs('node', '1007', 3)
SELECT ws_sample.gw_fct_getinfodocs('arc', '2001', 3)
SELECT ws_sample.gw_fct_getinfodocs('connec', '3004', 3)
*/

--    Variables
    query_result character varying;
    query_result_docs json;
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

--    Get query for docs
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat($1,''_x_doc'') AND device = $2'
        INTO query_result
        USING element_type, device;

--    Get docs
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE ' || quote_ident( element_type || '_id') || '::text = $1) a'
        INTO query_result_docs
        USING id;

--    Control NULL's
    query_result_docs := COALESCE(query_result_docs, '{}');

--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||',"docs":' || query_result_docs || '}')::json;
    RETURN query_result_docs;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;