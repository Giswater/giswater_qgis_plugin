/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NUMBER: 2426

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_schema_repair(schema_name_aux character varying)
  RETURNS text AS
$BODY$
DECLARE
    v_table_ddl   text;
    v_pk_ddl	text;
    column_record record;
    tablename_aux text;
    tablename_rec record;
    v_sql_aux text;
    column_rec record;
    v_table_dml text;
    column_aux text;
    sequence_aux text;
    rec_table text;
    column_ text;
    default_ text;
    
    
    
BEGIN

	SET search_path='SCHEMA_NAME', public;


	DELETE FROM audit_log_project WHERE fprocesscat_id=18 AND user_name=current_user;


	-- UPDATE COLUMNS
	FOR column_rec IN SELECT * FROM information_schema.columns, information_schema.tables
	WHERE tables.table_schema='SCHEMA_NAME' 
	AND columns.table_name=tables.table_name and columns.table_schema=tables.table_schema 
	AND tables.table_name in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND concat(tables.table_name,column_name) not in (select concat(table_name,column_name) FROM information_schema.columns where table_schema=schema_name_aux)
	AND table_type = 'BASE TABLE'

	
	LOOP
		v_sql_aux = concat (concat ('ALTER TABLE ',schema_name_aux,'.',column_rec.table_name,' ADD COLUMN ', column_rec.column_name,' '),
		(CASE 
		when column_rec.udt_name='varchar' then concat(column_rec.udt_name,'(',CASE WHEN column_rec.character_maximum_length IS NULL THEN 100 ELSE column_rec.character_maximum_length END,')')
		when column_rec.udt_name='numeric' then concat(column_rec.udt_name, 
		(CASE WHEN column_rec.numeric_precision IS NULL THEN null ELSE concat('(',column_rec.numeric_precision,',',column_rec.numeric_scale,')') END))
		else column_rec.udt_name end),' ;');

		IF column_rec.column_default is not null then 
			column_rec.column_default=replace(column_rec.column_default::text, 'SCHEMA_NAME' ,schema_name_aux);
			v_sql_aux= concat (v_sql_aux, concat ('ALTER TABLE ',schema_name_aux,'.',column_rec.table_name,' ALTER COLUMN ', column_rec.column_name,' SET DEFAULT ', column_rec.column_default));
		END IF;
		
		
		IF column_rec.is_nullable='NO' THEN
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, enabled, log_message) 
			VALUES (18, column_rec.table_name,column_rec.column_name, false, 'NOT NULL values for new columns are not enabled to automatic copy/paste of this function');
		END IF;
		
		IF column_rec.udt_name='geometry' THEN 
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, enabled, log_message) 
			VALUES (18, column_rec.table_name,column_rec.column_name, false, 'Geometry columns are not enabled to automatic copy/paste of this function');
		ELSE
			IF v_sql_aux IS NOT NULL THEN
				INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, enabled, log_message) 
				VALUES (18, column_rec.table_name,column_rec.column_name, true, v_sql_aux );
				EXECUTE v_sql_aux;
			END IF;
		END IF;
		
	END LOOP;

	-- Different Set default on same column
	FOR column_rec IN SELECT * FROM information_schema.columns, information_schema.tables
	WHERE tables.table_schema='SCHEMA_NAME' 
	AND columns.table_name=tables.table_name and columns.table_schema=tables.table_schema 
	AND tables.table_name in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND concat(tables.table_name,column_name) not in (select concat(table_name,column_name) FROM information_schema.columns where table_schema=schema_name_aux)
	AND table_type = 'BASE TABLE'
	LOOP
		IF column_rec.column_default != (select column_default FROM information_schema.columns where table_schema=schema_name_aux 
		AND table_name=column_rec.table_name AND column_name=column_rec.table_name)THEN
			
		END IF;
	END LOOP;
	
	-- Different Not null on same column
	FOR column_rec IN SELECT * FROM information_schema.columns, information_schema.tables
	WHERE tables.table_schema='SCHEMA_NAME' 
	AND columns.table_name=tables.table_name and columns.table_schema=tables.table_schema 
	AND tables.table_name in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND concat(tables.table_name,column_name) not in (select concat(table_name,column_name) FROM information_schema.columns where table_schema=schema_name_aux)
	AND table_type = 'BASE TABLE'
	LOOP
		IF column_rec.is_nullable != (select is_nullable FROM information_schema.columns where table_schema=schema_name_aux 
		AND table_name=column_rec.table_name AND column_name=column_rec.table_name) THEN
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, enabled, log_message) 
			VALUES (18, column_rec.table_name,column_rec.column_name, false,  'NOT NULL constraint are diferents in both columns. Check it');
			
		END IF;
	END LOOP;
	

	-- COLUMNS WITH SAME NAME AND DIFERENT DATA_TYPE
	FOR column_rec IN SELECT * FROM information_schema.columns, information_schema.tables
	WHERE tables.table_schema='SCHEMA_NAME' 
	AND columns.table_name=tables.table_name and columns.table_schema=tables.table_schema 
	AND tables.table_name in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND concat(tables.table_name,column_name,data_type) not in (select concat(table_name,column_name,data_type) FROM information_schema.columns where table_schema=schema_name_aux)
	AND table_type = 'BASE TABLE'

	LOOP
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, enabled, log_message) 
			VALUES (18, column_rec.table_name, column_rec.column_name, false, concat('Data type is diferent. Should be: ',column_record.udt_name' and it is different'));

	END LOOP;


	-- CREATE NEW TABLES
	FOR rec_table IN
	SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE'
	AND tables.table_schema='SCHEMA_NAME' 
	AND tables.table_name not in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	LOOP
      
		-- Create table in destination schema
		v_sql_aux := concat('CREATE TABLE ',schema_name_aux,'.',rec_table,' (LIKE SCHEMA_NAME.',rec_table,' INCLUDING CONSTRAINTS INCLUDING INDEXES INCLUDING DEFAULTS)');
		EXECUTE v_sql_aux;

		INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) 
		VALUES (18, rec_table, true, v_sql_aux);
		
		-- Set contraints
		FOR column_, default_ IN
			SELECT column_name, REPLACE(column_default, 'SCHEMA_NAME', schema_name_aux) 
			FROM information_schema.COLUMNS 
			WHERE table_schema = schema_name_aux AND table_name = rec_table AND column_default LIKE 'nextval(%' || 'SCHEMA_NAME' || '%::regclass)'
		LOOP

		EXECUTE 'ALTER TABLE ' || rec_table || ' ALTER COLUMN ' || column_ || ' SET DEFAULT ' || default_;

		INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) 
		 VALUES (18, rec_table, true, concat('ALTER TABLE ',tablename,' ALTER COLUMN ',column_,' SET DEFAULT ',default_ ));
		END LOOP;
		
		-- Copy table contents to destination schema
		EXECUTE 'INSERT INTO '||schema_name_aux||'.'|| rec_table || ' SELECT * FROM ' || 'SCHEMA_NAME' || '.' || rec_table; 	
        
	END LOOP;


	-- SEQUENCES
	-- Create sequences
	FOR rec_table IN SELECT sequence_name FROM information_schema.SEQUENCES WHERE sequence_schema = 'SCHEMA_NAME' AND sequence_name NOT IN 
	(SELECT sequence_name FROM information_schema.SEQUENCES WHERE sequence_schema = schema_name_aux)
	LOOP
		EXECUTE 'CREATE SEQUENCE ' || schema_name_aux || '.' || rec_table ||' INCREMENT 1  NO MINVALUE  NO MAXVALUE  START 1  CACHE 1';

		INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, enabled, log_message) 

		VALUES (18, 'Sequence', sequence_aux, true, concat ('CREATE SEQUENCE ',schema_name_aux,'.',rec_table,' INCREMENT 1  NO MINVALUE  NO MAXVALUE  START 1  CACHE 1' ));
	END LOOP;
	
	-- Set sequences
	FOR tablename_rec IN SELECT * FROM audit_cat_table WHERE sys_sequence IS NOT NULL
	LOOP 
		SELECT column_name INTO column_aux FROM information_schema.columns WHERE table_schema='SCHEMA_NAME' AND table_name=tablename_rec.id AND ordinal_position=1;
		IF column_aux IS NOT NULL THEN 
			EXECUTE 'ALTER TABLE '||schema_name_aux||'.'||tablename_rec.id||' ALTER COLUMN '||column_aux||' SET DEFAULT nextval('' '||schema_name_aux||'.'||tablename_rec.sys_sequence||' ''::regclass)';
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, enabled, log_message) 
			VALUES (18, tablename_rec.id, column_aux, true, v_sql_aux );
		ELSE
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, enabled, log_message) 
			VALUES (18, tablename_aux, column_aux, FALSE, 'Due an unexpected reason it was not possible to set default sequence value' );
		END IF;
			
	END LOOP;				
	

		
RETURN 'OK' ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;