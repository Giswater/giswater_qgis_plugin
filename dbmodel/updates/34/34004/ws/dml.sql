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
	
	
UPDATE config_api_form_fields SET tooltip = 'cat_dnom - Díametro nominal del elemento en mm. No se puede rellenar. Se usa el que tenga el campo dnom en el catálogo correspondiente' WHERE column_id = 'cat_dnom' AND tooltip = 'cat_dnom' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'cat_matcat_id - Material del elemento. No se puede rellenar Se usa el que tenga el campo matcat_id del catálogo correspondiente' WHERE column_id = 'cat_matcat_id' AND tooltip = 'cat_matcat_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'cat_pnom - Presión nominal del elemento en atm. No se puede rellenar. Se usa el que tenga el campo pnom en el catálogo correspondiente' WHERE column_id = 'cat_pnom' AND tooltip = 'cat_pnom' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'depth1 - Profundidad del nodo 1' WHERE column_id = 'depth1' AND tooltip = 'depth1' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'depth2 - Profundidad del nodo 2' WHERE column_id = 'depth2' AND tooltip = 'depth2' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'dqa_id - Identificador de la dqa(zona de calidad del agua) a la que pertenece el elemento' WHERE column_id = 'dqa_id' AND tooltip = 'dqa_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'elevation1 - Elevación del nodo 1' WHERE column_id = 'elevation1' AND tooltip = 'elevation1' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'elevation2 - Elevación del nodo 2' WHERE column_id = 'elevation2' AND tooltip = 'elevation2' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'macrodqa_id - Identificador de la macrodqa_id. Se rellena automáticamente en función de la dqa' WHERE column_id = 'macrodqa_id' AND tooltip = 'macrodqa_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'minsector_id - Identificador del minsector (sector mínimo de la red) al que pertenece el elemento' WHERE column_id = 'minsector_id' AND tooltip = 'minsector_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'nodetype_1 - Tipo del node 1' WHERE column_id = 'nodetype_1' AND tooltip = 'nodetype_1' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'nodetype_2 - Tipo del node 2' WHERE column_id = 'nodetype_2' AND tooltip = 'nodetype_2' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'staticpressure - Presión estática calculada dinámicamente y vinculada con la zona de presión' WHERE column_id = 'staticpressure' AND tooltip = 'staticpressure' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'staticpressure1 - Presión estática del nodo 1' WHERE column_id = 'staticpressure1' AND tooltip = 'staticpressure1' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'staticpressure2 - Presión estática del nodo 2' WHERE column_id = 'staticpressure2' AND tooltip = 'staticpressure2' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'sys_type - Tipo de elemento de sistema. Referente a la tabla sys_feature_cat' WHERE column_id = 'sys_type' AND tooltip = 'sys_type' AND formtype='feature';
	
	
UPDATE config_api_form_fields SET tooltip = 'broken - Para establecer si la válvula esta rota o no' WHERE column_id = 'broken' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'buried - Para establecer si la válvula esta enterrada o no' WHERE column_id = 'buried' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'cat_valve2 - Catálogo para una segunda válvula en el mismo elemento' WHERE column_id = 'cat_valve2' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'closed - Para establecer si la válvula se encuentra cerrada o no' WHERE column_id = 'closed' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'depth_valveshaft - Profundidad del eje de la válvula' WHERE column_id = 'depth_valveshaft' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'drive_type - Tipo de conducción para desague' WHERE column_id = 'drive_type' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'exit_code - Identificador del elemento dónde desagua' WHERE column_id = 'exit_code' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'exit_type - Tipo de salida para desague' WHERE column_id = 'exit_type' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'irrigation_indicator - Para establecer si tiene indicador de riego o no' WHERE column_id = 'irrigation_indicator' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'lin_meters - Longitud del desague en metros' WHERE column_id = 'lin_meters' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'pression_entry - Pressión de entrada (habitualmente en  kg/cm2)' WHERE column_id = 'pression_entry' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'pression_exit - Pressión de salida (habitualmente en  kg/cm2)' WHERE column_id = 'pression_exit' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'regulator_location - Localización concreta de la válvula de regulación' WHERE column_id = 'regulator_location' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'regulator_observ - Observaciones asociadas a la válvula de regulación' WHERE column_id = 'regulator_observ' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'regulator_situation - Calle dónde de situa la válvula de regulación' WHERE column_id = 'regulator_situation' AND tooltip IS NULL;
UPDATE config_api_form_fields SET tooltip = 'arq_patrimony - Para establecer si la fuente es patrimonio arquitectónico o no' WHERE column_id = 'arq_patrimony' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'chlorinator - Para establecer si tiene clorador o no' WHERE column_id = 'chlorinator' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'container_number - Número de contenedores de agua de la fuente' WHERE column_id = 'container_number' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'linked_connec - Identificador de la acometida asociada' WHERE column_id = 'linked_connec' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'power - Potencia total' WHERE column_id = 'power' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'pump_number - Número de bombas' WHERE column_id = 'pump_number' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'regulation_tank - Para establecer la existencia o no de un depósito de regulación' WHERE column_id = 'regulation_tank' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'vmax - Volumen máximo' WHERE column_id = 'vmax' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'vtotal - Volumen total' WHERE column_id = 'vtotal' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'communication - Para establecer si se ha comunicado la información del hidrante' WHERE column_id = 'communication' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'fire_code - Código para bomberos' WHERE column_id = 'fire_code' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'valve - Válvula vinculada con el hidrante' WHERE column_id = 'valve' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'serial_number - Número de serie del elemento' WHERE column_id = 'serial_number' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'lab_code - Código para laboratorio' WHERE column_id = 'lab_code' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'elev_height - Altura de la bomba' WHERE column_id = 'elev_height' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'max_flow - Flujo máximo' WHERE column_id = 'max_flow' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'min_flow - Flujo mínimo' WHERE column_id = 'min_flow' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'nom_flow - Flujo óptimo' WHERE column_id = 'nom_flow' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'pressure - Pressión' WHERE column_id = 'pressure' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'diam1 - Diámetro inicial' WHERE column_id = 'diam1' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'diam2 - Diámetro final' WHERE column_id = 'diam2' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'area - Área del depósito en m2' WHERE column_id = 'area' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'chlorination - Para establecer si tiene clorador o no' WHERE column_id = 'chlorination' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'vutil - Volumen útil' WHERE column_id = 'vutil' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'cat_valve - Catálogo de la válvula asociada' WHERE column_id = 'cat_valve' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'com_state - Para establecer si se ha comunicado o no si el agua es potable' WHERE column_id = 'com_state' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'drain_diam - Diámetro del tubo de drenaje' WHERE column_id = 'drain_diam' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'drain_distance - Distancia del desague' WHERE column_id = 'drain_distance' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'drain_exit - Tipo de salida del desague' WHERE column_id = 'drain_exit' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'drain_gully - Identificador de la reja de desague' WHERE column_id = 'drain_gully' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'customer_code - Código comercial' WHERE column_id = 'customer_code' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'top_floor - Número máximo de plantas del edificio a abastecer' WHERE column_id = 'top_floor' AND tooltip IS NULL AND formtype='feature';
