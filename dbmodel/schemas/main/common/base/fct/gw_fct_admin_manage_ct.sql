/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2724

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_schema_manage_ct(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_ct(p_data json)
  RETURNS json AS
$BODY$

/*
warning: it seems that NOT WORKS: 
ALTER TABLE gully_type DROP CONSTRAINT gully_type_id_fkey;
ALTER TABLE gully_type  ADD CONSTRAINT gully_type_id_fkey FOREIGN KEY (id) REFERENCES SCHEMA_NAME.cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, 
"data":{"action":"DROP"}}$$)

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, 
"data":{"action":"ADD"}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, 
"data":{"action":"DISABLE TOPO-TRIGGERS"}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, 
"data":{"action":"ENABLE TOPO-TRIGGERS"}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, 
"data":{"action":"RENAME", "table":"cat_feature_arc", "oldName":"arc_type_type_fkey", "newName":"cat_feature_arc_type_fkey"}}$$)}}$$)

-- fid: 136,137

*/

DECLARE

v_schemaname text;
v_tablerecord record;
v_query_text text;
v_action text;
v_return json;
v_36 integer=0;
v_37 integer=0;
v_projectype text;
v_table text;
v_oldname text;
v_newname text;
v_ctexists text;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	SELECT project_type INTO v_projectype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	v_action = (p_data->>'data')::json->>'action';
	v_table = (p_data->>'data')::json->>'table';
	v_oldname = (p_data->>'data')::json->>'oldName';
	v_newname = (p_data->>'data')::json->>'newName';

	IF v_action = 'DROP' THEN

		DELETE FROM temp_table WHERE fid=136;

		-- fk
		INSERT INTO temp_table (fid, text_column)
		SELECT distinct on (conname)
		136,
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
		WHERE  contype IN ('f')
		AND nspname ='SCHEMA_NAME';

		-- ckeck
		INSERT INTO temp_table (fid, text_column)
		SELECT distinct on (conname)
		136,
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
		WHERE  contype IN ('c')
		AND nspname ='SCHEMA_NAME';

		-- unique
		INSERT INTO temp_table (fid, text_column)
		SELECT distinct on (conname)
		136,
		concat(
		'{"tablename":"',
		conrelid::regclass,
		'","constraintname":"',
		conname,
		'","definition":"',
		replace (pg_get_constraintdef(c.oid),'"',''),
		'"}')
		FROM   pg_constraint c
		JOIN   pg_namespace n ON n.oid = c.connamespace
		join   information_schema.table_constraints tc ON conname=constraint_name
		WHERE  contype IN ('u')
		AND nspname ='SCHEMA_NAME';

		-- Insert not null on temp_table
		DELETE FROM temp_table WHERE fid=137;

		INSERT INTO temp_table (fid, text_column)
		SELECT distinct
				137,
				concat(
				'{"tablename":"',
				table_name,
				'","attributename":"',
				column_name,
				'","definition":"',
				--pg_get_attributedef(c.oid),
				'"}')
		FROM information_schema.columns
		WHERE table_schema = 'SCHEMA_NAME'
		AND is_nullable='NO' and concat(column_name,'_',table_name) not in (select concat(kcu.column_name,'_',tc.table_name)  FROM 
 		 	  information_schema.table_constraints AS tc 
  			  JOIN information_schema.key_column_usage AS kcu
  			  ON tc.constraint_name = kcu.constraint_name AND tc.table_schema = kcu.table_schema
			  WHERE tc.constraint_type = 'PRIMARY KEY' OR tc.constraint_type ='UNIQUE');


		-- Insert unique on temp_table
		DELETE FROM temp_table WHERE fid=138;
		
		INSERT INTO temp_table (fid, text_column)
		SELECT distinct on (conname)
		138,
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
		WHERE  contype IN ('u')
		AND nspname ='SCHEMA_NAME';


		-- Insert check on temp_table
		DELETE FROM temp_table WHERE fid=139;
		
		INSERT INTO temp_table (fid, text_column)
		SELECT distinct on (conname)
		139,
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
		WHERE  contype IN ('c')
		AND nspname ='SCHEMA_NAME';


		-- Drop fk
		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fid=136
		LOOP
			v_query_text:= 'ALTER TABLE '||quote_ident((v_tablerecord.text_column)::json->>'tablename')||
				       ' DROP CONSTRAINT IF EXISTS '||quote_ident((v_tablerecord.text_column)::json->>'constraintname')||' CASCADE;';
			EXECUTE v_query_text;
			v_36=v_36+1;
		END LOOP;

		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fid=137
		LOOP
			v_query_text:= 'ALTER TABLE '||quote_ident((v_tablerecord.text_column)::json->>'tablename')||
				       ' ALTER COLUMN '||quote_ident((v_tablerecord.text_column)::json->>'attributename')||' DROP NOT NULL;';
			EXECUTE v_query_text;
			v_37=v_37+1;
		END LOOP;


		v_query_text =  'SELECT *  FROM sys_foreignkey';
		FOR v_tablerecord IN EXECUTE v_query_text LOOP				
			EXECUTE 'ALTER TABLE '||v_tablerecord.target_table||' DISABLE TRIGGER gw_trg_typevalue_fk';
		END LOOP;

		-- Disable topocontrol triggers
		ALTER TABLE node DISABLE TRIGGER gw_trg_topocontrol_node;
		ALTER TABLE node DISABLE TRIGGER gw_trg_node_arc_divide;
		ALTER TABLE node DISABLE TRIGGER gw_trg_node_statecontrol;
		ALTER TABLE arc DISABLE TRIGGER gw_trg_topocontrol_arc;
		ALTER TABLE connec DISABLE TRIGGER gw_trg_connec_proximity_insert;
		ALTER TABLE connec DISABLE TRIGGER gw_trg_connec_proximity_update;
			
		v_return = concat('{"constraints dropped":"',v_36,'","notnull dropped":"',v_37,'"}');	
		
	ELSIF v_action = 'DISABLE TOPO-TRIGGERS' THEN
		ALTER TABLE node DISABLE TRIGGER gw_trg_topocontrol_node;
		ALTER TABLE node DISABLE TRIGGER gw_trg_node_arc_divide;
		ALTER TABLE node DISABLE TRIGGER gw_trg_node_statecontrol;
		ALTER TABLE arc DISABLE TRIGGER gw_trg_topocontrol_arc;
		ALTER TABLE connec DISABLE TRIGGER gw_trg_connec_proximity_insert;
		ALTER TABLE connec DISABLE TRIGGER gw_trg_connec_proximity_update;

		v_return = '{"Triggers disabled":"6"}';	

	ELSIF v_action = 'ENABLE TOPO-TRIGGERS' THEN
		ALTER TABLE node ENABLE TRIGGER gw_trg_topocontrol_node;
		ALTER TABLE node ENABLE TRIGGER gw_trg_node_statecontrol;
		ALTER TABLE node ENABLE TRIGGER gw_trg_node_arc_divide;
		ALTER TABLE arc ENABLE TRIGGER gw_trg_topocontrol_arc;
		ALTER TABLE connec ENABLE TRIGGER gw_trg_connec_proximity_insert;
		ALTER TABLE connec ENABLE TRIGGER gw_trg_connec_proximity_update;

		v_return = '{"Triggers enabled":"6"}';	

	ELSIF v_action = 'ADD' THEN

		-- Enable constraints 
		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fid=136 order by 1 desc
		LOOP
			v_query_text:=  'ALTER TABLE '||quote_ident((v_tablerecord.text_column::json)->>'tablename')|| 
							' ADD CONSTRAINT '||quote_ident((v_tablerecord.text_column::json)->>'constraintname')||
							' '||((v_tablerecord.text_column::json)->>'definition');
			EXECUTE v_query_text;
			v_36=v_36+1;
		END LOOP;

		
		FOR v_tablerecord IN SELECT * FROM temp_table WHERE fid=137 order by 1 desc
		LOOP
			v_query_text:=  'ALTER TABLE '||quote_ident((v_tablerecord.text_column::json)->>'tablename')|| 
							' ALTER COLUMN '||quote_ident((v_tablerecord.text_column::json)->>'attributename')||' SET NOT NULL;' ;
			EXECUTE v_query_text;
			v_37=v_37+1;	
		END LOOP;

		-- Enable custom foreing keys (to activate when bug solved)
		
		v_query_text =  'SELECT *  FROM sys_foreignkey';
		FOR v_tablerecord IN EXECUTE v_query_text LOOP				
			EXECUTE 'ALTER TABLE '||v_tablerecord.target_table||' ENABLE TRIGGER gw_trg_typevalue_fk';
		END LOOP;
		


		-- Enable topocontrol triggers
		ALTER TABLE node ENABLE TRIGGER gw_trg_topocontrol_node;
		ALTER TABLE node ENABLE TRIGGER gw_trg_node_arc_divide;
		ALTER TABLE node ENABLE TRIGGER gw_trg_node_statecontrol;
		ALTER TABLE arc ENABLE TRIGGER gw_trg_topocontrol_arc;
		ALTER TABLE connec ENABLE TRIGGER gw_trg_connec_proximity_insert;
		ALTER TABLE connec ENABLE TRIGGER gw_trg_connec_proximity_update;

		v_return = concat('{"constraints reloaded":"',v_36,'","notnull reloaded":"',v_37,'"}');
	
	ELSIF v_action = 'RENAME' THEN
		EXECUTE 'SELECT con.conname FROM pg_catalog.pg_constraint con INNER JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
            INNER JOIN pg_catalog.pg_namespace nsp ON nsp.oid = connamespace 
            WHERE nsp.nspname = '||quote_literal(v_schemaname)||' AND rel.relname = '||quote_literal(v_table)||' 
            and con.conname='||quote_literal(v_oldname)||''
        INTO v_ctexists;

		IF v_ctexists IS NOT NULL THEN
            EXECUTE 'ALTER TABLE '||v_table||' RENAME CONSTRAINT '||v_oldname||' TO '||v_newname||'';
        END IF;
	END IF;

	RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
