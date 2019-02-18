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


-----------------------
-- config api values
-----------------------

INSERT INTO config_api_form_tabs VALUES (1,'filters','tabExploitation','Explotacions','Explotacions actives',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (2,'filters','tabNetworkState','Elements xarxa','Elements de xarxa',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (3,'filters','tabHydroState','Abonats','Abonats',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (7,'search','tab_network','Xarxa','Elements de xarxa',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (8,'search_','tab_search','Cercador','Carrerer API web',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (9,'search','tab_address','Carrerer','Carrerer dades PG',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (10,'search','tab_hydro','Abonat','Abonat',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (11,'search','tab_workcat','Expedient','Expedients',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (12,'search','tab_psector','Psector','Sectors de planejament',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (204,'ve_node','tab_elements','Elem','Lista de elementos relacionados',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (206,'ve_node','tab_connections','Conn','{"Elementos aguas arriba"','"Elementos aguas abajo"}',NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (207,'ve_node','tab_visit','Visit','Lista de eventos del elemento',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (208,'ve_node','tab_documents','Doc','Lista de documentos',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (210,'ve_node','tab_plan','Cost','Partidas del elemento',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (302,'ve_arc','tab_elements','Elem','Lista de elementos relacionados',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (303,'ve_arc','tab_relations','Rel','Lista de relaciones',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (306,'ve_arc','tab_om','OM','Lista de eventos del elemento',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (307,'ve_arc','tab_documents','Doc','Lista de documentos',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (309,'ve_arc','tab_plan','Cos','Partidas del elemento',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (311,'ve_arc','tab_visit','Visit','Lista de eventos del elemento',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (408,'ve_connec','tab_elements','Elem','Lista de elementos relacionados',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (409,'ve_connec','tab_hydrometer','Abonados','Lista de abonados',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (411,'ve_connec','tab_visit','Visit','Lista de eventos del elemento',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (412,'ve_connec','tab_documents','Doc','Lista de documentos',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (500,'config','tabUser','User',NULL,'role_basic',NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (560,'config','tabAdmin','Admin',NULL,'role_admin',NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (561,'ve_arc','tab_inp','EPA inp',NULL,'role_epa',NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (562,'ve_arc','tab_rpt','EPA results',NULL,'role_om',NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (563,'ve_node','tab_inp','EPA inp',NULL,'role_epa',NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (564,'ve_node','tab_rpt','EPA results',NULL,'role_om',NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (565,'search','tab_visit','Visita','Visita',NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (566,'ve_connec','tab_hydrometer_val','Consumos','Valores de consumo para abonado',NULL,NULL,NULL,NULL);

-----------------------
-- add api parameter config param system
-----------------------

INSERT INTO config_param_system VALUES (90,'ApiVersion','0.9.101',NULL,NULL,NULL,NULL,NULL,NULL,TRUE,NULL,NULL,NULL,TRUE,TRUE,NULL,NULL,NULL);
