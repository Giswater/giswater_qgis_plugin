/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_api_form_fields VALUES (28220, 'visit_arc_insp', 'visit', 'visit_id', 1, 1, true, NULL, 'linetext', 'Visit id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28230, 'visit_arc_insp', 'visit', 'arc_id', 1, 2, true, NULL, 'linetext', 'Arc_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28250, 'visit_arc_insp', 'visit', 'visit_code', 1, 4, true, NULL, 'linetext', 'visit_code', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28260, 'visit_arc_insp', 'visit', 'sediments_arc', 1, 5, true, NULL, 'linetext', 'Sediments:', NULL, NULL, 'Ex.: 10 (en cmts.)', 12, 2, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28270, 'visit_arc_insp', 'visit', 'desperfectes_arc', 1, 6, true, NULL, 'linetext', 'Despefectes:', NULL, NULL, 'Ex.: 10 (en cmts.)', 12, 2, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28280, 'visit_arc_insp', 'visit', 'neteja_arc', 1, 7, true, NULL, 'combo', 'Netejat:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28070, 'visit_node_insp', 'visit', 'visit_id', 1, 1, true, NULL, 'linetext', 'Visit id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28090, 'visit_node_insp', 'visit', 'visitcat_id', 1, 3, true, NULL, 'combo', 'visitcat_id', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28100, 'visit_node_insp', 'visit', 'visit_code', 1, 4, true, NULL, 'linetext', 'visit_code', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28140, 'visit_connec_leak', 'visit', 'event_id', 1, 1, true, NULL, 'linetext', 'event_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28160, 'visit_connec_leak', 'visit', 'visitcat_id', 1, 3, true, NULL, 'combo', 'visitcat_id', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28170, 'visit_connec_leak', 'visit', 'visit_code', 1, 4, true, NULL, 'linetext', 'visit_code', NULL, NULL, 'Ex.: Work order code', NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28240, 'visit_arc_insp', 'visit', 'visitcat_id', 1, 3, true, NULL, 'combo', 'visitcat_id', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28080, 'visit_node_insp', 'visit', 'node_id', 1, 2, true, NULL, 'linetext', 'Node_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28120, 'visit_node_insp', 'visit', 'desperfectes_node', 1, 6, true, NULL, 'linetext', 'Despefectes:', NULL, NULL, 'Ex.: 10 (en cmts.)', 12, 2, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (28218, 'visit_arc_insp', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_api_form_fields VALUES (28138, 'visit_connec_leak', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_api_form_fields VALUES (28068, 'visit_node_insp', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_api_form_fields VALUES (27988, 'visit_node_leak', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_api_form_fields VALUES (27298, 'visit_connec_insp', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_api_form_fields VALUES (27218, 'visit_arc_leak', 'visit', 'class_id', 1, 1, true, NULL, 'combo', 'Tipus visita:', NULL, NULL, NULL, NULL, NULL, true, NULL, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL);
INSERT INTO config_api_form_fields VALUES (27300, 'visit_connec_insp', 'visit', 'visit_id', 1, 1, true, 'integer', 'linetext', 'Visit id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (27280, 'visit_arc_leak', 'visit', 'position_value', 1, 7, true, 'integer', 'linetext', 'position_value', NULL, NULL, 'Ex.: 34.57', 12, 2, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (27360, 'visit_connec_insp', 'visit', 'neteja_connec', 1, 7, true, 'string', 'combo', 'Netejat:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (27220, 'visit_arc_leak', 'visit', 'event_id', 1, 1, true, 'integer', 'linetext', 'event_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields VALUES (27230, 'visit_arc_leak', 'visit', 'visit_id', 1, 2, true, 'integer', 'linetext', 'visit_id', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);



INSERT INTO config_api_form_groupbox VALUES (12, 'go2epa', 1, 'Pre-process options');
INSERT INTO config_api_form_groupbox VALUES (13, 'go2epa', 2, 'File manager');
INSERT INTO config_api_form_groupbox VALUES (14, 'epaoptions', 1, 'Options');
INSERT INTO config_api_form_groupbox VALUES (15, 'epaoptions', 2, 'Times');
INSERT INTO config_api_form_groupbox VALUES (16, 'epaoptions', 3, 'Report');
INSERT INTO config_api_form_groupbox VALUES (1, 'config', 1, 'gb1');
INSERT INTO config_api_form_groupbox VALUES (11, 'config', 99, 'gb99');
INSERT INTO config_api_form_groupbox VALUES (2, 'config', 2, 'gb2');
INSERT INTO config_api_form_groupbox VALUES (3, 'config', 3, 'gb3');
INSERT INTO config_api_form_groupbox VALUES (4, 'config', 4, 'gb4');
INSERT INTO config_api_form_groupbox VALUES (5, 'config', 5, 'gb5');
INSERT INTO config_api_form_groupbox VALUES (6, 'config', 6, 'gb6');
INSERT INTO config_api_form_groupbox VALUES (7, 'config', 7, 'gb7');
INSERT INTO config_api_form_groupbox VALUES (8, 'config', 8, 'gb8');
INSERT INTO config_api_form_groupbox VALUES (9, 'config', 9, 'gb9');
INSERT INTO config_api_form_groupbox VALUES (10, 'config', 10, 'gb10');