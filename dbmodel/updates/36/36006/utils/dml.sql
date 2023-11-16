/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (518, 'Set end feature', 'utils', null, 'core', true, 'Function process', null) 
ON CONFLICT (fid) DO NOTHING;

-- 21/10/2023
INSERT INTO config_typevalue (typevalue, id, addparam) VALUES ('sys_table_context','{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}', '{"orderBy":99}')
ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Category type' WHERE id = 'man_type_category';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Fluid type' WHERE id = 'man_type_fluid';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Location type' WHERE id = 'man_type_location';
UPDATE sys_table SET context = '{"level_1":"INVENTORY","level_2":"VALUE DOMAIN"}' , alias = 'Function type' WHERE id = 'man_type_function';

-- 24/10/23
UPDATE sys_param_user SET ismandatory = True WHERE id = 'plan_psector_vdefault';

-- 27/10/23
UPDATE sys_message SET error_message = 'IT iS IMPOSSIBLE TO UPDATE ARC_ID FROM PSECTOR DIALOG BECAUSE THIS PLANNED LINK HAS NOT ARC AS EXIT-TYPE',
hint_message = 'TO UPDATE IT USE ARC_ID CONNECT(CONNEC or GULLY) DIALOG OR EDIT THE ENDPOINT OF LINK''S GEOMETRY ON CANVAS'
where id = 3212;

UPDATE config_form_fields SET tooltip='arc_id - Identificador del arco. No es necesario introducirlo, es un serial automático' WHERE formname='v_edit_arc' AND formtype='form_feature' AND columnname='arc_id' AND tabname='tab_data';
UPDATE config_form_fields SET tooltip='arc_id - Identificador del arco. No es necesario introducirlo, es un serial automático' WHERE formname='ve_arc_pipe' AND formtype='form_feature' AND columnname='arc_id' AND tabname='tab_data';
UPDATE config_form_fields SET tooltip='arc_id - Identificador del arco. No es necesario introducirlo, es un serial automático' WHERE formname='ve_arc_varc' AND formtype='form_feature' AND columnname='arc_id' AND tabname='tab_data';
UPDATE config_form_fields SET tooltip='arc_id - Identificador del arco. No es necesario introducirlo, es un serial automático' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='arc_id' AND tabname='tab_data';

-- 29/10/2023
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3282, 'gw_fct_getfeatureboundary', 'utils', 'function', 'json', 'json', 'Function to return boundary feature in function of different input parameters', 'role_edit', null, 'core') ON CONFLICT (id) DO NOTHING;

-- 31/10/2023
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3284, 'gw_fct_psector_merge', 'utils', 'function', 'json', 'json', 'Function to merge two or more psectors into one', 'role_master', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES (520, 'Psector merge', 'utils', NULL, 'core', true, 'Function process', NULL)
ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) 
VALUES(3284, 'Merge two or more psectors into one', '{"featureType":[]}'::json, '[{"widgetname":"psector_ids", "label":"Psector ids: (*)", "widgettype":"text", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":0, "isMandatory":true}, {"widgetname":"new_psector_name", "label":"New psector name: (*)", "widgettype":"text", "datatype":"text", "layoutname":"grl_option_parameters","layoutorder":1, "isMandatory":true}]'::json, NULL, true, '{4}');

-- 31/10/2023
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3286, 'gw_trg_refresh_state_expl_matviews', 'utils', 'Trigger function', null, null, 'Trigger function to refresh matviews in order to enhance performe', 'role_basic', null, 'core') ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_table WHERE id = 'arc_border_expl';

UPDATE config_form_tabs SET orderby=4 WHERE tabname='tab_event' AND orderby IS NULL;

-- 7/11/2023
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3288, 'gw_fct_setrepairpsector', 'utils', 'function', null, null, 'Function to fix possible errors on psector', 'role_master', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (521, 'Set repair psector', 'utils', null, 'core', true, 'Function process', null) 
ON CONFLICT (fid) DO NOTHING;

UPDATE config_csv SET alias = 'Import scada values', descript = 'Import scada values into table ext_rtc_scada_x_data according example file scada_values.csv', 
functionname = 'gw_fct_import_scada_values' WHERE fid = 469;

UPDATE config_csv SET descript='The csv file must have the following fields:
hydrometer_id, cat_period_id, sum, value_date (optional), value_type (optional), value_status (optional), value_state (optional)' WHERE fid=470 AND alias='Import hydrometer_x_data';

UPDATE config_csv SET descript='The csv file must have the following fields:
id, start_date, end_date, period_seconds (optional), code', active = true WHERE fid=471 AND alias='Import crm period values';

--11/11/2023
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(522, 'Check outfalls with more than 1 arc', 'utils', NULL, 'core', true, 'Function process', NULL);

INSERT INTO sys_message (id, error_message, log_level, show_user, project_type, "source")
VALUES(3250, 'Value 0 for exploitation it is not enabled on network objects. It is only used to relate undefined mapzones', 2, true, 'utils', 'core');
