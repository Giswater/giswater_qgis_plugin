/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- 2018/11/21
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('api_mincut_visible_layers', '["v_anl_mincut_result_valve", "v_anl_mincut_result_node", "v_anl_mincut_result_arc", "v_anl_mincut_result_connec"]', 'Array', 'System', 'Utils');

DELETE FROM config_param_system WHERE parameter = 'api_mincut_parameters';
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('api_mincut_parameters', '{"mincut_valve_layer":"v_anl_mincut_result_valve", "mincut_zoom_layer":"v_anl_mincut_result_node"}', 'Jsonj', 'System', 'Utils');





----------------
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'config_param_system', TRUE, 'New parameter api_mincut_visible_layers');
INSERT INTO audit_log_project (fprocesscat_id, table_id, enabled, log_message) VALUES (33, 'config_param_system', TRUE, 'Update parameter api_mincut_parameters');