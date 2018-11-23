/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO config_web_fields VALUES (280, 'v_anl_mincut_result_valve', 'id', false, 'string', NULL, NULL, NULL, 'Id:', 'text', NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_web_fields VALUES (281, 'v_anl_mincut_result_valve', 'result_id', false, 'double', 32, 0, NULL, 'Result id:', 'text', NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_web_fields VALUES (282, 'v_anl_mincut_result_valve', 'work_order', false, 'string', NULL, NULL, NULL, 'Work order:', 'text', NULL, NULL, NULL, NULL, true, 3);
INSERT INTO config_web_fields VALUES (283, 'v_anl_mincut_result_valve', 'node_id', false, 'string', NULL, NULL, NULL, 'Node_id:', 'text', NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_web_fields VALUES (284, 'v_anl_mincut_result_valve', 'closed', false, 'boolean', NULL, NULL, NULL, 'Closed:', 'text', NULL, NULL, NULL, NULL, false, 5);
INSERT INTO config_web_fields VALUES (285, 'v_anl_mincut_result_valve', 'broken', false, 'boolean', NULL, NULL, NULL, 'Broken:', 'text', NULL, NULL, NULL, NULL, false, 6);
INSERT INTO config_web_fields VALUES (286, 'v_anl_mincut_result_valve', 'unaccess', false, 'boolean', NULL, NULL, NULL, 'Unaccess:', 'check', NULL, NULL, NULL, NULL, true, 8);
INSERT INTO config_web_fields VALUES (287, 'v_anl_mincut_result_valve', 'proposed', false, 'boolean', NULL, NULL, NULL, 'Proposed:', 'text', NULL, NULL, NULL, NULL, false, 7);
