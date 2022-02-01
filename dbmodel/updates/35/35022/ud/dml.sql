/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/31
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'inp_pattern', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_curve' AND columnname='expl_id' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'inp_pattern', formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden
FROM config_form_fields WHERE formname='v_edit_cat_dscenario' AND columnname IN ('log')
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'inp_pattern', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_curve' AND columnname='expl_id' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, 
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('inp_pattern', 'form_feature', 'main', 'tsparameters', NULL, NULL, 
'string', 'text', 'tsparameters', NULL, NULL, false, false, true, false, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, false) 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_pattern', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_pattern' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_pattern_value', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_pattern' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_pattern_value', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_pattern' AND columnname ilike 'factor%' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'inp_timeseries', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='v_edit_inp_curve' AND columnname IN ('descript', 'log','expl_id') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_timeseries', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_timeseries' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_timeseries_value', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_timeseries' AND columnname IN ('timser_type','times_type','idval','expl_id')  ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
SELECT 'v_edit_inp_timeseries_value', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden 
FROM config_form_fields WHERE formname ='inp_timeseries_value'  ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET widgettype='combo', 
dv_querytext='SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',
widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": ""}}'
WHERE formname='v_edit_inp_pattern_value' AND columnname='pattern_id';

INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_pattern', 'View to edit patterns, filtered by expl_id','role_epa', '{"level_1":"EPA","level_2":"CATALOGS"}', 3, 'Pattern catalog', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_pattern_value', 'View to edit curve values, filtered by expl_id','role_epa','{"level_1":"EPA","level_2":"CATALOGS"}', 4,
'Pattern values', 'core')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET alias=NULL, orderby=NULL, context=NULL WHERE id IN ('inp_pattern', 'inp_pattern_value');

UPDATE config_form_fields SET widgetcontrols='{"valueRelation":{"nullValue":true, "layer": "cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": ""}}'
WHERE columnname='dscenario_id' AND formname='v_edit_inp_dscenario_junction';

UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":true, "layer": "v_edit_inp_timeseries", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": ""}}'
WHERE columnname='timser_id';

UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": ""}}'
WHERE columnname='pattern_id';

INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_timeseries', 'View to edit timeseries, filtered by expl_id','role_epa', '{"level_1":"EPA","level_2":"CATALOGS"}', 7, 
'Timeseries catalog', 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, context, orderby, alias, source)
VALUES ('v_edit_inp_timeseries_value', 'View to edit timeseries values, filtered by expl_id','role_epa','{"level_1":"EPA","level_2":"CATALOGS"}', 8,
'Timeseries values', 'core')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET alias=NULL, orderby=NULL, context=NULL WHERE id IN ('inp_timeseries', 'inp_timeseries_value');