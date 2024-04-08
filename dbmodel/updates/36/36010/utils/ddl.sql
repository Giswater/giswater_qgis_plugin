/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 26/03/2024
ALTER TABLE sys_foreignkey DROP CONSTRAINT sys_foreingkey_unique;
--ALTER TABLE sys_foreignkey DROP COLUMN parameter_id;
ALTER TABLE sys_foreignkey ADD CONSTRAINT sys_foreignkey_unique UNIQUE (typevalue_table, typevalue_name, target_table, target_field);

ALTER TABLE man_addfields_value RENAME TO _man_addfields_value_;
