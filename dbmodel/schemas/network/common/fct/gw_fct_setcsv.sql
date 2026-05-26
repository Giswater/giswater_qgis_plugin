/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
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
v_separator text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	
	--get decimal separator
	v_separator = ((p_data ->>'data')::json->>'separator')::text;

	-- getting input data values	
	v_fields = ((p_data ->>'data')::json->>'values')::json;
	FOR rec IN SELECT json_array_elements(v_fields) LOOP
		keys = '';
		_values = '';
		-- get columns name and values
		FOR _key, _value IN SELECT * FROM json_each_text(rec) LOOP
			keys = concat(_key,', ',keys);

			IF v_separator = ',' THEN
				IF split_part(_value, ',',1) ~ '^[0-9]' and split_part(_value, ',',2) ~ '^[0-9]' and split_part(_value, ',',3) ='' THEN
					_value=replace(_value,',','.');
				END IF;
			END IF;

			_values = concat('$$',_value,'$$, ',_values);
		
		END LOOP;
		keys = left(keys, -2);
		_values = left(_values, -2);
		
		--control insert nulls insetad of ''
		IF _values ilike '%$$$$%' THEN
			_values=REPLACE(_values, '$$$$', 'NULL');
		END IF;

		query = CONCAT('INSERT INTO temp_csv (', keys, ') VALUES(',_values,')');
		EXECUTE query;
			
	END LOOP;

	
	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Copy done successfully"}, "version":"'||v_version||'","body":{"form":{},"data":{}}}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;