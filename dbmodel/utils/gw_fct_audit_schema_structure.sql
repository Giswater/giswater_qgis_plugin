/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP FUNCTION IF EXISTS "SCHEMA_NAME". gw_fct_audit_schema_structure(character varying);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_schema_structure(foreign_schema character varying) RETURNS void AS $BODY$
DECLARE
   
BEGIN

   -- Search path
    SET search_path = "SCHEMA_NAME", public;


 
-- AUDIT SCHEMA

	DROP VIEW IF EXISTS "v_audit_schema_column" CASCADE;
	CREATE OR REPLACE VIEW "v_audit_schema_column" AS 
	select
	table_name||'_'||column_name as id,
	table_catalog,
	table_schema,
	table_name,
	column_name,
	udt_name as column_type,
	ordinal_position
	FROM information_schema.columns
	where table_schema='SCHEMA_NAME' and udt_name <> 'inet';


	DROP VIEW IF EXISTS "v_audit_schema_table" CASCADE;
	CREATE OR REPLACE VIEW "v_audit_schema_table" AS 
	select
	table_catalog,
	table_schema,
	table_name
	FROM information_schema.columns
	where table_schema='SCHEMA_NAME';


	DROP VIEW IF EXISTS v_audit_schema_catalog_column CASCADE;
	CREATE OR REPLACE VIEW v_audit_schema_catalog_column AS 
	 SELECT (db_cat_table.name || '_'::text) || db_cat_columns.column_name AS id, 
		db_cat_table.name AS table_name, 
		db_cat_columns.column_name, 
		db_cat_columns.column_type, 
		db_cat_columns.description
	   FROM db_cat_columns
	   JOIN db_cat_table ON db_cat_columns.db_cat_table_id = db_cat_table.id;



-- COMPARE WITH CATALOG

	DROP VIEW IF EXISTS "v_audit_schema_catalog_compare_table" CASCADE;
	CREATE OR REPLACE VIEW "v_audit_schema_catalog_compare_table" AS 
	SELECT
		table_name as schema_table_name
		name as catalog_table_name
		FROM information_schema.columns
		LEFT JOIN db_cat_table ON name=table_name
		WHERE table_schema='SCHEMA_NAME'
	UNION
		SELECT
		table_name as schema_table_name
		name as catalog_table_name
		FROM information_schema.columns
		RIGHT JOIN db_cat_table ON name=table_name
		WHERE table_schema='SCHEMA_NAME'


	DROP VIEW IF EXISTS v_audit_schema_catalog_compare_column CASCADE;
	CREATE VIEW v_audit_schema_catalog_compare_column AS
	SELECT
		v_audit_schema_column.table_name as audit_table,
		v_audit_schema_column.column_name as audit_column,
		v_audit_catalog_column.table_name as cat_table,
		v_audit_catalog_column.column_name cat_column
		from v_audit_schema_column
		left join v_audit_catalog_column on v_audit_catalog_column.id=v_audit_schema_column.id
		where v_audit_catalog_column.column_name is null
	UNION
		select
		v_audit_schema_column.table_name as audit_table,
		v_audit_schema_column.column_name as audit_column,
		v_audit_catalog_column.table_name as cat_table,
		v_audit_catalog_column.column_name cat_column
		from v_audit_schema_column
		right join v_audit_catalog_column on v_audit_catalog_column.id=v_audit_schema_column.id
		where v_audit_schema_column.column_name is null
		ORDER BY 1;



-- COMPARE WITH FOREIGN SCHEMA

   	DROP VIEW IF EXISTS "v_audit_schema_foreign_table" CASCADE;
	CREATE OR REPLACE VIEW "v_audit_schema_foreign_table" AS 
	SELECT
		table_catalog,
		table_schema,
		table_name
		FROM information_schema.columns
		where table_schema = foreign_schema;

		
	DROP VIEW IF EXISTS "v_audit_schema_foreign_column" CASCADE;
	CREATE OR REPLACE VIEW "v_audit_schema_foreign_column" AS 
	SELECT
		table_name||'_'||column_name as id,
		table_catalog,
		table_schema,
		table_name,
		column_name,
		udt_name as column_type,
		ordinal_position
		FROM information_schema.columns
		WHERE table_schema = foreign_schema and udt_name <> 'inet';


	DROP VIEW IF EXISTS v_audit_schema_foreign_compare_table CASCADE;
	CREATE VIEW v_audit_schema_foreign_compare_table AS
	SELECT
		v_audit_schema_table.table_name,
		v_audit_schema_foreign_table.table_name as foreign_table
		from v_audit_schema_table
		left join v_audit_schema_foreign_table on v_audit_schema_foreign_table.table_name=v_audit_schema_table.table_name
		where v_audit_schema_foreign_table.table_name is null
	UNION
	SELECT
		v_audit_schema_table.table_name,
		v_audit_schema_foreign_table.table_name as foreign_table
		from v_audit_schema_table
		right join v_audit_schema_foreign_table on v_audit_schema_foreign_table.table_name=v_audit_schema_table.table_name
		where v_audit_schema_table.table_name is null
		ORDER BY 1,2;


	DROP VIEW IF EXISTS v_audit_schema_foreign_compare_column CASCADE;
	CREATE VIEW v_audit_schema_foreign_compare_column AS
	SELECT
		v_audit_schema_column.table_name,
		v_audit_schema_column.ordinal_position,
		v_audit_schema_column.column_name,
		v_audit_schema_column.column_type,
		v_audit_schema_foreign_column.table_name as foreign_table,
		v_audit_schema_foreign_column.ordinal_position as foreign_position,
		v_audit_schema_foreign_column.column_name as foreign_column
		from v_audit_schema_column
		left join v_audit_schema_foreign_column on v_audit_schema_foreign_column.id=v_audit_schema_column.id
		where v_audit_schema_foreign_column.column_name is null
	UNION
	SELECT
		v_audit_schema_column.table_name,
		v_audit_schema_column.ordinal_position,
		v_audit_schema_column.column_name,
		v_audit_schema_column.column_type,
		v_audit_schema_foreign_column.table_name as foreign_table,
		v_audit_schema_foreign_column.ordinal_position as foreign_position,
		v_audit_schema_foreign_column.column_name as foreign_column
		from v_audit_schema_column
		right join v_audit_schema_foreign_column on v_audit_schema_foreign_column.id=v_audit_schema_column.id
		where v_audit_schema_column.column_name is null
		ORDER BY 1,2,4,5;



RETURN;   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  

