/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE SCHEMA_NAME.sys_role ADD CONSTRAINT sys_role_check CHECK (id IN ('admin','basic','edit','epa','master','om'));
ALTER TABLE SCHEMA_NAME.config ADD CONSTRAINT config_check CHECK (id IN (1::integer));