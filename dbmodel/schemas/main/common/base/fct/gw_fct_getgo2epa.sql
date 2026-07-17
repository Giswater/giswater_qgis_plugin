/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2576

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getgo2epa(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getgo2epa(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_fct_getgo2epa($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"go2epa"},
"feature":{},"data":{}}$$)
*/

DECLARE

v_version text;
v_formname text;
v_fields  json[];
v_fields_json json;
   
BEGIN

	-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

	-- get api version
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get input parameters
	v_formname := (p_data ->> 'form')::json->> 'formName';

	-- getting the form widgets
	SELECT gw_fct_getformfields(v_formname, 'form_generic', 'tab_data', null, null, null, null, null,null, null, null)
		INTO v_fields; 

	v_fields_json = array_to_json (v_fields);

	-- Control NULL's
	v_fields := COALESCE(v_fields, '{}');
	v_version := COALESCE(v_version, '');
		
	-- Return
    RETURN ('{"status":"Accepted", "version":"'||v_version||'"'||
             ',"body":{"message":{"level":1, "text":"Process done successfully"}'||
			',"form":{"formName":"", "formLabel":"", "formText":""'||
			',"data":{"fields":' || v_fields_json ||
				'}'||
			'}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;