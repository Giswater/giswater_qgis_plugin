/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2870

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setselectors (json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setselectors(p_data json)
  RETURNS json AS
$BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_setselectors($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},
"data":{"selector_type":"mincut", "tableName":"anl_mincut_result_selector", "column_id":"result_id", "result_name":"1", "result_value":"True"}}$$) AS result
*/

DECLARE

v_version json;
v_selector_type text;
v_tableName text;
v_column_id text;
v_result_name text;
v_result_value text;
	
BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;
		
	-- Get input parameters:
	v_selector_type := (p_data ->> 'data')::json->> 'selector_type';
	v_tableName := (p_data ->> 'data')::json->> 'tableName';
	v_column_id := (p_data ->> 'data')::json->> 'column_id';
	v_result_name := (p_data ->> 'data')::json->> 'result_name';
	v_result_value := (p_data ->> 'data')::json->> 'result_value';
	
	IF v_result_value = 'True' THEN
		EXECUTE 'INSERT INTO ' || v_tableName || ' ('|| v_column_id ||', cur_user) VALUES('|| v_result_name ||', '''|| current_user ||''')';
	ELSE
		EXECUTE 'DELETE FROM ' || v_tableName || ' WHERE ' || v_column_id || ' = '|| v_result_name ||'';
	END IF;
	
	-- Return
	RETURN ('{"status":"Accepted", "version":'||v_version||
			',"body":{"message":{"priority":1, "text":"This is a test message"}'||
			',"form":{"formName":"", "formLabel":"", "formText":""'||
			',"formActions":[]}'||
			',"feature":{}'||
			',"data":{"indexingLayers": {	"mincut": ["anl_mincut_result_selector", "v_anl_mincut_result_valve", "v_anl_mincut_result_cat", "v_anl_mincut_result_connec", "v_anl_mincut_result_node", "v_anl_mincut_result_arc"],
							"exploitation": ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_element"]
			}}}'||'}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  