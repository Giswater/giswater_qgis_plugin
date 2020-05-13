/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/05/05
UPDATE audit_cat_table SET sys_role_id = 'role_basic'  WHERE id = 'audit_check_data';

--2020/05/09
UPDATE ws.audit_cat_table SET sys_role_id = 'role_master' WHERE id = 'config_form_fields';

