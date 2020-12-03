/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO audit_cat_error(id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3038, 'Inserted value has unaccepted characters:', 'Don''t use accents, dots or dashes in the id and child view name', 2, true, 'utils', false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type,descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2758, 'gw_trg_update_child_view', 'utils', 'trigger function', 'Recreate child views after view name or id change','role_admin',false, false,false);
