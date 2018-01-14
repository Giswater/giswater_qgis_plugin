CREATE OR REPLACE FUNCTION ws30.gw_fct_audit_migrate_table(schema_name_aux varchar)
  RETURNS text AS
$BODY$
DECLARE
    v_table_ddl   text;
    v_pk_ddl	text;
    column_record record;
    tablename_aux text;
    v_sql_aux text;
    column_rec record;
    
BEGIN

	SET search_path='ws30', public;


	DELETE FROM audit_log_project WHERE fprocesscat_id=18 AND user_name=current_user;

	INSERT INTO audit_log_project (fprocesscat_id, table_id, error_message) 	VALUES (18, 'v*',  'table with v* are no managed');

	-- Update new columns
	FOR column_rec IN SELECT * FROM information_schema.columns
	where table_schema='ws30' 
	AND table_name in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND column_name not in (select distinct column_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND substring(table_name from 1 for 2) !='v_'
	AND udt_name <> 'inet'
	LOOP
		v_sql_aux = concat (concat ('ALTER TABLE ',schema_name_aux,'.',column_rec.table_name,' ADD COLUMN ', column_rec.column_name,' '),
		(CASE 
		when column_rec.udt_name='varchar' then concat(column_rec.udt_name,'(',CASE WHEN column_rec.character_maximum_length IS NULL THEN 100 ELSE column_rec.character_maximum_length END,')')
		when column_rec.udt_name='numeric' then concat(column_rec.udt_name, 
		(CASE WHEN column_rec.numeric_precision IS NULL THEN null ELSE concat('(',column_rec.numeric_precision,',',column_rec.numeric_scale,')') END))
		else column_rec.udt_name end),' ;');


		IF column_rec.column_default is not null then 
			v_sql_aux= concat (v_sql_aux, concat ('ALTER TABLE ',schema_name_aux,'.',column_rec.table_name,' ALTER COLUMN ', column_rec.column_name,' SET DEFAULT ', column_rec.column_default));
		END IF;
		
		
		IF column_rec.is_nullable='NO' THEN
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, error_message) 
			VALUES (18, column_rec.table_name,column_rec.column_name, 'NOT NULL values for new columns are not enabled to automatic copy/paste of this function');
		END IF;
		
		IF column_rec.udt_name='geometry' THEN 
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, error_message) 
			VALUES (18, column_rec.table_name,column_rec.column_name, 'Geometry columns are not enabled to automatic copy/paste of this function');
		ELSE
			IF v_sql_aux IS NOT NULL THEN
				EXECUTE v_sql_aux;
			END IF;
		END IF;
		
	END LOOP;

	-- Different Set default on same column
	FOR column_rec IN SELECT * FROM information_schema.columns
	where table_schema='ws30' 
	AND table_name in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND column_name in (select distinct column_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND substring(table_name from 1 for 2) !='v_'
	AND udt_name <> 'inet'
	LOOP
		IF column_rec.column_default != (select column_default FROM information_schema.columns where table_schema=schema_name_aux 
		AND table_name=column_rec.table_name AND column_name=column_rec.table_name)THEN
			
		END IF;
	END LOOP;
	
	-- Different Not null on same column
	FOR column_rec IN SELECT * FROM information_schema.columns
	where table_schema='ws30' 
	AND table_name in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND column_name in (select distinct column_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND substring(table_name from 1 for 2) !='v_'
	AND udt_name <> 'inet'
	LOOP
		IF column_rec.is_nullable != (select is_nullable FROM information_schema.columns where table_schema=schema_name_aux 
		AND table_name=column_rec.table_name AND column_name=column_rec.table_name) THEN
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, error_message) 
			VALUES (18, column_rec.table_name,column_rec.column_name, 'NOT NULL constraint are diferents in both columns. Check it');
			
		END IF;
	END LOOP;
	
	-- Different data type on same column
	FOR column_rec IN SELECT * FROM information_schema.columns
	where table_schema='ws30' 
	AND table_name in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND column_name not in (select distinct column_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND substring(table_name from 1 for 2) !='v_'
	AND udt_name <> 'inet'
	LOOP
		IF column_rec.udt_name != (select udt_name FROM information_schema.columns where table_schema=schema_name_aux 
		AND table_name=column_rec.table_name AND column_name=column_rec.table_name) THEN
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, error_message) 
			VALUES (18, column_rec.table_name, column_rec.column_name, 'Data type is diferent. Should be: ',column_record.udt_name' and it is different');
		END IF;
	END LOOP;

	

	-- CREATE NEW TABLES
    	FOR tablename_aux IN SELECT DISTINCT table_name
	FROM information_schema.columns
	where table_schema='test_ws' 
	AND table_name not in (select distinct table_name FROM information_schema.columns where table_schema=schema_name_aux)
	AND substring(table_name from 1 for 2) !='v_'
	order by table_name desc
	LOOP
		FOR column_record IN 
		SELECT 
		b.nspname as schema_name,
		b.relname as table_name,
		a.attname as column_name,
		pg_catalog.format_type(a.atttypid, a.atttypmod) as column_type,
		CASE WHEN 
			(SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
			FROM pg_catalog.pg_attrdef d
			WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef) IS NOT NULL THEN
			'DEFAULT '|| (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
				FROM pg_catalog.pg_attrdef d
				WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef)
		ELSE
			''
		END as column_default_value,
		CASE WHEN a.attnotnull = true THEN 
				'NOT NULL'
		ELSE
			'NULL'
		END as column_not_null,
		a.attnum as attnum,
		e.max_attnum as max_attnum
		FROM 
		pg_catalog.pg_attribute a
		INNER JOIN 
		(SELECT c.oid,
			n.nspname,
			c.relname
		FROM pg_catalog.pg_class c
			LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
		WHERE c.relname ~ ('^('||tablename_aux||')$')
			AND pg_catalog.pg_table_is_visible(c.oid)
		ORDER BY 2, 3) b
		ON a.attrelid = b.oid
		INNER JOIN 
		(SELECT 
			a.attrelid,
			max(a.attnum) as max_attnum
		FROM pg_catalog.pg_attribute a
		WHERE a.attnum > 0 
				AND NOT a.attisdropped
		GROUP BY a.attrelid) e
		ON a.attrelid=e.attrelid
		WHERE a.attnum > 0 
		AND NOT a.attisdropped
		ORDER BY a.attnum
		LOOP
			IF column_record.attnum = 1 THEN
			v_table_ddl:='CREATE TABLE '||schema_name_aux||'.'||column_record.table_name||' (';
			ELSE
			v_table_ddl:=v_table_ddl||',';
			END IF;
		
			IF column_record.attnum <= column_record.max_attnum THEN
			v_table_ddl:=v_table_ddl||chr(10)||
			'    "'||column_record.column_name||'" '||column_record.column_type||' '||column_record.column_default_value||' '||column_record.column_not_null;
			END IF;
		END LOOP;
		v_table_ddl:=v_table_ddl||');';

		IF (SELECT sys_criticity FROM audit_cat_table WHERE table_id=column_record.table_name)=3 THEN 
			v_table_dml= 'INSERT INTO '||schema_name_aux||'.'||column_record.table_name||' SELECT * FROM ws30.'||column_record.table_name||;
		END IF; 

   		IF v_pk_ddl IS NOT NULL THEN
			EXECUTE v_table_ddl;
			
		ELSE 
			INSERT INTO audit_log_project (fprocesscat_id, table_id, error_message) 
			VALUES (18, column_record.table_name, 'Due unexpected reason the table was not copied');
		END IF;
			

		-- PRIMARY KEY
		SELECT concat('ALTER TABLE ',schema_name_aux,'.',column_record.table_name,' ADD CONSTRAINT ',relname,'_',pg_attribute.attname,'_pkey PRIMARY KEY( ',pg_attribute.attname,' );') INTO v_pk_ddl
		FROM pg_index, pg_class, pg_namespace, pg_attribute
		WHERE   
		relname=column_record.table_name AND
		indrelid = pg_class.oid AND   nspname = 'test_ws' AND   pg_class.relnamespace = pg_namespace.oid 
		AND   pg_attribute.attrelid = pg_class.oid AND   pg_attribute.attnum = any(pg_index.indkey) AND indisprimary;
 
		IF v_pk_ddl IS NOT NULL THEN
			EXECUTE v_pk_ddl;
		ELSE
			INSERT INTO audit_log_project (fprocesscat_id, table_id, column_id, error_message) 
			VALUES (18, column_record.table_name, column_record.column_name, 'Due unexpected reason the table was not copied');
		END IF;
    
	END LOOP;
RETURN 'OK' ;
END;
$BODY$
  LANGUAGE 'plpgsql' COST 100.0 SECURITY INVOKER;