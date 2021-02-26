/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/22
DELETE FROM sys_function WHERE id = 2896;

UPDATE sys_param_user SET vdefault='{"action_index":[199,18]}' WHERE id='qgis_toolbar_hidebuttons';

UPDATE sys_message SET hint_message = 'It is necessary to remove feature from ve_* or v_edit_* or using end feature tool.' WHERE id = 3160;

UPDATE ext_municipality SET active=TRUE WHERE active IS NULL;