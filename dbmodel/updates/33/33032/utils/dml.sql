/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/07
ALTER TABLE edit_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;

DELETE FROM sys_typevalue_cat WHERE typevalue_name='man_addfields_cat_widgettype';
DELETE FROM typevalue_fk WHERE target_table = 'man_addfields_parameter' AND target_field='widgettype_id';
DELETE FROM edit_typevalue WHERE typevalue = 'man_addfields_cat_widgettype';

