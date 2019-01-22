/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2606

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setconfig(p_data json)
  RETURNS json AS
$BODY$

/*
--example for config button
SELECT SCHEMA_NAME.gw_api_setconfig($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{"formName":"config"},
"feature":{},
"data":{"fields":[{"widget":"", "value":"", "chk":"", "isChecked":"", "sysRoleId":""},{"widget":"", "value":"", "chk":"", "isChecked":"", "sysRoleId":""}]}}$$)

--example for epaoptions button
SELECT SCHEMA_NAME.gw_api_setconfig($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{"formName":"epaoptions"},
"feature":{},
"data":{"fields":{"widget":"", "value":""}}}$$)
*/

DECLARE
    schemas_array name[];
    api_version json;
    v_text text[];
    json_field json;
    v_project_type text;
    v_widget text;
    v_chk text;
    v_value text;
    v_isChecked text;
    v_json json;
    result text;
    v_table text;
    v_fields json;
    v_return text;
    v_formname text;
    text text;

BEGIN

-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--  Get project type
    SELECT wsoftware INTO v_project_type FROM version LIMIT 1;

--    Get schema name
    schemas_array := current_schemas(FALSE);

    v_fields = ((p_data::json->>'data')::json->>'fields')::json;
    v_formname := ((p_data::json->>'form')::json->>'formName');

    raise notice 'v_fields %', v_fields;
	
    FOR v_json IN SELECT * FROM json_array_elements(v_fields) as v_text
    LOOP
    
	-- Get values from json
	v_widget:= (SELECT (v_json ->> 'widget')) ;
	v_chk:= (SELECT (v_json ->> 'chk')) ;
	v_value:= (SELECT (v_json ->> 'value')) ;
	v_isChecked:= (SELECT (v_json ->> 'isChecked')) ;
		
	IF v_json ->> 'sysRoleId' = 'role_admin' THEN
		v_table:= 'config_param_system';

		EXECUTE 'SELECT * FROM '|| quote_ident(v_table) ||' WHERE parameter = $1' 
		INTO result
		USING v_widget;

		IF result IS NOT NULL THEN

		EXECUTE 'UPDATE '|| quote_ident(v_table) ||' SET value = $1 WHERE parameter = $2'
		USING  v_value, v_widget;
		
		END IF;

	ELSE
		v_table:= 'config_param_user';

		EXECUTE 'SELECT * FROM '|| quote_ident(v_table) ||' WHERE parameter = $1 AND cur_user=current_user' 
		INTO result
		USING v_widget;
		RAISE NOTICE 'result: %',result;
		
		-- Perform INSERT
		IF v_isChecked = 'True' THEN

			IF result IS NOT NULL THEN

			EXECUTE 'UPDATE '|| quote_ident(v_table) ||' SET value = $1 WHERE parameter = $2 AND cur_user=current_user'
			USING  v_value, v_widget;
			
			ELSE

			EXECUTE 'INSERT INTO '|| quote_ident(v_table) ||' (parameter, value, cur_user) VALUES ($1, $2, current_user)'
			USING  v_widget, v_value;
			END IF;
			
		ELSIF v_isChecked = 'False' THEN

			IF result IS NOT NULL THEN

			EXECUTE 'DELETE FROM '|| quote_ident(v_table) ||' WHERE parameter = $1 AND cur_user=current_user'
			USING v_widget;
			
			END IF;
		ELSIF v_formname = 'epaoptions' THEN
			EXECUTE 'UPDATE '|| quote_ident(v_table) ||' SET value = $1 WHERE parameter = $2 AND cur_user=current_user'
			USING  v_value, v_widget;
			

		END IF;
	END IF;
	
	RAISE NOTICE 'v_table: %',v_table;

   END LOOP;

--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'||api_version||
             ',"body":{"message":{"priority":1, "text":"This is a test message"}'||
			',"form":{}'||
			',"feature":{}'||
			',"data":{}}'||
	    '}')::json;
	    
--    Exception handling
   -- EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
