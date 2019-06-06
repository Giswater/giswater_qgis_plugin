/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP FUNCTION IF EXISTS "SCHEMA_NAME"."gw_fct_getinfoelements"(varchar, varchar, varchar, int4);

CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_getinfoelements"(element_type varchar, tab_type varchar, id varchar, p_device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

--    Variables
    query_result character varying;
    query_result_elements json;
    type_element_arg json;
    api_version json;
    v_key text;
    v_keyquerytext text;
    v_querytext text;
    v_idname text;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

	v_key = (SELECT value::json->>'key' FROM config_param_system WHERE parameter='api_getinfoelements');
	v_keyquerytext = (SELECT value::json->>'queryText' FROM config_param_system WHERE parameter='api_getinfoelements');
	v_idname = (SELECT value::json->>'idName' FROM config_param_system WHERE parameter='api_getinfoelements');
	

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
            INTO api_version;

--  Harmonize element_type
    element_type := lower (element_type);
    IF RIGHT (element_type,1)=':' THEN
        element_type := reverse(substring(reverse(element_type) from 2 for 99));
    END IF;   

     SELECT query_text INTO v_querytext FROM config_web_forms WHERE table_id = concat(element_type,'_x_', substring(lower(tab_type) from 4 for 99)) AND device = p_device;

     IF v_querytext IS NOT NULL THEN
	--EXECUTE v_querytext INTO query_result;

	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || (v_querytext) || ' WHERE ' || quote_ident(element_type) || '_id' || '::text = $1) a'
        INTO query_result_elements
        USING id;
	
     ELSE 

	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || (v_keyquerytext) || ' AND ' || quote_ident(v_idname) || '::text = $1) a'
        INTO query_result_elements
        USING id;

     END IF;
        

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


