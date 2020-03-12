/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/02/27
UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('button', 'check', 'combo', 'datepikertime', 'doubleSpinbox', 'hyperlink', 'text', 'typeahead') AND typevalue = 'widgettype_typevalue';

UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('boolean', 'date', 'dobule', 'integer', 'numeric', 'smallint', 'text') AND typevalue = 'datatype_typevalue';

UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('gw_api_open_url') AND typevalue = 'widgetfunction_typevalue';

UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('bot_layout_1', 'bot_layout_2', 'layout_data_1', 'layout_data_2', 'layout_data_3', 'top_layout') AND typevalue = 'layout_name_typevalue';


SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'id', 1, 'integer', 'text', 'id', 
NULL, NULL, NULL, TRUE, NULL, FALSE, NULL, NULL, 
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'formname', 2, 'text', 'text', 'Formname',
NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'formtype', 3, 'text', 'text', 'Formtype',
NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'column_id', 4, 'text', 'text', 'Column id', NULL, 'column_id - Id of the column', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'label', 5, 'text', 'text', 'Label', NULL, 'label - Label shown on the item form', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'hidden', 6, 'boolean', 'check', 'Hidden', NULL, 'hidden - Hide this field from form', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'layoutname', 7, 'text', 'combo', 'Layout name', NULL, 'layoutname - Name of the layout which field will be located', NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue= ''layout_name_typevalue'' AND  addparam->>''createAddfield''=''TRUE''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'layout_order', 8, 'integer', 'text', 'Layout order', NULL, 'layout_order - Order in the layout which field will be located', 
NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'iseditable', 9, 'boolean', 'check', 'Is editable', NULL, 'iseditable - Field is editable or not', 
NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'ismandatory', 10, 'boolean', 'check', 'Is mandatory', NULL, 'ismandatory - Field is mandatory or not', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'datatype', 11, 'text', 'combo', 'Datatype', NULL, 'datatype - Data type of the field', NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''datatype_typevalue'' AND addparam->>''createAddfield''=''TRUE''',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'widgettype', 12, 'text', 'combo', 'Widgettype', NULL, 
'widgettype - Widget of the field. Must match with the data type. Advanced configuration on widgetcontrols field is possible
If widgettype=''text'', you can force values using "minValue" or "maxValue" or "regexpControl". In addition you can enable multiline widget using "setQgisMultiline"
If widgettype=''combo'', you can only make editable combo for specific values of child using comboEnableWhenParent
If widgettype=''typeahead'', it is mandatory to use "typeaheadSearchField" to define search to be used', 
NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''widgettype_typevalue'' AND addparam->>''createAddfield''=''TRUE''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'widgetdim', 13, 'integer', 'text', 'Widgetdim', NULL, 'widgetdim - Dimension of the widget (may affect all widgets on same layout)', NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'tooltip', 14, 'text', 'text', 'Tooltip', NULL, 'tooltip - Tooltip shown when mouse passes over the label', NULL,  FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'placeholder', 15, 'text', 'text', 'Placeholder', NULL, 'placeholder - Sample value for textedit widgets', NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'stylesheet', 16, 'text', 'text', 'Stylesheet', NULL, 'stylesheet - Style of the label in the form. CSS styles are allowed', '{"label":"color:blue; font-weight:bold; font-style:normal; font-size:15px; background-color: yellow"}',  FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'isparent', 17, 'boolean', 'check', 'Isparent', NULL, 'isparent - Is parent of another field', NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'isautoupdate', 18, 'boolean', 'check', 'Isautoupdate', NULL, 
'isautoupdate - Force update of feature. If is true, you can use the key autoupdateReloadFields of widgetcontrols to identify fields must be reloaded with updated values.
Warning: It is dangerous for typeahead widget. It crashes!'
, NULL,  TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_querytext', 19, 'text', 'text', 'Dv querytext', NULL, 'dv_querytext - For combos, query which fill the values of the combo. Must have id, idval column structure', 'SELECT id, idval FROM some_table WHERE some_column=''some_value''', FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_orderby_id', 20, 'boolean', 'check', 'Dv orderby id', NULL, 'dv_orderby_id - For combos, order for id or not', NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_isnullvalue', 21, 'boolean', 'check', 'Dv isnullvalue', NULL, 'dv_isnullvalue - For combos, allow null value', NULL,  FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_parent_id', 22, 'text', 'text', 'Dv parentid', NULL, 'dv_parent_id - Id of the related parent table', NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'dv_querytext_filterc', 23, 'text', 'text', 'Dv querytext filterc', NULL, 'dv_querytext_filterc - Filter related to the parent table', ' AND value_state_type.state=', FALSE, NULL, TRUE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'widgetcontrols', 24, 'text', 'text', 'Widget controls', NULL, 
'widgetcontrols - Advanced options to control the widget.
If widgettype=''text'', you can force values using "minValue" or "maxValue" or "regexpControl". In addition you can enable multiline widget using "setQgisMultiline"
If widgettype=''combo'', you can only make editable combo for specific values of child using comboEnableWhenParent
If widgettype=''typeahead'', it is mandatory to use "typeaheadSearchField" to define search to be used
If isautoupdate=true, you can use autoupdateReloadFields to identify fields must be reloaded with updated values',
'{"setQgisMultiline":true, "minValue":0.001, "maxValue":100, "autoupdateReloadFields":["a", "b"], "typeaheadSearchField":"id", 
"comboEnableWhenParent":["a", "b"], "regexpControl":"[]"}', 
FALSE, NULL, TRUE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'widgetfunction', 25, 'text', 'combo', 'Widget function', NULL, 'widgetfunction - Python action triggered by users click on widget', NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''widgetfunction_typevalue''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'linkedaction', 26, 'text', 'combo', 'Linked action', NULL, 'linkedaction - Form action related with this field', NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''actionfunction_typevalue''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('ve_config_sysfields', 'form', 'listfilterparam', 27, 'text', 'text', 'Listfilterparam', NULL, 'listfilterparam - Parameters of the filters for lists', '{"sign":">","vdefault":"2014-01-01"}', FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, TRUE);


INSERT INTO config_api_form_actions (actionname) VALUES ('actionEdit');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionCopyPaste');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionCatalog');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionWorkcat');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionRotation');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionZoomIn');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionZoomOut');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionCentered');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionLink');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionHelp');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionGetArcId');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionAddPhoto');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionAddFile');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionDelete');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionGetParentId');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionSection');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionInterpolate');
INSERT INTO config_api_form_actions (actionname) VALUES ('visit_start');
INSERT INTO config_api_form_actions (actionname) VALUES ('visit_end');
INSERT INTO config_api_form_actions (actionname) VALUES ('actionZoom');
INSERT INTO config_api_form_actions (actionname) VALUES ('getInfoFromId');

--2020/03/10
UPDATE config_api_form_fields SET isautoupdate = FALSE WHERE widgettype='typeahead';
UPDATE config_api_form_fields SET widgetcontrols = gw_fct_json_object_delete_keys(widgetcontrols,'autoupdateReloadFields', 'typeaheadSearchField') WHERE widgettype='typeahead';


UPDATE config_api_form_fields SET dv_parent_id = null, dv_querytext_filterc = null where column_id = 'category_type'

UPDATE config_api_form_fields SET widgettype = 'text' WHERE column_id = 'macrodma_id';
UPDATE config_api_form_fields SET widgettype = 'text' WHERE column_id = 'macroexpl_id';
UPDATE config_api_form_fields SET widgettype = 'text' WHERE column_id = 'macrosector_id';
