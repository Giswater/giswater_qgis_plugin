/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2464


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_check_project(fprocesscat_id_aux integer)
  RETURNS integer AS
$BODY$

DECLARE 
query_text 	text;
sys_rows_aux 	text;
parameter_aux   text;
audit_rows_aux 	integer;
compare_sign_aux text;
enabled_bool 	boolean;
diference_aux 	integer;
error_aux integer;
count integer;
table_host_aux text;
table_dbname_aux text;
table_schema_aux text;
table_record record;
query_string text;
max_aux int8;
project_type_aux text;
rolec_rec record;
psector_vdef_aux text;

BEGIN 


	-- search path
	SET search_path = "SCHEMA_NAME", public;
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

	-- init process
	enabled_bool:=FALSE;
	count=0;
	
	--REFRESH MATERIALIZED VIEW v_ui_workcat_polygon_aux;

	SELECT value INTO psector_vdef_aux FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user=current_user;
	
	-- Force psector vdefault visible to current_user (only to => role_master)
	IF 'role_master' IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member')) and  psector_vdef_aux is not null THEN
	  DELETE FROM selector_psector WHERE psector_id =(SELECT value FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user=current_user)::integer AND cur_user=current_user;
	  INSERT INTO selector_psector (psector_id, cur_user) VALUES ((SELECT value FROM config_param_user WHERE parameter='psector_vdefault' AND cur_user=current_user)::integer, current_user);
	END IF;

	/* setting values user (>3.2)
	-- if is first time for user
	IF (SELECT cur_user FROM config_param user WHERE cur_user=current_user LIMIT 1) IS NULL THEN   
		-- set values of user
		PERFORM gw_fct_admin_role_resetuserprofile('"user":"'||current_user||'", "values":{}');
	END IF;
	*/

	-- Reset sequences
	IF project_type_aux='WS' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO max_aux;
	ELSIF project_type_aux='UD' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(gully_id::int8) FROM gully WHERE gully_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO max_aux;
	END IF;	
	IF max_aux IS NOT null THEN
		EXECUTE 'SELECT setval(''SCHEMA_NAME.urn_id_seq'','||max_aux||', true)';
	END IF;
	
	
	-- Special cases (doc_seq)
	SELECT max(id::integer) FROM doc WHERE id ~ '^\d+$' into max_aux;
	IF max_aux IS NOT null THEN
		EXECUTE 'SELECT setval(''SCHEMA_NAME.doc_seq'','||max_aux||', true)';
	END IF;
	
		
	-- rest of sequences
	FOR table_record IN SELECT * FROM audit_cat_table WHERE sys_sequence IS NOT NULL AND sys_sequence_field IS NOT NULL AND sys_sequence!='urn_id_seq' AND sys_sequence!='doc_seq'
	LOOP 
		query_string:= 'SELECT max('||table_record.sys_sequence_field||') FROM '||table_record.id||';' ;
		EXECUTE query_string INTO max_aux;	
		IF max_aux IS NOT NULL THEN 
			EXECUTE 'SELECT setval(''SCHEMA_NAME.'||table_record.sys_sequence||' '','||max_aux||', true)';
		END IF;
	END LOOP;		


	-- check qgis project (1)
	IF fprocesscat_id_aux=1 THEN
	
	--table_host_aux = (SELECT table_host FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux AND table_id='version');
	--table_dbname_aux = (SELECT table_dbname FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux AND table_id='version');
	--table_schema_aux = (SELECT table_schema FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux AND table_id='version');


		-- start process
		FOR table_record IN SELECT * FROM audit_cat_table WHERE qgis_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member'))
		LOOP
		
			RAISE NOTICE 'count % id % ', count, table_record.id;
			IF table_record.id NOT IN (SELECT table_id FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux) THEN
			
				INSERT INTO audit_check_project (table_id, fprocesscat_id, criticity, enabled, message) VALUES (table_record.id, 1, table_record.qgis_criticity, FALSE, table_record.qgis_message);
			ELSE 
				UPDATE audit_check_project SET criticity=table_record.qgis_criticity, enabled=TRUE WHERE table_id=table_record.id;
			END IF;	
			count=count+1;
		END LOOP;
		

		--error 1 (criticity = 3 and false)
		SELECT count (*) INTO error_aux FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=1 AND criticity=3 AND enabled=FALSE;

		RAISE NOTICE ' error_aux 3 %', error_aux;

		IF error_aux>0 THEN
			RETURN -1;

		ELSIF error_aux IS NULL OR error_aux = 0 THEN
			SELECT count (*) INTO error_aux FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=1 AND enabled=FALSE ;	
			IF (error_aux IS NULL) THEN
				RETURN 0;
			ELSE 
				RETURN error_aux;
			END IF;
		END IF;


	-- Checking user value_default
	ELSIF fprocesscat_id_aux=19 THEN

	DELETE FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux;

	FOR table_record IN SELECT * FROM audit_cat_param_user WHERE dv_table IS NOT NULL AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member'))
	LOOP 
		RAISE NOTICE '%', table_record;
		SELECT value INTO parameter_aux FROM config_param_user WHERE parameter=table_record.id AND cur_user=current_user;
		
		IF parameter_aux IS NOT NULL THEN
				
			IF table_record.dv_clause IS NOT NULL THEN
				EXECUTE table_record.dv_clause||'''||parameter_aux||''';
			ELSE 
				EXECUTE 'SELECT '||table_record.dv_column||' FROM '||table_record.dv_table|| ' WHERE '''||parameter_aux||'''='||table_record.dv_column INTO query_string;
			END IF;

			IF query_string IS NULL THEN

				INSERT INTO audit_check_project (table_id, fprocesscat_id, criticity, enabled, message) 
				VALUES (table_record.id, 19, NULL, FALSE, table_record.qgis_message);
				count=count+1;
			END IF;
			
		ELSE
			INSERT INTO audit_check_project (table_id, fprocesscat_id, criticity, enabled, message) 
			VALUES (table_record.id, 19, NULL, FALSE, table_record.qgis_message);
			count=count+1;
		END IF;
		
	END LOOP;

	RETURN count;


	-- Checking data consistency
	ELSIF fprocesscat_id_aux=2 THEN

	DELETE FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux;


		-- start process
		FOR table_record IN SELECT * FROM audit_cat_table WHERE sys_criticity>0
		LOOP	
			-- audit rows
			query_text:= 'SELECT count(*) FROM '||table_record.id;
			EXECUTE query_text INTO audit_rows_aux;
	
			-- system rows
			compare_sign_aux= substring(table_record.sys_rows from 1 for 1);
			sys_rows_aux=substring(table_record.sys_rows from 2 for 999);
			IF (sys_rows_aux>='0' and sys_rows_aux<'9999999') THEN
	
			ELSIF sys_rows_aux like'@%' THEN 
				query_text=substring(table_record.sys_rows from 3 for 999);
				IF query_text IS NULL THEN
					RETURN audit_function(2078,2464,(table_record.id)::text);
				END IF;
				EXECUTE query_text INTO sys_rows_aux;
			ELSE
				query_text='SELECT count(*) FROM '||sys_rows_aux;
				IF query_text IS NULL THEN
					RETURN audit_function(2078,2464,(table_record.id)::text);
				END IF;
				EXECUTE query_text INTO sys_rows_aux;
			END IF;
	
			IF compare_sign_aux='>'THEN 
				compare_sign_aux='=>';
			END IF;
	
			diference_aux=audit_rows_aux-sys_rows_aux::integer;
		
			-- compare audit rows & system rows
			IF compare_sign_aux='=' THEN
					IF diference_aux=0 THEN
					enabled_bool=TRUE;
				ELSE
					enabled_bool=FALSE;
				END IF;
					
			ELSIF compare_sign_aux='=>' THEN
				IF diference_aux >= 0 THEN
					enabled_bool=TRUE;
				ELSE	
					enabled_bool=FALSE;
				END IF;	
			END IF;

			
			INSERT INTO audit_check_project ( table_id, fprocesscat_id, criticity,enabled, message,user_name)
			VALUES (table_record.id,  fprocesscat_id_aux, table_record.sys_criticity, enabled_bool, 
			concat('Table needs ',compare_sign_aux,' ',sys_rows_aux,' rows and it has ',audit_rows_aux,' rows'), (SELECT current_user));
		END LOOP;

		SELECT COUNT(*) INTO error_aux FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=2 AND enabled=FALSE;	

		RETURN error_aux;
		
	END IF;


return 0;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;