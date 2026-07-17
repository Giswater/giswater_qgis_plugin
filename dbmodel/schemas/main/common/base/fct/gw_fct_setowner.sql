/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3024

/*
FUNCTION: gw_fct_setowner(p_data json)

PURPOSE:
  Transfers ownership of all database objects within the current schema to a new role
  using a JSON-based interface. This API function provides a standardized way to
  perform ownership transfer operations, integrating with Giswater's client-server
  architecture for schema administration and role management tasks.

PARAMETERS:
  - p_data (json): JSON object containing:
    * client.lang (text): Client language code (e.g., "ES", "EN")
    * data.owner (text): Name of the role that will become the new owner

RETURN:
  json: Standardized response object containing:
    * status: Operation status ("Accepted" on success)
    * message: Result message with level and text
    * version: Giswater version number
    * body: Additional data including form and info objects

HANDLES:
  - Schema ownership
  - Tables, views and materialized views (sys_table joined to pg_class)
  - Standalone sequences (pg_class, excluding owned-by-column)
  - Functions (pg_proc identity signatures)

EXAMPLE USAGE:
  SELECT SCHEMA_NAME.gw_fct_setowner($${"data":{"owner":"role_system"}}$$);

NOTES:
  - The executing user must have sufficient privileges to change ownership
  - The target role must already exist in the database
  - sys_table is processed first to ensure catalog integrity
  - Object discovery uses pg_catalog (pg_class, pg_proc), not information_schema
  - Function ownership uses pg_proc identity signatures (avoids sys_function type-name drift)
  - Returns Giswater-standard JSON response for client integration
  - Sequences owned by table columns (SERIAL/IDENTITY) transfer via ALTER TABLE ... OWNER TO
  - Standalone sequences are transferred with ALTER SEQUENCE ... OWNER TO
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setowner(p_data json)
  RETURNS json AS
$BODY$



DECLARE

rec record;
v_owner text;
v_schema text;
v_version text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_owner = ((p_data ->>'data')::json->>'owner')::text;
	v_schema = 'SCHEMA_NAME';

	SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;

	EXECUTE format('ALTER SCHEMA %I OWNER TO %I', v_schema, v_owner);

	-- force change sys_table owner before
	EXECUTE format('ALTER TABLE IF EXISTS %I.sys_table OWNER TO %I', v_schema, v_owner);

	FOR rec IN
		SELECT c.relname, c.relkind
		FROM sys_table s
		JOIN pg_class c ON c.relname = s.id
		JOIN pg_namespace n ON n.oid = c.relnamespace
		WHERE n.nspname = v_schema
		AND c.relkind IN ('r', 'p', 'f', 'v', 'm')
		ORDER BY s.id
	LOOP
		IF rec.relname = 'sys_table' THEN
			CONTINUE;
		END IF;
		IF rec.relkind IN ('r', 'p', 'f') THEN
			EXECUTE format('ALTER TABLE IF EXISTS %I.%I OWNER TO %I', v_schema, rec.relname, v_owner);
		ELSIF rec.relkind = 'v' THEN
			EXECUTE format('ALTER VIEW IF EXISTS %I.%I OWNER TO %I', v_schema, rec.relname, v_owner);
		ELSIF rec.relkind = 'm' THEN
			EXECUTE format('ALTER MATERIALIZED VIEW IF EXISTS %I.%I OWNER TO %I', v_schema, rec.relname, v_owner);
		END IF;
	END LOOP;

	FOR rec IN
		SELECT c.relname
		FROM pg_class c
		JOIN pg_namespace n ON n.oid = c.relnamespace
		WHERE n.nspname = v_schema
		AND c.relkind = 'S'
		AND NOT EXISTS (
			SELECT 1 FROM pg_depend d
			WHERE d.objid = c.oid
			AND d.deptype = 'a'
			AND d.refobjsubid <> 0
		)
	LOOP
		EXECUTE format('ALTER SEQUENCE IF EXISTS %I.%I OWNER TO %I', v_schema, rec.relname, v_owner);
	END LOOP;

	FOR rec IN
		SELECT p.oid::regprocedure::text AS func_sig
		FROM pg_proc p
		JOIN pg_namespace n ON n.oid = p.pronamespace
		WHERE n.nspname = v_schema
	LOOP
		EXECUTE format('ALTER FUNCTION %s OWNER TO %I', rec.func_sig, v_owner);
	END LOOP;

	--  Return
	RETURN json_build_object(
		'status', 'Accepted',
		'message', json_build_object('level', 1, 'text', 'Set owner done successfully'),
		'version', v_version,
		'body', json_build_object(
			'form', json_build_object(),
			'data', json_build_object('info', json_build_object())
		)
	);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
