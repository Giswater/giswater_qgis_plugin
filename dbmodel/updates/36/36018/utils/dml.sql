/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system SET
value = '{"table":"temp_municipality","selector":"selector_municipality","table_id":"muni_id","selector_id":"muni_id","label":"muni_id, ''-'', name","orderBy":"muni_id","manageAll":true,"query_filter":"","typeaheadFilter":" AND lower(concat(muni_id, '' - '', name))","selectionMode":"keepPreviousUsingShift", "orderbyCheck":false}'
WHERE parameter = 'basic_selector_tab_municipality';


-- 24/03/2025
-- Create user parameter for edit_disable_locklevel
INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('edit_disable_locklevel', 'hidden', 'Temporarily disable lock level for specific operations', 'role_edit', NULL, 'Disable lock level', NULL, NULL, true, NULL, 'utils', false, NULL, NULL, NULL, false, 'json', 'linetext', true, NULL, '{"update":false, "delete":false}', NULL, true, NULL, NULL, NULL, NULL, 'core');
-- INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('edit_disable_locklevel', '{"update":"false", "delete":"false"}', 'postgres'); -- Example

-- Create system parameter for automatic disable lock level configuration
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('edit_automatic_disable_locklevel', '{"update":false,"delete":false}', 'Enable/disable automatic lock level control for specific operations', 'Automatic disable lock level', NULL, NULL, true, 14, 'utils', NULL, NULL, 'json', 'linetext', true, true, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_system');

UPDATE config_form_list SET query_text='SELECT concat(arc_id, '' - '', doc_id) as sys_id, * FROM v_ui_doc_x_arc WHERE arc_id IS NOT NULL' WHERE listname='tbl_doc_x_arc' AND device=4;
UPDATE config_form_list SET query_text='SELECT concat(node_id, '' - '', doc_id) as sys_id, * FROM v_ui_doc_x_node WHERE node_id IS NOT NULL' WHERE listname='tbl_doc_x_node' AND device=4;
UPDATE config_form_list SET query_text='SELECT concat(connec_id, '' - '', doc_id) as sys_id, * FROM v_ui_doc_x_connec WHERE connec_id IS NOT NULL' WHERE listname='tbl_doc_x_connec' AND device=4;
UPDATE config_form_list SET query_text='SELECT concat(gully_id, '' - '', doc_id) as sys_id, * FROM v_ui_doc_x_gully WHERE gully_id IS NOT NULL' WHERE listname='tbl_doc_x_gully' AND device=4;
