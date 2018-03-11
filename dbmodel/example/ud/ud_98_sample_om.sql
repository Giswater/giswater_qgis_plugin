/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO om_visit_cat VALUES (1, 'Test','2018-01-01','2018-01-02', NULL);


INSERT INTO om_visit_parameter VALUES ('Arc rehabit type 1', NULL, 'REHABIT', 'ARC', 'TEXT', NULL, 'Inspection arc parameter 1', 'event_ud_arc_rehabit', 'a');
INSERT INTO om_visit_parameter VALUES ('Arc rehabit type 2', NULL, 'REHABIT', 'ARC', 'TEXT', NULL, 'Inspection arc parameter 2', 'event_ud_arc_rehabit', 'b');
INSERT INTO om_visit_parameter VALUES ('Arc inspection type 1', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Inspection arc parameter 3', 'event_ud_arc_standard', 'c');
INSERT INTO om_visit_parameter VALUES ('Arc inspection type 2', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Inspection arc parameter 4', 'event_ud_arc_standard', 'f');
INSERT INTO om_visit_parameter VALUES ('Connec inspection type 1', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Inspection connec parameter 1', 'event_standard', 'd');
INSERT INTO om_visit_parameter VALUES ('Connec inspection type 2', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Inspection connec parameter 2', 'event_standard', 'e');
INSERT INTO om_visit_parameter VALUES ('Node inspection type 1', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Inspection node parameter 1', 'event_standard', 'f');
INSERT INTO om_visit_parameter VALUES ('Node inspection type 2', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Inspection node parameter 2', 'event_standard', 'g');
INSERT INTO om_visit_parameter VALUES ('Node inspection type 3', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Inspection node parameter 3', 'event_standard', 'i');
INSERT INTO om_visit_parameter VALUES ('Gully inspection type 1', NULL, 'INSPECTION', 'GULLY', 'TEXT', NULL, 'Inspection gully parameter 1', 'event_standard', 'd');
INSERT INTO om_visit_parameter VALUES ('Gully inspection type 2', NULL, 'INSPECTION', 'GULLY', 'TEXT', NULL, 'Inspection gully parameter 2', 'event_standard', 'e');


