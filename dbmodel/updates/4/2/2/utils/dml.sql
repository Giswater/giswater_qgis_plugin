/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('help_domain', 'https://docs.giswater.org/', 'Base domain for documentation web.', 'Custom variable for documentation', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'boolean', 'check', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT DO NOTHING;

-- 01/09/2025
UPDATE config_form_fields SET widgetfunction = replace(widgetfunction::text, 'v_edit_', 've_')::json WHERE widgetfunction::TEXT ILIKE '%v_edit_%';

-- 02/09/2025
UPDATE config_form_tableview SET visible=true WHERE objectname='plan_psector_x_arc' AND columnname='descript';
UPDATE config_form_tableview SET visible=true WHERE objectname='plan_psector_x_node' AND columnname='descript';

INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'id', 0, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'connec_id', 1, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'arc_id', 2, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'psector_id', 3, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'state', 4, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'doable', 5, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'descript', 6, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', '_link_geom_', 7, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', '_userdefined_geom_', 8, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'link_id', 9, true, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'insert_tstamp', 10, false, NULL, NULL, NULL);
INSERT INTO config_form_tableview VALUES ('plan toolbar', 'utils', 'plan_psector_x_connec', 'insert_user', 11, false, NULL, NULL, NULL);

UPDATE config_typevalue SET addparam='{"orderBy":999}' WHERE typevalue='sys_table_context' AND id='{"levels": ["HIDDEN"]}';

-- 03/09/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) 
VALUES('layout_name_typevalue', 'lyt_connect_link_4', 'lyt_connect_link_4', 'lytConnectLink4', '{"lytOrientation": "horizontal"}'::json);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('generic', 'link_to_connec', 'tab_none', 'arc_id', 'lyt_connect_link_4', 1, 'text', 'text', 'Connect to arc:', 'Arc Id', NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('generic', 'link_to_connec', 'tab_none', 'btn_set_to_arc', 'lyt_connect_link_4', 2, NULL, 'button', NULL, 'Set to arc', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "155"
}'::json, NULL, NULL, NULL, false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_connec', 'tab_none', 'btn_expr_arc', 'lyt_connect_link_4', 3, NULL, 'button', NULL, 'Select by Expression - Set closest point', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, NULL, '{
  "functionName": "filter_expression_arc",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) 
VALUES(3512, 'gw_fct_plan_recover_archived', 'utils', 'function', 'json', 'json', NULL, 'role_plan', NULL, 'core', NULL);

UPDATE config_form_fields SET iseditable = false where formname ilike 've_node_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_arc_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_connec_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_link_%' and columnname = 'state';
UPDATE config_form_fields SET iseditable = false where formname ilike 've_gully_%' and columnname = 'state';
