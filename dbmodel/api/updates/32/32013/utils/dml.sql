/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 24/05/2019

UPDATE config_api_form_fields SET formtype='form' WHERE formname='printGeneric';


UPDATE sys_feature_cat SET shortcut_key = 'P' WHERE id = 'PUMP' AND tablename = 'v_edit_man_pump';
UPDATE cat_feature SET shortcut_key = concat('Alt+',sys_feature_cat.shortcut_key) FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'NODE';
UPDATE cat_feature SET shortcut_key = concat('Ctrl+',sys_feature_cat.shortcut_key) FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'CONNEC';
UPDATE cat_feature SET shortcut_key = sys_feature_cat.shortcut_key FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'ARC';


UPDATE config_param_system SET value = '{"sys_table_id":"v_ui_workcat_polygon_all", "sys_id_field":"workcat_id", "sys_search_field":"workcat_id", "sys_geom_field":"the_geom", "filter_text":"code"}' 
	WHERE parameter = 'api_search_workcat';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2", "feature_type":"node_id"}' 
	WHERE parameter = 'api_search_node';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Escomeses", "cat_field":"connecat_id", "orderby":"3", "feature_type":"connec_id"}' 
	WHERE parameter = 'api_search_connec';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5", "feature_type":"element_id"}' 
	WHERE parameter = 'api_search_element';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby" :"1", "feature_type":"arc_id"}' 
	WHERE parameter = 'api_search_arc';

	
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='arccat_id';
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='nodecat_id';
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='connecat_id';
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='connecat_id';
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='gratecat_id';
UPDATE config_api_form_fields set widgettype='typeahead', typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='workcat_id';
UPDATE config_api_form_fields set widgettype='typeahead', typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='workcat_id_end';



UPDATE config_api_form_fields set layout_name = concat('data_',layout_id) WHERE layout_name IS NULL;


-- 28/05/2019

UPDATE cat_feature SET parent_layer = 'v_edit_node' where parent_layer = 've_node';
UPDATE cat_feature SET parent_layer = 'v_edit_arc' where parent_layer = 've_arc';
UPDATE cat_feature SET parent_layer = 'v_edit_connec' where parent_layer = 've_connec';


UPDATE config_api_form_fields SET formname='unexpected_noinfra' WHERE formname='unspected_noinfra';
UPDATE config_api_form_fields SET formname='unexpected_arc' WHERE formname= 'unspected_arc';

UPDATE config_api_visit SET formname='unexpected_arc' WHERE formname= 'unspected_arc';
UPDATE config_api_visit SET formname='unexpected_noinfra' WHERE formname= 'unspected_noinfra';

-- 10/06/2019

UPDATE config_api_form_fields SET dv_querytext = 'SELECT id, id as idval FROM om_visit_lot WHERE active IS TRUE' WHERE id = 28490;
UPDATE config_api_form_fields SET dv_querytext = 'SELECT id, id as idval FROM om_visit_lot WHERE active IS TRUE' WHERE id = 28240;

UPDATE config_api_list SET query_text = 'SELECT DISTINCT ON (a.id) a.id AS sys_id, a.id AS lot_id, ''om_visit_lot'' as sys_table_id, ''id'' as sys_idname FROM om_visit_lot a' WHERE id = 28240;

UPDATE config_api_form_fields SET layout_order = 6 WHERE id = 30040;
UPDATE config_api_form_fields SET layout_order = 7 WHERE id = 30050;
INSERT INTO config_api_form_fields VALUES(30045, 'lot', 'lot','visitclass_id', 1, 5, TRUE, 'string', 'combo', 'Classe visita:', NULL, NULL, NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM om_visit_class WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

UPDATE config_api_form_fields SET dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue=''listlimit''' WHERE id='102718';

-- 04/07/2019

INSERT INTO config_api_form_tabs VALUES(570, 'v_edit_node', 'tab_elements', 'Elem', 'Lista de elementos relacionados', 'role_basic', 'Elements', null,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]', null);
INSERT INTO config_api_form_tabs VALUES(571, 'v_edit_node', 'tab_om', 'OM', 'Lista de eventos del elemento', 'role_basic', 'OM', null,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]', null);
INSERT INTO config_api_form_tabs VALUES(572, 'v_edit_node', 'tab_documents', 'Doc', 'Lista de documentos', 'role_basic', 'Doc', null,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]', null);
INSERT INTO config_api_form_tabs VALUES(573, 'v_edit_node', 'tab_plan', 'Cost', 'Partidas del elemento', 'role_basic', 'Cos', null,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false},{"actionName":"actionSection", "actionFunction":"", "actionTooltip":"actionSection", "disabled":false}]', null);

-- 11/07/2019

UPDATE config_api_form_fields SET column_id = 'connec_type' WHERE column_id = 'connectype_id';

-- 12/07/2019

UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'node_type';
UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'arctype_id';
UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'connec_type';
UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'muni_id';

UPDATE config_api_form_fields SET dv_parent_id = 'node_type' WHERE dv_parent_id = 'nodetype_id';
UPDATE config_api_form_fields SET dv_parent_id = 'arc_type' WHERE dv_parent_id = 'arctype_id';
UPDATE config_api_form_fields SET dv_parent_id = 'connec_type' WHERE dv_parent_id = 'connectype_id';

DELETE FROM config_api_form_fields WHERE formname='visitManager';
DELETE FROM config_api_form_fields WHERE formname='v_ui_om_visitman_x_arc';
DELETE FROM config_api_form_fields WHERE formname='v_ui_om_visitman_x_connec';
DELETE FROM config_api_form_fields WHERE formname='v_ui_om_visitman_x_node';
DELETE FROM config_api_form_fields WHERE formname='lot';
DELETE FROM config_api_form_fields WHERE formname='om_visit';
DELETE FROM config_api_form_fields WHERE formname='om_visit_lot';
DELETE FROM config_api_form_fields WHERE formname='om_visit_event_photo';

DELETE FROM config_api_form_fields WHERE formname='visit_node_leak';
DELETE FROM config_api_form_fields WHERE formname='visit_connec_leak';
DELETE FROM config_api_form_fields WHERE formname='visit_arc_leak';
DELETE FROM config_api_form_fields WHERE formname='visit_node_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_connec_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_arc_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_class_0';
DELETE FROM config_api_form_fields WHERE formname='unexpected_noinfra';
DELETE FROM config_api_form_fields WHERE formname='unexpected_arc';
DELETE FROM config_api_form_fields WHERE formname='visit_emb_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_connec_insp_';
DELETE FROM config_api_form_fields WHERE formname='visit_node_insp_';

INSERT INTO config_api_form_fields VALUES (28492, 'visitManager', 'form', 'acceptbutton', 9, 1, true, NULL, 'button', 'Acceptar', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwSetVisitManager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28460, 'visitManager', 'form', 'startbutton', 1, 3, true, NULL, 'button', 'INICIAR JORNADA', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwSetVisitManagerStart', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28459, 'visitManager', 'form', 'endbutton', 1, 8, true, NULL, 'button', 'FINALITZAR JORNADA', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwSetVisitManagerEnd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (30000, 'lot', 'form', 'lot_id', 1, 1, true, 'integer', 'text', 'Ordre treball:', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (30070, 'lot', 'form', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (30040, 'lot', 'form', 'descript', 1, 5, true, 'string', 'text', 'Descripció', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (30050, 'lot', 'form', 'status', 1, 6, true, 'integer', 'combo', 'Estat:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT DISTINCT id,  idval FROM sys_combo_values WHERE sys_combo_cat_id=5 AND id IN (3,4,5)', NULL, NULL, NULL, NULL, 'gwGetLot', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (30030, 'lot', 'form', 'enddate', 1, 4, false, 'date', 'datepickertime', 'Final:', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (30020, 'lot', 'form', 'startdate', 1, 3, false, 'date', 'datepickertime', 'Inici:', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (30010, 'lot', 'form', 'idval', 1, 2, false, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28662, 'v_ui_om_visitman_x_node', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28702, 'v_ui_om_visitman_x_connec', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28740, 'om_visit', 'listHeader', 'startdate', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"2014-01-01" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28750, 'om_visit', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28410, 'om_visit_event_photo', 'listHeader', 'filetype', 1, 1, true, NULL, 'combo', 'Tipus fitxer', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT distinct filetype AS id, filetype AS idval FROM om_visit_filetype_x_extension WHERE filetype IS NOT NULL', NULL, true, NULL, NULL, 'gwGetVisit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28490, 'visitManager', 'form', 'lot_id', 1, 7, true, NULL, 'combo', 'Ordre treball:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT id, idval FROM om_visit_lot WHERE active IS TRUE', NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28480, 'visitManager', 'form', 'starttime', 1, 4, false, 'date', 'datepickertime', 'Hora inici', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28440, 'visitManager', 'form', 'date', 1, 2, true, 'date', 'datepickertime', 'Data', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28640, 'v_ui_om_visitman_x_arc', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28680, 'v_ui_om_visitman_x_node', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28720, 'v_ui_om_visitman_x_connec', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28430, 'visitManager', 'form', 'user_id', 1, 1, true, 'string', 'combo', 'Nom:', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'SELECT id, name AS idval FROM cat_users WHERE id = current_user', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28456, 'visitManager', 'form', 'backbutton', 9, 2, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28444, 'visitManager', 'form', 'vehicle_id', 1, 6, false, 'string', 'combo', 'Vehicle', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT id, idval FROM cat_vehicle WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28442, 'visitManager', 'form', 'team_id', 1, 5, true, 'string', 'combo', 'Equip:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT id, idval FROM cat_team WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28760, 'om_visit', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28620, 'v_ui_om_visitman_x_arc', 'listHeader', 'visit_start', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"01-01-2014" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28622, 'v_ui_om_visitman_x_arc', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28660, 'v_ui_om_visitman_x_node', 'listHeader', 'visit_start', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"01-01-2014" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28700, 'v_ui_om_visitman_x_connec', 'listHeader', 'visit_start', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"01-01-2014" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28494, 'om_visit_lot', 'listFooter', 'createlot', 1, 1, true, NULL, 'button', 'CREAR ORDRE TREBALL', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetLot', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28496, 'om_visit_lot', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28412, 'om_visit_event_photo', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28420, 'om_visit_event_photo', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrera', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
