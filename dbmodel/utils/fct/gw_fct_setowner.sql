/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3024

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setowner(p_data json)
  RETURNS json AS
$BODY$


/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_setowner($${"client":{"lang":"ES"}, "data":{"owner":"role_admin"}}$$);
*/



DECLARE

rec text;
v_owner text;
v_schema text;
v_version text;
v_error_context text;
v_project_type text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	v_owner = ((p_data ->>'data')::json->>'owner')::text; 
	v_schema = 'SCHEMA_NAME';

	
	SELECT lower(project_type) into v_project_type from sys_version order by id desc limit 1;
	
	SELECT giswater INTO v_version FROM sys_version order by id desc limit 1;

	EXECUTE 'ALTER SCHEMA '|| v_schema ||' OWNER TO '|| v_owner ||';';

	-- force change sys_table owner before
	EXECUTE 'ALTER TABLE IF EXISTS '|| v_schema ||'."sys_table" OWNER TO '|| v_owner ||';';
	FOR rec IN
		EXECUTE 'SELECT s.id 
				FROM sys_table s
				left join information_schema.tables t
				on s.id = t.table_name
				where t.table_schema = '|| quote_literal(v_schema)||'
				and t.table_type ilike ''%table%''
				ORDER BY id;'
	LOOP
		IF rec <> 'sys_table' THEN
			EXECUTE 'ALTER TABLE IF EXISTS '|| v_schema ||'."'|| rec ||'" OWNER TO '|| v_owner ||';';
		END IF;
	END LOOP;

	FOR rec IN
		EXECUTE 'SELECT s.id 
				FROM sys_table s
				left join information_schema.views v
				on s.id = v.table_name
				where v.table_schema = '|| quote_literal(v_schema)||'
				ORDER BY id;'
	LOOP
		EXECUTE 'ALTER VIEW IF EXISTS '|| v_schema ||'."'|| rec ||'" OWNER TO '|| v_owner ||';';
	END LOOP;

	FOR rec IN
		EXECUTE 'SELECT sequence_name FROM information_schema.SEQUENCES WHERE sequence_schema = '|| quote_literal(v_schema)||''
	LOOP
		EXECUTE 'ALTER SEQUENCE '|| v_schema ||'."'|| rec ||'" OWNER TO '|| v_owner ||';';
	END LOOP;

	FOR rec IN
		EXECUTE 'select case when input_params is null or input_params = ''void'' then concat(function_name, ''()'') 
		else concat(function_name, ''('', input_params, '')'') end from sys_function
		WHERE project_type = '||quote_literal(v_project_type)||''
	LOOP
		
		IF rec ilike '%character varying%' THEN
			rec = replace(rec, 'character varying', 'varchar');
		
		ELSIF rec ilike '%boolean%' then
			rec = replace(rec, 'boolean', 'bool');
		
		END IF;
		
		EXECUTE 'ALTER FUNCTION '|| v_schema ||'.'|| rec ||' OWNER TO '|| v_owner ||';';
		
	END LOOP;

	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Set owner done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":{}'||			
			'}}'||
	    '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;