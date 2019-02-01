/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-----------------------
-- Records of om_visit_class
-----------------------
INSERT INTO om_visit_class VALUES (0, 'Open visit', 'All it''s possible, multievent and multifeature (or not)', true, NULL, NULL, NULL, 'role_om');
INSERT INTO om_visit_class VALUES (1, 'Avaria tram', NULL, true, false, false, 'ARC', 'role_om');
INSERT INTO om_visit_class VALUES (2, 'Inspecció i neteja connec', NULL, true, false, true, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (3, 'Avaria node', NULL, true, false, false, 'NODE', 'role_om');
INSERT INTO om_visit_class VALUES (4, 'Avaria connec', NULL, true, false, false, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (5, 'Inspecció i neteja tram', NULL, true, false, true, 'ARC', 'role_om');
INSERT INTO om_visit_class VALUES (6, 'Inspecció i neteja node', NULL, true, false, true, 'NODE', 'role_om');
