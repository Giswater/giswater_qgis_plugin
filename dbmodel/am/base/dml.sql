/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
--
-- Default values
--
SET search_path = am, public;

INSERT INTO sys_version (id, giswater, project_type, postgres, postgis, "date", "language", epsg) VALUES(2, '4.0.001', 'AM', 'PostgreSQL 16.1, compiled by Visual C++ build 1937, 64-bit', '3.4 USE_GEOS=1 USE_PROJ=1 USE_STATS=1', '2025-04-16 10:48:31.383', 'en_US', 25831);

INSERT INTO config_catalog_def SELECT id AS arccat_id, dnom::NUMERIC, round(dnom::NUMERIC * 3 / 5 + 70) AS cost_constr, round(dnom::NUMERIC * 9 / 5 + 310) AS cost_repmain, 10 AS compliance FROM PARENT_SCHEMA.cat_arc WHERE dnom IS NOT NULL;

INSERT INTO config_material_def SELECT id, 0.16, 58, 50, 42, 1964, 10 FROM PARENT_SCHEMA.cat_material WHERE active = true;

INSERT INTO config_engine_def VALUES ('bratemain0', '0.05', 'SH', NULL, NULL, true, 'lyt_engine_1', 1, 'Break rate coefficient', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('drate', '0.05', 'SH', NULL, NULL, true, 'lyt_engine_1', 2, 'Discount rate (%)', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('rleak_1', '0.2', 'WM', NULL, NULL, true, 'lyt_engine_1', 3, 'Real breaks', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('mleak_1', '0.1', 'WM', NULL, NULL, true, 'lyt_engine_1', 4, 'Probability of failure', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('longevity_1', '0.7', 'WM', NULL, NULL, true, 'lyt_engine_1', 5, 'Longevity', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('flow_1', '0.0', 'WM', NULL, NULL, true, 'lyt_engine_1', 6, 'Circulating flow', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('nrw_1', '0.0', 'WM', NULL, NULL, true, 'lyt_engine_1', 7, 'ANC', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('strategic_1', '0.0', 'WM', NULL, NULL, true, 'lyt_engine_1', 8, 'Strategic', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('compliance_1', '0.0', 'WM', NULL, NULL, true, 'lyt_engine_1', 9, 'Compliance', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('expected_year', '0.7', 'SH', NULL, NULL, true, 'lyt_engine_2', 1, 'Weight expected year', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('compliance', '0.1', 'SH', NULL, NULL, true, 'lyt_engine_2', 2, 'Weight compliance', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('strategic', '0.2', 'SH', NULL, NULL, true, 'lyt_engine_2', 3, 'Weight strategic', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('rleak_2', '0.0', 'WM', NULL, NULL, true, 'lyt_engine_2', 4, 'Real breaks', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('mleak_2', '0.0', 'WM', NULL, NULL, true, 'lyt_engine_2', 5, 'Probability of failure', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('longevity_2', '0.0', 'WM', NULL, NULL, true, 'lyt_engine_2', 6, 'Longevity', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('flow_2', '0.5', 'WM', NULL, NULL, true, 'lyt_engine_2', 7, 'Circulating flow', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('nrw_2', '0.2', 'WM', NULL, NULL, true, 'lyt_engine_2', 8, 'ANC', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('strategic_2', '0.0', 'WM', NULL, NULL, true, 'lyt_engine_2', 9, 'Strategic', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_engine_def VALUES ('compliance_2', '0.3', 'WM', NULL, NULL, true, 'lyt_engine_2', 10, 'Compliance', 'float', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- config_form_tableview
--

INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_catalog_def', 'dnom', 0, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_catalog_def', 'cost_constr', 1, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_catalog_def', 'cost_repmain', 2, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_catalog_def', 'compliance', 3, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_material_def', 'material', 0, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_material_def', 'pleak', 1, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_material_def', 'age_max', 2, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_material_def', 'age_med', 3, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_material_def', 'age_min', 4, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_material_def', 'builtdate_vdef', 5, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_material_def', 'compliance', 6, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'parameter', 0, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'value', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'method', 2, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'round', 3, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'descript', 4, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'active', 5, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'layoutname', 6, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'layoutorder', 7, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'label', 8, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'datatype', 9, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'widgettype', 10, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'dv_querytext', 11, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'dv_controls', 12, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'ismandatory', 13, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'iseditable', 14, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'stylesheet', 15, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'widgetcontrols', 16, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'planceholder', 17, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_config', 'utils', 'config_engine_def', 'standardvalue', 18, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'result_id', 0, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'result_name', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'result_type', 2, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'descript', 3, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'report', 4, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'expl_id', 5, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'budget', 6, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'target_year', 7, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'tstamp', 8, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'cur_user', 9, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'status', 10, true, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'presszone_id', 11, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'material_id', 12, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'features', 13, false, NULL, NULL, '{"stretch": true}');
INSERT INTO config_form_tableview VALUES ('priority_manager', 'utils', 'cat_result', 'dnom', 14, false, NULL, NULL, '{"stretch": true}');


INSERT INTO value_status VALUES ('CANCELED', 'CANCELED');
INSERT INTO value_status VALUES ('ON PLANNING', 'ON PLANNING');
INSERT INTO value_status VALUES ('FINISHED', 'FINISHED');

INSERT INTO value_result_type VALUES ('GLOBAL', 'GLOBAL');
INSERT INTO value_result_type VALUES ('SELECTION', 'SELECTION');
