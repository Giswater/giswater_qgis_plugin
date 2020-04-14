/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

-- 07/04/2020

INSERT INTO config_api_form_tabs (id, formname, tabname, label,  tooltip, sys_role) 
VALUES (710, 'exploitation', 'tabExploitation', 'Exploitation', 'Exploitation Selector', 'role_basic');

SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, context,  descript, label, project_type, datatype, isdeprecated) 
VALUES ('api_selector_exploitation', '{"table":"exploitation", "selector":"selector_expl", "table_id":"expl_id",  "selector_id":"expl_id",  "label":"expl_id, '' - '', name, '' '', CASE WHEN descript IS NULL THEN '' ELSE concat('' - '', descript) END, ''"}', 'system', 'Select which label to display for selectors', 'Selector labels:', 'utils', 'json', FALSE);

--2020/04/14

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_pipe', 'form', 'dma_id', null , 'integer', 'combo', 'Dma', NULL, 
	'dma_id - Identificador de la dma a la que pertenece el elemento. Si no se modifica la configuración, el programa la selecciona automáticamente en función de la geometría',
	'Dma', FALSE, FALSE, TRUE, FALSE, 
	'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL',
TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_virtualvalve', 'form', 'dma_id', null , 'integer', 'combo', 'Dma', NULL, 
	'dma_id - Identificador de la dma a la que pertenece el elemento. Si no se modifica la configuración, el programa la selecciona automáticamente en función de la geometría',
	'Dma', FALSE, FALSE, TRUE, FALSE, 
	'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL',
TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_inlet', 'form', 'dma_id', null , 'integer', 'combo', 'Dma', NULL, 
	'dma_id - Identificador de la dma a la que pertenece el elemento. Si no se modifica la configuración, el programa la selecciona automáticamente en función de la geometría',
	'Dma', FALSE, FALSE, TRUE, FALSE, 
	'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL',
TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_tank', 'form', 'dma_id', null , 'integer', 'combo', 'Dma', NULL, 
	'dma_id - Identificador de la dma a la que pertenece el elemento. Si no se modifica la configuración, el programa la selecciona automáticamente en función de la geometría',
	'Dma', FALSE, FALSE, TRUE, FALSE, 
	'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL',
TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_reservoir', 'form', 'dma_id', null , 'integer', 'combo', 'Dma', NULL, 
	'dma_id - Identificador de la dma a la que pertenece el elemento. Si no se modifica la configuración, el programa la selecciona automáticamente en función de la geometría',
	'Dma', FALSE, FALSE, TRUE, FALSE, 
	'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL',
TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_connec', 'form', 'dma_id', null , 'integer', 'combo', 'Dma', NULL, 
	'dma_id - Identificador de la dma a la que pertenece el elemento. Si no se modifica la configuración, el programa la selecciona automáticamente en función de la geometría',
	'Dma', FALSE, FALSE, TRUE, FALSE, 
	'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL',
TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_junction', 'form', 'dma_id', null , 'integer', 'combo', 'Dma', NULL, 
	'dma_id - Identificador de la dma a la que pertenece el elemento. Si no se modifica la configuración, el programa la selecciona automáticamente en función de la geometría',
	'Dma', FALSE, FALSE, TRUE, FALSE, 
	'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL',
TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_pump', 'form', 'dma_id', null , 'integer', 'combo', 'Dma', NULL, 
	'dma_id - Identificador de la dma a la que pertenece el elemento. Si no se modifica la configuración, el programa la selecciona automáticamente en función de la geometría',
	'Dma', FALSE, FALSE, TRUE, FALSE, 
	'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL',
TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_valve', 'form', 'dma_id', null , 'integer', 'combo', 'Dma', NULL, 
	'dma_id - Identificador de la dma a la que pertenece el elemento. Si no se modifica la configuración, el programa la selecciona automáticamente en función de la geometría',
	'Dma', FALSE, FALSE, TRUE, FALSE, 
	'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL',
TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;
