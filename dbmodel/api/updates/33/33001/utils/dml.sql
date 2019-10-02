/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 01/10/2019
UPDATE audit_cat_param_user SET label = 'Keep opened edition on update feature:' WHERE id = 'cf_keep_opened_edition';

INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('composers_path', 'C:/Users/Usuari/AppData/Roaming/QGIS/QGIS3/profiles/default/python/plugins/giswater/templates/qgiscomposer/en', current_user) ON CONFLICT (parameter) DO NOTHING;
INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('actions_to_hide', '74,75,76,199', current_user) ON CONFLICT (parameter) DO NOTHING;
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, isenabled, project_type, datatype, widgettype, isdeprecated) VALUES ('custom_action_sms', '{"show_mincut_sms":false, "show_sms_info":false, "path_sms_script":"C:/Users/user/Desktop/script_test/dist/script/script.exe", "field_code":"code"}', 'json', 'system', 'Manage QPushButton "btn_notify" in mincut_edit.ui and QAction "actionShowNotified"', 'Action SMS:', TRUE, 'utils', 'string', 'linetext', false) ON CONFLICT (parameter) DO NOTHING;