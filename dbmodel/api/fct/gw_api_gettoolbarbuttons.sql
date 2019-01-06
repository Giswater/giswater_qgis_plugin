/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2628


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_gettoolbarbuttons(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_api_gettoolbarbuttons($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"clientbuttons":["lotManager", "visit"]}}$$)
*/


DECLARE
	v_apiversion text;
	v_role text;
	v_projectype text;
	v_clientbuttons text;
	v_buttons json;
		
BEGIN

-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
  
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

-- get input parameter
	v_clientbuttons := (p_data ->> 'data')::json->> 'clientbuttons';

-- get user's role
	-- to do;
	
-- get project type
        SELECT wsoftware INTO v_projectype FROM version LIMIT 1;

-- enable buttons

	--  Harmonize buttons
	v_clientbuttons = concat('{',substring((v_clientbuttons) from 2 for LENGTH(v_clientbuttons)));
	v_clientbuttons = concat('}',substring(reverse(v_clientbuttons) from 2 for LENGTH(v_clientbuttons)));
	v_clientbuttons := reverse(v_clientbuttons);

        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT idval as "buttonName", buttonoptions as  "buttonOptions" 
		FROM SCHEMA_NAME.config_api_toolbar_buttons WHERE (project_type =''utils'' or project_type='||quote_literal(LOWER(v_projectype))||')
		AND idval = any('''||v_clientbuttons||'''::text[]) ) a'
		INTO v_buttons;

--    Control NULL's
	v_buttons := COALESCE(v_buttons, '{}');
	
--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"form":{}'||
		     ',"feature":{}'||
		     ',"data":{"buttons":' || v_buttons ||
				'}}'||
	    '}')::json;
       
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



