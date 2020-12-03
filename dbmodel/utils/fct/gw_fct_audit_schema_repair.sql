/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NUMBER: 2426

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_audit_schema_repair(schema_name_aux character varying);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_schema_repair(p_schemaname character varying)
  RETURNS text AS
$BODY$

DECLARE

v_table_ddl   text;
v_pk_ddl	text;
v_tablename text;
column_aux text;
v_table_dml text;
v_sequence text;
v_sql text;
column_ text;
v_default text;

rec_table text;
rec_tablename record;
rec_column_record record;
rec_column record;

BEGIN

	SET search_path='SCHEMA_NAME', public;

	DELETE FROM audit_check_data WHERE fid=18 AND cur_user=current_user;

	-- UPDATE COLUMNS
	FOR rec_column IN SELECT * FROM information_schema.columns, information_schema.tables
	WHERE tables.table_schema='SCHEMA_NAME' 
	AND columns.table_name=tables.table_name and columns.table_schema=tables.table_schema 
	AND tables.table_name in (select distinct table_name FROM information_schema.columns where table_schema=p_schemaname)
	AND concat(tables.table_name,column_name) not in (select concat(table_name,column_name) FROM information_schema.columns where table_schema=p_schemaname)
	AND table_type = 'BASE TABLE'

	LOOP
		v_sql = concat (concat ('ALTER TABLE ',p_schemaname,'.',rec_column.table_name,' ADD COLUMN ', rec_column.column_name,' '),
		(CASE 
		when rec_column.udt_name='varchar' then concat(rec_column.udt_name,'(',CASE WHEN rec_column.character_maximum_length IS NULL THEN 100 ELSE rec_column.character_maximum_length END,')')
		when rec_column.udt_name='numeric' then concat(rec_column.udt_name, 
		(CASE WHEN rec_column.numeric_precision IS NULL THEN null ELSE concat('(',rec_column.numeric_precision,',',rec_column.numeric_scale,')') END))
		else rec_column.udt_name end),' ;');

		IF rec_column.column_default is not null then 
			rec_column.column_default=replace(rec_column.column_default::text, 'SCHEMA_NAME' ,p_schemaname);
			v_sql= concat (v_sql, concat ('ALTER TABLE ',p_schemaname,'.',rec_column.table_name,' ALTER COLUMN ', rec_column.column_name,' SET DEFAULT ', rec_column.column_default));
		END IF;
		
		
		IF rec_column.is_nullable='NO' THEN
			INSERT INTO audit_check_data (fid, table_id, column_id, enabled, error_message)
			VALUES (18, rec_column.table_name,rec_column.column_name, false, 'NOT NULL values for new columns are not enabled to automatic copy/paste of this function');
		END IF;
		
		IF rec_column.udt_name='geometry' THEN 
			INSERT INTO audit_check_data (fid, table_id, column_id, enabled, error_message)
			VALUES (18, rec_column.table_name,rec_column.column_name, false, 'Geometry columns are not enabled to automatic copy/paste of this function');
		ELSE
			IF v_sql IS NOT NULL THEN
				INSERT INTO audit_check_data (fid, table_id, column_id, enabled, error_message)
				VALUES (18, rec_column.table_name,rec_column.column_name, true, v_sql );
				EXECUTE v_sql;
			END IF;
		END IF;
		
	END LOOP;

	-- Different Set default on same column
	FOR rec_column IN SELECT * FROM information_schema.columns, information_schema.tables
	WHERE tables.table_schema='SCHEMA_NAME' 
	AND columns.table_name=tables.table_name and columns.table_schema=tables.table_schema 
	AND tables.table_name in (select distinct table_name FROM information_schema.columns where table_schema=p_schemaname)
	AND concat(tables.table_name,column_name) not in (select concat(table_name,column_name) FROM information_schema.columns where table_schema=p_schemaname)
	AND table_type = 'BASE TABLE'
	LOOP
		IF rec_column.column_default != (select column_default FROM information_schema.columns where table_schema=p_schemaname 
		AND table_name=rec_column.table_name AND column_name=rec_column.table_name)THEN
			
		END IF;
	END LOOP;
	
	-- Different Not null on same column
	FOR rec_column IN SELECT * FROM information_schema.columns, information_schema.tables
	WHERE tables.table_schema='SCHEMA_NAME' 
	AND columns.table_name=tables.table_name and columns.table_schema=tables.table_schema 
	AND tables.table_name in (select distinct table_name FROM information_schema.columns where table_schema=p_schemaname)
	AND concat(tables.table_name,column_name) not in (select concat(table_name,column_name) FROM information_schema.columns where table_schema=p_schemaname)
	AND table_type = 'BASE TABLE'
	LOOP
		IF rec_column.is_nullable != (select is_nullable FROM information_schema.columns where table_schema=p_schemaname 
		AND table_name=rec_column.table_name AND column_name=rec_column.table_name) THEN
			INSERT INTO audit_check_data (fid, table_id, column_id, enabled, error_message)
			VALUES (18, rec_column.table_name,rec_column.column_name, false,  'NOT NULL constraint are diferents in both columns. Check it');
			
		END IF;
	END LOOP;
	

	-- COLUMNS WITH SAME NAME AND DIFERENT DATA_TYPE
	FOR rec_column IN SELECT * FROM information_schema.columns, information_schema.tables
	WHERE tables.table_schema='SCHEMA_NAME' 
	AND columns.table_name=tables.table_name and columns.table_schema=tables.table_schema 
	AND tables.table_name in (select distinct table_name FROM information_schema.columns where table_schema=p_schemaname)
	AND concat(tables.table_name,column_name,data_type) not in (select concat(table_name,column_name,data_type) FROM information_schema.columns where table_schema=p_schemaname)
	AND table_type = 'BASE TABLE'

	LOOP
			INSERT INTO audit_check_data (fid, table_id, column_id, enabled, error_message)
			VALUES (18, rec_column.table_name, rec_column.column_name, false, concat('Data type is diferent. Should be: ',rec_column_record.udt_name' and it is different'));

	END LOOP;

	-- CREATE NEW TABLES
	FOR rec_table IN
	SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE'
	AND tables.table_schema='SCHEMA_NAME' 
	AND tables.table_name not in (select distinct table_name FROM information_schema.columns where table_schema=p_schemaname)
	LOOP
      
		-- Create table in destination schema
		v_sql := concat('CREATE TABLE ',p_schemaname,'.',rec_table,' (LIKE SCHEMA_NAME.',rec_table,' INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS)');
		EXECUTE v_sql;

		INSERT INTO audit_check_data (fid, table_id, enabled, error_message)
		VALUES (18, rec_table, true, v_sql);
		
		-- Set contraints
		FOR column_, v_default IN
			SELECT column_name, REPLACE(column_default, 'SCHEMA_NAME', p_schemaname) 
			FROM information_schema.COLUMNS 
			WHERE table_schema = p_schemaname AND table_name = rec_table AND column_default LIKE 'nextval(%' || 'SCHEMA_NAME' || '%::regclass)'
		LOOP

		EXECUTE 'ALTER TABLE ' || rec_table || ' ALTER COLUMN ' || column_ || ' SET DEFAULT ' || v_default;

		INSERT INTO audit_check_data (fid, table_id, enabled, error_message)
		 VALUES (18, rec_table, true, concat('ALTER TABLE ',tablename,' ALTER COLUMN ',column_,' SET DEFAULT ',v_default ));
		END LOOP;
		
		-- Copy table contents to destination schema
		EXECUTE 'INSERT INTO '||p_schemaname||'.'|| rec_table || ' SELECT * FROM ' || 'SCHEMA_NAME' || '.' || rec_table; 	
        
	END LOOP;


	-- SEQUENCES
	-- Create sequences
	FOR rec_table IN SELECT sequence_name FROM information_schema.SEQUENCES WHERE sequence_schema = 'SCHEMA_NAME' AND sequence_name NOT IN 
	(SELECT sequence_name FROM information_schema.SEQUENCES WHERE sequence_schema = p_schemaname)
	LOOP
		EXECUTE 'CREATE SEQUENCE ' || p_schemaname || '.' || rec_table ||' INCREMENT 1  NO MINVALUE  NO MAXVALUE  START 1  CACHE 1';

		INSERT INTO audit_check_data (fid, table_id, column_id, enabled, error_message)

		VALUES (18, 'Sequence', v_sequence, true, concat ('CREATE SEQUENCE ',p_schemaname,'.',rec_table,' INCREMENT 1  NO MINVALUE  NO MAXVALUE  START 1  CACHE 1' ));
	END LOOP;
	
	-- Set sequences
	FOR rec_tablename IN SELECT * FROM sys_table WHERE sys_sequence IS NOT NULL
	LOOP 
		SELECT column_name INTO column_aux FROM information_schema.columns WHERE table_schema='SCHEMA_NAME' AND table_name=rec_tablename.id AND ordinal_position=1;
		IF column_aux IS NOT NULL THEN 
			EXECUTE 'ALTER TABLE '||p_schemaname||'.'||rec_tablename.id||' ALTER COLUMN '||column_aux||' SET DEFAULT nextval('' '||p_schemaname||'.'||rec_tablename.sys_sequence||' ''::regclass)';
			INSERT INTO audit_check_data (fid, table_id, column_id, enabled, error_message)
			VALUES (18, rec_tablename.id, column_aux, true, v_sql );
		ELSE
			INSERT INTO audit_check_data (fid, table_id, column_id, enabled, error_message)
			VALUES (18, v_tablename, column_aux, FALSE, 'Due an unexpected reason it was not possible to set default sequence value' );
		END IF;
			
	END LOOP;				
			
	RETURN 'OK' ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;