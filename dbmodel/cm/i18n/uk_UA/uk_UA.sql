/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('workorder_id', 'workorder', 'form_feature', 'tab_data', 'Workorder Id:', 'Workorder Id'),
    ('active', 'generic', 'team_create', 'tab_none', 'Active:', 'Active:'),
    ('inventoryclass_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Inventory Class:', 'Inventory Class'),
    ('descript', 'lot', 'form_feature', 'tab_data', 'Description:', 'Description'),
    ('organization_assigned', 'lot', 'form_feature', 'tab_data', 'Organization Assigned:', 'Organization Assigned'),
    ('expl_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('organization_id', 'campaign_visit', 'form_feature', 'tab_data', 'Organization:', 'Organization'),
    ('serie', 'workorder', 'form_feature', 'tab_data', 'Serie:', 'Serie'),
    ('workorder_id', 'lot', 'form_feature', 'tab_data', 'Workorder id:', 'Workorder id'),
    ('descript', 'campaign_review', 'form_feature', 'tab_data', 'Description:', 'Description'),
    ('status', 'campaign_inventory', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('startdate', 'lot', 'form_feature', 'tab_data', 'Planified start:', 'Planified start'),
    ('cost', 'workorder', 'form_feature', 'tab_data', 'Cost:', 'Cost'),
    ('status', 'lot', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('name', 'generic', 'team_create', 'tab_none', 'Name:', 'Name:'),
    ('expl_id', 'campaign_review', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('lot_id', 'lot', 'form_feature', 'tab_data', 'Lot ID:', 'Id'),
    ('descript', 'campaign_inventory', 'form_feature', 'tab_data', 'Description:', 'Description'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', 'Active:', 'Active'),
    ('txt_infolog', 'generic', 'check_project_cm', 'tab_log', NULL, NULL),
    ('active', 'campaign_inventory', 'form_feature', 'tab_data', 'Active:', 'Active'),
    ('real_startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Real start:', 'Real start'),
    ('real_enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Real end:', 'Real end'),
    ('campaign_id', 'lot', 'form_feature', 'tab_data', 'Campaign id:', 'Campaign id'),
    ('real_enddate', 'campaign_review', 'form_feature', 'tab_data', 'Real end:', 'Real end'),
    ('enddate', 'campaign_review', 'form_feature', 'tab_data', 'Planified end:', 'Planified end'),
    ('address', 'workorder', 'form_feature', 'tab_data', 'Address:', 'Address'),
    ('campaign_id', 'campaign_review', 'form_feature', 'tab_data', 'Campaign Id:', 'Id'),
    ('expl_id', 'campaign_visit', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('exercise', 'workorder', 'form_feature', 'tab_data', 'Exercise:', 'Exercise'),
    ('sector_id', 'lot', 'form_feature', 'tab_data', 'Sector Id:', 'Sector Id'),
    ('name', 'campaign_visit', 'form_feature', 'tab_data', 'Name:', 'Name'),
    ('enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Planified end:', 'Planified end'),
    ('expl_id', 'lot', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Planified start:', 'Planified start'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', NULL, NULL),
    ('campaign_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Campaign Id:', 'Id'),
    ('active', 'lot', 'form_feature', 'tab_data', 'Active:', 'Active'),
    ('campaign_id', 'campaign_visit', 'form_feature', 'tab_data', 'Lot Id:', 'Id'),
    ('visitclass_id', 'campaign_visit', 'form_feature', 'tab_data', 'Visitclass:', 'Visitclass'),
    ('lot', 'generic', 'check_project_cm', 'tab_data', 'Lot:', 'Lot'),
    ('real_enddate', 'lot', 'form_feature', 'tab_data', 'Real end:', 'Real end'),
    ('observ', 'workorder', 'form_feature', 'tab_data', 'Observ:', 'Observ'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', 'Active:', 'Active'),
    ('status', 'campaign_visit', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Planified start:', 'Planified start'),
    ('descript', 'generic', 'team_create', 'tab_none', 'Description:', 'Description:'),
    ('name', 'campaign_inventory', 'form_feature', 'tab_data', 'Name:', 'Name'),
    ('enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Planified end:', 'Planified end'),
    ('workorder_name', 'workorder', 'form_feature', 'tab_data', 'Workorder name:', 'Workorder name'),
    ('startdate', 'campaign_review', 'form_feature', 'tab_data', 'Planified start:', 'Planified start'),
    ('campaign', 'generic', 'check_project_cm', 'tab_data', 'Campaign:', 'Campaign'),
    ('sector_id', 'campaign_visit', 'form_feature', 'tab_data', 'Sector Id:', 'Sector Id'),
    ('real_startdate', 'campaign_review', 'form_feature', 'tab_data', 'Real start:', 'Real start'),
    ('sector_id', 'campaign_review', 'form_feature', 'tab_data', 'Sector Id:', 'Sector Id'),
    ('name', 'lot', 'form_feature', 'tab_data', 'Name:', 'Name'),
    ('real_startdate', 'lot', 'form_feature', 'tab_data', 'Real start:', 'Real start'),
    ('sector_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Sector Id:', 'Sector Id'),
    ('startdate', 'workorder', 'form_feature', 'tab_data', 'Startdate:', 'Startdate'),
    ('code', 'generic', 'team_create', 'tab_none', 'Code:', 'Code:'),
    ('name', 'campaign_review', 'form_feature', 'tab_data', 'Name:', 'Name'),
    ('enddate', 'lot', 'form_feature', 'tab_data', 'Planified end:', 'Planified end'),
    ('reviewclass_id', 'campaign_review', 'form_feature', 'tab_data', 'Reviewclass:', 'Reviewclass'),
    ('descript', 'campaign_visit', 'form_feature', 'tab_data', 'Description:', 'Description'),
    ('real_enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Real end:', 'Real end'),
    ('organization_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Organization:', 'Organization'),
    ('workorder_class', 'workorder', 'form_feature', 'tab_data', 'Workorder class:', 'Workorder class'),
    ('status', 'campaign_review', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('team_id', 'lot', 'form_feature', 'tab_data', 'Team:', 'Team'),
    ('organization_id', 'campaign_review', 'form_feature', 'tab_data', 'Organization:', 'Organization'),
    ('real_startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Real start:', 'Real start'),
    ('workorder_type', 'workorder', 'form_feature', 'tab_data', 'Workorder type:', 'Workorder type')
) AS v(columnname, formname, formtype, tabname, label, tooltip)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_form_tabs AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('selector_campaign', 'tab_campaign', 'Campaign', 'Campaign'),
    ('selector_campaign', 'tab_lot', 'Lot', 'Lot')
) AS v(formname, tabname, label, tooltip)
WHERE t.formname = v.formname AND t.tabname = v.tabname;

UPDATE config_param_system AS t
SET label = v.label, descript = v.descript
FROM (
    VALUES
    ('basic_selector_tab_lot', 'Selector variables', 'Variable to configura all options related to search for the specificic tab'),
    ('admin_campaign_type', NULL, 'Variable to specify wich type of campaign we whant to see when create'),
    ('basic_selector_tab_campaign', 'Selector variables', 'Variable to configura all options related to search for the specificic tab')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

UPDATE sys_typevalue AS t
SET idval = v.idval, descript = v.descript
FROM (
    VALUES
    ('8', 'campaign_status', 'READY-TO-ACCEPT', NULL),
    ('6', 'lot_feature_status', 'CANCELED', NULL),
    ('6', 'campaign_status', 'EXECUTED', NULL),
    ('3', 'campaign_feature_status', 'VISITED', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('4', 'lot_status', 'ON GOING', NULL),
    ('6', 'lot_status', 'EXECUTED', NULL),
    ('2', 'campaign_type', 'VISIT', NULL),
    ('7', 'lot_status', 'REJECTED', NULL),
    ('9', 'lot_status', 'ACCEPTED', NULL),
    ('9', 'campaign_status', 'ACCEPTED', NULL),
    ('4', 'lot_feature_status', 'VISIT AGAIN', NULL),
    ('4', 'campaign_feature_status', 'VISIT AGAIN', NULL),
    ('2', 'campaign_feature_status', 'NOT VISITED', NULL),
    ('4', 'campaign_status', 'ON GOING', NULL),
    ('2', 'campaign_status', 'PLANIFIED', NULL),
    ('5', 'lot_feature_status', 'ACCEPTED', NULL),
    ('1', 'lot_feature_status', 'PLANIFIED', NULL),
    ('8', 'lot_status', 'READY-TO-ACCEPT', NULL),
    ('10', 'lot_status', 'CANCELED', NULL),
    ('6', 'campaign_feature_status', 'CANCELED', NULL),
    ('3', 'campaign_status', 'ASSIGNED', NULL),
    ('3', 'lot_status', 'ASSIGNED', NULL),
    ('2', 'lot_feature_status', 'NOT VISITED', NULL),
    ('2', 'lot_status', 'PLANIFIED', NULL),
    ('1', 'campaign_type', 'REVIEW', NULL),
    ('7', 'campaign_status', 'REJECTED', NULL),
    ('5', 'campaign_feature_status', 'ACCEPTED', NULL),
    ('1', 'campaign_feature_status', 'PLANIFIED', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'lyt_buttons', NULL),
    ('1', 'lot_status', 'PLANIFYING', NULL),
    ('3', 'lot_feature_status', 'VISITED', NULL),
    ('10', 'campaign_status', 'CANCELED', NULL),
    ('3', 'campaign_type', 'INVENTORY', NULL),
    ('1', 'campaign_status', 'PLANIFYING', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

UPDATE config_form_fields AS t
SET widgetcontrols = v.text::json
FROM (
	VALUES
	('active', 'campaign_review', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
    ('active', 'lot', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', '{"vdefault_value": "Esta función tiene por objetivo pasar el control de calidad de una campaña, pudiendo escoger de forma concreta un lote especifico.<br><br>Se analizan diferentes aspectos siendo lo más destacado que se configura para que los datos esten operativos en el conjunto de una campaña para que el modelo hidraulico funcione."}'),
    ('active', 'campaign_inventory', 'form_feature', 'tab_data', '{"vdefault_value": "True"}')
) AS v(columnname, formname, formtype, tabname, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';
UPDATE sys_table AS t
SET alias = v.alias, descript = v.descript
FROM (
    VALUES
    ('%_lot_connec', NULL, 've_ws44_1709_lot_connec'),
    ('%_camp_link', NULL, 've_ws44_1709_camp_link'),
    ('%_camp_connec', NULL, 've_ws44_1709_camp_connec'),
    ('%_lot_node', NULL, 've_ws44_1709_lot_node'),
    ('%_lot_link', NULL, 've_ws44_1709_lot_link'),
    ('%_lot_arc', NULL, 've_ws44_1709_lot_arc'),
    ('%_camp_arc', NULL, 've_ws44_1709_camp_arc'),
    ('%_camp_node', NULL, 've_ws44_1709_camp_node')
) AS v(id, alias, descript)
WHERE t.id = v.id;

UPDATE config_form_tableview AS t
SET alias = v.alias
FROM (
    VALUES
    ('om_campaign_x_link', 'qindex2', 'Qindex2'),
    ('om_campaign_x_link', 'link_id', 'Link id'),
    ('om_campaign_lot_x_node', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_connec', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_link', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_link', 'lot_id', 'Lot id'),
    ('om_campaign_lot_x_link', 'action', 'Action'),
    ('v_ui_campaign', 'name', 'Name'),
    ('v_ui_campaign', 'status', 'Status'),
    ('v_ui_campaign', 'real_startdate', 'Real start date'),
    ('om_campaign_lot_x_link', 'qindex2', 'Qindex2'),
    ('om_campaign_lot_x_link', 'update_count', 'Update count'),
    ('om_campaign_lot_x_arc', 'node_2', 'Node 2'),
    ('cat_team', 'team_id', 'Team id'),
    ('om_campaign_x_node', 'qindex2', 'Qindex2'),
    ('v_ui_campaign', 'startdate', 'Startdate'),
    ('om_campaign_lot_x_arc', 'update_count', 'Update count'),
    ('om_campaign_x_connec', 'the_geom', 'The geom'),
    ('v_ui_campaign', 'organization_id', 'Organization id'),
    ('om_campaign_lot_x_connec', 'update_log', 'Update log'),
    ('om_campaign_x_link', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_connec', 'qindex2', 'Qindex2'),
    ('om_campaign_x_connec', 'code', 'Code'),
    ('om_campaign_x_arc', 'campaign_id', 'Campaign id'),
    ('v_ui_lot', 'real_enddate', 'Real end date'),
    ('v_ui_lot', 'lot_id', 'Lot id'),
    ('v_ui_lot', 'descript', 'Descript'),
    ('v_ui_lot', 'workorder_name', 'Workorder name'),
    ('v_ui_lot', 'startdate', 'Startdate'),
    ('v_ui_lot', 'enddate', 'End date'),
    ('om_campaign_lot_x_connec', 'lot_id', 'Lot id'),
    ('om_campaign_lot_x_arc', 'arc_id', 'Arc id'),
    ('cat_user', 'username', 'User name'),
    ('om_campaign_x_link', 'status', 'Status'),
    ('om_campaign_lot_x_link', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_arc', 'action', 'Action'),
    ('om_campaign_x_arc', 'arccat_id', 'Arccat id'),
    ('om_campaign_x_connec', 'id', 'Id'),
    ('cat_team', 'code', 'Code'),
    ('cat_team', 'role_id', 'Role id'),
    ('om_campaign_lot_x_node', 'node_id', 'Node id'),
    ('om_campaign_x_connec', 'connectcat_id', 'Connectcat id'),
    ('om_campaign_x_arc', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_connec', 'org_observ', 'Org observ'),
    ('om_campaign_x_link', 'linkcat_id', 'Linkcat id'),
    ('om_campaign_x_node', 'status', 'Status'),
    ('om_campaign_x_link', 'org_observ', 'Org observ'),
    ('v_ui_campaign', 'enddate', 'End date'),
    ('om_campaign_x_connec', 'campaign_id', 'Campaign id'),
    ('om_campaign_lot_x_arc', 'node_1', 'Node 1'),
    ('om_campaign_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_link', 'team_observ', 'Team observ'),
    ('cat_user', 'active', 'Active'),
    ('om_campaign_lot_x_node', 'action', 'Action'),
    ('om_campaign_x_node', 'the_geom', 'The geom'),
    ('cat_team', 'descript', 'Descript'),
    ('om_campaign_lot_x_arc', 'lot_id', 'Lot id'),
    ('v_ui_campaign', 'the_geom', 'The geom'),
    ('om_campaign_lot_x_node', 'code', 'Code'),
    ('om_campaign_x_arc', 'org_observ', 'Org observ'),
    ('om_campaign_x_link', 'code', 'Code'),
    ('v_ui_lot', 'active', 'Active'),
    ('v_ui_lot', 'expl_id', 'Expl id'),
    ('om_campaign_x_arc', 'node_1', 'Node 1'),
    ('om_campaign_lot_x_connec', 'id', 'Id'),
    ('om_campaign_x_node', 'org_observ', 'Org observ'),
    ('v_ui_lot', 'real_startdate', 'Real start date'),
    ('om_campaign_lot_x_connec', 'action', 'Action'),
    ('om_campaign_x_connec', 'status', 'Status'),
    ('v_ui_lot', 'sector_id', 'Sector id'),
    ('v_ui_lot', 'team_name', 'Team name'),
    ('v_ui_campaign', 'active', 'Active'),
    ('om_campaign_x_arc', 'node_2', 'Node 2'),
    ('om_campaign_x_link', 'campaign_id', 'Campaign id'),
    ('om_campaign_x_connec', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_connec', 'connec_id', 'Connec id'),
    ('cat_user', 'user_id', 'User id'),
    ('om_campaign_x_arc', 'status', 'Status'),
    ('om_campaign_lot_x_link', 'code', 'Code'),
    ('om_campaign_x_node', 'node_id', 'Node id'),
    ('cat_organization', 'active', 'Active'),
    ('om_campaign_x_node', 'code', 'Code'),
    ('cat_organization', 'descript', 'Descript'),
    ('v_ui_campaign', 'campaign_class', 'Campaign class'),
    ('v_ui_campaign', 'real_enddate', 'Real end date'),
    ('om_campaign_lot_x_link', 'id', 'Id'),
    ('om_campaign_x_arc', 'arc_type', 'Arc type'),
    ('cat_team', 'active', 'Active'),
    ('v_ui_campaign', 'campaign_id', 'Campaign id'),
    ('v_ui_lot', 'campaign_name', 'Campaign name'),
    ('om_campaign_x_node', 'admin_observ', 'Admin observ'),
    ('v_ui_lot', 'name', 'Name'),
    ('om_campaign_lot_x_arc', 'team_observ', 'Team observ'),
    ('om_campaign_x_arc', 'qindex2', 'Qindex2'),
    ('cat_user', 'teamname', 'Team name'),
    ('om_campaign_x_link', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'team_observ', 'Team observ'),
    ('om_campaign_lot_x_connec', 'qindex2', 'Qindex2'),
    ('cat_team', 'orgname', 'Org. name'),
    ('cat_user', 'code', 'Code'),
    ('om_campaign_lot_x_arc', 'qindex2', 'Qindex2'),
    ('v_ui_lot', 'the_geom', 'The geom'),
    ('om_campaign_x_node', 'campaign_id', 'Campaign id'),
    ('v_ui_lot', 'status', 'Status'),
    ('cat_organization', 'code', 'Code'),
    ('om_campaign_lot_x_connec', 'update_count', 'Update count'),
    ('cat_organization', 'orgname', 'Org. name'),
    ('om_campaign_lot_x_node', 'update_log', 'Update log'),
    ('om_campaign_lot_x_arc', 'code', 'Code'),
    ('om_campaign_lot_x_link', 'update_log', 'Update log'),
    ('om_campaign_lot_x_arc', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_arc', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_node', 'id', 'Id'),
    ('om_campaign_x_link', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_node', 'qindex2', 'Qindex2'),
    ('om_campaign_x_arc', 'arc_id', 'Arc id'),
    ('om_campaign_lot_x_connec', 'connec_id', 'Connec id'),
    ('om_campaign_lot_x_connec', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_link', 'link_id', 'Link id'),
    ('om_campaign_lot_x_node', 'lot_id', 'Lot id'),
    ('om_campaign_x_node', 'nodecat_id', 'Nodecat id'),
    ('om_campaign_x_node', 'qindex1', 'Qindex1'),
    ('om_campaign_x_arc', 'the_geom', 'The geom'),
    ('om_campaign_lot_x_arc', 'update_log', 'Update log'),
    ('om_campaign_x_connec', 'qindex1', 'Qindex1'),
    ('om_campaign_x_link', 'the_geom', 'The geom'),
    ('om_campaign_x_node', 'node_type', 'Node type'),
    ('om_campaign_lot_x_connec', 'status', 'Status'),
    ('om_campaign_lot_x_arc', 'status', 'Status'),
    ('om_campaign_lot_x_connec', 'code', 'Code'),
    ('v_ui_campaign', 'descript', 'Descript'),
    ('om_campaign_x_arc', 'code', 'Code'),
    ('om_campaign_lot_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'update_count', 'Update count'),
    ('cat_team', 'teamname', 'Team name'),
    ('om_campaign_lot_x_link', 'status', 'Status'),
    ('om_campaign_x_node', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'qindex1', 'Qindex1'),
    ('om_campaign_x_arc', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_node', 'status', 'Status'),
    ('om_campaign_lot_x_connec', 'team_observ', 'Team observ'),
    ('cat_organization', 'organization_id', 'Organization id'),
    ('v_ui_campaign', 'campaign_type', 'Campaign type')
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

UPDATE sys_fprocess AS t
SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name
FROM (
    VALUES
    (203, 'nodes duplicated with state 1.', 'There are no nodes duplicated with state 1', 'Check duplicated nodes'),
    (200, 'There are some users with no team assigned.', 'All users have a team assigned.', 'Check users consistence'),
    (202, 'There are some orphan nodes', 'There aren''t orphan nodes.', 'Check orphan nodes'),
    (100, 'null value on the column %check_column% of %table_name%', 'The %check_column% on %table_name% have correct values.', 'Check nulls consistence'),
    (201, 'teams with no users assigned.', 'All teams have users assigned.', 'Check teams consistence')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

