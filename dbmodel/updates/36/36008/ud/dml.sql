/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--29/02/24
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_conduit', 'form_feature', 'tab_epa', 'edit_dscenario', 'lyt_epa_dsc_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"101", "size":"20x20"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "edit_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_conduit",
    "tablename": "v_edit_inp_dscenario_conduit",
    "pkey": [
      "dscenario_id",
      "arc_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_conduit", "view": "v_edit_inp_dscenario_conduit", "add_view": "v_edit_inp_dscenario_conduit", "pk": ["dscenario_id", "arc_id"]}
   ],
   "add_dlg_title":"Conduit"
  }
}'::json, 'tbl_inp_conduit', false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_outfall', 'form_feature', 'tab_epa', 'edit_dscenario', 'lyt_epa_dsc_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"101", "size":"20x20"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "edit_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_outfall",
    "tablename": "v_edit_inp_dscenario_outfall",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_outfall", "view": "v_edit_inp_dscenario_outfall", "add_view": "v_edit_inp_dscenario_outfall", "pk": ["dscenario_id", "node_id"]}
   ],
   "add_dlg_title":"Outfall"
  }
}'::json, 'tbl_inp_outfall', false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_junction', 'form_feature', 'tab_epa', 'edit_dscenario', 'lyt_epa_dsc_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"101", "size":"20x20"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "edit_dscenario",
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
   ],
   "add_dlg_title":"Junction"
  }
}'::json, 'tbl_inp_dscenario_junction', false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_storage', 'form_feature', 'tab_epa', 'edit_dscenario', 'lyt_epa_dsc_1', 3, NULL, 'button', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"101", "size":"20x20"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "edit_dscenario",
  "module": "info",
  "parameters": {
    "targetwidget": "tab_epa_tbl_inp_storage",
    "tablename": "v_edit_inp_dscenario_storage",
    "pkey": [
      "dscenario_id",
      "node_id"
    ],
    "tableviews": [
		{"tbl": "tab_epa_tbl_inp_storage", "view": "v_edit_inp_dscenario_storage", "add_view": "v_edit_inp_dscenario_storage", "pk": ["dscenario_id", "node_id"]}
   ],
   "add_dlg_title":"Storage"
  }
}'::json, 'tbl_inp_storage', false, NULL) ON CONFLICT DO NOTHING;

UPDATE config_form_fields SET layoutorder = 4 WHERE columnname = 'hspacer_epa_1';

-- 01/03/24

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"hemisphere", "dataType":"float8", "isUtils":"False"}}$$);

UPDATE config_form_tabs SET tabactions='[{"actionName": "actionEdit", "disabled": false}, 
{"actionName": "actionZoom", "disabled": false}, 
{"actionName": "actionCentered", "disabled": false}, 
{"actionName": "actionZoomOut", "disabled": false}, 
{"actionName": "actionCatalog", "disabled": false}, 
{"actionName": "actionWorkcat", "disabled": false}, 
{"actionName": "actionCopyPaste", "disabled": false}, 
{"actionName": "actionLink", "disabled": false},
{"actionName":"actionGetArcId", "disabled":false},
{"actionName":"actionInterpolate", "disabled":false},
{"actionName": "actionHelp", "disabled": false},
  {
    "actionName": "actionRotation",
    "disabled": false
  }]'::json WHERE formname='v_edit_node' AND tabname='tab_connections';

UPDATE config_form_tabs SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  }
]'::json WHERE formname='v_edit_node' AND tabname='tab_data';
UPDATE config_form_tabs SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  }
]'::json WHERE formname='v_edit_node' AND tabname='tab_elements';
UPDATE config_form_tabs SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  }
]'::json WHERE formname='v_edit_node' AND tabname='tab_event';
UPDATE config_form_tabs SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  }
]'::json WHERE formname='v_edit_node' AND tabname='tab_documents';
UPDATE config_form_tabs SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  },
  {
    "actionName": "actionInterpolate",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  }
]'::json WHERE formname='v_edit_node' AND tabname='tab_plan';
UPDATE config_form_tabs SET tabactions='[
  {
    "actionName": "actionEdit",
    "actionTooltip": "Edit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "actionTooltip": "Zoom In",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "actionTooltip": "Center",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "actionTooltip": "Zoom Out",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "actionTooltip": "Change Catalog",
    "disabled": false
  },
  {
    "actionName": "actionWorkcat",
    "actionTooltip": "Add Workcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "actionTooltip": "Copy Paste",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "actionTooltip": "Open Link",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "actionTooltip": "Help",
    "disabled": false
  },
  {
    "actionName": "actionMapZone",
    "actionTooltip": "Add Mapzone",
    "disabled": false
  },
  {
    "actionName": "actionSetToArc",
    "actionTooltip": "Set to_arc",
    "disabled": false
  },
  {
    "actionName": "actionGetParentId",
    "actionTooltip": "Set parent_id",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "actionTooltip": "Set arc_id",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "actionTooltip": "Rotation",
    "disabled": false
  },
  {
    "actionName": "actionRotation",
    "disabled": false
  }
]'::json WHERE formname='v_edit_node' AND tabname='tab_epa';
