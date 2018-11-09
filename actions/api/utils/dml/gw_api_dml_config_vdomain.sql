/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


UPDATE config_param_system SET value='TRUE' WHERE parameter='sys_api_service';


INSERT INTO audit_cat_table VALUES ('config_web_fields_cat_datatype', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('config_web_layer_cat_formtab', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('config_web_layer_cat_form', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('config_web_fields_cat_type', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('config_web_layer', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('config_web_tabs', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('config_web_tableinfo_x_inforole', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('config_web_fields', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('config_web_forms', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('config_web_composer_scale', 'web', '', 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL);

INSERT INTO audit_cat_table VALUES ('v_web_composer', 'web', '', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('selector_composer', 'web', '', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL);



INSERT INTO config_web_fields_cat_type VALUES ('text');
INSERT INTO config_web_fields_cat_type VALUES ('combo');
INSERT INTO config_web_fields_cat_type VALUES ('textarea');
INSERT INTO config_web_fields_cat_type VALUES ('checkbox');
INSERT INTO config_web_fields_cat_type VALUES ('datepickertime');
INSERT INTO config_web_fields_cat_type VALUES ('formDivider');


INSERT INTO config_web_fields_cat_datatype VALUES ('string');
INSERT INTO config_web_fields_cat_datatype VALUES ('boolean');
INSERT INTO config_web_fields_cat_datatype VALUES ('double');
INSERT INTO config_web_fields_cat_datatype VALUES ('date');


INSERT INTO config_web_layer_cat_formtab VALUES ('tabConnect');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabDoc');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabElement');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabVisit');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabHydro');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabMincut');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabNetwork');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabSearch');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabWorkcat');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabPsector');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabState');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabExpl');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabExploitation');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabNetworkState');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabHydroState');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabAddress');


INSERT INTO config_web_layer_cat_form VALUES ('F11', 'INFO_UD_NODE');
INSERT INTO config_web_layer_cat_form VALUES ('F12', 'INFO_WS_NODE');
INSERT INTO config_web_layer_cat_form VALUES ('F13', 'INFO_UTILS_ARC');
INSERT INTO config_web_layer_cat_form VALUES ('F14', 'INFO_UTILS_CONNEC');
INSERT INTO config_web_layer_cat_form VALUES ('F15', 'INFO_UD_GULLY');
INSERT INTO config_web_layer_cat_form VALUES ('F16', 'GENERIC');
INSERT INTO config_web_layer_cat_form VALUES ('F21', 'VISIT');
INSERT INTO config_web_layer_cat_form VALUES ('F22', 'VISIT_EVENT_STANDARD');
INSERT INTO config_web_layer_cat_form VALUES ('F23', 'VISIT_EVENT_UD_ARC_STANDARD');
INSERT INTO config_web_layer_cat_form VALUES ('F24', 'VISIT_EVENT_UD_ARC_REHABIT');
INSERT INTO config_web_layer_cat_form VALUES ('F25', 'VISIT_MANAGER');
INSERT INTO config_web_layer_cat_form VALUES ('F26', 'ADD_MULTIPLE_VISIT');
INSERT INTO config_web_layer_cat_form VALUES ('F27', 'GALLERY');
INSERT INTO config_web_layer_cat_form VALUES ('F31', 'SEARCH');
INSERT INTO config_web_layer_cat_form VALUES ('F32', 'PRINT');
INSERT INTO config_web_layer_cat_form VALUES ('F33', 'FILTER');
INSERT INTO config_web_layer_cat_form VALUES ('F41', 'MINCUT_NEW');
INSERT INTO config_web_layer_cat_form VALUES ('F42', 'MINCUT_ADD_CONNEC');
INSERT INTO config_web_layer_cat_form VALUES ('F43', 'MINCUT_ADD_HYDROMETER');
INSERT INTO config_web_layer_cat_form VALUES ('F44', 'MINCUT_END');
INSERT INTO config_web_layer_cat_form VALUES ('F45', 'MINCUT_MANAGEMENT');



INSERT INTO config_web_composer_scale VALUES (100, '1:100', NULL, 1);
INSERT INTO config_web_composer_scale VALUES (200, '1:200', NULL, 2);
INSERT INTO config_web_composer_scale VALUES (500, '1:500', NULL, 3);
INSERT INTO config_web_composer_scale VALUES (1000, '1:1000', NULL, 4);
INSERT INTO config_web_composer_scale VALUES (2000, '1:2000', NULL, 5);
INSERT INTO config_web_composer_scale VALUES (10000, '1:10000', NULL, 6);
INSERT INTO config_web_composer_scale VALUES (50000, '1:50000', NULL, 7);
INSERT INTO config_web_composer_scale VALUES (5000, '1:5000', NULL, NULL);




INSERT INTO config_web_fields VALUES (1, 'F22', 'parameter_id', NULL, 'string', 30, NULL, 'parameter', 'parameter_id', 'text', NULL, NULL, NULL, NULL, true, 1);
INSERT INTO config_web_fields VALUES (2, 'F22', 'value', NULL, 'string', NULL, NULL, '0.00', 'value', 'text', NULL, NULL, NULL, NULL, true, 2);
INSERT INTO config_web_fields VALUES (3, 'F22', 'text', NULL, 'string', NULL, NULL, '', 'text', 'text', NULL, NULL, NULL, NULL, true, 3);

INSERT INTO config_web_fields VALUES (4, 'F23', 'parameter_id', NULL, 'string', NULL, NULL, 'parameter', 'parameter_id', 'text', NULL, NULL, NULL, NULL, true, 1);
INSERT INTO config_web_fields VALUES (5, 'F23', 'position_id', NULL, 'string', NULL, NULL, '', 'position_id', 'text', NULL, NULL, NULL, NULL, true, 2);
INSERT INTO config_web_fields VALUES (6, 'F23', 'position_value', NULL, 'string', NULL, NULL, '', 'position_value', 'text', NULL, NULL, NULL, NULL, true, 3);
INSERT INTO config_web_fields VALUES (7, 'F23', 'value', NULL, 'string', NULL, NULL, '0.00', 'value', 'text', NULL, NULL, NULL, NULL, true, 4);
INSERT INTO config_web_fields VALUES (8, 'F23', 'text', NULL, 'string', NULL, NULL, '', 'text', 'text', NULL, NULL, NULL, NULL, true, 5);

INSERT INTO config_web_fields VALUES (10, 'F24', 'parameter_id', NULL, 'string', 30, NULL, 'parameter', 'id', 'text', NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_web_fields VALUES (11, 'F24', 'position_id', NULL, 'string', 30, NULL, '', 'position_id', 'text', NULL, NULL, NULL, NULL, true, 3);
INSERT INTO config_web_fields VALUES (12, 'F24', 'position_value', NULL, 'string', 12, NULL, '0.00', 'position_value', 'text', NULL, NULL, NULL, NULL, true, 4);
INSERT INTO config_web_fields VALUES (13, 'F24', 'value1', NULL, 'string', NULL, NULL, '0.00', 'value1', 'text', NULL, NULL, NULL, NULL, true, 6);
INSERT INTO config_web_fields VALUES (14, 'F24', 'value2', NULL, 'string', NULL, NULL, '0.00', 'value2', 'text', NULL, NULL, NULL, NULL, true, 7);
INSERT INTO config_web_fields VALUES (15, 'F24', 'geom1', NULL, 'string', NULL, NULL, '0.00', 'geom1', 'text', NULL, NULL, NULL, NULL, true, 8);
INSERT INTO config_web_fields VALUES (16, 'F24', 'geom2', NULL, 'string', NULL, NULL, '0.00', 'geom2', 'text', NULL, NULL, NULL, NULL, true, 9);
INSERT INTO config_web_fields VALUES (17, 'F24', 'geom3', NULL, 'string', NULL, NULL, '0.00', 'geom3', 'text', NULL, NULL, NULL, NULL, true, 10);
INSERT INTO config_web_fields VALUES (18, 'F24', 'value', NULL, 'string', 12, NULL, '0.00', 'value', 'text', NULL, NULL, NULL, NULL, true, 5);

INSERT INTO config_web_fields VALUES (24, 'F31', 'hydro_expl', NULL, NULL, NULL, NULL, NULL, 'Explotació:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (25, 'F31', 'hydro_search', NULL, NULL, NULL, NULL, NULL, 'Abonat:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (26, 'F31', 'workcat_search', NULL, NULL, NULL, NULL, NULL, 'Expedient:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (27, 'F31', 'psector_expl', NULL, NULL, NULL, NULL, NULL, 'Explotació:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (28, 'F31', 'psector_search', NULL, NULL, NULL, NULL, NULL, 'Psector:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (29, 'F31', 'add_postnumber', NULL, NULL, NULL, NULL, NULL, 'Núm.:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (30, 'F31', 'generic_search', NULL, NULL, NULL, NULL, NULL, 'Cerca:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (31, 'F31', 'net_type', NULL, NULL, NULL, NULL, NULL, 'Tipus:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (32, 'F31', 'net_code', NULL, NULL, NULL, NULL, NULL, 'Codi:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (33, 'F31', 'add_muni', NULL, NULL, NULL, NULL, NULL, 'Municipi:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (34, 'F31', 'add_street', NULL, NULL, NULL, NULL, NULL, 'Carrer:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (38, 'F31', 'visit_search', NULL, NULL, NULL, NULL, NULL, 'Visita:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_web_fields VALUES (280, 'v_anl_mincut_result_valve', 'id', false, 'string', NULL, NULL, NULL, 'Id:', 'text', NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_web_fields VALUES (281, 'v_anl_mincut_result_valve', 'result_id', false, 'double', 32, 0, NULL, 'Result id:', 'text', NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_web_fields VALUES (282, 'v_anl_mincut_result_valve', 'work_order', false, 'string', NULL, NULL, NULL, 'Work order:', 'text', NULL, NULL, NULL, NULL, true, 3);
INSERT INTO config_web_fields VALUES (283, 'v_anl_mincut_result_valve', 'node_id', false, 'string', NULL, NULL, NULL, 'Node_id:', 'text', NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_web_fields VALUES (284, 'v_anl_mincut_result_valve', 'closed', false, 'boolean', NULL, NULL, NULL, 'Closed:', 'text', NULL, NULL, NULL, NULL, false, 5);
INSERT INTO config_web_fields VALUES (285, 'v_anl_mincut_result_valve', 'broken', false, 'boolean', NULL, NULL, NULL, 'Broken:', 'text', NULL, NULL, NULL, NULL, false, 6);
INSERT INTO config_web_fields VALUES (286, 'v_anl_mincut_result_valve', 'unaccess', false, 'boolean', NULL, NULL, NULL, 'Unaccess:', 'check', NULL, NULL, NULL, NULL, true, 8);
INSERT INTO config_web_fields VALUES (287, 'v_anl_mincut_result_valve', 'proposed', false, 'boolean', NULL, NULL, NULL, 'Proposed:', 'text', NULL, NULL, NULL, NULL, false, 7);

INSERT INTO config_web_fields VALUES (290, 'F45', 'mincut_muni', NULL, NULL, NULL, NULL, NULL, 'Municipi:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (291, 'F45', 'mincut_class', NULL, NULL, NULL, NULL, NULL, 'Classe:', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_web_fields VALUES (292, 'F45', 'mincut_workorder', NULL, NULL, NULL, NULL, NULL, 'Expedient:', NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_web_fields VALUES (297, 'F32', 'composer', true, 'string', NULL, NULL, NULL, 'Composer:', 'combo', 'config_web_composer', 'id', 'id', NULL, true, 1);
INSERT INTO config_web_fields VALUES (295, 'F32', 'descript', true, 'string', NULL, NULL, 'descript', 'Descripcio:', 'textarea', NULL, NULL, NULL, NULL, true, 5);
INSERT INTO config_web_fields VALUES (300, 'F32', 'scale', true, 'string', NULL, NULL, NULL, 'Escala:', 'combo', 'config_web_composer_scale', 'id', 'idval', NULL, true, 2);
INSERT INTO config_web_fields VALUES (294, 'F32', 'title', true, 'string', NULL, NULL, 'title', 'Titol:', 'text', NULL, NULL, NULL, NULL, true, 4);
INSERT INTO config_web_fields VALUES (296, 'F32_', 'date', true, 'date', NULL, NULL, NULL, 'Data:', 'datepikertime', NULL, NULL, NULL, NULL, true, 6);
INSERT INTO config_web_fields VALUES (304, 'F32', 'divider', false, 'string', NULL, NULL, NULL, NULL, 'formDivider', NULL, NULL, NULL, NULL, true, 3);




