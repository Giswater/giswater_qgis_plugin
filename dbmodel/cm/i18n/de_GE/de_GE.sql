/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('active', 'campaign_inventory', 'form_feature', 'tab_data', 'Aktiv:', 'Aktiv'),
    ('campaign_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Kampagnen-id:', 'Id'),
    ('descript', 'campaign_inventory', 'form_feature', 'tab_data', 'Beschreibung:', 'Beschreibung'),
    ('enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Geplantes Ende:', 'Geplantes Ende'),
    ('expl_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Expl id:', 'Expl. id'),
    ('inventoryclass_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Inventarklasse:', 'Inventar Klasse'),
    ('name', 'campaign_inventory', 'form_feature', 'tab_data', 'Name:', 'Name'),
    ('organization_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Organisation:', 'Organisation'),
    ('real_enddate', 'campaign_inventory', 'form_feature', 'tab_data', 'Echtes Ende:', 'Echtes Ende'),
    ('real_startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Ein echter Start:', 'Echter Start'),
    ('sector_id', 'campaign_inventory', 'form_feature', 'tab_data', 'Sektor-id:', 'Sektor-id'),
    ('startdate', 'campaign_inventory', 'form_feature', 'tab_data', 'Geplanter Start:', 'Geplanter Start'),
    ('status', 'campaign_inventory', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', 'Aktiv:', 'Aktiv'),
    ('campaign_id', 'campaign_review', 'form_feature', 'tab_data', 'Kampagnen-id:', 'Id'),
    ('descript', 'campaign_review', 'form_feature', 'tab_data', 'Beschreibung:', 'Beschreibung'),
    ('enddate', 'campaign_review', 'form_feature', 'tab_data', 'Geplantes Ende:', 'Geplantes Ende'),
    ('expl_id', 'campaign_review', 'form_feature', 'tab_data', 'Expl id:', 'Expl. id'),
    ('name', 'campaign_review', 'form_feature', 'tab_data', 'Name:', 'Name'),
    ('organization_id', 'campaign_review', 'form_feature', 'tab_data', 'Organisation:', 'Organisation'),
    ('real_enddate', 'campaign_review', 'form_feature', 'tab_data', 'Echtes Ende:', 'Echtes Ende'),
    ('real_startdate', 'campaign_review', 'form_feature', 'tab_data', 'Ein echter Start:', 'Echter Start'),
    ('reviewclass_id', 'campaign_review', 'form_feature', 'tab_data', 'Klasse überprüfen:', 'Rückblick auf die Klasse'),
    ('sector_id', 'campaign_review', 'form_feature', 'tab_data', 'Sektor-id:', 'Sektor-id'),
    ('startdate', 'campaign_review', 'form_feature', 'tab_data', 'Geplanter Start:', 'Geplanter Start'),
    ('status', 'campaign_review', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', 'Aktiv:', 'Aktiv'),
    ('campaign_id', 'campaign_visit', 'form_feature', 'tab_data', 'Lot id:', 'Id'),
    ('descript', 'campaign_visit', 'form_feature', 'tab_data', 'Beschreibung:', 'Beschreibung'),
    ('enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Geplantes Ende:', 'Geplantes Ende'),
    ('expl_id', 'campaign_visit', 'form_feature', 'tab_data', 'Expl id:', 'Expl. id'),
    ('name', 'campaign_visit', 'form_feature', 'tab_data', 'Name:', 'Name'),
    ('organization_id', 'campaign_visit', 'form_feature', 'tab_data', 'Organisation:', 'Organisation'),
    ('real_enddate', 'campaign_visit', 'form_feature', 'tab_data', 'Echtes Ende:', 'Echtes Ende'),
    ('real_startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Ein echter Start:', 'Echter Start'),
    ('sector_id', 'campaign_visit', 'form_feature', 'tab_data', 'Sektor-id:', 'Sektor-id'),
    ('startdate', 'campaign_visit', 'form_feature', 'tab_data', 'Geplanter Start:', 'Geplanter Start'),
    ('status', 'campaign_visit', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('visitclass_id', 'campaign_visit', 'form_feature', 'tab_data', 'Klasse besuchen:', 'Besucherklasse'),
    ('campaign', 'generic', 'check_project_cm', 'tab_data', 'Kampagne:', 'Kampagne'),
    ('lot', 'generic', 'check_project_cm', 'tab_data', 'Los:', 'Los'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', NULL, NULL),
    ('txt_infolog', 'generic', 'check_project_cm', 'tab_log', NULL, NULL),
    ('active', 'generic', 'team_create', 'tab_none', 'Aktiv:', 'Active:'),
    ('code', 'generic', 'team_create', 'tab_none', 'Code:', 'Code:'),
    ('descript', 'generic', 'team_create', 'tab_none', 'Beschreibung:', 'Description:'),
    ('name', 'generic', 'team_create', 'tab_none', 'Name:', 'Name:'),
    ('active', 'lot', 'form_feature', 'tab_data', 'Aktiv:', 'Aktiv'),
    ('campaign_id', 'lot', 'form_feature', 'tab_data', 'Kampagnen-id:', 'Kampagnen-id'),
    ('descript', 'lot', 'form_feature', 'tab_data', 'Beschreibung:', 'Beschreibung'),
    ('enddate', 'lot', 'form_feature', 'tab_data', 'Geplantes Ende:', 'Geplantes Ende'),
    ('expl_id', 'lot', 'form_feature', 'tab_data', 'Expl id:', 'Expl. id'),
    ('lot_id', 'lot', 'form_feature', 'tab_data', 'Los id:', 'Id'),
    ('name', 'lot', 'form_feature', 'tab_data', 'Name:', 'Name'),
    ('organization_assigned', 'lot', 'form_feature', 'tab_data', 'Zugewiesene Organisation:', 'Zugewiesene Organisation'),
    ('real_enddate', 'lot', 'form_feature', 'tab_data', 'Echtes Ende:', 'Echtes Ende'),
    ('real_startdate', 'lot', 'form_feature', 'tab_data', 'Ein echter Start:', 'Echter Start'),
    ('sector_id', 'lot', 'form_feature', 'tab_data', 'Sektor-id:', 'Sektor-id'),
    ('startdate', 'lot', 'form_feature', 'tab_data', 'Geplanter Start:', 'Geplanter Start'),
    ('status', 'lot', 'form_feature', 'tab_data', 'Status:', 'Status'),
    ('team_id', 'lot', 'form_feature', 'tab_data', 'Mannschaft:', 'Team'),
    ('workorder_id', 'lot', 'form_feature', 'tab_data', 'Arbeitsauftrag-id:', 'Arbeitsauftrag id'),
    ('address', 'workorder', 'form_feature', 'tab_data', 'Adresse:', 'Adresse'),
    ('cost', 'workorder', 'form_feature', 'tab_data', 'Kosten:', 'Kosten'),
    ('exercise', 'workorder', 'form_feature', 'tab_data', 'Übung:', 'Übung'),
    ('observ', 'workorder', 'form_feature', 'tab_data', 'Beobachten:', 'Beobachten'),
    ('serie', 'workorder', 'form_feature', 'tab_data', 'Serie:', 'Serie'),
    ('startdate', 'workorder', 'form_feature', 'tab_data', 'Startdatum:', 'Datum des Beginns'),
    ('workorder_class', 'workorder', 'form_feature', 'tab_data', 'Klasse der Arbeitsaufträge:', 'Klasse Workorder'),
    ('workorder_id', 'workorder', 'form_feature', 'tab_data', 'Workorder id:', 'Workorder id'),
    ('workorder_name', 'workorder', 'form_feature', 'tab_data', 'Workorder name:', 'Workorder name'),
    ('workorder_type', 'workorder', 'form_feature', 'tab_data', 'Art des Arbeitsauftrags:', 'Art des Arbeitsauftrags')
) AS v(columnname, formname, formtype, tabname, label, tooltip)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_form_tabs AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('selector_campaign', 'tab_campaign', 'Kampagne', 'Kampagne'),
    ('selector_campaign', 'tab_lot', 'Los', 'Los')
) AS v(formname, tabname, label, tooltip)
WHERE t.formname = v.formname AND t.tabname = v.tabname;

UPDATE config_param_system AS t
SET label = v.label, descript = v.descript
FROM (
    VALUES
    ('admin_campaign_type', NULL, 'Variable zur Angabe des Kampagnentyps, den wir bei der Erstellung sehen wollen'),
    ('basic_selector_tab_campaign', 'Variabler Selektor', 'Variable zur Konfiguration aller Optionen im Zusammenhang mit der Suche für die jeweilige Registerkarte'),
    ('basic_selector_tab_lot', 'Variabler Selektor', 'Variable zur Konfiguration aller Optionen im Zusammenhang mit der Suche für die jeweilige Registerkarte')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

UPDATE sys_typevalue AS t
SET idval = v.idval, descript = v.descript
FROM (
    VALUES
    ('1', 'campaign_feature_status', 'GEPLANT', NULL),
    ('2', 'campaign_feature_status', 'NICHT BESUCHT', NULL),
    ('3', 'campaign_feature_status', 'VISITED', NULL),
    ('4', 'campaign_feature_status', 'WIEDERBESUCHEN', NULL),
    ('5', 'campaign_feature_status', 'AKZEPTIERT', NULL),
    ('6', 'campaign_feature_status', 'ANGESAGT', NULL),
    ('1', 'campaign_status', 'PLANUNG', NULL),
    ('10', 'campaign_status', 'ANGESAGT', NULL),
    ('2', 'campaign_status', 'GEPLANT', NULL),
    ('3', 'campaign_status', 'ZUGEORDNET', NULL),
    ('4', 'campaign_status', 'IM GANG', NULL),
    ('5', 'campaign_status', 'STAND-BY', NULL),
    ('6', 'campaign_status', 'EXECUTED', NULL),
    ('7', 'campaign_status', 'ABGELEHNT', NULL),
    ('8', 'campaign_status', 'READY-TO-ACCEPT', NULL),
    ('9', 'campaign_status', 'AKZEPTIERT', NULL),
    ('1', 'campaign_type', 'REVIEW', NULL),
    ('2', 'campaign_type', 'BESUCHE', NULL),
    ('3', 'campaign_type', 'INVENTUR', NULL),
    ('lyt_buttons', 'layout_name_typevalue', 'lyt_buttons', NULL),
    ('1', 'lot_feature_status', 'GEPLANT', NULL),
    ('2', 'lot_feature_status', 'NICHT BESUCHT', NULL),
    ('3', 'lot_feature_status', 'BESUCHT', NULL),
    ('4', 'lot_feature_status', 'WIEDERBESUCHEN', NULL),
    ('5', 'lot_feature_status', 'AKZEPTIERT', NULL),
    ('6', 'lot_feature_status', 'ANGESAGT', NULL),
    ('1', 'lot_status', 'PLANUNG', NULL),
    ('10', 'lot_status', 'ANGESAGT', NULL),
    ('2', 'lot_status', 'GEPLANT', NULL),
    ('3', 'lot_status', 'ZUGEORDNET', NULL),
    ('4', 'lot_status', 'IM GANG', NULL),
    ('5', 'lot_status', 'STAND-BY', NULL),
    ('6', 'lot_status', 'EXECUTED (OPERATIV setzen und Trace speichern)', NULL),
    ('7', 'lot_status', 'ABGELEHNT', NULL),
    ('8', 'lot_status', 'ABNAHMEBEREIT', NULL),
    ('9', 'lot_status', 'AKZEPTIERT', NULL)
) AS v(id, typevalue, idval, descript)
WHERE t.id = v.id AND t.typevalue = v.typevalue;

UPDATE config_form_fields AS t
SET widgetcontrols = v.text::json
FROM (
	VALUES
	('active', 'campaign_inventory', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', '{"vdefault_value": "True"}'),
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
    ('om_campaign_lot_x_arc', 'action', 'Aktion'),
    ('om_campaign_lot_x_connec', 'action', 'Aktion'),
    ('om_campaign_lot_x_link', 'action', 'Aktion'),
    ('om_campaign_lot_x_node', 'action', 'Aktion'),
    ('v_ui_campaign', 'active', 'Aktiv'),
    ('v_ui_lot', 'active', 'Active'),
    ('cat_organization', 'active', 'Aktiv'),
    ('cat_team', 'active', 'Aktiv'),
    ('cat_user', 'active', 'Aktiv'),
    ('om_campaign_x_arc', 'admin_observ', 'Admin beobachten'),
    ('om_campaign_x_connec', 'admin_observ', 'Admin beobachten'),
    ('om_campaign_x_link', 'admin_observ', 'Admin beobachten'),
    ('om_campaign_x_node', 'admin_observ', 'Admin beobachten'),
    ('om_campaign_x_arc', 'arccat_id', 'Arccat id'),
    ('om_campaign_x_arc', 'arc_id', 'Bogen-ID'),
    ('om_campaign_lot_x_arc', 'arc_id', 'Bogen-ID'),
    ('om_campaign_x_arc', 'arc_type', 'Lichtbogen-Typ'),
    ('v_ui_campaign', 'campaign_class', 'Klasse der Kampagne'),
    ('v_ui_campaign', 'campaign_id', 'Kampagnen-ID'),
    ('om_campaign_x_arc', 'campaign_id', 'Kampagnen-ID'),
    ('om_campaign_x_connec', 'campaign_id', 'Kampagnen-ID'),
    ('om_campaign_x_link', 'campaign_id', 'Kampagnen-ID'),
    ('om_campaign_x_node', 'campaign_id', 'Kampagnen-ID'),
    ('v_ui_lot', 'campaign_name', 'Name der Kampagne'),
    ('v_ui_campaign', 'campaign_type', 'Kampagnen-Typ'),
    ('om_campaign_x_arc', 'code', 'Code'),
    ('om_campaign_x_connec', 'code', 'Code'),
    ('om_campaign_x_link', 'code', 'Code'),
    ('om_campaign_x_node', 'code', 'Code'),
    ('om_campaign_lot_x_arc', 'code', 'Code'),
    ('om_campaign_lot_x_connec', 'code', 'Code'),
    ('om_campaign_lot_x_link', 'code', 'Code'),
    ('om_campaign_lot_x_node', 'code', 'Code'),
    ('cat_organization', 'code', 'Code'),
    ('cat_team', 'code', 'Code'),
    ('cat_user', 'code', 'Code'),
    ('om_campaign_x_connec', 'connec_id', 'Verbinden'),
    ('om_campaign_lot_x_connec', 'connec_id', 'Verbinden'),
    ('om_campaign_x_connec', 'connectcat_id', 'Connectcat-ID'),
    ('v_ui_campaign', 'descript', 'Beschreibung'),
    ('v_ui_lot', 'descript', 'Beschreibung'),
    ('cat_organization', 'descript', 'Beschreibung'),
    ('cat_team', 'descript', 'Beschreibung'),
    ('v_ui_campaign', 'enddate', 'Datum des Endes'),
    ('v_ui_lot', 'enddate', 'Datum des Endes'),
    ('v_ui_lot', 'expl_id', 'Expl id'),
    ('om_campaign_x_arc', 'id', 'Id'),
    ('om_campaign_x_connec', 'id', 'Id'),
    ('om_campaign_x_link', 'id', 'Id'),
    ('om_campaign_x_node', 'id', 'Id'),
    ('om_campaign_lot_x_arc', 'id', 'Id'),
    ('om_campaign_lot_x_connec', 'id', 'Id'),
    ('om_campaign_lot_x_link', 'id', 'Id'),
    ('om_campaign_lot_x_node', 'id', 'Id'),
    ('om_campaign_x_link', 'linkcat_id', 'Linkcat-ID'),
    ('om_campaign_x_link', 'link_id', 'Link id'),
    ('om_campaign_lot_x_link', 'link_id', 'Link id'),
    ('v_ui_lot', 'lot_id', 'Lot id'),
    ('om_campaign_lot_x_arc', 'lot_id', 'Lot id'),
    ('om_campaign_lot_x_connec', 'lot_id', 'Lot id'),
    ('om_campaign_lot_x_link', 'lot_id', 'Lot id'),
    ('om_campaign_lot_x_node', 'lot_id', 'Lot id'),
    ('v_ui_campaign', 'name', 'Name'),
    ('v_ui_lot', 'name', 'Name'),
    ('om_campaign_x_arc', 'node_1', 'Knoten 1'),
    ('om_campaign_lot_x_arc', 'node_1', 'Knoten 1'),
    ('om_campaign_x_arc', 'node_2', 'Node 2'),
    ('om_campaign_lot_x_arc', 'node_2', 'Node 2'),
    ('om_campaign_x_node', 'nodecat_id', 'Nodecat-ID'),
    ('om_campaign_x_node', 'node_id', 'Knoten-ID'),
    ('om_campaign_lot_x_node', 'node_id', 'Knoten-ID'),
    ('om_campaign_x_node', 'node_type', 'Typ des Knotens'),
    ('v_ui_campaign', 'organization_id', 'Organisations-ID'),
    ('cat_organization', 'organization_id', 'Organisations-ID'),
    ('cat_organization', 'orgname', 'Name der Organisation'),
    ('cat_team', 'orgname', 'Name der Organisation'),
    ('om_campaign_x_arc', 'org_observ', 'Org beobachten'),
    ('om_campaign_x_connec', 'org_observ', 'Org beobachten'),
    ('om_campaign_x_link', 'org_observ', 'Org beobachten'),
    ('om_campaign_x_node', 'org_observ', 'Org beobachten'),
    ('om_campaign_lot_x_arc', 'org_observ', 'Org beobachten'),
    ('om_campaign_lot_x_connec', 'org_observ', 'Org beobachten'),
    ('om_campaign_lot_x_link', 'org_observ', 'Org beobachten'),
    ('om_campaign_lot_x_node', 'org_observ', 'Org beobachten'),
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
    ('v_ui_campaign', 'real_enddate', 'Tatsächliches Enddatum'),
    ('v_ui_lot', 'real_enddate', 'Tatsächliches Enddatum'),
    ('v_ui_campaign', 'real_startdate', 'Tatsächlicher Starttermin'),
    ('v_ui_lot', 'real_startdate', 'Tatsächlicher Starttermin'),
    ('cat_team', 'role_id', 'Rollenbezeichnung'),
    ('v_ui_lot', 'sector_id', 'Sektorbezeichnung'),
    ('v_ui_campaign', 'startdate', 'Datum des Beginns'),
    ('v_ui_lot', 'startdate', 'Datum des Beginns'),
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
    ('cat_team', 'team_id', 'Team-ID'),
    ('v_ui_lot', 'team_name', 'Name der Mannschaft'),
    ('cat_team', 'teamname', 'Name der Mannschaft'),
    ('cat_user', 'teamname', 'Name der Mannschaft'),
    ('om_campaign_lot_x_arc', 'team_observ', 'Team beobachten'),
    ('om_campaign_lot_x_connec', 'team_observ', 'Team beobachten'),
    ('om_campaign_lot_x_link', 'team_observ', 'Team beobachten'),
    ('om_campaign_lot_x_node', 'team_observ', 'Team beobachten'),
    ('v_ui_campaign', 'the_geom', 'Das Geom'),
    ('om_campaign_x_arc', 'the_geom', 'Das Geom'),
    ('om_campaign_x_connec', 'the_geom', 'Das Geom'),
    ('om_campaign_x_link', 'the_geom', 'Das Geom'),
    ('om_campaign_x_node', 'the_geom', 'Das Geom'),
    ('v_ui_lot', 'the_geom', 'Das Geom'),
    ('om_campaign_lot_x_arc', 'update_count', 'Anzahl aktualisieren'),
    ('om_campaign_lot_x_connec', 'update_count', 'Anzahl aktualisieren'),
    ('om_campaign_lot_x_link', 'update_count', 'Anzahl aktualisieren'),
    ('om_campaign_lot_x_node', 'update_count', 'Anzahl aktualisieren'),
    ('om_campaign_lot_x_arc', 'update_log', 'Update log'),
    ('om_campaign_lot_x_connec', 'update_log', 'Update log'),
    ('om_campaign_lot_x_link', 'update_log', 'Update log'),
    ('om_campaign_lot_x_node', 'update_log', 'Update log'),
    ('cat_user', 'user_id', 'Benutzer-ID'),
    ('cat_user', 'username', 'Name des Benutzers'),
    ('v_ui_lot', 'workorder_name', 'Workorder name')
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

UPDATE sys_fprocess AS t
SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name
FROM (
    VALUES
    (100, 'Nullwert in der Spalte %check_column% von %table_name%.', 'Die %check_column% auf %table_name% haben korrekte Werte.', 'Nullen auf Konsistenz prüfen'),
    (200, 'Es gibt einige Benutzer, denen kein Team zugewiesen ist.', 'Allen Benutzern ist ein Team zugewiesen.', 'Konsistenz der Benutzer prüfen'),
    (201, 'Teams, denen keine Benutzer zugewiesen sind.', 'Allen Teams sind Benutzer zugewiesen.', 'Konsistenz der Teams prüfen'),
    (202, 'Es gibt einige verwaiste Knotenpunkte.', 'Es gibt keine verwaisten Knotenpunkte.', 'Verwaiste Knoten prüfen'),
    (203, 'Knoten mit Zustand 1 dupliziert.', 'Es gibt keine doppelten Knoten mit Zustand 1', 'Duplizierte Knoten prüfen')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

