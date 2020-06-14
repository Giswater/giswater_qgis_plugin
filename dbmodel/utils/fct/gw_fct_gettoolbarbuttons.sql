/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2628

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_gettoolbarbuttons(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_gettoolbarbuttons(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_fct_gettoolbarbuttons($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"clientbuttons":["lotManager", "visit"]}}$$)
*/

DECLARE

v_version text;
v_role text;
v_projectype text;
v_clientbuttons text;
v_buttons json;
		
BEGIN

	-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
  
	--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

	-- get input parameter
	v_clientbuttons := (p_data ->> 'data')::json->> 'clientbuttons';

	-- get user's role
		
	-- get project type
    SELECT project_type INTO v_projectype FROM sys_version LIMIT 1;

	--  Harmonize buttons
	v_clientbuttons = concat('{',substring((v_clientbuttons) from 2 for LENGTH(v_clientbuttons)));
	v_clientbuttons = concat('}',substring(reverse(v_clientbuttons) from 2 for LENGTH(v_clientbuttons)));
	v_clientbuttons := reverse(v_clientbuttons);

        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT idval as "buttonName", buttonoptions as  "buttonOptions" 
		FROM SCHEMA_NAME.config_api_toolbar_buttons WHERE (project_type =''utils'' or project_type='||quote_literal(LOWER(v_projectype))||')
		AND idval = any('||quote_literal(v_clientbuttons)||'::text[]) ) a'
		INTO v_buttons;

	-- Control NULL's
	v_buttons := COALESCE(v_buttons, '{}');
	
	-- Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"This is a test message"}, "version":'||v_version||
             ',"body":{"form":{}'||
		     ',"feature":{}'||
		     ',"data":{"buttons":' || v_buttons ||
				'}}'||
	    '}')::json;
       
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;



