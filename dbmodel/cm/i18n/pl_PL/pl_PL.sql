/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('active', 'campaign_inventory', 'form_feature', 'tab_data', 'Aktywny:', 'Aktywny'),
    ('campaign_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Kampania Id:', 'Id'),
    ('descript', 'campaign_inventory', 'form_feature', 'tab_data', 'Opis:', 'Opis'),
    ('enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Planowany koniec:', 'Planowany koniec'),
    ('expl_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('inventoryclass_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Klasa zapasów:', 'Klasa zapasów'),
    ('name', 'campaign_inventory', 'form_feature', 'tab_data', 'Imię i nazwisko:', 'Nazwa'),
    ('organization_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Organizacja:', 'Organizacja'),
    ('real_enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Prawdziwy koniec:', 'Prawdziwy koniec'),
    ('real_startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Prawdziwy początek:', 'Prawdziwy start'),
    ('sector_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Id sektora:', 'Id sektora'),
    ('startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Planowany start:', 'Planowany start'),
    ('status', 'campaign_inventory', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', 'Aktywny:', 'Aktywny'),
    ('campaign_id', 'campaign_review', 'form_feature', 'tab_data', 'Kampania Id:', 'Id'),
    ('descript', 'campaign_review', 'form_feature', 'tab_data', 'Opis:', 'Opis'),
    ('enddate', 'campaign_review', 'form_feature', 'tab_data', 'Planowany koniec:', 'Planowany koniec'),
    ('expl_id', 'campaign_review', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('name', 'campaign_review', 'form_feature', 'tab_data', 'Imię i nazwisko:', 'Nazwa'),
    ('organization_id', 'campaign_review', 'form_feature', 'tab_data', 'Organizacja:', 'Organizacja'),
    ('real_enddate', 'campaign_review', 'form_feature', 'tab_data', 'Prawdziwy koniec:', 'Prawdziwy koniec'),
    ('real_startdate', 'campaign_review', 'form_feature', 'tab_data', 'Prawdziwy początek:', 'Prawdziwy start'),
    ('reviewclass_id', 'campaign_review', 'form_feature', 'tab_data', 'Klasa recenzji:', 'Reviewclass'),
    ('sector_id', 'campaign_review', 'form_feature', 'tab_data', 'Id sektora:', 'Id sektora'),
    ('startdate', 'campaign_review', 'form_feature', 'tab_data', 'Planowany start:', 'Planowany start'),
    ('status', 'campaign_review', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', 'Aktywny:', 'Aktywny'),
    ('campaign_id', 'campaign_visit', 'form_feature', 'tab_data', 'Lot Id:', 'Id'),
    ('descript', 'campaign_visit', 'form_feature', 'tab_data', 'Opis:', 'Opis'),
    ('enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Planowany koniec:', 'Planowany koniec'),
    ('expl_id', 'campaign_visit', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('name', 'campaign_visit', 'form_feature', 'tab_data', 'Imię i nazwisko:', 'Nazwa'),
    ('organization_id', 'campaign_visit', 'form_feature', 'tab_data', 'Organizacja:', 'Organizacja'),
    ('real_enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Prawdziwy koniec:', 'Prawdziwy koniec'),
    ('real_startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Prawdziwy początek:', 'Prawdziwy start'),
    ('sector_id', 'campaign_visit', 'form_feature', 'tab_data', 'Id sektora:', 'Id sektora'),
    ('startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Planowany start:', 'Planowany start'),
    ('status', 'campaign_visit', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('visitclass_id', 'campaign_visit', 'form_feature', 'tab_data', 'Klasa odwiedzin:', 'Klasa odwiedzin'),
    ('campaign', 'generic', 'check_project_cm', 'tab_data', 'Kampania:', 'Kampania'),
    ('lot', 'generic', 'check_project_cm', 'tab_data', 'Lot:', 'Lot'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', NULL, NULL),
    ('txt_infolog', 'generic', 'check_project_cm', 'tab_log', NULL, NULL),
    ('active', 'generic', 'team_create', 'tab_none', 'Aktywny:', 'Active:'),
    ('code', 'generic', 'team_create', 'tab_none', 'Kod:', 'Code:'),
    ('descript', 'generic', 'team_create', 'tab_none', 'Opis:', 'Description:'),
    ('name', 'generic', 'team_create', 'tab_none', 'Imię i nazwisko:', 'Name:'),
    ('active', 'lot', 'form_feature', 'tab_data', 'Aktywny:', 'Aktywny'),
    ('campaign_id', 'lot', 'form_feature', 'tab_data', 'Identyfikator kampanii:', 'Identyfikator kampanii'),
    ('descript', 'lot', 'form_feature', 'tab_data', 'Opis:', 'Opis'),
    ('enddate', 'lot', 'form_feature', 'tab_data', 'Planowany koniec:', 'Planowany koniec'),
    ('expl_id', 'lot', 'form_feature', 'tab_data', 'Expl Id:', 'Expl Id'),
    ('lot_id', 'lot', 'form_feature', 'tab_data', 'Identyfikator działki:', 'Id'),
    ('name', 'lot', 'form_feature', 'tab_data', 'Imię i nazwisko:', 'Nazwa'),
    ('organization_assigned', 'lot', 'form_feature', 'tab_data', 'Przydzielona organizacja:', 'Przypisana organizacja'),
    ('real_enddate', 'lot', 'form_feature', 'tab_data', 'Prawdziwy koniec:', 'Prawdziwy koniec'),
    ('real_startdate', 'lot', 'form_feature', 'tab_data', 'Prawdziwy początek:', 'Prawdziwy start'),
    ('sector_id', 'lot', 'form_feature', 'tab_data', 'Id sektora:', 'Id sektora'),
    ('startdate', 'lot', 'form_feature', 'tab_data', 'Planowany start:', 'Planowany start'),
    ('status', 'lot', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('team_id', 'lot', 'form_feature', 'tab_data', 'Zespół:', 'Zespół'),
    ('workorder_id', 'lot', 'form_feature', 'tab_data', 'Identyfikator zlecenia:', 'Identyfikator zlecenia'),
    ('address', 'workorder', 'form_feature', 'tab_data', 'Adres:', 'Adres'),
    ('cost', 'workorder', 'form_feature', 'tab_data', 'Koszt:', 'Koszt'),
    ('exercise', 'workorder', 'form_feature', 'tab_data', 'Ćwiczenie:', 'Ćwiczenie'),
    ('observ', 'workorder', 'form_feature', 'tab_data', 'Obserwować:', 'Obserwacja'),
    ('serie', 'workorder', 'form_feature', 'tab_data', 'Seria:', 'Seria'),
    ('startdate', 'workorder', 'form_feature', 'tab_data', 'Data rozpoczęcia:', 'Data rozpoczęcia'),
    ('workorder_class', 'workorder', 'form_feature', 'tab_data', 'Klasa zlecenia roboczego:', 'Klasa zlecenia roboczego'),
    ('workorder_id', 'workorder', 'form_feature', 'tab_data', 'Workorder Id:', 'Identyfikator zlecenia'),
    ('workorder_name', 'workorder', 'form_feature', 'tab_data', 'Nazwa zlecenia:', 'Nazwa zlecenia'),
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
    ('admin_campaign_type', NULL, 'Zmienna określająca typ kampanii, który chcemy zobaczyć podczas tworzenia'),
    ('basic_selector_tab_campaign', 'Selektor zmiennych', 'Zmienna do konfigurowania wszystkich opcji związanych z wyszukiwaniem dla określonej karty'),
    ('basic_selector_tab_lot', 'Selektor zmiennych', 'Zmienna do konfigurowania wszystkich opcji związanych z wyszukiwaniem dla określonej karty')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

UPDATE sys_typevalue AS t
SET idval = v.idval, descript = v.descript
FROM (
    VALUES
    ('1', 'campaign_feature_status', 'PLANOWANE', NULL),
    ('2', 'campaign_feature_status', 'NIE ODWIEDZONO', NULL),
    ('3', 'campaign_feature_status', 'VISITED', NULL),
    ('4', 'campaign_feature_status', 'ODWIEDŹ PONOWNIE', NULL),
    ('5', 'campaign_feature_status', 'PRZYJĘTY', NULL),
    ('6', 'campaign_feature_status', 'ODWOŁANE', NULL),
    ('1', 'campaign_status', 'PLANOWANIE', NULL),
    ('10', 'campaign_status', 'ODWOŁANE', NULL),
    ('2', 'campaign_status', 'PLANOWANE', NULL),
    ('3', 'campaign_status', 'PRZYPISANY', NULL),
    ('4', 'campaign_status', 'NA BIEŻĄCO', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('6', 'campaign_status', 'EXECUTED', NULL),
    ('7', 'campaign_status', 'ODRZUCONY', NULL),
    ('8', 'campaign_status', 'READY-TO-ACCEPT', NULL),
    ('9', 'campaign_status', 'PRZYJĘTY', NULL),
    ('1', 'campaign_type', 'PRZEGLĄD', NULL),
    ('2', 'campaign_type', 'WIZYTA', NULL),
    ('3', 'campaign_type', 'INWENTARYZACJA', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'lyt_buttons', NULL),
    ('1', 'lot_feature_status', 'PLANOWANE', NULL),
    ('2', 'lot_feature_status', 'NIE ODWIEDZONO', NULL),
    ('3', 'lot_feature_status', 'ODWIEDZONY', NULL),
    ('4', 'lot_feature_status', 'ODWIEDŹ PONOWNIE', NULL),
    ('5', 'lot_feature_status', 'PRZYJĘTY', NULL),
    ('6', 'lot_feature_status', 'ODWOŁANE', NULL),
    ('1', 'lot_status', 'PLANOWANIE', NULL),
    ('10', 'lot_status', 'ODWOŁANE', NULL),
    ('2', 'lot_status', 'PLANOWANE', NULL),
    ('3', 'lot_status', 'PRZYPISANY', NULL),
    ('4', 'lot_status', 'NA BIEŻĄCO', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL),
    ('6', 'lot_status', 'WYKONANE', NULL),
    ('7', 'lot_status', 'ODRZUCONY', NULL),
    ('8', 'lot_status', 'GOTOWY DO PRZYJĘCIA', NULL),
    ('9', 'lot_status', 'PRZYJĘTY', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

UPDATE config_form_fields AS t
SET widgetcontrols = v.text::json
FROM (
	VALUES
	('active', 'campaign_inventory', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', '{"vdefault_value": "Prawda"}'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', '{"vdefault_value": "Esta función tiene por objetivo pasar el control de calidad de una campaña, pudiendo escoger de forma concreta un lote especifico.<br><br>Se analizan diferentes aspectos siendo lo más destacado que se configura para que los datos esten operativos en el conjunto de una campaña para que el modelo hidraulico funcione."}'),
    ('active', 'lot', 'form_feature', 'tab_data', '{"vdefault_value": "True"}')
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
    ('om_campaign_lot_x_arc', 'action', 'Działanie'),
    ('om_campaign_lot_x_connec', 'action', 'Działanie'),
    ('om_campaign_lot_x_link', 'action', 'Działanie'),
    ('om_campaign_lot_x_node', 'action', 'Działanie'),
    ('v_ui_campaign', 'active', 'Aktywny'),
    ('v_ui_lot', 'active', 'Active'),
    ('cat_organization', 'active', 'Aktywny'),
    ('cat_team', 'active', 'Aktywny'),
    ('cat_user', 'active', 'Aktywny'),
    ('om_campaign_x_arc', 'admin_observ', 'Obserwacja administratora'),
    ('om_campaign_x_connec', 'admin_observ', 'Obserwacja administratora'),
    ('om_campaign_x_link', 'admin_observ', 'Obserwacja administratora'),
    ('om_campaign_x_node', 'admin_observ', 'Obserwacja administratora'),
    ('om_campaign_x_arc', 'arccat_id', 'Identyfikator Arccat'),
    ('om_campaign_x_arc', 'arc_id', 'Identyfikator łuku'),
    ('om_campaign_lot_x_arc', 'arc_id', 'Identyfikator łuku'),
    ('om_campaign_x_arc', 'arc_type', 'Typ łuku'),
    ('v_ui_campaign', 'campaign_class', 'Klasa kampanii'),
    ('v_ui_campaign', 'campaign_id', 'Identyfikator kampanii'),
    ('om_campaign_x_arc', 'campaign_id', 'Identyfikator kampanii'),
    ('om_campaign_x_connec', 'campaign_id', 'Identyfikator kampanii'),
    ('om_campaign_x_link', 'campaign_id', 'Identyfikator kampanii'),
    ('om_campaign_x_node', 'campaign_id', 'Identyfikator kampanii'),
    ('v_ui_lot', 'campaign_name', 'Nazwa kampanii'),
    ('v_ui_campaign', 'campaign_type', 'Typ kampanii'),
    ('om_campaign_x_arc', 'code', 'Kod'),
    ('om_campaign_x_connec', 'code', 'Kod'),
    ('om_campaign_x_link', 'code', 'Kod'),
    ('om_campaign_x_node', 'code', 'Kod'),
    ('om_campaign_lot_x_arc', 'code', 'Kod'),
    ('om_campaign_lot_x_connec', 'code', 'Kod'),
    ('om_campaign_lot_x_link', 'code', 'Kod'),
    ('om_campaign_lot_x_node', 'code', 'Kod'),
    ('cat_organization', 'code', 'Kod'),
    ('cat_team', 'code', 'Kod'),
    ('cat_user', 'code', 'Kod'),
    ('om_campaign_x_connec', 'connec_id', 'Identyfikator połączenia'),
    ('om_campaign_lot_x_connec', 'connec_id', 'Identyfikator połączenia'),
    ('om_campaign_x_connec', 'connectcat_id', 'Identyfikator Connectcat'),
    ('v_ui_campaign', 'descript', 'Opis'),
    ('v_ui_lot', 'descript', 'Opis'),
    ('cat_organization', 'descript', 'Opis'),
    ('cat_team', 'descript', 'Opis'),
    ('v_ui_campaign', 'enddate', 'Data zakończenia'),
    ('v_ui_lot', 'enddate', 'Data zakończenia'),
    ('v_ui_lot', 'expl_id', 'Expl id'),
    ('om_campaign_x_arc', 'id', 'Id'),
    ('om_campaign_x_connec', 'id', 'Id'),
    ('om_campaign_x_link', 'id', 'Id'),
    ('om_campaign_x_node', 'id', 'Id'),
    ('om_campaign_lot_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_connec', 'id', 'Id'),
    ('om_campaign_lot_x_link', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'id', 'Id'),
    ('om_campaign_x_link', 'linkcat_id', 'Identyfikator Linkcat'),
    ('om_campaign_x_link', 'link_id', 'Identyfikator łącza'),
    ('om_campaign_lot_x_link', 'link_id', 'Identyfikator łącza'),
    ('v_ui_lot', 'lot_id', 'Identyfikator działki'),
    ('om_campaign_lot_x_arc', 'lot_id', 'Identyfikator działki'),
    ('om_campaign_lot_x_connec', 'lot_id', 'Identyfikator działki'),
    ('om_campaign_lot_x_link', 'lot_id', 'Identyfikator działki'),
    ('om_campaign_lot_x_node', 'lot_id', 'Identyfikator działki'),
    ('v_ui_campaign', 'name', 'Nazwa'),
    ('v_ui_lot', 'name', 'Nazwa'),
    ('om_campaign_x_arc', 'node_1', 'Węzeł 1'),
    ('om_campaign_lot_x_arc', 'node_1', 'Węzeł 1'),
    ('om_campaign_x_arc', 'node_2', 'Węzeł 2'),
    ('om_campaign_lot_x_arc', 'node_2', 'Węzeł 2'),
    ('om_campaign_x_node', 'nodecat_id', 'Identyfikator Nodecat'),
    ('om_campaign_x_node', 'node_id', 'Identyfikator węzła'),
    ('om_campaign_lot_x_node', 'node_id', 'Identyfikator węzła'),
    ('om_campaign_x_node', 'node_type', 'Typ węzła'),
    ('v_ui_campaign', 'organization_id', 'Identyfikator organizacji'),
    ('cat_organization', 'organization_id', 'Identyfikator organizacji'),
    ('cat_organization', 'orgname', 'Nazwa organizacji'),
    ('cat_team', 'orgname', 'Nazwa organizacji'),
    ('om_campaign_x_arc', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_x_connec', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_x_link', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_x_node', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_lot_x_arc', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_lot_x_connec', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_lot_x_link', 'org_observ', 'Obserwacja organizacji'),
    ('om_campaign_lot_x_node', 'org_observ', 'Obserwacja organizacji'),
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
    ('v_ui_campaign', 'real_enddate', 'Rzeczywista data zakończenia'),
    ('v_ui_lot', 'real_enddate', 'Rzeczywista data zakończenia'),
    ('v_ui_campaign', 'real_startdate', 'Rzeczywista data rozpoczęcia'),
    ('v_ui_lot', 'real_startdate', 'Rzeczywista data rozpoczęcia'),
    ('cat_team', 'role_id', 'Identyfikator roli'),
    ('v_ui_lot', 'sector_id', 'Identyfikator sektora'),
    ('v_ui_campaign', 'startdate', 'Data rozpoczęcia'),
    ('v_ui_lot', 'startdate', 'Data rozpoczęcia'),
    ('v_ui_campaign', 'status', 'Status'),
    ('om_campaign_x_arc', 'status', 'Status'),
    ('om_campaign_x_connec', 'status', 'Status'),
    ('om_campaign_x_link', 'status', 'Status'),
    ('om_campaign_x_node', 'status', 'Status'),
    ('v_ui_lot', 'status', 'Status'),
    ('om_campaign_lot_x_arc', 'status', 'Status'),
    ('om_campaign_lot_x_connec', 'status', 'Status'),
    ('om_campaign_lot_x_link', 'status', 'Status'),
    ('om_campaign_lot_x_node', 'status', 'Status'),
    ('cat_team', 'team_id', 'Identyfikator zespołu'),
    ('v_ui_lot', 'team_name', 'Nazwa zespołu'),
    ('cat_team', 'teamname', 'Nazwa zespołu'),
    ('cat_user', 'teamname', 'Nazwa zespołu'),
    ('om_campaign_lot_x_arc', 'team_observ', 'Obserwator zespołu'),
    ('om_campaign_lot_x_connec', 'team_observ', 'Obserwator zespołu'),
    ('om_campaign_lot_x_link', 'team_observ', 'Obserwator zespołu'),
    ('om_campaign_lot_x_node', 'team_observ', 'Obserwator zespołu'),
    ('v_ui_campaign', 'the_geom', 'Geom'),
    ('om_campaign_x_arc', 'the_geom', 'Geom'),
    ('om_campaign_x_connec', 'the_geom', 'Geom'),
    ('om_campaign_x_link', 'the_geom', 'Geom'),
    ('om_campaign_x_node', 'the_geom', 'Geom'),
    ('v_ui_lot', 'the_geom', 'Geom'),
    ('om_campaign_lot_x_arc', 'update_count', 'Liczba aktualizacji'),
    ('om_campaign_lot_x_connec', 'update_count', 'Liczba aktualizacji'),
    ('om_campaign_lot_x_link', 'update_count', 'Liczba aktualizacji'),
    ('om_campaign_lot_x_node', 'update_count', 'Liczba aktualizacji'),
    ('om_campaign_lot_x_arc', 'update_log', 'Dziennik aktualizacji'),
    ('om_campaign_lot_x_connec', 'update_log', 'Dziennik aktualizacji'),
    ('om_campaign_lot_x_link', 'update_log', 'Dziennik aktualizacji'),
    ('om_campaign_lot_x_node', 'update_log', 'Dziennik aktualizacji'),
    ('cat_user', 'user_id', 'Identyfikator użytkownika'),
    ('cat_user', 'username', 'Nazwa użytkownika'),
    ('v_ui_lot', 'workorder_name', 'Nazwa zlecenia')
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

UPDATE sys_fprocess AS t
SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name
FROM (
    VALUES
    (100, 'wartość null w kolumnie %check_column% %table_name%', 'Kolumna %check_column% w %table_name% ma prawidłowe wartości.', 'Sprawdź spójność zer'),
    (200, 'Niektórzy użytkownicy nie mają przypisanego zespołu.', 'Wszyscy użytkownicy mają przypisany zespół.', 'Sprawdź spójność użytkowników'),
    (201, 'zespołów bez przypisanych użytkowników.', 'Wszystkie zespoły mają przypisanych użytkowników.', 'Sprawdź spójność zespołów'),
    (202, 'Istnieje kilka osieroconych węzłów', 'Nie ma osieroconych węzłów.', 'Sprawdź osierocone węzły'),
    (203, 'węzłów zduplikowanych ze stanem 1.', 'Nie ma zduplikowanych węzłów ze stanem 1', 'Sprawdź zduplikowane węzły')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

