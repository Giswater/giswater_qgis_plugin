/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2128


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_audit_schema_data(character varying);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_schema_data(foreign_schema character varying)  RETURNS integer AS
$BODY$

DECLARE 
table_record 	record;
query_text 	text;
sys_rows_aux 	text;
audit_rows_aux 	integer;
compare_sign_aux text;
is_ok_boolean 	boolean;

BEGIN 


	SET search_path = "SCHEMA_NAME", public;
	
	is_ok_boolean:=FALSE;
	
	FOR table_record IN SELECT * FROM audit_cat_table WHERE sys_criticity>0
	LOOP	
		-- audit rows
		query_text:= 'SELECT count(*) INTO count_int FROM '||table_record;
		EXECUTE query_text INTO audit_rows_aux;

		-- system rows
		compare_sign_aux= substract(table_record.sys_rows from 0 in 1);
		sys_rows_aux=substract(table_record.sys_rows from 1 in 999);
		IF column_type(sys_rows_aux)!=integer THEN
			query_text='SELECT count(*) FROM '||sys_rows_aux;
			EXECUTE query_text INTO sys_rows_aux;
		END IF;

		IF compare_sign_aux='>'THEN 
			compare_sign_aux='=>'
		END IF;

		diference_aux=audit_rows_aux-sys_rows_aux::integer;

		-- compare audit rows & system rows
		IF compare_sign_aux='=' THEN
			IF diference=0 THEN
				is_ok_boolean=TRUE;
			ELSE
				is_ok_boolean=FALSE;
			END IF;
			
		ELSIF compare_sign_aux='=>' THEN
			IF diference >= 0 THEN
				is_ok_boolean=TRUE;
			ELSE
				is_ok_boolean=FALSE;
			END IF;	
		END IF;

		INSERT INTO audit_schema_data VALUES (table_record.id,  table_record.sys_criticity, table_record.sys_message, concat(compare_sign_aux,' ',sys_rows_aux), audit_rows_aux, is_ok_boolean);
	
		

DROP TABLE IF EXISTS ws_data.audit_schema_data CASCADE; 
CREATE TABLE ws_data.audit_schema_data (
table_id text PRIMARY KEY,
sys_criticity smallint,
sys_message text,
sys_rows text,
audit_rows integer,
is_ok boolean
);

		
	
	
RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

