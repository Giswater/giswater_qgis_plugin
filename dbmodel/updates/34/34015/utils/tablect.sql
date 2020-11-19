/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/06/29
-- RENAME
ALTER TABLE sys_table RENAME CONSTRAINT audit_cat_table_pkey TO sys_table_pkey;

--DROP
ALTER TABLE sys_table DROP CONSTRAINT IF EXISTS audit_cat_table_qgis_role_id_fkey;
ALTER TABLE sys_table DROP CONSTRAINT IF EXISTS audit_cat_table_sys_role_id_fkey;

ALTER TABLE sys_table ADD CONSTRAINT sys_table_qgis_role_id_fkey FOREIGN KEY (qgis_role_id) 
REFERENCES sys_role (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE sys_table ADD CONSTRAINT sys_table_sys_role_id_fkey FOREIGN KEY (sys_role)
REFERENCES sys_role (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;