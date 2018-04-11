/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_role_permissions(text, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_role_permissions(db_name_aux text, schema_name_aux text) RETURNS void AS
$BODY$

DECLARE 
table_record record;
project_type_aux text;
query_text text;
function_name_aux text;

BEGIN 


	-- search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- Looking for project type
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	-- Starting process
	-- Grant access on database
	FOR table_record IN SELECT * FROM sys_role
	LOOP
		query_text:= 'GRANT ALL ON DATABASE '||db_name_aux||' TO '||table_record.id||';'; 
		EXECUTE query_text;
	END LOOP;
	
	-- Grant generic permissions
	FOR table_record IN SELECT * FROM sys_role
	LOOP
		query_text:= 'GRANT ALL ON SCHEMA '||schema_name_aux||' TO '||table_record.id||';'; 
		EXECUTE query_text;
		query_text:= 'GRANT SELECT ON ALL TABLES IN SCHEMA '||schema_name_aux||' TO '||table_record.id||';'; 
		EXECUTE query_text;
		query_text:= 'GRANT ALL ON ALL SEQUENCES IN SCHEMA  '||schema_name_aux||' TO "role_basic";'; 
		EXECUTE query_text;
	END LOOP;

	-- Grant specificic permissions for tables
	FOR table_record IN SELECT * FROM audit_cat_table WHERE sys_role_id IS NOT NULL
	LOOP
		query_text:= 'GRANT ALL ON TABLE '||table_record.id||' TO '||table_record.sys_role_id||';';
		EXECUTE query_text;
	END LOOP;
	
	-- Grant specificic permissions for functions
	FOR table_record IN SELECT * FROM audit_cat_function WHERE project_type=project_type_aux
	LOOP
		function_name_aux=concat(table_record.function_name,'(',table_record.input_params,')');
		query_text:= 'GRANT ALL ON FUNCTION '||table_record.id||' TO '||function_name_aux||';';
		EXECUTE query_text;
	END LOOP;

		
RETURN ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

