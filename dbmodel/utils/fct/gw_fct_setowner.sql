/*
This file is part of Giswater
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
		EXECUTE 'GRANT ALL ON SEQUENCE '|| v_schema ||'."'|| rec ||'" TO '|| v_owner ||';';
	END LOOP;

	FOR rec IN
		EXECUTE 'SELECT CASE WHEN input_params IS NULL OR input_params = ''void'' THEN CONCAT(function_name, ''()'') 
		ELSE CONCAT(function_name, ''('', input_params, '')'') END FROM sys_function
		WHERE project_type = ' || QUOTE_LITERAL(v_project_type) || ''
	LOOP
		-- Replace specific data types for function signature
		IF rec ILIKE '%CHARACTER VARYING%' THEN
			rec = REPLACE(rec, 'CHARACTER VARYING', 'VARCHAR');
		ELSIF rec ILIKE '%BOOLEAN%' THEN
			rec = REPLACE(rec, 'BOOLEAN', 'BOOL');
		END IF;

		-- Check if the function exists in the schema
		PERFORM 1
		FROM pg_proc p
		JOIN pg_namespace n ON p.pronamespace = n.oid
		WHERE n.nspname = QUOTE_LITERAL(v_schema)
		AND p.proname = SPLIT_PART(rec, '(', 1);

		-- If the function exists, alter its owner
		IF FOUND THEN
			EXECUTE 'ALTER FUNCTION ' || v_schema || '.' || rec || ' OWNER TO ' || v_owner || ';';
		END IF;
	END LOOP;

	--  Return
	RETURN json_build_object(
		'status', 'Accepted',
		'message', json_build_object('level', 1, 'text', 'Set owner done successfully'),
		'version', v_version,
		'body', json_build_object(
			'form', json_build_object(),
			'data', json_build_object('info', json_build_object())
		)
	);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;