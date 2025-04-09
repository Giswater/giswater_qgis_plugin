/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO PARENT_SCHEMA.config_param_system (parameter, value, descript, isenabled, project_type, datatype) VALUES
('plugin_lotmanage', '{"lotManage":"TRUE"}', 'External plugin to use functionality of planified lot visits', FALSE, 'utils', 'json') ON CONFLICT (parameter) DO NOTHING;

INSERT INTO PARENT_SCHEMA.config_param_system (parameter, value, descript, isenabled, project_type, datatype) VALUES
('admin_publish_user', 'qgisserver','Publish user', FALSE, 'utils', 'text') ON CONFLICT (parameter) DO NOTHING;


INSERT INTO PARENT_SCHEMA.sys_table VALUES ('cat_team', 'Catalog of teams', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('om_campaign_lot', 'Table with all lots that took place', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('selector_lot', 'Selector of lots', 'role_basic', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('om_campaign_lot_x_arc', 'Table of arcs related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('om_campaign_lot_x_connec', 'Table of connecs related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('om_campaign_lot_x_node', 'Table of nodes related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('config_visit_class_x_workorder', 'Table of visit classes related to its workorders', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ext_workorder_type', 'Table of workorders related to its types', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ext_workorder_class', 'Table of workorders related to its classes', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ext_workorder', 'External table of workorders', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('om_team_x_user', 'Relation between teams and their users', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;

INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_ui_om_campaign_lot', 'User interface view for lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_res_lot_x_user', 'View with the results of a work realised by a user in relation with one lot', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ve_campaign_x_node', 'View that relates nodes and lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ve_campaign_x_arc', 'View that relates arcs and lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ve_campaign_x_connec', 'View that relates connecs and lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_om_team_x_user', 'View with the realtion between users and teams', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_edit_cat_team', 'Editable view for cat_team', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('v_om_campaign_x_user', 'View with the information aobut works made by a user in relation to one lot', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ve_campaign_x_arc_web', 'View to publish arcs related to lots on web', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ve_campaign_x_node_web', 'View to publish nodes related to lots on web', 'role_om', 0) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_table VALUES ('ve_campaign_x_connec_web', 'View to publish connecs related to lots on web', 'role_om', 0) ON CONFLICT (id) DO NOTHING;

INSERT INTO PARENT_SCHEMA.sys_function VALUES (2898, 'gw_fct_getlot', 'lot_manage', 'function', 'json', 'json', 'Function to provide lot form', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_function VALUES (2862, 'gw_fct_setlot', 'lot_manage', 'function', 'json', 'json', 'Set lot', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_function VALUES (2640, 'gw_fct_getvisitmanager', 'lot_manage', 'function', 'json', 'json', 'To call visit from user', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_function VALUES (2882, 'gw_fct_setvisitmanager', 'lot_manage', 'function', 'json', 'json', 'Function to manage visit manager', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_function VALUES (2997, 'gw_fct_lot_psector_geom', 'lot_manage', 'function', 'json', 'json', 'Function to set the_geom of the psector after its insert', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_function VALUES (2838, 'gw_trg_edit_cat_team', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_edit_cat_team', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_function VALUES (2842, 'gw_trg_edit_lot_x_user', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_lot_x_user', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_function VALUES (2834, 'gw_trg_edit_team_x_user', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_team_x_user', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.sys_function VALUES (2836, 'gw_trg_edit_team_x_visitclass', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_team_x_visitclass', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('campaign_cat_status', 1, 'PLANIFYING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('campaign_cat_status', 2, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('campaign_cat_status', 3, 'ASSIGNED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('campaign_cat_status', 4, 'ON GOING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('campaign_cat_status', 5, 'EXECUTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('campaign_cat_status', 6, 'REVISED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('campaign_cat_status', 7, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('campaign_x_feature_status', 1, 'Not visited', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('campaign_x_feature_status', 0, 'Visited', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO PARENT_SCHEMA.om_typevalue VALUES ('visit_status', 5, 'Validated', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO PARENT_SCHEMA.config_typevalue VALUES ('tabname_typevalue', 'tab_team', 'tab_team', 'tabTeam');
INSERT INTO PARENT_SCHEMA.config_typevalue VALUES ('widgetfunction_typevalue', 'get_visit_manager', 'get_visit_manager', 'gwGetVisitManager')
ON CONFLICT (typevalue, id) DO UPDATE SET camelstyle=EXCLUDED.camelstyle;
INSERT INTO PARENT_SCHEMA.config_typevalue VALUES ('widgetfunction_typevalue', 'set_visit_manager', 'set_visit_manager', 'gwSetVisitManager')
ON CONFLICT (typevalue, id) DO UPDATE SET camelstyle=EXCLUDED.camelstyle;
INSERT INTO PARENT_SCHEMA.config_typevalue VALUES ('widgetfunction_typevalue', 'get_lot', 'get_lot', 'gwGetLot')
ON CONFLICT (typevalue, id) DO UPDATE SET camelstyle=EXCLUDED.camelstyle;
INSERT INTO PARENT_SCHEMA.config_typevalue VALUES ('widgetfunction_typevalue', 'set_lot', 'set_lot', 'gwSetLot')
ON CONFLICT (typevalue, id) DO UPDATE SET camelstyle=EXCLUDED.camelstyle;


/*config_form_tabs*/
DELETE FROM PARENT_SCHEMA.config_form_tabs WHERE formname='visitManager';
INSERT INTO PARENT_SCHEMA.config_form_tabs VALUES ('visit_manager', 'tab_data', 'General data', 'Data', 'role_om', '{"name":"gwGetVisitManager", "parameters":{"form":{"tabData":{"active":true}, "tabLots":{"active":false}}}}', '{}', 3) ON CONFLICT (formname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_tabs VALUES ('visit_manager', 'tab_done', 'Executed visits', 'Executed visits', 'role_om', '{"name":"gwGetVisitManager", "parameters":{"form":{"tabData":{"active":false}, "tabLots":{"active":false},"tabDone":{"active":true}}}}', '[{"actionName":"actionDelete", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "actionTable":{"tableName":"om_visit","idName":"id"}, "disabled":false},{"actionName":"changeAction", "actionFunction":"gwGetVisit", "disabled":false}]', 3)ON CONFLICT (formname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_tabs VALUES ('visit_manager', 'tab_lot', 'Lots', 'Lots', 'role_om', '{"name":"gwGetVisitManager", "parameters":{"form":{"tabData":{"active":false}, "tabLots":{"active":true}}}}', '[{"actionName":"actionDelete", "actionFunction":"gwSetDelete", "actionTooltip":"Delete file", "actionTable":{"tableName":"om_visit_lot","idName":"id"}, "disabled":false},{"actionName":"changeAction", "actionFunction":"gwGetLot", "disabled":false}]', 3)ON CONFLICT (formname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_tabs VALUES ('lot', 'tab_data', 'Data', 'Data', 'role_om', '{"name":"gwGetLot", "parameters":{"form":{"tabData":{"active":true}}}}', '{}', 3) ON CONFLICT (formname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_tabs VALUES ('v_edit_arc', 'tab_visit', 'Visit', 'List of visits', 'role_basic', NULL, NULL, 4) ON CONFLICT (formname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_tabs VALUES ('v_edit_node', 'tab_visit', 'Visit', 'List of visits', 'role_basic', NULL, NULL, 4) ON CONFLICT (formname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_tabs VALUES ('v_edit_connec', 'tab_visit', 'Visit', 'List of visits', 'role_basic', NULL, NULL, 4) ON CONFLICT (formname, tabname) DO NOTHING;


/*config_form_list*/
INSERT INTO PARENT_SCHEMA.config_form_list VALUES ('om_campaign_lot', 'SELECT a.id AS sys_id, ''om_campaign_lot'' as sys_listname, ''id'' as sys_idname, a.id AS lot_id, c.idval AS visitclass_id, t.idval AS status FROM om_campaign_lot a
JOIN config_visit_class c ON c.id=a.visitclass_id
LEFT JOIN PARENT_SCHEMA.om_typevalue t ON t.id::integer=a.status WHERE typevalue=''lot_cat_status''',
3, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}')
ON CONFLICT (listname, device) DO NOTHING;

INSERT INTO PARENT_SCHEMA.config_form_list VALUES ('om_visit', 'SELECT o.id as sys_id, ''om_visit'' as sys_listname,''id'' as sys_idname, o.id, date_trunc(''second'',startdate) AS startdate, c.idval AS visitclass_id FROM om_visit o
LEFT JOIN config_visit_class c ON c.id=o.class_id
WHERE  user_name=current_user',
3, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}')
ON CONFLICT (listname, device) DO NOTHING;

/*config_form_fields*/
ALTER TABLE PARENT_SCHEMA.config_form_fields DISABLE TRIGGER gw_trg_config_control;

--visit_manager tab_data (visit_manager)
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('visit_manager', 'form_visit', 'tab_none', 'user_id', 'lyt_data_1', 1, 'text', 'combo', 'Name', NULL, NULL, false, false, false, false, false, 'SELECT id, name AS idval FROM cat_users WHERE name = current_user', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('visit_manager', 'form_visit', 'tab_none', 'date', 'lyt_data_1', 2, 'date', 'datetime', 'Date', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('visit_manager', 'form_visit', 'tab_none', 'startbutton', 'lyt_data_1', 3, NULL, 'button', 'START LOT', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL,'{"setMultiline":false}', '{"functionName": "set_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('visit_manager', 'form_visit', 'tab_none', 'team_id', 'lyt_data_1', 4, 'text', 'combo', 'Team', NULL, NULL, false, true, true, false, false, 'SELECT id, idval FROM (SELECT DISTINCT cat_team.id, idval FROM cat_team
LEFT JOIN v_om_team_x_user ON v_om_team_x_user.team=cat_team.idval
JOIN om_campaign_lot ON om_campaign_lot.team_id=cat_team.id WHERE status IN (3,4,5) AND v_om_team_x_user.user_name=current_user)a');

INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('visit_manager', 'form_visit', 'tab_none', 'lot_id', 'lyt_data_1', 5, 'text', 'combo', 'Lot', NULL, NULL, false, false, true, false, false, 'SELECT u.id, concat(u.id, '' | '', u.status) as idval FROM v_ui_om_campaign_lot u JOIN ud.om_campaign_lot USING (id)
JOIN PARENT_SCHEMA.om_typevalue ON u.status=PARENT_SCHEMA.om_typevalue.idval AND typevalue=''lot_cat_status''
WHERE PARENT_SCHEMA.om_typevalue.id::integer IN (3,4,5)', NULL, NULL, 'team_id', ' AND team_id', NULL, '{"setMultiline":false}', '{"functionName": "get_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('visit_manager', 'form_visit', 'tab_none', 'endbutton', 'lyt_data_1', 6, NULL, 'button', 'END LOT', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "set_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('visit_manager', 'form_visit', 'tab_none', 'backbutton', 'lyt_data_3', 1, NULL, 'button', 'Close', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "set_previous_from_back"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--visit_manager tab_lot (om_visit_lot)
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('om_campaign_lot', 'form_list_header', 'tab_none', 'team_id', 'lyt_data_1', 1, 'text', 'combo', 'Team', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM cat_team', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('om_campaign_lot', 'form_list_header', 'tab_none', 'limit', 'lyt_data_1', 2, 'integer', 'text', 'Limit', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('om_campaign_lot', 'form_list_footer', 'tab_none', 'createlot', 'lyt_data_1', 3, NULL, 'button', 'CREATE NEW LOT', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "get_lot"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--visit_manager tab_done (om_visit)
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('om_visit', 'form_list_header', 'tab_none', 'team_id', 'lyt_data_1', 1, 'text', 'combo', 'Team', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM cat_team', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('om_visit', 'form_list_header', 'tab_none', 'startdate', 'lyt_data_1', 2, 'date', 'datetime', 'Startdate', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"2020-01-01"}', '{"functionName": "get_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('om_visit', 'form_list_header', 'tab_none', 'limit', 'lyt_data_1', 3, 'integer', 'text', 'Limit', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', '{"functionName": "get_visit_manager"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

-- form_lot
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('lot', 'form_lot', 'tab_none', 'id', 'lyt_data_1', 1, 'integer', 'text', 'Lot id', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('lot', 'form_lot', 'tab_none', 'team_id', 'lyt_data_1', 2, 'text', 'combo', 'Team', NULL, NULL, false, false, false, false, false, 'SELECT cat_team.id, cat_team.idval FROM cat_team
JOIN v_om_team_x_user ON v_om_team_x_user.team = cat_team.idval
WHERE v_om_team_x_user.user_id = current_user', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('lot', 'form_lot', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'Description', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('lot', 'form_lot', 'tab_none', 'visitclass_id', 'lyt_data_1', 4, 'text', 'combo', 'Visit class', NULL, NULL, false, false, true, false, false, 'SELECT id, idval FROM config_visit_class WHERE id IS NOT NULL AND visit_type=1', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', NULL, NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('lot', 'form_lot', 'tab_none', 'status', 'lyt_data_1', 5, 'text', 'combo', 'Status', NULL, NULL, false, false, true, false, false, 'SELECT DISTINCT id, idval FROM PARENT_SCHEMA.om_typevalue WHERE typevalue=''lot_cat_status'' AND id::integer IN (3,4,5)', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "get_lot"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
INSERT INTO PARENT_SCHEMA.config_form_fields VALUES ('lot', 'form_lot', 'tab_none', 'acceptbutton', 'lyt_data_3', 1, NULL, 'button', 'Accept', NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}', '{"functionName": "set_lot"}', NULL, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

ALTER TABLE PARENT_SCHEMA.config_form_fields ENABLE TRIGGER gw_trg_config_control;

-- update config_form_list *_x_visit_manager (if its default value)
UPDATE PARENT_SCHEMA.config_form_list SET query_text='SELECT visit_id AS sys_id, visit_start AS "Date", config_visit_class.idval AS "Visit class", om_visit.user_name AS "Visit user"
FROM v_ui_om_visitman_x_node
JOIN om_visit ON om_visit.id=v_ui_om_visitman_x_node.visit_id
JOIN config_visit_class ON config_visit_class.id=om_visit.class_id'
WHERE query_text='SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node'
AND listname='node_x_visit_manager';

UPDATE PARENT_SCHEMA.config_form_list SET query_text='SELECT visit_id AS sys_id, visit_start AS "Date", config_visit_class.idval AS "Visit class", om_visit.user_name AS "Visit user"
FROM v_ui_om_visitman_x_arc
JOIN om_visit ON om_visit.id=v_ui_om_visitman_x_arc.visit_id
JOIN config_visit_class ON config_visit_class.id=om_visit.class_id' WHERE query_text='SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc'
AND listname='arc_x_visit_manager';

UPDATE PARENT_SCHEMA.config_form_list SET query_text='SELECT visit_id AS sys_id, visit_start AS "Date", config_visit_class.idval AS "Visit class", om_visit.user_name AS "Visit user"
FROM v_ui_om_visitman_x_connec
JOIN om_visit ON om_visit.id=v_ui_om_visitman_x_connec.visit_id
JOIN config_visit_class ON config_visit_class.id=om_visit.class_id' WHERE query_text='SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec'
AND listname='connec_x_visit_manager';

