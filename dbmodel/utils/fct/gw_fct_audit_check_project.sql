
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_check_project(fprocesscat_id_aux integer)
  RETURNS integer AS
$BODY$

DECLARE 
table_record 	record;
query_text 	text;
sys_rows_aux 	text;
audit_rows_aux 	integer;
compare_sign_aux text;
enabled_bool 	boolean;
diference_aux 	integer;
error_aux integer;
count integer;
table_host_aux text;
table_dbname_aux text;
table_schema_aux text;

BEGIN 


	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- init process
	enabled_bool:=FALSE;

	count=0;
	
	IF fprocesscat_id_aux=1 THEN
	
	table_host_aux = (SELECT table_host FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux AND table_id='version');
	table_dbname_aux = (SELECT table_dbname FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux AND table_id='version');
	table_schema_aux = (SELECT table_schema FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux AND table_id='version');


		-- start process
		FOR table_record IN SELECT * FROM audit_cat_table WHERE qgis_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, 'member'))
		LOOP
		
			RAISE NOTICE 'count % id % ', count, table_record.id;
			IF table_record.id NOT IN (SELECT table_id FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux) THEN
			--AND table_host= table_host_aux AND table_dbname=table_dbname_aux AND table_schema=table_schema_aux) THEN
				--	IF table_record.id IN (SELECT table_id FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=fprocesscat_id_aux AND enabled IS NULL) THEN
				--		table_record.qgis_message='Table exists but is from other source. Check it';
				--	END IF;		
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
					raise exception 'query_text %', table_record.id;
				END IF;
				EXECUTE query_text INTO sys_rows_aux;
			ELSE
				query_text='SELECT count(*) FROM '||sys_rows_aux;
				IF query_text IS NULL THEN
					raise exception 'query_text %', table_record.id;
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

			
			INSERT INTO audit_check_project VALUES (table_record.id,  fprocesscat_id_aux, table_record.sys_criticity, enabled_bool, concat('Table needs ',compare_sign_aux,' ',sys_rows_aux,' rows and it has ',audit_rows_aux,' rows'), (SELECT current_user));
		END LOOP;

		SELECT COUNT(*) INTO error_aux FROM audit_check_project WHERE user_name=current_user AND fprocesscat_id=2 AND enabled=FALSE;	

		RETURN error_aux;

	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;