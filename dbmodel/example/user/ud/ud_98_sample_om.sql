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


INSERT INTO config_api_form_fields VALUES (35, 'visit_emb_insp', 'visit', 'backbutton', 9, 2, true, NULL, 'button', 'Enrera', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (36, 'visit_emb_insp', 'visit', 'image1', 1, 6, true, 'bytea', 'image', NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT row_to_json(res) FROM (SELECT encode(image, ''base64'') AS image FROM config_api_images WHERE id=1) res;', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (31, 'visit_emb_insp', 'visit', 'connec_id', 1, 3, true, 'double', 'text', 'Connec id', NULL, NULL, NULL, 12, 0, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (32, 'visit_emb_insp', 'visit', 'neteja_embornals', 1, 4, true, NULL, 'combo', 'Netejat:', NULL, NULL, NULL, 12, 2, false, NULL, true, NULL, 'SELECT id, idval FROM sys_combo_values WHERE sys_combo_cat_id=1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (33, 'visit_emb_insp', 'visit', 'olors_embornals', 1, 5, true, 'string', 'text', 'Olors:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28, 'visit_emb_insp', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (30, 'visit_emb_insp', 'visit', 'visit_id', 1, 2, true, 'double', 'text', 'Visit id', NULL, NULL, NULL, 12, 0, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (34, 'visit_emb_insp', 'visit', 'acceptbutton', 9, 1, true, NULL, 'button', 'Acceptar', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwSetVisit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
