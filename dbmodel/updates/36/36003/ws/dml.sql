/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3250, 'gw_trg_edit_minsector', 'ws', 'trigger function', NULL, NULL, 'Allows editing minsector view', 'role_edit', NULL, 'core');

UPDATE sys_style SET idval = 'v_edit_minsector' WHERE  idval = 'v_minsector';
UPDATE sys_table SET id = 'v_edit_minsector' WHERE  id = 'v_minsector';

UPDATE config_toolbox SET inputparams = 
'[{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":1, "placeholder":"[1,2]", "value":""},
{"widgetname":"sector", "label":"Sector id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"usePsectors", "label":"Use masterplan psectors:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":6, "value":"FALSE"},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":8,
"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":10, "isMandatory":false, "placeholder":"5-30", "value":""}]'
WHERE id = 2706;

-- info epa +/- buttons
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_connec', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_connec",
    "tablename": "v_edit_inp_dscenario_connec",
    "pkey": [
      "dscenario_id",
      "connec_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_connec", "view": "v_edit_inp_dscenario_connec", "add_view": "v_edit_inp_dscenario_connec", "pk": ["dscenario_id", "connec_id"]}
   ]
  }
}'::json, 'tbl_inp_connec', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_connec', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_connec', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_connec', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_connec",
    "tablename": "v_edit_inp_dscenario_connec",
    "pkey": [
      "dscenario_id",
      "connec_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_connec", "view": "v_edit_inp_dscenario_connec", "add_view": "v_edit_inp_dscenario_connec", "pk": ["dscenario_id", "connec_id"]}
   ]
  }
}'::json, 'tbl_inp_connec', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_inlet",
    "tablename": "v_edit_inp_dscenario_inlet",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_inlet", "view": "v_edit_inp_dscenario_inlet", "add_view": "v_edit_inp_dscenario_inlet", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_inlet', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_inlet', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_inlet",
    "tablename": "v_edit_inp_dscenario_inlet",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_inlet", "view": "v_edit_inp_dscenario_inlet", "add_view": "v_edit_inp_dscenario_inlet", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_inlet', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_junction', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_junction",
    "tablename": "v_edit_inp_dscenario_junction",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_junction", "view": "v_edit_inp_dscenario_junction", "add_view": "v_edit_inp_dscenario_junction", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_junction', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_junction', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_junction', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_junction', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_junction",
    "tablename": "v_edit_inp_dscenario_junction",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_junction", "view": "v_edit_inp_dscenario_junction", "add_view": "v_edit_inp_dscenario_junction", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_junction', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_pipe', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_pipe",
    "tablename": "v_edit_inp_dscenario_pipe",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_pipe", "view": "v_edit_inp_dscenario_pipe", "add_view": "v_edit_inp_dscenario_pipe", "pk": ["dscenario_id", "arc_id"]}
   ]
  }
}'::json, 'tbl_inp_pipe', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_pipe', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_pipe', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_pipe', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_pipe",
    "tablename": "v_edit_inp_dscenario_pipe",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_pipe", "view": "v_edit_inp_dscenario_pipe", "add_view": "v_edit_inp_dscenario_pipe", "pk": ["dscenario_id", "arc_id"]}
   ]
  }
}'::json, 'tbl_inp_pipe', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_pump', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_pump",
    "tablename": "v_edit_inp_dscenario_pump",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_pump", "view": "v_edit_inp_dscenario_pump", "add_view": "v_edit_inp_dscenario_pump", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_pump', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_pump', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_pump', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_pump', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_pump",
    "tablename": "v_edit_inp_dscenario_pump",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_pump", "view": "v_edit_inp_dscenario_pump", "add_view": "v_edit_inp_dscenario_pump", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_pump', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_reservoir', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_reservoir",
    "tablename": "v_edit_inp_dscenario_reservoir",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_reservoir", "view": "v_edit_inp_dscenario_reservoir", "add_view": "v_edit_inp_dscenario_reservoir", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_reservoir', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_reservoir', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_reservoir', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_reservoir', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_reservoir",
    "tablename": "v_edit_inp_dscenario_reservoir",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_reservoir", "view": "v_edit_inp_dscenario_reservoir", "add_view": "v_edit_inp_dscenario_reservoir", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_reservoir', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_shortpipe",
    "tablename": "v_edit_inp_dscenario_shortpipe",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_shortpipe", "view": "v_edit_inp_dscenario_shortpipe", "add_view": "v_edit_inp_dscenario_shortpipe", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_shortpipe', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_shortpipe', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_shortpipe",
    "tablename": "v_edit_inp_dscenario_shortpipe",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_shortpipe", "view": "v_edit_inp_dscenario_shortpipe", "add_view": "v_edit_inp_dscenario_shortpipe", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_shortpipe', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_tank', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_tank",
    "tablename": "v_edit_inp_dscenario_tank",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_tank", "view": "v_edit_inp_dscenario_tank", "add_view": "v_edit_inp_dscenario_tank", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_tank', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_tank', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_tank', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_tank', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_tank",
    "tablename": "v_edit_inp_dscenario_tank",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_tank", "view": "v_edit_inp_dscenario_tank", "add_view": "v_edit_inp_dscenario_tank", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_tank', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_valve",
    "tablename": "v_edit_inp_dscenario_valve",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_valve", "view": "v_edit_inp_dscenario_valve", "add_view": "v_edit_inp_dscenario_valve", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_valve', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_valve', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_valve",
    "tablename": "v_edit_inp_dscenario_valve",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_valve", "view": "v_edit_inp_dscenario_valve", "add_view": "v_edit_inp_dscenario_valve", "pk": ["dscenario_id", "node_id"]}
   ]
  }
}'::json, 'tbl_inp_valve', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_virtualpump', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_virtualpump",
    "tablename": "v_edit_inp_dscenario_virtualpump",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_virtualpump", "view": "v_edit_inp_dscenario_virtualpump", "add_view": "v_edit_inp_dscenario_virtualpump", "pk": ["dscenario_id", "arc_id"]}
   ]
  }
}'::json, 'tbl_inp_virtualpump', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_virtualpump', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_virtualpump', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_virtualpump', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_virtualpump",
    "tablename": "v_edit_inp_dscenario_virtualpump",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_virtualpump", "view": "v_edit_inp_dscenario_virtualpump", "add_view": "v_edit_inp_dscenario_virtualpump", "pk": ["dscenario_id", "arc_id"]}
   ]
  }
}'::json, 'tbl_inp_virtualpump', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_virtualvalve', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_virtualvalve",
    "tablename": "v_edit_inp_dscenario_virtualvalve",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_virtualvalve", "view": "v_edit_inp_dscenario_virtualvalve", "add_view": "v_edit_inp_dscenario_virtualvalve", "pk": ["dscenario_id", "arc_id"]}
   ]
  }
}'::json, 'tbl_inp_virtualvalve', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_virtualvalve', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_virtualvalve', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_virtualvalve', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_virtualvalve",
    "tablename": "v_edit_inp_dscenario_virtualvalve",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_virtualvalve", "view": "v_edit_inp_dscenario_virtualvalve", "add_view": "v_edit_inp_dscenario_virtualvalve", "pk": ["dscenario_id", "arc_id"]}
   ]
  }
}'::json, 'tbl_inp_virtualvalve', false, NULL);

-- config tableviews
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, connec_id, pjoint_type, pjoint_id, demand, pattern_id, peak_factor, status, minorloss, custom_roughness, custom_length, custom_dint FROM v_edit_inp_dscenario_connec WHERE connec_id IS NOT NULL'
	WHERE listname='tbl_inp_connec';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, overflow, head, pattern_id, mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id FROM v_edit_inp_dscenario_inlet WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_inlet';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, demand, pattern_id, emitter_coeff, init_quality, source_type, source_quality, source_pattern_id FROM v_edit_inp_dscenario_junction WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_junction';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, arc_id, minorloss, status, roughness, dint, bulk_coeff, wall_coeff FROM v_edit_inp_dscenario_pipe WHERE arc_id IS NOT NULL'
	WHERE listname='tbl_inp_pipe';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id FROM v_edit_inp_dscenario_pump WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_pump';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, pattern_id, head, init_quality, source_type, source_quality, source_pattern_id FROM v_edit_inp_dscenario_reservoir WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_reservoir';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, minorloss, status, bulk_coeff, wall_coeff FROM v_edit_inp_dscenario_shortpipe WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_shortpipe';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id, mixing_model, mixing_fraction, reaction_coeff, init_quality, source_type, source_quality, source_pattern_id FROM v_edit_inp_dscenario_tank WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_tank';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, nodarc_id, valv_type, pressure, flow, coef_loss, curve_id, minorloss, status, add_settings, init_quality FROM v_edit_inp_dscenario_valve WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_valve';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, arc_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id FROM v_edit_inp_dscenario_virtualpump WHERE arc_id IS NOT NULL'
	WHERE listname='tbl_inp_virtualpump';

UPDATE sys_fprocess SET fprocess_name = 'Non-mandatory nodarc with less than two arcs' WHERE fid = 292;
DELETE FROM sys_fprocess WHERE fid = 293;

-- 01/08/23

UPDATE config_form_fields
SET layoutorder = (SELECT attnum FROM pg_attribute WHERE attrelid = formname::regclass AND attname = columnname and attnum > 0 AND NOT attisdropped ORDER BY attnum LIMIT 1)
WHERE formname IN ('v_edit_inp_flwreg_orifice', 'v_edit_inp_dscenario_flwreg_orifice', 'v_edit_inp_flwreg_outlet', 'v_edit_inp_dscenario_flwreg_outlet', 'v_edit_inp_flwreg_pump', 'v_edit_inp_dscenario_flwreg_pump', 'v_edit_inp_flwreg_weir', 'v_edit_inp_dscenario_flwreg_weir', 'v_edit_inp_dscenario_demand', 'v_edit_inp_dscenario_pump_additional', 'v_edit_inp_dscenario_pump','v_edit_inp_pump_additional', 'v_edit_inp_dscenario_virtualvalve', 'v_edit_inp_dscenario_virtualpump', 'v_edit_inp_dscenario_valve', 'v_edit_inp_dscenario_tank', 'v_edit_inp_dscenario_shortpipe', 'v_edit_inp_dscenario_rules', 'v_edit_inp_dscenario_reservoir', 'v_edit_inp_dscenario_pipe', 'v_edit_inp_dscenario_junction', 'v_edit_inp_dscenario_inlet', 'v_edit_inp_dscenario_controls', 'v_edit_inp_dscenario_connec', 'inp_dscenario_virtualvalve', 'v_edit_inp_dscenario_conduit', 'v_edit_inp_dscenario_inflows', 'v_edit_inp_dscenario_inflows_poll', 'v_edit_inp_dscenario_lid_usage', 'v_edit_inp_dscenario_outfall', 'v_edit_inp_dscenario_raingage', 'v_edit_inp_dscenario_storage', 'v_edit_inp_dscenario_treatment');

-- set hiden and iseditable for dscenario arc_id/node_id/connec_id/feature_id
UPDATE config_form_fields
SET iseditable = false, hidden = false
WHERE formname IN ('v_edit_inp_flwreg_orifice', 'v_edit_inp_dscenario_flwreg_orifice', 'v_edit_inp_flwreg_outlet', 'v_edit_inp_dscenario_flwreg_outlet', 'v_edit_inp_flwreg_pump', 'v_edit_inp_dscenario_flwreg_pump', 'v_edit_inp_flwreg_weir', 'v_edit_inp_dscenario_flwreg_weir', 'v_edit_inp_dscenario_demand', 'v_edit_inp_dscenario_pump_additional', 'v_edit_inp_dscenario_pump','v_edit_inp_pump_additional', 'v_edit_inp_dscenario_virtualvalve', 'v_edit_inp_dscenario_virtualpump', 'v_edit_inp_dscenario_valve', 'v_edit_inp_dscenario_tank', 'v_edit_inp_dscenario_shortpipe', 'v_edit_inp_dscenario_rules', 'v_edit_inp_dscenario_reservoir', 'v_edit_inp_dscenario_pipe', 'v_edit_inp_dscenario_junction', 'v_edit_inp_dscenario_inlet', 'v_edit_inp_dscenario_controls', 'v_edit_inp_dscenario_connec', 'inp_dscenario_virtualvalve', 'v_edit_inp_dscenario_conduit', 'v_edit_inp_dscenario_inflows', 'v_edit_inp_dscenario_inflows_poll', 'v_edit_inp_dscenario_lid_usage', 'v_edit_inp_dscenario_outfall', 'v_edit_inp_dscenario_raingage', 'v_edit_inp_dscenario_storage', 'v_edit_inp_dscenario_treatment') AND columnname IN ('arc_id', 'node_id', 'connec_id','feature_id');

UPDATE config_form_fields
SET columnname = 'tbl_inp_inlet' WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='tbl_inp_tank' AND tabname='tab_epa';

UPDATE config_form_fields
SET hidden=true
WHERE formname='v_edit_inp_dscenario_junction' AND formtype='form_feature' AND columnname='peak_factor' AND tabname='tab_none';

DELETE FROM config_form_fields
WHERE formname='v_edit_inp_dscenario_pump_additional' AND formtype='form_feature' AND columnname='overflow' AND tabname='tab_none';

UPDATE config_form_fields
SET ismandatory=true
WHERE columnname='speed' AND tabname='tab_none' AND formname ilike 'v_edit_inp_dscenario%';

UPDATE config_form_fields
SET  widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_pump"}'::json
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='tbl_inp_pump' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_junction"}'::json
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='tbl_inp_junction' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_pipe"}'::json
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='tbl_inp_pipe' AND tabname='tab_epa';
UPDATE config_form_fields
SET  widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_shortpipe"}'::json
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='tbl_inp_shortpipe' AND tabname='tab_epa';
UPDATE config_form_fields
SET  widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_tank"}'::json
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='tbl_inp_tank' AND tabname='tab_epa';
UPDATE config_form_fields
SET  widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_reservoir"}'::json
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='tbl_inp_reservoir' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_valve"}'::json
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='tbl_inp_valve' AND tabname='tab_epa';
UPDATE config_form_fields
SET  widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_virtualvalve"}'::json
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='tbl_inp_virtualvalve' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_connec"}'::json
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='tbl_inp_connec' AND tabname='tab_epa';
UPDATE config_form_fields
SET  widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_pump"}'::json
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='tbl_inp_pump' AND tabname='tab_epa';
UPDATE config_form_fields
SET  widgetcontrols='{"saveValue": false, "tableUpsert":"v_edit_inp_dscenario_inlet"}'::json
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='tbl_inp_inlet' AND tabname='tab_epa';

-- 03/08/23

UPDATE config_form_tableview
SET columnindex=0, visible=false WHERE objectname='inp_dscenario_demand' AND columnname='id';
UPDATE config_form_tableview
SET columnindex=1, visible=true WHERE objectname='inp_dscenario_demand' AND columnname='dscenario_id';
UPDATE config_form_tableview
SET columnindex=2, visible=true WHERE objectname='inp_dscenario_demand' AND columnname='feature_id';
UPDATE config_form_tableview
SET columnindex=3, visible=true WHERE objectname='inp_dscenario_demand' AND columnname='feature_type';
UPDATE config_form_tableview
SET columnindex=4, visible=true WHERE objectname='inp_dscenario_demand' AND columnname='demand';
UPDATE config_form_tableview
SET columnindex=5, visible=true WHERE objectname='inp_dscenario_demand' AND columnname='pattern_id';
UPDATE config_form_tableview
SET columnindex=6, visible=true WHERE objectname='inp_dscenario_demand' AND columnname='demand_type';
UPDATE config_form_tableview
SET columnindex=7, visible=true WHERE objectname='inp_dscenario_demand' AND columnname='source';
UPDATE config_form_tableview
SET columnindex=0, visible=false WHERE objectname='inp_dscenario_pump_additional' AND columnname='id';
UPDATE config_form_tableview
SET columnindex=1, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='dscenario_id';
UPDATE config_form_tableview
SET columnindex=2, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='node_id';
UPDATE config_form_tableview
SET columnindex=3, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='order_id';
UPDATE config_form_tableview
SET columnindex=4, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='power';
UPDATE config_form_tableview
SET columnindex=5, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='curve_id';
UPDATE config_form_tableview
SET columnindex=6, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='speed';
UPDATE config_form_tableview
SET columnindex=7, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='pattern_id';
UPDATE config_form_tableview
SET columnindex=8, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='status';
UPDATE config_form_tableview
SET columnindex=9, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='energyparam';
UPDATE config_form_tableview
SET columnindex=10, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='energyvalue';
UPDATE config_form_tableview
SET columnindex=11, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='effic_curve_id';
UPDATE config_form_tableview
SET columnindex=12, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='energy_price';
UPDATE config_form_tableview
SET columnindex=13, visible=true WHERE objectname='inp_dscenario_pump_additional' AND columnname='energy_pattern_id';
UPDATE config_form_tableview
SET columnindex=0, visible=false WHERE objectname='inp_pump_additional' AND columnname='id';
UPDATE config_form_tableview
SET columnindex=1, visible=true WHERE objectname='inp_pump_additional' AND columnname='node_id';
UPDATE config_form_tableview
SET columnindex=2, visible=true WHERE objectname='inp_pump_additional' AND columnname='order_id';
UPDATE config_form_tableview
SET columnindex=3, visible=true WHERE objectname='inp_pump_additional' AND columnname='power';
UPDATE config_form_tableview
SET columnindex=4, visible=true WHERE objectname='inp_pump_additional' AND columnname='curve_id';
UPDATE config_form_tableview
SET columnindex=5, visible=true WHERE objectname='inp_pump_additional' AND columnname='speed';
UPDATE config_form_tableview
SET columnindex=6, visible=true WHERE objectname='inp_pump_additional' AND columnname='pattern_id';
UPDATE config_form_tableview
SET columnindex=7, visible=true WHERE objectname='inp_pump_additional' AND columnname='status';
UPDATE config_form_tableview
SET columnindex=8, visible=true WHERE objectname='inp_pump_additional' AND columnname='energyparam';
UPDATE config_form_tableview
SET columnindex=10, visible=true WHERE objectname='inp_pump_additional' AND columnname='energyvalue';
UPDATE config_form_tableview
SET columnindex=10, visible=true WHERE objectname='inp_pump_additional' AND columnname='effic_curve_id';
UPDATE config_form_tableview
SET columnindex=11, visible=false WHERE objectname='inp_pump_additional' AND columnname='energy_price';
UPDATE config_form_tableview
SET columnindex=12, visible=true WHERE objectname='inp_pump_additional' AND columnname='energy_pattern_id';

UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_pump",
    "tablename": "v_edit_inp_dscenario_pump",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_pump", "view": "v_edit_inp_dscenario_pump", "add_view": "v_edit_inp_dscenario_pump", "pk": ["dscenario_id", "node_id"]}
   ]
 , "add_dlg_title":"Pump" }
}'::json, linkedobject='tbl_inp_pump', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_connec",
    "tablename": "v_edit_inp_dscenario_connec",
    "pkey": [
      "dscenario_id",
      "connec_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_connec", "view": "v_edit_inp_dscenario_connec", "add_view": "v_edit_inp_dscenario_connec", "pk": ["dscenario_id", "connec_id"]}
   ], "add_dlg_title":"Connec" 
  }
}'::json, linkedobject='tbl_inp_connec', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_inlet",
    "tablename": "v_edit_inp_dscenario_inlet",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_inlet", "view": "v_edit_inp_dscenario_inlet", "add_view": "v_edit_inp_dscenario_inlet", "pk": ["dscenario_id", "node_id"]}
   ], "add_dlg_title":"Inlet" 
  }
}'::json, linkedobject='tbl_inp_inlet', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_junction",
    "tablename": "v_edit_inp_dscenario_junction",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_junction", "view": "v_edit_inp_dscenario_junction", "add_view": "v_edit_inp_dscenario_junction", "pk": ["dscenario_id", "node_id"]}
   ]
 , "add_dlg_title":"Junction"  }
}'::json, linkedobject='tbl_inp_junction', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_pipe",
    "tablename": "v_edit_inp_dscenario_pipe",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_pipe", "view": "v_edit_inp_dscenario_pipe", "add_view": "v_edit_inp_dscenario_pipe", "pk": ["dscenario_id", "arc_id"]}
   ], "add_dlg_title":"Pipe" 
  }
}'::json, linkedobject='tbl_inp_pipe', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_reservoir",
    "tablename": "v_edit_inp_dscenario_reservoir",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_reservoir", "view": "v_edit_inp_dscenario_reservoir", "add_view": "v_edit_inp_dscenario_reservoir", "pk": ["dscenario_id", "node_id"]}
   ], "add_dlg_title":"Reservoir" 
  }
}'::json, linkedobject='tbl_inp_reservoir', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_shortpipe",
    "tablename": "v_edit_inp_dscenario_shortpipe",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_shortpipe", "view": "v_edit_inp_dscenario_shortpipe", "add_view": "v_edit_inp_dscenario_shortpipe", "pk": ["dscenario_id", "node_id"]}
   ]
, "add_dlg_title":"Shortpipe"   }
}'::json, linkedobject='tbl_inp_shortpipe', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_tank",
    "tablename": "v_edit_inp_dscenario_tank",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_tank", "view": "v_edit_inp_dscenario_tank", "add_view": "v_edit_inp_dscenario_tank", "pk": ["dscenario_id", "node_id"]}
   ], "add_dlg_title":"Tank" 
  }
}'::json, linkedobject='tbl_inp_tank', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_valve",
    "tablename": "v_edit_inp_dscenario_valve",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_valve", "view": "v_edit_inp_dscenario_valve", "add_view": "v_edit_inp_dscenario_valve", "pk": ["dscenario_id", "node_id"]}
   ]
, "add_dlg_title":"Valve"   }
}'::json, linkedobject='tbl_inp_valve', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_virtualpump",
    "tablename": "v_edit_inp_dscenario_virtualpump",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_virtualpump", "view": "v_edit_inp_dscenario_virtualpump", "add_view": "v_edit_inp_dscenario_virtualpump", "pk": ["dscenario_id", "arc_id"]}
   ]
, "add_dlg_title":"Virtualpump" 
  }
}'::json, linkedobject='tbl_inp_virtualpump', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields
SET widgetfunction='{
  "functionName": "add_to_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_virtualvalve",
    "tablename": "v_edit_inp_dscenario_virtualvalve",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_virtualvalve", "view": "v_edit_inp_dscenario_virtualvalve", "add_view": "v_edit_inp_dscenario_virtualvalve", "pk": ["dscenario_id", "arc_id"]}
   ]
, "add_dlg_title":"Virtualvalve" 
  }
}'::json, linkedobject='tbl_inp_virtualvalve', hidden=false, web_layoutorder=NULL
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';

UPDATE config_form_fields
SET  ismandatory=false
WHERE formname='v_edit_inp_dscenario_pump' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_none';
UPDATE config_form_fields
SET  ismandatory=false
WHERE formname='v_edit_inp_dscenario_pump_additional' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_none';

UPDATE config_form_fields
SET  ismandatory=false
WHERE formname='v_edit_inp_dscenario_pipe' AND formtype='form_feature' AND columnname='roughness' AND tabname='tab_none';
UPDATE config_form_fields
SET ismandatory=false
WHERE formname='v_edit_inp_dscenario_pipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';

UPDATE config_form_fields
SET ismandatory=false
WHERE formname='v_edit_inp_dscenario_connec' AND formtype='form_feature' AND columnname='custom_roughness' AND tabname='tab_none';
UPDATE config_form_fields
SET ismandatory=false
WHERE formname='v_edit_inp_dscenario_connec' AND formtype='form_feature' AND columnname='custom_length' AND tabname='tab_none';
UPDATE config_form_fields
SET ismandatory=false
WHERE formname='v_edit_inp_dscenario_connec' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_none';

UPDATE config_function set layermanager = '{"visible": ["v_edit_minsector"]}' WHERE id = 2706;

-- add orderby to most tableviews
UPDATE config_form_list
	SET vdefault='{"orderBy":"1", "orderType": "ASC"}'::json
  WHERE listname IN ('tbl_element_x_arc', 'tbl_element_x_node', 'tbl_element_x_connec', 'tbl_relations', 'tbl_hydrometer', 'tbl_visit_x_arc', 
  'tbl_visit_x_node', 'tbl_visit_x_connec', 'tbl_doc_x_arc', 'tbl_doc_x_node', 'tbl_doc_x_connec', 'tbl_inp_virtualvalve', 'tbl_hydrometer_value', 
  'tbl_inp_connec', 'tbl_inp_inlet', 'tbl_inp_junction', 'tbl_inp_pipe', 'tbl_inp_pump', 'tbl_inp_reservoir', 'tbl_inp_shortpipe', 'tbl_inp_tank', 
  'tbl_inp_valve', 'tbl_inp_virtualpump');


