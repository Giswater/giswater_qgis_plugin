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

