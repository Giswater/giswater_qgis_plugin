/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/13
UPDATE config_api_form_fields SET dv_querytext_filterc = replace(dv_querytext_filterc,'=','') WHERE dv_querytext_filterc is not null;

-- 2020/03/16
UPDATE config_api_form_fields SET layoutname = 'lyt_data_1' WHERE layoutname = 'layout_data_1';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_2' WHERE layoutname = 'layout_data_2';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3' WHERE layoutname = 'layout_data_3';
UPDATE config_api_form_fields SET layoutname = 'lyt_bot_1' WHERE layoutname = 'bot_layout_1';
UPDATE config_api_form_fields SET layoutname = 'lyt_bot_2' WHERE layoutname = 'bot_layout_2';
UPDATE config_api_form_fields SET layoutname = 'lyt_top_1' WHERE layoutname = 'top_layout';

UPDATE config_api_form_fields SET layoutname = 'lyt_top_1' WHERE formtype='catalog' AND layoutname = 'top_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_distance' WHERE formtype='catalog' AND layoutname = 'distance_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_depth' WHERE formtype='catalog' AND layoutname = 'depth_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_symbology' WHERE formtype='catalog' AND layoutname = 'symbology_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_other' WHERE formtype='catalog' AND layoutname = 'other_layout';


UPDATE config_api_form_fields SET widgettype ='typeahead',
dv_querytext= 'select id as id, postnumber as idval from v_ext_address WHERE id IS NOT NULL ',
dv_querytext_filterc = ' AND v_ext_address.streetname ',
dv_parent_id = 'streetname'
WHERE column_id = 'postnumber';


UPDATE config_api_form_fields SET widgettype ='typeahead',
dv_querytext= 'select id as id, postnumber as idval from v_ext_address WHERE id IS NOT NULL ',
dv_querytext_filterc = ' AND v_ext_address.streetname ',
dv_parent_id = 'streetname2'
WHERE column_id = 'postnumber2';


UPDATE config_api_form_fields SET column_id = 'streetname', label = 'streetname', widgettype = 'typeahead', dv_querytext = 'SELECT id AS id, name AS idval FROM ext_streetaxis WHERE id IS NOT NULL',
dv_querytext_filterc = 'AND muni_id', dv_parent_id = 'muni_id' 
WHERE column_id = 'streetaxis_id';

UPDATE config_api_form_fields SET column_id = 'streetname2', label = 'streetname2', widgettype = 'typeahead', dv_querytext = 'SELECT id AS id, name AS idval FROM ext_streetaxis WHERE id IS NOT NULL',
dv_querytext_filterc = 'AND muni_id', dv_parent_id = 'muni_id' 
WHERE column_id = 'streetaxis2_id';


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_arc', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_arc', 'feature', 'tstamp', null, 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_node', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_node', 'feature', 'tstamp', null, 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_connec', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_connec', 'feature', 'tstamp', null, 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_arc', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_arc', 'feature', 'tstamp', null, 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_node', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_node', 'feature', 'tstamp', null, 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_connec', 'feature', 'macroexpl_id', null , 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_connec', 'feature', 'tstamp', null, 'text', 'text', 'Macroexploitation', NULL, 'Macroexploitation', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

UPDATE config_api_form_fields SET hidden = true WHERE column_id = 'cat_arctype_id' and formname  like '%ve_arc%' or formname  = 'v_edit_arc';
UPDATE config_api_form_fields SET hidden = true WHERE column_id = 'nodetype_id' and formname  like '%ve_node%' or formname  = 'v_edit_node';
UPDATE config_api_form_fields SET hidden = true WHERE column_id = 'connectype_id' and formname  like '%ve_connec%' or formname  = 'v_edit_connec';



