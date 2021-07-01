/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
--FUNCTION CODE: 3014


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setcsv(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

SELECT gw_fct_setcsv($${
"client":{"device":4, "infoType":1, "lang":"ES"}, 
"form":{}, "feature":{}, 
"data":{"filterFields":{}, "pageInfo":{}, 
	"values":[{"fid": 236, "csv1": "113961", "csv2": "38", "csv3": "50"},
		  {"fid": 236, "csv1": "113961", "csv2": "38", "csv3": "50"}]}}$$);
*/

DECLARE
v_version text;
v_error_context text;

v_fields json;
rec json;
_key text;
_value text;
keys text;
_values text;
query text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data values	
	v_fields = ((p_data ->>'data')::json->>'values')::json;
	FOR rec IN SELECT json_array_elements(v_fields) LOOP
		keys = '';
		_values = '';
		-- get columns name and values
		FOR _key, _value IN SELECT * FROM json_each_text(rec) LOOP
			raise notice '_value-->%',_value;
			keys = concat(_key,', ',keys);
			_values = concat('$$',_value,'$$, ',_values);
		
		END LOOP;
		keys = left(keys, -2);
		_values = left(_values, -2);
		query = CONCAT('INSERT INTO temp_csv (', keys, ') VALUES(',_values,')');
		EXECUTE query;
			
	END LOOP;

	
	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Copy done successfully"}, "version":"'||v_version||'","body":{"form":{},"data":{}}}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;