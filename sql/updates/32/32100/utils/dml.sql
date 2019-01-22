/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Deprecated sequences
-- todo: insert all deprecated sequences on audit_cat_sequence

-- Deprecated tables and views
-- todo: UPDATE audit_cat_table SET isdeprecated=TRUE where id='config';

-- Deprecated functions
--todo: UPDATE audit_cat_functions SET isdeprecated=TRUE where id='config';




-----------------------
-- config_param_system
-----------------------
-- network 
UPDATE config_param_system SET value='{"sys_table_id":"ve_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby" :"1", "feature_type":"arc_id"}' WHERE parameter='api_search_arc';
UPDATE config_param_system SET value='{"sys_table_id":"ve_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2", "feature_type":"node_id"}' WHERE parameter='api_search_node';
UPDATE config_param_system SET value='{"sys_table_id":"ve_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Escomeses", "cat_field":"connecat_id", "orderby":"3", "feature_type":"connec_id"}' WHERE parameter='api_search_connec';
UPDATE  config_param_system SET value='{"sys_table_id":"ve_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5", "feature_type":"element_id"}' WHERE parameter='api_search_element';
-- psector
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_plan_psector","WARNING":"sys_table_id only web, python is hardcoded: v_edit_plan_psector as self.plan_om =''plan''", "sys_id_field":"psector_id", "sys_search_field":"name", "sys_parent_field":"expl_id", "sys_geom_field":"the_geom"}'
WHERE parameter='api_search_psector';

INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('nodeisert_arcendpoint', 'FALSE', 'boolean', 'edit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('orphannode_delete', 'false', 'boolean', NULL, NULL, 4, 3, 'Orphan node delete:', NULL, NULL, true, 1, 13, 6, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('nodetype_change_enabled', 'FALSE', 'boolean', NULL, NULL, 4, 3, 'nodetype_change_enabled', NULL, NULL, true, 1, 13, 12, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('samenode_init_end_control', 'true', NULL, NULL, NULL, 4, 3, 'Arc same node init end control:', NULL, NULL, true, NULL, 13, 2, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('audit_function_control', 'TRUE', 'boolean', NULL, NULL, 4, 3, 'audit_function_control', NULL, NULL, false, 1, NULL, NULL, NULL, false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('insert_double_geometry', 'false', 'boolean', NULL, NULL, 4, 3, 'Double geometry enabled:', NULL, NULL, true, 1, 13, 5, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('buffer_value', '3.0', 'double precision', NULL, NULL, 5, 7, 'Double geometry enabled:', NULL, NULL, true, 1, 13, 5, 'utils', false, false, 'double', 'spinbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('node_proximity_control', 'true', 'boolean', NULL, NULL, 4, 3, 'Node proximity control:', NULL, NULL, true, 1, 13, 3, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('arc_searchnodes_control', 'true', 'boolean', NULL, NULL, 4, 3, 'Arc searchnodes buffer:', NULL, NULL, true, 1, 13, 1, 'utils', false, false, 'boolean', 'checkbox', NULL);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, dt, wt, label, dv_querytext, dv_filterbyfield, isenabled, orderby, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) VALUES ('connec_proximity_control', 'true', 'boolean', NULL, NULL, 4, 3, 'Connec proximity control:', NULL, NULL, true, 1, 13, 4, 'utils', false, false, 'boolean', 'checkbox', NULL);


-----------------------
-- config_param_user
-----------------------
/*
INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, qgis_message, data_type, label, dv_querytext, dv_parent_id, isenabled, layout_id, layout_order, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, vdefault, ischeckeditable, widgetcontrols) VALUES ('arc_searchnodes', 'config', NULL, 'role_edit', NULL, 'text', 'Arc searchnodes:', NULL, NULL, true, 8, 5, 'utils', false, NULL, NULL, NULL, false, 'float', 'spinbox', '0.1', false, '{"minValue":0.01, "maxValue":1}');
INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, qgis_message, data_type, label, dv_querytext, dv_parent_id, isenabled, layout_id, layout_order, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, vdefault, ischeckeditable, widgetcontrols) VALUES ('node_proximity', 'config', NULL, 'role_edit', NULL, 'float', 'Node proximity:', NULL, NULL, true, 8, 6, 'utils', false, NULL, NULL, NULL, false, 'double', 'spinbox', '0.1', false, '{"minValue":0.01, "maxValue":1}');
INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, qgis_message, data_type, label, dv_querytext, dv_parent_id, isenabled, layout_id, layout_order, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, vdefault, ischeckeditable, widgetcontrols) VALUES ('connec_proximity', 'config', NULL, 'role_edit', NULL, 'text', 'Connec proximity:', NULL, NULL, true, 8, 7, 'utils', false, NULL, NULL, NULL, false, 'float', 'spinbox', '0.1', false, '{"minValue":0.01, "maxValue":1}');
INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, qgis_message, data_type, label, dv_querytext, dv_parent_id, isenabled, layout_id, layout_order, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, vdefault, ischeckeditable, widgetcontrols) VALUES ('node_duplicated_tolerance', 'config', NULL, 'role_edit', NULL, 'text', 'Node duplicated tolerance:', NULL, NULL, true, 8, 8, 'utils', false, NULL, NULL, NULL, false, 'float', 'spinbox', '0.1', false, '{"minValue":0.01, "maxValue":1}');
INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, qgis_message, data_type, label, dv_querytext, dv_parent_id, isenabled, layout_id, layout_order, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, vdefault, ischeckeditable, widgetcontrols) VALUES ('vnode_update_tolerance', 'config', NULL, 'role_edit', NULL, 'text', 'Vnode update tolerance:', NULL, NULL, true, 8, 9, 'utils', false, NULL, NULL, NULL, false, 'float', 'spinbox', '0.1', false, '{"minValue":0.01, "maxValue":1}');
INSERT INTO audit_cat_param_user (id, formname, description, sys_role_id, qgis_message, data_type, label, dv_querytext, dv_parent_id, isenabled, layout_id, layout_order, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, datatype, widgettype, vdefault, ischeckeditable, widgetcontrols) VALUES ('node2arc', 'config', NULL, 'role_edit', NULL, 'text', 'Node2arc:', NULL, NULL, true, 8, 10, 'utils', false, NULL, NULL, NULL, false, 'float', 'spinbox', '0.1', false, '{"minValue":0.01, "maxValue":1}');
*/

-----------------------
-- sys_csv2pg_cat
-----------------------
INSERT INTO sys_csv2pg_cat VALUES (9, 'Export inp', 'Export inp', null, 'role_epa');
INSERT INTO sys_csv2pg_cat VALUES (10, 'Import rpt', 'Import rpt', null, 'role_epa');
INSERT INTO sys_csv2pg_cat VALUES (11, 'Import inp', 'Import inp', null, 'role_admin');
