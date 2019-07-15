/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setallfilters(
    fields json,
    tabname character varying,
    tabidname character varying)
  RETURNS json AS
$BODY$
DECLARE

--	Variables
	json_element json;
	api_version text;
	aux_vic text;

BEGIN


--	Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

--	Get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--	Iterate through array elements
	FOR json_element IN SELECT * FROM json_array_elements(fields)
	LOOP 
--		Filter 'all'
		IF json_element->>'name' <> 'select_all' THEN	
			EXECUTE format('SELECT gw_fct_setfilters($1,$2,%L,%L)', tabName, tabIdName)
			USING (json_element->>'name')::INT, (json_element->>'value')::BOOL;
		END IF;
		
	END LOOP;

	
--	Return
	RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||'}')::json;    


--	Exception handling
	EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

