/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 25/04/2024
ALTER TABLE sys_foreignkey DROP CONSTRAINT IF EXISTS sys_foreingkey_unique;
ALTER TABLE sys_foreignkey DROP CONSTRAINT IF EXISTS sys_foreignkey_typevalue_table_typevalue_name_target_table__key;
ALTER TABLE sys_foreignkey ADD CONSTRAINT sys_foreignkey_unique UNIQUE (typevalue_table, typevalue_name, target_table, target_field);