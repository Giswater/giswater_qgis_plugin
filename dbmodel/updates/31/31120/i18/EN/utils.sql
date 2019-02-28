/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



INSERT INTO om_visit_class VALUES (6, 'Inspection and clean arc', NULL, true, false, true, 'ARC', 'role_om');
INSERT INTO om_visit_class VALUES (5, 'Inspection and clean node', NULL, true, false, true, 'NODE', 'role_om');
INSERT INTO om_visit_class VALUES (7, 'Inspection and clean embornals', NULL, true, false, true, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (1, 'Leak on pipe', NULL, true, false, false, 'ARC', 'role_om');
INSERT INTO om_visit_class VALUES (0, 'Open visit', NULL, true, true, false, NULL, 'role_om');
INSERT INTO om_visit_class VALUES (2, 'Inspection and clean connec', NULL, true, false, true, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (4, 'Leak on connec', NULL, true, false, false, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (3, 'Leak on node', NULL, true, false, false, 'NODE', 'role_om');
INSERT INTO om_visit_class VALUES (8, 'Incident', NULL, true, false, true, null, 'role_om');



INSERT INTO om_visit_parameter VALUES ('leak_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'leak on arc', 'event_standard', 'defaultvalue', FALSE, 'arc_insp_des');
INSERT INTO om_visit_parameter VALUES ('leak_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'leak on node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_des');
INSERT INTO om_visit_parameter VALUES ('clean_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Clean of arc', 'event_standard', 'defaultvalue', FALSE, 'arc_cln_exec');
INSERT INTO om_visit_parameter VALUES ('clean_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Clean of node', 'event_standard', 'defaultvalue',FALSE, 'node_cln_exec');
INSERT INTO om_visit_parameter VALUES ('clean_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Clean of connec', 'event_standard', 'defaultvalue',FALSE, 'con_cln_exec');
INSERT INTO om_visit_parameter VALUES ('sediments_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Sediments in arc', 'event_standard', 'defaultvalue',FALSE, 'arc_insp_sed');
INSERT INTO om_visit_parameter VALUES ('leak_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'leak on connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_des');
INSERT INTO om_visit_parameter VALUES ('sediments_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Sediments in connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_sed');
INSERT INTO om_visit_parameter VALUES ('sediments_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Sediments in node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_sed');
INSERT INTO om_visit_parameter VALUES ('comment', NULL, 'INSPECTION', NULL, 'TEXT', NULL, 'Tipus d''incidència', 'event_standard', 'e', 'comment');
INSERT INTO om_visit_parameter VALUES ('incident_type', NULL, 'INSPECTION', NULL, 'TEXT', NULL, 'Comentari tipus A', 'event_standard', NULL, 'incident_type');


INSERT INTO om_visit_class_x_parameter VALUES (1, 6, 'sediments_node');
INSERT INTO om_visit_class_x_parameter VALUES (2, 2, 'clean_connec');
INSERT INTO om_visit_class_x_parameter VALUES (3, 2, 'leak_connec');
INSERT INTO om_visit_class_x_parameter VALUES (5, 5, 'leak_arc');
INSERT INTO om_visit_class_x_parameter VALUES (6, 5, 'clean_arc');
INSERT INTO om_visit_class_x_parameter VALUES (4, 2, 'sediments_connec');
INSERT INTO om_visit_class_x_parameter VALUES (7, 5, 'sediments_arc');
INSERT INTO om_visit_class_x_parameter VALUES (8, 6, 'leak_node');
INSERT INTO om_visit_class_x_parameter VALUES (9, 6, 'clean_node');
INSERT INTO om_visit_class_x_parameter VALUES (10, 1, '3');
INSERT INTO om_visit_class_x_parameter VALUES (11, 3, '10');
INSERT INTO om_visit_class_x_parameter VALUES (12, 4, '6');
INSERT INTO om_visit_class_x_parameter VALUES (9, 8, 'comment');
INSERT INTO om_visit_class_x_parameter VALUES (15, 8, 'incident_type');


INSERT INTO om_visit_cat_status VALUES (0, 'Closed', NULL);
INSERT INTO om_visit_cat_status VALUES (1, 'On going', NULL);
INSERT INTO om_visit_cat_status VALUES (2, 'Stand by', NULL);
INSERT INTO om_visit_cat_status VALUES (3, 'Canceled', NULL);

INSERT INTO om_visit_filetype_x_extension VALUES ('Document', 'doc');
INSERT INTO om_visit_filetype_x_extension VALUES ('Pdf', 'pdf');
INSERT INTO om_visit_filetype_x_extension VALUES ('Image', 'jpg');
INSERT INTO om_visit_filetype_x_extension VALUES ('Image', 'png');
INSERT INTO om_visit_filetype_x_extension VALUES ('Video', 'mp4');

INSERT INTO sys_combo_values VALUES (1, 1, 'YES', NULL);
INSERT INTO sys_combo_values VALUES (1, 2, 'NO', NULL);
INSERT INTO sys_combo_values VALUES (1, 3, 'NOT ALL', NULL);
INSERT INTO sys_combo_values VALUES (2, 1, 'GOOD', NULL);
INSERT INTO sys_combo_values VALUES (2, 2, 'SOME', NULL);
INSERT INTO sys_combo_values VALUES (2, 3, 'BAD', NULL);
INSERT INTO sys_combo_values VALUES (4, 1, 'BROKEN COVER', NULL);
INSERT INTO sys_combo_values VALUES (4, 2, 'WATER ON STREET', NULL);
INSERT INTO sys_combo_values VALUES (4, 3, 'KEYS ON GULLY', NULL);
INSERT INTO sys_combo_values VALUES (4, 4, 'SMELT', NULL);
INSERT INTO sys_combo_values VALUES (4, 5, 'COVER NOISE', NULL);
INSERT INTO sys_combo_values VALUES (4, 6, 'NOISE WITH SMELT', NULL);
INSERT INTO sys_combo_values VALUES (4, 7, 'NOISE WITH SMELT AND MORE', NULL);
INSERT INTO sys_combo_values VALUES (4, 8, 'OTHER', NULL);



