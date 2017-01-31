/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO plan_psector VALUES ('ACT_01_F1', 'Expanding the capacity of the pipes located on Francesc Layret street.', 'NORMAL_PRIORITY', NULL, NULL, 'Action caused by the headloss of the pipe.', NULL, 750.00, 'sector_01', '01', 19.00, 21.00, NULL, '0106000020E7640000010000000103000000010000000500000062EBC6A727941941B58BF9D6467551417EBB5BC63A961941B58BF9D6467551417EBB5BC63A961941057CDEC53675514162EBC6A727941941047CDEC53675514162EBC6A727941941B58BF9D646755141');
INSERT INTO plan_psector VALUES ('ACT_02_F2', 'Expanding the capacity of the pipes located on Legalitat street.', 'LOW_PRIORITY', NULL, NULL, 'Action caused by the headloss of the pipe.', 90.0000, 750.00, 'sector_01', '02', 19.00, 21.00, NULL, '0106000020E7640000010000000103000000010000000500000076C2E9BF34941941DBAB60D39875514166D2E9BF34941941DA5E77A17775514166D738AE339319415E5E77A17775514166C738AE339319415FAB60D39875514176C2E9BF34941941DBAB60D398755141');



INSERT INTO plan_arc_x_psector VALUES (1, '2085_b', 'ACT_01_F1', '01', NULL);
INSERT INTO plan_arc_x_psector VALUES (2, '2086_b', 'ACT_01_F1', '01', NULL);
INSERT INTO plan_arc_x_psector VALUES (4, '2065_b', 'ACT_02_F2', '02', NULL);

INSERT INTO plan_node_x_psector VALUES (2, '1076_b', 'ACT_01_F1', '01', NULL);


INSERT INTO plan_other_x_psector VALUES (1, 'SECURITY_HEALTH', 9360.12, 'ACT_01_F1', '01', 'Safety and health in works');
INSERT INTO plan_other_x_psector VALUES (2, 'PROTEC_SERVIS', 9360.12, 'ACT_01_F1', '01', 'Proteccion of existing services');
INSERT INTO plan_other_x_psector VALUES (3, 'N_T110-63_PN16', 1.00, 'ACT_01_F1', '01', 'Reconstruct node type T110-63-63 mm');
INSERT INTO plan_other_x_psector VALUES (4, 'N_T110-110_PN16', 1.00, 'ACT_01_F1', '01', 'Reconstruct node type T110-110-110 mm');
INSERT INTO plan_other_x_psector VALUES (5, 'SECURITY_HEALTH', 5991.72, 'ACT_02_F2', '02', 'Safety and health in works');
INSERT INTO plan_other_x_psector VALUES (8, 'N_T160-110_PN16', 1.00, 'ACT_02_F2', '02', 'Reconstruct node type T150-150-110 mm');
INSERT INTO plan_other_x_psector VALUES (7, 'N_T110-63_PN16', 1.00, 'ACT_02_F2', '02', 'Reconstruct node type T110-63-63 mm');
INSERT INTO plan_other_x_psector VALUES (6, 'PROTEC_SERVIS', 5991.72, 'ACT_02_F2', '02', 'Proteccion of existing services');



SELECT pg_catalog.setval('plan_arc_x_pavement_seq', 1008, true);
SELECT pg_catalog.setval('plan_arc_x_psector_seq', 4, true);
SELECT pg_catalog.setval('plan_node_x_psector_seq', 5, true);
SELECT pg_catalog.setval('plan_other_x_psector_seq', 9, true);