/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/27
UPDATE config_api_form_fields SET typeahead= gw_fct_json_object_delete_keys(typeahead,'threshold', 'noresultsMsg', 'loadingMsg');

UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('button', 'check', 'combo', 'datepikertime', 'doubleSpinbox', 'hyperlink', 'text', 'typeahead') AND typevalue = 'widgettype_typevalue';

UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('boolean', 'date', 'dobule', 'integer', 'numeric', 'smallint', 'text') AND typevalue = 'datatype_typevalue';

UPDATE config_api_typevalue SET addparam='{"createAddfield":"TRUE"}' WHERE id IN ('gw_api_open_url') AND typevalue = 'widgetfunction_typevalue';


SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'id', 1, 1, true, 'integer', 'text', 'id', NULL, NULL, NULL, 100, NULL, TRUE, NULL, FALSE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'formname', 1, 2, true, 'text', 'text', 'Formname:', NULL, NULL, NULL, 100, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'column_id', 1, 3, true, 'text', 'text', 'Column id:', NULL, 'column_id - Id of the column', NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'label', 1, 4, true, 'text', 'text', 'Label:', NULL, 'label - Label shown on the item form', NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'layout_name', 1, 5, true, 'text', 'text', 'Layout name:', NULL, 'layout_name - Name of the layout which field will be located', 'layot_data_1', NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'layout_order', 1, 6, true, 'integer', 'text', 'Layout order:', NULL, 'layout_order - Order in the layout which field will be located', NULL, 10, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'iseditable', 1, 7, true, 'boolean', 'check', 'Is editable:', NULL, 'iseditable - Field is editable or not', NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'ismandatory', 1, 8, true, 'boolean', 'check', 'Is mandatory:', NULL, 'ismandatory - Field is mandatory or not', NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'widgetdim', 1, 9, true, 'integer', 'text', 'Widgetdim:', NULL, 'widgetdim - Dimension of the widget (may affect all widgets on same layout)', NULL, 10, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'widgetcontrols', 1, 10, true, 'text', 'text', 'Widget controls:', NULL, 'widgetcontrols - Advanced options to control the widget', '{"setQgisMultiline":true, "minValue":0.001, "maxValue":100}', NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'tooltip', 1, 11, true, 'text', 'text', 'Tooltip:', NULL, 'tooltip - Tooltip shown when mouse passes over the label', NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'placeholder', 1, 12, true, 'text', 'text', 'Placeholder:', NULL, 'placeholder - Sample value for textedit widgets', NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'stylesheet', 1, 13, true, 'text', 'text', 'Stylesheet:', NULL, 'stylesheet - Style of the label in the form. CSS styles are allowed', '{"label":"color:blue; font-weight:bold; font-style:normal; font-size:15px; background-color: yellow"}', NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'hidden', 1, 14, true, 'boolean', 'check', 'Hidden:', NULL, 'hidden - Hide this field from form', NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, FALSE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'datatype', 1, 15, true, 'text', 'combo', 'Datatype:', NULL, 'datatype - Data type of the field', NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''datatype_typevalue'' AND addparam->>''createAddfield''=''TRUE''',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'widgettype', 1, 16, true, 'text', 'combo', 'Widgettype:', NULL, 'widgettype - Widget of the field. Must match with the data type', NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''widgettype_typevalue'' AND addparam->>''createAddfield''=''TRUE''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'field_length', 1, 17, true, 'integer', 'text', 'Field length:', NULL, 'field_length - Maximum number of characters of the field in case of datatype is integer or numeric', NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'num_decimals', 1, 18, true, 'integer', 'text', 'Num decimals:', NULL, 'num_decimals - Number of decimals in case of datatype is numeric', NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);



INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'isparent', 1, 19, true, 'boolean', 'check', 'Isparent:', NULL, 'isparent - Is parent of another field', NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);



INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'isautoupdate', 1, 20, true, 'boolean', 'check', 'Isautoupdate:', NULL, 'isautoupdate - Force update of feature (not valid for typeahead widget)', NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);



INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'dv_querytext', 1, 21, true, 'text', 'text', 'Dv querytext:', NULL, 'dv_querytext - For combos, query which fill the values of the combo. Must have id, idval column structure', 'SELECT id, idval FROM some_table WHERE some_column=''some_value''', NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'dv_orderby_id', 1, 22, true, 'boolean', 'check', 'Dv orderby id:', NULL, 'dv_orderby_id - For combos, order for id or not', NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'dv_isnullvalue', 1, 23, true, 'boolean', 'check', 'Dv isnullvalue:', NULL, 'dv_isnullvalue - For combos, allow null value', NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'dv_parent_id', 1, 24, true, 'text', 'text', 'Dv parentid:', NULL, 'dv_parent_id - Id of the related parent table', NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'dv_querytext_filterc', 1, 25, true, 'text', 'text', 'Dv querytext filterc:', NULL, 'dv_querytext_filterc - Filter related to the parent table', ' AND value_state_type.state=', NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'widgetfunction', 1, 26, true, 'text', 'combo', 'Widget function:', NULL, 'widgetfunction - Python action triggered by users click on widget', NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''widgetfunction_typevalue''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'action_function', 1, 27, true, 'text', 'combo', 'Action function:', NULL, 'action_function - Form action related and triggered by this field', NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM config_api_typevalue WHERE typevalue=''actionfunction_typevalue''', 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);



INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'typeahead', 1, 28, true, 'text', 'text', 'Typeahead:', NULL, 'typeahead - Json which define properties of typeahed', '{"fieldToSearch":"id"}', NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);



INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'listfilterparam', 1, 29, true, 'text', 'text', 'Listfilterparam:', NULL, 'listfilterparam - Parameters of the filters for lists', '{"sign":">","vdefault":"2014-01-01"}', NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols, hidden, reload_field) 
VALUES ('ve_config_sys_fields', 'form', 'reload_field', 1, 30, true, 'text', 'text', 'Reload field:', NULL, 'reload_field - When auto update is TRUE, columns to reload values', '{"reload":["some_column1", "some_column1"]}', NULL, NULL, FALSE, NULL, TRUE, NULL, NULL, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'data_1', NULL, NULL, TRUE, NULL);
