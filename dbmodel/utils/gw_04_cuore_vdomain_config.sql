/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of config system table
-- ----------------------------

INSERT INTO config VALUES (1, 0.1, 0.5, 0.5, 0.1, 0.5,false,null,false,null,false, true, true, true, 0.001, 0.001, false, true);

INSERT INTO config_csv_import VALUES ('inp_pattern', 'Patterns');
INSERT INTO config_csv_import VALUES ('inp_curve', 'Curve');

INSERT INTO config_extract_raster_value VALUES ('1', 'topo', '1', 'v_edit_node', 'elev');

INSERT INTO config_search_plus VALUES ('1', 'point', 'point_type', 'text', 'ext_urban_propierties', 'complement', 'placement', 'postnumber', 'ext_streetaxis', 'id', 'name', 'v_edit_connec', 'streetaxis_id', 'postnumber', 'v_edit_connec', 'connec_id', 'v_rtc_hydrometer', 'hydrometer_id', 'connec_id');


INSERT INTO config_ui_forms VALUES (340, NULL, 'v_rtc_hydrometer', 'instalation_date', false, NULL, 11);
INSERT INTO config_ui_forms VALUES (341, NULL, 'v_rtc_hydrometer', 'flow', false, NULL, 12);
INSERT INTO config_ui_forms VALUES (342, NULL, 'v_rtc_hydrometer', 'easel', false, NULL, 13);
INSERT INTO config_ui_forms VALUES (343, NULL, 'v_rtc_hydrometer', 'cover', false, NULL, 14);
INSERT INTO config_ui_forms VALUES (344, NULL, 'v_rtc_hydrometer', 'diameter', false, NULL, 15);
INSERT INTO config_ui_forms VALUES (345, NULL, 'v_rtc_hydrometer', 'kink_date', false, NULL, 16);
INSERT INTO config_ui_forms VALUES (346, NULL, 'v_rtc_hydrometer', 'technical_average', false, NULL, 17);
INSERT INTO config_ui_forms VALUES (347, NULL, 'v_rtc_hydrometer', 'hydrometer_number', false, NULL, 18);
INSERT INTO config_ui_forms VALUES (290, NULL, 'v_ui_doc_x_arc', 'doc_id', true, 150, 4);
INSERT INTO config_ui_forms VALUES (291, NULL, 'v_ui_doc_x_arc', 'path', true, 150, 5);
INSERT INTO config_ui_forms VALUES (323, NULL, 'v_edit_rtc_hydro_data_x_connec', 'id', false, 150, 1);
INSERT INTO config_ui_forms VALUES (293, NULL, 'v_ui_doc_x_arc', 'tagcat_id', true, 150, 7);
INSERT INTO config_ui_forms VALUES (294, NULL, 'v_ui_doc_x_arc', 'date', true, 150, 8);
INSERT INTO config_ui_forms VALUES (324, NULL, 'v_edit_rtc_hydro_data_x_connec', 'connec_id', true, 150, 2);
INSERT INTO config_ui_forms VALUES (296, NULL, 'v_ui_doc_x_node', 'id', true, 150, 1);
INSERT INTO config_ui_forms VALUES (297, NULL, 'v_ui_doc_x_node', 'node_id', true, 150, 2);
INSERT INTO config_ui_forms VALUES (298, NULL, 'v_ui_doc_x_node', 'doc_type', true, 150, 3);
INSERT INTO config_ui_forms VALUES (299, NULL, 'v_ui_doc_x_node', 'doc_id', true, 150, 4);
INSERT INTO config_ui_forms VALUES (300, NULL, 'v_ui_doc_x_node', 'path', true, 150, 5);
INSERT INTO config_ui_forms VALUES (301, NULL, 'v_ui_doc_x_node', 'observ', true, 150, 6);
INSERT INTO config_ui_forms VALUES (302, NULL, 'v_ui_doc_x_node', 'tagcat_id', true, 150, 7);
INSERT INTO config_ui_forms VALUES (303, NULL, 'v_ui_doc_x_node', 'date', true, 150, 8);
INSERT INTO config_ui_forms VALUES (304, NULL, 'v_ui_doc_x_node', 'user', true, 150, 9);
INSERT INTO config_ui_forms VALUES (325, NULL, 'v_edit_rtc_hydro_data_x_connec', 'hydrometer_id', true, 150, 3);
INSERT INTO config_ui_forms VALUES (326, NULL, 'v_edit_rtc_hydro_data_x_connec', 'cat_hydrometer_id', false, 150, 4);
INSERT INTO config_ui_forms VALUES (327, NULL, 'v_edit_rtc_hydro_data_x_connec', 'hydrometer_type', true, 150, 5);
INSERT INTO config_ui_forms VALUES (329, NULL, 'v_edit_rtc_hydro_data_x_connec', 'sum', true, 150, 7);
INSERT INTO config_ui_forms VALUES (331, NULL, 'v_rtc_hydrometer', 'connec_id', true, 150, 2);
INSERT INTO config_ui_forms VALUES (333, NULL, 'v_rtc_hydrometer', 'cat_hydrometer_id', true, 150, 4);
INSERT INTO config_ui_forms VALUES (335, NULL, 'v_rtc_hydrometer', 'client_name', true, 150, 6);
INSERT INTO config_ui_forms VALUES (336, NULL, 'v_rtc_hydrometer', 'adress', false, NULL, 7);
INSERT INTO config_ui_forms VALUES (337, NULL, 'v_rtc_hydrometer', 'adress_number', false, NULL, 8);
INSERT INTO config_ui_forms VALUES (338, NULL, 'v_rtc_hydrometer', 'adress_adjunct', false, NULL, 9);
INSERT INTO config_ui_forms VALUES (306, NULL, 'v_ui_doc_x_connec', 'connec_id', true, 150, 2);
INSERT INTO config_ui_forms VALUES (307, NULL, 'v_ui_doc_x_connec', 'doc_type', true, 150, 3);
INSERT INTO config_ui_forms VALUES (308, NULL, 'v_ui_doc_x_connec', 'doc_id', true, 150, 4);
INSERT INTO config_ui_forms VALUES (309, NULL, 'v_ui_doc_x_connec', 'path', true, 150, 5);
INSERT INTO config_ui_forms VALUES (339, NULL, 'v_rtc_hydrometer', 'hydrometer_code', false, NULL, 10);
INSERT INTO config_ui_forms VALUES (311, NULL, 'v_ui_doc_x_connec', 'tagcat_id', true, 150, 7);
INSERT INTO config_ui_forms VALUES (312, NULL, 'v_ui_doc_x_connec', 'date', true, 150, 8);
INSERT INTO config_ui_forms VALUES (348, NULL, 'v_rtc_hydrometer', 'hydrometer_flag', false, NULL, 19);
INSERT INTO config_ui_forms VALUES (349, NULL, 'v_rtc_hydrometer', 'digits_hydrometer', false, NULL, 20);
INSERT INTO config_ui_forms VALUES (315, NULL, 'v_ui_element_x_connec', 'connec_id', true, 150, 2);
INSERT INTO config_ui_forms VALUES (316, NULL, 'v_ui_element_x_connec', 'elementcat_id', true, 150, 3);
INSERT INTO config_ui_forms VALUES (317, NULL, 'v_ui_element_x_connec', 'element_id', true, 150, 4);
INSERT INTO config_ui_forms VALUES (350, NULL, 'v_rtc_hydrometer', 'kit_flag_ulmc', false, NULL, 21);
INSERT INTO config_ui_forms VALUES (351, NULL, 'v_rtc_hydrometer', 'brand', false, NULL, 22);
INSERT INTO config_ui_forms VALUES (352, NULL, 'v_rtc_hydrometer', 'class', false, NULL, 23);
INSERT INTO config_ui_forms VALUES (321, NULL, 'v_ui_element_x_connec', 'builtdate', true, 150, 8);
INSERT INTO config_ui_forms VALUES (322, NULL, 'v_ui_element_x_connec', 'enddate', true, 150, 9);
INSERT INTO config_ui_forms VALUES (292, NULL, 'v_ui_doc_x_arc', 'observ', false, 150, 6);
INSERT INTO config_ui_forms VALUES (295, NULL, 'v_ui_doc_x_arc', 'user', false, 150, 9);
INSERT INTO config_ui_forms VALUES (305, NULL, 'v_ui_doc_x_connec', 'id', false, 150, 1);
INSERT INTO config_ui_forms VALUES (310, NULL, 'v_ui_doc_x_connec', 'observ', false, 150, 6);
INSERT INTO config_ui_forms VALUES (313, NULL, 'v_ui_doc_x_connec', 'user', false, 150, 9);
INSERT INTO config_ui_forms VALUES (314, NULL, 'v_ui_element_x_connec', 'id', false, 150, 1);
INSERT INTO config_ui_forms VALUES (318, NULL, 'v_ui_element_x_connec', 'state', false, 150, 5);
INSERT INTO config_ui_forms VALUES (319, NULL, 'v_ui_element_x_connec', 'observ', false, 150, 6);
INSERT INTO config_ui_forms VALUES (320, NULL, 'v_ui_element_x_connec', 'comment', false, 150, 7);
INSERT INTO config_ui_forms VALUES (353, NULL, 'v_rtc_hydrometer', 'ulmc', false, NULL, 24);
INSERT INTO config_ui_forms VALUES (354, NULL, 'v_rtc_hydrometer', 'voltman_flow', false, NULL, 25);
INSERT INTO config_ui_forms VALUES (356, NULL, 'v_rtc_hydrometer', 'easel_diameter_pol', false, NULL, 27);
INSERT INTO config_ui_forms VALUES (357, NULL, 'v_rtc_hydrometer', 'easel_diameter_mm', false, NULL, 28);
INSERT INTO config_ui_forms VALUES (358, NULL, 'v_rtc_hydrometer', 'text2', false, NULL, 29);
INSERT INTO config_ui_forms VALUES (359, NULL, 'v_rtc_hydrometer', 'text3', false, NULL, 30);
INSERT INTO config_ui_forms VALUES (330, NULL, 'v_rtc_hydrometer', 'hydrometer_id', true, 75, 1);
INSERT INTO config_ui_forms VALUES (332, NULL, 'v_rtc_hydrometer', 'urban_propierties_code', true, 75, 3);
INSERT INTO config_ui_forms VALUES (334, NULL, 'v_rtc_hydrometer', 'hydrometer_type', true, 50, 5);
INSERT INTO config_ui_forms VALUES (328, NULL, 'v_edit_rtc_hydro_data_x_connec', 'cat_period_id', true, 150, 6);
INSERT INTO config_ui_forms VALUES (355, NULL, 'v_rtc_hydrometer', 'multi_jet_flow', false, NULL, 26);
INSERT INTO config_ui_forms VALUES (289, NULL, 'v_ui_doc_x_arc', 'doc_type', true, 500, 3);
INSERT INTO config_ui_forms VALUES (287, NULL, 'v_ui_doc_x_arc', 'id', true, 500, 1);
INSERT INTO config_ui_forms VALUES (288, NULL, 'v_ui_doc_x_arc', 'arc_id', true, 150, 2);
INSERT INTO config_ui_forms VALUES (367, NULL, 'v_ui_element_x_arc', 'builtdate', NULL, NULL, 8);
INSERT INTO config_ui_forms VALUES (368, NULL, 'v_ui_element_x_arc', 'enddate', NULL, NULL, 9);
INSERT INTO config_ui_forms VALUES (360, NULL, 'v_ui_element_x_arc', 'id', false, NULL, 1);
INSERT INTO config_ui_forms VALUES (364, NULL, 'v_ui_element_x_arc', 'state', false, NULL, 5);
INSERT INTO config_ui_forms VALUES (365, NULL, 'v_ui_element_x_arc', 'observ', false, NULL, 6);
INSERT INTO config_ui_forms VALUES (366, NULL, 'v_ui_element_x_arc', 'comment', true, 100, 7);
INSERT INTO config_ui_forms VALUES (363, NULL, 'v_ui_element_x_arc', 'element_id', true, 50, 4);
INSERT INTO config_ui_forms VALUES (362, NULL, 'v_ui_element_x_arc', 'elementcat_id', true, 150, 3);
INSERT INTO config_ui_forms VALUES (361, NULL, 'v_ui_element_x_arc', 'arc_id', true, 100, 2);
INSERT INTO config_ui_forms VALUES (385, NULL, 'v_ui_element_x_node', 'builtdate', NULL, NULL, 8);
INSERT INTO config_ui_forms VALUES (386, NULL, 'v_ui_element_x_node', 'enddate', NULL, NULL, 9);
INSERT INTO config_ui_forms VALUES (378, NULL, 'v_ui_element_x_node', 'id', false, NULL, 1);
INSERT INTO config_ui_forms VALUES (382, NULL, 'v_ui_element_x_node', 'state', false, NULL, 5);
INSERT INTO config_ui_forms VALUES (383, NULL, 'v_ui_element_x_node', 'observ', false, NULL, 6);
INSERT INTO config_ui_forms VALUES (384, NULL, 'v_ui_element_x_node', 'comment', false, NULL, 7);
INSERT INTO config_ui_forms VALUES (387, NULL, 'v_ui_doc_x_node', 'id', false, NULL, 1);
INSERT INTO config_ui_forms VALUES (392, NULL, 'v_ui_doc_x_node', 'observ', false, NULL, 6);
INSERT INTO config_ui_forms VALUES (391, NULL, 'v_ui_doc_x_node', 'path', false, NULL, 5);
INSERT INTO config_ui_forms VALUES (393, NULL, 'v_ui_doc_x_node', 'tagcat_id', false, NULL, 7);
INSERT INTO config_ui_forms VALUES (395, NULL, 'v_ui_doc_x_node', 'user', false, NULL, 9);
INSERT INTO config_ui_forms VALUES (394, NULL, 'v_ui_doc_x_node', 'date', true, 50, 8);
INSERT INTO config_ui_forms VALUES (390, NULL, 'v_ui_doc_x_node', 'doc_id', true, 150, 4);
INSERT INTO config_ui_forms VALUES (389, NULL, 'v_ui_doc_x_node', 'doc_type', true, 200, 3);
INSERT INTO config_ui_forms VALUES (388, NULL, 'v_ui_doc_x_node', 'node_id', true, 75, 2);
INSERT INTO config_ui_forms VALUES (381, NULL, 'v_ui_element_x_node', 'element_id', true, 75, 4);
INSERT INTO config_ui_forms VALUES (380, NULL, 'v_ui_element_x_node', 'elementcat_id', true, 150, 3);
INSERT INTO config_ui_forms VALUES (379, NULL, 'v_ui_element_x_node', 'node_id', true, 50, 2);
INSERT INTO config_ui_forms VALUES (396, NULL, 'v_ui_scada_x_node', 'id', false, NULL, 1);
INSERT INTO config_ui_forms VALUES (400, NULL, 'v_ui_scada_x_node', 'status', false, NULL, 5);
INSERT INTO config_ui_forms VALUES (401, NULL, 'v_ui_scada_x_node', 'timestamp', false, NULL, 6);
INSERT INTO config_ui_forms VALUES (397, NULL, 'v_ui_scada_x_node', 'scada_id', true, 50, 2);
INSERT INTO config_ui_forms VALUES (398, NULL, 'v_ui_scada_x_node', 'node_id', true, 150, 3);
INSERT INTO config_ui_forms VALUES (399, NULL, 'v_ui_scada_x_node', 'value', true, 100, 4);