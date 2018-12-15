/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- TABLE: "TABLENAME"

INSERT INTO "SCHEMA_NAME".config_web_fields (table_id, name, is_mandatory, "dataType", field_length, num_decimals, placeholder, label, type, dv_table, dv_id_column, dv_name_column, sql_text, is_enabled, orderby)
SELECT  
tables.table_name, 
column_name, 
(CASE WHEN is_nullable='YES' THEN FALSE ELSE TRUE END),
(CASE WHEN udt_name='varchar' THEN 'string' WHEN udt_name='bool' THEN 'boolean' WHEN udt_name='numeric' THEN 'double'
 WHEN udt_name='int2' THEN 'double' WHEN udt_name='int4' THEN 'double' WHEN udt_name='int8' THEN 'double' WHEN udt_name='date' THEN 'date' END),
numeric_precision,
numeric_scale,
concat('Ex.:',column_name),
column_name,
(CASE WHEN udt_name='varchar' THEN 'text' WHEN udt_name='bool' THEN 'checkbox' WHEN udt_name='numeric' THEN 'text'
 WHEN udt_name='int2' THEN 'text' WHEN udt_name='int4' THEN 'text' WHEN udt_name='int8' THEN 'text' WHEN udt_name='date' THEN 'date' END),
null,null,null,null,true,
ordinal_position 
FROM information_schema.columns, information_schema.tables
	WHERE tables.table_schema='SCHEMA_NAME' 
	AND columns.table_name=tables.table_name and columns.table_schema=tables.table_schema 
	AND tables.table_name in (select distinct table_name FROM information_schema.columns where table_schema='SCHEMA_NAME')
	AND tables.table_name= 'TABLENAME'
	AND udt_name!='geometry'