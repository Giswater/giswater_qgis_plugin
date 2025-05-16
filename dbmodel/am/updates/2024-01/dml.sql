/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = am, public;

INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'iscorporate', 15, true, NULL, NULL, '{"stretch": true}');

INSERT INTO PARENT_SCHEMA.config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('sys_table_context', '{"level_1":"AM","level_2":"LAYERS"}', NULL, NULL, '{"orderBy":1}'::json) ON CONFLICT (typevalue,id) DO NOTHING;

INSERT INTO PARENT_SCHEMA.sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('arc_output', 'id', 'role_om', NULL, '{"level_1":"AM","level_2":"LAYERS"}', NULL, 'Arc output', NULL, NULL, NULL, 'am', NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('ext_arc_asset', 'id', 'role_om', NULL, '{"level_1":"AM","level_2":"LAYERS"}', NULL, 'Extension arc asset', NULL, NULL, NULL, 'am', NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('leaks', 'id', 'role_om', NULL, '{"level_1":"AM","level_2":"LAYERS"}', NULL, 'Leaks', NULL, NULL, NULL, 'am', NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_asset_arc_corporate', 'id', 'role_om', NULL, '{"level_1":"AM","level_2":"LAYERS"}', NULL, 'Asset arc corporate', NULL, NULL, NULL, 'am', NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_asset_arc_input', 'id', 'role_om', NULL, '{"level_1":"AM","level_2":"LAYERS"}', NULL, 'Asset arc input', NULL, NULL, NULL, 'am', NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_asset_arc_output', 'id', 'role_om', NULL, '{"level_1":"AM","level_2":"LAYERS"}', NULL, 'Asset arc output', NULL, NULL, NULL, 'am', NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table (id, descript, sys_role, project_template, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam) VALUES('v_asset_arc_output_compare', 'id', 'role_om', NULL, '{"level_1":"AM","level_2":"LAYERS"}', NULL, 'Asset arc output compare', NULL, NULL, NULL, 'am', NULL) ON CONFLICT (id) DO NOTHING;
