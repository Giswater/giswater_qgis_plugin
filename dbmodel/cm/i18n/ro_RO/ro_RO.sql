/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('active', 'campaign_inventory', 'form_feature', 'tab_data', 'Activ:', 'Activ'),
    ('campaign_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Campania Id:', 'Id'),
    ('descript', 'campaign_inventory', 'form_feature', 'tab_data', 'Descriere:', 'Descriere'),
    ('enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Sfârșit planificat:', 'Sfârșit planificat'),
    ('expl_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('inventoryclass_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Clasa de inventar:', 'Clasa de inventar'),
    ('name', 'campaign_inventory', 'form_feature', 'tab_data', 'Nume:', 'Nume și prenume'),
    ('organization_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Organizație:', 'Organizație'),
    ('real_enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Sfârșit real:', 'Sfârșit real'),
    ('real_startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Început real:', 'Start real'),
    ('sector_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Sector Id:', 'Id sector'),
    ('startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Start planificat:', 'Start planificat'),
    ('status', 'campaign_inventory', 'form_feature', 'tab_data', 'Statutul:', 'Statut'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', 'Activ:', 'Activ'),
    ('campaign_id', 'campaign_review', 'form_feature', 'tab_data', 'Campania Id:', 'Id'),
    ('descript', 'campaign_review', 'form_feature', 'tab_data', 'Descriere:', 'Descriere'),
    ('enddate', 'campaign_review', 'form_feature', 'tab_data', 'Sfârșit planificat:', 'Sfârșit planificat'),
    ('expl_id', 'campaign_review', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('name', 'campaign_review', 'form_feature', 'tab_data', 'Nume:', 'Nume și prenume'),
    ('organization_id', 'campaign_review', 'form_feature', 'tab_data', 'Organizație:', 'Organizație'),
    ('real_enddate', 'campaign_review', 'form_feature', 'tab_data', 'Sfârșit real:', 'Sfârșit real'),
    ('real_startdate', 'campaign_review', 'form_feature', 'tab_data', 'Început real:', 'Start real'),
    ('reviewclass_id', 'campaign_review', 'form_feature', 'tab_data', 'Clasa de revizuire:', 'Clasa de revizuire'),
    ('sector_id', 'campaign_review', 'form_feature', 'tab_data', 'Sector Id:', 'Id sector'),
    ('startdate', 'campaign_review', 'form_feature', 'tab_data', 'Start planificat:', 'Start planificat'),
    ('status', 'campaign_review', 'form_feature', 'tab_data', 'Statutul:', 'Statut'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', 'Activ:', 'Activ'),
    ('campaign_id', 'campaign_visit', 'form_feature', 'tab_data', 'Lot Id:', 'Id'),
    ('descript', 'campaign_visit', 'form_feature', 'tab_data', 'Descriere:', 'Descriere'),
    ('enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Sfârșit planificat:', 'Sfârșit planificat'),
    ('expl_id', 'campaign_visit', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('name', 'campaign_visit', 'form_feature', 'tab_data', 'Nume:', 'Nume și prenume'),
    ('organization_id', 'campaign_visit', 'form_feature', 'tab_data', 'Organizație:', 'Organizație'),
    ('real_enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Sfârșit real:', 'Sfârșit real'),
    ('real_startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Început real:', 'Start real'),
    ('sector_id', 'campaign_visit', 'form_feature', 'tab_data', 'Sector Id:', 'Id sector'),
    ('startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Start planificat:', 'Start planificat'),
    ('status', 'campaign_visit', 'form_feature', 'tab_data', 'Statutul:', 'Statut'),
    ('visitclass_id', 'campaign_visit', 'form_feature', 'tab_data', 'Clasa de vizitare:', 'Clasa de vizitare'),
    ('campaign', 'generic', 'check_project_cm', 'tab_data', 'Campanie:', 'Campanie'),
    ('lot', 'generic', 'check_project_cm', 'tab_data', 'Lot:', 'Lot'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', NULL, NULL),
    ('txt_infolog', 'generic', 'check_project_cm', 'tab_log', NULL, NULL),
    ('active', 'generic', 'team_create', 'tab_none', 'Activ:', 'Active:'),
    ('code', 'generic', 'team_create', 'tab_none', 'Cod:', 'Code:'),
    ('descript', 'generic', 'team_create', 'tab_none', 'Descriere:', 'Description:'),
    ('name', 'generic', 'team_create', 'tab_none', 'Nume:', 'Name:'),
    ('active', 'lot', 'form_feature', 'tab_data', 'Activ:', 'Activ'),
    ('campaign_id', 'lot', 'form_feature', 'tab_data', 'Identitatea campaniei:', 'Id-ul campaniei'),
    ('descript', 'lot', 'form_feature', 'tab_data', 'Descriere:', 'Descriere'),
    ('enddate', 'lot', 'form_feature', 'tab_data', 'Sfârșit planificat:', 'Sfârșit planificat'),
    ('expl_id', 'lot', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('lot_id', 'lot', 'form_feature', 'tab_data', 'Lot ID:', 'Id'),
    ('name', 'lot', 'form_feature', 'tab_data', 'Nume:', 'Nume și prenume'),
    ('organization_assigned', 'lot', 'form_feature', 'tab_data', 'Organizație atribuită:', 'Organizație atribuită'),
    ('real_enddate', 'lot', 'form_feature', 'tab_data', 'Sfârșit real:', 'Sfârșit real'),
    ('real_startdate', 'lot', 'form_feature', 'tab_data', 'Început real:', 'Start real'),
    ('sector_id', 'lot', 'form_feature', 'tab_data', 'Sector Id:', 'Id sector'),
    ('startdate', 'lot', 'form_feature', 'tab_data', 'Start planificat:', 'Start planificat'),
    ('status', 'lot', 'form_feature', 'tab_data', 'Statutul:', 'Statut'),
    ('team_id', 'lot', 'form_feature', 'tab_data', 'Echipa:', 'Echipa'),
    ('workorder_id', 'lot', 'form_feature', 'tab_data', 'Comanda de lucru id:', 'ID-ul comenzii de lucru'),
    ('address', 'workorder', 'form_feature', 'tab_data', 'Adresa:', 'Adresă'),
    ('cost', 'workorder', 'form_feature', 'tab_data', 'Cost:', 'Costuri'),
    ('exercise', 'workorder', 'form_feature', 'tab_data', 'Exercițiu:', 'Exercițiu'),
    ('observ', 'workorder', 'form_feature', 'tab_data', 'Observați:', 'Observați'),
    ('serie', 'workorder', 'form_feature', 'tab_data', 'Serie:', 'Serie'),
    ('startdate', 'workorder', 'form_feature', 'tab_data', 'Data de începere:', 'Data de începere'),
    ('workorder_class', 'workorder', 'form_feature', 'tab_data', 'Clasa comenzii de lucru:', 'Clasa comenzii de lucru'),
    ('workorder_id', 'workorder', 'form_feature', 'tab_data', 'Workorder Id:', 'Id comandă de lucru'),
    ('workorder_name', 'workorder', 'form_feature', 'tab_data', 'Numele comenzii de lucru:', 'Numele comenzii de lucru'),
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
    ('admin_campaign_type', NULL, 'Variabilă pentru a specifica ce tip de campanie dorim să vedem atunci când creăm'),
    ('basic_selector_tab_campaign', 'Selector variabil', 'Variabilă pentru configurarea tuturor opțiunilor legate de căutarea pentru fila specifică'),
    ('basic_selector_tab_lot', 'Selector variabil', 'Variabilă pentru configurarea tuturor opțiunilor legate de căutarea pentru fila specifică')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

UPDATE sys_typevalue AS t
SET idval = v.idval, descript = v.descript
FROM (
    VALUES
    ('1', 'campaign_feature_status', 'PLANIFICAT', NULL),
    ('2', 'campaign_feature_status', 'NEVIZITAT', NULL),
    ('3', 'campaign_feature_status', 'VĂZUT', NULL),
    ('4', 'campaign_feature_status', 'VIZITAȚI DIN NOU', NULL),
    ('5', 'campaign_feature_status', 'ACCEPTAT', NULL),
    ('6', 'campaign_feature_status', 'ANULAT', NULL),
    ('1', 'campaign_status', 'PLANIFICARE', NULL),
    ('10', 'campaign_status', 'ANULAT', NULL),
    ('2', 'campaign_status', 'PLANIFICAT', NULL),
    ('3', 'campaign_status', 'ATRIBUIT', NULL),
    ('4', 'campaign_status', 'ÎN CURS DE DESFĂȘURARE', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('6', 'campaign_status', 'EXECUTAT', NULL),
    ('7', 'campaign_status', 'REJECTAT', NULL),
    ('8', 'campaign_status', 'GATA DE ACCEPTARE', NULL),
    ('9', 'campaign_status', 'ACCEPTAT', NULL),
    ('1', 'campaign_type', 'RECENZIE', NULL),
    ('2', 'campaign_type', 'VIZITA', NULL),
    ('3', 'campaign_type', 'INVENTAR', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'lyt_buttons', NULL),
    ('1', 'lot_feature_status', 'PLANIFICAT', NULL),
    ('2', 'lot_feature_status', 'NEVIZITAT', NULL),
    ('3', 'lot_feature_status', 'VĂZUT', NULL),
    ('4', 'lot_feature_status', 'VIZITAȚI DIN NOU', NULL),
    ('5', 'lot_feature_status', 'ACCEPTAT', NULL),
    ('6', 'lot_feature_status', 'ANULAT', NULL),
    ('1', 'lot_status', 'PLANIFICARE', NULL),
    ('10', 'lot_status', 'ANULAT', NULL),
    ('2', 'lot_status', 'PLANIFICAT', NULL),
    ('3', 'lot_status', 'ATRIBUIT', NULL),
    ('4', 'lot_status', 'ÎN CURS DE DESFĂȘURARE', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL),
    ('6', 'lot_status', 'EXECUTAT', NULL),
    ('7', 'lot_status', 'REJECTAT', NULL),
    ('8', 'lot_status', 'GATA DE ACCEPTARE', NULL),
    ('9', 'lot_status', 'ACCEPTAT', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

UPDATE config_form_fields AS t
SET widgetcontrols = v.text::json
FROM (
	VALUES
	('active', 'campaign_inventory', 'form_feature', 'tab_data', '{"vdefault_value": "Adevărat"}'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', '{"vdefault_value": "Adevărat"}'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', '{"vdefault_value": "Adevărat"}'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', '{"vdefault_value": "Această funcție urmărește să treacă controlul de calitate al unei campanii, putând alege un anumit lot într-un mod concret.<br><br> Sunt analizate diferite aspecte, cel mai important fiind faptul că este configurat astfel încât datele să fie operaționale în întreaga campanie pentru ca modelul hidraulic să funcționeze."}'),
    ('active', 'lot', 'form_feature', 'tab_data', '{"vdefault_value": "Adevărat"}')
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
    ('om_campaign_lot_x_arc', 'action', 'Acțiune'),
    ('om_campaign_lot_x_connec', 'action', 'Acțiune'),
    ('om_campaign_lot_x_link', 'action', 'Acțiune'),
    ('om_campaign_lot_x_node', 'action', 'Acțiune'),
    ('v_ui_campaign', 'active', 'Activ'),
    ('v_ui_lot', 'active', 'Activ'),
    ('cat_organization', 'active', 'Activ'),
    ('cat_team', 'active', 'Activ'),
    ('cat_user', 'active', 'Activ'),
    ('om_campaign_x_arc', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_connec', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_link', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_node', 'admin_observ', 'Admin observ'),
    ('om_campaign_x_arc', 'arccat_id', 'Arccat id'),
    ('om_campaign_x_arc', 'arc_id', 'Arc id'),
    ('om_campaign_lot_x_arc', 'arc_id', 'Arc id'),
    ('om_campaign_x_arc', 'arc_type', 'Tip arc'),
    ('v_ui_campaign', 'campaign_class', 'Clasa de campanie'),
    ('v_ui_campaign', 'campaign_id', 'Id-ul campaniei'),
    ('om_campaign_x_arc', 'campaign_id', 'Id-ul campaniei'),
    ('om_campaign_x_connec', 'campaign_id', 'Id-ul campaniei'),
    ('om_campaign_x_link', 'campaign_id', 'Id-ul campaniei'),
    ('om_campaign_x_node', 'campaign_id', 'Id-ul campaniei'),
    ('v_ui_lot', 'campaign_name', 'Numele campaniei'),
    ('v_ui_campaign', 'campaign_type', 'Tipul campaniei'),
    ('om_campaign_x_arc', 'code', 'Cod'),
    ('om_campaign_x_connec', 'code', 'Cod'),
    ('om_campaign_x_link', 'code', 'Cod'),
    ('om_campaign_x_node', 'code', 'Cod'),
    ('om_campaign_lot_x_arc', 'code', 'Cod'),
    ('om_campaign_lot_x_connec', 'code', 'Cod'),
    ('om_campaign_lot_x_link', 'code', 'Cod'),
    ('om_campaign_lot_x_node', 'code', 'Cod'),
    ('cat_organization', 'code', 'Cod'),
    ('cat_team', 'code', 'Cod'),
    ('cat_user', 'code', 'Cod'),
    ('om_campaign_x_connec', 'connec_id', 'Conectare id'),
    ('om_campaign_lot_x_connec', 'connec_id', 'Conectare id'),
    ('om_campaign_x_connec', 'connectcat_id', 'Connectcat id'),
    ('v_ui_campaign', 'descript', 'Descript'),
    ('v_ui_lot', 'descript', 'Descript'),
    ('cat_organization', 'descript', 'Descript'),
    ('cat_team', 'descript', 'Descript'),
    ('v_ui_campaign', 'enddate', 'Data de încheiere'),
    ('v_ui_lot', 'enddate', 'Data de încheiere'),
    ('v_ui_lot', 'expl_id', 'Expl id'),
    ('om_campaign_x_arc', 'id', 'Id'),
    ('om_campaign_x_connec', 'id', 'Id'),
    ('om_campaign_x_link', 'id', 'Id'),
    ('om_campaign_x_node', 'id', 'Id'),
    ('om_campaign_lot_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_connec', 'id', 'Id'),
    ('om_campaign_lot_x_link', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'id', 'Id'),
    ('om_campaign_x_link', 'linkcat_id', 'Id Linkcat'),
    ('om_campaign_x_link', 'link_id', 'Link id'),
    ('om_campaign_lot_x_link', 'link_id', 'Link id'),
    ('v_ui_lot', 'lot_id', 'Id lot'),
    ('om_campaign_lot_x_arc', 'lot_id', 'Id lot'),
    ('om_campaign_lot_x_connec', 'lot_id', 'Id lot'),
    ('om_campaign_lot_x_link', 'lot_id', 'Id lot'),
    ('om_campaign_lot_x_node', 'lot_id', 'Id lot'),
    ('v_ui_campaign', 'name', 'Nume și prenume'),
    ('v_ui_lot', 'name', 'Nume și prenume'),
    ('om_campaign_x_arc', 'node_1', 'Nod 1'),
    ('om_campaign_lot_x_arc', 'node_1', 'Nod 1'),
    ('om_campaign_x_arc', 'node_2', 'Nodul 2'),
    ('om_campaign_lot_x_arc', 'node_2', 'Nodul 2'),
    ('om_campaign_x_node', 'nodecat_id', 'Nodecat id'),
    ('om_campaign_x_node', 'node_id', 'Id nod'),
    ('om_campaign_lot_x_node', 'node_id', 'Id nod'),
    ('om_campaign_x_node', 'node_type', 'Tipul nodului'),
    ('v_ui_campaign', 'organization_id', 'Id organizație'),
    ('cat_organization', 'organization_id', 'Id organizație'),
    ('cat_organization', 'orgname', 'Nume org.'),
    ('cat_team', 'orgname', 'Nume org.'),
    ('om_campaign_x_arc', 'org_observ', 'Org observ'),
    ('om_campaign_x_connec', 'org_observ', 'Org observ'),
    ('om_campaign_x_link', 'org_observ', 'Org observ'),
    ('om_campaign_x_node', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_arc', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_connec', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_link', 'org_observ', 'Org observ'),
    ('om_campaign_lot_x_node', 'org_observ', 'Org observ'),
    ('om_campaign_x_arc', 'qindex1', 'Qindex1'),
    ('om_campaign_x_connec', 'qindex1', 'Qindex1'),
    ('om_campaign_x_link', 'qindex1', 'Qindex1'),
    ('om_campaign_x_node', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_arc', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_connec', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_link', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_node', 'qindex1', 'Qindex1'),
    ('om_campaign_x_arc', 'qindex2', 'Qindex2'),
    ('om_campaign_x_connec', 'qindex2', 'Qindex2'),
    ('om_campaign_x_link', 'qindex2', 'Qindex2'),
    ('om_campaign_x_node', 'qindex2', 'Qindex2'),
    ('om_campaign_lot_x_arc', 'qindex2', 'Qindex2'),
    ('om_campaign_lot_x_connec', 'qindex2', 'Qindex2'),
    ('om_campaign_lot_x_link', 'qindex2', 'Qindex2'),
    ('om_campaign_lot_x_node', 'qindex2', 'Qindex2'),
    ('v_ui_campaign', 'real_enddate', 'Data finală reală'),
    ('v_ui_lot', 'real_enddate', 'Data finală reală'),
    ('v_ui_campaign', 'real_startdate', 'Data reală de începere'),
    ('v_ui_lot', 'real_startdate', 'Data reală de începere'),
    ('cat_team', 'role_id', 'Id rol'),
    ('v_ui_lot', 'sector_id', 'Id sector'),
    ('v_ui_campaign', 'startdate', 'Data de începere'),
    ('v_ui_lot', 'startdate', 'Data de începere'),
    ('v_ui_campaign', 'status', 'Statut'),
    ('om_campaign_x_arc', 'status', 'Statut'),
    ('om_campaign_x_connec', 'status', 'Statut'),
    ('om_campaign_x_link', 'status', 'Statut'),
    ('om_campaign_x_node', 'status', 'Statut'),
    ('v_ui_lot', 'status', 'Statut'),
    ('om_campaign_lot_x_arc', 'status', 'Statut'),
    ('om_campaign_lot_x_connec', 'status', 'Statut'),
    ('om_campaign_lot_x_link', 'status', 'Statut'),
    ('om_campaign_lot_x_node', 'status', 'Statut'),
    ('cat_team', 'team_id', 'Id echipă'),
    ('v_ui_lot', 'team_name', 'Numele echipei'),
    ('cat_team', 'teamname', 'Numele echipei'),
    ('cat_user', 'teamname', 'Numele echipei'),
    ('om_campaign_lot_x_arc', 'team_observ', 'Echipa observ'),
    ('om_campaign_lot_x_connec', 'team_observ', 'Echipa observ'),
    ('om_campaign_lot_x_link', 'team_observ', 'Echipa observ'),
    ('om_campaign_lot_x_node', 'team_observ', 'Echipa observ'),
    ('v_ui_campaign', 'the_geom', 'Geom'),
    ('om_campaign_x_arc', 'the_geom', 'Geom'),
    ('om_campaign_x_connec', 'the_geom', 'Geom'),
    ('om_campaign_x_link', 'the_geom', 'Geom'),
    ('om_campaign_x_node', 'the_geom', 'Geom'),
    ('v_ui_lot', 'the_geom', 'Geom'),
    ('om_campaign_lot_x_arc', 'update_count', 'Actualizarea numărului'),
    ('om_campaign_lot_x_connec', 'update_count', 'Actualizarea numărului'),
    ('om_campaign_lot_x_link', 'update_count', 'Actualizarea numărului'),
    ('om_campaign_lot_x_node', 'update_count', 'Actualizarea numărului'),
    ('om_campaign_lot_x_arc', 'update_log', 'Jurnal de actualizare'),
    ('om_campaign_lot_x_connec', 'update_log', 'Jurnal de actualizare'),
    ('om_campaign_lot_x_link', 'update_log', 'Jurnal de actualizare'),
    ('om_campaign_lot_x_node', 'update_log', 'Jurnal de actualizare'),
    ('cat_user', 'user_id', 'ID utilizator'),
    ('cat_user', 'username', 'Numele utilizatorului'),
    ('v_ui_lot', 'workorder_name', 'Numele comenzii de lucru')
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

UPDATE sys_fprocess AS t
SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name
FROM (
    VALUES
    (100, 'valoare nulă pe coloana %check_column% din %table_name%', '%check_column% de pe %table_name% au valori corecte.', 'Verificarea consistenței nulităților'),
    (200, 'Există unii utilizatori cărora nu li s-a atribuit nicio echipă.', 'Toți utilizatorii au atribuită o echipă.', 'Verificarea consistenței utilizatorilor'),
    (201, 'echipe fără utilizatori atribuiți.', 'Toate echipele au utilizatori atribuiți.', 'Verificarea consistenței echipelor'),
    (202, 'Există câteva noduri orfane', 'Nu există noduri orfane.', 'Verificarea nodurilor orfane'),
    (203, 'noduri dublate cu starea 1.', 'Nu există noduri duplicate cu starea 1', 'Verificarea nodurilor duplicate')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

