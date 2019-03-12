-- Function: SCHEMA_NAME.gw_fct_admin_schema_manage_fk(json)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_admin_schema_manage_fk(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_schema_manage_fk(p_data json)
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
	v_action text;
BEGIN
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';
	
	v_action = (p_data->>'data')::json->>'action';

	IF v_action = 'DROP' THEN

		-- Insert fk on temp_table
		DELETE FROM temp_table WHERE fprocesscat_id=36;
		
		INSERT INTO temp_table (fprocesscat_id, text_column)
		SELECT distinct on (conname)
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
		AND nspname =v_schemaname;

		DELETE FROM temp_table WHERE fprocesscat_id=37;

		INSERT INTO temp_table (fprocesscat_id, text_column)
		SELECT distinct
				37,
				concat(
				'{"tablename":"',
				table_name,
				'","attributename":"',
				column_name,
				'","definition":"',
			--	pg_get_attributedef(c.oid),
				'"}')
		FROM information_schema.columns
		WHERE table_schema = v_schemaname
		AND is_nullable='NO' and concat(column_name,'_',table_name) not in (select concat(kcu.column_name,'_',tc.table_name)  FROM 
 		 	  information_schema.table_constraints AS tc 
  			  JOIN information_schema.key_column_usage AS kcu
  			  ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
			  WHERE tc.constraint_type = 'PRIMARY KEY' OR tc.constraint_type ='UNIQUE' );

		-- Drop fk
		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fprocesscat_id=36
		LOOP
			v_query_text:= 'ALTER TABLE '||((v_tablerecord.text_column)::json->>'tablename')||
				       ' DROP CONSTRAINT IF EXISTS '||((v_tablerecord.text_column)::json->>'constraintname')||';';
			raise notice 'asgsdg %',v_query_text;
			EXECUTE v_query_text;
		END LOOP;

		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fprocesscat_id=37
		LOOP
			v_query_text:= 'ALTER TABLE '||((v_tablerecord.text_column)::json->>'tablename')||
				       ' ALTER COLUMN '||((v_tablerecord.text_column)::json->>'attributename')||' DROP NOT NULL;';
			raise notice 'NOTNULL %',v_query_text;
			EXECUTE v_query_text;
		END LOOP;

	ELSIF v_action = 'ADD' THEN
		
		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fprocesscat_id=36
		LOOP
			v_query_text:=  'ALTER TABLE '||((v_tablerecord.text_column::json)->>'tablename')|| 
							' ADD CONSTRAINT '||((v_tablerecord.text_column::json)->>'constraintname')||
							' '||((v_tablerecord.text_column::json)->>'definition');
			EXECUTE v_query_text;
		END LOOP;

		
		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fprocesscat_id=37
		LOOP
			v_query_text:=  'ALTER TABLE '||((v_tablerecord.text_column::json)->>'tablename')|| 
							' ALTER COLUMN '||((v_tablerecord.text_column::json)->>'attributename')||' SET NOT NULL;' ;
		raise notice 'SET NOTNULL %',v_query_text;
			EXECUTE v_query_text;
		END LOOP;
		
	END IF;
	
RETURN;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
