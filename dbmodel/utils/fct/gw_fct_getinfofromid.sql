	/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2582

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getinfofromid(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfofromid(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
UPSERT FEATURE 
arc no nodes extremals
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_arc_pipe", "inputGeometry":"0102000020E7640000020000000056560000A083198641000000669A33C041000000E829D880410000D0AE90F0F341" },
		"data":{}}$$)
arc with nodes extremals
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_arc_pipe", "inputGeometry":"0102000020E764000002000000998B3C512F881941B28315AA7F76514105968D7D748819419FDF72D781765141" },
		"data":{"addSchema":"SCHEMA_NAME"}}$$)
INFO BASIC
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_arc_pipe", "id":"2001"},
		"data":{}}$$)

SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
		"form":{"editable":"True"}, 
		"feature":{"tableName":"v_edit_arc","id":"2001"},
		"data":{}}$$)

SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_node_junction", "id":"1001"},
		"data":{}}$$)
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_connec_wjoin", "id":"3001"},
		"data":{}}$$)
SELECT SCHEMA_NAME.gw_fct_getinfofromid($${
		"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
		"form":{"editable":"True"},
		"feature":{"tableName":"ve_element", "id":"125101"},
		"data":{}}$$)

SELECT SCHEMA_NAME.gw_fct_getfeatureinsert($${"client":{"device":4, "infoType":1, "lang":"ES","epsg":25831, "cur_user":"test_user"}, "form":{}, "feature":{"tableName":"ve_node_air_valve"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "rolePermissions":"full", "coordinates":{"x1":418957.8771109133, "y1":4576670.596288238}}}$$);

*/

DECLARE


v_return json;
v_error_context text;
BEGIN
	
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- trigger core function
	SELECT gw_fct_infofromid(p_data) INTO v_return;
	
	-- Return
	RETURN v_return;
	
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;