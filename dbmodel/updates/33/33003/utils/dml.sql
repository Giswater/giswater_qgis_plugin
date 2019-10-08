/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 03/10/2019

INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('composers_path', 'C:/Users/Usuari/AppData/Roaming/QGIS/QGIS3/profiles/default/python/plugins/giswater/templates/qgiscomposer/en', current_user) ON CONFLICT (parameter, cur_user) DO NOTHING;
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('actions_to_hide', '74,75,76,199', current_user) ON CONFLICT (parameter, cur_user) DO NOTHING;
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, isenabled, project_type, datatype, widgettype, ismandatory, isdeprecated) VALUES ('custom_action_sms', '{"show_mincut_sms":false, "show_sms_info":false, "path_sms_script":"C:/Users/user/Desktop/script_test/dist/script/script.exe", "field_code":"code"}', 'json', 'system', 'Manage QPushButton "btn_notify" in mincut_edit.ui and QAction "actionShowNotified"', 'Action SMS:', TRUE, 'utils', 'string', 'linetext', true, false) ON CONFLICT (parameter) DO NOTHING;


INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('v_edit_exploitation', 'GIS feature', 'Shows editable information about exploitation', 'role_edit', 0, 'role_basic', false);

INSERT INTO audit_cat_function(id, function_name, project_type, function_type,descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2756, 'gw_trg_edit_exploitation', 'utils', 'trigger function', 'Edit exploitation data', 'role_edit', false, false, false);
