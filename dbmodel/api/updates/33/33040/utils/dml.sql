/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/13
UPDATE config_api_form_fields SET dv_querytext_filterc = replace(dv_querytext_filterc,'=','') WHERE dv_querytext_filterc is not null;

-- 2020/03/16
UPDATE  config_api_form_fields SET widgettype ='typeahead', dv_parent_id = 'streetname',
dv_querytext = 'SELECT a.postnumber AS id, a.postnumber AS idval FROM ext_address a JOIN ext_streetaxis m ON streetaxis_id=m.id WHERE a.id IS NOT NULL',
dv_querytext_filterc = 'AND m.name' 
WHERE column_id = 'postnumber';

UPDATE  config_api_form_fields SET widgettype ='typeahead', dv_parent_id = 'streetname2',
dv_querytext = 'SELECT a.postnumber AS id, a.postnumber AS idval FROM ext_address a JOIN ext_streetaxis m ON streetaxis_id=m.id WHERE a.id IS NOT NULL', 
dv_querytext_filterc = 'AND m.name' 
WHERE column_id = 'postnumber2';

UPDATE  config_api_form_fields SET column_id = 'streetname', label = 'streetname', widgettype = 'typeahead',
dv_querytext = 'SELECT id AS id, a.name AS idval FROM ext_streetaxis a JOIN ext_municipality m USING (muni_id) WHERE id IS NOT NULL', 
dv_querytext_filterc = 'AND m.name' 
WHERE column_id = 'streetaxis_id';

UPDATE  config_api_form_fields SET column_id = 'streetname2', label = 'streetname2', widgettype = 'typeahead',
dv_querytext = 'SELECT id AS id, a.name AS idval FROM ext_streetaxis a JOIN ext_municipality m USING (muni_id) WHERE id IS NOT NULL', 
dv_querytext_filterc = 'AND m.name' 
WHERE column_id = 'streetaxis2_id';


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_arc', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_arc', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'Insert tstamp', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_node', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_node', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'Insert timestamp', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_connec', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_connec', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'Insert tstamp', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_arc', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_arc', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'Insert tstamp', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_node', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_node', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'Insert tstamp', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_connec', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_connec', 'feature', 'tstamp', null, 'text', 'text', 'Insert tstamp', NULL, 'Insert tstamp', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

UPDATE config_api_form_fields SET hidden = true WHERE column_id = 'cat_arctype_id' and (formname  like '%ve_arc%' or formname  = 'v_edit_arc');
UPDATE config_api_form_fields SET hidden = true WHERE column_id = 'nodetype_id' and (formname  like '%ve_node%' or formname  = 'v_edit_node');
UPDATE config_api_form_fields SET hidden = true WHERE column_id = 'connectype_id' and (formname  like '%ve_connec%' or formname  = 'v_edit_connec');

UPDATE config_api_form_fields SET widgettype = 'text' where column_id = 'lastupdate';
UPDATE config_api_form_fields SET widgettype = 'combo' where column_id = 'macrosector_id';

--2020/03/31
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_feature_cat", "column":"orderby"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_feature_cat", "column":"shortcut_key"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_feature_cat", "column":"tablename"}}$$);

--2020/04/06
UPDATE config_api_form_fields SET ismandatory=FALSE WHERE ismandatory IS NULL;
UPDATE config_api_form_fields SET isparent=FALSE WHERE isparent IS NULL;
UPDATE config_api_form_fields SET iseditable=FALSE WHERE iseditable IS NULL;
UPDATE config_api_form_fields SET isautoupdate=FALSE WHERE isautoupdate IS NULL;
UPDATE config_api_form_fields SET dv_orderby_id=TRUE WHERE dv_orderby_id IS NULL AND widgettype = 'combo';
UPDATE config_api_form_fields SET dv_isnullvalue=FALSE WHERE dv_isnullvalue IS NULL AND widgettype = 'combo';