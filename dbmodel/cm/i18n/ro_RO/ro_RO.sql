/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('workorder_id', 'workorder', 'form_feature', 'tab_data', 'Workorder Id:', 'Id comandă de lucru'),
    ('active', 'generic', 'team_create', 'tab_none', 'Activ:', 'Active:'),
    ('inventoryclass_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Clasa de inventar:', 'Clasa de inventar'),
    ('descript', 'lot', 'form_feature', 'tab_data', 'Descriere:', 'Descriere'),
    ('organization_assigned', 'lot', 'form_feature', 'tab_data', 'Organizație atribuită:', 'Organizație atribuită'),
    ('expl_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('organization_id', 'campaign_visit', 'form_feature', 'tab_data', 'Organizație:', 'Organizație'),
    ('serie', 'workorder', 'form_feature', 'tab_data', 'Serie:', 'Serie'),
    ('workorder_id', 'lot', 'form_feature', 'tab_data', 'Comanda de lucru id:', 'ID-ul comenzii de lucru'),
    ('descript', 'campaign_review', 'form_feature', 'tab_data', 'Descriere:', 'Descriere'),
    ('status', 'campaign_inventory', 'form_feature', 'tab_data', 'Statutul:', 'Statut'),
    ('startdate', 'lot', 'form_feature', 'tab_data', 'Start planificat:', 'Start planificat'),
    ('cost', 'workorder', 'form_feature', 'tab_data', 'Cost:', 'Costuri'),
    ('status', 'lot', 'form_feature', 'tab_data', 'Statutul:', 'Statut'),
    ('name', 'generic', 'team_create', 'tab_none', 'Nume:', 'Name:'),
    ('expl_id', 'campaign_review', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('lot_id', 'lot', 'form_feature', 'tab_data', 'Lot ID:', 'Id'),
    ('descript', 'campaign_inventory', 'form_feature', 'tab_data', 'Descriere:', 'Descriere'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', 'Activ:', 'Activ'),
    ('txt_infolog', 'generic', 'check_project_cm', 'tab_log', NULL, NULL),
    ('active', 'campaign_inventory', 'form_feature', 'tab_data', 'Activ:', 'Activ'),
    ('real_startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Început real:', 'Start real'),
    ('real_enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Sfârșit real:', 'Sfârșit real'),
    ('campaign_id', 'lot', 'form_feature', 'tab_data', 'Identitatea campaniei:', 'Id-ul campaniei'),
    ('real_enddate', 'campaign_review', 'form_feature', 'tab_data', 'Sfârșit real:', 'Sfârșit real'),
    ('enddate', 'campaign_review', 'form_feature', 'tab_data', 'Sfârșit planificat:', 'Sfârșit planificat'),
    ('address', 'workorder', 'form_feature', 'tab_data', 'Adresa:', 'Adresă'),
    ('campaign_id', 'campaign_review', 'form_feature', 'tab_data', 'Campania Id:', 'Id'),
    ('expl_id', 'campaign_visit', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('exercise', 'workorder', 'form_feature', 'tab_data', 'Exercițiu:', 'Exercițiu'),
    ('sector_id', 'lot', 'form_feature', 'tab_data', 'Sector Id:', 'Id sector'),
    ('name', 'campaign_visit', 'form_feature', 'tab_data', 'Nume:', 'Nume și prenume'),
    ('enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Sfârșit planificat:', 'Sfârșit planificat'),
    ('expl_id', 'lot', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Start planificat:', 'Start planificat'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', NULL, NULL),
    ('campaign_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Campania Id:', 'Id'),
    ('active', 'lot', 'form_feature', 'tab_data', 'Activ:', 'Activ'),
    ('campaign_id', 'campaign_visit', 'form_feature', 'tab_data', 'Lot Id:', 'Id'),
    ('visitclass_id', 'campaign_visit', 'form_feature', 'tab_data', 'Clasa de vizitare:', 'Clasa de vizitare'),
    ('lot', 'generic', 'check_project_cm', 'tab_data', 'Lot:', 'Lot'),
    ('real_enddate', 'lot', 'form_feature', 'tab_data', 'Sfârșit real:', 'Sfârșit real'),
    ('observ', 'workorder', 'form_feature', 'tab_data', 'Observați:', 'Observați'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', 'Activ:', 'Activ'),
    ('status', 'campaign_visit', 'form_feature', 'tab_data', 'Statutul:', 'Statut'),
    ('startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Start planificat:', 'Start planificat'),
    ('descript', 'generic', 'team_create', 'tab_none', 'Descriere:', 'Description:'),
    ('name', 'campaign_inventory', 'form_feature', 'tab_data', 'Nume:', 'Nume și prenume'),
    ('enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Sfârșit planificat:', 'Sfârșit planificat'),
    ('workorder_name', 'workorder', 'form_feature', 'tab_data', 'Numele comenzii de lucru:', 'Numele comenzii de lucru'),
    ('startdate', 'campaign_review', 'form_feature', 'tab_data', 'Start planificat:', 'Start planificat'),
    ('campaign', 'generic', 'check_project_cm', 'tab_data', 'Campanie:', 'Campanie'),
    ('sector_id', 'campaign_visit', 'form_feature', 'tab_data', 'Sector Id:', 'Id sector'),
    ('real_startdate', 'campaign_review', 'form_feature', 'tab_data', 'Început real:', 'Start real'),
    ('sector_id', 'campaign_review', 'form_feature', 'tab_data', 'Sector Id:', 'Id sector'),
    ('name', 'lot', 'form_feature', 'tab_data', 'Nume:', 'Nume și prenume'),
    ('real_startdate', 'lot', 'form_feature', 'tab_data', 'Început real:', 'Start real'),
    ('sector_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Sector Id:', 'Id sector'),
    ('startdate', 'workorder', 'form_feature', 'tab_data', 'Data de începere:', 'Data de începere'),
    ('code', 'generic', 'team_create', 'tab_none', 'Cod:', 'Code:'),
    ('name', 'campaign_review', 'form_feature', 'tab_data', 'Nume:', 'Nume și prenume'),
    ('enddate', 'lot', 'form_feature', 'tab_data', 'Sfârșit planificat:', 'Sfârșit planificat'),
    ('reviewclass_id', 'campaign_review', 'form_feature', 'tab_data', 'Clasa de revizuire:', 'Clasa de revizuire'),
    ('descript', 'campaign_visit', 'form_feature', 'tab_data', 'Descriere:', 'Descriere'),
    ('real_enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Sfârșit real:', 'Sfârșit real'),
    ('organization_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Organizație:', 'Organizație'),
    ('workorder_class', 'workorder', 'form_feature', 'tab_data', 'Clasa comenzii de lucru:', 'Clasa comenzii de lucru'),
    ('status', 'campaign_review', 'form_feature', 'tab_data', 'Statutul:', 'Statut'),
    ('team_id', 'lot', 'form_feature', 'tab_data', 'Echipa:', 'Echipa'),
    ('organization_id', 'campaign_review', 'form_feature', 'tab_data', 'Organizație:', 'Organizație'),
    ('real_startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Început real:', 'Start real'),
    ('workorder_type', 'workorder', 'form_feature', 'tab_data', 'Tipul comenzii de lucru:', 'Tipul comenzii de lucru')
) AS v(columnname, formname, formtype, tabname, label, tooltip)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_form_tabs AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('selector_campaign', 'tab_campaign', 'Campanie', 'Campanie'),
    ('selector_campaign', 'tab_lot', 'Lot', 'Lot')
) AS v(formname, tabname, label, tooltip)
WHERE t.formname = v.formname AND t.tabname = v.tabname;

UPDATE config_param_system AS t
SET label = v.label, descript = v.descript
FROM (
    VALUES
    ('basic_selector_tab_lot', 'Selector variabil', 'Variabilă pentru configurarea tuturor opțiunilor legate de căutarea pentru fila specifică'),
    ('admin_campaign_type', NULL, 'Variabilă pentru a specifica ce tip de campanie dorim să vedem atunci când creăm'),
    ('basic_selector_tab_campaign', 'Selector variabil', 'Variabilă pentru configurarea tuturor opțiunilor legate de căutarea pentru fila specifică')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

UPDATE sys_typevalue AS t
SET idval = v.idval, descript = v.descript
FROM (
    VALUES
    ('8', 'campaign_status', 'READY-TO-ACCEPT', NULL),
    ('6', 'lot_feature_status', 'ANULAT', NULL),
    ('6', 'campaign_status', 'EXECUTED', NULL),
    ('3', 'campaign_feature_status', 'VISITED', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('4', 'lot_status', 'ÎN CURS DE DESFĂȘURARE', NULL),
    ('6', 'lot_status', 'EXECUTAT', NULL),
    ('2', 'campaign_type', 'VIZITA', NULL),
    ('7', 'lot_status', 'REJECTAT', NULL),
    ('9', 'lot_status', 'ACCEPTAT', NULL),
    ('9', 'campaign_status', 'ACCEPTAT', NULL),
    ('4', 'lot_feature_status', 'VIZITAȚI DIN NOU', NULL),
    ('4', 'campaign_feature_status', 'VIZITAȚI DIN NOU', NULL),
    ('2', 'campaign_feature_status', 'NEVIZITAT', NULL),
    ('4', 'campaign_status', 'ÎN CURS DE DESFĂȘURARE', NULL),
    ('2', 'campaign_status', 'PLANIFICAT', NULL),
    ('5', 'lot_feature_status', 'ACCEPTAT', NULL),
    ('1', 'lot_feature_status', 'PLANIFICAT', NULL),
    ('8', 'lot_status', 'GATA DE ACCEPTARE', NULL),
    ('10', 'lot_status', 'ANULAT', NULL),
    ('6', 'campaign_feature_status', 'ANULAT', NULL),
    ('3', 'campaign_status', 'ATRIBUIT', NULL),
    ('3', 'lot_status', 'ATRIBUIT', NULL),
    ('2', 'lot_feature_status', 'NEVIZITAT', NULL),
    ('2', 'lot_status', 'PLANIFICAT', NULL),
    ('1', 'campaign_type', 'RECENZIE', NULL),
    ('7', 'campaign_status', 'REJECTAT', NULL),
    ('5', 'campaign_feature_status', 'ACCEPTAT', NULL),
    ('1', 'campaign_feature_status', 'PLANIFICAT', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'lyt_buttons', NULL),
    ('1', 'lot_status', 'PLANIFICARE', NULL),
    ('3', 'lot_feature_status', 'VĂZUT', NULL),
    ('10', 'campaign_status', 'ANULAT', NULL),
    ('3', 'campaign_type', 'INVENTAR', NULL),
    ('1', 'campaign_status', 'PLANIFICARE', NULL),
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
    ('om_campaign_lot_x_link', 'lot_id', 'Id lot'),
    ('om_campaign_lot_x_link', 'action', 'Acțiune'),
    ('v_ui_campaign', 'name', 'Nume și prenume'),
    ('v_ui_campaign', 'status', 'Statut'),
    ('v_ui_campaign', 'real_startdate', 'Data reală de începere'),
    ('om_campaign_lot_x_link', 'qindex2', 'Qindex2'),
    ('om_campaign_lot_x_link', 'update_count', 'Actualizarea numărului'),
    ('om_campaign_lot_x_arc', 'node_2', 'Nodul 2'),
    ('cat_team', 'team_id', 'Id echipă'),
    ('om_campaign_x_node', 'qindex2', 'Qindex2'),
    ('v_ui_campaign', 'startdate', 'Data de începere'),
    ('om_campaign_lot_x_arc', 'update_count', 'Actualizarea numărului'),
    ('om_campaign_x_connec', 'the_geom', 'Geom'),
    ('v_ui_campaign', 'organization_id', 'Id organizație'),
    ('om_campaign_lot_x_connec', 'update_log', 'Jurnal de actualizare'),
    ('om_campaign_x_link', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_connec', 'qindex2', 'Qindex2'),
    ('om_campaign_x_connec', 'code', 'Cod'),
    ('om_campaign_x_arc', 'campaign_id', 'Id-ul campaniei'),
    ('v_ui_lot', 'real_enddate', 'Data finală reală'),
    ('v_ui_lot', 'lot_id', 'Id lot'),
    ('v_ui_lot', 'descript', 'Descript'),
    ('v_ui_lot', 'workorder_name', 'Numele comenzii de lucru'),
    ('v_ui_lot', 'startdate', 'Data de începere'),
    ('v_ui_lot', 'enddate', 'Data de încheiere'),
    ('om_campaign_lot_x_connec', 'lot_id', 'Id lot'),
    ('om_campaign_lot_x_arc', 'arc_id', 'Arc id'),
    ('cat_user', 'username', 'Numele utilizatorului'),
    ('om_campaign_x_link', 'status', 'Statut'),
    ('om_campaign_lot_x_link', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_arc', 'action', 'Acțiune'),
    ('om_campaign_x_arc', 'arccat_id', 'Arccat id'),
    ('om_campaign_x_connec', 'id', 'Id'),
    ('cat_team', 'code', 'Cod'),
    ('cat_team', 'role_id', 'Id rol'),
    ('om_campaign_lot_x_node', 'node_id', 'Id nod'),
    ('om_campaign_x_connec', 'connectcat_id', 'Connectcat id'),
    ('om_campaign_x_arc', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_connec', 'org_observ', 'Org observ'),
    ('om_campaign_x_link', 'linkcat_id', 'Id Linkcat'),
    ('om_campaign_x_node', 'status', 'Statut'),
    ('om_campaign_x_link', 'org_observ', 'Org observ'),
    ('v_ui_campaign', 'enddate', 'Data de încheiere'),
    ('om_campaign_x_connec', 'campaign_id', 'Id-ul campaniei'),
    ('om_campaign_lot_x_arc', 'node_1', 'Nod 1'),
    ('om_campaign_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_link', 'team_observ', 'Echipa observ'),
    ('cat_user', 'active', 'Activ'),
    ('om_campaign_lot_x_node', 'action', 'Acțiune'),
    ('om_campaign_x_node', 'the_geom', 'Geom'),
    ('cat_team', 'descript', 'Descript'),
    ('om_campaign_lot_x_arc', 'lot_id', 'Id lot'),
    ('v_ui_campaign', 'the_geom', 'Geom'),
    ('om_campaign_lot_x_node', 'code', 'Cod'),
    ('om_campaign_x_arc', 'org_observ', 'Org observ'),
    ('om_campaign_x_link', 'code', 'Cod'),
    ('v_ui_lot', 'active', 'Active'),
    ('v_ui_lot', 'expl_id', 'Expl id'),
    ('om_campaign_x_arc', 'node_1', 'Nod 1'),
    ('om_campaign_lot_x_connec', 'id', 'Id'),
    ('om_campaign_x_node', 'org_observ', 'Org observ'),
    ('v_ui_lot', 'real_startdate', 'Data reală de începere'),
    ('om_campaign_lot_x_connec', 'action', 'Acțiune'),
    ('om_campaign_x_connec', 'status', 'Statut'),
    ('v_ui_lot', 'sector_id', 'Id sector'),
    ('v_ui_lot', 'team_name', 'Numele echipei'),
    ('v_ui_campaign', 'active', 'Activ'),
    ('om_campaign_x_arc', 'node_2', 'Nodul 2'),
    ('om_campaign_x_link', 'campaign_id', 'Id-ul campaniei'),
    ('om_campaign_x_connec', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_connec', 'connec_id', 'Conectare id'),
    ('cat_user', 'user_id', 'ID utilizator'),
    ('om_campaign_x_arc', 'status', 'Statut'),
    ('om_campaign_lot_x_link', 'code', 'Cod'),
    ('om_campaign_x_node', 'node_id', 'Id nod'),
    ('cat_organization', 'active', 'Activ'),
    ('om_campaign_x_node', 'code', 'Cod'),
    ('cat_organization', 'descript', 'Descript'),
    ('v_ui_campaign', 'campaign_class', 'Clasa de campanie'),
    ('v_ui_campaign', 'real_enddate', 'Data finală reală'),
    ('om_campaign_lot_x_link', 'id', 'Id'),
    ('om_campaign_x_arc', 'arc_type', 'Tip arc'),
    ('cat_team', 'active', 'Activ'),
    ('v_ui_campaign', 'campaign_id', 'Id-ul campaniei'),
    ('v_ui_lot', 'campaign_name', 'Numele campaniei'),
    ('om_campaign_x_node', 'admin_observ', 'Admin observ'),
    ('v_ui_lot', 'name', 'Nume și prenume'),
    ('om_campaign_lot_x_arc', 'team_observ', 'Echipa observ'),
    ('om_campaign_x_arc', 'qindex2', 'Qindex2'),
    ('cat_user', 'teamname', 'Numele echipei'),
    ('om_campaign_x_link', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'team_observ', 'Echipa observ'),
    ('om_campaign_lot_x_connec', 'qindex2', 'Qindex2'),
    ('cat_team', 'orgname', 'Nume org.'),
    ('cat_user', 'code', 'Cod'),
    ('om_campaign_lot_x_arc', 'qindex2', 'Qindex2'),
    ('v_ui_lot', 'the_geom', 'Geom'),
    ('om_campaign_x_node', 'campaign_id', 'Id-ul campaniei'),
    ('v_ui_lot', 'status', 'Statut'),
    ('cat_organization', 'code', 'Cod'),
    ('om_campaign_lot_x_connec', 'update_count', 'Actualizarea numărului'),
    ('cat_organization', 'orgname', 'Nume org.'),
    ('om_campaign_lot_x_node', 'update_log', 'Jurnal de actualizare'),
    ('om_campaign_lot_x_arc', 'code', 'Cod'),
    ('om_campaign_lot_x_link', 'update_log', 'Jurnal de actualizare'),
    ('om_campaign_lot_x_arc', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_arc', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_node', 'id', 'Id'),
    ('om_campaign_x_link', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_node', 'qindex2', 'Qindex2'),
    ('om_campaign_x_arc', 'arc_id', 'Arc id'),
    ('om_campaign_lot_x_connec', 'connec_id', 'Conectare id'),
    ('om_campaign_lot_x_connec', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_link', 'link_id', 'Link id'),
    ('om_campaign_lot_x_node', 'lot_id', 'Id lot'),
    ('om_campaign_x_node', 'nodecat_id', 'Nodecat id'),
    ('om_campaign_x_node', 'qindex1', 'Qindex1'),
    ('om_campaign_x_arc', 'the_geom', 'Geom'),
    ('om_campaign_lot_x_arc', 'update_log', 'Jurnal de actualizare'),
    ('om_campaign_x_connec', 'qindex1', 'Qindex1'),
    ('om_campaign_x_link', 'the_geom', 'Geom'),
    ('om_campaign_x_node', 'node_type', 'Tipul nodului'),
    ('om_campaign_lot_x_connec', 'status', 'Statut'),
    ('om_campaign_lot_x_arc', 'status', 'Statut'),
    ('om_campaign_lot_x_connec', 'code', 'Cod'),
    ('v_ui_campaign', 'descript', 'Descript'),
    ('om_campaign_x_arc', 'code', 'Cod'),
    ('om_campaign_lot_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'update_count', 'Actualizarea numărului'),
    ('cat_team', 'teamname', 'Numele echipei'),
    ('om_campaign_lot_x_link', 'status', 'Statut'),
    ('om_campaign_x_node', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'qindex1', 'Qindex1'),
    ('om_campaign_x_arc', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_node', 'status', 'Statut'),
    ('om_campaign_lot_x_connec', 'team_observ', 'Echipa observ'),
    ('cat_organization', 'organization_id', 'Id organizație'),
    ('v_ui_campaign', 'campaign_type', 'Tipul campaniei')
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

UPDATE sys_fprocess AS t
SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name
FROM (
    VALUES
    (203, 'noduri dublate cu starea 1.', 'Nu există noduri duplicate cu starea 1', 'Verificarea nodurilor duplicate'),
    (200, 'Există unii utilizatori cărora nu li s-a atribuit nicio echipă.', 'Toți utilizatorii au atribuită o echipă.', 'Verificarea consistenței utilizatorilor'),
    (202, 'Există câteva noduri orfane', 'Nu există noduri orfane.', 'Verificarea nodurilor orfane'),
    (100, 'valoare nulă pe coloana %check_column% din %table_name%', '%check_column% de pe %table_name% au valori corecte.', 'Verificarea consistenței nulităților'),
    (201, 'echipe fără utilizatori atribuiți.', 'Toate echipele au utilizatori atribuiți.', 'Verificarea consistenței echipelor')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

