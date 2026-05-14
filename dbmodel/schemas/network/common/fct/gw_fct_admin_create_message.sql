/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3308

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_create_message(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_create_message(p_data json)
  RETURNS json AS
$BODY$

/*
* EXAMPLE
SELECT gw_fct_admin_create_message($${"data":{"error_message":"Arc not found",
                    "hint_message":"Please check table arc", "log_level":"2",
                    "show_user":"TRUE", "project_type":"utils","source":"core"}}$$);
*/

DECLARE
	v_schemaname text;
	v_project_type text;
	v_version text;
	v_id integer;
	v_error_message text;
	v_hint_message text;
	v_log_level integer;
	v_show_user boolean;
	v_project_type_data text;
	v_source text;
	v_insert_query text;
	v_get_message_query text;
	v_result_json text;
BEGIN

	SET search_path = 'SCHEMA_NAME', public;
	v_schemaname := 'SCHEMA_NAME';

	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get max id value and increment by 2
	SELECT (MAX(id) + 2) INTO v_id FROM sys_message;

	-- Extract values from JSON
	v_error_message := ((p_data ->>'data')::json->>'error_message')::text;
	v_hint_message := ((p_data ->>'data')::json->>'hint_message')::text;
	v_log_level := ((p_data ->>'data')::json->>'log_level')::integer;
	v_show_user := ((p_data ->>'data')::json->>'show_user')::boolean;
	v_project_type_data := ((p_data ->>'data')::json->>'project_type')::text;
	v_source := ((p_data ->>'data')::json->>'source')::text;

	-- Control NULL's
	IF v_error_message IS NULL THEN
	v_error_message := '';
	END IF;
	IF v_hint_message IS NULL THEN
	v_hint_message := '';
	END IF;
	IF v_log_level IS NULL THEN
	v_log_level := 0;
	END IF;
	IF v_show_user IS NULL THEN
	v_show_user := FALSE;
	END IF;
	IF v_project_type_data IS NULL THEN
	v_project_type_data := '';
	END IF;
	IF v_source IS NULL THEN
	v_source := '';
	END IF;

	-- Create insert query string
	v_insert_query := 'INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, source) VALUES (' ||
					v_id || ', ' ||
					quote_literal(v_error_message) || ', ' ||
					quote_literal(v_hint_message) || ', ' ||
					v_log_level || ', ' ||
					v_show_user || ', ' ||
					quote_literal(v_project_type_data) || ', ' ||
					quote_literal(v_source) || ');';


	-- Create get message query string
	v_get_message_query := 'SELECT gw_fct_getmessage($$' ||
							'{"client":{"device":4,"infoType":1,"lang":"ES"},' ||
							'"feature":{},' ||
							'"data":{"message":"' || v_id || '","function":"","parameters":null,"is_process":true}}' ||
							'$$);';

	v_result_json := '{"insert_query": ' || v_insert_query || ', "get_message_query": ' || v_get_message_query || '}';

	RETURN v_result_json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

