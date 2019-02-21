/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2648


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_schema_manage_fk(p_data)
  RETURNS void AS
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_admin_schema_manage_fk($${
"client":{"lang":"ES"}, 
"data":{"action":"DROP"}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_schema_manage_fk($${
"client":{"lang":"ES"}, 
"data":{"action":"ADD"}}$$)

*/

DECLARE
	v_schemaname text;
	v_tablerecord record;
	v_query_text text;
BEGIN
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';
	
	v_action = (p_data->>'data')::json->>'action';

	IF v_action = 'DROP' THEN
	
		-- Insert fk on temp_table
		INSERT INTO ws_sample.temp_table (fprocesscat_id, text_column)
		SELECT 
		36,
		concat(
		'{"tablename":"',
		conrelid::regclass,
		'","constraintname":"',
		conname,
		'","definition":"',
		pg_get_constraintdef(c.oid),
		'"}')
		FROM   pg_constraint c
		JOIN   pg_namespace n ON n.oid = c.connamespace
		join   information_schema.table_constraints tc ON conname=constraint_name
		WHERE  contype IN ('f', 'p ')
		AND constraint_type = 'FOREIGN KEY'
		ORDER  BY conrelid::regclass::text, contype DESC;

		-- Drop fk
		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fprocesscat_id=36
		LOOP
			v_query_text:= 'DROP CONSTRAINT IF EXISTS '||v_tablerecord.id::json->>'constraintname'||';';
			EXECUTE v_query_text;
		END LOOP;
	
	ELSIF v_action = 'ADD' THEN
		
		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fprocesscat_id=36
		LOOP
			v_query_text:=  'ALTER TABLE '||v_tablerecord.id::json->>'tablename'|| 
							' ADD CONSTRAINT '||v_tablerecord.id::json->>'constraintname'||
							' '||v_tablerecord.id::json->>'definition';
			EXECUTE v_query_text;
		END LOOP;
		
	END IF;
	
RETURN;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

