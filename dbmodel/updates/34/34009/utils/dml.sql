/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-- 13/11/2019
UPDATE sys_foreignkey SET target_table='ext_cat_raster' WHERE target_table='cat_raster';

UPDATE sys_function SET function_type = 'function' WHERE function_type IN ('api function','Function to manage messages');

INSERT INTO sys_function VALUES (2866, 'gw_fct_get_combochilds', 'utils', 'function',null, null, 'Function to manage combos', 'role_basic', FALSE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2868, 'gw_fct_getinsertformdisabled', 'utils', 'function',null, null, 'Function to manage disabled forms', 'role_basic', FALSE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2870, 'gw_fct_setselectors', 'utils', 'function',null, null, 'Function to manage selectors', 'role_basic', FALSE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2872, 'gw_fct_get_filtervaluesvdef', 'utils', 'function',null, null, 'Function to manage vdefault of filters', 'role_basic', FALSE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2874, 'gw_fct_getcolumnsfromid', 'utils', 'function',null, null, 'Function to manage colmuns from id', 'role_basic', FALSE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2876, 'gw_api_getunexpected', 'utils', 'function',null, null, 'Function to manage unspected visits', 'role_om', FALSE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2878, 'gw_fct_getvisitsfromfeature', 'utils', 'function',null, null, 'Function to manage visit from feature', 'role_om', FALSE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2880, 'gw_fct_setdimensioning', 'utils', 'function',null, null, 'Function to manage dimensioning', 'role_edit', FALSE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2882, 'gw_api_setvisitmanager', 'utils', 'function',null, null, 'Function to manage visit manager', 'role_om', FALSE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2884, 'gw_fct_import_omvisitlot', 'utils', 'function',null, null, 'Function to manage lots', 'role_om', FALSE)
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_function WHERE function_name IN('gw_fct_node_replace','gw_fct_getinsertform_vdef','gw_fct_getfiltervaluesvdef','audit_function');

UPDATE config_csv SET functionname = 'gw_fct_utils_csv2pg_import_addfields' WHERE functionname = 'gw_fct_import_addfields';
UPDATE config_csv SET functionname = 'gw_fct_utils_csv2pg_import_dbprices' WHERE functionname = 'gw_fct_import_dbprices';
UPDATE config_csv SET functionname = 'gw_fct_utils_csv2pg_import_elements' WHERE functionname = 'gw_fct_import_elements';
UPDATE config_csv SET functionname = 'gw_fct_utils_csv2pg_import_omvisit' WHERE functionname = 'gw_fct_import_omvisit';
UPDATE config_csv SET functionname = 'gw_fct_utils_csv2pg_import_omvisitlot' WHERE functionname = 'gw_fct_import_omvisitlot';
UPDATE config_csv SET functionname = 'gw_fct_utils_csv2pg_import_timeseries' WHERE functionname = 'gw_fct_import_timeseries';
UPDATE config_csv SET functionname = 'gw_fct_utils_csv2pg_importblock' WHERE functionname = 'gw_fct_importblock';
UPDATE config_csv SET functionname = 'gw_fct_utils_export_ui_xml' WHERE functionname = 'gw_fct_export_ui_xml';
UPDATE config_csv SET functionname = 'gw_fct_utils_import_ui_xml' WHERE functionname = 'gw_fct_import_ui_xml';

UPDATE sys_function SET isdeprecated  = true WHERE id = 2502;

INSERT INTO sys_table (id, context, descript, sys_role_id, sys_criticity, qgis_criticity,  isdeprecated)
    VALUES ('config_visit_class_x_feature', 'visit', 'Table to configure visit class related to feature', 'role_om', 0, 0, false)
    ON CONFLICT (id) DO NOTHING;

UPDATE config_param_system SET value =
'{"table":"exploitation", "selector":"selector_expl", "table_id":"expl_id",  "selector_id":"expl_id",  "label":"expl_id, '' - '', name, '''', CASE WHEN descript IS NULL THEN '''' ELSE concat('' - '', descript) END", 
 "manageAll":true, "selectionMode":"keepPreviousUsingShift", 
 "layerManager":{"active":[], "visible":["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_gully"], "zoom":["v_edit_arc"], "index":["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_gully"]}, 
 "query_filter":"AND expl_id > 0", "typeaheadFilter":{"queryText":"SELECT expl_id as id, name AS idval FROM v_edit_exploitation WHERE expl_id > 0"}}'
 WHERE parameter = 'api_selector_exploitation';
 
  
UPDATE sys_param_user SET dv_querytext = replace (dv_querytext, 'user_name', 'cur_user') where dv_querytext like '%user_name%';

UPDATE sys_function set function_name = 'gw_fct_mincut_inlet_flowtrace' where function_name like 'gw_fct_inlet_flowtrace';

UPDATE sys_function SET return_type = null, input_params = null;

DELETE FROM sys_function where function_name like '%trg_review_audit%';
DELETE FROM sys_function WHERE id IN (1322, 1224, 1326, 1230, 1324, 1226, 1228, 2856, 2442);

-- 15/05/2020
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);

INSERT INTO config_param_system(parameter, value, context, descript, label,isenabled, project_type, isdeprecated)
VALUES ('sys_vpn_permissions', FALSE, 'system', 'Variable to check if vpn connexion with server is used in order to assign correct permissions to the database',
'Sys vpn permissions', FALSE, 'utils', FALSE) ON CONFLICT (parameter) DO NOTHING;

UPDATE om_visit_class SET formname = a.formname, tablename = a.tablename FROM _config_api_visit_ a WHERE om_visit_class.id = a.visitclass_id;


UPDATE sys_foreignkey SET target_table = 'sys_message', target_field = 'message_type' WHERE typevalue_name = 'mtype_typevalue';

ALTER TABLE sys_foreignkey DISABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE sys_foreignkey SET typevalue_table = 'config_typevalue' WHERE typevalue_table ='config_api_typevalue';

INSERT INTO config_typevalue(typevalue, id, idval) VALUES ('widgetfunction_typevalue', 'open_url', 'open_url');

INSERT INTO config_typevalue(typevalue, id, idval) VALUES ('widgetfunction_typevalue', 'info_node', 'info_node');

INSERT INTO config_typevalue(typevalue, id, idval) VALUES ('widgetfunction_typevalue', 'set_print', 'set_print');


UPDATE config_form_fields SET widgetfunction = 'set_composer' WHERE widgetfunction = 'gw_api_setcomposer';
UPDATE config_form_fields SET widgetfunction = 'set_print' WHERE widgetfunction = 'gw_api_setprint';
UPDATE config_form_fields SET widgetfunction = 'open_url' WHERE widgetfunction = 'gw_api_open_url';
UPDATE config_form_fields SET widgetfunction = 'info_node' WHERE widgetfunction = 'gw_api_open_node';
UPDATE config_form_fields SET widgetfunction = NULL WHERE widgetfunction = 'get_catalog_id';

UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, 'config_api_images', 'sys_image');
UPDATE config_form_fields SET dv_querytext = replace (dv_querytext, 'config_api_typevalue', 'config_typevalue');


UPDATE sys_foreignkey SET target_table = 'config_form_fields' WHERE target_table = 'config_api_form_fields';
UPDATE sys_foreignkey SET target_table = 'config_info_layer' WHERE target_table = 'config_api_layer';
UPDATE sys_foreignkey SET target_table = 'config_form_tabs' WHERE target_table = 'config_api_form_tabs';
UPDATE sys_foreignkey SET target_table = 'config_form_fields' WHERE target_table = 'config_api_form_fields';

COMMENT ON TABLE sys_function
  IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
It is possible to create own functions. Ids starting by 9 are reserved to work with';


COMMENT ON TABLE sys_fprocess
  IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
It is possible to create own process. Ids starting by 9 are reserved to work with';

-- 2020/03/19

UPDATE sys_foreignkey SET target_table = 'sys_message', target_field = 'message_type' WHERE typevalue_name = 'mtype_typevalue';

UPDATE sys_foreignkey SET typevalue_table = 'config_typevalue' WHERE typevalue_table ='config_api_typevalue';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3098, 'If widgettype=typeahead and dv_querytext_filterc is not null dv_parent_id must be combo', NULL, 2, TRUE, 'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3100, 'If widgettype=typeahead, id and idval for dv_querytext expression must be the same field', NULL, 2, TRUE, 'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3102, 'If dv_querytext_filterc is not null dv_parent_id is mandatory', NULL, 2, TRUE, 'utils', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3104, 'When dv_querytext_filterc, dv_parent_id must be a valid column for this form. Please check form because there is not column_id with this name', NULL, 2, TRUE, 'utils', false) ON CONFLICT (id) DO NOTHING;

--2020/04/07
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3106, 'There is no presszone defined in the model', NULL, 2, TRUE, 'ws', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3108, 'Feature is out of any presszone, feature_id:', NULL, 2, TRUE, 'ws', false) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, isdeprecated)
VALUES (3110, 'There is no municipality defined in the model', NULL, 2, TRUE, 'utils', false) ON CONFLICT (id) DO NOTHING;

-- 2020/05/18
UPDATE sys_table SET isdeprecated = TRUE WHERE id IN ('value_verified', 'value_review_status', 'value_review_validation');