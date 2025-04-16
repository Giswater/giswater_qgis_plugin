/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

/*
INSERT INTO sys_table VALUES ('cat_team', 'Catalog of teams', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_campaign_lot', 'Table with all lots that took place', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('selector_lot', 'Selector of lots', 'role_basic', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_campaign_lot_x_arc', 'Table of arcs related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_campaign_lot_x_connec', 'Table of connecs related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_campaign_lot_x_node', 'Table of nodes related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('config_visit_class_x_workorder', 'Table of visit classes related to its workorders', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ext_workorder_type', 'Table of workorders related to its types', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ext_workorder_class', 'Table of workorders related to its classes', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('ext_workorder', 'External table of workorders', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_team_x_user', 'Relation between teams and their users', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, 'lot_plugin') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table VALUES ('om_visit_lot_x_gully', 'Table of gullys related to lots', 'role_om', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_function VALUES (2898, 'gw_fct_getlot', 'lot_manage', 'function', 'json', 'json', 'Function to provide lot form', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2862, 'gw_fct_setlot', 'lot_manage', 'function', 'json', 'json', 'Set lot', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2640, 'gw_fct_getvisitmanager', 'lot_manage', 'function', 'json', 'json', 'To call visit from user', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2882, 'gw_fct_setvisitmanager', 'lot_manage', 'function', 'json', 'json', 'Function to manage visit manager', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2997, 'gw_fct_lot_psector_geom', 'lot_manage', 'function', 'json', 'json', 'Function to set the_geom of the psector after its insert', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2838, 'gw_trg_edit_cat_team', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_edit_cat_team', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2842, 'gw_trg_edit_lot_x_user', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_lot_x_user', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2834, 'gw_trg_edit_team_x_user', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_team_x_user', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_function VALUES (2836, 'gw_trg_edit_team_x_visitclass', 'utils', 'trigger function', NULL, NULL, 'Makes editable v_om_team_x_visitclass', 'role_om', NULL, NULL) ON CONFLICT (id) DO NOTHING;
*/


INSERT INTO sys_typevalue VALUES ('campaign_status', 1, 'PLANIFYING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 2, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 3, 'ASSIGNED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 4, 'ON GOING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 5, 'STAND-BY', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 6, 'EXECUTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 7, 'REJECTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 8, 'READY-TO-ACCEPT', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 9, 'ACCEPTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_status', 10, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_typevalue VALUES ('lot_status', 1, 'PLANIFYING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 2, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 3, 'ASSIGNED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 4, 'ON GOING', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 5, 'STAND-BY', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 6, 'EXECUTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 7, 'REJECTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 8, 'READY-TO-ACCEPT', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 9, 'ACCEPTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_status', 10, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 1, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 2, 'NOT VISITED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 3, 'VISITED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 4, 'VISIT AGAIN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 5, 'ACCEPTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('campaign_feature_status', 6, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_typevalue VALUES ('lot_feature_status', 1, 'PLANIFIED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 2, 'NOT VISITED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 3, 'VISITED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 4, 'VISIT AGAIN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 5, 'ACCEPTED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_typevalue VALUES ('lot_feature_status', 6, 'CANCELED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;