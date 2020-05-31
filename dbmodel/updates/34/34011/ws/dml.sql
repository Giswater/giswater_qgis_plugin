/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
UPDATE config_form_fields set columnname = 'presszone_id' WHERE columnname ='presszonecat_id';
UPDATE config_form_fields set formname = 'presszone' WHERE formname ='cat_presszone';
UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, 'cat_presszone', 'presszone') WHERE columnname like '%press%';
UPDATE config_form_fields SET dv_querytext_filterc = replace (dv_querytext_filterc, 'cat_presszone', 'presszone') WHERE columnname like '%press%';

INSERT INTO sys_function VALUES (2924, 'gw_trg_edit_dqa', 'ws', 'trigger function',null, null, 'Function to manage dqa editable', 'role_edit', FALSE);
INSERT INTO sys_function VALUES (2926, 'gw_trg_edit_presszone', 'ws', 'trigger function',null, null, 'Function to manage presszone editable', 'role_edit', FALSE);

UPDATE sys_table SET id='presszone' ,notify_action = replace (notify_action::text, '"trg_fields":"id"', '"trg_fields":"presszone_id"')::json WHERE id='cat_presszone';
