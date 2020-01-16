/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2792

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_backup(p_data json)
  RETURNS json AS
$BODY$

/*
INSTRUCTIONS
------------
CREATE, creates a backup for all data on related table on temp_table with fprocesscat_id = 111
RESTORE, delete all rows on original table and restore all rows from backup name.
	It is mandatory to fill two keys (backupName and table) as as security check
	Before backup is restored rows from original table are saved using a backupName of concat(tablename, _backup). As result, if you try to restore two times same table, you will need to delete this system backup before.
DELETE A backup name on temp_table
	It is mandatory to fill two keys (backupName and table) as as security check.
	
EXAMPLE
-------
SELECT SCHEMA_NAME.gw_fct_admin_manage_backup ($${"data":{"action":"CREATE", "backupName":"test6", "table":"config_api_form_fields"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_backup ($${"data":{"action":"RESTORE", "backupName":"test5", "table":"config_api_form_fields"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_backup ($${"data":{"action":"DELETE", "backupName":"test4","table":"config_api_form_fields" }}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_backup ($${"data":{"action":"DELETE", "backupName":"config_api_form_fields_backup","table":"config_api_form_fields"}}$$)
*/


DECLARE 
	v_querytext text;
	v_priority integer = 0;
	v_message text;
	v_action text;
	v_backupname text;
	v_tablename text;
	v_fields text[];
	v_field text;
	v_count int4 = 0;
	v_schemaname text;
	v_columntype text;
	v_bkname text;
	v_addmessage text;
	v_tablename_check text;
	
BEGIN 
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';


	-- get input parameters
	v_action := (p_data ->> 'data')::json->> 'action';
	v_backupname := (p_data ->> 'data')::json->> 'backupName';
	v_tablename:= (p_data ->> 'data')::json->> 'table';

	IF v_backupname IS NULL OR v_backupname IS NULL OR v_backupname IS NULL THEN
		RAISE EXCEPTION 'Some mandatory key is missing, action %, backupName %, table %', v_action, v_backupname, v_tablename;
	END IF;
	

	IF v_action ='CREATE' THEN

		IF (SELECT count(*) FROM temp_table WHERE text_column::json->>'name' = v_backupname ) > 0 THEN
			RAISE EXCEPTION 'The backup name exists. Try with other name or delete it before';
		END IF;

		v_querytext = 'INSERT INTO temp_table (fprocesscat_id, text_column, addparam) SELECT 111, ''{"name":"'||v_backupname||'", "table":"'||v_tablename||'"}'', row_to_json(row) FROM (SELECT * FROM '||v_tablename||') row';

		EXECUTE 'SELECT count(*) FROM '||v_tablename
			INTO v_count;

		EXECUTE v_querytext;
		
	ELSIF v_action ='RESTORE' THEN

		-- get table from backup
		SELECT text_column::json->>'table' INTO v_tablename_check FROM temp_table WHERE text_column::json->>'name' = v_backupname AND fprocesscat_id=111 LIMIT 1;

		-- check consistency on tablename
		IF v_tablename != v_tablename_check THEN
			RAISE EXCEPTION 'Backup % has no data related to % table. Please check it before continue', v_backupname, v_tablename;
		END IF;

		-- create a security backup of previous data on restored table
		v_bkname = v_tablename||'_backup';

		-- check if previous security backup if exists
		SELECT count(*) INTO v_count FROM temp_table WHERE text_column::json->>'name' = v_bkname;
		IF v_count > 0 THEN
			RAISE EXCEPTION 'Exists another security backup (created by system) for table % called %. Before continue you need to delete it', v_tablename, v_bkname;
		END IF;

		-- check if backup exists
		SELECT count(*) INTO v_count FROM temp_table WHERE text_column::json->>'name' = v_backupname;
		IF v_count = 0 THEN
			RAISE EXCEPTION 'There is no backup with provided name. Please check it before continue';
		END IF;
			
		v_querytext = 'INSERT INTO temp_table (fprocesscat_id, text_column, addparam) SELECT 111, ''{"name":"'||v_bkname||'", "table":"'||v_tablename||'"}'', row_to_json(row) FROM (SELECT * FROM '||v_tablename||') row';
		EXECUTE v_querytext;

		-- delete table
		v_querytext = 'DELETE FROM '||v_tablename;
		EXECUTE v_querytext;
			
		-- get fields from table
		select array_agg(json_keys) into v_fields from (
		select json_object_keys(addparam) as json_keys from (SELECT addparam FROM temp_table limit 1)a)b;

		-- build querytext (init)
		v_querytext = 'INSERT INTO '||v_tablename||' SELECT';

		-- build querytext
		FOREACH v_field IN ARRAY v_fields 
		LOOP
			-- Get column type
			EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(v_tablename) || ' AND column_name = $2'
			USING v_schemaname, v_field
			INTO v_columntype;
			
			v_querytext = concat (v_querytext, ' (addparam->>''', v_field, ''')::',v_columntype, ',');

		END LOOP;

		-- delete last ','
		v_querytext = reverse (v_querytext);
		v_querytext = substring (v_querytext, 2);
		v_querytext = reverse (v_querytext);

		-- build querytext (end)
		v_querytext = concat (v_querytext, ' FROM temp_table WHERE fprocesscat_id=111 AND text_column::json->>''name'' = ',quote_literal(v_backupname));

		EXECUTE 'SELECT count(*) FROM temp_table WHERE fprocesscat_id=111 AND text_column::json->>''name'' = '||quote_literal(v_backupname)
			INTO v_count;
	
		EXECUTE v_querytext;

		RAISE NOTICE 'v_querytext %', v_querytext;

		v_addmessage = 'Previous data from table before retore have been saved on temp_table ( '||v_bkname||' )';

	ELSIF v_action= 'DELETE' THEN

		-- get table from backup
		SELECT text_column::json->>'table' INTO v_tablename FROM temp_table WHERE text_column::json->>'name' = v_backupname AND fprocesscat_id=111 LIMIT 1;

		EXECUTE 'SELECT count(*) FROM temp_table WHERE text_column::json->>''name'' = '|| quote_literal(v_backupname) ||' AND fprocesscat_id=111'
		INTO v_count;

		DELETE FROM temp_table WHERE text_column::json->>'name' = v_backupname AND fprocesscat_id=111;

	END IF;

	-- message
	v_message =  concat ('BACKUP ''',v_backupname,''' for ',v_tablename,' table sucessfully ',v_action,'D. Rows affected: ',v_count, '.', v_addmessage);

	--    Control NULL's
	v_message := COALESCE(v_message, '');
	
	-- Return
	RETURN ('{"message":{"priority":"'||v_priority||'", "text":"'||v_message||'"}}');	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
