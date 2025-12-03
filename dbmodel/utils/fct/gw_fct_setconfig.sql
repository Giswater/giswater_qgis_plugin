/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2606

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setconfig(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setconfig(p_data json)
  RETURNS json AS
$BODY$

/*
--example for config button
SELECT SCHEMA_NAME.gw_fct_setconfig($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"config"},
"feature":{},
"data":{"fields":[{"widget":"", "value":"", "chk":"", "isChecked":"", "sysRoleId":""},{"widget":"", "value":"", "chk":"", "isChecked":"", "sysRoleId":""}]}}$$)

--example for epaoptions button
SELECT SCHEMA_NAME.gw_fct_setconfig($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"epaoptions"},
"feature":{},
"data":{"fields":{"widget":"", "value":""}}}$$)
*/

DECLARE

schemas_array name[];
v_version text;
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
v_widgettype text;
v_uservalues json;

BEGIN

	-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

	-- get api version
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- fix diferent ways to say null on client
    p_data = REPLACE (p_data::text, '"NULL"', 'null');
    p_data = REPLACE (p_data::text, '"null"', 'null');
    p_data = REPLACE (p_data::text, '""', 'null');
    p_data = REPLACE (p_data::text, '''''', 'null');
    p_data = REPLACE (p_data::text, '''''', 'null');

	--  Get project type
    SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	--  Get schema name
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
	v_widgettype:= (SELECT (v_json ->> 'widget_type')) ;

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

			IF v_widgettype = 'check' THEN
				EXECUTE 'UPDATE '|| quote_ident(v_table) ||' SET value = $1 WHERE parameter = $2 AND cur_user=current_user'
				USING  v_value, v_widget;
			ELSE
				IF result IS NOT NULL THEN

				EXECUTE 'DELETE FROM '|| quote_ident(v_table) ||' WHERE parameter = $1 AND cur_user=current_user'
				USING v_widget;

				END IF;
			END IF;
		ELSIF v_formname = 'epaoptions' THEN
			IF result IS NOT NULL THEN
				EXECUTE 'UPDATE '|| quote_ident(v_table) ||' SET value = $1 WHERE parameter = $2 AND cur_user=current_user'
				USING  v_value, v_widget;
			ELSE
				EXECUTE 'INSERT INTO '|| quote_ident(v_table) ||' (parameter, value, cur_user) VALUES ($1, $2, current_user)'
				USING  v_widget, v_value;
			END IF;
		END IF;
	END IF;
   END LOOP;

	-- get uservalues
	PERFORM gw_fct_workspacemanager($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"CHECK"}}$$);
	v_uservalues = (SELECT to_json(array_agg(row_to_json(a))) FROM (SELECT parameter, value FROM config_param_user WHERE parameter IN ('plan_psector_current', 'utils_workspace_current')
	AND cur_user = current_user ORDER BY parameter)a);

	-- Control nulls
	v_uservalues := COALESCE(v_uservalues, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "version":'||v_version||
             ',"body":{"message":{"level":1, "text":"Process done successfully"}'||
			',"form":{}'||
			',"feature":{}'||
			',"data":{ "userValues":'||v_uservalues||'}}'||
	    '}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM),  'version', v_version, 'SQLSTATE', SQLSTATE)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
