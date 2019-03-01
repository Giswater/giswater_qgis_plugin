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
INSERT INTO om_visit_class VALUES (8, 'Incidència', NULL, true, false, true, null, 'role_om');



INSERT INTO om_visit_parameter VALUES ('desperfectes_arc', NULL, 'INSPECCIO', 'ARC', 'TEXT', NULL, 'Desperfectes en arc', 'event_standard', 'defaultvalue', FALSE, 'arc_insp_des');
INSERT INTO om_visit_parameter VALUES ('desperfectes_node', NULL, 'INSPECCIO', 'NODE', 'TEXT', NULL, 'Desperfectes en node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_des');
INSERT INTO om_visit_parameter VALUES ('neteja_arc', NULL, 'INSPECCIO', 'ARC', 'TEXT', NULL, 'Neteja del arc', 'event_standard', 'defaultvalue', FALSE, 'arc_cln_exec');
INSERT INTO om_visit_parameter VALUES ('neteja_node', NULL, 'INSPECCIO', 'NODE', 'TEXT', NULL, 'Neteja del node', 'event_standard', 'defaultvalue',FALSE, 'node_cln_exec');
INSERT INTO om_visit_parameter VALUES ('neteja_connec', NULL, 'INSPECCIO', 'CONNEC', 'TEXT', NULL, 'Neteja del connec', 'event_standard', 'defaultvalue',FALSE, 'con_cln_exec');
INSERT INTO om_visit_parameter VALUES ('sediments_arc', NULL, 'INSPECCIO', 'ARC', 'TEXT', NULL, 'Sediments en arc', 'event_standard', 'defaultvalue',FALSE, 'arc_insp_sed');
INSERT INTO om_visit_parameter VALUES ('desperfectes_connec', NULL, 'INSPECCIO', 'CONNEC', 'TEXT', NULL, 'Desperfectes en connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_des');
INSERT INTO om_visit_parameter VALUES ('sediments_connec', NULL, 'INSPECCIO', 'CONNEC', 'TEXT', NULL, 'Sediments en connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_sed');
INSERT INTO om_visit_parameter VALUES ('sediments_node', NULL, 'INSPECCIO', 'NODE', 'TEXT', NULL, 'Sediments en node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_sed');
INSERT INTO om_visit_parameter VALUES ('tipus_incidencia', NULL, 'INSPECCIO', null, 'TEXT', NULL, 'Tipus incidència', 'event_standard', 'e', FALSE, 'tipus_incidencia');
INSERT INTO om_visit_parameter VALUES ('comentari_incidencia', NULL, 'INSPECCIO', null, 'TEXT', NULL, 'Comentari tipus A', 'event_standard', NULL, FALSE, 'comentari_incidencia');


INSERT INTO om_visit_class_x_parameter VALUES (1, 6, 'sediments_node');
INSERT INTO om_visit_class_x_parameter VALUES (2, 2, 'neteja_connec');
INSERT INTO om_visit_class_x_parameter VALUES (3, 2, 'desperfectes_connec');
INSERT INTO om_visit_class_x_parameter VALUES (5, 6, 'desperfectes_arc');
INSERT INTO om_visit_class_x_parameter VALUES (6, 6, 'neteja_arc');
INSERT INTO om_visit_class_x_parameter VALUES (4, 2, 'sediments_connec');
INSERT INTO om_visit_class_x_parameter VALUES (7, 6, 'sediments_arc');
INSERT INTO om_visit_class_x_parameter VALUES (8, 5, 'desperfectes_node');
INSERT INTO om_visit_class_x_parameter VALUES (9, 5, 'neteja_node');
INSERT INTO om_visit_class_x_parameter VALUES (10, 1, 'desperfectes_arc');
INSERT INTO om_visit_class_x_parameter VALUES (11, 3, 'desperfectes_node');
INSERT INTO om_visit_class_x_parameter VALUES (12, 4, 'desperfectes_connec');
INSERT INTO om_visit_class_x_parameter VALUES (13, 8, 'comentari_incidencia');
INSERT INTO om_visit_class_x_parameter VALUES (15, 8, 'tipus_incidencia');

INSERT INTO om_visit_cat_status VALUES (0, 'Tancada', NULL);
INSERT INTO om_visit_cat_status VALUES (1, 'En curs', NULL);
INSERT INTO om_visit_cat_status VALUES (2, 'Stand by', NULL);
INSERT INTO om_visit_cat_status VALUES (3, 'Cancelada', NULL);

INSERT INTO om_visit_filetype_x_extension VALUES ('Document', 'doc');
INSERT INTO om_visit_filetype_x_extension VALUES ('Pdf', 'pdf');
INSERT INTO om_visit_filetype_x_extension VALUES ('Imatge', 'jpg');
INSERT INTO om_visit_filetype_x_extension VALUES ('Imatge', 'png');
INSERT INTO om_visit_filetype_x_extension VALUES ('Video', 'mp4');

INSERT INTO sys_combo_values VALUES (1, 1, 'SI', NULL);
INSERT INTO sys_combo_values VALUES (1, 2, 'NO', NULL);
INSERT INTO sys_combo_values VALUES (1, 3, 'A MITGES', NULL);
INSERT INTO sys_combo_values VALUES (2, 1, 'BON ESTAT', NULL);
INSERT INTO sys_combo_values VALUES (2, 2, 'ALGUN DESPERFECTE', NULL);
INSERT INTO sys_combo_values VALUES (2, 3, 'MAL ESTAT', NULL);
INSERT INTO sys_combo_values VALUES (4, 1, 'TAPA TRENCADA', NULL);
INSERT INTO sys_combo_values VALUES (4, 2, 'AIGUA AL CARRER', NULL);
INSERT INTO sys_combo_values VALUES (4, 3, 'CLAUS CAIGUDES EN EMBORNAL', NULL);
INSERT INTO sys_combo_values VALUES (4, 4, 'OLORS', NULL);
INSERT INTO sys_combo_values VALUES (4, 5, 'SOROLL DE TAPA', NULL);
INSERT INTO sys_combo_values VALUES (4, 6, 'OLORS AMB SOROLL', NULL);
INSERT INTO sys_combo_values VALUES (4, 7, 'OLORS AMB SOROLL I MAL ASPECTE', NULL);
INSERT INTO sys_combo_values VALUES (4, 8, 'ALTRES', NULL);




