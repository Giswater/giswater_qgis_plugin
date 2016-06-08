/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



INSERT INTO "SCHEMA_NAME".cat_doc VALUES ('AS_BUILT', 'AS_BUILT', NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_doc VALUES ('OTHER', 'OTHER', NULL, NULL);
INSERT INTO "SCHEMA_NAME".cat_doc VALUES ('INCIDENT', 'INCIDENT', NULL, NULL);


-- INSERT INTO "SCHEMA_NAME".cat_tag VALUES ('NO TAG', NULL);
INSERT INTO "SCHEMA_NAME".cat_tag VALUES ('PRIORITY NORMAL', NULL);
INSERT INTO "SCHEMA_NAME".cat_tag VALUES ('PRIORITY HIGH', NULL);


INSERT INTO "SCHEMA_NAME".doc VALUES (2, 'INCIDENT', 'c:/docs/incident.pdf', 'Incident from public works', 'PRIORITY HIGH', '2016-05-31 14:20:25', 'postgres');
INSERT INTO "SCHEMA_NAME".doc VALUES (3, 'OTHER', 'c:/docs/other.pdf', 'Other', 'PRIORITY HIGH', '2016-05-31 14:21:03', 'postgres');
INSERT INTO "SCHEMA_NAME".doc VALUES (1, 'AS_BUILT', 'c:/docs/doc.pdf', 'As built documentation', 'PRIORITY HIGH', '2016-05-31 14:19:39', 'postgres');



INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (7, 2, '2001');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (8, 2, '2002');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (9, 2, '2003');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (10, 2, '2004');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (11, 2, '2005');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (12, 2, '2006');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (13, 3, '2001');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (14, 3, '2002');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (15, 3, '2003');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (16, 3, '2004');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (1, 1, '2001');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (2, 1, '2002');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (3, 1, '2003');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (4, 1, '2004');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (5, 1, '2005');
INSERT INTO "SCHEMA_NAME".doc_x_arc VALUES (6, 1, '2006');




INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (10, 2, '3001');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (11, 2, '3002');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (12, 2, '3003');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (13, 2, '3004');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (14, 2, '3005');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (15, 2, '3006');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (16, 3, '3001');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (17, 3, '3002');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (18, 3, '3003');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (19, 3, '3004');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (20, 3, '3005');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (21, 3, '3006');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (22, 3, '3007');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (23, 3, '3008');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (1, 1, '3001');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (2, 1, '3002');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (3, 1, '3003');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (4, 1, '3004');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (5, 1, '3005');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (6, 1, '3006');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (7, 1, '3007');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (8, 1, '3008');
INSERT INTO "SCHEMA_NAME".doc_x_connec VALUES (9, 1, '3009');




INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (9, 2, '1001');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (10, 2, '1002');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (11, 2, '1003');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (12, 2, '1004');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (13, 2, '1005');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (14, 3, '1001');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (15, 3, '1002');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (16, 3, '1003');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (17, 3, '1004');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (18, 3, '1005');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (19, 3, '1006');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (1, 1, '1001');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (2, 1, '1002');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (3, 1, '1003');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (4, 1, '1004');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (5, 1, '1005');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (6, 1, '1006');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (7, 1, '1007');
INSERT INTO "SCHEMA_NAME".doc_x_node VALUES (8, 1, '1008');




SELECT pg_catalog.setval('"SCHEMA_NAME".doc_x_node_seq', 20, true);
SELECT pg_catalog.setval('"SCHEMA_NAME".doc_x_arc_seq', 17, true);
SELECT pg_catalog.setval('"SCHEMA_NAME".doc_x_connec_seq', 24, true);