/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3496

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_check_linked_mapzones(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_linked_mapzones(p_data json)
  RETURNS json AS
$BODY$

/* example

*/

DECLARE

	-- system
	v_project_type text;
	v_version text;
	v_query_text text;

	-- parameters
	v_mapzone_name text;
	v_mapzone_id text;

	--
	v_field_name text;
	v_count int;

BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get project type and version
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get input parameters:
	v_mapzone_name := (p_data ->> 'parameters')::json->>'mapzoneName';
	v_mapzone_id := (p_data ->> 'parameters')::json->>'mapzoneId';

	v_field_name := lower(v_mapzone_name) || '_id';

	v_query_text := '
		SELECT 1 FROM arc WHERE ' || quote_ident(v_field_name) || ' = ' || quote_literal(v_mapzone_id) || '
		UNION
		SELECT 1 FROM connec WHERE ' || quote_ident(v_field_name) || ' = ' || quote_literal(v_mapzone_id) || '
		UNION
		SELECT 1 FROM node WHERE ' || quote_ident(v_field_name) || ' = ' || quote_literal(v_mapzone_id) || '
		UNION
		SELECT 1 FROM link WHERE ' || quote_ident(v_field_name) || ' = ' || quote_literal(v_mapzone_id) || '
	';
	IF v_project_type = 'UD' THEN
		v_query_text := v_query_text || '
		UNION
		SELECT 1 FROM gully WHERE ' || quote_ident(v_field_name) || ' = ' || quote_literal(v_mapzone_id) || '
		';
	END IF;

	-- Use EXECUTE to run the dynamic SQL and check if any rows exist
	EXECUTE 'SELECT COUNT(*) FROM (' || v_query_text || ') t' INTO v_count;

	IF v_count > 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4334", "function":"3496","parameters":{"mapzone_name":"' || v_mapzone_name || '"}, "is_process":true}}$$);';
	END IF;

	-- Return
	RETURN json_build_object('status', 'Accepted', 'message', 'Mapzone checked', 'version', v_version)::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
