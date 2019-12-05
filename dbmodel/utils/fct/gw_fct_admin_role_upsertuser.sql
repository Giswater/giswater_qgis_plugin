/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2780

-- DROP FUNCTION SCHEMA_NAME.gw_fct_admin_role_upsertuser(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_role_upsertuser(p_data json)
  RETURNS integer AS
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_admin_role_upsertuser($${
"client":{"device":9, "infoType":100, "lang":"ES"}, 
"form":{}, 
"data":{"filterFields":{}, "pageInfo":{}, "user_name":"john", "password":"123", "role":"role_basic", "action":"insert", 
"manager_id":["1","2","3"]}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_role_upsertuser($${
"client":{"device":9, "infoType":100, "lang":"ES"}, 
"form":{}, 
"data":{"filterFields":{}, "pageInfo":{}, "user_name":"john", "password":null, "role":"role_om", "action":"update","manager_id":["1"]}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_role_upsertuser($${
"client":{"device":9, "infoType":100, "lang":"ES"}, 
"form":{}, 
"data":{"filterFields":{}, "pageInfo":{}, "user_name":"john", "password":"456", "role":null, "action":"update"}}$$);

SELECT SCHEMA_NAME.gw_fct_admin_role_upsertuser($${
"client":{"device":9, "infoType":100, "lang":"ES"}, 
"form":{}, "data":{"filterFields":{}, "pageInfo":{}, "user_name":"john", "password":null, "role":null, "action":"delete"}}$$);
*/


DECLARE
	v_user_name text;
	v_password text;
	v_role text;
	v_action text;
	v_current_role text;
	v_schema text;
	rec record;
	v_manager json;
	v_manager_array text[];
	rec_manager TEXT;
	v_expl_array integer[];
	rec_expl integer;
	v_current_manager text[];

BEGIN

	SET search_path = 'SCHEMA_NAME' , public;

	v_schema = 'SCHEMA_NAME';

	v_user_name = lower(((p_data ->>'data')::json->>'user_name')::text);
	v_password = ((p_data ->>'data')::json->>'password')::text;
	v_role = ((p_data ->>'data')::json->>'role')::text;
	v_action = ((p_data ->>'data')::json->>'action')::text;
	v_manager = ((p_data->>'data')::json->>'manager_id')::text;
	--change managers list into array
	v_manager_array=(SELECT array_agg(value) AS list FROM json_array_elements_text(v_manager) );
   
	IF v_action = 'insert' THEN


		--create user in  a database, encrypt password and assign a role	
		IF (SELECT 1 FROM pg_roles WHERE rolname=v_user_name) is null THEN
		
			EXECUTE 'CREATE USER '||v_user_name||' WITH ENCRYPTED PASSWORD '''||v_password||''';';
		ELSE
			RETURN audit_function(3040,2780);
		END IF;

		EXECUTE 'GRANT '||v_role||' TO '||v_user_name||';';
		
		
		--insert user into user catalog
		INSERT INTO cat_users (id,name,sys_role) VALUES (v_user_name,v_user_name,v_role) ON CONFLICT (id) DO NOTHING;

		--insert user into related cat_manager and exploitation
		FOREACH rec_manager IN ARRAY v_manager_array LOOP
			UPDATE cat_manager SET username = array_append(username,v_user_name) WHERE id = rec_manager::integer;
		END LOOP;
		

		--insert values for the new user into basic selectors
		EXECUTE 'INSERT INTO selector_state (state_id, cur_user) VALUES (1,'''||v_user_name||''') ON CONFLICT (state_id,cur_user) DO NOTHING';
		EXECUTE 'INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, '''||v_user_name||''' FROM exploitation_x_user WHERE username= '''||v_user_name||''' LIMIT 1 ON CONFLICT (expl_id,cur_user) DO NOTHING';
		

	ElSIF v_action = 'update' THEN

		--assign a new password if its not null
		IF v_password IS NOT NULL THEN

			EXECUTE 'ALTER USER '||v_user_name||' WITH ENCRYPTED PASSWORD '''||v_password||''';';
		END IF;

		--check users current role
		EXECUTE 'SELECT rolname FROM pg_user u JOIN pg_auth_members m ON (m.member = u.usesysid) JOIN pg_roles r ON (r.oid = m.roleid)
		WHERE  u.usename = '''||v_user_name||''';'
		INTO v_current_role;

		--assign a new role if its different than the current one and change values in users catalog
		IF v_role != v_current_role AND v_role IS NOT NULL THEN

			EXECUTE ' REVOKE '||v_current_role||' FROM '||v_user_name||';';

			EXECUTE ' GRANT '||v_role||' TO '||v_user_name||';';

			UPDATE cat_users SET sys_role = v_role WHERE id = v_user_name;
		END IF;

		--check to which manager
		select array_agg(id) into v_current_manager from (select id, username as users from cat_manager) a where v_user_name =any(users);

		--change assignation to managers if it changed
		IF (v_current_manager <> v_manager_array) OR (v_current_manager is null and v_manager_array iS NOT NULL) THEN
			--remove user from current managers
			UPDATE cat_manager SET username = array_remove(username,v_user_name) WHERE v_user_name = any(username);

			--add user to new managers
			FOREACH rec_manager IN ARRAY v_manager_array LOOP
				UPDATE cat_manager SET username = array_append(username,v_user_name) WHERE id = rec_manager::integer;
			END LOOP;
		END IF;


	ElSIF v_action = 'delete' THEN

		--remove values for user from all the selectors and delete user
		FOR rec IN EXECUTE 'SELECT * FROM information_schema.tables WHERE table_name ilike ''%selector%'' AND table_name!=''anl_mincut_selector_valve'' AND table_schema= '''||v_schema||'''' LOOP

			EXECUTE 'DELETE FROM '||rec.table_name||' WHERE cur_user = '''||v_user_name||''';';
		END LOOP;

		--remove user from cat_manager
		UPDATE cat_manager SET username = array_remove(username,v_user_name) WHERE v_user_name = any(username);
		
		--remove user from users catalog
		DELETE FROM cat_users WHERE id = v_user_name;

		EXECUTE 'DROP USER '||v_user_name||';';

	END IF;
	
RETURN 0;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
