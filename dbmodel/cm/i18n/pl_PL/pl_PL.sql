/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('workorder_id', 'workorder', 'form_feature', 'tab_data', 'Workorder Id:', 'Identyfikator zlecenia'),
    ('active', 'generic', 'team_create', 'tab_none', 'Aktywny:', 'Active:'),
    ('inventoryclass_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Klasa zapasów:', 'Klasa zapasów'),
    ('descript', 'lot', 'form_feature', 'tab_data', 'Opis:', 'Opis'),
    ('organization_assigned', 'lot', 'form_feature', 'tab_data', 'Przydzielona organizacja:', 'Przypisana organizacja'),
    ('expl_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('organization_id', 'campaign_visit', 'form_feature', 'tab_data', 'Organizacja:', 'Organizacja'),
    ('serie', 'workorder', 'form_feature', 'tab_data', 'Seria:', 'Seria'),
    ('workorder_id', 'lot', 'form_feature', 'tab_data', 'Identyfikator zlecenia:', 'Identyfikator zlecenia'),
    ('descript', 'campaign_review', 'form_feature', 'tab_data', 'Opis:', 'Opis'),
    ('status', 'campaign_inventory', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('startdate', 'lot', 'form_feature', 'tab_data', 'Planowany start:', 'Planowany start'),
    ('cost', 'workorder', 'form_feature', 'tab_data', 'Koszt:', 'Koszt'),
    ('status', 'lot', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('name', 'generic', 'team_create', 'tab_none', 'Imię i nazwisko:', 'Name:'),
    ('expl_id', 'campaign_review', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('lot_id', 'lot', 'form_feature', 'tab_data', 'Identyfikator działki:', 'Id'),
    ('descript', 'campaign_inventory', 'form_feature', 'tab_data', 'Opis:', 'Opis'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', 'Aktywny:', 'Aktywny'),
    ('txt_infolog', 'generic', 'check_project_cm', 'tab_log', NULL, NULL),
    ('active', 'campaign_inventory', 'form_feature', 'tab_data', 'Aktywny:', 'Aktywny'),
    ('real_startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Prawdziwy początek:', 'Prawdziwy start'),
    ('real_enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Prawdziwy koniec:', 'Prawdziwy koniec'),
    ('campaign_id', 'lot', 'form_feature', 'tab_data', 'Identyfikator kampanii:', 'Identyfikator kampanii'),
    ('real_enddate', 'campaign_review', 'form_feature', 'tab_data', 'Prawdziwy koniec:', 'Prawdziwy koniec'),
    ('enddate', 'campaign_review', 'form_feature', 'tab_data', 'Planowany koniec:', 'Planowany koniec'),
    ('address', 'workorder', 'form_feature', 'tab_data', 'Adres:', 'Adres'),
    ('campaign_id', 'campaign_review', 'form_feature', 'tab_data', 'Kampania Id:', 'Id'),
    ('expl_id', 'campaign_visit', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('exercise', 'workorder', 'form_feature', 'tab_data', 'Ćwiczenie:', 'Ćwiczenie'),
    ('sector_id', 'lot', 'form_feature', 'tab_data', 'Id sektora:', 'Id sektora'),
    ('name', 'campaign_visit', 'form_feature', 'tab_data', 'Imię i nazwisko:', 'Nazwa'),
    ('enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Planowany koniec:', 'Planowany koniec'),
    ('expl_id', 'lot', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Planowany start:', 'Planowany start'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', NULL, NULL),
    ('campaign_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Kampania Id:', 'Id'),
    ('active', 'lot', 'form_feature', 'tab_data', 'Aktywny:', 'Aktywny'),
    ('campaign_id', 'campaign_visit', 'form_feature', 'tab_data', 'Lot Id:', 'Id'),
    ('visitclass_id', 'campaign_visit', 'form_feature', 'tab_data', 'Klasa odwiedzin:', 'Klasa odwiedzin'),
    ('lot', 'generic', 'check_project_cm', 'tab_data', 'Lot:', 'Lot'),
    ('real_enddate', 'lot', 'form_feature', 'tab_data', 'Prawdziwy koniec:', 'Prawdziwy koniec'),
    ('observ', 'workorder', 'form_feature', 'tab_data', 'Obserwować:', 'Obserwacja'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', 'Aktywny:', 'Aktywny'),
    ('status', 'campaign_visit', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Planowany start:', 'Planowany start'),
    ('descript', 'generic', 'team_create', 'tab_none', 'Opis:', 'Description:'),
    ('name', 'campaign_inventory', 'form_feature', 'tab_data', 'Imię i nazwisko:', 'Nazwa'),
    ('enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Planowany koniec:', 'Planowany koniec'),
    ('workorder_name', 'workorder', 'form_feature', 'tab_data', 'Nazwa zlecenia:', 'Nazwa zlecenia'),
    ('startdate', 'campaign_review', 'form_feature', 'tab_data', 'Planowany start:', 'Planowany start'),
    ('campaign', 'generic', 'check_project_cm', 'tab_data', 'Kampania:', 'Kampania'),
    ('sector_id', 'campaign_visit', 'form_feature', 'tab_data', 'Id sektora:', 'Id sektora'),
    ('real_startdate', 'campaign_review', 'form_feature', 'tab_data', 'Prawdziwy początek:', 'Prawdziwy start'),
    ('sector_id', 'campaign_review', 'form_feature', 'tab_data', 'Id sektora:', 'Id sektora'),
    ('name', 'lot', 'form_feature', 'tab_data', 'Imię i nazwisko:', 'Nazwa'),
    ('real_startdate', 'lot', 'form_feature', 'tab_data', 'Prawdziwy początek:', 'Prawdziwy start'),
    ('sector_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Id sektora:', 'Id sektora'),
    ('startdate', 'workorder', 'form_feature', 'tab_data', 'Data rozpoczęcia:', 'Data rozpoczęcia'),
    ('code', 'generic', 'team_create', 'tab_none', 'Kod:', 'Code:'),
    ('name', 'campaign_review', 'form_feature', 'tab_data', 'Imię i nazwisko:', 'Nazwa'),
    ('enddate', 'lot', 'form_feature', 'tab_data', 'Planowany koniec:', 'Planowany koniec'),
    ('reviewclass_id', 'campaign_review', 'form_feature', 'tab_data', 'Klasa recenzji:', 'Reviewclass'),
    ('descript', 'campaign_visit', 'form_feature', 'tab_data', 'Opis:', 'Opis'),
    ('real_enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Prawdziwy koniec:', 'Prawdziwy koniec'),
    ('organization_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Organizacja:', 'Organizacja'),
    ('workorder_class', 'workorder', 'form_feature', 'tab_data', 'Klasa zlecenia roboczego:', 'Klasa zlecenia roboczego'),
    ('status', 'campaign_review', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('team_id', 'lot', 'form_feature', 'tab_data', 'Zespół:', 'Zespół'),
    ('organization_id', 'campaign_review', 'form_feature', 'tab_data', 'Organizacja:', 'Organizacja'),
    ('real_startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Prawdziwy początek:', 'Prawdziwy start'),
    ('workorder_type', 'workorder', 'form_feature', 'tab_data', 'Typ zlecenia:', 'Typ zlecenia')
) AS v(columnname, formname, formtype, tabname, label, tooltip)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_form_tabs AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('selector_campaign', 'tab_campaign', 'Kampania', 'Kampania'),
    ('selector_campaign', 'tab_lot', 'Lot', 'Lot')
) AS v(formname, tabname, label, tooltip)
WHERE t.formname = v.formname AND t.tabname = v.tabname;

UPDATE config_param_system AS t
SET label = v.label, descript = v.descript
FROM (
    VALUES
    ('basic_selector_tab_lot', 'Selektor zmiennych', 'Zmienna do konfigurowania wszystkich opcji związanych z wyszukiwaniem dla określonej karty'),
    ('admin_campaign_type', NULL, 'Zmienna określająca typ kampanii, który chcemy zobaczyć podczas tworzenia'),
    ('basic_selector_tab_campaign', 'Selektor zmiennych', 'Zmienna do konfigurowania wszystkich opcji związanych z wyszukiwaniem dla określonej karty')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

UPDATE sys_typevalue AS t
SET idval = v.idval, descript = v.descript
FROM (
    VALUES
    ('8', 'lot_status', 'GOTOWY DO PRZYJĘCIA', NULL),
    ('6', 'campaign_feature_status', 'ODWOŁANE', NULL),
    ('2', 'campaign_feature_status', 'NIE ODWIEDZONO', NULL),
    ('7', 'lot_status', 'ODRZUCONY', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('3', 'campaign_status', 'PRZYPISANY', NULL),
    ('4', 'lot_status', 'NA BIEŻĄCO', NULL),
    ('6', 'lot_status', 'WYKONANE', NULL),
    ('4', 'lot_feature_status', 'ODWIEDŹ PONOWNIE', NULL),
    ('6', 'lot_feature_status', 'ODWOŁANE', NULL),
    ('2', 'campaign_type', 'WIZYTA', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL),
    ('1', 'campaign_status', 'PLANOWANIE', NULL),
    ('9', 'lot_status', 'PRZYJĘTY', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'lyt_buttons', NULL),
    ('1', 'lot_feature_status', 'PLANOWANE', NULL),
    ('10', 'lot_status', 'ODWOŁANE', NULL),
    ('3', 'lot_status', 'PRZYPISANY', NULL),
    ('2', 'lot_status', 'PLANOWANE', NULL),
    ('5', 'campaign_feature_status', 'PRZYJĘTY', NULL),
    ('3', 'campaign_type', 'INWENTARYZACJA', NULL),
    ('4', 'campaign_feature_status', 'ODWIEDŹ PONOWNIE', NULL),
    ('1', 'campaign_feature_status', 'PLANOWANE', NULL),
    ('4', 'campaign_status', 'NA BIEŻĄCO', NULL),
    ('1', 'lot_status', 'PLANOWANIE', NULL),
    ('2', 'campaign_status', 'PLANOWANE', NULL),
    ('7', 'campaign_status', 'ODRZUCONY', NULL),
    ('2', 'lot_feature_status', 'NIE ODWIEDZONO', NULL),
    ('5', 'lot_feature_status', 'PRZYJĘTY', NULL),
    ('8', 'campaign_status', 'READY-TO-ACCEPT', NULL),
    ('10', 'campaign_status', 'ODWOŁANE', NULL),
    ('3', 'lot_feature_status', 'ODWIEDZONY', NULL),
    ('6', 'campaign_status', 'EXECUTED', NULL),
    ('3', 'campaign_feature_status', 'VISITED', NULL),
    ('1', 'campaign_type', 'PRZEGLĄD', NULL),
    ('9', 'campaign_status', 'PRZYJĘTY', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

UPDATE config_form_fields AS t
SET widgetcontrols = v.text::json
FROM (
	VALUES
	('active', 'campaign_visit', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
    ('active', 'lot', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', '{"vdefault_value": "Esta función tiene por objetivo pasar el control de calidad de una campaña, pudiendo escoger de forma concreta un lote especifico.<br><br>Se analizan diferentes aspectos siendo lo más destacado que se configura para que los datos esten operativos en el conjunto de una campaña para que el modelo hidraulico funcione."}'),
    ('active', 'campaign_inventory', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', '{"vdefault_value": "Prawda"}')
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
    ('om_campaign_x_link', 'link_id', 'Identyfikator łącza'),
    ('om_campaign_lot_x_node', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_lot_x_connec', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_link', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_link', 'lot_id', 'Identyfikator działki'),
    ('om_campaign_lot_x_link', 'action', 'Działanie'),
    ('v_ui_campaign', 'name', 'Nazwa'),
    ('v_ui_campaign', 'status', 'Status'),
    ('v_ui_campaign', 'real_startdate', 'Rzeczywista data rozpoczęcia'),
    ('om_campaign_lot_x_link', 'qindex2', 'Qindex2'),
    ('om_campaign_lot_x_link', 'update_count', 'Liczba aktualizacji'),
    ('om_campaign_lot_x_arc', 'node_2', 'Węzeł 2'),
    ('cat_team', 'team_id', 'Identyfikator zespołu'),
    ('om_campaign_x_node', 'qindex2', 'Qindex2'),
    ('v_ui_campaign', 'startdate', 'Data rozpoczęcia'),
    ('om_campaign_lot_x_arc', 'update_count', 'Liczba aktualizacji'),
    ('om_campaign_x_connec', 'the_geom', 'Geom'),
    ('v_ui_campaign', 'organization_id', 'Identyfikator organizacji'),
    ('om_campaign_lot_x_connec', 'update_log', 'Dziennik aktualizacji'),
    ('om_campaign_x_link', 'admin_observ', 'Obserwacja administratora'),
    ('om_campaign_x_connec', 'qindex2', 'Qindex2'),
    ('om_campaign_x_connec', 'code', 'Kod'),
    ('om_campaign_x_arc', 'campaign_id', 'Identyfikator kampanii'),
    ('v_ui_lot', 'real_enddate', 'Rzeczywista data zakończenia'),
    ('v_ui_lot', 'lot_id', 'Identyfikator działki'),
    ('v_ui_lot', 'descript', 'Opis'),
    ('v_ui_lot', 'workorder_name', 'Nazwa zlecenia'),
    ('v_ui_lot', 'startdate', 'Data rozpoczęcia'),
    ('v_ui_lot', 'enddate', 'Data zakończenia'),
    ('om_campaign_lot_x_connec', 'lot_id', 'Identyfikator działki'),
    ('om_campaign_lot_x_arc', 'arc_id', 'Identyfikator łuku'),
    ('cat_user', 'username', 'Nazwa użytkownika'),
    ('om_campaign_x_link', 'status', 'Status'),
    ('om_campaign_lot_x_link', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_lot_x_arc', 'action', 'Działanie'),
    ('om_campaign_x_arc', 'arccat_id', 'Identyfikator Arccat'),
    ('om_campaign_x_connec', 'id', 'Id'),
    ('cat_team', 'code', 'Kod'),
    ('cat_team', 'role_id', 'Identyfikator roli'),
    ('om_campaign_lot_x_node', 'node_id', 'Identyfikator węzła'),
    ('om_campaign_x_connec', 'connectcat_id', 'Identyfikator Connectcat'),
    ('om_campaign_x_arc', 'admin_observ', 'Obserwacja administratora'),
    ('om_campaign_x_connec', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_x_link', 'linkcat_id', 'Identyfikator Linkcat'),
    ('om_campaign_x_node', 'status', 'Status'),
    ('om_campaign_x_link', 'org_observ', 'Obserwacja organizacji'),
    ('v_ui_campaign', 'enddate', 'Data zakończenia'),
    ('om_campaign_x_connec', 'campaign_id', 'Identyfikator kampanii'),
    ('om_campaign_lot_x_arc', 'node_1', 'Węzeł 1'),
    ('om_campaign_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_link', 'team_observ', 'Obserwator zespołu'),
    ('cat_user', 'active', 'Aktywny'),
    ('om_campaign_lot_x_node', 'action', 'Działanie'),
    ('om_campaign_x_node', 'the_geom', 'Geom'),
    ('cat_team', 'descript', 'Opis'),
    ('om_campaign_lot_x_arc', 'lot_id', 'Identyfikator działki'),
    ('v_ui_campaign', 'the_geom', 'Geom'),
    ('om_campaign_lot_x_node', 'code', 'Kod'),
    ('om_campaign_x_arc', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_x_link', 'code', 'Kod'),
    ('v_ui_lot', 'active', 'Active'),
    ('v_ui_lot', 'expl_id', 'Expl id'),
    ('om_campaign_x_arc', 'node_1', 'Węzeł 1'),
    ('om_campaign_lot_x_connec', 'id', 'Id'),
    ('om_campaign_x_node', 'org_observ', 'Obserwacja organizacji'),
    ('v_ui_lot', 'real_startdate', 'Rzeczywista data rozpoczęcia'),
    ('om_campaign_lot_x_connec', 'action', 'Działanie'),
    ('om_campaign_x_connec', 'status', 'Status'),
    ('v_ui_lot', 'sector_id', 'Identyfikator sektora'),
    ('v_ui_lot', 'team_name', 'Nazwa zespołu'),
    ('v_ui_campaign', 'active', 'Aktywny'),
    ('om_campaign_x_arc', 'node_2', 'Węzeł 2'),
    ('om_campaign_x_link', 'campaign_id', 'Identyfikator kampanii'),
    ('om_campaign_x_connec', 'admin_observ', 'Obserwacja administratora'),
    ('om_campaign_x_connec', 'connec_id', 'Identyfikator połączenia'),
    ('cat_user', 'user_id', 'Identyfikator użytkownika'),
    ('om_campaign_x_arc', 'status', 'Status'),
    ('om_campaign_lot_x_link', 'code', 'Kod'),
    ('om_campaign_x_node', 'node_id', 'Identyfikator węzła'),
    ('cat_organization', 'active', 'Aktywny'),
    ('om_campaign_x_node', 'code', 'Kod'),
    ('cat_organization', 'descript', 'Opis'),
    ('v_ui_campaign', 'campaign_class', 'Klasa kampanii'),
    ('v_ui_campaign', 'real_enddate', 'Rzeczywista data zakończenia'),
    ('om_campaign_lot_x_link', 'id', 'Id'),
    ('om_campaign_x_arc', 'arc_type', 'Typ łuku'),
    ('cat_team', 'active', 'Aktywny'),
    ('v_ui_campaign', 'campaign_id', 'Identyfikator kampanii'),
    ('v_ui_lot', 'campaign_name', 'Nazwa kampanii'),
    ('om_campaign_x_node', 'admin_observ', 'Obserwacja administratora'),
    ('v_ui_lot', 'name', 'Nazwa'),
    ('om_campaign_lot_x_arc', 'team_observ', 'Obserwator zespołu'),
    ('om_campaign_x_arc', 'qindex2', 'Qindex2'),
    ('cat_user', 'teamname', 'Nazwa zespołu'),
    ('om_campaign_x_link', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'team_observ', 'Obserwator zespołu'),
    ('om_campaign_lot_x_connec', 'qindex2', 'Qindex2'),
    ('cat_team', 'orgname', 'Nazwa organizacji'),
    ('cat_user', 'code', 'Kod'),
    ('om_campaign_lot_x_arc', 'qindex2', 'Qindex2'),
    ('v_ui_lot', 'the_geom', 'Geom'),
    ('om_campaign_x_node', 'campaign_id', 'Identyfikator kampanii'),
    ('v_ui_lot', 'status', 'Status'),
    ('cat_organization', 'code', 'Kod'),
    ('om_campaign_lot_x_connec', 'update_count', 'Liczba aktualizacji'),
    ('cat_organization', 'orgname', 'Nazwa organizacji'),
    ('om_campaign_lot_x_node', 'update_log', 'Dziennik aktualizacji'),
    ('om_campaign_lot_x_arc', 'code', 'Kod'),
    ('om_campaign_lot_x_link', 'update_log', 'Dziennik aktualizacji'),
    ('om_campaign_lot_x_arc', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_arc', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_lot_x_node', 'id', 'Id'),
    ('om_campaign_x_link', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_node', 'qindex2', 'Qindex2'),
    ('om_campaign_x_arc', 'arc_id', 'Identyfikator łuku'),
    ('om_campaign_lot_x_connec', 'connec_id', 'Identyfikator połączenia'),
    ('om_campaign_lot_x_connec', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_lot_x_link', 'link_id', 'Identyfikator łącza'),
    ('om_campaign_lot_x_node', 'lot_id', 'Identyfikator działki'),
    ('om_campaign_x_node', 'nodecat_id', 'Identyfikator Nodecat'),
    ('om_campaign_x_node', 'qindex1', 'Qindex1'),
    ('om_campaign_x_arc', 'the_geom', 'Geom'),
    ('om_campaign_lot_x_arc', 'update_log', 'Dziennik aktualizacji'),
    ('om_campaign_x_connec', 'qindex1', 'Qindex1'),
    ('om_campaign_x_link', 'the_geom', 'Geom'),
    ('om_campaign_x_node', 'node_type', 'Typ węzła'),
    ('om_campaign_lot_x_connec', 'status', 'Status'),
    ('om_campaign_lot_x_arc', 'status', 'Status'),
    ('om_campaign_lot_x_connec', 'code', 'Kod'),
    ('v_ui_campaign', 'descript', 'Opis'),
    ('om_campaign_x_arc', 'code', 'Kod'),
    ('om_campaign_lot_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'update_count', 'Liczba aktualizacji'),
    ('cat_team', 'teamname', 'Nazwa zespołu'),
    ('om_campaign_lot_x_link', 'status', 'Status'),
    ('om_campaign_x_node', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'qindex1', 'Qindex1'),
    ('om_campaign_x_arc', 'qindex1', 'Qindex1'),
    ('om_campaign_lot_x_node', 'status', 'Status'),
    ('om_campaign_lot_x_connec', 'team_observ', 'Obserwator zespołu'),
    ('cat_organization', 'organization_id', 'Identyfikator organizacji'),
    ('v_ui_campaign', 'campaign_type', 'Typ kampanii')
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

UPDATE sys_fprocess AS t
SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name
FROM (
    VALUES
    (200, 'Niektórzy użytkownicy nie mają przypisanego zespołu.', 'Wszyscy użytkownicy mają przypisany zespół.', 'Sprawdź spójność użytkowników'),
    (202, 'Istnieje kilka osieroconych węzłów', 'Nie ma osieroconych węzłów.', 'Sprawdź osierocone węzły'),
    (100, 'wartość null w kolumnie %check_column% %table_name%', 'Kolumna %check_column% w %table_name% ma prawidłowe wartości.', 'Sprawdź spójność zer'),
    (201, 'zespołów bez przypisanych użytkowników.', 'Wszystkie zespoły mają przypisanych użytkowników.', 'Sprawdź spójność zespołów'),
    (203, 'węzłów zduplikowanych ze stanem 1.', 'Nie ma zduplikowanych węzłów ze stanem 1', 'Sprawdź zduplikowane węzły')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

