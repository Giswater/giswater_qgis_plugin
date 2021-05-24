/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/13
UPDATE sys_table SET sys_role='role_edit' WHERE id='inp_connec';


INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_mat_roughness', 'form_feature', 'main', 'id', null, null, 'integer', 'text', 'id', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_mat_roughness', 'form_feature', 'main', 'matcat_id', null, null, 'string', 'combo', 'matcat_id', true, false, true, 
false, false, 'SELECT id, id AS idval FROM cat_mat_arc WHERE id IS NOT NULL', null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_mat_roughness', 'form_feature', 'main', 'period_id', null, null, 'string', 'text', 'period_id', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_mat_roughness', 'form_feature', 'main', 'init_age', null, null, 'integer', 'text', 'init_age', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_mat_roughness', 'form_feature', 'main', 'end_age', null, null, 'integer', 'text', 'end_age', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_mat_roughness', 'form_feature', 'main', 'roughness', null, null, 'numeric', 'text', 'roughness', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_mat_roughness', 'form_feature', 'main', 'descript', null, null, 'string', 'text', 'descript', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);

INSERT INTO config_form_fields(
formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, 
isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('cat_mat_roughness', 'form_feature', 'main', 'active', null, null, 'boolean', 'check', 'active', false, false, true, 
false, false, null, null,false, null, null,null,
null,null,null,false);