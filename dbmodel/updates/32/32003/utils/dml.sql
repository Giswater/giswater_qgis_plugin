/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-- 2019/03/27
SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('sys_exploitation_x_user','false','boolean', 'basic', 'Parameters to identify if system has enabled restriction for users in function of exploitation');

INSERT INTO sys_fprocess_cat VALUES (39, 'Epa inlet flowtrace', 'Edit', 'Epa inlet flowtrace', 'ws');

UPDATE sys_feature_type SET parentlayer = 'v_edit_arc' WHERE id='ARC';
UPDATE sys_feature_type SET parentlayer = 'v_edit_node' WHERE id='NODE';
UPDATE sys_feature_type SET parentlayer = 'v_edit_connec' WHERE id='CONNEC';


INSERT INTO audit_cat_table VALUES ('anl_polygon', 'Analysis', 'Table with the results of the topology process of polygons', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, false);


-- 2019/04/03
UPDATE config_param_system SET data_type = NULL, context = 'Api', descript = 'Version of API', 
label = 'Api version:', dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = null, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = NULL, widgettype = NULL, tooltip = NULL, ismandatory = NULL,iseditable = NULL, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'ApiVersion';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', descript = 'Layer used by search tool to fill Municipality field', 
label = 'Expl layer:', dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'expl_layer';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the previous layer used as key to fill Municipality field', label = 'Expl field code:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'expl_field_code';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the previous layer used as name to fill Municipality field', label = 'Expl field name:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'expl_field_name';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Layer used by search tool to fill Network tab in case of Arc type selected', label = 'Network layer arc:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_layer_arc';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus',
descript = 'Column in the previous layer used as key to fill Street field', label = 'Street field code:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'street_field_code';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Layer used by search tool to fill Network tab in case of Connec type selected', label = 'Network layer connec:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_layer_connec';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Minimum scale that the search tool will show', label = 'Scale zoom:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 17, 
	layout_order = 3, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'integer', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'scale_zoom';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'First field in the concatenate string that fills Hydrometer widget in search tool', label = 'Basic search hyd hydro field 1:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 17, 
	layout_order = 7, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'basic_search_hyd_hydro_field_1';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Layer used by search tool to fill Network tab in case of Element type selected', label = 'Network layer element:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_layer_element';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Layer used by search tool to fill Network tab in case of Gully type selected', label = 'Network layer gully:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_layer_gully';
UPDATE config_param_system SET data_type = NULL, context = 'mincut', 
descript = 'Different ways to use mincut. If true, mincut is done with pgrouting, an extension of Postgis', label = 'Om mincut use pgrouting:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 17, 
	layout_order = 1, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'om_mincut_use_pgrouting';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Layer used by search tool to fill Network tab in case of Node type selected', label = 'Network layer node:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_layer_node';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the related previous layer used to fill Code field', label = 'Network field arc code:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_field_arc_code';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the related previous layer used to fill Code field', label = 'Network field connec code:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_field_connec_code';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the related previous layer used to fill Code field', label = 'Network field element code:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_field_element_code';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the related previous layer used to fill Code field', label = 'Network field gully code:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_field_gully_code';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the related previous layer used to fill Code field', label = 'Network field node code:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'network_field_node_code';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Layer used by search tool to fill Street field', label = 'Street layer:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'street_layer';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the previous layer used as name to fill Street field', label = 'Street field name:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'street_field_name';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Layer used by search tool to fill Number field', label = 'Portal layer:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'portal_layer';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_adress', 
descript = 'Parameters used to define search by street', label = 'Api search street:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_street';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_adress', 
descript = 'Parameters used to define search by postnumber', label = 'Api search postnumber:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_postnumber';
UPDATE config_param_system SET data_type = NULL, context = 'path', 
descript = 'Folder in your computer which Giswater uses to manage Custom Options on developer toolbox', label = 'Custom giswater folder:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'custom_giswater_folder';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the previous layer used as key to fill Number field', label = 'Portal field code:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'portal_field_code';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the previous layer used as name to fill Number field', label = 'Portal field number:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'portal_field_number';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_network', 
descript = 'Parameters used to define search by exploitation', label = 'Api search exploitation:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_exploitation';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for node geom1 in case of revision (only UD)', label = 'Node geom 1 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 7, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_node_geom1_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for connec geom1 in case of revision (only UD)', label = 'Connec geom 1 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 11, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_connec_geom1_tol';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', descript = 'Column used as id to fill postal field', 
	label = 'Portal field postal:', dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= true
	WHERE parameter = 'portal_field_postal';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'Enable/disable check of state and topology of the network', label = 'State topo control:', 
	dv_querytext = NULL, dv_filterbyfield = true, isenabled = NULL, layout_id = 13, 
	layout_order = NULL, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'chk_state_topo';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_hydrometer', 
descript = 'Parameters used to define search by hydrometer', label = 'Api search hydrometer:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_hydrometer';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for connec geom2 in case of revision (only UD)', label = 'Connec geom 2 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 12, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_connec_geom2_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for gully top_elev in case of revision (only UD)', label = 'Gully top elev tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 13, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_gully_top_elev_tol';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_visit', 
descript = 'Parameters used to define search by visit', label = 'Api search visit modificat:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_visit_modificat';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Minimum accepted distance between two connecs, closer connecs are defined as duplicated', label = 'Connec duplicated tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 16, 
	layout_order = 2, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'connec_duplicated_tolerance';
UPDATE config_param_system SET data_type = NULL, context = 'api', 
descript = 'Sensibility value of an info on web', label = 'Api sensibility factor web:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = false, 
	datatype = 'integer', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_sensibility_factor_web';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_network', 
descript = 'Parameters used to define search by arc', label = 'Api search arc:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_arc';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_network', 
descript = 'Parameters used to define search by node', label = 'Api search node:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_node';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_network', 
descript = 'Parameters used to define search by connec', label = 'Api search connec:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_connec';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column used to fill Street field', label = 'Street field exploitation:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'street_field_expl';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_network', 
descript = 'Parameters used to define search by element', label = 'Api search element:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_element';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for arc geom1 in case of revision (only UD)', label = 'Arc geom 1 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 3, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_arc_geom1_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for node ymax in case of revision (only UD)', label = 'Node Y max tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 6, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_node_ymax_tol';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_workcat', 
descript = 'Parameters used to define search by workcat', label = 'Api search workcat:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_workcat';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_network', 
descript = 'Parameters used to define search by network', label = 'Api search network null:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_network_null';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Minimum accepted distance between two nodes, closer nodes are defined as duplicated', label = 'Node duplicated tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 16, 
	layout_order = 1, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'node_duplicated_tolerance';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Node ymax is NULL when drawing profile (UD)', label = 'Ymax vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'ymax_vd';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Node system elevation is NULL when drawing profile (UD)', label = 'Sys elev vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_elev_vd';
UPDATE config_param_system SET data_type = NULL, context = 'mincut', 
descript = 'Enable/disable showing mincut confilcts on map', label = 'Mincut conflict map:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 17, 
	layout_order = 2, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'mincut_conflict_map';
UPDATE config_param_system SET data_type = NULL, context = 'epa', 
descript = 'Length of the arc created from node feature on epa exportation', label = 'Node2arc length:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 17, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'node2arc';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Minimum accepted distance between two nodes', label = 'Node proximity control:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 10, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'node_proximity';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Layer used by search tool to fill Hydrometer field', label = 'Basic search hyd hydro layer name:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'basic_search_hyd_hydro_layer_name';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Minimum accepted distance between two connecs', label = 'Connec proximity control:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 11, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'connec_proximity';
UPDATE config_param_system SET data_type = NULL, context = 'edit', descript = 'Buffer which vnode use to search an arc to connect with on update vnode', label = 'Vnode update tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 15, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'vnode_update_tolerance';
UPDATE config_param_system SET data_type = NULL, context = 'review', descript = 'Tolerance of difference allowed for node geom2 in case of revision (only UD)', label = 'Node geom 2 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 8, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_node_geom2_tol';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Node catalog geom1 is NULL when drawing profile (UD)', label = 'Cat geom1:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'cat_geom1_vd';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_psector', 
descript = 'Parameters used to define search by psector', label = 'Api search psector:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_psector';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for connec y1 in case of revision (only UD)', label = 'Connec y1 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 9, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_connec_y1_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for connec y2 in case of revision (only UD)', label = 'Connec y2 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 10, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_connec_y2_tol';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Value that defines the distance buffer in which link is looking for his end features', label = 'Link search button:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= true
	WHERE parameter = 'link_search_button';
UPDATE config_param_system SET data_type = NULL, context = 'om', 
descript = 'Inventary migration date. Used in system rapports', label = 'Inventory update date:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 16, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'date', widgettype = 'datepickertime', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'inventory_update_date';
UPDATE config_param_system SET data_type = NULL, context = 'topology', 
descript = 'If true, the direction of the arc is fixed by the slope (UD)', label = 'Geometry direction as slope arc direction:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 9, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'geom_slp_direction';
UPDATE config_param_system SET data_type = NULL, context = 'topology', 
descript = 'To enable or disable state topology rules (WS)', label = 'State topocontrol:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 8, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'state_topocontrol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for node elevation in case of revision (only WS)', label = 'Node elev tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 1, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_node_elevation_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for node depth in case of revision (only WS)', label = 'Node depth tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 3, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_node_depth_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for arc y1 in case of revision (only UD)', label = 'Arc y1 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 1, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_arc_y1_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for arc y2 in case of revision (only UD)', label = 'Gully geom 1 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 2, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_arc_y2_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for arc geom2 in case of revision (only UD)', label = 'Arc geom 2 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 4, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_arc_geom2_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for node top_elev in case of revision (only UD)', label = 'Node top elev tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 5, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_node_top_elev_tol';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Node top elevation is NULL when drawing profile (UD)', label = 'Top elev vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'top_elev_vd';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Arc catalog geom1 is NULL when drawing profile (UD)', label = 'Geom1 vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'geom1_vd';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Arc catalog z1 is NULL when drawing profile (UD)', label = 'Z1 vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'z1_vd';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Arc catalog z2 is NULL when drawing profile (UD)', label = 'Z2 vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'z2_vd';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Arc system elevation 2 is NULL when drawing profile (UD)', label = 'Sys elev2 vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_elev2_vd';
UPDATE config_param_system SET data_type = NULL, context = 'path', descript = 'The hyperlink of document info to an url or a file is made up of two parts. 
	A common part to all documents, and a specific part for each document. The common part to all is the value of this variable', 
label = 'Doc absolute path:', dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= true
	WHERE parameter = 'doc_absolute_path';
UPDATE config_param_system SET data_type = NULL, context = 'path', 
	descript = 'The hyperlink of visit info to an url or a file is made up of two parts. A common part to all visits, 
	and a specific part for each visit. The common part to all is the value of this variable', label = 'Om visit absolute path:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= true
	WHERE parameter = 'om_visit_absolute_path';
UPDATE config_param_system SET data_type = NULL, context = 'om', descript = 'Enable/disable using rehabit module of visit', 
	label = 'Module om rehabit:', dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= true
	WHERE parameter = 'module_om_rehabit';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'Variable to check if daily updates are used', label = 'Sys daily updates:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_daily_updates';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'Variable to check if utils schema exists', label = 'Sys utils schema:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_utils_schema';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'Variable to check if api service is used', label = 'Sys api service:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_api_service';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'If true link parameter will be the same as element id', label = 'Edit automatic insert link:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'edit_automatic_insert_link';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'Variable to check if custom views are used', label = 'Sys custom views:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_custom_views';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'Type of currency used is this schema to calculate budgets', label = 'Sys currency:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_currency';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'To define some parameters to be used in gw_fct_utils_csv2pg_import_omvisit function. These parameters will also has to be defined in om_visit_parameter table', label = 'Utils csv2pg om visit parameters:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'utils_csv2pg_om_visit_parameters';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'System default value for publish', label = 'Edit publish sysvdefault:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'edit_publish_sysvdefault';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'System default value for inventory', label = 'Edit inventory sysvdefault:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'edit_inventory_sysvdefault';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'If TRUE, when you connect an element to the network, its state_type will be updated to value of the json', label = 'Edit connect update statetype:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'edit_connect_update_statetype';
UPDATE config_param_system SET data_type = NULL, context = 'api', 
descript = 'Sensibility value of an info on mobil', label = 'Api sensibility factor mobile:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = false, 
	datatype = 'integer', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_sensibility_factor_mobile';
UPDATE config_param_system SET data_type = NULL, context = 'om', 
descript = 'Visit parameters. AutoNewWorkcat IF TRUE, automatic workcat is created with same id that visit', label = 'Om visit automatic workcat:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'om_visit_parameters';
UPDATE config_param_system SET data_type = NULL, context = 'daily_update_mails', 
descript = 'Daily update mails', label = 'Daily update mails:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'daily_update_mails';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'System default value for uncertain', label = 'Edit uncertain sysvdefault:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'edit_uncertain_sysvdefault';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Enable/disable control of inserting duplicated gullies', label = 'Gully proximity control:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'gully_proximity_control';
UPDATE config_param_system SET data_type = NULL, context = 'api', descript = 'Minimum and maximum margin of canvas', label = 'Api canvasmargin:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_canvasmargin';
UPDATE config_param_system SET data_type = NULL, context = 'system', descript = 'Variable to check if scada schema exists', label = 'Sys scada schema:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_scada_schema';
UPDATE config_param_system SET data_type = NULL, context = 'mincut', 
descript = 'Variable to enable/disable the possibility to use valve unaccess button to open valves with closed status (WS)', label = 'Om mincut valvestat using valveunaccess:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ws', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'om_mincut_valvestat_using_valveunaccess';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Arc y1 is NULL when drawing profile (UD)', label = 'Y1 vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'y1_vd';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Arc y2 is NULL when drawing profile (UD)', label = 'Y2 vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'y2_vd';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', 
descript = 'Default value used if Arc slope is NULL when drawing profile (UD)', label = 'Slope vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'slope_vd';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'If true, user can manually update node_1 and node_2. Used in migrations with trustly data for not execute arc_searchnodes trigger', 
label = 'Edit enable arc nodes update:', dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 7, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'edit_enable_arc_nodes_update';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for gully units in case of revision (only UD)', label = 'Gully units tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 18, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'integer', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_gully_units_tol';
UPDATE config_param_system SET data_type = NULL, context = 'api_search_network', 
descript = 'Parameters used to define search by visit', label = 'Api search visit:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'api_search_visit';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for gully ymax in case of revision (only UD)', label = 'Gully Y max tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 14, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_gully_ymax_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for gully sandbox in case of revision (only UD)', label = 'Gully sandbox tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 15, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_gully_sandbox_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for gully connec_geom1 in case of revision (only UD)', label = 'Gully geom 1 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 16, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_gully_connec_geom1_tol';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Tolerance of difference allowed for gully connec_geom2 in case of revision (only UD)', label = 'Gully geom 2 tolerance:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 15, 
	layout_order = 17, project_type = 'ud', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'rev_gully_connec_geom2_tol';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Field used by hydrometer search tool', label = 'Basic search hyd hydro field cc:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 17, 
	layout_order = 4, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'basic_search_hyd_hydro_field_cc';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Second field in the concatenate string that fills Hydrometer widget in search tool', label = 'Basic search hyd hydro field 2:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 17, 
	layout_order = 8, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'basic_search_hyd_hydro_field_2';
UPDATE config_param_system SET data_type = NULL, context = 'rtc', 
descript = 'The hyperlink in the hydrometer info to an url or a file is made up of two parts. A common part to all hydrometers, and a specific part for each hydrometer. The common part to all is the value of this variable', label = 'Hydrometer link absolute path:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 17, 
	layout_order = 9, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'hydrometer_link_absolute_path';
UPDATE config_param_system SET data_type = NULL, context = 'topology', 
descript = 'Buffer which links use to search an arc to connect with', label = 'Link search buffer:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 13, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'link_searchbuffer';
UPDATE config_param_system SET data_type = NULL, context = 'review', 
descript = 'Buffer to find neighbour elements', label = 'Neighbourhood proximity buffer:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 14, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'proximity_buffer';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Enable/disable automatic arc division when the node is inserted over an arc', label = 'Edit arc divide automatic control:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 6, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= true
	WHERE parameter = 'edit_arc_divide_automatic_control';
UPDATE config_param_system SET data_type = NULL, context = 'om', 
descript = 'Default value for code (UD)', label = 'Code vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'code_vd';
UPDATE config_param_system SET data_type = NULL, context = 'draw_profile', descript = 'Default value used if Arc system elevation 1 is NULL when drawing profile (UD)', label = 'Sys elev1 vd:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ud', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_elev1_vd';
UPDATE config_param_system SET data_type = NULL, context = 'mincut', 
descript = 'If true, mincut temporary overlaps are disabled. Giswater won''t show you a message when different mincuts overlaps eachselfs (WS)', 
label = 'Om mincut disable check temporary overlap:', dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ws', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'om_mincut_disable_check_temporary_overlap';
UPDATE config_param_system SET data_type = NULL, context = 'mincut', 
descript = 'If true, Giswater save traceability from each valve to the tank which it has access (WS)', label = 'Om mincut valve2tank traceability:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ws', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'om_mincut_valve2tank_traceability';
UPDATE config_param_system SET data_type = NULL, context = 'edit',
descript = 'If TRUE, topocontrol function is used but the elements which violates topology also can get inside the network. Be careful, this function can lead to errors', label = 'Edit topocontrol dsbl error:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'edit_topocontrol_dsbl_error';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'If true, when inserting a new reduction, diam1 and diam2 values are capturated from dnom and dint from cat_node (WS)', label = 'Edit node reduction auto d1d2:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ws', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'edit_node_reduction_auto_d1d2';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'System parameter which identifies existing schema in the database with common information for those organizations which share cartography in more than on production schema(ws/ud). In this case, information is propagated to both schemas using views', label = 'Ext utils schema:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'ext_utils_schema';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'Variable to check if role permissions are used', label = 'Sys role permissions:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_role_permissions';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'Variable to check if crm schema exists', label = 'Sys crm schema:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_crm_schema';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Column in the previous layer used as name to fill Exploitation field', label = 'Basic search hyd hydro field expl name:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'basic_search_hyd_hydro_field_expl_name';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Third field in the concatenate string that fills Hydrometer widget in search tool', label = 'Basic search hyd hydro field 3:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'basic_search_hyd_hydro_field_3';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Field used by hydrometer search tool', label = 'Basic search hyd hydro field erhc:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 17, 
	layout_order = 6, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'basic_search_hyd_hydro_field_erhc';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'Field used by hydrometer search tool', label = 'Basic search hyd hydro field ccc:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 17, 
	layout_order = 5, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'basic_search_hyd_hydro_field_ccc';
UPDATE config_param_system SET data_type = NULL, context = 'searchplus', 
descript = 'To choose which value will be used in workcat form to filter elements', label = 'Basic search workcat filter:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = false, layout_id = 1, 
	layout_order = 0, project_type = 'ws', dv_isparent = false, isautoupdate = false, 
	datatype = 'string', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'basic_search_workcat_filter';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Enable/disable inserting double geometry features (point & polygon)', label = 'Double geometry enabled:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 12, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'insert_double_geometry';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Radius value of a circle on which a square polygon is built', label = 'Double geometry enabled:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 12, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'double', widgettype = 'spinbox', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'buffer_value';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Enable/disable control of inserting duplicated nodes', label = 'Node proximity control:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 10, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'node_proximity_control';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Enable/disable control of inserting duplicated connecs', label = 'Connec proximity control:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 11, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'connec_proximity_control';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Enable/disable automatic delete of orphan nodes', label = 'Orphan node delete:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 4, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'orphannode_delete';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Enable/disable the ability to change type of node', label = 'Nodetype change enabled:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 5, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'nodetype_change_enabled';
UPDATE config_param_system SET data_type = NULL, context = 'rtc', 
descript = 'Default value used if ext_cat_period doesn''t have date values or they are incorrect', label = 'Rtc period seconds:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'integer', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'vdefault_rtc_period_seconds';
UPDATE config_param_system SET data_type = NULL, context = 'plan', 
descript = 'Value used to identify ficticius arcs in case of new creation on planning operations to maintain the topology', label = 'Plan statetype ficticius:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'integer', widgettype = 'linetext', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'plan_statetype_ficticius';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'If TRUE, when insert a new connec customer_code will be the same as connec_id', label = 'Customer code autofill:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'customer_code_autofill';
UPDATE config_param_system SET data_type = NULL, context = 'basic', 
descript = 'Parameters to identify if system has enabled restriction for users in function of exploitation', label = 'Sys exploitation x user:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'sys_exploitation_x_user';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Enable/disable control of arcs with the same node at the beginning and at the end', label = 'Arc same node init end control:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 3, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'samenode_init_end_control';
UPDATE config_param_system SET data_type = NULL, context = 'system', 
descript = 'Enable/diable control audit functions', label = 'Audit Function control:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 1, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'audit_function_control';
UPDATE config_param_system SET data_type = NULL, context = 'mincut', 
descript = 'Variable to enable/disable the debug messages of mincut (WS)', label = 'Om mincut debug:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'ws', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'om_mincut_debug';
UPDATE config_param_system SET data_type = NULL, context = 'epa', 
descript = 'Conversion factors of CRM flows in function of EPA units choosed by user', label = 'Epa units factor:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'epa_units_factor';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Enable/disable the ability to look for arc''s final nodes', label = 'Arc searchnodes buffer:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = true, layout_id = 13, 
	layout_order = 2, project_type = 'utils', dv_isparent = false, isautoupdate = false, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'arc_searchnodes_control';
UPDATE config_param_system SET data_type = NULL, context = 'om', 
descript = 'Parameters used to set duration of different classes of visit', label = 'Om visit duration time:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'om_visit_duration_vdefault';
UPDATE config_param_system SET data_type = NULL, context = 'api', 
descript = 'Current api version', label = 'ApiVersion:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'ApiVersion';
UPDATE config_param_system SET data_type = NULL, context = 'edit', 
descript = 'Automatic insert of a node at the end of an arc', label = 'Automatic insert arc end point:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'boolean', widgettype = 'check', tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'nodeinsert_arcendpoint';
UPDATE config_param_system SET data_type = NULL, context = 'system', descript = 'Basic information about schema', label = 'Schema manager:', 
	dv_querytext = NULL, dv_filterbyfield = NULL, isenabled = NULL, layout_id = NULL, 
	layout_order = NULL, project_type = 'utils', dv_isparent = NULL, isautoupdate = NULL, 
	datatype = 'string', widgettype = NULL, tooltip = NULL, ismandatory = false,iseditable = true, 
	reg_exp = NULL, dv_orderby_id = NULL, dv_isnullvalue = NULL, stylesheet = NULL,
	widgetcontrols = NULL, placeholder = NULL, isdeprecated= NULL
	WHERE parameter = 'schema_manager';

update config_param_system set data_type = datatype, ismandatory=TRUE;
update config_param_system set ismandatory=FALSE WHERE parameter='custom_giswater_folder' OR parameter='ext_utils_schema' or 
	parameter='hydrometer_link_absolute_path';
update config_param_system set isenabled=false where isenabled is null;
update config_param_system 	set layout_id=null,layout_order=null, ismandatory=null, widgettype=null, datatype=null, iseditable=null, 
	dv_isparent=null, dv_querytext=null, dv_filterbyfield=null, isautoupdate=null where isenabled is false;
update config_param_system set isdeprecated=false where isdeprecated is null;
update config_param_system set iseditable=TRUE where isenabled = true and iseditable is null;
update config_param_system set dv_isparent=FALSE where isenabled = true and dv_isparent is null;
update config_param_system set isautoupdate=FALSE where isenabled = true and isautoupdate is null;

-- refactor id on table
update config_param_system a set id = b.a FROM 	(SELECT row_number() over (order by id)+10000 AS a, id FROM config_param_system) b where b.id = a.id;
update config_param_system a set id = b.a FROM 	(SELECT row_number() over (order by id) AS a, id FROM config_param_system) b where b.id = a.id;
