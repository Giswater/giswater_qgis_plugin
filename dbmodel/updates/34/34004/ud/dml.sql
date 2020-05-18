/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

--2020/03/13
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_gully', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'macroexploitation - Identificador de la macroexplotacion. Se rellena automáticamente en función de la explotacion', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)  ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_gully', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'tstamp - Fecha de inserción del elemento a la base de datos', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)  ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_gully', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'macroexploitation - Identificador de la macroexplotacion. Se rellena automáticamente en función de la explotacion', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)  ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_gully', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'tstamp - Fecha de inserción del elemento a la base de datos', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE)  ON CONFLICT (formname, formtype, column_id) DO NOTHING;


--2020/03/30
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_divider', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_divider', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_outfall', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_outfall', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
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
VALUES ('v_edit_inp_virtual', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_virtual', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
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
VALUES ('v_edit_inp_weir', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_weir', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_orifice', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_orifice', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_storage', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_storage', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_conduit', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_conduit', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_outlet', 'form', 'expl_id', null , 'integer', 'combo', 'Exploitation', NULL, NULL,'Exploitation', FALSE, FALSE, FALSE, FALSE, 
	'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
	widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_outlet', 'form', 'state_type', null , 'integer', 'combo', 'State type', NULL, NULL, 'State type', FALSE, FALSE, FALSE, FALSE, 
	'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',NULL, NULL, 'state', ' AND value_state_type.state  ', NULL, NULL, NULL, 
	NULL, 'lyt_data_1', NULL, FALSE) ON CONFLICT (formname, formtype, column_id) DO NOTHING;
	
	
UPDATE config_api_form_fields SET tooltip = 'connec_arccat_id - Catálogo del tramo de conexión' WHERE column_id = 'connec_arccat_id' AND tooltip = 'connec_arccat_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'demand - Deamanda de agua' WHERE column_id = 'demand' AND tooltip = 'demand' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'diagonal - Para establecer si la conexión se encuentra en diagonal o perpendicular' WHERE column_id = 'diagonal' AND tooltip = 'diagonal' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'gully_id - Identificador del gully. No es necesario introducirlo, es un serial automático' WHERE column_id = 'gully_id' AND tooltip = 'gully_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'inverted_slope - Para establecer si el conducto tiene pendiente invertido o no' WHERE column_id = 'inverted_slope' AND tooltip = 'inverted_slope' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'sandbox - Profundidad del arenero' WHERE column_id = 'sandbox' AND tooltip = 'sandbox' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'slope - Pendiente del conducto' WHERE column_id = 'slope' AND tooltip = 'slope' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'uncertain - Para establecer si la ubicación del elemento es incierta' WHERE column_id = 'uncertain' AND tooltip = 'uncertain' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'unconnected - Para establecer si el elemento esta desconectado' WHERE column_id = 'unconnected' AND tooltip = 'unconnected' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'xyz_date - Fecha recogida de la cota de topógrafo' WHERE column_id = 'xyz_date' AND tooltip = 'xyz_date' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'r1 - Recubrimiento. Distància entre la generatriz superior y la superfície en el nodo 1' WHERE column_id = 'r1' AND tooltip = 'r1' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'r2 - Recubrimiento. Distància entre la generatriz superior y la superfície en el nodo 2' WHERE column_id = 'r2' AND tooltip = 'r2' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'z1 - Distancia entre la solera del nodo 1 y la generatriz inferior del tramo' WHERE column_id = 'z1' AND tooltip = 'z1' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'z2 - Distancia entre la solera del nodo 2 y la generatriz inferior del tramo' WHERE column_id = 'z2' AND tooltip = 'z2' AND formtype='feature';	
	
	
UPDATE config_api_form_fields SET tooltip = 'accessibility - Para establecer si es accesible o no' WHERE column_id = 'accessibility' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'bottom_channel - Para establecer si tiene canal al fondo o no' WHERE column_id = 'bottom_channel' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'length - Longitud total' WHERE column_id = 'length' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'max_volume - Volumen máximo' WHERE column_id = 'max_volume' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'sander_depth - Profundidad del arenero' WHERE column_id = 'sander_depth' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'util_volume - Volumen útil' WHERE column_id = 'util_volume' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'width - Anchura total' WHERE column_id = 'width' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'prot_surface - Para establecer si existe un protector en superfície' WHERE column_id = 'prot_surface' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'serial_number - Número de serie del elemento' WHERE column_id = 'serial_number' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'siphon - Para establecer si tiene sifón o no' WHERE column_id = 'siphon' AND (tooltip IS NULL OR tooltip='siphon') AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'units - Número de rejas' WHERE column_id = 'units' AND (tooltip IS NULL OR tooltip = 'units') AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'sander_length - Longitud del arenero' WHERE column_id = 'sander_length' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'min_height - Altura mínima' WHERE column_id = 'min_height' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'custom_area - Area útil del depósito' WHERE column_id = 'custom_area' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'groove - Para establecer si hay ranura en el encintado' WHERE column_id = 'groove' AND tooltip = 'groove' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'inlet - Elemento con aportaciones' WHERE column_id = 'inlet' AND tooltip IS NULL;
