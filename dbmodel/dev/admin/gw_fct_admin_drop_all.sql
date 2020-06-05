/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 

--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_drop_all();


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_drop_all() RETURNS void AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_admin_drop_all();
*/


DECLARE 
	v_dbnname varchar;
	v_schema_array name[];
	v_schemaname varchar;
	v_tablerecord record;
	v_project_type text;
	v_query_text text;
	v_function_name text;
	v_apiservice boolean;	
	v_rolepermissions boolean;

BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	
	
	v_dbnname =  (SELECT current_database());
	v_schema_array := current_schemas(FALSE);
	v_schemaname :=v_schema_array[1];
	
		
	
		-- Delete functions (can delete with different parameters. Ex: (json))
		FOR v_tablerecord IN SELECT * FROM audit_cat_function 
		LOOP
			v_function_name=concat(v_tablerecord.function_name,'(',v_tablerecord.input_params,')');
			v_query_text:= 'DROP FUNCTION IF EXISTS '||v_tablerecord.function_name||'() CASCADE;';
			EXECUTE v_query_text;
		END LOOP;

		-- Delete tables
		FOR v_tablerecord IN SELECT * FROM audit_cat_table WHERE sys_role IS NOT NULL
		AND id NOT LIKE 'v_%' AND id NOT LIKE 'audit_cat_table' AND id NOT LIKE 'audit_cat_function' 
		AND isdeprecated IS FALSE
		LOOP
			v_query_text:= 'DROP TABLE '||v_tablerecord.id||' CASCADE;';
			EXECUTE v_query_text;
		END LOOP;
			
RETURN ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

