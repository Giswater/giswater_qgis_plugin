/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/11
DROP TRIGGER IF EXISTS gw_trg_sysaddfields ON sys_addfields;
CREATE TRIGGER gw_trg_sysaddfields BEFORE UPDATE OF active ON sys_addfields
FOR EACH ROW EXECUTE PROCEDURE gw_trg_sysaddfields();
