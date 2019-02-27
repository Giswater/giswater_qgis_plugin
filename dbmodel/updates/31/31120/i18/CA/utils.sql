/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



INSERT INTO om_visit_class VALUES (6, 'Inspecció i neteja arc', NULL, true, false, true, 'ARC', 'role_om');
INSERT INTO om_visit_class VALUES (5, 'Inspecció i neteja node', NULL, true, false, true, 'NODE', 'role_om');
INSERT INTO om_visit_class VALUES (7, 'Neteja embornals', NULL, true, false, true, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (1, 'averia en tram', NULL, true, false, false, 'ARC', 'role_om');
INSERT INTO om_visit_class VALUES (0, 'Open visit', NULL, true, true, false, NULL, 'role_om');
INSERT INTO om_visit_class VALUES (2, 'Inspecció i neteja connec', NULL, true, false, true, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (4, 'Avaria connec', NULL, true, false, false, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (3, 'Avaria node', NULL, true, false, false, 'NODE', 'role_om');
INSERT INTO om_visit_class VALUES (8, 'Incidència tipus A', NULL, true, false, true, null, 'role_om');
INSERT INTO om_visit_class VALUES (9, 'Incidència tipus B', NULL, true, false, true, null, 'role_om');


INSERT INTO om_visit_parameter VALUES ('desperfectes_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Desperfectes en arc', 'event_standard', 'defaultvalue', FALSE, 'arc_insp_des');
INSERT INTO om_visit_parameter VALUES ('desperfectes_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Desperfectes en node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_des');
INSERT INTO om_visit_parameter VALUES ('neteja_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Neteja del arc', 'event_standard', 'defaultvalue', FALSE, 'arc_cln_exec');
INSERT INTO om_visit_parameter VALUES ('neteja_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Neteja del node', 'event_standard', 'defaultvalue',FALSE, 'node_cln_exec');
INSERT INTO om_visit_parameter VALUES ('neteja_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Neteja del connec', 'event_standard', 'defaultvalue',FALSE, 'con_cln_exec');
INSERT INTO om_visit_parameter VALUES ('sediments_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Sediments en arc', 'event_standard', 'defaultvalue',FALSE, 'arc_insp_sed');
INSERT INTO om_visit_parameter VALUES ('desperfectes_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Desperfectes en connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_des');
INSERT INTO om_visit_parameter VALUES ('sediments_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Sediments en connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_sed');
INSERT INTO om_visit_parameter VALUES ('sediments_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Sediments en node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_sed');
INSERT INTO om_visit_parameter VALUES ('comentari_typea', NULL, 'INSPECTION', null, 'TEXT', NULL, 'Comentari incidència tipus A', 'event_standard', 'defaultvalue',FALSE, 'comentari_typea');
INSERT INTO om_visit_parameter VALUES ('comentari_typeb', NULL, 'INSPECTION', null, 'TEXT', NULL, 'Comentari incidència tipus B', 'event_standard', 'defaultvalue',FALSE, 'comentari_typeb');


INSERT INTO om_visit_class_x_parameter VALUES (1, 6, 'sediments_node');
INSERT INTO om_visit_class_x_parameter VALUES (2, 2, 'neteja_connec');
INSERT INTO om_visit_class_x_parameter VALUES (3, 2, 'desperfectes_connec');
INSERT INTO om_visit_class_x_parameter VALUES (5, 5, 'desperfectes_arc');
INSERT INTO om_visit_class_x_parameter VALUES (6, 5, 'neteja_arc');
INSERT INTO om_visit_class_x_parameter VALUES (4, 2, 'sediments_connec');
INSERT INTO om_visit_class_x_parameter VALUES (7, 5, 'sediments_arc');
INSERT INTO om_visit_class_x_parameter VALUES (8, 6, 'desperfectes_node');
INSERT INTO om_visit_class_x_parameter VALUES (9, 6, 'neteja_node');
INSERT INTO om_visit_class_x_parameter VALUES (10, 1, '3');
INSERT INTO om_visit_class_x_parameter VALUES (11, 3, '10');
INSERT INTO om_visit_class_x_parameter VALUES (12, 4, '6');
INSERT INTO om_visit_class_x_parameter VALUES (13, 8, 'comentari_typea');
INSERT INTO om_visit_class_x_parameter VALUES (14, 9, 'comentari_typeb');

INSERT INTO om_visit_cat_status VALUES (0, 'Tancada', NULL);
INSERT INTO om_visit_cat_status VALUES (1, 'En curs', NULL);
INSERT INTO om_visit_cat_status VALUES (2, 'Stand by', NULL);
INSERT INTO om_visit_cat_status VALUES (3, 'Cancelada', NULL);

INSERT INTO om_visit_filetype_x_extension VALUES ('Document', 'doc');
INSERT INTO om_visit_filetype_x_extension VALUES ('Pdf', 'pdf');
INSERT INTO om_visit_filetype_x_extension VALUES ('Imatge', 'jpg');
INSERT INTO om_visit_filetype_x_extension VALUES ('Imatge', 'png');
INSERT INTO om_visit_filetype_x_extension VALUES ('Video', 'mp4');




