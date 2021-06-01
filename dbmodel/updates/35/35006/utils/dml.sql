/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/01
ALTER TABLE sys_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM sys_typevalue WHERE typevalue_name='value_verified';
ALTER TABLE sys_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
