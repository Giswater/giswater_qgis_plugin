/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/02
UPDATE config_form_fields SET formname='v_edit_inp_coverage' WHERE formname ='inp_coverage_land_x_subc';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_coverage', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE columnname ilike 'hydrology_id' AND formname='v_edit_inp_subcatchment';

INSERT INTO sys_table(id, descript, sys_role,  context, orderby, alias, source)
VALUES ('v_edit_inp_coverage', 'Editable view to manage coverage', 'role_epa',  '{"level_1":"EPA","level_2":"HYDRAULICS"}',17, 'Inp coverage', 
'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, source)
VALUES ('v_anl_grafanalytics_upstream', 'Table to work with grafanalytics', 'role_epa', 'giswater') 
ON CONFLICT (id) DO NOTHING;

UPDATE config_form_fields SET label='dma' WHERE columnname='dma_id' AND label='dma_id' AND formname LIKE 've_%';
UPDATE config_form_fields SET label='sector' WHERE columnname='sector_id' AND label='sector_id' AND formname LIKE 've_%';
UPDATE config_form_fields SET label='exploitation' WHERE columnname='expl_id' AND label='expl_id' AND formname LIKE 've_%';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_feature_node', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_feature_node' and columnname in ('epa_default', 'isarcdivide', 'isprofilesurface','isexitupperintro', 'choose_hemisphere',
'num_arcs', 'double_geom');

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_feature_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_feature_gully';

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_cat_feature_gully', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, 
placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='cat_feature' AND columnname in ('link_path', 'shortcut_key', 'codeautofill', 'descript', 'active');

UPDATE config_form_fields SET columnname='system_id' WHERE columnname='type' and formname ilike 'v_edit_cat_feature_gully';
UPDATE config_form_fields SET iseditable=true WHERE  formname ilike 'v_edit_cat_feature_gully';

UPDATE config_form_fields SET label='sys_type' WHERE columnname='system_id' and formname ilike 'v_edit_cat_feature%';

UPDATE config_form_fields SET widgettype='combo' WHERE columnname='system_id' and formname in ('cat_feature_gully', 'v_edit_cat_feature_gully');

UPDATE config_form_fields SET dv_querytext='SELECT id as id, id as idval FROM sys_feature_cat WHERE id IS NOT NULL AND type=''GULLY'' ' 
WHERE columnname='system_id' and formname ilike 'v_edit_cat_feature_gully';

UPDATE config_form_fields SET dv_querytext='SELECT id as id, id as idval FROM sys_feature_cat WHERE id IS NOT NULL AND type=''NODE'' ' 
WHERE columnname='system_id' and formname ilike 'v_edit_cat_feature_node';

INSERT INTO sys_table(id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, source, style_id, addparam)
VALUES ('v_edit_cat_feature_gully', 'Editable view for cat_feature_gully configuration', 'role_admin', null, '{"level_1":"INVENTORY","level_2":"CATALOGS"}',4, 'Gully feature catalog', null,null,null,'core',null,null)
ON CONFLICT (id) DO NOTHING;

