/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO plan_psector VALUES ('ACT_02_F1', 'Expanding the capacity of the conduits located on Francesc Layret street and General Prim avenue.', 'NORMAL_PRIORITY', NULL, NULL, 'Action caused by the hydraulic insufficiency of the conduit.', NULL, 1000.00, 'sector_01', '02', 19.00, 21.00, NULL, '0106000020E764000001000000010300000001000000050000003407E979009219410C37A427737551414BD77D98C39419410C37A427737551414BD77D98C39419418E5ABC995D7551413407E979009219418E5ABC995D7551413407E979009219410C37A42773755141');
INSERT INTO plan_psector VALUES ('ACT_01_F0', 'Expanding the capacity of the conduits located on Aragó avenue and Torre de la Vila avenue.', 'HIGH_PRIORITY', NULL, NULL, 'Action caused by the hydraulic insufficiency of the conduit and serious structural problems.', NULL, 1500.00, 'sector_01', '01', 19.00, 21.00, NULL, '0106000020E764000001000000010300000001000000050000007FD83C72699319411A5EFB06157551417FD83C7269931941D8DD28FAF3745141F50B5DD084971941D8DD28FAF3745141F50B5DD0849719411A5EFB06157551417FD83C72699319411A5EFB0615755141');


INSERT INTO plan_arc_x_psector VALUES (1, 'A247', 'ACT_01_F0', '01', NULL);
INSERT INTO plan_arc_x_psector VALUES (2, 'A248', 'ACT_01_F0', '01', NULL);
INSERT INTO plan_arc_x_psector VALUES (3, 'A249', 'ACT_01_F0', '01', NULL);
INSERT INTO plan_arc_x_psector VALUES (4, 'A250', 'ACT_01_F0', '01', NULL);
INSERT INTO plan_arc_x_psector VALUES (5, 'A251', 'ACT_02_F1', '02', NULL);
INSERT INTO plan_arc_x_psector VALUES (6, 'A252', 'ACT_02_F1', '02', NULL);



INSERT INTO plan_node_x_psector VALUES (1, 'N91', 'ACT_01_F0', '01', NULL);
INSERT INTO plan_node_x_psector VALUES (2, 'N92', 'ACT_01_F0', '01', NULL);
INSERT INTO plan_node_x_psector VALUES (3, 'N94', 'ACT_01_F0', '01', NULL);
INSERT INTO plan_node_x_psector VALUES (4, 'N36', 'ACT_02_F1', '02', NULL);


INSERT INTO plan_other_x_psector VALUES (5, 'SECURITY_HEALTH', 43265.31, 'ACT_01_F0', '01', NULL);
INSERT INTO plan_other_x_psector VALUES (6, 'UNEXPECTED', 43265.31, 'ACT_01_F0', '01', NULL);
INSERT INTO plan_other_x_psector VALUES (7, 'PROTECT_SERVICES', 43265.31, 'ACT_01_F0', '01', NULL);
INSERT INTO plan_other_x_psector VALUES (8, 'SECURITY_HEALTH', 14803.42, 'ACT_02_F1', '02', NULL);
INSERT INTO plan_other_x_psector VALUES (9, 'UNEXPECTED', 14803.42, 'ACT_02_F1', '02', NULL);
INSERT INTO plan_other_x_psector VALUES (10, 'PROTECT_SERVICES', 14803.42, 'ACT_02_F1', '02', NULL);

SELECT pg_catalog.setval('plan_arc_x_psector_seq', 6, true);
SELECT pg_catalog.setval('plan_node_x_psector_seq', 4, true);
SELECT pg_catalog.setval('plan_other_x_psector_seq', 10, true);