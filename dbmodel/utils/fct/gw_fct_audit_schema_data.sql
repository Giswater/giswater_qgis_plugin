/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_audit_schema_data(character varying);
CREATE OR REPLACE FUNCTION ws_data.gw_fct_audit_schema_data(schema_id_aux character varying) RETURNS integer AS
$BODY$

DECLARE 
table_record 	record;
query_text 	text;
sys_rows_aux 	text;
audit_rows_aux 	integer;
compare_sign_aux text;
is_ok_boolean 	boolean;
diference_aux 	integer;

BEGIN 


	-- search path
	SET search_path = "ws_data", public;

	-- init process
	is_ok_boolean:=FALSE;

	DELETE FROM audit_schema_data;

	-- start process
	FOR table_record IN SELECT * FROM audit_cat_table WHERE sys_criticity>0
	LOOP	
		-- audit rows
		query_text:= 'SELECT count(*) FROM '||schema_id_aux||'.'||table_record.id;
		EXECUTE query_text INTO audit_rows_aux;

		-- system rows
		compare_sign_aux= substring(table_record.sys_rows from 1 for 1);
		sys_rows_aux=substring(table_record.sys_rows from 2 for 999);
		IF (sys_rows_aux>'0' and sys_rows_aux<'9999999') THEN

		ELSIF sys_rows_aux like'@%' THEN 
			query_text=substring(table_record.sys_rows from 3 for 999);
			EXECUTE query_text INTO sys_rows_aux;
		ELSE
			query_text='SELECT count(*) FROM '||schema_id_aux||'.'||sys_rows_aux;
			EXECUTE query_text INTO sys_rows_aux;
		END IF;

		IF compare_sign_aux='>'THEN 
			compare_sign_aux='=>';
		END IF;

		diference_aux=audit_rows_aux-sys_rows_aux::integer;

		-- compare audit rows & system rows
		IF compare_sign_aux='=' THEN
			IF diference_aux=0 THEN
				is_ok_boolean=TRUE;
			ELSE
				is_ok_boolean=FALSE;
			END IF;
			
		ELSIF compare_sign_aux='=>' THEN
			IF diference_aux >= 0 THEN
				is_ok_boolean=TRUE;
			ELSE
				is_ok_boolean=FALSE;
			END IF;	
		END IF;

		INSERT INTO audit_schema_data VALUES (table_record.id,  table_record.sys_criticity, table_record.sys_message, concat(compare_sign_aux,' ',sys_rows_aux), audit_rows_aux, is_ok_boolean);
	END LOOP;
	
RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

