/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO om_visit_class_x_parameter VALUES (2, 2, 'neteja_connec');
INSERT INTO om_visit_class_x_parameter VALUES (3, 2, 'desperfectes_connec');
INSERT INTO om_visit_class_x_parameter VALUES (5, 5, 'desperfectes_arc');
INSERT INTO om_visit_class_x_parameter VALUES (6, 5, 'neteja_arc');
INSERT INTO om_visit_class_x_parameter VALUES (4, 2, 'sediments_connec');
INSERT INTO om_visit_class_x_parameter VALUES (7, 5, 'sediments_arc');
INSERT INTO om_visit_class_x_parameter VALUES (8, 6, 'desperfectes_node');
INSERT INTO om_visit_class_x_parameter VALUES (9, 6, 'neteja_node');
INSERT INTO om_visit_class_x_parameter VALUES (10, 6, 'sediments_node');




INSERT INTO om_visit_parameter VALUES ('desperfectes_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Desperfectes en arc', 'event_standard', 'f', 'arc_insp_des');
INSERT INTO om_visit_parameter VALUES ('desperfectes_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Desperfectes en node', 'event_standard', 'f', 'node_insp_des');
INSERT INTO om_visit_parameter VALUES ('neteja_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Neteja del arc', 'event_standard', 'g', 'arc_cln_exec');
INSERT INTO om_visit_parameter VALUES ('neteja_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Neteja del node', 'event_standard', 'g', 'node_cln_exec');
INSERT INTO om_visit_parameter VALUES ('neteja_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Neteja del connec', 'event_standard', 'g', 'con_cln_exec');
INSERT INTO om_visit_parameter VALUES ('sediments_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Sediments en arc', 'event_standard', 'e', 'arc_insp_sed');
INSERT INTO om_visit_parameter VALUES ('desperfectes_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Desperfectes en connec', 'event_standard', 'f', 'con_insp_des');
INSERT INTO om_visit_parameter VALUES ('sediments_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Sediments en connec', 'event_standard', 'e', 'con_insp_sed');
INSERT INTO om_visit_parameter VALUES ('sediments_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Sediments en node', 'event_standard', 'e', 'node_insp_sed');

