/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('active', 'campaign_inventory', 'form_feature', 'tab_data', 'Actiu:', 'Actius'),
    ('campaign_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Identificador de campanya:', 'Id'),
    ('descript', 'campaign_inventory', 'form_feature', 'tab_data', 'Descripció:', 'Descripció'),
    ('enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Final previst:', 'Final planificat'),
    ('expl_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Id explotació:', 'Id expl'),
    ('inventoryclass_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Classe d''inventari:', 'Classe d''inventari'),
    ('name', 'campaign_inventory', 'form_feature', 'tab_data', 'Nom:', 'Nom'),
    ('organization_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Organització:', 'Organització'),
    ('real_enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Final real:', 'Final real'),
    ('real_startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Inici real:', 'Començament real'),
    ('sector_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Id del sector:', 'Id. del sector'),
    ('startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Inici previst:', 'Inici previst'),
    ('status', 'campaign_inventory', 'form_feature', 'tab_data', 'Estat:', 'Estat'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', 'Actiu:', 'Actius'),
    ('campaign_id', 'campaign_review', 'form_feature', 'tab_data', 'Identificador de campanya:', 'Id'),
    ('descript', 'campaign_review', 'form_feature', 'tab_data', 'Descripció:', 'Descripció'),
    ('enddate', 'campaign_review', 'form_feature', 'tab_data', 'Final previst:', 'Final planificat'),
    ('expl_id', 'campaign_review', 'form_feature', 'tab_data', 'Id explotació:', 'Id expl'),
    ('name', 'campaign_review', 'form_feature', 'tab_data', 'Nom:', 'Nom'),
    ('organization_id', 'campaign_review', 'form_feature', 'tab_data', 'Organització:', 'Organització'),
    ('real_enddate', 'campaign_review', 'form_feature', 'tab_data', 'Final real:', 'Final real'),
    ('real_startdate', 'campaign_review', 'form_feature', 'tab_data', 'Inici real:', 'Començament real'),
    ('reviewclass_id', 'campaign_review', 'form_feature', 'tab_data', 'Classe de revisió:', 'Classe de revisió'),
    ('sector_id', 'campaign_review', 'form_feature', 'tab_data', 'Id del sector:', 'Id. del sector'),
    ('startdate', 'campaign_review', 'form_feature', 'tab_data', 'Inici previst:', 'Inici previst'),
    ('status', 'campaign_review', 'form_feature', 'tab_data', 'Estat:', 'Estat'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', 'Actiu:', 'Actius'),
    ('campaign_id', 'campaign_visit', 'form_feature', 'tab_data', 'Identificador del lot:', 'Id'),
    ('descript', 'campaign_visit', 'form_feature', 'tab_data', 'Descripció:', 'Descripció'),
    ('enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Final previst:', 'Final planificat'),
    ('expl_id', 'campaign_visit', 'form_feature', 'tab_data', 'Id explotació:', 'Id expl'),
    ('name', 'campaign_visit', 'form_feature', 'tab_data', 'Nom:', 'Nom'),
    ('organization_id', 'campaign_visit', 'form_feature', 'tab_data', 'Organització:', 'Organització'),
    ('real_enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Final real:', 'Final real'),
    ('real_startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Inici real:', 'Començament real'),
    ('sector_id', 'campaign_visit', 'form_feature', 'tab_data', 'Id del sector:', 'Id. del sector'),
    ('startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Inici previst:', 'Inici previst'),
    ('status', 'campaign_visit', 'form_feature', 'tab_data', 'Estat:', 'Estat'),
    ('visitclass_id', 'campaign_visit', 'form_feature', 'tab_data', 'Classe de visita:', 'Classe de visita'),
    ('campaign', 'generic', 'check_project_cm', 'tab_data', 'Campanya:', 'Campanya'),
    ('lot', 'generic', 'check_project_cm', 'tab_data', 'Lot:', 'Lot'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', NULL, NULL),
    ('txt_infolog', 'generic', 'check_project_cm', 'tab_log', NULL, NULL),
    ('active', 'generic', 'team_create', 'tab_none', 'Actiu:', 'Active:'),
    ('code', 'generic', 'team_create', 'tab_none', 'Codi:', 'Code:'),
    ('descript', 'generic', 'team_create', 'tab_none', 'Descripció:', 'Description:'),
    ('name', 'generic', 'team_create', 'tab_none', 'Nom:', 'Name:'),
    ('active', 'lot', 'form_feature', 'tab_data', 'Actiu:', 'Actius'),
    ('campaign_id', 'lot', 'form_feature', 'tab_data', 'Identificador de campanya:', 'Identificador de campanya'),
    ('descript', 'lot', 'form_feature', 'tab_data', 'Descripció:', 'Descripció'),
    ('enddate', 'lot', 'form_feature', 'tab_data', 'Final previst:', 'Final planificat'),
    ('expl_id', 'lot', 'form_feature', 'tab_data', 'Id explotació:', 'Id expl'),
    ('lot_id', 'lot', 'form_feature', 'tab_data', 'Identificador del lot:', 'Id'),
    ('name', 'lot', 'form_feature', 'tab_data', 'Nom:', 'Nom'),
    ('organization_assigned', 'lot', 'form_feature', 'tab_data', 'Organització assignada:', 'Organització assignada'),
    ('real_enddate', 'lot', 'form_feature', 'tab_data', 'Final real:', 'Final real'),
    ('real_startdate', 'lot', 'form_feature', 'tab_data', 'Inici real:', 'Començament real'),
    ('sector_id', 'lot', 'form_feature', 'tab_data', 'Id del sector:', 'Id. del sector'),
    ('startdate', 'lot', 'form_feature', 'tab_data', 'Inici previst:', 'Inici previst'),
    ('status', 'lot', 'form_feature', 'tab_data', 'Estat:', 'Estat'),
    ('team_id', 'lot', 'form_feature', 'tab_data', 'Equip:', 'Equip'),
    ('workorder_id', 'lot', 'form_feature', 'tab_data', 'Id de la comanda de treball:', 'Id de la comanda de treball'),
    ('address', 'workorder', 'form_feature', 'tab_data', 'Adreça:', 'Adreça'),
    ('cost', 'workorder', 'form_feature', 'tab_data', 'Cost:', 'Cost'),
    ('exercise', 'workorder', 'form_feature', 'tab_data', 'Exercici:', 'Exercici'),
    ('observ', 'workorder', 'form_feature', 'tab_data', 'Observació:', 'Observeu'),
    ('serie', 'workorder', 'form_feature', 'tab_data', 'Sèrie:', 'Sèrie'),
    ('startdate', 'workorder', 'form_feature', 'tab_data', 'Data d''inici:', 'Data d''inici'),
    ('workorder_class', 'workorder', 'form_feature', 'tab_data', 'Classe d''ordre laboral:', 'Classe d''ordre laboral'),
    ('workorder_id', 'workorder', 'form_feature', 'tab_data', 'Id de la comanda de treball:', 'Id de la comanda de treball'),
    ('workorder_name', 'workorder', 'form_feature', 'tab_data', 'Nom de l''ordre de treball:', 'Nom de l''ordre de treball'),
    ('workorder_type', 'workorder', 'form_feature', 'tab_data', 'Tipus d''ordre de treball:', 'Tipus d''ordre de treball')
) AS v(columnname, formname, formtype, tabname, label, tooltip)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_form_tabs AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('selector_campaign', 'tab_campaign', 'Campanya', 'Campanya'),
    ('selector_campaign', 'tab_lot', 'Lot', 'Lot')
) AS v(formname, tabname, label, tooltip)
WHERE t.formname = v.formname AND t.tabname = v.tabname;

UPDATE config_param_system AS t
SET label = v.label, descript = v.descript
FROM (
    VALUES
    ('admin_campaign_type', NULL, 'Variable per especificar quin tipus de campanya volem veure en crear-la'),
    ('basic_selector_tab_campaign', 'Variables selectores', 'Variable per configurar totes les opcions relacionades amb la cerca de la pestanya específica'),
    ('basic_selector_tab_lot', 'Variables selectores', 'Variable per configurar totes les opcions relacionades amb la cerca de la pestanya específica')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

UPDATE sys_typevalue AS t
SET idval = v.idval, descript = v.descript
FROM (
    VALUES
    ('1', 'campaign_feature_status', 'PLANIFICAT', NULL),
    ('2', 'campaign_feature_status', 'NO VISITAT', NULL),
    ('3', 'campaign_feature_status', 'VISITAT', NULL),
    ('4', 'campaign_feature_status', 'TORNAR A VISITAR', NULL),
    ('5', 'campaign_feature_status', 'ACCEPTAT', NULL),
    ('6', 'campaign_feature_status', 'CANCELAT', NULL),
    ('1', 'campaign_status', 'PLANIFICACIÓ', NULL),
    ('10', 'campaign_status', 'CANCELAT', NULL),
    ('2', 'campaign_status', 'PLANIFICAT', NULL),
    ('3', 'campaign_status', 'ASIGNAT', NULL),
    ('4', 'campaign_status', 'EN MARCHA', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('6', 'campaign_status', 'EXECUTAT', NULL),
    ('7', 'campaign_status', 'REBUTAT', NULL),
    ('8', 'campaign_status', 'LLES PER A ACCEPTAR', NULL),
    ('9', 'campaign_status', 'ACCEPTAT', NULL),
    ('1', 'campaign_type', 'REVISIÓ', NULL),
    ('2', 'campaign_type', 'VISITA', NULL),
    ('3', 'campaign_type', 'INVENTARI', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'botons_lyt', NULL),
    ('1', 'lot_feature_status', 'PLANIFICAT', NULL),
    ('2', 'lot_feature_status', 'NO VISITAT', NULL),
    ('3', 'lot_feature_status', 'VISITAT', NULL),
    ('4', 'lot_feature_status', 'TORNAR A VISITAR', NULL),
    ('5', 'lot_feature_status', 'ACCEPTAT', NULL),
    ('6', 'lot_feature_status', 'CANCELAT', NULL),
    ('1', 'lot_status', 'PLANIFICACIÓ', NULL),
    ('10', 'lot_status', 'CANCELAT', NULL),
    ('2', 'lot_status', 'PLANIFICAT', NULL),
    ('3', 'lot_status', 'ASIGNAT', NULL),
    ('4', 'lot_status', 'EN MARCHA', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL),
    ('6', 'lot_status', 'EXECUTAT', NULL),
    ('7', 'lot_status', 'REBUTAT', NULL),
    ('8', 'lot_status', 'LLES PER A ACCEPTAR', NULL),
    ('9', 'lot_status', 'ACCEPTAT', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

UPDATE config_form_fields AS t
SET widgetcontrols = v.text::json
FROM (
	VALUES
	('active', 'campaign_inventory', 'form_feature', 'tab_data', '{"vdefault_value": "És cert"}'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', '{"vdefault_value": "És cert"}'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', '{"vdefault_value": "És cert"}'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', '{"vdefault_value": "Aquesta funció pretén passar el control de qualitat d''una campanya, podent escollir específicament un lot concret.<br><br>S''analitzen diferents aspectes, el més destacat és que està configurat perquè les dades estiguin operatives al llarg d''una campanya perquè funcioni el model hidràulic."}'),
    ('active', 'lot', 'form_feature', 'tab_data', '{"vdefault_value": "És cert"}')
) AS v(columnname, formname, formtype, tabname, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';
UPDATE sys_table AS t
SET alias = v.alias, descript = v.descript
FROM (
    VALUES
    ('%_camp_arc', NULL, 've_ws44_1709_camp_arc'),
    ('%_camp_connec', NULL, 've_ws44_1709_camp_connec'),
    ('%_camp_link', NULL, 've_ws44_1709_camp_link'),
    ('%_camp_node', NULL, 've_ws44_1709_camp_node'),
    ('%_lot_arc', NULL, 've_ws44_1709_lot_arc'),
    ('%_lot_connec', NULL, 've_ws44_1709_lot_connec'),
    ('%_lot_link', NULL, 've_ws44_1709_lot_link'),
    ('%_lot_node', NULL, 've_ws44_1709_lot_node')
) AS v(id, alias, descript)
WHERE t.id = v.id;

UPDATE config_form_tableview AS t
SET alias = v.alias
FROM (
    VALUES
    ('om_campaign_lot_x_arc', 'action', 'Acció'),
    ('om_campaign_lot_x_connec', 'action', 'Acció'),
    ('om_campaign_lot_x_link', 'action', 'Acció'),
    ('om_campaign_lot_x_node', 'action', 'Acció'),
    ('v_ui_campaign', 'active', 'Actius'),
    ('v_ui_lot', 'active', 'Actius'),
    ('cat_organization', 'active', 'Actius'),
    ('cat_team', 'active', 'Actius'),
    ('cat_user', 'active', 'Actius'),
    ('om_campaign_x_arc', 'admin_observ', 'Observació administrativa'),
    ('om_campaign_x_connec', 'admin_observ', 'Observació administrativa'),
    ('om_campaign_x_link', 'admin_observ', 'Observació administrativa'),
    ('om_campaign_x_node', 'admin_observ', 'Observació administrativa'),
    ('om_campaign_x_arc', 'arccat_id', 'Arccat id'),
    ('om_campaign_x_arc', 'arc_id', 'Id de l''arc'),
    ('om_campaign_lot_x_arc', 'arc_id', 'Id de l''arc'),
    ('om_campaign_x_arc', 'arc_type', 'Tipus d''arc'),
    ('v_ui_campaign', 'campaign_class', 'Classe de campanya'),
    ('v_ui_campaign', 'campaign_id', 'Identificador de campanya'),
    ('om_campaign_x_arc', 'campaign_id', 'Identificador de campanya'),
    ('om_campaign_x_connec', 'campaign_id', 'Identificador de campanya'),
    ('om_campaign_x_link', 'campaign_id', 'Identificador de campanya'),
    ('om_campaign_x_node', 'campaign_id', 'Identificador de campanya'),
    ('v_ui_lot', 'campaign_name', 'Nom de la campanya'),
    ('v_ui_campaign', 'campaign_type', 'Tipus de campanya'),
    ('om_campaign_x_arc', 'code', 'Codi'),
    ('om_campaign_x_connec', 'code', 'Codi'),
    ('om_campaign_x_link', 'code', 'Codi'),
    ('om_campaign_x_node', 'code', 'Codi'),
    ('om_campaign_lot_x_arc', 'code', 'Codi'),
    ('om_campaign_lot_x_connec', 'code', 'Codi'),
    ('om_campaign_lot_x_link', 'code', 'Codi'),
    ('om_campaign_lot_x_node', 'code', 'Codi'),
    ('cat_organization', 'code', 'Codi'),
    ('cat_team', 'code', 'Codi'),
    ('cat_user', 'code', 'Codi'),
    ('om_campaign_x_connec', 'connec_id', 'ID de connexió'),
    ('om_campaign_lot_x_connec', 'connec_id', 'ID de connexió'),
    ('om_campaign_x_connec', 'connectcat_id', 'ID de Connectcat'),
    ('v_ui_campaign', 'descript', 'Descripció'),
    ('v_ui_lot', 'descript', 'Descripció'),
    ('cat_organization', 'descript', 'Descripció'),
    ('cat_team', 'descript', 'Descripció'),
    ('v_ui_campaign', 'enddate', 'Data de finalització'),
    ('v_ui_lot', 'enddate', 'Data de finalització'),
    ('v_ui_lot', 'expl_id', 'ID expl'),
    ('om_campaign_x_arc', 'id', 'Id'),
    ('om_campaign_x_connec', 'id', 'Id'),
    ('om_campaign_x_link', 'id', 'Id'),
    ('om_campaign_x_node', 'id', 'Id'),
    ('om_campaign_lot_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_connec', 'id', 'Id'),
    ('om_campaign_lot_x_link', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'id', 'Id'),
    ('om_campaign_x_link', 'linkcat_id', 'ID de Linkcat'),
    ('om_campaign_x_link', 'link_id', 'ID de l''enllaç'),
    ('om_campaign_lot_x_link', 'link_id', 'ID de l''enllaç'),
    ('v_ui_lot', 'lot_id', 'Id. del lot'),
    ('om_campaign_lot_x_arc', 'lot_id', 'Id. del lot'),
    ('om_campaign_lot_x_connec', 'lot_id', 'Id. del lot'),
    ('om_campaign_lot_x_link', 'lot_id', 'Id. del lot'),
    ('om_campaign_lot_x_node', 'lot_id', 'Id. del lot'),
    ('v_ui_campaign', 'name', 'Nom'),
    ('v_ui_lot', 'name', 'Nom'),
    ('om_campaign_x_arc', 'node_1', 'Node 1'),
    ('om_campaign_lot_x_arc', 'node_1', 'Node 1'),
    ('om_campaign_x_arc', 'node_2', 'Node 2'),
    ('om_campaign_lot_x_arc', 'node_2', 'Node 2'),
    ('om_campaign_x_node', 'nodecat_id', 'Nodecat id'),
    ('om_campaign_x_node', 'node_id', 'Id. del node'),
    ('om_campaign_lot_x_node', 'node_id', 'Id. del node'),
    ('om_campaign_x_node', 'node_type', 'Tipus de node'),
    ('v_ui_campaign', 'organization_id', 'ID de l''organització'),
    ('cat_organization', 'organization_id', 'ID de l''organització'),
    ('cat_organization', 'orgname', 'Org.nom'),
    ('cat_team', 'orgname', 'Org.nom'),
    ('om_campaign_x_arc', 'org_observ', 'Org observ'),
    ('om_campaign_x_connec', 'org_observ', 'Org observ'),
    ('om_campaign_x_link', 'org_observ', 'Org observ'),
    ('om_campaign_x_node', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_arc', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_connec', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_link', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_node', 'org_observ', 'Org observ'),
    ('om_campaign_x_arc', 'qindex1', 'Qíndex 1'),
    ('om_campaign_x_connec', 'qindex1', 'Qíndex 1'),
    ('om_campaign_x_link', 'qindex1', 'Qíndex 1'),
    ('om_campaign_x_node', 'qindex1', 'Qíndex 1'),
    ('om_campaign_lot_x_arc', 'qindex1', 'Qíndex 1'),
    ('om_campaign_lot_x_connec', 'qindex1', 'Qíndex 1'),
    ('om_campaign_lot_x_link', 'qindex1', 'Qíndex 1'),
    ('om_campaign_lot_x_node', 'qindex1', 'Qíndex 1'),
    ('om_campaign_x_arc', 'qindex2', 'Qíndex2'),
    ('om_campaign_x_connec', 'qindex2', 'Qíndex2'),
    ('om_campaign_x_link', 'qindex2', 'Qíndex2'),
    ('om_campaign_x_node', 'qindex2', 'Qíndex2'),
    ('om_campaign_lot_x_arc', 'qindex2', 'Qíndex2'),
    ('om_campaign_lot_x_connec', 'qindex2', 'Qíndex2'),
    ('om_campaign_lot_x_link', 'qindex2', 'Qíndex2'),
    ('om_campaign_lot_x_node', 'qindex2', 'Qíndex2'),
    ('v_ui_campaign', 'real_enddate', 'Data de final real'),
    ('v_ui_lot', 'real_enddate', 'Data de final real'),
    ('v_ui_campaign', 'real_startdate', 'Data d''inici real'),
    ('v_ui_lot', 'real_startdate', 'Data d''inici real'),
    ('cat_team', 'role_id', 'Identificador de rol'),
    ('v_ui_lot', 'sector_id', 'Id. del sector'),
    ('v_ui_campaign', 'startdate', 'Data d''inici'),
    ('v_ui_lot', 'startdate', 'Data d''inici'),
    ('v_ui_campaign', 'status', 'Estat'),
    ('om_campaign_x_arc', 'status', 'Estat'),
    ('om_campaign_x_connec', 'status', 'Estat'),
    ('om_campaign_x_link', 'status', 'Estat'),
    ('om_campaign_x_node', 'status', 'Estat'),
    ('v_ui_lot', 'status', 'Estat'),
    ('om_campaign_lot_x_arc', 'status', 'Estat'),
    ('om_campaign_lot_x_connec', 'status', 'Estat'),
    ('om_campaign_lot_x_link', 'status', 'Estat'),
    ('om_campaign_lot_x_node', 'status', 'Estat'),
    ('cat_team', 'team_id', 'ID de l''equip'),
    ('v_ui_lot', 'team_name', 'Nom de l''equip'),
    ('cat_team', 'teamname', 'Nom de l''equip'),
    ('cat_user', 'teamname', 'Nom de l''equip'),
    ('om_campaign_lot_x_arc', 'team_observ', 'Observació d''equip'),
    ('om_campaign_lot_x_connec', 'team_observ', 'Observació d''equip'),
    ('om_campaign_lot_x_link', 'team_observ', 'Observació d''equip'),
    ('om_campaign_lot_x_node', 'team_observ', 'Observació d''equip'),
    ('v_ui_campaign', 'the_geom', 'El geom'),
    ('om_campaign_x_arc', 'the_geom', 'El geom'),
    ('om_campaign_x_connec', 'the_geom', 'El geom'),
    ('om_campaign_x_link', 'the_geom', 'El geom'),
    ('om_campaign_x_node', 'the_geom', 'El geom'),
    ('v_ui_lot', 'the_geom', 'El geom'),
    ('om_campaign_lot_x_arc', 'update_count', 'Recompte d''actualitzacions'),
    ('om_campaign_lot_x_connec', 'update_count', 'Recompte d''actualitzacions'),
    ('om_campaign_lot_x_link', 'update_count', 'Recompte d''actualitzacions'),
    ('om_campaign_lot_x_node', 'update_count', 'Recompte d''actualitzacions'),
    ('om_campaign_lot_x_arc', 'update_log', 'Actualitza el registre'),
    ('om_campaign_lot_x_connec', 'update_log', 'Actualitza el registre'),
    ('om_campaign_lot_x_link', 'update_log', 'Actualitza el registre'),
    ('om_campaign_lot_x_node', 'update_log', 'Actualitza el registre'),
    ('cat_user', 'user_id', 'Identificador d''usuari'),
    ('cat_user', 'username', 'Nom d''usuari'),
    ('v_ui_lot', 'workorder_name', 'Nom de l''ordre de treball')
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

UPDATE sys_fprocess AS t
SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name
FROM (
    VALUES
    (100, 'valor nul a la columna %check_column% de %table_name%.', 'Les %check_column% de %table_name% tenen valors correctes.', 'Comprovar la consistència nul·la'),
    (200, 'Hi ha alguns usuaris sense equip assignat.', 'Tots els usuaris tenen un equip assignat.', 'Comproveu la coherència dels usuaris'),
    (201, 'equips sense usuaris assignats.', 'Tots els equips tenen usuaris assignats.', 'Comprovar la coherència dels equips'),
    (202, 'Hi ha alguns nodes orfes.', 'No hi ha nodes orfes.', 'Comproveu els nodes orfes'),
    (203, 'nodes duplicats amb l''estat 1.', 'No hi ha nodes duplicats amb l''estat 1', 'Comproveu els nodes duplicats')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

