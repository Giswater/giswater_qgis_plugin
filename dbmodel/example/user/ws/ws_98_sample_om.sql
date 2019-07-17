/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO om_visit_cat VALUES (1, 'Test num.1','2017-1-1', '2017-3-31', NULL, FALSE);
INSERT INTO om_visit_cat VALUES (2, 'Test num.2','2017-4-1', '2017-7-31', NULL, FALSE);
INSERT INTO om_visit_cat VALUES (3, 'Test num.3','2017-8-1', '2017-9-30', NULL, TRUE);
INSERT INTO om_visit_cat VALUES (4, 'Test num.4','2017-10-1', '2017-12-31', NULL, TRUE);


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
INSERT INTO om_visit_parameter VALUES ('comment', NULL, 'INSPECTION', NULL, 'TEXT', NULL, 'comment', 'event_standard', 'e', FALSE, 'comment');
INSERT INTO om_visit_parameter VALUES ('incident_type', NULL, 'INSPECTION', NULL, 'TEXT', NULL, 'incident type', 'event_standard', NULL, FALSE, 'incident_type');


INSERT INTO om_visit_class_x_parameter VALUES (1, 6, 'sediments_node');
INSERT INTO om_visit_class_x_parameter VALUES (2, 2, 'clean_connec');
INSERT INTO om_visit_class_x_parameter VALUES (3, 2, 'leak_connec');
INSERT INTO om_visit_class_x_parameter VALUES (5, 6, 'leak_arc');
INSERT INTO om_visit_class_x_parameter VALUES (6, 6, 'clean_arc');
INSERT INTO om_visit_class_x_parameter VALUES (4, 2, 'sediments_connec');
INSERT INTO om_visit_class_x_parameter VALUES (7, 6, 'sediments_arc');
INSERT INTO om_visit_class_x_parameter VALUES (8, 5, 'leak_node');
INSERT INTO om_visit_class_x_parameter VALUES (9, 5, 'clean_node');
INSERT INTO om_visit_class_x_parameter VALUES (10, 1, 'leak_arc');
INSERT INTO om_visit_class_x_parameter VALUES (11, 3, 'leak_node');
INSERT INTO om_visit_class_x_parameter VALUES (12, 4, 'leak_connec');
INSERT INTO om_visit_class_x_parameter VALUES (13, 8, 'comment');
INSERT INTO om_visit_class_x_parameter VALUES (15, 8, 'incident_type');