/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2552

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_role_permissions();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_role_permissions() RETURNS void AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_role_permissions() 
*/

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

rec_user record;

BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- Looking for project type
	SELECT project_type INTO v_project_type FROM sys_version LIMIT 1;
	
	v_dbnname =  (SELECT current_database());
	v_schema_array := current_schemas(FALSE);
	v_schemaname :=v_schema_array[1];
	
	v_vpn_dbuser = (SELECT value::boolean FROM config_param_system WHERE parameter='admin_vpn_permissions');
	
	-- Create (if not exists) roles
	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_basic';
	IF v_roleexists is null THEN
		CREATE ROLE "role_basic" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_om';
	IF v_roleexists is null THEN
		CREATE ROLE "role_om" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_edit';
	IF v_roleexists is null THEN
		CREATE ROLE "role_edit" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_epa';
	IF v_roleexists is null THEN
		CREATE ROLE "role_epa" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_master';
	IF v_roleexists is null THEN
		CREATE ROLE "role_master" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_admin';
	IF v_roleexists is null THEN
		CREATE ROLE "role_admin" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	SELECT rolname into v_roleexists FROM pg_roles WHERE rolname = 'role_crm';
	IF v_roleexists is null THEN
		CREATE ROLE "role_crm" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
	END IF;

	-- Grant permissions
	GRANT role_basic TO role_om;
	GRANT role_om TO role_edit;
	GRANT role_edit TO role_epa;
	GRANT role_epa TO role_master;
	GRANT role_master TO role_admin;

	-- Grant role admin to postgres user
	GRANT role_admin TO postgres; 	

	-- Grant generic permissions
	IF v_vpn_dbuser THEN
	
		v_query_text:= 'REVOKE ALL ON DATABASE '||v_dbnname||' FROM "role_basic";';
		EXECUTE v_query_text;		
			
		FOR rec_user IN (SELECT * FROM cat_users) LOOP
			v_query_text:= 'GRANT ALL ON DATABASE '||v_dbnname||' TO '||rec_user.id||'';
			EXECUTE v_query_text;				
		END LOOP;
	ELSE
		v_query_text:= 'GRANT ALL ON DATABASE '||v_dbnname||' TO "role_basic";';
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

	RETURN ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

