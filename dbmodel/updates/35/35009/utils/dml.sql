/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/21

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'id',null,null,'string', 'text','id',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'descript',null,null,'string', 'text','descript',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'link',null,null,'string', 'text','link',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'svg',null,null,'string', 'text','svg',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'z1',null,null,'double', 'text','z1',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'z2',null,null,'double', 'text','z2',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'width',null,null,'double', 'text','width',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'area',null,null,'double', 'text','area',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'estimated_depth',null,null,'double', 'text','estimated_depth',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'bulk',null,null,'double', 'text','bulk',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'label',null,null,'string', 'text','label',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'acoeff',null,null,'double', 'text','acoeff',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

-- 2021/06/24
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3052, 'gw_fct_anl_arc_length', 'utils', 'function', 'json', 'json',
'Check topology assistant. Detect arcs duplicated only by final nodes or the entire geometry',
'role_edit', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3052,'Arcs shorter than specific length', '{"featureType":["arc"]}', 
'[{"widgetname":"arcLength", "label":"Arc length:", "widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layoutorder":1}]', NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name, returnmanager, layermanager, actions)
VALUES (3052,'gw_fct_anl_arc_length', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (387, 'Find short arcs', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3054, 'gw_fct_setmapzoneconfig', 'utils', 'function', 'json', 'json',
'Function that changes configuration of a mapzone after using node replace, arc fusion or divide tool on features that are involved in a mapzone',
'role_edit', NULL, NULL) ON CONFLICT (id) DO NOTHING;

-- 2021/06/28
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3056, 'gw_trg_edit_inp_controls', 'utils', 'function trigger', NULL, NULL,
'Allows editing inp controls view','role_epa', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3058, 'gw_trg_edit_inp_rules', 'ws', 'function trigger', NULL, NULL,
'Allows editing inp rules view','role_epa', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3060, 'gw_trg_edit_inp_curve', 'ws', 'function trigger', NULL, NULL,
'Allows editing inp rules view','role_epa', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3062, 'gw_trg_edit_inp_pattern', 'ws', 'function trigger', NULL, NULL,
'Allows editing inp rules view','role_epa', NULL, NULL) ON CONFLICT (id) DO NOTHING;

--2021/06/29

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname)
VALUES ('inp_curve', 'form_feature', 'sector_id', NULL, 'integer', 'combo', 'sector_id', FALSE, FALSE,
TRUE, FALSE, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL ' , TRUE, TRUE,
NULL,NULL,NULL, NULL,FALSE,'main') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname)
SELECT 'v_edit_inp_curve', formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname
FROM config_form_fields WHERE formname = 'inp_curve' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname)
SELECT 'v_edit_inp_curve_value', formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
FALSE, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname
FROM config_form_fields WHERE formname = 'inp_curve' AND columnname IN ('curve_type', 'descript', 'sector_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname)
SELECT 'v_edit_inp_curve_value', formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname
FROM config_form_fields WHERE formname = 'inp_curve_value' 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname)
SELECT 'v_edit_inp_controls', formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname
FROM config_form_fields WHERE formname = 'inp_controls' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3064, 'gw_fct_anl_node_elev', 'ud', 'function', 'json', 'json',
'Analysis of duplicated values inserted on fieds top_elev, ymax and elev','role_edit', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3066, 'gw_fct_anl_arc_elev', 'ud', 'function', 'json', 'json',
'Analysis of duplicated values inserted on fieds y and elev','role_edit', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (389, 'Nodes with duplicated values of top_elev, ymax and elev', 'ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (390, 'Arcs with duplicated values of y and elev', 'ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3064,'Check nodes elevation values', '{"featureType":["node"]}', NULL, NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3066,'Check arcs elevation values', '{"featureType":["arc"]}', NULL, NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name, returnmanager, layermanager, actions)
VALUES (3064,'gw_fct_anl_node_elev', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function(id, function_name, returnmanager, layermanager, actions)
VALUES (3066,'gw_fct_anl_node_elev', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL, NULL)
ON CONFLICT (id) DO NOTHING;

--2021/06/30
INSERT INTO config_param_system VALUES ('admin_formheader_field', '{"node":"node_id", "arc":"arc_id", "connec":"connec_id", "gully":"gully_id", "element":{"childType":"ELEMENT", "column":"element_id"},
 "hydrometer":{"childType":"HYDROMETER", "column":"hydrometer_id"},  "newText":"NEW"}', 'Field to use as header from every feature_type when getinfofromid. When element and hydrometer, childType is used as text to concat with column. When insert new feature, newText is used to translate the concat text', 
NULL, NULL, NULL, FALSE, NULL, 'utils') ON CONFLICT (parameter) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (391, 'Arcs shorter than value set as node proximity', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_param_system(parameter, value, descript, label,isenabled, project_type,  datatype)
VALUES ('basic_selector_sectorfromexpl', '{"activated":"false"}', 'If true, sector selector is set automatically set to the sector which  geometry overlaps the selected exploitation.',
'Selector variables', FALSE, 'utils','json');

