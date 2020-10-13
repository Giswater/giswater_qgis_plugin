/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/14
UPDATE config_param_system SET project_type = 'ws' WHERE parameter = 'om_mincut_enable_alerts';

--2020/08/04
INSERT INTO sys_function (id, function_name, project_type, function_type) 
VALUES (2994, 'gw_fct_vnode_repair', 'utils', 'function')ON CONFLICT (id) DO NOTHING;


INSERT INTO config_toolbox VALUES (2496, 'Arc repair', TRUE, '{"featureType":["arc"]}', NULL, NULL, TRUE);

INSERT INTO sys_function (id, function_name, project_type, function_type) 
VALUES (2996, 'gw_trg_edit_element_pol', 'utils', 'function')ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox VALUES (2522, 'Import epanet inp file', TRUE, '{"featureType":[]}', '[{"widgetname":"useNode2arc", "label":"Create node2arc:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"false"}]', null, TRUE);
INSERT INTO config_toolbox VALUES (2524, 'Import swmm inp file', TRUE, '{"featureType":[]}', '[{"widgetname":"createSubcGeom", "label":"Create subcatchments geometry:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"true"}]', null, TRUE);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle) VALUES ('datatype_typevalue', 'text', 'text', 'text')
ON CONFLICT (typevalue, id) DO NOTHING;

--update user's vdefault
UPDATE sys_param_user SET id = concat('edit_', sys_param_user.id) 
FROM sys_addfields WHERE sys_param_user.id = concat(param_name,'_','_vdefault');


--update addfields vdefault
UPDATE config_param_user SET parameter = concat('edit_', parameter) FROM sys_param_user WHERE sys_param_user.id = concat('edit_',parameter);


UPDATE config_param_user SET parameter = concat('edit_addfield_',config_param_user.parameter ) 
FROM sys_addfields WHERE config_param_user.parameter = concat(param_name,'_',lower(cat_feature_id),'_vdefault');

-- update feature_vdefault
DELETE FROM sys_param_user WHERE id IN (SELECT concat(lower(id),'_vdefault') FROM cat_feature);

DELETE FROM config_param_user WHERE parameter IN (SELECT concat(lower(id),'_vdefault') FROM cat_feature);

DELETE FROM config_param_user WHERE parameter NOT IN (SELECT id FROM sys_param_user) ;

-- 2020/15/09
UPDATE sys_param_user SET id ='basic_search_exploitation_vdefault' WHERE id = 'basic_search_exploitation_vdefaut';
UPDATE sys_param_user SET id ='basic_search_municipality_vdefault' WHERE id = 'basic_search_municipality_vdefaut';

/*
2020/09/08
DELETE ALL REFERENCES TO LOT PLUGIN
*/
DELETE FROM sys_table WHERE id='v_ui_om_vehicle_x_parameters';
DELETE FROM sys_table WHERE id='v_visit_lot_user';
DELETE FROM sys_table WHERE id='v_om_user_x_team';
DELETE FROM sys_table WHERE id='v_om_team_x_visitclass';
DELETE FROM sys_table WHERE id='v_edit_cat_team';
DELETE FROM sys_table WHERE id='v_ext_cat_vehicle';
DELETE FROM sys_table WHERE id='v_om_lot_x_user';
DELETE FROM sys_table WHERE id='v_ui_om_visit_lot';
DELETE FROM sys_table WHERE id='v_res_lot_x_user';
DELETE FROM sys_table WHERE id='ve_lot_x_node';
DELETE FROM sys_table WHERE id='ve_lot_x_connec';
DELETE FROM sys_table WHERE id='ve_lot_x_arc';
DELETE FROM sys_table WHERE id='ve_lot_x_gully';
DELETE FROM sys_table WHERE id='om_team_x_visitclass';
DELETE FROM sys_table WHERE id='om_vehicle_x_parameters';
DELETE FROM sys_table WHERE id='om_team_x_vehicle';
DELETE FROM sys_table WHERE id='ext_cat_vehicle';
DELETE FROM sys_table WHERE id='om_visit_team_x_user';
DELETE FROM sys_table WHERE id='om_visit_lot_x_user';
DELETE FROM sys_table WHERE id='config_visit_class_x_workorder';
DELETE FROM sys_table WHERE id='ext_workorder';
DELETE FROM sys_table WHERE id='ext_workorder_class';
DELETE FROM sys_table WHERE id='om_visit_class_x_wo';
DELETE FROM sys_table WHERE id='ext_workorder_type';
DELETE FROM sys_table WHERE id='om_visit_lot_x_node';
DELETE FROM sys_table WHERE id='om_visit_lot_x_connec';
DELETE FROM sys_table WHERE id='om_visit_lot_x_arc';
DELETE FROM sys_table WHERE id='om_visit_lot_x_gully';
DELETE FROM sys_table WHERE id='selector_lot';
DELETE FROM sys_table WHERE id='om_visit_lot';
DELETE FROM sys_table WHERE id='cat_team';

DELETE FROM sys_function WHERE function_name='gw_fct_getlot';
DELETE FROM sys_function WHERE function_name='gw_fct_setlot';
DELETE FROM sys_function WHERE function_name='gw_fct_getvisitmanager';
DELETE FROM sys_function WHERE function_name='gw_fct_setvisitmanager';
DELETE FROM sys_function WHERE function_name='gw_trg_edit_cat_team';
DELETE FROM sys_function WHERE function_name='gw_trg_edit_cat_vehicle';
DELETE FROM sys_function WHERE function_name='gw_trg_edit_lot_x_user';
DELETE FROM sys_function WHERE function_name='gw_trg_edit_team_x_user';
DELETE FROM sys_function WHERE function_name='gw_trg_edit_team_x_vehicle';
DELETE FROM sys_function WHERE function_name='gw_trg_edit_team_x_visitclass';
DELETE FROM sys_function WHERE function_name='gw_fct_setvehicleload';

UPDATE sys_table SET sys_role = 'role_basic' WHERE id = 'audit_check_data';
UPDATE sys_table SET sys_role = 'role_basic' WHERE id = 'selector_inp_hydrology';