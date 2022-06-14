/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/08
update  inp_typevalue set addparam = '{"BC": ["SURFACE", "SOIL", "STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'BC';

update  inp_typevalue set addparam = '{"RG": ["SURFACE", "SOIL", "STORAGE"] }' WHERE inp_typevalue.id  = 'RG';

update  inp_typevalue set addparam = '{"GR": ["SURFACE", "SOIL", "DRAINMAT"] }' WHERE inp_typevalue.id  = 'GR';

update  inp_typevalue set addparam = '{"IT": ["SURFACE", "STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'IT';

update  inp_typevalue set addparam = '{"PP": ["SURFACE", "PAVEMENT", "SOIL", "STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'PP';

update  inp_typevalue set addparam = '{"RB": ["STORAGE", "DRAIN"] }' WHERE inp_typevalue.id  = 'RB';

update  inp_typevalue set addparam = '{"RD": ["SURFACE", "DRAIN"] }' WHERE inp_typevalue.id  = 'RD';

update  inp_typevalue set addparam = '{"VS": ["SURFACE"] }' WHERE inp_typevalue.id  = 'VS';

update config_toolbox
set inputparams='[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""},
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""},
{"widgetname":"descript", "label":"Descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5,"value":""}]' 
WHERE id=3118;

--2022/06/11
DELETE FROM config_fprocess WHERE tablename in ('vi_grate', 'vi_link',  'vi_lxsections');

UPDATE sys_param_user SET formname  ='epaoptions' WHERE id = 'inp_options_networkmode';

INSERT INTO sys_feature_epa_type VALUES ('GULLY', 'GULLY', 'inp_gully', null, true);
INSERT INTO sys_feature_epa_type VALUES ('NETGULLY', 'NODE', 'inp_netgully', 'Special case: Additional epa_type for those nodes that are netgullys', true);

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''NODE'' AND id != ''NETGULLY'''
WHERE columnname = 'epa_type' AND formname like 've_nod%';

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''NODE'' AND id != ''NETGULLY'''
WHERE columnname = 'epa_type' AND formname = 'v_edit_node';

DELETE FROM sys_table WHERE id in('vi_lxsections', 'vi_link', 'vi_grate', 'vi_gully2pjoint');

INSERT INTO sys_table (id, descript, sys_role, source) VALUES 
('vi_gully2node', 'View to show what is the outlet node of gully', 'role_epa','core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES 
('v_edit_inp_netgully', 'View to manage epa-side of netgully. Special case where netgully has two epa-sides (junction and also gully)', 
'role_epa','core');
INSERT INTO sys_table (id, descript, sys_role, source) VALUES 
('inp_netgully', 'Table to manage epa-side of netgully. Special case where netgully has two epa-sides (junction and also gully)', 
'role_epa','core');

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(455, 'Check arc_id null for gully', 'ud', NULL, 'core', true, 'Check epa-result', NULL) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(456, 'Check gullies with null values on (custom)top_elev', 'ud', NULL, 'core', true, 'Check epa-result', NULL) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(457, 'Check gullies with null values on (custom)width', 'ud', NULL, 'core', true, 'Check epa-result', NULL) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(458, 'Check gullies with null values on (custom)length', 'ud', NULL, 'core', true, 'Check epa-result', NULL) 
ON CONFLICT (fid) DO NOTHING;

DELETE FROM sys_param_user where id = 'epa_gully_outlet_type_vdefault';
INSERT INTO sys_param_user(id, formname, descript, sys_role, isenabled, project_type, isautoupdate, datatype, widgettype, ismandatory, dv_isnullvalue, dv_querytext, vdefault, source, iseditable, label, layoutname, layoutorder)
VALUES ('epa_gully_outlet_type_vdefault', 'config', 'Default value for enable /disable gully. Two options are available (Sink, To network). In case of Sink water is lossed.',
'role_epa', true, 'ud', true, 'text', 'combo', false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''typevalue_gully_outlet_type''' ,'To network', 'core', true ,'1D/2D Gully outlet_type vdefault:', 'lyt_epa',2)
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user where id = 'epa_gully_method_vdefault';
INSERT INTO sys_param_user(id, formname, descript, sys_role, isenabled, project_type, isautoupdate, datatype, widgettype, ismandatory, dv_isnullvalue, dv_querytext, vdefault, source, iseditable, label, layoutname, layoutorder)
VALUES ('epa_gully_method_vdefault', 'config', 'Default value for calculation method on gullies. Two options are available (UPC, W/O).',
'role_epa', true, 'ud', true, 'text', 'combo', false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''typevalue_gully_method''' ,'W/O', 'core', true ,'1D/2D Gully calculation method vdefault:', 'lyt_epa',3)
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user where id = 'epa_gully_cd_weir_vdefault';
INSERT INTO sys_param_user(id, formname, descript, sys_role, isenabled, project_type, isautoupdate, datatype, widgettype, ismandatory, vdefault, source, iseditable, label, layoutname, layoutorder)
VALUES ('epa_gully_cd_weir_vdefault', 'config', 'Default value for cd_weir using calculation method W/O on gullies.',
'role_epa', true, 'ud', true, 'numeric', 'text', true, '1.6', 'core', true ,'1D/2D Gully CD-WEIR vdefault for W/O method:', 'lyt_epa',4)
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user where id = 'epa_gully_cd_orifice_vdefault';
INSERT INTO sys_param_user(id, formname, descript, sys_role, isenabled, project_type, isautoupdate, datatype, widgettype, ismandatory, vdefault, source, iseditable, label, layoutname, layoutorder)
VALUES ('epa_gully_cd_orifice_vdefault', 'config', 'Default value for cd_orifice using calculation method W/O on gullies.',
'role_epa', true, 'ud', true, 'numeric', 'text', true, '0.7', 'core', true ,'1D/2D Gully CD-ORIFICE vdefault for W/O method:', 'lyt_epa',5)
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_param_user where id = 'epa_gully_efficiency_vdefault';
INSERT INTO sys_param_user(id, formname, descript, sys_role, isenabled, project_type, isautoupdate, datatype, widgettype, ismandatory, vdefault, source, iseditable, label, layoutname, layoutorder)
VALUES ('epa_gully_efficiency_vdefault', 'config', 'Default value for efficiency on gullies.',
'role_epa', true, 'ud', true, 'numeric', 'text', true, '100', 'core', true ,'1D/2D Gully efficiency vdefault:', 'lyt_epa',6)
ON CONFLICT (id) DO NOTHING;

UPDATE sys_param_user SET formname  ='hidden' where id in('edit_update_elevation_from_dem', 'utils_debug_mode', 'utils_checkproject_qgislayer');

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_feature_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_feature_arc' and columnname in ('epa_default') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET
dv_querytext='SELECT id as id, id as idval FROM sys_feature_epa_type WHERE feature_type =''GULLY'''
WHERE formname='v_edit_cat_feature_gully' and columnname='epa_default';

INSERT INTO sys_feature_epa_type(id, feature_type, epa_table, descript, active)
VALUES ('UNDEFINED', 'GULLY', NULL, NULL, TRUE) ON CONFLICT (id, feature_type) DO NOTHING;

INSERT INTO edit_typevalue(typevalue, id, idval)
VALUES ('gully_units_placement', 'WIDTH-SIDE', 'WIDTH-SIDE') ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO edit_typevalue(typevalue, id, idval)
VALUES ('gully_units_placement', 'LENGTH-SIDE', 'LENGTH-SIDE') ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,parameter_id, active)
VALUES ('edit_typevalue', 'gully_units_placement', 'gully', 'units_placement',null ,true);

INSERT INTO sys_foreignkey(typevalue_table, typevalue_name, target_table, target_field,parameter_id, active)
VALUES ('edit_typevalue', 'gully_units_placement', 'man_netgully', 'units_placement',null ,true);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate,  dv_querytext,  dv_isnullvalue, hidden)
SELECT 'v_edit_gully', 'form_feature', 'data', 'units_placement', 'lyt_data_2', max(layoutorder) +1, 'string', 'combo', 'units placement', null,
null, false, false, true, false, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''gully_units_placement''',true, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate,  dv_querytext,  dv_isnullvalue, hidden)
SELECT 'v_edit_gully', 'form_feature', 'data', 'groove_height', 'lyt_data_2', max(layoutorder) +1, 'double', 'text', 'groove height', null,
null, false, false, true, false, null,true, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate,  dv_querytext,  dv_isnullvalue, hidden)
SELECT 'v_edit_gully', 'form_feature', 'data', 'groove_length', 'lyt_data_2', max(layoutorder) +1, 'double', 'text', 'groove length', null,
null, false, false, true, false, null,true, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 've_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_gully' and columnname in ('units_placement','groove_height','groove_length') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 've_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_gully' and columnname in ('units_placement','groove_height','groove_length') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT child_layer, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields, cat_feature WHERE formname='v_edit_gully' and columnname in ('units_placement','groove_height','groove_length') and 
(feature_type='GULLY' OR system_id='NETGULLY') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT child_layer, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, 
'SELECT id, id as idval FROM sys_feature_epa_type WHERE active IS TRUE AND feature_type = ''GULLY''', 
dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields, cat_feature WHERE formname='v_edit_arc' and columnname in ('epa_default') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, 
'SELECT id, id as idval FROM sys_feature_epa_type WHERE active IS TRUE AND feature_type = ''GULLY''', 
dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_arc' and columnname in ('epa_default') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 've_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, 
'SELECT id, id as idval FROM sys_feature_epa_type WHERE active IS TRUE AND feature_type = ''GULLY''', 
dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_arc' and columnname in ('epa_default') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

