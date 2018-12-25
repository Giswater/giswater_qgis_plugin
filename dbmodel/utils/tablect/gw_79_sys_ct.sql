/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP CHECK

ALTER TABLE "sys_role" DROP CONSTRAINT IF EXISTS "sys_role_check";
ALTER TABLE "config" DROP CONSTRAINT IF EXISTS "config_check";


-- ADD CHECK


ALTER TABLE "sys_role" ADD CONSTRAINT sys_role_check CHECK (id IN ('role_admin','role_basic','role_edit','role_epa','role_master','role_om'));
ALTER TABLE "config" ADD CONSTRAINT config_check CHECK (id::integer IN (1::integer));

