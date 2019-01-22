/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2550


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_schema_dropdeprecated_rel()
  RETURNS void AS
$BODY$


DECLARE
	v_schemaname text;
	v_tablerecord record;
	v_query_text text;
BEGIN
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- Drop sequences
	FOR v_tablerecord IN SELECT * FROM audit_cat_table WHERE isdeprecated IS TRUE
	LOOP
		v_query_text:= 'DROP VIEW IF EXISTS '||v_tablerecord.id||';';
		EXECUTE v_query_text;
	END LOOP;

	-- Drop views and tables
	FOR v_tablerecord IN SELECT * FROM audit_cat_table WHERE isdeprecated IS TRUE
	LOOP
		IF v_tablerecord.id IN (SELECT tablename FROM information_schema.views WHERE table_schema=v_schemaname) THEN
			v_query_text:= 'DROP VIEW IF EXISTS '||v_tablerecord.id||';';
			EXECUTE v_query_text;
		ELSE
	
		v_query_text:= 'DROP TABLE IF EXISTS '||v_tablerecord.id||';';
		EXECUTE v_query_text;
		END IF;
	END LOOP;
	-- Drop functions
	FOR v_tablerecord IN SELECT * FROM audit_cat_function WHERE isdeprecated IS TRUE
	LOOP
		v_query_text:= 'DROP FUNCTION IF EXISTS '||v_tablerecord.id||';';
		EXECUTE v_query_text;
	END LOOP;
		
RETURN;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

