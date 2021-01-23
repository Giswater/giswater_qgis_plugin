/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

--2020/03/30
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_connec', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

UPDATE config_api_form_fields SET widgettype = 'combo', dv_querytext = 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',
dv_parent_id = 'state', dv_querytext_filterc = ' AND value_state_type.state  ' WHERE formname = 'v_edit_inp_connec' AND column_id = 'state_type';

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_inlet', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_inlet', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_junction', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_junction', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_pipe', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_pipe', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_pump', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_pump', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_reservoir', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_reservoir', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_shortpipe', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_shortpipe', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_tank', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_tank', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_valve', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_valve', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_virtualvalve', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_virtualvalve', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;
