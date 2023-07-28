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

UPDATE config_function set style = '{"style": {"polygon": {"style": "categorized","field": "minsector_id",  "transparency": 0.5}}}',layermanager=null WHERE id = 2706;

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