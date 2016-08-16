/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- INSERT INTOcat_tag VALUES ('NO TAG', NULL);
INSERT INTO cat_tag VALUES ('PRIORITY NORMAL', NULL);
INSERT INTO cat_tag VALUES ('PRIORITY HIGH', NULL);


INSERT INTO doc VALUES (2, 'INCIDENT', 'c:/docs/incident.pdf', 'Incident from public works', 'PRIORITY HIGH', '2016-05-31 14:20:25', 'postgres');
INSERT INTO doc VALUES (3, 'OTHER', 'c:/docs/other.pdf', 'Other', 'PRIORITY HIGH', '2016-05-31 14:21:03', 'postgres');
INSERT INTO doc VALUES (1, 'AS_BUILT', 'c:/docs/doc.pdf', 'As built documentation', 'PRIORITY HIGH', '2016-05-31 14:19:39', 'postgres');



INSERT INTO doc_x_arc VALUES (7, 2, 'A141');
INSERT INTO doc_x_arc VALUES (8, 2, 'A142');
INSERT INTO doc_x_arc VALUES (9, 2, 'A143');
INSERT INTO doc_x_arc VALUES (10, 2, 'A144');
INSERT INTO doc_x_arc VALUES (11, 2, 'A145');
INSERT INTO doc_x_arc VALUES (12, 2, 'A146');
INSERT INTO doc_x_arc VALUES (13, 3, 'A141');
INSERT INTO doc_x_arc VALUES (14, 3, 'A142');
INSERT INTO doc_x_arc VALUES (15, 3, 'A143');
INSERT INTO doc_x_arc VALUES (16, 3, 'A144');
INSERT INTO doc_x_arc VALUES (1, 1, 'A141');
INSERT INTO doc_x_arc VALUES (2, 1, 'A142');
INSERT INTO doc_x_arc VALUES (3, 1, 'A143');
INSERT INTO doc_x_arc VALUES (4, 1, 'A144');
INSERT INTO doc_x_arc VALUES (5, 1, 'A145');
INSERT INTO doc_x_arc VALUES (6, 1, 'A146');




INSERT INTO doc_x_connec VALUES (10, 2, '3001');
INSERT INTO doc_x_connec VALUES (11, 2, '3002');
INSERT INTO doc_x_connec VALUES (12, 2, '3003');
INSERT INTO doc_x_connec VALUES (13, 2, '3004');
INSERT INTO doc_x_connec VALUES (14, 2, '3005');
INSERT INTO doc_x_connec VALUES (15, 2, '3006');
INSERT INTO doc_x_connec VALUES (16, 3, '3001');
INSERT INTO doc_x_connec VALUES (17, 3, '3002');
INSERT INTO doc_x_connec VALUES (18, 3, '3003');
INSERT INTO doc_x_connec VALUES (19, 3, '3004');
INSERT INTO doc_x_connec VALUES (20, 3, '3005');
INSERT INTO doc_x_connec VALUES (21, 3, '3006');
INSERT INTO doc_x_connec VALUES (22, 3, '3007');
INSERT INTO doc_x_connec VALUES (23, 3, '3008');
INSERT INTO doc_x_connec VALUES (1, 1, '3001');
INSERT INTO doc_x_connec VALUES (2, 1, '3002');
INSERT INTO doc_x_connec VALUES (3, 1, '3003');
INSERT INTO doc_x_connec VALUES (4, 1, '3004');
INSERT INTO doc_x_connec VALUES (5, 1, '3005');
INSERT INTO doc_x_connec VALUES (6, 1, '3006');
INSERT INTO doc_x_connec VALUES (7, 1, '3007');
INSERT INTO doc_x_connec VALUES (8, 1, '3008');
INSERT INTO doc_x_connec VALUES (9, 1, '3009');




INSERT INTO doc_x_node VALUES (9, 2, 'N101');
INSERT INTO doc_x_node VALUES (10, 2, 'N102');
INSERT INTO doc_x_node VALUES (11, 2, 'N93');
INSERT INTO doc_x_node VALUES (12, 2, 'N104');
INSERT INTO doc_x_node VALUES (13, 2, 'N105');
INSERT INTO doc_x_node VALUES (14, 3, 'N101');
INSERT INTO doc_x_node VALUES (15, 3, 'N102');
INSERT INTO doc_x_node VALUES (16, 3, 'N93');
INSERT INTO doc_x_node VALUES (17, 3, 'N104');
INSERT INTO doc_x_node VALUES (18, 3, 'N105');
INSERT INTO doc_x_node VALUES (19, 3, 'N106');
INSERT INTO doc_x_node VALUES (1, 1, 'N101');
INSERT INTO doc_x_node VALUES (2, 1, 'N102');
INSERT INTO doc_x_node VALUES (3, 1, 'N93');
INSERT INTO doc_x_node VALUES (4, 1, 'N104');
INSERT INTO doc_x_node VALUES (5, 1, 'N105');
INSERT INTO doc_x_node VALUES (6, 1, 'N106');
INSERT INTO doc_x_node VALUES (7, 1, 'N107');
INSERT INTO doc_x_node VALUES (8, 1, 'N108');


INSERT INTO doc_x_gully VALUES (1, 2, '10');
INSERT INTO doc_x_gully VALUES (2, 2, '11');
INSERT INTO doc_x_gully VALUES (3, 2, '12');
INSERT INTO doc_x_gully VALUES (4, 2, '13');
INSERT INTO doc_x_gully VALUES (5, 2, '14');
INSERT INTO doc_x_gully VALUES (6, 2, '15');
INSERT INTO doc_x_gully VALUES (7, 2, '16');
INSERT INTO doc_x_gully VALUES (8, 2, '17');
INSERT INTO doc_x_gully VALUES (9, 3, '18');
INSERT INTO doc_x_gully VALUES (10, 3, '19');
INSERT INTO doc_x_gully VALUES (11, 3, '20');
INSERT INTO doc_x_gully VALUES (12, 3, '21');
INSERT INTO doc_x_gully VALUES (13, 3, '22');
INSERT INTO doc_x_gully VALUES (14, 3, '23');
INSERT INTO doc_x_gully VALUES (15, 3, '24');
INSERT INTO doc_x_gully VALUES (16, 1, '25');
INSERT INTO doc_x_gully VALUES (17, 1, '26');
INSERT INTO doc_x_gully VALUES (18, 1, '27');
INSERT INTO doc_x_gully VALUES (19, 1, '28');
INSERT INTO doc_x_gully VALUES (20, 1, '29');
INSERT INTO doc_x_gully VALUES (21, 1, '30');
INSERT INTO doc_x_gully VALUES (22, 1, '31');
INSERT INTO doc_x_gully VALUES (23, 1, '32');
INSERT INTO doc_x_gully VALUES (24, 1, '33');
INSERT INTO doc_x_gully VALUES (25, 3, '34');
INSERT INTO doc_x_gully VALUES (26, 3, '35');
INSERT INTO doc_x_gully VALUES (27, 3, '36');
INSERT INTO doc_x_gully VALUES (28, 3, '37');
INSERT INTO doc_x_gully VALUES (29, 3, '38');
INSERT INTO doc_x_gully VALUES (30, 3, '39');
INSERT INTO doc_x_gully VALUES (113, 3, '913');
INSERT INTO doc_x_gully VALUES (115, 3, '915');
INSERT INTO doc_x_gully VALUES (117, 2, '917');
INSERT INTO doc_x_gully VALUES (114, 1, '914');
INSERT INTO doc_x_gully VALUES (118, 2, '918');




SELECT pg_catalog.setval('doc_x_node_seq', 20, true);
SELECT pg_catalog.setval('doc_x_arc_seq', 17, true);
SELECT pg_catalog.setval('doc_x_connec_seq', 24, true);
SELECT pg_catalog.setval('doc_x_gully_seq', 119, true);