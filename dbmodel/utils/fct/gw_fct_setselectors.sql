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
SELECT SCHEMA_NAME.gw_fct_setselectors($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{}, "data":{"selectorType":"explfrommuni", "id":2, "value":true, "isAlone":true}}$$);
SELECT * FROM selector_expl
*/

DECLARE

v_version json;
v_selectortype text;
v_tablename text;
v_columnname text;
v_id text;
v_value text;
v_muni integer;
v_isalone boolean;
v_parameter_selector json;
	
BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;
	
	-- Get input parameters:
	v_selectortype := (p_data ->> 'data')::json->> 'selectorType';
	v_id := (p_data ->> 'data')::json->> 'id';
	v_value := (p_data ->> 'data')::json->> 'value';
	v_isalone := (p_data ->> 'data')::json->> 'isAlone';

	-- Get system parameters
	v_parameter_selector = (SELECT value::json FROM config_param_system WHERE parameter = concat('basic_selector_', v_selectortype));
		v_tablename = v_parameter_selector->>'selector';
		v_columnname = v_parameter_selector->>'selector_id'; 

		RAISE NOTICE ' % %', v_tablename, v_columnname;
	
	-- managing is alone
	IF v_isalone THEN
		EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';
	END IF;

	-- managing value
	IF v_value THEN
		EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) VALUES('|| v_id ||', '''|| current_user ||''')';
	ELSE
		EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE ' || v_columnname || ' = '|| v_id ||'';
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
  