/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO om_visit_cat VALUES (1, 'prueba num.1','2017-1-1', '2017-3-31', NULL, FALSE);
INSERT INTO om_visit_cat VALUES (2, 'prueba num.2','2017-4-1', '2017-7-31', NULL, FALSE);
INSERT INTO om_visit_cat VALUES (3, 'prueba num.3','2017-8-1', '2017-9-30', NULL, TRUE);
INSERT INTO om_visit_cat VALUES (4, 'prueba num.4','2017-10-1', '2017-12-31', NULL, TRUE);


INSERT INTO om_visit_parameter VALUES ('Arc rehabit type 1', NULL, 'REHABIT', 'ARC', 'TEXT', NULL, 'Rehabilitation arc parameter 1', 'event_ud_arc_rehabit', 'a');
INSERT INTO om_visit_parameter VALUES ('Arc rehabit type 2', NULL, 'REHABIT', 'ARC', 'TEXT', NULL, 'Rehabilitation arc parameter 2', 'event_ud_arc_rehabit', 'b');
INSERT INTO om_visit_parameter VALUES ('Arc inspection type 1', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Inspection arc parameter 1', 'event_ud_arc_standard', 'c');
INSERT INTO om_visit_parameter VALUES ('Arc inspection type 2', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Inspection arc parameter 2', 'event_ud_arc_standard', 'f');
INSERT INTO om_visit_parameter VALUES ('Connec inspection type 1', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Inspection connec parameter 1', 'event_standard', 'd', true);
INSERT INTO om_visit_parameter VALUES ('Connec inspection type 2', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Inspection connec parameter 2', 'event_standard', 'e', true);
INSERT INTO om_visit_parameter VALUES ('Node inspection type 1', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Inspection node parameter 1', 'event_standard', 'f', true);
INSERT INTO om_visit_parameter VALUES ('Node inspection type 2', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Inspection node parameter 2', 'event_standard', 'g', true);
INSERT INTO om_visit_parameter VALUES ('Node inspection type 3', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Inspection node parameter 3', 'event_standard', 'i', true);
INSERT INTO om_visit_parameter VALUES ('Gully inspection type 1', NULL, 'INSPECTION', 'GULLY', 'TEXT', NULL, 'Inspection gully parameter 1', 'event_standard', 'd', true);
INSERT INTO om_visit_parameter VALUES ('Gully inspection type 2', NULL, 'INSPECTION', 'GULLY', 'TEXT', NULL, 'Inspection gully parameter 2', 'event_standard', 'e', true);


