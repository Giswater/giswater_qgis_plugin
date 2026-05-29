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

--
-- TOC entry 10 (class 2615 OID 151924)
-- Name: SCHEMA_NAME; Type: SCHEMA; Schema: -; Owner: -
--

-- The postgis extension is checked when connection is stablished. In case of does not exists, it tries to create. In case of failure, message is reported

CREATE EXTENSION IF NOT EXISTS tablefunc;

CREATE EXTENSION IF NOT EXISTS pgrouting;

CREATE EXTENSION IF NOT EXISTS unaccent;

CREATE SCHEMA "SCHEMA_NAME";


DO $$
DECLARE
	v_role_exists boolean;
BEGIN
    	-- Create (if not exists) roles and grant permissions
	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_basic') into v_role_exists;
	IF v_role_exists is null THEN
		CREATE ROLE "role_basic" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;
	ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMA_NAME GRANT SELECT ON TABLES TO role_basic;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_om') into v_role_exists;
	IF v_role_exists is null THEN
		CREATE ROLE "role_om" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_basic TO role_om;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_edit') into v_role_exists;
	IF v_role_exists is null THEN
		CREATE ROLE "role_edit" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_om TO role_edit;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_epa') into v_role_exists;
	IF v_role_exists is null THEN
		CREATE ROLE "role_epa" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_edit TO role_epa;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_plan') into v_role_exists;
	IF v_role_exists is null THEN
		CREATE ROLE "role_plan" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_epa TO role_plan;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_admin') into v_role_exists;
	IF v_role_exists is null THEN
		CREATE ROLE "role_admin" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_plan TO role_admin;
		-- Grant role admin to postgres user
		GRANT role_admin TO postgres;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_system') into v_role_exists;
	IF v_role_exists is null THEN
		CREATE ROLE "role_system" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_admin TO role_system;
	END IF;

	SELECT EXISTS(SELECT rolname FROM pg_roles WHERE rolname = 'role_crm') into v_role_exists;
	IF v_role_exists is null THEN
		CREATE ROLE "role_crm" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	-- Assign role admin to current user
	IF 'role_system' NOT IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) and
	(select rolsuper from pg_roles where rolname = current_user) is true THEN
		GRANT role_system TO current_user;
	END IF;
END$$;