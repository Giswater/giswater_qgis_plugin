/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type, datatype) VALUES
('plugin_lotmanage', '{"lotManage":"TRUE"}', 'External plugin to use functionality of planified lot visits', FALSE, 'utils', 'json') ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type, datatype) VALUES
('admin_publish_user', 'qgisserver','Publish user', FALSE, 'utils', 'text') ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type, datatype) VALUES
('om_lotmanage_units', '{"arcBuffer": "5", "linkBuffer": "2", "nodeBuffer": "2", "unitBuffer": "0", "areaFactor": "2", "azimuthFactor": "1", "elevFactor": "0", "maxLinkLength":7}',
'Specific configuration for plugin om_lotmanage, relate to buffer of the units and the weight for choose the best candidate on the intersections with isprofilesurface false', 
FALSE, 'ud', 'json') ON CONFLICT (parameter) DO NOTHING;

INSERT INTO sys_table VALUES ('cat_team', 'Catalog of teams', 'role_om', 0, NULL, NULL, NULL, 'cat_team_id_seq', 'id', NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_visit_lot', 'Table with all lots that took place', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('selector_lot', 'Selector of lots', 'role_basic', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_visit_lot_x_arc', 'Table of arcs related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_visit_lot_x_connec', 'Table of connecs related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_visit_lot_x_node', 'Table of nodes related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('config_visit_class_x_workorder', 'Table of visit classes related to its workorders', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ext_workorder_type', 'Table of workorders related to its types', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_visit_class_x_wo', 'Table that relates workorders with visitclass', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ext_workorder_class', 'Table of workorders related to its classes', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ext_workorder', 'External table of workorders', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_visit_lot_x_user', 'Table that saves information about works made by a user in relation to one lot', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ext_cat_vehicle', 'External catalog of vehicles', 'role_om', 0, NULL, NULL, NULL, 'ext_cat_vehicle_id_seq', 'id', NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_team_x_vehicle', 'Relation between teams and their vehicles', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_vehicle_x_parameters', 'Relation between vehicles and their parameters', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_team_x_visitclass', 'Relation between teams and visitclass', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_team_x_user', 'Relation between teams and their users', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_visit_lot_user', 'Lot user view', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table VALUES ('v_ui_om_visit_lot', 'User interface view for lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_res_lot_x_user', 'View with the results of a work realised by a user in relation with one lot', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ve_lot_x_node', 'View that relates nodes and lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ve_lot_x_arc', 'View that relates arcs and lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ve_lot_x_connec', 'View that relates connecs and lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_ui_om_vehicle_x_parameters', 'User interface view of the realtion between vehicles and their parameters', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_om_team_x_user', 'View with the realtion between users and teams', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_om_team_x_visitclass', 'View with the relation between teams and visitclass', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_edit_cat_team', 'Editable view for cat_team', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_ext_cat_vehicle', 'Editable view for ext_cat_vehicle', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_om_lot_x_user', 'View with the information aobut works made by a user in relation to one lot', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ve_lot_x_arc_web', 'View to publish arcs related to lots on web', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ve_lot_x_node_web', 'View to publish nodes related to lots on web', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ve_lot_x_connec_web', 'View to publish connecs related to lots on web', 'role_om', 0) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_table VALUES ('om_visit_lot_x_unit', 'Table of UM', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_visit_lot_x_macrounit', 'Table of Macrounits related to lots', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('temp_lot_unit', 'Temporal table used by lot units algorithm', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_category', 'Category catalog related to OM', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_macrocategory', 'Macrocategory catalog related to OM', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_category_x_arc', 'Relation between arcs and their om_category', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_category_x_node', 'Relation between node and their om_category', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_category_x_connec', 'Relation between connecs and their om_category', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_category_x_gully', 'Relation between gullys and their om_category', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_edit_om_visit_lot_x_unit', 'View to manage and edit units related to lots', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('v_edit_om_visit_lot_x_macrounit', 'View to manage and edit macrounits related to lots', 'role_om', 0) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function VALUES (2898, 'gw_fct_getlot', 'lot_manage', 'function', 'json', 'json', 'Function to provide lot form', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2862, 'gw_fct_setlot', 'lot_manage', 'function', 'json', 'json', 'Set lot', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2640, 'gw_fct_getvisitmanager', 'lot_manage', 'function', 'json', 'json', 'To call visit from user', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2882, 'gw_fct_setvisitmanager', 'lot_manage', 'function', 'json', 'json', 'Function to manage visit manager', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2912, 'gw_fct_setvehicleload', 'lot_manage', 'function', 'json', 'json', 'Function to set loads of vehicles (vehicle management)', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2997, 'gw_fct_lot_psector_geom', 'lot_manage', 'function', 'json', 'json', 'Function to set the_geom of the psector after its insert', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2838, 'gw_trg_edit_cat_team', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_edit_cat_team', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2840, 'gw_trg_edit_cat_vehicle', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_ext_cat_vehicle', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2842, 'gw_trg_edit_lot_x_user', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_lot_x_user', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2834, 'gw_trg_edit_team_x_user', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_team_x_user', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2844, 'gw_trg_edit_team_x_vehicle', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_team_x_vehicle', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2836, 'gw_trg_edit_team_x_visitclass', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_team_x_visitclass', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function VALUES (3135, 'gw_fct_lot_unit', 'utils', 'function', 'json', 'json', 'Generate units', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3137, 'gw_fct_lot_unit_recursive', 'utils', 'function', 'json', 'json', 'Analytics recursive to manage lot units', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3139, 'gw_fct_setunitinterval', 'utils', 'function', 'json', 'json', 'Set intervals for units', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3141, 'gw_trg_lot_x_unit', 'utils', 'trigger function', NULL, NULL, 'Makes editable om_visit_lot_x_unit', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3143, 'gw_trg_lot_x_macrounit', 'utils', 'trigger function', NULL, NULL, 'Makes editable om_visit_lot_x_macrounit', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3145, 'gw_fct_lot_unit_order', 'utils', 'function', 'json', 'json', 'Order units', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3147, 'gw_fct_lot_unit_order_recursive', 'utils', 'function', 'json', 'json', 'Recursive function used to order units', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3149, 'gw_fct_lot_unit_update_geom', 'utils', 'function', 'json', 'json', 'Function to update geom of units', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3151, 'gw_fct_lot_unit_orderbydist_recursive', 'utils', 'function', 'integer', 'json', 'Function to order UM by distance when generating them', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3153, 'gw_fct_om_category_geom', 'utils', 'function', 'integer', NULL, 'Function to calculate geom of om_category', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3155, 'gw_trg_dma2category', 'utils', 'trigger function', NULL, NULL, 'Copy values of dma_id to om_category', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3157, 'gw_trg_om_visit_lot', 'utils', 'trigger function', NULL, NULL, 'Manage status of visits when lot is validated', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (3159, 'gw_fct_periodic_lot', 'utils', 'function', NULL, 'json', 'Reset lot if it has periodicity', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO om_typevalue VALUES ('lot_cat_status', 1, 'PLANIFYING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('lot_cat_status', 2, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('lot_cat_status', 3, 'ASSIGNED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('lot_cat_status', 4, 'ON GOING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('lot_cat_status', 5, 'EXECUTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('lot_cat_status', 6, 'REVISED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('lot_cat_status', 7, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO om_typevalue VALUES ('lot_x_feature_status', 1, 'Not visited', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('lot_x_feature_status', 0, 'Visited', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO om_typevalue VALUES ('visit_status', 5, 'Validated', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_typevalue VALUES ('tabname_typevalue', 'tab_team', 'tab_team', 'tabTeam');
INSERT INTO config_typevalue VALUES ('widgetfunction_typevalue', 'set_vehicle_load', 'set_vehicle_load', 'gwSetVehicleLoad')
ON CONFLICT (typevalue, id) DO UPDATE SET camelstyle=EXCLUDED.camelstyle;
INSERT INTO config_typevalue VALUES ('widgetfunction_typevalue', 'get_visit_manager', 'get_visit_manager', 'gwGetVisitManager') 
ON CONFLICT (typevalue, id) DO UPDATE SET camelstyle=EXCLUDED.camelstyle;
INSERT INTO config_typevalue VALUES ('widgetfunction_typevalue', 'set_visit_manager', 'set_visit_manager', 'gwSetVisitManager') 
ON CONFLICT (typevalue, id) DO UPDATE SET camelstyle=EXCLUDED.camelstyle;
INSERT INTO config_typevalue VALUES ('widgetfunction_typevalue', 'get_lot', 'get_lot', 'gwGetLot') 
ON CONFLICT (typevalue, id) DO UPDATE SET camelstyle=EXCLUDED.camelstyle;
INSERT INTO config_typevalue VALUES ('widgetfunction_typevalue', 'set_lot', 'set_lot', 'gwSetLot')
ON CONFLICT (typevalue, id) DO UPDATE SET camelstyle=EXCLUDED.camelstyle;


UPDATE config_visit_class_x_workorder SET active = TRUE;

/*CONFIG_FORM_TABS*/
DELETE FROM config_form_tabs WHERE formname='visitManager';
INSERT INTO config_form_tabs VALUES ('visit_manager', 'tab_data', 'General data', 'Data', 'role_om', '{"name":"gwGetVisitManager", "parameters":{"form":{"tabData":{"active":true}, "tabLots":{"active":false}}}}', '{}', 3) ON CONFLICT (formname, tabname, device) DO NOTHING;
INSERT INTO config_form_tabs VALUES ('visit_manager', 'tab_done', 'Executed visits', 'Executed visits', 'role_om', '{"name":"gwGetVisitManager", "parameters":{"form":{"tabData":{"active":false}, "tabLots":{"active":false},"tabDone":{"active":true}}}}', '[{"actionName":"actionDelete", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "actionTable":{"tableName":"om_visit","idName":"id"}, "disabled":false},{"actionName":"changeAction", "actionFunction":"gwGetVisit", "disabled":false}]', 3)ON CONFLICT (formname, tabname, device) DO NOTHING;
INSERT INTO config_form_tabs VALUES ('visit_manager', 'tab_lot', 'Lots', 'Lots', 'role_om', '{"name":"gwGetVisitManager", "parameters":{"form":{"tabData":{"active":false}, "tabLots":{"active":true}}}}', '[{"actionName":"actionDelete", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "actionTable":{"tableName":"om_visit_lot","idName":"id"}, "disabled":false},{"actionName":"changeAction", "actionFunction":"gwGetLot", "disabled":false}]', 3)ON CONFLICT (formname, tabname, device) DO NOTHING;
INSERT INTO config_form_tabs VALUES ('visit_manager', 'tab_team', 'Vehicle load', 'Vehicle load', 'role_om', '{"name":"gwGetVisitManager", "parameters":{"form":{"tabData":{"active":false}, "tabLots":{"active":false},"tabDone":{"active":false},"tabTeam":{"active":true}}}}', '[{"actionName":"actionAddFile", "actionFunction":"gwSetFileInsert", "actionTooltip":"Add Photo", "disabled":false}]', 3)ON CONFLICT (formname, tabname, device) DO NOTHING;
INSERT INTO config_form_tabs VALUES ('lot', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetLot", "parameters":{"form":{"tabData":{"active":true}}}}', '{}', 3) ON CONFLICT (formname, tabname, device) DO NOTHING;
INSERT INTO config_form_tabs VALUES ('v_edit_arc', 'tab_visit', 'Visit', 'List of visits', 'role_basic', NULL, NULL, 4) ON CONFLICT (formname, tabname, device) DO NOTHING;
INSERT INTO config_form_tabs VALUES ('v_edit_node', 'tab_visit', 'Visit', 'List of visits', 'role_basic', NULL, NULL, 4) ON CONFLICT (formname, tabname, device) DO NOTHING;
INSERT INTO config_form_tabs VALUES ('v_edit_connec', 'tab_visit', 'Visit', 'List of visits', 'role_basic', NULL, NULL, 4) ON CONFLICT (formname, tabname, device) DO NOTHING;


/*CONFIG_FORM_LIST*/
INSERT INTO config_form_list VALUES ('om_visit_lot', 'SELECT a.id AS sys_id, ''om_visit_lot'' as sys_table_id, ''id'' as sys_idname, a.id AS lot_id, c.idval AS visitclass_id, t.idval AS status FROM om_visit_lot a 
JOIN config_visit_class c ON c.id=a.visitclass_id
LEFT JOIN om_typevalue t ON t.id::integer=a.status WHERE typevalue=''lot_cat_status''', 
3, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}')
ON CONFLICT (listname, device) DO NOTHING; 


INSERT INTO config_form_list VALUES('om_visit', 'SELECT o.id as sys_id, ''om_visit'' as sys_table_id,''id'' as sys_idname, o.id AS "Id visita" , date_trunc(''minute'',o.startdate) as  "Iniciada",  lot_id AS "Id lot", c.idval AS "Tipus",
CASE WHEN o.status=4 THEN ''Si'' ELSE ''NO'' END AS "Visita acabada"  FROM om_visit o 
JOIN config_visit_class c ON c.id = o.class_id
JOIN om_visit_lot t on t.id=o.lot_id', 3, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json)
ON CONFLICT (listname, device) DO NOTHING; 


/*CONFIG_FORM_FIELDS*/
--visit_manager tab_data (visit_manager)
INSERT INTO config_form_fields VALUES ('visit_manager', 'form_visit', 'main', 'user_id', 'lyt_data_1', 1, 'text', 'combo', 'Name', NULL, NULL, false, false, false, false, false, 'SELECT id, name AS idval FROM cat_users WHERE name = current_user', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('visit_manager', 'form_visit', 'main', 'date', 'lyt_data_1', 2, 'date', 'datetime', 'Date', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('visit_manager', 'form_visit', 'main', 'startbutton', 'lyt_data_1', 3, NULL, 'button', 'START LOT', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}', '{"functionName": "set_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('visit_manager', 'form_visit', 'main', 'team_id', 'lyt_data_1', 4, 'text', 'combo', 'Team', NULL, NULL, false, true, true, false, false, 'SELECT id, idval FROM (SELECT DISTINCT cat_team.id, idval FROM cat_team 
LEFT JOIN v_om_team_x_user ON v_om_team_x_user.team=cat_team.idval
JOIN om_visit_lot ON om_visit_lot.team_id=cat_team.id WHERE status IN (3,4,5) AND v_om_team_x_user.user_name=current_user)a 
WHERE id NOT IN (SELECT team_id FROM om_visit_lot_x_user WHERE endtime IS NULL AND user_id!=current_user)', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "get_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('visit_manager', 'form_visit', 'main', 'lot_id', 'lyt_data_1', 5, 'text', 'combo', 'Lot', NULL, NULL, false, false, true, false, false, 'SELECT u.id, concat( u.id, '' | '',u.visitclass_id,'' | '',u.status) as idval FROM v_ui_om_visit_lot u JOIN om_visit_lot USING (id) 
JOIN om_typevalue ON u.status=om_typevalue.idval AND typevalue=''lot_cat_status''
WHERE om_typevalue.id::integer IN (3,4,5)', NULL, NULL, 'team_id', ' AND team_id', NULL, '{"setMultiline":false}', '{"functionName": "get_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('visit_manager', 'form_visit', 'main', 'endbutton', 'lyt_data_1', 6, NULL, 'button', 'END LOT', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "set_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('visit_manager', 'form_visit', 'main', 'backbutton', 'lyt_data_3', 1, NULL, 'button', 'Close', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "set_previous_from_back"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--visit_manager tab_lot (om_visit_lot)
INSERT INTO config_form_fields VALUES ('om_visit_lot', 'form_list_header', 'main', 'team_id', 'lyt_data_1', 1, 'text', 'combo', 'Team', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM cat_team', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('om_visit_lot', 'form_list_header', 'main', 'limit', 'lyt_data_1', 2, 'integer', 'text', 'Limit', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('om_visit_lot', 'form_list_footer', 'main', 'createlot', 'lyt_data_1', 3, NULL, 'button', 'CREATE NEW LOT', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "get_lot"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--visit_manager tab_done (om_visit)
INSERT INTO config_form_fields VALUES ('om_visit', 'form_list_header', 'main', 'team_id', 'lyt_data_1', 1, 'text', 'combo', 'Team', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM cat_team', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('om_visit', 'form_list_header', 'main', 'startdate', 'lyt_data_1', 2, 'date', 'datetime', 'Startdate', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"2020-01-01"}', '{"functionName": "get_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('om_visit', 'form_list_header', 'main', 'limit', 'lyt_data_1', 3, 'integer', 'text', 'Limit', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', '{"functionName": "get_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--visit_manager tab_team (om_vehicle_x_parameters)
INSERT INTO config_form_fields
VALUES('om_vehicle_x_parameters', 'form_list_header', 'main', 'divider', 'data_1', 6, NULL, 'divider', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);

INSERT INTO config_form_fields
VALUES('om_vehicle_x_parameter', 'form_list_header', 'main', 'limit', 'data_1', 4, 'integer', 'text', 'Limit', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault": 15}'::json, '{"functionName": "get_visit_manager"}'::json, NULL, false);

INSERT INTO config_form_fields
VALUES('om_vehicle_x_parameters', 'form_list_header', 'main', 'vehicle_id', 'data_1', 2, 'string', 'combo', 'Vehicle', NULL, NULL, false, false, true, false, NULL, 'select distinct(v.id), v.idval from om_team_x_vehicle tv
join ext_cat_vehicle v on v.id=tv.vehicle_id
join om_team_x_user tu on tv.team_id=tu.team_id
where tu.user_id=current_user', true, false, 'team_id', ' AND tu.team_id', NULL, '{"setMultiline":false}'::json, NULL, NULL, false);

INSERT INTO config_form_fields
VALUES('om_vehicle_x_parameters', 'form_list_header', 'main', 'team_id', 'data_1', 1, 'string', 'combo', 'Team', NULL, NULL, false, true, true, false, NULL, 'SELECT DISTINCT(ext_cat_vehicle.id), idval FROM ext_cat_vehicle  
JOIN om_team_x_vehicle ON  om_team_x_vehicle.vehicle_id = ext_cat_vehicle.id
WHERE ext_cat_vehicle.id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false);

INSERT INTO config_form_fields
VALUES('om_vehicle_x_parameters', 'form_list_header', 'main', 'load', 'data_1', 3, 'string', 'text', 'Kg', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false);

INSERT INTO config_form_fields
VALUES('om_vehicle_x_parameters', 'form_list_header', 'main', 'acceptbutton', 'data_1', 5, NULL, 'button', 'Accept', NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{"functionName": "set_vehicle_load"}'::json, NULL, false);


-- form_lot
INSERT INTO config_form_fields VALUES ('lot', 'form_lot', 'main', 'id', 'lyt_data_1', 1, 'integer', 'text', 'Lot id', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('lot', 'form_lot', 'main', 'team_id', 'lyt_data_1', 2, 'text', 'combo', 'Team', NULL, NULL, false, false, false, false, false, 'SELECT cat_team.id, cat_team.idval FROM cat_team
JOIN v_om_team_x_user ON v_om_team_x_user.team = cat_team.idval
WHERE v_om_team_x_user.user_id = current_user', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('lot', 'form_lot', 'main', 'descript', 'lyt_data_1', 3, 'text', 'text', 'Description', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('lot', 'form_lot', 'main', 'visitclass_id', 'lyt_data_1', 4, 'text', 'combo', 'Visit class', NULL, NULL, false, false, true, false, false, 'SELECT id, idval FROM config_visit_class WHERE id IS NOT NULL AND visit_type=1', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('lot', 'form_lot', 'main', 'status', 'lyt_data_1', 5, 'text', 'combo', 'Status', NULL, NULL, false, false, true, false, false, 'SELECT DISTINCT id, idval FROM om_typevalue WHERE typevalue=''lot_cat_status'' AND id::integer IN (3,4,5)', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "get_lot"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('lot', 'form_lot', 'main', 'acceptbutton', 'lyt_data_3', 1, NULL, 'button', 'Accept', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "set_lot"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

-- update config_web_forms *_x_visit_manager (if its default value)
UPDATE config_web_forms SET query_text='SELECT visit_id AS sys_id, visit_start AS "Date", config_visit_class.idval AS "Visit class", om_visit.user_name AS "Visit user"
FROM v_ui_om_visitman_x_node
JOIN om_visit ON om_visit.id=v_ui_om_visitman_x_node.visit_id
JOIN config_visit_class ON config_visit_class.id=om_visit.class_id' 
WHERE query_text='SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node'
AND table_id='node_x_visit_manager';

UPDATE config_web_forms SET query_text='SELECT visit_id AS sys_id, visit_start AS "Date", config_visit_class.idval AS "Visit class", om_visit.user_name AS "Visit user"
FROM v_ui_om_visitman_x_arc
JOIN om_visit ON om_visit.id=v_ui_om_visitman_x_arc.visit_id
JOIN config_visit_class ON config_visit_class.id=om_visit.class_id' WHERE query_text='SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc'
AND table_id='arc_x_visit_manager';

UPDATE config_web_forms SET query_text='SELECT visit_id AS sys_id, visit_start AS "Date", config_visit_class.idval AS "Visit class", om_visit.user_name AS "Visit user"
FROM v_ui_om_visitman_x_connec
JOIN om_visit ON om_visit.id=v_ui_om_visitman_x_connec.visit_id
JOIN config_visit_class ON config_visit_class.id=om_visit.class_id' WHERE query_text='SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec'
AND table_id='connec_x_visit_manager';


-- set serial id on ext_cat_vehicle 
CREATE SEQUENCE ext_cat_vehicle_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

ALTER TABLE ext_cat_vehicle ALTER COLUMN id set default nextval('SCHEMA_NAME.ext_cat_vehicle_id_seq');


INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('om_lot_block_dma2category', 'dynamic', 'Used in gw_trg_dma2category', 'role_om', NULL, NULL, NULL, NULL, true, NULL, 'ud', false, NULL, NULL, NULL, false, 'text', NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_manage');
