/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



DROP VIEW IF EXISTS v_audit_functions;
CREATE VIEW v_audit_functions AS 
SELECT tstamp, audit_cat_error.id, audit_cat_error.error_message, audit_cat_error.hint_message, audit_cat_error.log_level, audit_cat_error.show_user, user_name, addr, debug_info
FROM audit_function_actions INNER JOIN audit_cat_error ON audit_function_actions.audit_cat_error_id = audit_cat_error.id
ORDER BY audit_function_actions.id DESC;



DROP VIEW IF EXISTS v_audit_db_columns;
CREATE OR REPLACE VIEW v_audit_db_columns AS 
SELECT (table_name || '_'::text) || column_name AS id, 
    table_name, 
    column_name, 
    column_type
	FROM audit_db_columns
	ORDER BY table_name, column_name;



DROP VIEW IF EXISTS v_db_cat_columns;
CREATE VIEW v_db_cat_columns AS
SELECT
	name||'_'||column_name as id,
	name as table_name,
	column_name,
	column_type,
	db_cat_columns.description
	FROM db_cat_columns
	JOIN db_cat_table ON db_cat_table_id=db_cat_table.id;



DROP VIEW IF EXISTS v_audit_db_columns_diference;
CREATE VIEW v_audit_db_columns_diference AS
SELECT
	v_audit_db_columns.table_name as audit_table,
	v_audit_db_columns.column_name as audit_column,
	v_db_cat_columns.table_name as cat_table,
	v_db_cat_columns.column_name cat_column
	from v_audit_db_columns
	left join v_db_cat_columns on v_db_cat_columns.id=v_audit_db_columns.id
	where v_db_cat_columns.column_name is null
UNION
	select
	v_audit_db_columns.table_name as audit_table,
	v_audit_db_columns.column_name as audit_column,
	v_db_cat_columns.table_name as cat_table,
	v_db_cat_columns.column_name cat_column
	from v_audit_db_columns
	right join v_db_cat_columns on v_db_cat_columns.id=v_audit_db_columns.id
	where v_audit_db_columns.column_name is null;

