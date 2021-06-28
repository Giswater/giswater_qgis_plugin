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
VALUES ('cat_arc','form_feature', 'main', 'pnom',null,null,'double', 'text','pnom',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'dnom',null,null,'double', 'text','dnom',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'dint',null,null,'double', 'text','dint',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_arc','form_feature', 'main', 'dext',null,null,'double', 'text','dext',null, false,
false, true, false, null, null, null,null, null, null, null,null, null, null, false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

--2021/06/28
INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname)
VALUES ('inp_curve', 'form_feature', 'sector_id', NULL, 'integer', 'combo', 'sector_id', FALSE, FALSE,
TRUE, FALSE, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL ' , TRUE, TRUE,
NULL,NULL,NULL, NULL,FALSE,'main') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname)
VALUES ('inp_pattern', 'form_feature', 'sector_id', NULL, 'integer', 'combo', 'sector_id', FALSE, FALSE,
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
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname)
SELECT 'v_edit_inp_pattern', formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname
FROM config_form_fields WHERE formname = 'inp_pattern' AND columnname not in ('pattern_type') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname)
SELECT 'v_edit_inp_pattern_value', formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
FALSE, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname
FROM config_form_fields WHERE formname = 'inp_pattern' AND columnname not in ('pattern_type', 'pattern_id') 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden,tabname)
SELECT 'v_edit_inp_pattern_value', formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname
FROM config_form_fields WHERE formname = 'inp_pattern_value' AND columnname not ilike '_f%' 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname)
SELECT 'v_edit_inp_rules', formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname
FROM config_form_fields WHERE formname = 'inp_rules' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname)
SELECT 'v_edit_inp_controls', formtype, columnname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, 
iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, 
dv_parent_id, dv_querytext_filterc, widgetfunction, linkedobject,  hidden, tabname
FROM config_form_fields WHERE formname = 'inp_controls' ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

