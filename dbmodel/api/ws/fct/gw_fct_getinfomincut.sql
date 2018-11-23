/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfomincut"(p_element_type varchar, id varchar, mincut_start timestamp, mincut_end timestamp, device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_mincuts json;
    api_version json;

    
BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--    get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;
        
--    Harmonize element_type
    p_element_type := lower (p_element_type);
    IF RIGHT (p_element_type,1)=':' THEN
        p_element_type := reverse(substring(reverse(p_element_type) from 2 for 99));
    END IF;

--    Get query for mincut
    EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = concat($1,''_x_mincut'') AND device = $2'
        INTO query_result
        USING p_element_type, device;


--    Add id filter
    query_result := query_result || ' WHERE ' || quote_ident( p_element_type || '_id') || ' = ' || quote_literal(id);

--    Add visit_start filter
    IF mincut_start IS NOT NULL THEN
        query_result := query_result || ' AND received_date >= ' || quote_literal(mincut_start::TIMESTAMP(6));
    END IF;

--    Add visit_end filter
    IF mincut_end IS NOT NULL THEN
        query_result := query_result || ' AND received_date <= ' || quote_literal(mincut_end::TIMESTAMP(6));
    END IF;

RAISE NOTICE 'Res: %', query_result;

--    Get mincuts with just date filters
    EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' ORDER BY "result_id" DESC) a'
        INTO query_result_mincuts
        USING id;

--    Control NULL's
    query_result_mincuts := COALESCE(query_result_mincuts, '{}');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "mincuts":' || query_result_mincuts || 
        '}')::json;    


--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
--        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

