/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2614

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setgo2epa(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_api_setgo2epa($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{},
"data":{"fields":{"widget":"parameter", "value":"3333"}}}$$)
*/

DECLARE
    schemas_array name[];
    api_version json;
    v_text text[];
    json_field json;
    v_widget text;
    v_value text;
    v_json json;
    v_table text;
    v_fields json;
    v_return text;
    v_field text;
    i integer=1;
    text text;
  

BEGIN

-- set search path
    set search_path='SCHEMA_NAME';

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--    Get schema name
    schemas_array := current_schemas(FALSE);
    
    v_fields = ((p_data->>'data')::json->>'fields')::json;

    	raise notice 'v_fields % ', v_fields;

    select array_agg(row_to_json(a)) into v_text from json_each(v_fields)a;

        	raise notice 'v_text % ', v_text;


     FOREACH text IN ARRAY v_text
    LOOP

	-- Get field and value from json
	SELECT v_text [i] into json_field;

	v_field:= (SELECT ((v_text [i])::json ->> 'key')) ;
	v_value:= (SELECT ((v_text [i])::json ->> 'value')) ;

	i=i+1;

	raise notice 'v_field % v_value %', v_field, v_value;
	
	EXECUTE 'UPDATE config_param_user SET value = $1 WHERE parameter = $2 AND cur_user=current_user'
		USING  v_value, v_field;
	
   END LOOP;

/*

    v_fields = ((p_data::json->>'data')::json->>'fields')::json;
    v_table:= 'config_param_user';

    raise notice 'x %', v_fields;

    --FOREACH field IN p_fields
    FOR v_json IN SELECT * FROM json_array_elements(v_fields) as v_text
    LOOP
	-- Get values from json
	v_widget:= (SELECT (v_json ->> 'widget')) ;
	v_value:= (SELECT (v_json ->> 'value')) ;

	EXECUTE 'UPDATE '|| quote_ident(v_table) ||' SET value = $1 WHERE parameter = $2 AND cur_user=current_user'
		USING  v_value, v_widget;
   END LOOP;
   */

--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'||api_version||
             ',"body":{"message":{"priority":1, "text":"This is a test message"}'||
			',"form":{}'||
			',"feature":{}'||
			',"data":{}'||
	    '}}')::json;

      
--    Exception handling
   -- EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
