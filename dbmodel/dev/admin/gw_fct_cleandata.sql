/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_cleandata(p_data json) RETURNS json AS 
$BODY$

/*EXAMPLE

--Replace '' with NULL.

--clean all tables in schema
SELECT SCHEMA_NAME.gw_fct_cleandata($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_man_wjoin", "id":["1004","1005"]},
"data":{"parameters":{"table":["ALL"]}}}$$)

--clean parent tables + addfields
SELECT SCHEMA_NAME.gw_fct_cleandata($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_man_wjoin", "id":["1004","1005"]},
"data":{"parameters":{"table":["BASIC"]}}}$$)

--clean listed tables
SELECT SCHEMA_NAME.gw_fct_cleandata($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_man_wjoin", "id":["1004","1005"]},
"data":{"parameters":{"table":["man_valve", "node"]}}}$$)

*/

DECLARE

v_table text;
v_table_array text[];
v_version text;
v_result json;
v_result_info json;
v_result_point json;
v_error_context text;
rec_table text;
rec_column  text;
v_schema text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_schema='SCHEMA_NAME';
	-- select version
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;

	-- getting input data 	
	v_table :=  (((p_data ->>'data')::json->>'parameters')::json->>'table')::text;
	v_table_array = ARRAY(SELECT json_array_elements_text(v_table::json)); 		

	IF v_table_array = '{BASIC}' THEN
		v_table_array = '{arc, node, connec, man_addfields_value}';
	ELSIF v_table_array = '{ALL}' THEN
		EXECUTE 'SELECT array_agg(table_name::TEXT) FROM information_schema.tables 
		WHERE table_schema = '||quote_literal(v_schema)||' and table_type = ''BASE TABLE'''
		INTO v_table_array;
	END IF;

	FOREACH rec_table IN array(v_table_array) LOOP

		FOR rec_column IN EXECUTE 'SELECT column_name FROM information_schema.columns WHERE table_schema = '||quote_literal(v_schema)||' 
		AND table_name= '||quote_literal(rec_table)||' AND is_nullable = ''YES'' AND data_type in (''character varying'', ''text'')' LOOP
			
			EXECUTE 'UPDATE '||rec_table||' SET '||rec_column||' = NULL WHERE '||rec_column||' ='''';';
		
		END LOOP;

	END LOOP;
	

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Clean data done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
			'}}'||
	    '}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;