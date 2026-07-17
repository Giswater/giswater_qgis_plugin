/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

RESET ROLE;

--
-- TOC entry 10 (class 2615 OID 151924)
-- Name: SCHEMA_NAME; Type: SCHEMA; Schema: -; Owner: -
--

-- The postgis extension is checked when connection is stablished. In case of does not exists, it tries to create. In case of failure, message is reported

CREATE EXTENSION IF NOT EXISTS tablefunc;

CREATE EXTENSION IF NOT EXISTS pgrouting;

CREATE EXTENSION IF NOT EXISTS unaccent;

DO $$
DECLARE
	v_role_exists boolean;
BEGIN
    	-- Create roles if missing; always (re)apply hierarchy grants (idempotent)
	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_basic') into v_role_exists;
	IF NOT v_role_exists THEN
		CREATE ROLE "role_basic" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_om') into v_role_exists;
	IF NOT v_role_exists THEN
		CREATE ROLE "role_om" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_edit') into v_role_exists;
	IF NOT v_role_exists THEN
		CREATE ROLE "role_edit" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_epa') into v_role_exists;
	IF NOT v_role_exists THEN
		CREATE ROLE "role_epa" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_plan') into v_role_exists;
	IF NOT v_role_exists THEN
		CREATE ROLE "role_plan" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_admin') into v_role_exists;
	IF NOT v_role_exists THEN
		CREATE ROLE "role_admin" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_system') into v_role_exists;
	IF NOT v_role_exists THEN
		CREATE ROLE "role_system" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_crm') into v_role_exists;
	IF NOT v_role_exists THEN
		CREATE ROLE "role_crm" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	GRANT role_basic TO role_om;
	GRANT role_om TO role_edit;
	GRANT role_edit TO role_epa;
	GRANT role_epa TO role_plan;
	GRANT role_plan TO role_admin;
	GRANT role_admin TO role_system;

	-- Assign role_system to current superuser installer
	IF 'role_system' NOT IN (SELECT rolname FROM pg_roles WHERE pg_has_role(current_user, oid, 'member'))
		AND (SELECT rolsuper FROM pg_roles WHERE rolname = current_user) IS TRUE THEN
		GRANT role_system TO current_user;
	END IF;
END$$;

-- Schema must be created by a role with CREATE ON DATABASE (installer).
-- role_system owns objects but does not need database-level CREATE.
CREATE SCHEMA "SCHEMA_NAME" AUTHORIZATION role_system;

SET ROLE role_system;

ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMA_NAME GRANT SELECT ON TABLES TO role_basic;
