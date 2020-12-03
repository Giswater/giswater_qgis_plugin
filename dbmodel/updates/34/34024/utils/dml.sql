/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/10/22
UPDATE sys_param_user SET label = 'QGIS composers path' WHERE id = 'qgis_composers_folderpath';
UPDATE sys_param_user SET label = 'QGIS hide buttons on toolbox' WHERE id = 'qgis_toolbar_hidebuttons';
UPDATE sys_param_user SET label = 'Name of polygon virtual layer' WHERE id = 'virtual_polygon_vdefault';
UPDATE sys_param_user SET label = 'Name of point virtual layer' WHERE id = 'virtual_point_vdefault';
UPDATE sys_param_user SET label = 'Name of line virtual layer' WHERE id = 'virtual_line_vdefault';


INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'text3', layoutorder, datatype, widgettype, 'text3', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_plan_psector' and columnname = 'text2';

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'text4', layoutorder, datatype, widgettype, 'text4', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_plan_psector' and columnname = 'text2';

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'text5', layoutorder, datatype, widgettype, 'text5', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_plan_psector' and columnname = 'text2';

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'text6', layoutorder, datatype, widgettype, 'text6', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_plan_psector' and columnname = 'text2';

DELETE FROM config_csv WHERE fid IN (246, 247, 245, 237, 244);

DELETE FROM config_param_system WHERE parameter = 'utils_import_visit_parameters';

DELETE FROM sys_function WHERE id IN (2884, 2512, 2738);

--2738
DROP FUNCTION IF EXISTS gw_fct_utils_csv2pg_import_timeseries();
DROP FUNCTION IF EXISTS gw_fct_import_timeseries(json);

--2512
DROP FUNCTION IF EXISTS gw_fct_import_omvisit(json);

--2884
DROP FUNCTION IF EXISTS gw_fct_utils_csv2pg_import_omvisitlot(json);
DROP FUNCTION IF EXISTS gw_fct_import_omvisitlot(json);

-- 2020/10/26
DELETE FROM config_param_system WHERE parameter = 'edit_arc_insert_automatic_endpoint';

INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, isdeprecated, vdefault)
VALUES ('edit_arc_insert_automatic_endpoint', 'config', 'If value, enables to digitize new arcs without node_2. Node2 it is automatic triggered using default nodecat value from user and common values from arc',
'role_edit', 'Automatic node insert as arc endpoint', TRUE, 7, 'utils', FALSE, FALSE, 'boolean', 'check', TRUE, 'lyt_other',
TRUE, FALSE, 'false') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3160, 'This feature with state = 2 is only attached to one psector' , 'It''s necessary to remove feature completaly using end feature tool', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3162, 'This feature is a final node for planned arc ' , 'It''s necessary to remove arcs first, then nodes', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING;

-- 2020/10/28
DELETE FROM sys_param_user where id = 'inp_options_skipdemandpattern';
UPDATE sys_param_user SET vdefault = lower(vdefault) WHERE id = 'qgis_form_initproject_hidden';

--2020/10/21
INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (302, 'Check values of system variables', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (303, 'Check cat_feature field active', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (304, 'Check cat_feature field code_autofill', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (305, 'Check cat_feature_node field num_arcs', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (306, 'Check cat_feature_node field isarcdivide', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (307, 'Check cat_feature_node field graf_delimiter', 'ws') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (308, 'Check cat_feature_node field isexitupperintro', 'ud') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (309, 'Check cat_feature_node field choose_hemisphere', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (310, 'Check cat_feature_node field isprofilesurface', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (311, 'Check child view man table definition', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (312, 'Check child view addfields', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (313, 'Find not existing child views', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (314, 'Find active features without child views', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (315, 'Check definition on config_info_layer_x_type', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (316, 'Check definition on config_form_fields', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (317, 'Find ve_* views not defined in cat_feature', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (318, 'Check config_form_fields field datatype', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (319, 'Check config_form_fields field widgettype', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (320, 'Check config_form_fields field dv_querytext', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (321, 'Check config_form_fields for addfields definition', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (322, 'Check config_form_fields layoutorder duplicated', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (323, 'Check cat_arc field active', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (324, 'Check cat_arc field cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (325, 'Check cat_arc field m2bottom_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (326, 'Check cat_arc field m3protec_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (327, 'Check cat_node field active', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (328, 'Check cat_node field cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (329, 'Check cat_node field cost_column', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (330, 'Check cat_node field estimated_depth', 'ws') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (331, 'Check cat_node field estimated_y', 'ud') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (332, 'Check cat_connec field active', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (333, 'Check cat_connec field cost_ut', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (334, 'Check cat_connec field cost_ml', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (335, 'Check cat_connec field cost_m3', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (336, 'Check cat_pavement field thickness', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (337, 'Check cat_pavement field m2cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (338, 'Check cat_soil field y_param', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (339, 'Check cat_soil field b', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (340, 'Check cat_soil field m3exc_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (341, 'Check cat_soil field m3fill_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (342, 'Check cat_soil field m3excess_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (343, 'Check cat_soil field m2trenchl_cost', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (344, 'Check cat_grate field active', 'ud') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (345, 'Check cat_grate field cost_ut', 'ud') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (346, 'Check plan_arc_x_pavement rows number', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (347, 'Check plan_arc_x_pavement field pavcat_id', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (348, 'Check final nodes of arc state=2 in psector', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (349, 'Check compatibility of DB and plugin version', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (350, 'Check host of QGIS layers', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (351, 'Check DB name of QGIS layers', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (352, 'Check schema name of QGIS layers', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (353, 'Check user name of QGIS layers', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (354, 'Check arc state=2 with final nodes in psector', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (355, 'Check arc state=2 with operative nodes in psector', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (356, 'Planned connecs without reference link', 'utils') ON CONFLICT (fid) DO NOTHING ;

--2020/11/03
UPDATE config_form_tabs
SET tabactions=tabactions::jsonb || '{"actionName":"actionRotation", "actionTooltip":"Rotation",  "disabled":false}'::jsonb
WHERE formname ='v_edit_node';


INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3164, 'Arc have incorrectly defined final nodes in this plan alternative', 'Make sure that arcs finales are on service', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING ;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES (3002, 'gw_fct_setplan', 'utils', 'function','json', 'json', 
'Function that returns qgis layer configuration for masterplan', 'role_master', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_typevalue VALUES ('tabname_typevalue', 'tab_event', 'tab_event', 'tabEvent') ON CONFLICT (typevalue, id) DO NOTHING;
UPDATE config_form_tabs SET tabname='tab_event' WHERE tabname='tab_om';
DELETE FROM config_typevalue WHERE typevalue='tabname_typevalue' AND id='tab_om';

--2020/11/05
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (3004, 'gw_fct_mincut_output', 'ws', 'function', 'integer', 'integer', 'Details of mincut', 'role_om') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES (3006, 'gw_fct_settoarc', 'ws', 'function','json', 'json', 
'Function that sets flow direction in inp and mapzone tables', 'role_edit', NULL) ON CONFLICT (id) DO NOTHING;

--2020/11/09
UPDATE config_form_fields SET widgettype='combo', iseditable=TRUE WHERE columnname='macrodma_id' AND formname='v_edit_dma';
UPDATE config_form_fields SET iseditable=TRUE WHERE columnname='macrosector_id' AND formname='v_edit_sector';

INSERT INTO config_param_system (parameter, value, descript, label, isenabled, layoutorder, project_type, datatype, widgettype, ismandatory, iseditable, layoutname) VALUES
('edit_element_doublegeom', '{"activated":true,"value":1}', 'Enable/disable inserting double geometry elements', 'Element double geometry enabled:', true, 17,  'utils', 'string', 'linetext', TRUE, TRUE, 'lyt_topology')
ON CONFLICT (parameter) DO NOTHING;

UPDATE config_param_system s SET value=concat('{"activated":true,"value":',u.value,'}') FROM config_param_user u WHERE s.parameter='edit_element_doublegeom'
AND u.parameter='edit_element_doublegeom';

DELETE FROM config_param_user WHERE parameter='edit_element_doublegeom';

DELETE FROM sys_param_user WHERE id='edit_element_doublegeom';

UPDATE sys_param_user SET formname ='hidden' WHERE formname = 'hidden_value';

-- 2020/11/14
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES (3008, 'gw_fct_setarcreverse', 'utils', 'function','json', 'json', 
'Function that reverse arc', 'role_edit', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user(id, formname, 
descript, 
sys_role, project_type, isdeprecated)
VALUES ('edit_arc_keepdepthval_when_reverse_geom', 'hidden', 
'If value, when arc is reversed only id values from node_1 and node_2 will be exchanged, keeping depth values on same node (y1, y2, custom_y1, custom_y2, elev_1, elev_2, custom_elev_1, custom_elev_2, sys_elev_1, sys_elev_2) will remain on same node', 
'role_edit', 'ud', 'false') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (357, 'Arc reverse', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (358, 'Reset user profile', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO config_toolbox
VALUES (2922, 'Reset user profile', TRUE, '{"featureType":[]}', 
'[{"widgetname":"user", "label":"User name:","widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":"", "tooltip": "User name"},
  {"widgetname":"fromUser", "label":"Copy from user (same role):","widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":"", "tooltip": "Optative user name to copy all values from it"}]',
null, TRUE)
ON CONFLICT (id) DO NOTHING;

UPDATE config_toolbox SET alias = 'Check backend configuration' WHERE alias = 'Check API configuration';
UPDATE config_toolbox SET alias = 'Import dxf file' WHERE alias = 'Manage dxf files';

UPDATE sys_function SET descript ='Function to reset user values. 
Two options are enabled: 1-reset from default values; 2-reset from values of another user' WHERE id = 2922;

UPDATE config_toolbox SET alias = 'Linear Reference System' WHERE alias = 'LRS';

-- 2020/11/16
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES (3010, 'gw_fct_getmincut', 'ws', 'function','json', 'json', 
'Function that gets mincut information', 'role_om', NULL) ON CONFLICT (function_name, project_type) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)

VALUES (359, 'Set configuration of field to_arc', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query)
VALUES (3012, 'gw_fct_mincut_connec', 'ws', 'function','json', 'json', 
'Function that sets mincut connec & hydrometer class', 'role_om', NULL) ON CONFLICT (function_name, project_type) DO NOTHING;