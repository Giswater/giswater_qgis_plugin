/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NUMBER: 2424

--DROP FUNCTION IF EXISTS "SCHEMA_NAME". gw_fct_audit_schema_check(character varying);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_schema_check(foreign_schema character varying) RETURNS void AS $BODY$
DECLARE
   v_sql	varchar;

BEGIN

-- Search path
    SET search_path = "SCHEMA_NAME", public;

 
-- DROP VIEWS
	DROP VIEW IF EXISTS "v_audit_schema_column" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_table" CASCADE;
   	DROP VIEW IF EXISTS "v_audit_schema_foreign_table" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_foreign_column" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_foreign_column_aux" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_foreign_compare_table" CASCADE;
	DROP VIEW IF EXISTS "v_audit_schema_foreign_compare_column" CASCADE;


-- AUDIT SCHEMA
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

	CREATE OR REPLACE VIEW "v_audit_schema_table" AS 
	select distinct on (table_name)
	table_catalog,
	table_schema,
	table_name
	FROM information_schema.columns
	where table_schema='SCHEMA_NAME';



-- COMPARE WITH FOREIGN SCHEMA

v_sql:= 'CREATE OR REPLACE VIEW v_audit_schema_foreign_table AS SELECT table_catalog,table_schema,table_name FROM information_schema.columns where table_schema ='||quote_literal(foreign_schema)||';';    
EXECUTE v_sql;

v_sql:=	'CREATE OR REPLACE VIEW v_audit_schema_foreign_column_aux AS SELECT table_name as tn, column_name as cn ,table_catalog,table_schema,table_name,column_name,udt_name as column_type,ordinal_position,udt_name FROM information_schema.columns WHERE table_schema = '||quote_literal(foreign_schema)||';'; 
EXECUTE v_sql;

	CREATE VIEW v_audit_schema_foreign_column AS
	SELECT
		tn||'_'||cn as id,
		table_catalog,
		table_schema,
		table_name,
		column_name,
		udt_name as column_type,
		ordinal_position
		FROM v_audit_schema_foreign_column_aux
		WHERE udt_name <> 'inet';

	CREATE VIEW v_audit_schema_foreign_compare_column AS
	SELECT
       (row_number() OVER (ORDER BY v_audit_schema_column.table_name)) AS rid,
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
		(row_number() OVER (ORDER BY v_audit_schema_column.table_name))+10000 AS rid,
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
		ORDER BY 2,3,5,6;

	CREATE VIEW v_audit_schema_foreign_compare_table AS
	SELECT
       (row_number() OVER (ORDER BY v_audit_schema_table.table_name)) AS rid,
		v_audit_schema_table.table_name,
		v_audit_schema_foreign_table.table_name as foreign_table
		from v_audit_schema_table
		left join v_audit_schema_foreign_table on v_audit_schema_foreign_table.table_name=v_audit_schema_table.table_name
		where v_audit_schema_foreign_table.table_name is null
		GROUP BY 2,3
	UNION
	SELECT
       (row_number() OVER (ORDER BY v_audit_schema_table.table_name))+10000 AS rid,
		v_audit_schema_table.table_name,
		v_audit_schema_foreign_table.table_name as foreign_table
		from v_audit_schema_table
		right join v_audit_schema_foreign_table on v_audit_schema_foreign_table.table_name=v_audit_schema_table.table_name
		where v_audit_schema_table.table_name is null
		GROUP BY 2,3
		ORDER BY 2,3;


RETURN;   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  

