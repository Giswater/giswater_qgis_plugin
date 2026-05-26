/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2552

/*
FUNCTION: gw_fct_admin_role_permissions()

PURPOSE:
  Establishes and maintains the complete role hierarchy and permission structure for a
  Giswater database schema. This administrative function creates all standard Giswater
  roles if they don't exist, configures their hierarchical relationships, and grants
  appropriate permissions on database objects (tables, views, sequences, functions).
  Essential for initial database setup and permission maintenance.

PARAMETERS:
  None

RETURN:
  void: Function completes silently on success, raises exception on failure

HANDLES:
  Roles (created with hierarchical inheritance):
    - role_basic: Base role with SELECT permissions (all other roles inherit from this)
    - role_om: Operations & Maintenance (inherits: role_basic)
    - role_edit: Editing capabilities (inherits: role_om)
    - role_epa: EPA modeling capabilities (inherits: role_edit)
    - role_plan: Planning capabilities (inherits: role_epa)
    - role_admin: Administrative capabilities (inherits: role_plan)
    - role_system: System-level operations (inherits: role_admin)
    - role_crm: Customer Relationship Management (standalone role)
  
  Permissions:
    - Database connection grants
    - Schema access (main schema and optional utils schema)
    - Table/View SELECT for role_basic, specific grants per sys_table.sys_role
    - Sequence ALL permissions
    - Function execution permissions
    - Special handling for VPN database users (per admin_vpn_permissions config)
    - Publish user permissions (per admin_publish_user config)

EXAMPLE USAGE:
  SELECT SCHEMA_NAME.gw_fct_admin_role_permissions();

NOTES:
  - Must be executed by a superuser or role owner
  - Role hierarchy ensures cascading permissions (e.g., role_admin inherits all lower permissions)
  - Grants role_admin to postgres user and current superuser automatically
  - VPN mode (admin_vpn_permissions): revokes database access from role_basic, grants individually per cat_users
  - Publish user receives generic SELECT permissions across all tables
  - Processes optional utils schema if admin_utils_schema config is enabled
  - Uses sys_table catalog to determine role-specific table permissions
  - ALTER DEFAULT PRIVILEGES ensures future tables inherit role_basic SELECT permissions
  - Functions receive ALL permissions (note: may be downgraded to SELECT in future versions)
*/

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_role_permissions();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_role_permissions() RETURNS void AS
$BODY$

DECLARE

v_roleexists text;
v_dbnname varchar;
v_schema_array name[];
v_schemaname varchar;
v_tablerecord record;
v_project_type text;
v_query_text text;
v_function_name text;
v_apiservice boolean;
v_rolepermissions boolean;
v_publishuser varchar;
v_vpn_dbuser boolean;
v_error_context text;
rec_user record;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- Looking for project type
	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	v_dbnname =  (SELECT current_database());
	v_schema_array := current_schemas(FALSE);
	v_schemaname :=v_schema_array[1];

	v_vpn_dbuser = (SELECT value::boolean FROM config_param_system WHERE parameter='admin_vpn_permissions');

	-- Create (if not exists) roles and grant permissions
	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_basic';
	IF v_roleexists is null THEN
		CREATE ROLE "role_basic" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;
	ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMA_NAME GRANT SELECT ON TABLES TO role_basic;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_om';
	IF v_roleexists is null THEN
		CREATE ROLE "role_om" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_basic TO role_om;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_edit';
	IF v_roleexists is null THEN
		CREATE ROLE "role_edit" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_om TO role_edit;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_epa';
	IF v_roleexists is null THEN
		CREATE ROLE "role_epa" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_edit TO role_epa;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_plan';
	IF v_roleexists is null THEN
		CREATE ROLE "role_plan" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_epa TO role_plan;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_admin';
	IF v_roleexists is null THEN
		CREATE ROLE "role_admin" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_plan TO role_admin;
		-- Grant role admin to postgres user
		GRANT role_admin TO postgres;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_system';
	IF v_roleexists is null THEN
		CREATE ROLE "role_system" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
		GRANT role_admin TO role_system;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_crm';
	IF v_roleexists is null THEN
		CREATE ROLE "role_crm" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	-- Assign role admin to current user
	IF 'role_admin' NOT IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) and
	(select rolsuper from pg_roles where rolname = current_user) is true THEN
		GRANT role_admin TO current_user;
	END IF;


	-- Grant generic permissions
	IF v_vpn_dbuser THEN

		v_query_text:= 'REVOKE ALL ON DATABASE "'||v_dbnname||'" FROM "role_basic";';
		EXECUTE v_query_text;

		FOR rec_user IN (SELECT * FROM cat_users WHERE active IS TRUE) LOOP
			v_query_text:= 'GRANT ALL ON DATABASE "'||v_dbnname||'" TO '||rec_user.id||';';
			EXECUTE v_query_text;
		END LOOP;
	ELSE
		v_query_text:= 'GRANT ALL ON DATABASE "'||v_dbnname||'" TO "role_basic";';
		EXECUTE v_query_text;
	END IF;

	v_query_text:= 'GRANT ALL ON SCHEMA '||v_schemaname||' TO "role_basic";';
	EXECUTE v_query_text;

	v_query_text:= 'GRANT SELECT ON ALL TABLES IN SCHEMA '||v_schemaname||' TO "role_basic";';
	EXECUTE v_query_text;

	v_query_text:= 'GRANT ALL ON ALL SEQUENCES IN SCHEMA  '||v_schemaname||' TO "role_basic";';
	EXECUTE v_query_text;

	-- Grant all in order to ensure the functionality. We need to review the catalog function before downgrade ALL to SELECT
	v_query_text:= 'GRANT ALL ON ALL FUNCTIONS IN SCHEMA '||v_schemaname||' TO role_basic';
	EXECUTE v_query_text;

	-- Grant specificic permissions for tables
	FOR v_tablerecord IN SELECT * FROM sys_table WHERE sys_role IS NOT NULL AND id IN
	(SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname = 'SCHEMA_NAME'
	UNION
	SELECT viewname FROM pg_catalog.pg_views WHERE schemaname != 'pg_catalog' AND schemaname = 'SCHEMA_NAME')

	LOOP
		v_query_text:= 'GRANT ALL ON TABLE '||v_tablerecord.id||' TO '||v_tablerecord.sys_role||';';
		EXECUTE v_query_text;
	END LOOP;

	-- role permissions for admin_publish_user
	v_publishuser = (SELECT value FROM config_param_system WHERE parameter='admin_publish_user');
	IF v_publishuser IS NOT NULL THEN

        -- Grant generic permissions
        v_query_text:= 'GRANT ALL ON DATABASE '||v_dbnname||' TO '||v_publishuser;
        EXECUTE v_query_text;

		v_query_text:= 'GRANT ALL ON SCHEMA '||v_schemaname||' TO '||v_publishuser;
		EXECUTE v_query_text;

		v_query_text:= 'GRANT SELECT ON ALL TABLES IN SCHEMA '||v_schemaname||' TO '||v_publishuser;
		EXECUTE v_query_text;

	END IF;

	--check if exists schem utils and recreate permissions
  EXECUTE 'SELECT EXISTS (select * from pg_catalog.pg_namespace where nspname = ''utils'');'
  INTO v_query_text;

  IF v_query_text = 't' or v_query_text = 'true' THEN
   	EXECUTE 'SELECT value::boolean FROM config_param_system WHERE parameter=''admin_utils_schema'';'
    INTO v_query_text;
  END IF;

  IF v_query_text = 't' or v_query_text = 'true'  THEN
  	--Grant to role_basic
 		v_query_text:= 'GRANT ALL ON SCHEMA utils TO "role_basic";';
		EXECUTE v_query_text;

		v_query_text:= 'GRANT SELECT ON ALL TABLES IN SCHEMA utils TO "role_basic";';
		EXECUTE v_query_text;

		v_query_text:= 'GRANT ALL ON ALL SEQUENCES IN SCHEMA  utils TO "role_basic";';
		EXECUTE v_query_text;

		v_query_text:= 'GRANT ALL ON ALL FUNCTIONS IN SCHEMA utils TO role_basic';
		EXECUTE v_query_text;

		-- Grant specificic permissions for tables
		FOR v_tablerecord IN SELECT * FROM utils.sys_table WHERE sys_role IS NOT NULL AND id IN
		(SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname = 'utils'
		UNION
		SELECT viewname FROM pg_catalog.pg_views WHERE schemaname != 'pg_catalog' AND schemaname = 'utils') LOOP
			v_query_text:= 'GRANT ALL ON TABLE utils.'||v_tablerecord.id||' TO '||v_tablerecord.sys_role||';';
			EXECUTE v_query_text;
		END LOOP;

  END IF;
	RETURN ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
