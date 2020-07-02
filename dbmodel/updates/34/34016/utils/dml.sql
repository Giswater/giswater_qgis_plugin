/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/02
UPDATE  config_form_fields set dv_querytext = 'SELECT id as id,idval FROM plan_typevalue WHERE typevalue=''value_priority'''
where columnname='priority' and formname='v_edit_plan_psector';