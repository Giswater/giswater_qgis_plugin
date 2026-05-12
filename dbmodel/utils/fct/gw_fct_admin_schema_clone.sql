/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2122

DROP FUNCTION IF EXISTS "SCHEMA_NAME".clone_schema(text, text);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_clone_schema(json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_admin_schema_clone(p_data json)
RETURNS json AS

$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_schema_clone($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, 
"data":{"parameters":{"source_schema":"SCHEMA_NAME","dest_schema":"SCHEMA_NAME_2"}}}$$);
*/

DECLARE

rec_view record;
rec_fk record;
rec_table text;
rec_fct record;
rec_seq  record;
rec_trg record;
v_tablename text;
v_default text;
v_column text;
v_source_schema text; 
v_dest_schema text;
v_version text;
v_error_context text;
v_fct_definition text;
v_query_text text;
v_id_field text;
v_trg_fields text;  
v_replace_query text;
v_result json;
v_result_info json;
v_result_point json;
v_result_polygon json;
v_result_line json;
v_count integer;
v_software text;
v_project_type text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT giswater, upper(project_type) INTO v_version, v_project_type FROM sys_version order by id desc limit 1;

	-- get input data   
	v_source_schema := ((p_data ->>'data')::json->>'parameters')::json->>'source_schema'::text;
	v_dest_schema := ((p_data ->>'data')::json->>'parameters')::json->>'dest_schema'::text;

	-- Create destination schema
	EXECUTE 'CREATE SCHEMA ' || v_dest_schema ;
	 
	-- Sequences
	FOR rec_table IN
		SELECT sequence_name FROM information_schema.SEQUENCES WHERE sequence_schema = v_source_schema
	LOOP

		EXECUTE 'CREATE SEQUENCE ' || v_dest_schema || '.' || rec_table;
	END LOOP;

	-- Tables
	FOR rec_table IN
		SELECT table_name FROM information_schema.TABLES WHERE table_schema = v_source_schema AND table_type = 'BASE TABLE' ORDER BY table_name
	LOOP

		-- Create table in destination schema
		v_tablename := v_dest_schema || '.' || rec_table;
		EXECUTE 'CREATE TABLE ' || v_tablename || ' (LIKE ' || v_source_schema || '.' || rec_table || ' INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS)';
	
		-- Set contraints
		FOR v_column, v_default IN

			EXECUTE 'SELECT column_name,  REPLACE(column_default, concat('''||rec_table||''',''_'',column_name), 
			concat('''||v_dest_schema||''',''.'','''||rec_table||''',''_'',column_name)) 
			FROM information_schema.columns 
			WHERE table_schema = '''||v_source_schema||''' AND table_name = '''||rec_table||''' AND column_default 
			LIKE ''nextval(%' || rec_table || '%::regclass)'''
		LOOP
			EXECUTE 'ALTER TABLE ' || v_tablename || ' ALTER COLUMN ' || v_column || ' SET DEFAULT ' || v_default;
		END LOOP;
		
		-- Copy table contents to destination schema
		EXECUTE 'INSERT INTO ' || v_tablename || ' SELECT * FROM ' || v_source_schema || '.' || rec_table;  
		
	END LOOP;

	IF v_project_type = 'WS' OR v_project_type = 'UD' THEN
		EXECUTE 'ALTER TABLE '|| v_dest_schema ||'.arc ALTER COLUMN arc_id SET DEFAULT nextval('''||v_dest_schema||'.urn_id_seq''::regclass);';
		EXECUTE 'ALTER TABLE '|| v_dest_schema ||'.node ALTER COLUMN node_id SET DEFAULT nextval('''||v_dest_schema||'.urn_id_seq''::regclass);';
		EXECUTE 'ALTER TABLE '|| v_dest_schema ||'.anl_node ALTER COLUMN node_id SET DEFAULT nextval('''||v_dest_schema||'.urn_id_seq''::regclass);';
		EXECUTE 'ALTER TABLE '|| v_dest_schema ||'.connec ALTER COLUMN connec_id SET DEFAULT nextval('''||v_dest_schema||'.urn_id_seq''::regclass);';
	END IF;

	IF  v_project_type = 'UD' THEN
		EXECUTE 'ALTER TABLE '|| v_dest_schema ||'.gully ALTER COLUMN gully_id SET DEFAULT nextval('''||v_dest_schema||'.urn_id_seq''::regclass);';
	END IF;

	-- fk,check

	FOR rec_fk IN
		EXECUTE 'SELECT distinct on (conname) conrelid::regclass AS tablename, conname AS constraintname, pg_get_constraintdef(c.oid),
		replace(pg_get_constraintdef(c.oid),''REFERENCES'',concat(''REFERENCES '','''||v_dest_schema||''',''.'')) AS definition
		FROM   pg_constraint c JOIN   pg_namespace n ON n.oid = c.connamespace
		join   information_schema.table_constraints tc ON conname=constraint_name WHERE contype IN (''f'',''c'',''u'')
		AND nspname = '''||v_source_schema||''' AND  conname not ilike ''%category_type%'';'
	LOOP
			
		v_query_text:=  'ALTER TABLE '||v_dest_schema || '.' || rec_fk.tablename||' DROP CONSTRAINT IF EXISTS '|| rec_fk.constraintname||' CASCADE;';
		EXECUTE v_query_text;
		v_query_text:=  'ALTER TABLE '||v_dest_schema || '.' || rec_fk.tablename||' ADD CONSTRAINT '|| rec_fk.constraintname|| ' '||rec_fk.definition||';';
		EXECUTE v_query_text;

	END LOOP;

	--reset sequences
	FOR rec_seq IN
		(SELECT seq_ns.nspname as sequence_schema, seq.relname as sequence_name, tab.relname as related_table
		FROM pg_class seq JOIN pg_namespace seq_ns on seq.relnamespace = seq_ns.oid
		JOIN pg_depend d ON d.objid = seq.oid AND d.deptype = 'a' 
		JOIN pg_class tab ON d.objid = seq.oid AND d.refobjid = tab.oid
		WHERE seq.relkind = 'S' AND seq_ns.nspname = v_source_schema)
	LOOP

		EXECUTE 'SELECT distinct on (conname) replace(replace(pg_get_constraintdef(c.oid), ''PRIMARY KEY ('',''''),'')'','''') 
		FROM   pg_constraint c JOIN   pg_namespace n ON n.oid = c.connamespace
		join   information_schema.table_constraints tc ON conname=constraint_name WHERE contype =''p'' 
		AND nspname = '''||v_source_schema||''' AND table_name = '''||rec_seq.related_table||''';'
		INTO v_id_field;
		 
		IF v_id_field is not null THEN
			EXECUTE 'SELECT count('||v_id_field||') FROM '||rec_seq.related_table||';'
			INTO v_count;
			
			IF v_count > 0 THEN
				EXECUTE 'SELECT setval('''||v_dest_schema||'.'||rec_seq.sequence_name||''', 
				(SELECT max('||v_id_field||')+1 FROM '||rec_seq.related_table||'), true);';
			END IF;
		END IF;

	END LOOP;

	EXECUTE 'SELECT setval('''||v_dest_schema||'.urn_id_seq'', gw_fct_setvalurn(),true);';

	-- View
	FOR rec_view IN
		EXECUTE 'SELECT table_name, view_definition as definition 
		FROM information_schema.views	 WHERE table_schema = '''||v_source_schema||''''
	LOOP

		EXECUTE 'CREATE VIEW ' || v_dest_schema || '.' || rec_view.table_name || ' AS  
		'||rec_view.definition||';';
	END LOOP;

	FOR rec_view IN 
		EXECUTE 'SELECT schemaname, matviewname, replace(definition, 
		concat('||quote_literal(v_source_schema)||',''.''),concat('||quote_literal(v_dest_schema)||',''.'')) AS definition 
		from pg_matviews WHERE schemaname='''||v_source_schema||''''
	LOOP
		EXECUTE 'CREATE MATERIALIZED VIEW ' || v_dest_schema || '.' || rec_view.matviewname || ' AS  
		'||rec_view.definition||';';
	END LOOP;

	EXECUTE 'SELECT gw_fct_admin_manage_schema($${"client":{"lang":"ES"}, 
	"data":{"action":"RENAMESCHEMA","source":"'||v_source_schema||'", "target":"'||v_dest_schema||'"}}$$);';

	--Functions
	EXECUTE 'SELECT replace(''project_type'', '''||v_source_schema||''','''||v_dest_schema||''')'
	into v_software;

	FOR rec_fct IN 
	
		EXECUTE 'SELECT routine_name,concat(routine_name,''('',string_agg(parameters.data_type,'', ''),'')'') FROM information_schema.routines
	   LEFT JOIN information_schema.parameters ON routines.specific_name=parameters.specific_name
		WHERE routines.specific_schema='''||v_source_schema||''' and routine_name!=''audit_function'' and routine_name!=''gw_fct_arc_repair''
		group by routine_name'
	LOOP
		EXECUTE 'select * from pg_get_functiondef('''||v_source_schema||'.'|| rec_fct.routine_name||'''::regproc)'
		INTO v_fct_definition;
		v_fct_definition = REPLACE (v_fct_definition,concat(v_source_schema,'.'), concat(v_dest_schema,'.'));
		v_fct_definition = REPLACE (v_fct_definition,concat('"',v_source_schema,'"'), concat('"',v_dest_schema,'"'));
		v_fct_definition = REPLACE (v_fct_definition,concat('''',v_source_schema,''''), concat('''',v_dest_schema,''''));

		IF v_fct_definition ~* v_software THEN
		v_fct_definition = REPLACE (v_fct_definition,v_software, 'project_type');
		END IF; 
		EXECUTE v_fct_definition;
 
	END LOOP;

	--trg
	FOR rec_trg IN 
		select event_object_schema as table_schema, event_object_table as table_name, trigger_schema, trigger_name,
		string_agg(event_manipulation, ',') as event, action_timing as activation, action_condition as condition, action_statement as definition
		from information_schema.triggers where event_object_schema = v_source_schema group by 1,2,3,4,6,7,8 order by table_schema, table_name
	LOOP

		SELECT string_agg(event_object_column, ',') INTO v_trg_fields FROM information_schema.triggered_update_columns 
		WHERE event_object_schema = v_source_schema and event_object_table=rec_trg.table_name AND trigger_name = rec_trg.trigger_name;


		EXECUTE 'select replace('''||rec_trg.event||''', '','', '' OR '')'
		INTO v_replace_query;
		
		rec_trg.definition = replace(rec_trg.definition,concat(v_source_schema,'.'),concat(v_dest_schema,'.'));
		IF v_trg_fields IS NULL THEN 

			

			EXECUTE 'CREATE TRIGGER '||rec_trg.trigger_name||' '||rec_trg.activation||' '||v_replace_query||'
			ON '||v_dest_schema||'.'||rec_trg.table_name||' FOR EACH ROW '|| rec_trg.definition||';';
		  
		ELSE   

			EXECUTE 'select replace('''||v_replace_query||''', ''UPDATE'', '' UPDATE  OF '||v_trg_fields||''')'
			INTO v_replace_query; 
	   

			EXECUTE 'CREATE TRIGGER '||rec_trg.trigger_name||' '||rec_trg.activation||' '||v_replace_query||' ON 
			'||v_dest_schema||'.'||rec_trg.table_name||' FOR EACH ROW '|| rec_trg.definition||';';

		END IF;

	END LOOP;

	-- admin role permissions
	PERFORM gw_fct_admin_role_permissions();

	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"values":',v_result_info, '}');

	--geometry
	v_result_line = '{}';
	v_result_polygon = '{}';
	v_result_point = '{}';

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Copy schema done successfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
			   '}'||
		'}')::json, 2122, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
