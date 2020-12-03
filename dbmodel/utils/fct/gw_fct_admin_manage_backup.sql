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
CREATE, create a backup for all data for related table into temp_table with fid = 211
RESTORE, delete all rows from original table and restore all rows from backup name. To prevent damages into original table two strategies have been developed:
	1 - It is mandatory to fill both keys (backupName and table) as as security check
	2- Before restore the backup , a new backup from original table is created using the key newBackupName. 
	As result, if you try to restore and that backup name already exists you will need to delete this system backup before because it will exists there.
DELETE,a backup name on temp_table. 
	1- It is mandatory to fill two keys (backupName and table) as as security check.
	
EXAMPLE
-------
SELECT SCHEMA_NAME.gw_fct_admin_manage_backup ($${"data":{"action":"CREATE", "backupName":"test8", "table":"config_form_fields"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_backup ($${"data":{"action":"RESTORE", "backupName":"test6", "newBackupName":"test5", "table":"config_form_fields"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_backup ($${"data":{"action":"DELETE", "backupName":"test4","table":"config_form_fields" }}$$)

-- fid: 211

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
v_addmessage text;
v_tablename_check text;
v_newbackupname text;
v_version text;
v_audit_result text;
v_status text;
v_level text;
v_error_context text;

BEGIN 
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	 -- select project type
    SELECT giswater INTO  v_version FROM sys_version LIMIT 1;

	-- get input parameters
	v_action := (p_data ->> 'data')::json->> 'action';
	v_backupname := (p_data ->> 'data')::json->> 'backupName';
	v_newbackupname:= (p_data ->> 'data')::json->> 'newBackupName';
	v_tablename:= (p_data ->> 'data')::json->> 'table';

	IF v_backupname IS NULL OR length(v_backupname) < 1 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3146", "function":"2792","debug_msg":null}}$$);' INTO v_audit_result;

	ELSE

		IF v_action ='CREATE' THEN

			IF (SELECT count(*) FROM temp_table WHERE text_column::json->>'name' = v_backupname AND fid = 211) > 0 THEN
				
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3148", "function":"2792","debug_msg":"'||v_backupname||'"}}$$);' INTO v_audit_result;
			END IF;

			v_querytext = 'INSERT INTO temp_table (fid, text_column, addparam) SELECT 211, ''{"name":"'||v_backupname||'", "table":"'||v_tablename||'"}'', row_to_json(row) FROM (SELECT * FROM '||v_tablename||') row';

			EXECUTE 'SELECT count(*) FROM '||v_tablename
				INTO v_count;

			EXECUTE v_querytext;
			
		ELSIF v_action ='RESTORE' THEN
			SELECT text_column::json->>'table' INTO v_tablename_check FROM temp_table WHERE text_column::json->>'name' = v_backupname AND fid=211 LIMIT 1;

			-- check consistency on tablename
			IF v_tablename != v_tablename_check THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3150", "function":"2792","debug_msg":"'||v_tablename||'}}$$);' INTO v_audit_result;
			END IF;

			-- automatic backup creation
			-- check if backup exists
			IF (SELECT count(*) FROM temp_table WHERE text_column::json->>'name' = v_newbackupname AND fid=211 ) > 0 THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3148", "function":"2792","debug_msg":"'||v_newbackupname||'"}}$$);' INTO v_audit_result;
			END IF;

			v_querytext = 'INSERT INTO temp_table (fid, text_column, addparam) SELECT 211, ''{"name":"'||v_newbackupname||'", "table":"'||v_tablename||'"}'', row_to_json(row) FROM (SELECT * FROM '||v_tablename||') row';

			EXECUTE 'SELECT count(*) FROM '||v_tablename
				INTO v_count;

			EXECUTE v_querytext;

			-- restore		
			-- get table from backup
			
			-- delete table
			v_querytext = 'DELETE FROM '||v_tablename;
			EXECUTE v_querytext;
				
			-- get fields from table
			select array_agg(json_keys) into v_fields from ( select json_object_keys(addparam) as json_keys FROM 
			(SELECT addparam FROM temp_table WHERE fid =211 AND text_column::json->>'name' = v_backupname limit 1)a)b;

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
			v_querytext = concat (v_querytext, ' FROM temp_table WHERE fid=211 AND text_column::json->>''name'' = ',quote_literal(v_backupname));

			EXECUTE 'SELECT count(*) FROM temp_table WHERE fid=211 AND text_column::json->>''name'' = '||quote_literal(v_backupname)
				INTO v_count;
		
			EXECUTE v_querytext;

			v_addmessage = 'Previous data from table before retore have been saved on temp_table <<'||v_newbackupname||'>>';


		ELSIF v_action= 'DELETE' THEN

			-- get table from backup
			SELECT text_column::json->>'table' INTO v_tablename FROM temp_table WHERE text_column::json->>'name' = v_backupname AND fid=211 LIMIT 1;

			EXECUTE 'SELECT count(*) FROM temp_table WHERE text_column::json->>''name'' = '|| quote_literal(v_backupname) ||' AND fid=211'
			INTO v_count;

			DELETE FROM temp_table WHERE text_column::json->>'name' = v_backupname AND fid=211;

		END IF;

	END IF;

	IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message =  concat ('BACKUP <<',v_backupname,'>> for ',v_tablename,' table sucessfully ',v_action,'D. Rows affected: ',v_count, '.', v_addmessage);

    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;



	--    Control NULL's
	v_message := COALESCE(v_message, '');
	
	-- Return
	--  Return
     RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{}}'||
	    '}')::json;

    EXCEPTION WHEN OTHERS THEN
	GETT STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;