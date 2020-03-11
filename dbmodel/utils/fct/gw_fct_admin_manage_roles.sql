/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2810

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_manage_roles(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_roles(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_manage_roles($${
"client":{"device":9, "infoType":100, "lang":"ES"}, 
"form":{}, "data":{"action":"CREATE"}}$$);
*/


DECLARE
v_action text;
v_version text;
v_return json;
	
BEGIN

	SET search_path = 'SCHEMA_NAME' , public;

	SELECT  giswater INTO  v_version FROM version order by id desc limit 1;

	v_action = ((p_data ->>'data')::json->>'action')::text;

	-- creation
	IF v_action = 'CREATE' THEN
		IF (SELECT rolname FROM pg_roles WHERE rolname = 'role_basic') IS NULL THEN CREATE ROLE "role_basic" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION; END IF;
		IF (SELECT rolname FROM pg_roles WHERE rolname = 'role_om') IS NULL THEN CREATE ROLE "role_om" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;END IF;
		IF (SELECT rolname FROM pg_roles WHERE rolname = 'role_edit') IS NULL THEN CREATE ROLE "role_edit" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;END IF;
		IF (SELECT rolname FROM pg_roles WHERE rolname = 'role_epa') IS NULL THEN CREATE ROLE "role_epa" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;END IF;
		IF (SELECT rolname FROM pg_roles WHERE rolname = 'role_master') IS NULL THEN CREATE ROLE "role_master" NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;END IF;
		IF (SELECT rolname FROM pg_roles WHERE rolname = 'role_admin') IS NULL THEN CREATE ROLE "role_admin" SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;END IF;
		IF (SELECT rolname FROM pg_roles WHERE rolname = 'role_crm') IS NULL THEN CREATE ROLE "role_crm" SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;END IF;

		GRANT role_basic TO role_om;
		GRANT role_om TO role_crm;
		GRANT role_om TO role_edit;
		GRANT role_edit TO role_epa;
		GRANT role_epa TO role_master;
		GRANT role_master TO role_admin;
	END IF;
				
	--return definition for v_audit_check_result
	v_return= ('{"status":"Accepted", "message":{"level":1, "text":"Roles managed succesfully"}, "version":""'||
		     ',"body":{"form":{},"data":{}}}')::json;

	RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
