/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO om_visit_cat VALUES (1, 'prueba num.1','2017-12-31', NULL, NULL, TRUE);
INSERT INTO om_visit_cat VALUES (2, 'prueba num.2','2017-12-31', NULL, NULL, FALSE);
INSERT INTO om_visit_cat VALUES (3, 'prueba num.3','2017-12-31', NULL, NULL, TRUE);
INSERT INTO om_visit_cat VALUES (4, 'prueba num.4','2017-12-31', NULL, NULL, TRUE);

INSERT INTO om_visit_parameter_type VALUES ('INSPECTION');
INSERT INTO om_visit_parameter_type VALUES ('REHABIT');

INSERT INTO om_visit_parameter_form_type VALUES ('event_standard');
INSERT INTO om_visit_parameter_form_type VALUES ('event_ud_arc_rehabit');
INSERT INTO om_visit_parameter_form_type VALUES ('event_ud_arc_standard');

INSERT INTO om_visit_parameter VALUES ('insp_arc_p1', NULL, 'REHABIT', 'ARC', 'TEXT', NULL, 'Inspection arc parameter 1', 'event_ud_arc_rehabit', 'a');
INSERT INTO om_visit_parameter VALUES ('insp_arc_p2', NULL, 'REHABIT', 'ARC', 'TEXT', NULL, 'Inspection arc parameter 2', 'event_ud_arc_rehabit', 'b');
INSERT INTO om_visit_parameter VALUES ('insp_arc_p3', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Inspection arc parameter 3', 'event_ud_arc_standard', 'c');
INSERT INTO om_visit_parameter VALUES ('insp_connec_p1', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Inspection connec parameter 1', 'event_standard', 'd');
INSERT INTO om_visit_parameter VALUES ('insp_connec_p2', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Inspection connec parameter 2', 'event_standard', 'e');
INSERT INTO om_visit_parameter VALUES ('insp_node_p1', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Inspection node parameter 1', 'event_standard', 'f');
INSERT INTO om_visit_parameter VALUES ('insp_node_p2', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Inspection node parameter 2', 'event_standard', 'g');
INSERT INTO om_visit_parameter VALUES ('insp_node_p3', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Inspection node parameter 3', 'event_standard', 'i');

INSERT INTO audit_log_arc_traceability VALUES (1, 'DIVIDE ARC', '2058', '129', '130', '128', '2017-12-29 12:41:13.532596', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (2, 'DIVIDE ARC', '2057', '132', '133', '131', '2017-12-29 12:44:46.555244', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (3, 'DIVIDE ARC', '2029', '135', '136', '134', '2017-12-29 12:46:59.667326', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (4, 'DIVIDE ARC', '2033', '139', '140', '138', '2017-12-29 12:52:26.415181', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (5, 'DIVIDE ARC', '2077', '113833', '113834', '113832', '2017-12-31 13:10:48.731264', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (6, 'DIVIDE ARC', '113834', '113846', '113847', '113845', '2017-12-31 13:11:13.344406', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (7, 'DIVIDE ARC', '113847', '113853', '113854', '113852', '2017-12-31 13:11:42.24963', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (8, 'ARC FUSION', '113856', '113846', '113853', '113845', '2017-12-31 13:26:46.476997', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (9, 'ARC FUSION', '113857', '113833', '113856', '113832', '2017-12-31 13:26:46.559534', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (10, 'DIVIDE ARC', '2090', '113874', '113875', '113873', '2018-01-08 09:49:02.274617', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (11, 'DIVIDE ARC', '2206', '113881', '113882', '113880', '2018-01-08 09:49:19.243099', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (12, 'DIVIDE ARC', '2209', '113884', '113885', '113883', '2018-01-08 09:49:29.653833', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (13, 'DIVIDE ARC', '2091', '113909', '113910', '113908', '2018-01-09 07:58:49.85281', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (14, 'DIVIDE ARC', '2036', '113921', '113922', '42', '2018-01-09 12:33:30.100043', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (15, 'DIVIDE ARC', '2075', '113935', '113936', '41', '2018-01-09 12:38:14.386951', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (16, 'DIVIDE ARC', '114035', '114100', '114101', '114044', '2018-01-23 14:36:07.46449', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (17, 'DIVIDE ARC', '114100', '114103', '114104', '114102', '2018-01-23 14:37:53.375161', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (18, 'DIVIDE ARC', '114105', '114140', '114141', '114139', '2018-01-23 15:54:43.09451', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (19, 'DIVIDE ARC', '114031', '114159', '114160', '114147', '2018-01-23 16:07:45.696088', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (20, 'DIVIDE ARC', '114047', '114161', '114162', '114148', '2018-01-23 16:08:00.115394', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (21, 'DIVIDE ARC', '114048', '114163', '114164', '114149', '2018-01-23 16:08:08.12125', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (22, 'DIVIDE ARC', '114049', '114165', '114166', '114150', '2018-01-23 16:08:18.986229', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (23, 'DIVIDE ARC', '114089', '114167', '114168', '114151', '2018-01-23 16:08:25.002323', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (24, 'DIVIDE ARC', '114090', '114169', '114170', '114152', '2018-01-23 16:08:33.856595', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (25, 'DIVIDE ARC', '114058', '114171', '114172', '114153', '2018-01-23 16:08:38.440841', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (26, 'DIVIDE ARC', '114114', '114173', '114174', '114158', '2018-01-23 16:08:47.247892', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (27, 'DIVIDE ARC', '114129', '114175', '114176', '114156', '2018-01-23 16:08:51.920702', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (28, 'DIVIDE ARC', '114062', '114177', '114178', '114154', '2018-01-23 16:09:04.675523', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (29, 'DIVIDE ARC', '114115', '114179', '114180', '114155', '2018-01-23 16:09:16.248099', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (30, 'DIVIDE ARC', '114124', '114181', '114182', '114157', '2018-01-23 16:09:25.01485', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (31, 'DIVIDE ARC', '114078', '114194', '114195', '114190', '2018-01-23 16:18:23.532963', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (32, 'DIVIDE ARC', '114080', '114196', '114197', '114191', '2018-01-23 16:18:30.83579', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (33, 'DIVIDE ARC', '114135', '114198', '114199', '114188', '2018-01-23 16:18:44.364595', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (34, 'DIVIDE ARC', '114096', '114200', '114201', '114187', '2018-01-23 16:18:52.259412', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (35, 'DIVIDE ARC', '114120', '114202', '114203', '114193', '2018-01-23 16:18:58.870095', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (36, 'DIVIDE ARC', '114068', '114204', '114205', '114185', '2018-01-23 16:19:10.757245', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (37, 'DIVIDE ARC', '114063', '114206', '114207', '114183', '2018-01-23 16:19:24.051338', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (38, 'DIVIDE ARC', '114033', '114208', '114209', '114184', '2018-01-23 16:19:36.611997', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (39, 'DIVIDE ARC', '114075', '114210', '114211', '114189', '2018-01-23 16:19:47.314759', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (40, 'DIVIDE ARC', '114087', '114212', '114213', '114192', '2018-01-23 16:20:36.186321', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (41, 'DIVIDE ARC', '114122', '114215', '114216', '114186', '2018-01-23 16:22:33.945851', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (42, 'DIVIDE ARC', '114070', '114217', '114218', '114214', '2018-01-23 16:22:44.209903', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (43, 'ARC FUSION', '114219', '114198', '114199', '114188', '2018-01-23 16:24:09.003341', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (44, 'DIVIDE ARC', '114125', '114221', '114222', '114220', '2018-01-23 16:24:38.434543', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (45, 'DIVIDE ARC', '114060', '114224', '114225', '114223', '2018-01-23 16:26:46.270359', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (46, 'DIVIDE ARC', '114081', '114228', '114229', '114227', '2018-01-23 16:28:00.66198', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (47, 'DIVIDE ARC', '114074', '114231', '114232', '114230', '2018-01-23 16:28:00.66198', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (48, 'DIVIDE ARC', '114113', '114234', '114235', '114233', '2018-01-23 16:28:16.053758', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (49, 'DIVIDE ARC', '114211', '114240', '114241', '114239', '2018-01-24 14:22:47.572359', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (50, 'DIVIDE ARC', '114097', '114243', '114244', '114242', '2018-01-24 14:25:56.947317', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (51, 'DIVIDE ARC', '114228', '114246', '114247', '114245', '2018-01-24 14:29:08.225473', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (52, 'DIVIDE ARC', '114200', '114249', '114250', '114248', '2018-01-24 14:31:16.321059', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (53, 'DIVIDE ARC', '114173', '114252', '114253', '114251', '2018-01-24 14:31:16.321059', 'postgres');
INSERT INTO audit_log_arc_traceability VALUES (54, 'DIVIDE ARC', '114029', '114255', '114256', '114254', '2018-01-25 09:38:45.75678', 'postgres');


