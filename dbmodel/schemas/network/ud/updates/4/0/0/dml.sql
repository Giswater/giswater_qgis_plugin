/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

INSERT INTO dwfzone (dwfzone_id, code, name) VALUES(0, '0', 'Undefined') ON CONFLICT DO NOTHING;

-- 15/10/2024
INSERT INTO cat_arc (id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1, z2, width, area, estimated_depth, thickness, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef)
SELECT id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef
FROM _cat_arc;

INSERT INTO cat_node (id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", acoeff)
SELECT id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", acoeff
FROM _cat_node;

INSERT INTO cat_connec (id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand_id, model_id, svg, active, "label")
SELECT id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand_id, model_id, svg, active, "label"
FROM _cat_connec;

INSERT INTO cat_gully (id, gully_type, matcat_id, length, width, efficiency, descript, link, brand_id, model_id, svg, label, active)
SELECT id, gully_type, matcat_id, length, width,
CASE
  WHEN effective_area IS NOT NULL AND total_area > 0 THEN
    effective_area/total_area
  ELSE
    0.8
END AS efficiency, descript, link, brand_id, model_id, svg, label, active
FROM _cat_grate;

UPDATE sys_param_user SET dv_querytext='SELECT id AS id, id AS idval FROM cat_gully WHERE id IS NOT NULL AND active IS TRUE ' WHERE id='edit_gratecat_vdefault';

-- 30/10/2024
DELETE FROM sys_foreignkey WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_snow' AND target_table='inp_snowpack' AND target_field='snow_type ';


--04/11/2024
ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_snow' AND id='PLOWABLE';
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_snow' AND id='IMPERVIOUS';
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_snow' AND id='PERVIOUS';
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_snow' AND id='REMOVAL';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

DELETE FROM config_form_fields
	WHERE formname='upsert_catalog_gully' AND formtype='form_catalog' AND columnname='geom1' AND tabname='tab_none';
DELETE FROM config_form_fields
	WHERE formname='upsert_catalog_gully' AND formtype='form_catalog' AND columnname='shape' AND tabname='tab_none';


UPDATE config_form_fields set dv_querytext = replace(dv_querytext, 'cat_grate', 'cat_gully');
UPDATE config_form_fields set dv_querytext_filterc = replace(dv_querytext_filterc, 'cat_grate', 'cat_gully');

-- 05/11/2024

UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": true
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
    "actionName": "actionWorkcat",
    "disabled": false
  },
  {
    "actionName": "actionCopyPaste",
    "disabled": false
  },
  {
    "actionName": "actionCatalog",
    "disabled": false
  },
  {
    "actionName": "actionLink",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_data';
UPDATE config_form_tabs
	SET tabactions='[
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
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_epa';
UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": true
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
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": true
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
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET tabactions='[
  {
    "actionName": "actionEdit",
    "disabled": true
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
    "actionName": "actionHelp",
    "disabled": false
  },
  {
    "actionName": "actionGetArcId",
    "disabled": false
  }
]'::json
	WHERE formname='v_edit_gully' AND tabname='tab_event';
UPDATE config_form_tabs
	SET tabactions='[
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
]'::json
	WHERE formname='v_edit_node' AND tabname='tab_data';

-- 20/11/24
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_time_2', 'lyt_time_2', 'layoutTime2', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('epa_selector', 'tab_time', 'Date time', 'Date time', 'role_basic', NULL, NULL, 1, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_none', 'tab_main', 'lyt_epa_select_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"tabs":["tab_result", "tab_time"]}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'compare_date', 'lyt_time_2', 0, 'string', 'combo', 'Compare date', 'Compare date', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, '{"setMultiline":false, "nullQuery":true}'::json, '{
  "functionName": "set_combo_values",
  "parameters": {
    "cmbListToChange": [
      "compare_time"
    ]
  },
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_compare', 'lyt_result_1', 1, 'string', 'combo', 'Result name (to compare):', 'Result name (to compare)', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "set_combo_values",
  "parameters": {
    "cmbListToChange": [
      "compare_date",
      "compare_time"
    ]
  },
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'selector_time', 'lyt_time_1', 1, 'string', 'combo', 'Selector time', 'Selector time', NULL, false, false, true, false, false, NULL, NULL, true, NULL, NULL, NULL, '{"setMultiline":false, "nullQuery":true}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'compare_time', 'lyt_time_2', 1, 'string', 'combo', 'Compare time', 'Compare time', NULL, false, false, true, false, false, NULL, NULL, true, NULL, NULL, NULL, '{"setMultiline":false, "nullQuery":true}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'selector_date', 'lyt_time_1', 0, 'string', 'combo', 'Selector date', 'Selector date', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, '{"setMultiline":false, "nullQuery":true}'::json, '{
  "functionName": "set_combo_values",
  "parameters": {
    "cmbListToChange": [
      "selector_time"
    ]
  },
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_show', 'lyt_result_1', 0, 'string', 'combo', 'Result name (to show):', 'Result name', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "set_combo_values",
  "parameters": {
    "cmbListToChange": [
      "selector_date",
      "selector_time"
    ]
  },
  "module": "go2epa_selector_btn"
}'::json, NULL, false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('epa_selector_tab_time', '{"layouts":["lyt_time_1","lyt_time_2"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


-- 28/11/2024
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('epa_results', 'SELECT result_id as id, expl_id::text, sector_id::text, network_type, status, iscorporate::text, descript, cur_user, exec_date, rpt_stats::text, addparam, export_options, network_stats, inp_options FROM v_ui_rpt_cat_result', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name":"btn_edit",
      "widgetfunction": {
        "functionName": "edit",
        "params": {}
      },
      "color": "default",
      "text": "Edit",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name":"btn_show_inp_data",
      "widgetfunction": {
        "functionName": "showInpData",
        "params": {}
      },
      "color": "default",
      "text": "Show inp data",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    },
    {
      "name":"btn_toggle_archive",
      "widgetfunction": {
        "functionName": "toggleArchive",
        "params": {}
      },
      "color": "default",
      "text": "Toggle archive",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_delete",
      "widgetfunction": {
        "functionName": "delete",
        "params": {}
      },
      "color": "error",
      "text": "Delete",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

-- 04/12/2024
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_froutlet', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_frorifice', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_frpump', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_frweir', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dwf', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');


UPDATE config_form_list
	SET query_text='SELECT nodarc_id, to_arc, order_id, flwreg_length, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4 FROM inp_frorifice WHERE id IS NOT NULL'
	WHERE listname='inp_frorifice' AND device=4;
UPDATE config_form_list
	SET query_text='SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.ori_type, d.offsetval, d.cd, d.orate, d.flap, d.shape, d.geom1, d.geom2, d.geom3, d.geom4
FROM inp_dscenario_frorifice d
JOIN inp_frorifice f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL'
	WHERE listname='inp_dscenario_frorifice' AND device=4;


DELETE FROM config_form_tableview
	WHERE objectname='inp_dscenario_frorifice' AND columnname='close_time';
DELETE FROM config_form_tableview
	WHERE objectname='inp_frorifice' AND columnname='close_time';
UPDATE config_form_tableview
	SET columnindex=16
	WHERE objectname='inp_frorifice' AND columnname='nodarc_id';

-- cat_dwf_scenario rename to cat_dwf
UPDATE sys_table SET id = 'cat_dwf' WHERE id = 'cat_dwf_scenario';

UPDATE config_toolbox SET inputparams='[
  {"widgetname":"target", "label":"Target Scenario:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDwf"},
  {"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user UNION SELECT -999,''ALL VISIBLE SECTORS'' ORDER BY 1 DESC", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userSector"},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["INSERT-ONLY", "DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["INSERT ONLY", "DELETE & COPY", "KEEP & COPY", "DELETE ONLY"], "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"INSERT-ONLY"},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":4, "selectedId":""}
  ]'::json WHERE id=3102;

UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='id' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='idval' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='startdate' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='log' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='observ' AND tabname='tab_none';
UPDATE config_form_fields SET formname='v_edit_cat_dwf' WHERE formname='v_edit_cat_dwf_scenario' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';

UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='idval' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='id' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='startdate' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='enddate' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET formname='cat_dwf' WHERE formname='cat_dwf_scenario' AND formtype='form_feature' AND columnname='observ' AND tabname='tab_none';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM cat_dwf WHERE active IS true', widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "cat_dwf", "activated": true, "keyColumn": "id", "valueColumn": "idval", "filterExpression": ""}}'::json WHERE formname='inp_dwf' AND formtype='form_feature' AND columnname='dwfscenario_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM cat_dwf WHERE active IS true', widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "cat_dwf", "activated": true, "keyColumn": "id", "valueColumn": "idval", "filterExpression": ""}}'::json WHERE formname='inp_dwf_pol_x_node' AND formtype='form_feature' AND columnname='dwfscenario_id' AND tabname='tab_none';
UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM cat_dwf WHERE active IS true', widgetcontrols='{"setMultiline":false,"valueRelation":{"nullValue":false, "layer": "cat_dwf", "activated": true, "keyColumn": "id", "valueColumn": "idval", "filterExpression": ""}}'::json WHERE formname='v_edit_inp_dwf' AND formtype='form_feature' AND columnname='dwfscenario_id' AND tabname='tab_none';

UPDATE sys_param_user SET dv_querytext='SELECT id, idval FROM cat_dwf WHERE id IS not null' WHERE id='inp_options_dwfscenario';

UPDATE config_toolbox SET inputparams = replace(inputparams::text, 'cat_dwf_scenario', 'cat_dwf')::json;

--05/12/2024
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_frorifice', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_froutlet', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_frpump', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_frweir', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_inflows', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');

-- 10/12/2024
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_1', 'lyt_nvo_mng_1', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_2', 'lyt_nvo_mng_2', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_mng_3', 'lyt_nvo_mng_1', 'layoutNonVisualObjectsManager1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_curves_1', 'lyt_curves_1', 'layoutCurves1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_patterns_1', 'lyt_patterns_1', 'layoutPatterns1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_timeseries_1', 'lyt_timeseries_1', 'layoutTimeseries1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_controls_1', 'lyt_controls_1', 'layoutControls1', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_lids_1', 'lyt_lids_1', 'layoutLids1', NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_curves', 'tab_curves', 'tabCurves', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_patterns', 'tab_patterns', 'tabPatterns', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_timeseries', 'tab_timeseries', 'tabTimeseries', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_controls', 'tab_controls', 'tabControls', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_lids', 'tab_lids', 'tabLids', NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_manager', 'nvo_manager', 'nonVisualObjectsManager', NULL);
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_curves', 'Curves', 'Curves', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_patterns', 'Patterns', 'Patterns', 'role_basic', NULL, NULL, 1, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_timeseries', 'Timeseries', 'Timeseries', 'role_basic', NULL, NULL, 2, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_controls', 'Controls', 'Controls', 'role_basic', NULL, NULL, 3, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_manager', 'tab_lids', 'Lids', 'Lids', 'role_basic', NULL, NULL, 4, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_patterns', 'tab_patterns', 'lyt_patterns_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_patterns', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_controls', 'tab_controls', 'lyt_controls_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_controls', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_lids', 'tab_lids', 'lyt_lids_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_lids', false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_timeseries', 'tab_timeseries', 'lyt_timeseries_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_timeseries', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_none', 'tab_main', 'lyt_nvo_mng_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_curves",
    "tab_patterns",
    "tab_timeseries",
    "tab_controls",
    "tab_lids"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "closeDlg"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_manager', 'tab_curves', 'tab_curves', 'lyt_curves_1', 0, NULL, 'tablewidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'tbl_nvo_mng_curves', false, 0);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_curves', 'SELECT * FROM v_edit_inp_curve WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openCurves","params":{"initialHeight":480,"initialWidth":650,"minHeight":480,"minWidth":560,"title":"Curve"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openCurves","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_patterns', 'SELECT * FROM v_edit_inp_pattern WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"pattern_id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openPatterns","params":{"initialHeight":580,"initialWidth":720,"minHeight":579,"minWidth":719,"title":"Pattern"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openPatterns","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_controls', 'SELECT * FROM v_edit_inp_controls WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openControls","params":{"initialHeight":400,"initialWidth":300,"minHeight":390,"minWidth":290,"title":"Control"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openControls","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_timeseries', 'SELECT * FROM v_edit_inp_timeseries WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openTimeseries","params":{"initialHeight":480,"initialWidth":650,"minHeight":480,"minWidth":560,"title":"Timeseries"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openTimeseries","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_mng_lids', 'SELECT * FROM inp_lid WHERE lidco_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{"enableGlobalFilter":false,"enableStickyHeader":true,"positionToolbarAlertBanner":"bottom","enableGrouping":false,"enablePinning":true,"enableColumnOrdering":true,"enableColumnFilterModes":true,"enableFullScreenToggle":false,"enablePagination":true,"enableExporting":true,"muiTablePaginationProps":{"rowsPerPageOptions":[5,10,15,20,50,100],"showFirstButton":true,"showLastButton":true},"enableRowSelection":true,"multipleRowSelection":true,"initialState":{"showColumnFilters":false,"pagination":{"pageSize":5,"pageIndex":0},"density":"compact","columnFilters":[],"sorting":[{"id":"lidco_id","desc":true}]},"modifyTopToolBar":true,"renderTopToolbarCustomActions":[{"widgetfunction":{"functionName":"openLids","params":{"initialHeight":480,"initialWidth":650,"minHeight":480,"minWidth":560,"title":"LIDS"}},"color":"success","text":"Open","disableOnSelect":true,"moreThanOneDisable":true}],"enableRowActions":false,"renderRowActionMenuItems":[{"widgetfunction":{"functionName":"openLids","params":{}},"icon":"OpenInBrowser","text":"Open"}]}'::json);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_controls', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_controls', 'sector_id', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_controls', 'text', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_controls', 'active', 3, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'lidco_id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "lidco_id",
  "header": "lidco_id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'lidco_type', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'observ', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'log', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_lids', 'active', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'descript', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'expl_id', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'curve_type', 1, true, NULL, NULL, NULL, '{
  "accessorKey": "curve_type",
  "filterVariant": "select",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_curves', 'log', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'pattern_id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "pattern_id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'observ', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'tscode', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'tsparameters', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'expl_id', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_patterns', 'log', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'id', 0, true, NULL, NULL, NULL, '{
  "accessorKey": "id",
  "header": "Id",
  "filterVariant": "text",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'timser_type', 1, true, NULL, NULL, NULL, '{
  "accessorKey": "timser_type",
  "filterVariant": "select",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'times_type', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'idval', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'descript', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'fname', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'expl_id', 6, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('epa_toolbar', 'ud', 'tbl_nvo_mng_timeseries', 'active', 7, true, NULL, NULL, NULL, '{
  "accessorKey": "active",
  "header": "active",
  "filterVariant": "checkbox",
  "enableSorting": true,
  "enableColumnOrdering": true,
  "enableColumnFilter": true,
  "enableClickToCopy": false
}'::json);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_timeseries', '{"layouts":["lyt_timeseries_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_curves', '{"layouts":["lyt_curves_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_patterns', '{"layouts":["lyt_patterns_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_controls', '{"layouts":["lyt_controls_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_manager_tab_lids', '{"layouts":["lyt_lids_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_1', 'lyt_nvo_curves_1', 'layoutNonVisualObjectsCurves1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_2', 'lyt_nvo_curves_2', 'layoutNonVisualObjectsCurves2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_curves_3', 'lyt_nvo_curves_3', 'layoutNonVisualObjectsCurves3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_curves', 'nvo_curves', 'nonVisualObjectsCurves', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'tbl_curves', 'lyt_nvo_curves_3', 0, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "style": "regular"
}'::json, NULL, 'tbl_nvo_curves', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'img_plot', 'lyt_nvo_curves_3', 1, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'descript', 'lyt_nvo_curves_2', 0, NULL, 'text', 'Description', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'id', 'lyt_nvo_curves_1', 0, NULL, 'text', 'Curve ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'curve_type', 'lyt_nvo_curves_1', 1, NULL, 'combo', 'Curve Type', NULL, NULL, false, false, false, false, false, 'SELECT DISTINCT curve_type AS id, curve_type AS idval FROM v_edit_inp_curve', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_curves', 'tab_none', 'expl_id', 'lyt_nvo_curves_1', 2, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_curves', 'SELECT x_value, y_value FROM v_edit_inp_curve_value WHERE curve_id IS NOT NULL ', 5, 'tab', 'list', '{
  "orderBy": "id",
  "orderType": "ASC"
}'::json, NULL);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_1', 'lyt_nvo_patterns_1', 'layoutNonVisualObjectsPatterns1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_2', 'lyt_nvo_patterns_2', 'layoutNonVisualObjectsPatterns2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_patterns_3', 'lyt_nvo_patterns_3', 'layoutNonVisualObjectsPatterns3', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_patterns', 'nvo_patterns', 'nonVisualObjectsPatterns', NULL);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'pattern_id', 'lyt_nvo_patterns_1', 0, NULL, 'text', 'Pattern ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'observ', 'lyt_nvo_patterns_1', 1, NULL, 'text', 'Observation', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'expl_id', 'lyt_nvo_patterns_1', 2, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, '', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'img_plot', 'lyt_nvo_patterns_3', 0, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns_hourly', 'lyt_nvo_patterns_2', 0, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false, "style": "regular"}'::json, NULL, 'tbl_nvo_patterns_hourly', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns_daily', 'lyt_nvo_patterns_2', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false, "style": "regular"
}'::json, NULL, 'tbl_nvo_patterns_daily', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns_weekend', 'lyt_nvo_patterns_2', 2, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false, "style": "regular"
}'::json, NULL, 'tbl_nvo_patterns_weekend', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_patterns', 'tab_none', 'tbl_patterns_monthly', 'lyt_nvo_patterns_2', 3, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false, "style": "regular"
}'::json, NULL, 'tbl_nvo_patterns_monthly', false, 3);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns_hourly', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "pattern_id",
  "orderType": "ASC"
}'::json, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns_daily', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "pattern_id",
  "orderType": "ASC"
}'::json, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns_weekend', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "pattern_id",
  "orderType": "ASC"
}'::json, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_patterns_monthly', 'SELECT factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12 FROM v_edit_inp_pattern_value WHERE pattern_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "pattern_id",
  "orderType": "ASC"
}'::json, NULL);

-- 1- Insert layouts  and form in config_typevalue
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_timeseries_1', 'lyt_nvo_timeseries_1', 'layoutNonVisualObjectsTimeseries1', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_timeseries_2', 'lyt_nvo_timeseries_2', 'layoutNonVisualObjectsTimeseries2', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_timeseries_3', 'lyt_nvo_timeseries_3', 'layoutNonVisualObjectsTimeseries3', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_timeseries_4', 'lyt_nvo_timeseries_4', 'layoutNonVisualObjectsTimeseries4', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_timeseries', 'nvo_timeseries', 'nonVisualObjectstimeseries', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'id', 'lyt_nvo_timeseries_1', 0, NULL, 'text', 'Time Series ID', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'idval', 'lyt_nvo_timeseries_1', 1, NULL, 'text', 'idval', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'timser_type', 'lyt_nvo_timeseries_2', 0, NULL, 'combo', 'Time Series Type', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_timserid''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'times_type', 'lyt_nvo_timeseries_2', 1, NULL, 'combo', 'Times Type', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_timeseries''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'expl_id', 'lyt_nvo_timeseries_3', 0, NULL, 'combo', 'Exploitation ID', NULL, NULL, false, false, false, false, false, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id > 0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'fname', 'lyt_nvo_timeseries_3', 1, NULL, 'text', 'File name', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'descript', 'lyt_nvo_timeseries_4', 0, NULL, 'text', 'Description', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_timeseries', 'tab_none', 'tbl_timeseries', 'lyt_nvo_timeseries_4', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "style": "regular"
}'::json, NULL, 'tbl_nvo_timeseries', false, 1);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('tbl_nvo_timeseries', 'SELECT time, value FROM v_edit_inp_timeseries_value WHERE timser_id IS NOT NULL', 5, 'tab', 'list', '{
  "orderBy": "id",
  "orderType": "ASC"
}'::json, NULL);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_controls_1', 'lyt_nvo_controls_1', 'layoutNonVisualObjectsControls1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_controls', 'nvo_controls', 'nonVisualObjectsControls', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'sector_id', 'lyt_nvo_controls_1', 0, NULL, 'combo', 'Sector ID', NULL, NULL, false, false, false, false, false, 'SELECT sector_id as id, name as idval FROM v_edit_sector WHERE sector_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'active', 'lyt_nvo_controls_1', 1, NULL, 'check', 'Active', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_controls', 'tab_none', 'text', 'lyt_nvo_controls_1', 2, NULL, 'textarea', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 2);


INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'nvo_lids', 'nvo_lids', 'nonVisualObjectsLids', '{
  "lytOrientation": "horizontal"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_lids_1', 'lyt_nvo_lids_1', 'layoutNonVisualObjectsLids1', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_nvo_lids_2', 'lyt_nvo_lids_2', 'layoutNonVisualObjectsLids2', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_surface_1', 'lyt_surface_1', 'layoutLidSurface', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_soil_1', 'lyt_soil_1', 'layoutLidSoil', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_storage_1', 'lyt_storage_1', 'layoutLidStorage', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_drain_1', 'lyt_drain_1', 'layoutLidDrain', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_pavement_1', 'lyt_pavement_1', 'layoutLidPavement', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_roof_1', 'lyt_roof_1', 'layoutLidRoof', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_drainmat_1', 'lyt_drainmat_1', 'layoutLidDrainamat', '{
  "lytOrientation": "vertical"
}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_surface', 'tab_surface', 'tabSurface', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_soil', 'tab_soil', 'tabSoil', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_storage', 'tab_storage', 'tabStorage', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_drain', 'tab_drain', 'tabDrain', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_pavement', 'tab_pavement', 'tabPavement', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_roof', 'tab_roof', 'tabRoof', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_drainmat', 'tab_drainmat', 'tabDrainmat', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_surface', 'Surface', 'Surface', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_soil', 'Soil', 'Soil', 'role_basic', NULL, NULL, 1, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_drainmat', 'Drainage Mat', 'Drainage Mat', 'role_basic', NULL, NULL, 2, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_pavement', 'Pavement', 'Pavement', 'role_basic', NULL, NULL, 3, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_storage', 'Storage', 'Storage', 'role_basic', NULL, NULL, 4, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('nvo_lids', 'tab_drain', 'Drain', 'Drain', 'role_basic', NULL, NULL, 5, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_none', 'lidco_id', 'lyt_nvo_lids_1', 0, NULL, 'text', 'Control Name', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_none', 'lidco_type', 'lyt_nvo_lids_1', 1, NULL, 'combo', 'Control Name', NULL, NULL, false, false, false, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_lidtype''', NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_none', 'img_lids', 'lyt_nvo_lids_1', 2, NULL, 'label', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_none', 'lbl_lids', 'lyt_nvo_lids_1', 3, NULL, 'label', 'Source: SWMM 5.1', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('GR', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_soil",
    "tab_drainmat"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_2', 'lyt_soil_1', 0, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_3', 'lyt_soil_1', 1, NULL, 'text', 'Porosity    (volume fraction)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_4', 'lyt_soil_1', 2, NULL, 'text', 'Field Capacity (volume fraction)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_3', 'lyt_surface_1', 1, NULL, 'text', 'Vegetation Volume Fraction', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_4', 'lyt_surface_1', 2, NULL, 'text', 'Surface Roughness (Mannings n)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_5', 'lyt_surface_1', 3, NULL, 'text', 'Surface Slope (percent)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_6', 'lyt_surface_1', 4, NULL, 'text', 'Swale Side Slope (run / rise)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_surface', 'value_2', 'lyt_surface_1', 0, NULL, 'text', 'Berm Height (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_6', 'lyt_soil_1', 4, NULL, 'text', 'Conductivity    (in/hr or mm/hr)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_2', 'lyt_drain_1', 0, NULL, 'text', 'Flow Coefficient*', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_3', 'lyt_drain_1', 1, NULL, 'text', 'Flow Exponent', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_4', 'lyt_drain_1', 2, NULL, 'text', 'Offset (in or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_5', 'lyt_drain_1', 3, NULL, 'text', 'Drain Delay (hrs)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_6', 'lyt_drain_1', 4, NULL, 'text', 'Open Level (in or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drain', 'value_7', 'lyt_drain_1', 5, NULL, 'text', 'Closed Level (in or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_7', 'lyt_soil_1', 5, NULL, 'text', 'Conductivity Slope', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_8', 'lyt_soil_1', 6, NULL, 'text', 'Suction Head (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drainmat', 'value_2', 'lyt_drainmat_1', 0, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drainmat', 'value_3', 'lyt_drainmat_1', 1, NULL, 'text', 'Void Fraction', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_drainmat', 'value_4', 'lyt_drainmat_1', 2, NULL, 'text', 'Roughness (Mannings n)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_2', 'lyt_pavement_1', 0, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_3', 'lyt_pavement_1', 1, NULL, 'text', 'Void Ratio (Void / Solids)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_4', 'lyt_pavement_1', 2, NULL, 'text', 'Imprevious Surface Fraction', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_5', 'lyt_pavement_1', 3, NULL, 'text', 'Permeability    (in/hr or mm/hr)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_6', 'lyt_pavement_1', 4, NULL, 'text', 'Clogging Factor', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 4);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_7', 'lyt_pavement_1', 5, NULL, 'text', 'Regeneration Interval (days)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 5);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_pavement', 'value_8', 'lyt_pavement_1', 6, NULL, 'text', 'Regeneration Fraction', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 6);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_roof', 'value_2', 'lyt_roof_1', 0, NULL, 'text', 'Flow Capacity (in/hr or mm/hr)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_storage', 'value_2', 'lyt_storage_1', 0, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_storage', 'value_3', 'lyt_storage_1', 1, NULL, 'text', 'Void Ratio (Voids / Solids)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_storage', 'value_4', 'lyt_storage_1', 2, NULL, 'text', 'Seepage Rate (in/hr or mm/hr)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_storage', 'value_5', 'lyt_storage_1', 3, NULL, 'text', 'Thickness (in. or mm)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('VS', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'nvo_lids', 'tab_soil', 'value_5', 'lyt_soil_1', 3, NULL, 'text', 'Wilting Point (volume fraction)', NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('BC', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_soil",
    "tab_storage"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('PP', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_pavement",
    "tab_storage"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('IT', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_storage"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('RB', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_storage",
    "tab_drain"
  ]
}'::json, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('RG', 'nvo_lids', 'tab_none', 'tab_main', 'lyt_nvo_lids_2', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_surface",
    "tab_soil"
  ]
}'::json, NULL, NULL, false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_surface', '{"layouts":["lyt_surface_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_soil', '{"layouts":["lyt_soil_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_storage', '{"layouts":["lyt_storage_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_drainmat', '{"layouts":["lyt_drainmat_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_drain', '{"layouts":["lyt_drain_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_pavement', '{"layouts":["lyt_pavement_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('nvo_lids_tab_roof', '{"layouts":["lyt_roof_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'ud', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--12/12/2024
UPDATE sys_style SET stylevalue = replace(stylevalue,'tot_flood','tot_flood_compare') WHERE layername IN ('v_rpt_comp_nodeflooding_sum');
UPDATE sys_style SET stylevalue = replace(stylevalue,'mfull_depth','mfull_depth_compare') WHERE layername IN ('v_rpt_comp_arcflow_sum');

DELETE FROM sys_table WHERE id='cat_mat_grate';
DELETE FROM sys_table WHERE id='cat_mat_gully';

--13/12/2024
UPDATE sys_style SET stylevalue = replace(stylevalue,'vhmax','vhmax_compare') WHERE layername IN ('v_rpt_comp_subcatchrunoff_sum');

--16/12/2024

update sys_message
set error_message = 'Feature is out of sector, feature_id: %feature_id%'
where id = 1010;

update sys_message
set error_message = 'Feature is out of dma, feature_id: %feature_id%'
where id = 1014;

update sys_message
set error_message = 'One or more arcs has the same node as Node1 and Node2. Node_id: %node_id%'
where id = 1040;

update sys_message
set error_message = 'One or more arcs was not inserted/updated because it has not start/end node. Arc_id: %arc_id%'
where id = 1042;

update sys_message
set error_message = 'Exists one o more connecs closer than configured minimum distance, connec_id: %connec_id%'
where id = 1044;

update sys_message
set error_message = 'Exists one o more nodes closer than configured minimum distance, node_id: %node_id%'
where id = 1046;

update sys_message
set error_message = 'There is at least one arc attached to the deleted feature. (num. arc,feature_id) = %num_arc%, %feature_id%'
where id = 1056;

update sys_message
set error_message = 'There is at least one element attached to the deleted feature. (num. element,feature_id) = %num_element%, %feature_id%'
where id = 1058;

update sys_message
set error_message = 'There is at least one document attached to the deleted feature. (num. document,feature_id) = %num_document%, %feature_id%'
where id = 1060;

update sys_message
set error_message = 'There is at least one visit attached to the deleted feature. (num. visit,feature_id) = %num_visit%, %feature_id%'
where id = 1062;

update sys_message
set error_message = 'There is at least one link attached to the deleted feature. (num. link,feature_id) = %num_link%, %feature_id%'
where id = 1064;

update sys_message
set error_message = 'There is at least one connec attached to the deleted feature. (num. connec,feature_id) = %num_connec%, %feature_id%'
where id = 1066;

update sys_message
set error_message = 'There is at least one gully attached to the deleted feature. (num. gully,feature_id)= %num_gully%, %feature_id%'
where id = 1068;

update sys_message
set error_message = 'The feature can''t be replaced, because it''s state is different than 1. State = %state_id%'
where id = 1070;

update sys_message
set error_message = 'Before downgrading the node to state 0, disconnect the associated features, node_id: %node_id%'
where id = 1072;

update sys_message
set error_message = 'Before downgrading the arc to state 0, disconnect the associated features, arc_id: %arc_id%'
where id = 1074;

update sys_message
set error_message = 'Before downgrading the connec to state 0, disconnect the associated features, connec_id: %connec_id%'
where id = 1076;

update sys_message
set error_message = 'Before downgrading the gully to state 0, disconnect the associated features, gully_id: %gully_id%'
where id = 1078;

update sys_message
set error_message = 'Nonexistent arc_id: %arc_id%'
where id = 1082;

update sys_message
set error_message = 'Nonexistent node_id: %node_id%'
where id = 1084;

update sys_message
set error_message = 'Node with state 2 over another node with state=2 on same alternative it is not allowed. The node is: %node_id%'
where id = 1096;

update sys_message
set error_message = 'It is not allowed to insert/update one node with state(1) over another one with state (1) also. The node is: %node_id%'
where id = 1097;

update sys_message
set error_message = 'It is not allowed to insert/update one node with state (2) over another one with state (2). The node is: %node_id%'
where id = 1100;

update sys_message
set error_message = 'Feature is out of exploitation, feature_id: %feature_id%'
where id = 2012;

update sys_message
set error_message = '(arc_id, geom type) = %arc_id%, %geom_type%'
where id = 2022;

update sys_message
set error_message = 'The feature does not have state(1) value to be replaced, state = %state_id%'
where id = 2028;

update sys_message
set error_message = 'The feature not have state(2) value to be replaced, state = %state_id%'
where id = 2030;

update sys_message
set error_message = 'It is impossible to validate the arc without assigning value of arccat_id, arc_id: %arc_id%'
where id = 2036;

update sys_message
set error_message = 'The exit arc must be reversed. Arc = %arc_id%'
where id = 2038;

update sys_message
set error_message = 'Reduced geometry is not a Linestring, (arc_id,geom type)= %arc_id%, %geom_type%'
where id = 2040;

update sys_message
set error_message = 'Query text = %query_text%'
where id = 2078;

update sys_message
set error_message = 'The x value is too large. The total length of the line is %line_length%'
where id = 2080;

update sys_message
set error_message = 'The extension does not exists. Extension = %extension%'
where id = 2082;

update sys_message
set error_message = 'The module does not exists. Module = %module%'
where id = 2084;

update sys_message
set error_message = 'There are [units] values nulls or not defined on price_value_unit table  = %units%'
where id = 2088;

update sys_message
set error_message = 'There is at least one node attached to the deleted feature. (num. node,feature_id)= %num_node%, %feature_id%'
where id = 2108;

update sys_message
set error_message = 'The selected arc has state=0 (num. node,feature_id)= %element_id%'
where id = 3002;

update sys_message
set error_message = 'The minimum arc length of this exportation is: %min_arc_length%'
where id = 3010;

update sys_message
set error_message = 'Can''t modify typevalue: %typevalue%'
where id = 3028;

update sys_message
set error_message = 'Can''t delete typevalue: %typevalue%'
where id = 3030;

update sys_message
set error_message = 'Can''t apply the foreign key %typevalue_name%'
where id = 3032;

update sys_message
set error_message = 'Selected state type doesn''t correspond with state %state_id%'
where id = 3036;

update sys_message
set error_message = 'Inserted value has unaccepted characters: %characters%'
where id = 3038;

update sys_message
set error_message = 'Selected node type doesn''t divide arc. Node type: %node_type%'
where id = 3046;

update sys_message
set error_message = 'Connect2network tool is not enabled for connec''s with state=2. Connec_id: %connec_id%'
where id = 3052;

update sys_message
set error_message = 'Connect2network tool is not enabled for gullies with state=2. Gully_id: %gully_id%'
where id = 3054;

update sys_message
set error_message = 'It is impossible to validate the arc without assigning value of arccat_id. Arc_id: %arc_id%'
where id = 3056;

update sys_message
set error_message = 'It is impossible to validate the connec without assigning value of connecat_id. Connec_id: %connec_id%'
where id = 3058;

update sys_message
set error_message = 'It is impossible to validate the node without assigning value of nodecat_id. Node_id: %node_id%'
where id = 3060;

update sys_message
set error_message = 'Selected gratecat_id has NULL width or length. Gratecat_id: %gratecat_id%'
where id = 3062;

update sys_message
set error_message = 'It is not possible to create the link. On inventory mode only one link is enabled for each connec. Connec_id: %connec_id%'
where id = 3076;

update sys_message
set error_message = 'It is not possible to create the link. On inventory mode only one link is enabled for each gully. Gully_id: %gully_id%'
where id = 3078;

update sys_message
set error_message = 'It is not possible to relate connect with state=1 over network feature with state=2, connect: %connec_id%'
where id = 3080;

update sys_message
set error_message = 'Feature is out of any presszone, feature_id: %feature_id%'
where id = 3108;

update sys_message
set error_message = '%id% does not exists, impossible to delete it'
where id = 3116;

update sys_message
set error_message = 'Node is connected to arc which is involved in psector %psector_list%'
where id = 3140;

update sys_message
set error_message = 'Node is involved in psector %psector_list%'
where id = 3142;

update sys_message
set error_message = 'Exploitation of the feature is different than the one of the related arc. Arc_id: %arc_id%'
where id = 3144;

update sys_message
set error_message = 'Backup name already exists %backup_name%'
where id = 3148;

update sys_message
set error_message = 'Backup has no data related to table %table_name%'
where id = 3150;

update sys_message
set error_message = 'Null values on geom1 or geom2 fields on element catalog %elementcat_id%'
where id = 3152;

update sys_message
set error_message = 'Input parameter has null value %table_name%'
where id = 3156;

update sys_message
set error_message = 'This feature with state = 2 is only attached to one psector %psector_id%'
where id = 3160;

update sys_message
set error_message = 'Id value for this catalog already exists %value%'
where id = 3166;

update sys_message
set error_message = 'It is no possible to relate planned connec/gully over planned connec/gully wich not are on same psector. %debugmsg%'
where id = 3178;

update sys_message
set error_message = 'You are trying to modify some network element with related connects (connec / gully) on psector not selected. %psector_id%'
where id = 3180;

update sys_message
set error_message = 'It is not possible to downgrade connec because has operative hydrometer associated %feature_id%'
where id = 3194;

update sys_message
set error_message = 'Shortcut key is already defined for another feature %shortcut%'
where id = 3196;

update sys_message
set error_message = 'It''s not possible to break planned arcs by using operative nodes %arc_id%'
where id = 3202;

update sys_message
set error_message = 'The inserted value is not present in a catalog. %catalog%'
where id = 3022;

update sys_message
set error_message = 'Inserted feature_id does not exist on node/connec table %feature_id%'
where id = 3230;

update sys_message
set error_message = 'It''s not possible to connect to this arc because it exceed the maximum diameter configured: %diameter%'
where id = 3232;

update sys_message
set error_message = 'It''s not possible to configure this node as mapzone header, because it''s not an operative nor planified node %zone%'
where id = 3242;

update sys_message
set error_message = 'It''s not possible to use selected arcs. They are not connected to node parent %nodeparent%'
where id = 3244;

update sys_message
set error_message = 'There is no subcatchment or outlet_id nearby'
where id = 3252;

update sys_message
set error_message = 'No arc exists with a smaller diameter than the maximum configuered on edit_link_check_arcdnom: %edit_link_check_arcdnom%'
where id = 3260;

update sys_message
set error_message = 'Wrong configuration. Check config_form_fields on column widgetcontrol key ''reloadfields'' for columnname: %parentname%'
where id = 3264;

update sys_message
set error_message = left(error_message, length(error_message)-1)
where error_message ilike '%.';

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3360, 'Create Thyssen subcatchments', '{"featureType":[]}'::json, '[
{"widgetname":"clipLayer", "label":"Clip Layer:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,
"comboIds":["sector","expl", "muni"],
"comboNames":["SECTOR","EXPL", "MUNICIPALITY"]},
{"widgetname":"deletePrevious", "label":"Delete previous subcatchments:", "widgettype":"check", "datatype":"boolean", "layoutname":"grl_option_parameters","layoutorder":2, "value":"true"}
]'::json, NULL, true, '{4}');

-- 18/12/2024
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_results', 'SELECT dscenario_id as id, name, descript, dscenario_type, parent_id, expl_id, active::TEXT, log FROM v_edit_cat_dscenario WHERE dscenario_id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": true,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [
    {
      "name": "btn_toggle_active",
      "widgetfunction": {
        "functionName": "toggle_active",
        "params": {}
      },
      "color": "default",
      "text": "Toggle active",
      "disableOnSelect": true,
      "moreThanOneDisable": true
    },
    {
      "name": "btn_delete",
      "widgetfunction": {
        "functionName": "delete",
        "params": {}
      },
      "color": "error",
      "text": "Delete",
      "disableOnSelect": true,
      "moreThanOneDisable": false
    }
  ],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_pump_1', 'lyt_pump_1', 'lytPump1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_junction_1', 'lyt_junction_1', 'lytJunction1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_conduit_1', 'lyt_conduit_1', 'lytConduit1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_raingage_1', 'lyt_raingage_1', 'lytRaingage1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_weir_1', 'lyt_weir_1', 'lytWeir1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_outfall_1', 'lyt_outfall_1', 'lytOutfall1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_inflows_1', 'lyt_inflows_1', 'lytInflows1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_treatment_1', 'lyt_treatment_1', 'lytTreatment1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_poll_1', 'lyt_poll_1', 'lytPoll1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_orifice_1', 'lyt_orifice_1', 'lytOrifice1', '{"lytOrientation": "vertical"}'::json);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_outlet_1', 'lyt_outlet_1', 'lytOutlet1', '{"lytOrientation": "vertical"}'::json);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_outlet', 'tab_outlet', 'tabOutlet', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_conduit', 'tab_conduit', 'tabConduit', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_raingage', 'tab_raingage', 'tabRaingage', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_junction', 'tab_junction', 'tabJunction', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_weir', 'tab_weir', 'tabWeir', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_outfall', 'tab_outfall', 'tabOutfall', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_inflows', 'tab_inflows', 'tabInflows', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_treatment', 'tab_treatment', 'tabTreatment', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_poll', 'tab_poll', 'tabPoll', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_pump', 'tab_pump', 'tabPump', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_orifice', 'tab_orifice', 'tabOrifice', NULL);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_conduit', 'Conduit', 'Conduit', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_controls', 'Controls', 'Controls', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_inflows', 'Inflows', 'Inflows', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_junction', 'Junction', 'Junction', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_lids', 'Lids', 'Lids', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_orifice', 'Orifice', 'Orifice', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_outfall', 'Outfall', 'Outfall', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_outlet', 'Outlet', 'Outlet', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_poll', 'Poll', 'Poll', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_pump', 'Pump', 'Pump', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_raingage', 'Raingage', 'Raingage', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_storage', 'Storage', 'Storage', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_treatment', 'Treatment', 'Treatment', 'role_basic', NULL, NULL, 0, '{5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('dscenario', 'tab_weir', 'Weir', 'Weir', 'role_basic', NULL, NULL, 0, '{5}');

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_controls', '{"layouts":["lyt_controls_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_conduit', '{"layouts":["lyt_conduit_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_raingage', '{"layouts":["lyt_raingage_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_junction', '{"layouts":["lyt_junction_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_weir', '{"layouts":["lyt_weir_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_outfall', '{"layouts":["lyt_outfall_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_storage', '{"layouts":["lyt_storage_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_inflows', '{"layouts":["lyt_inflows_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_treatment', '{"layouts":["lyt_treatment_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_poll', '{"layouts":["lyt_poll_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_pump', '{"layouts":["lyt_pump_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_orifice', '{"layouts":["lyt_orifice_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_lids', '{"layouts":["lyt_lids_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('dscenario_tab_outlet', '{"layouts":["lyt_outlet_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_controls', 'tbl_controls', 'lyt_controls_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_controls', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_conduit', 'tbl_conduit', 'lyt_conduit_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_conduit', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_raingage', 'tbl_raingage', 'lyt_raingage_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_raingage', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_weir', 'tbl_weir', 'lyt_weir_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_weir', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_outfall', 'tbl_outfall', 'lyt_outfall_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_outfall', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_storage', 'tbl_storage', 'lyt_storage_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_storage', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_inflows', 'tbl_inflows', 'lyt_inflows_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_inflows', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_treatment', 'tbl_treatment', 'lyt_treatment_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_treatment', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_orifice', 'tbl_orifice', 'lyt_orifice_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_orifice', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_lids', 'tbl_lids', 'lyt_lids_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_lids', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_outlet', 'tbl_outlet', 'lyt_outlet_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_outlet', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_poll', 'tbl_poll', 'lyt_poll_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_poll', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_pump', 'tbl_pump', 'lyt_pump_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_pump', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_junction', 'tbl_junction', 'lyt_junction_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, 'dscenario_junction', false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'dscenario', 'tab_none', 'tab_main', 'lyt_dscenario_1', 1, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_pump",
    "tab_junction",
    "tab_conduit",
    "tab_raingage",
    "tab_weir",
    "tab_outfall",
    "tab_storage",
    "tab_inflows",
    "tab_treatment",
    "tab_poll",
    "tab_orifice",
    "tab_lids",
    "tab_outlet",
    "tab_controls"
  ]
}'::json, NULL, NULL, false, 1);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_controls', 'SELECT dscenario_id AS id, sector_id, "text", active FROM inp_dscenario_controls where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "sector_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "sector_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_conduit', 'SELECT dscenario_id AS id, arc_id, arccat_id, matcat_id, custom_n, barrels, culvert, kentry, kexit, kavg, flap, q0, qmax, seepage, elev1, elev2 FROM inp_dscenario_conduit where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "arc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "arc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_raingage', 'SELECT dscenario_id AS id, rg_id, form_type, intvl, scf, rgage_type, timser_id, fname,sta, units FROM inp_dscenario_raingage where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "rg_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "rg_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_junction', 'SELECT dscenario_id AS id, node_id, y0, ysur, apond, outfallparam, elev, ymax FROM inp_dscenario_junction where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_outfall', 'SELECT dscenario_id AS id, node_id, elev, ymax, outfall_type, stage, curve_id, timser_id, gate, route_to FROM inp_dscenario_outfall  where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_storage', 'SELECT dscenario_id AS id, node_id, elev, ymax, storage_type, curve_id, a1, a2, a0, fevap, sh, hc, imd, y0, ysur FROM inp_dscenario_storage where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_inflows', 'SELECT dscenario_id AS id, node_id, order_id, timser_id, sfactor, base, pattern_id FROM inp_dscenario_inflows where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_treatment', 'SELECT dscenario_id AS id, node_id, poll_id, "function" FROM inp_dscenario_treatment where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_orifice', 'SELECT dscenario_id AS id, nodarc_id, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4 FROM inp_dscenario_frorifice where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "nodarc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "nodarc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_lids', 'SELECT dscenario_id AS id, subc_id, lidco_id, numelem, area, width, initsat, fromimp, toperv, rptfile, descript FROM inp_dscenario_lids  where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "subc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "subc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_outlet', 'SELECT dscenario_id AS id, nodarc_id, outlet_type, offsetval, curve_id, cd1, flap, cd2 FROM inp_dscenario_froutlet where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "nodarc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "nodarc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_pump', 'SELECT dscenario_id AS id, nodarc_id, curve_id, status, shutoff, startup FROM inp_dscenario_frpump where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "nodarc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "nodarc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_weir', 'SELECT dscenario_id AS id, nodarc_id, weir_type, offsetval, cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, coef_curve, road_surf FROM inp_dscenario_frweir where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "nodarc_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "nodarc_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('dscenario_poll', 'SELECT dscenario_id AS id, node_id, poll_id, timser_id, form_type, mfactor, sfactor, base, pattern_id FROM inp_dscenario_inflows_poll  where dscenario_id is not NULL', 5, 'tab', 'list', '{
  "orderBy": "1",
  "orderType": "ASC"
}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": false,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": false,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": false,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "node_id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "node_id",
        "desc": false
      }
    ]
  },
  "renderTopToolbarCustomActions": [],
  "modifyTopToolBar": true,
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_controls', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_conduit', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_raingage', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_junction', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_weir', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_outfall', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_storage', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_inflows', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_treatment', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_poll', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_pump', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_orifice', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_lids', 'id', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('dscenariom_form', 'utils', 'dscenario_outlet', 'id', NULL, false, NULL, NULL, NULL, NULL);

--20/12/2024
UPDATE config_form_fields
SET iseditable = false
WHERE formtype = 'form_feature'
  AND columnname = 'to_arc'
  AND tabname = 'tab_none'
  AND formname IN (
    'v_edit_inp_frorifice',
    'v_edit_inp_froutlet',
    'v_edit_inp_frpump',
    'v_edit_inp_frweir'
  );

DROP FUNCTION IF EXISTS gw_fct_import_swmm_inp(p_data json);

DELETE FROM config_toolbox
	WHERE id=2524; --gw_fct_import_swmm_inp

DELETE FROM sys_function
	WHERE id=2524; --gw_fct_import_swmm_inp

update config_form_fields set dv_querytext_filterc = null
where formname in ('v_edit_inp_frpump','v_edit_inp_frorifice','v_edit_inp_frweir','v_edit_inp_froutlet');

--10/01/2025
--edited 28/01/2025

-- Insert on config_form_fields for parent view
-- copying columns from some random child (all childs has same columns that parent)
INSERT INTO config_form_fields
SELECT 'v_edit_flwreg', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfrpump' AND columnname IN ('nodarc_id','order_id','to_arc','flwreg_length');

-- Insert on config_form_fields for child views
INSERT INTO config_form_fields
SELECT 've_flwreg_frorifice', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfrorifice' AND columnname != 'close_time';

INSERT INTO config_form_fields
SELECT 've_flwreg_frweir', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfrweir';

INSERT INTO config_form_fields
SELECT 've_flwreg_froutlet', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfroutlet';

INSERT INTO config_form_fields
SELECT 've_flwreg_frpump', formtype, tabname, columnname, layoutname, layoutorder , "datatype", widgettype, label, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols , widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'v_edit_inp_frfrpump';

--Adding flwregtype on forms for flowregulators
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_flwreg_frorifice', 'form_feature', 'tab_none', 'flwreg_type', NULL, 16, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname,layoutorder,   "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_flwreg_frweir', 'form_feature', 'tab_none', 'flwreg_type', NULL,20, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname,layoutorder,   "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_flwreg_froutlet', 'form_feature', 'tab_none', 'flwreg_type', NULL,12, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname,layoutorder,   "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_flwreg_frpump', 'form_feature', 'tab_none', 'flwreg_type', NULL,10, 'string', 'text', 'flwreg_type', 'flwreg_type', NULL, false, false, false, false, NULL,
NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

--Default parameters uneditable for flow regulators

UPDATE config_form_fields  set iseditable = FALSE where columnname IN ('nodarc_id', 'node_id', 'order_id', 'to_arc' )
AND formname IN ('ve_flwreg_frorifice','v_edit_flwreg_frweir', 'v_edit_flwreg_froutlet' ,'v_edit_flwreg_frpump');

--Trigger function for editing flowregulators.
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3372, 'gw_trg_edit_flwreg', 'ud', 'function', 'json', 'json', 'Trigger to insert the flowregulators.', 'role_epa', NULL, 'core');

--Add flowregulators in inventory
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES('sys_table_context', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}',
NULL, NULL, '{"orderBy":9}'::json);

--Adding flowregulators ibnto network group
INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
VALUES('v_edit_flwreg', 'View to edit flowregulators.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 1, 'Flow regulator (parent)', NULL, NULL, NULL, 'core', '{
  "pkey": "nodarc_id"
}'::json);
-- INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
-- VALUES('ve_flwreg_frweir', 'View to edit flowregulators for weir.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 5, 'Weir', NULL, NULL, NULL, 'core', '{
--   "pkey": "nodarc_id"
-- }'::json);
-- INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
-- VALUES('v_edit_flwreg_froutlet', 'View to edit flowregulators for outlet.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 3, 'Outlet', NULL, NULL, NULL, 'core', '{
--   "pkey": "nodarc_id"
-- }'::json);
-- INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
-- VALUES('ve_flwreg_frpump', 'View to edit flowregulators for pumps.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 4, 'Pump', NULL, NULL, NULL, 'core', '{
--   "pkey": "nodarc_id"
-- }'::json);
-- INSERT INTO sys_table (id, descript, sys_role, criticity, context, orderby, alias, notify_action, isaudit, keepauditdays, "source", addparam)
-- VALUES('ve_flwreg_frorifice', 'View to edit flowregulators for orifice.', 'role_epa', NULL, '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"FLOW REGULATORS"}', 2, 'Orifice', NULL, NULL, NULL, 'core', '{
--   "pkey": "nodarc_id"
-- }'::json);

--Edit button for flwreg
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_flwreg', 'tab_none', NULL, NULL, 'role_epa', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  }
]'::json, 0, '{4,5}');

INSERT INTO temp_node (id, result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, omzone_id, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node, age)
SELECT id, result_id, node_id::integer, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, NULL, y0, ysur, apond, the_geom, expl_id, addparam, parent, arcposition, fusioned_node, age
FROM _temp_node;

INSERT INTO temp_arc (id, result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, omzone_id, length, n, the_geom, expl_id,
addparam, arcparent, q0, qmax, barrels, slope, flag, culvert, kentry, kexit, kavg, flap, seepage, age)
SELECT id, result_id, arc_id::integer, node_1::integer, node_2::integer, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, NULL, length, n, the_geom, expl_id,
addparam, arcparent, q0, qmax, barrels, slope, flag, culvert, kentry, kexit, kavg, flap, seepage, age
FROM _temp_arc;

INSERT INTO temp_gully (gully_id, gully_type, gullycat_id, arc_id, node_id, sector_id, state, state_type, top_elev, units, units_placement, outlet_type, width, length, "depth", "method", weir_cd, orifice_cd, a_param, b_param, efficiency, the_geom)
SELECT gully_id::integer, gully_type, gratecat_id, arc_id::integer, node_id::integer, sector_id, state, state_type, top_elev, units, units_placement, outlet_type, width, length, "depth", "method", weir_cd, orifice_cd, a_param, b_param, efficiency, the_geom
FROM _temp_gully;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_link', 'form_feature', 'tab_none', 'verified', 'lyt_data_1', 29, 'integer', 'combo', 'Verified', 'Verified', NULL, false, false, true, false, NULL, 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_verified''', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top"}'::json, NULL, NULL, true, NULL);

UPDATE config_form_fields SET datatype = 'integer', widgettype = 'combo', label = 'Verified', tooltip = 'verified', iseditable = true,
dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_verified''',
dv_orderby_id = true, dv_isnullvalue = true, widgetcontrols = '{"setMultiline": false, "labelPosition": "top"}'::json WHERE columnname = 'verified';

-- 30/01/2025
INSERT INTO man_manhole (node_id, length, width, sander_depth, prot_surface, inlet, bottom_channel, accessibility, bottom_mat)
SELECT node_id::integer, length, width, sander_depth, prot_surface, inlet, bottom_channel, accessibility, bottom_mat
FROM _man_manhole;

INSERT INTO review_node (node_id, top_elev, ymax, node_type, matcat_id, nodecat_id, annotation, observ, review_obs, expl_id, the_geom,
field_checked, is_validated, field_date)
SELECT node_id::integer, top_elev, ymax, node_type, matcat_id, nodecat_id, annotation, observ, review_obs, expl_id, the_geom,
field_checked, is_validated, field_date
FROM _review_node;

INSERT INTO review_audit_node (id, node_id, old_top_elev, new_top_elev, old_ymax, new_ymax, old_node_type, new_node_type, old_matcat_id, new_matcat_id, old_nodecat_id, new_nodecat_id,
old_annotation, new_annotation, old_observ, new_observ, review_obs, expl_id, the_geom, review_status_id, field_date, field_user, is_validated)
SELECT id, node_id::integer, old_top_elev, new_top_elev, old_ymax, new_ymax, old_node_type, new_node_type, old_matcat_id, new_matcat_id, old_nodecat_id, new_nodecat_id,
old_annotation, new_annotation, old_observ, new_observ, review_obs, expl_id, the_geom, review_status_id, field_date, field_user, is_validated
FROM _review_audit_node;

UPDATE config_form_fields SET dv_querytext='SELECT node_id as id, node_id as idval FROM ve_frelem WHERE flwreg_type = ''FRORIFICE'' AND node_id IS NOT NULL'
WHERE formname='v_edit_inp_dscenario_frorifice' AND columnname='nodarc_id';

UPDATE config_form_fields SET dv_querytext='SELECT node_id as id, node_id as idval FROM ve_frelem WHERE flwreg_type = ''FROUTLET'' AND node_id IS NOT NULL'
WHERE formname='v_edit_inp_dscenario_froutlet' AND columnname='nodarc_id';

UPDATE config_form_fields SET dv_querytext='SELECT node_id as id, node_id as idval FROM ve_frelem WHERE flwreg_type = ''FRPUMP'' AND node_id IS NOT NULL'
WHERE formname='v_edit_inp_dscenario_frpump' AND columnname='nodarc_id';

UPDATE config_form_fields SET dv_querytext='SELECT node_id as id, node_id as idval FROM ve_frelem WHERE flwreg_type = ''FRWEIR'' AND node_id IS NOT NULL'
WHERE formname='v_edit_inp_dscenario_frweir' AND columnname='nodarc_id';
-- 30/01/2025

-- Insert supplyzone types
INSERT INTO edit_typevalue VALUES('dwfzone_type', 'UNDEFINED', 'UNDEFINED', NULL, NULL);

-- Insert widgets drainzone
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=1, "datatype"='integer', widgettype='text', "label"='drainzone_id', tooltip='drainzone_id', placeholder=NULL, ismandatory=true, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='drainzone_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=2, "datatype"='string', widgettype='text', "label"='name', tooltip='name', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='name' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=3, "datatype"='string', widgettype='combo', "label"='drainzone_type', tooltip='drainzone_type', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue=''drainzone_type''', dv_orderby_id=true, dv_isnullvalue=true, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='drainzone_type' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=4, "datatype"='string', widgettype='text', "label"='descript', tooltip='descript', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=5, "datatype"='boolean', widgettype='check', "label"='active', tooltip='active', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='active' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=6, "datatype"='integer', widgettype='combo', "label"='lock_level', tooltip='lock_level', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext='SELECT id, idval from edit_typevalue WHERE typevalue=''value_lock_level''', dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='undelete' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=7, "datatype"='string', widgettype='text', "label"='graphconfig', tooltip='graphconfig', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=8, "datatype"='string', widgettype='text', "label"='stylesheet', tooltip='stylesheet', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='stylesheet' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=9, "datatype"='string', widgettype='text', "label"='link', tooltip='link', placeholder=NULL, ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='link' AND tabname='tab_none';
UPDATE config_form_fields SET layoutname='lyt_data_1', layoutorder=10, "datatype"='text', widgettype='text', "label"='expl_id', tooltip='expl_id', placeholder='Ex: 1,2', ismandatory=false, isparent=false, iseditable=true, isautoupdate=false, isfilter=false, dv_querytext=NULL, dv_orderby_id=NULL, dv_isnullvalue=NULL, dv_parent_id=NULL, dv_querytext_filterc=NULL, stylesheet=NULL, widgetcontrols='{"setMultiline":false}'::json, widgetfunction=NULL, linkedobject=NULL, hidden=false, web_layoutorder=NULL WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';

-- Insert widgets macrosector
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'macrosector_id', 'lyt_data_1', 1, 'integer', 'text', 'macrosector_id', 'macrosector_id', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'text', 'text', 'name', 'name', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 3, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 4, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_macrosector', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 5, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, false, 'SELECT id, idval from edit_typevalue WHERE typevalue=''value_lock_level''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);


-- Insert widgets sector
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'sector_id', 'lyt_data_1', 1, 'integer', 'text', 'sector_id', 'sector_id', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'sector_type', 'lyt_data_1', 3, 'string', 'combo', 'sector_type', 'sector_type', NULL, false, false, true, false, false, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''sector_type''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'macrosector', 'lyt_data_1', 4, 'string', 'combo', 'macrosector_id', 'macrosector_id', NULL, false, false, true, false, false, 'SELECT name as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 5, 'text', 'text', 'descript', 'descript', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 6, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 7, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, false, 'SELECT id, idval from edit_typevalue WHERE typevalue=''value_lock_level''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'graphconfig', 'lyt_data_1', 8, 'string', 'text', 'graphconfig', 'graphconfig', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 9, 'string', 'text', 'stylesheet', 'stylesheet', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'parent_id', 'lyt_data_1', 10, 'string', 'combo', 'parent_id', 'parent_id', NULL, false, false, true, false, false, 'SELECT sector_id as id,name as idval FROM v_ui_sector WHERE sector_id > -1 AND active IS TRUE', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_sector', 'form_feature', 'tab_none', 'link', 'lyt_data_1', 11, 'string', 'text', 'link', 'link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- Insert widgets dwfzone
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'dwfzone_id', 'lyt_data_1', 1, 'integer', 'text', 'dwfzone_id', 'dwfzone_id', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'name', 'lyt_data_1', 2, 'string', 'text', 'name', 'name', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'dwfzone_type', 'lyt_data_1', 3, 'string', 'combo', 'dwfzone_type', 'dwfzone_type', NULL, false, false, true, false, false, 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dwfzone_type''', true, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'descript', 'lyt_data_1', 4, 'string', 'text', 'descript', 'descript', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'active', 'lyt_data_1', 5, 'boolean', 'check', 'active', 'active', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'lock_level', 'lyt_data_1', 6, 'integer', 'combo', 'lock_level', 'lock_level', NULL, false, false, true, false, false, 'SELECT id, idval from edit_typevalue WHERE typevalue=''value_lock_level''', NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'graphconfig', 'lyt_data_1', 7, 'string', 'text', 'graphconfig', 'graphconfig', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'stylesheet', 'lyt_data_1', 8, 'string', 'text', 'stylesheet', 'stylesheet', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'link', 'lyt_data_1', 9, 'string', 'text', 'link', 'link', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields VALUES('v_ui_dwfzone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1', 10, 'text', 'text', 'expl_id', 'expl_id', 'Ex: 1,2', false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, NULL);

-- 06/02/2025
-- sys_foreignkey
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'node', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'arc', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'connec', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'element', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_datasource', 'gully', 'datasource', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

-- 10/02/2025
INSERT INTO arc_add (arc_id, result_id, max_flow, max_veloc, mfull_flow, mfull_depth)
SELECT arc_id::integer, result_id, max_flow, max_veloc, mfull_flow, mfull_depth
FROM rpt_arcflow_sum;

INSERT INTO node_add (node_id, result_id, max_depth, max_height, flooding_rate, flooding_vol)
SELECT d.node_id::integer, result_id, max_depth, max_height, f.max_rate, f.tot_flood
FROM rpt_nodedepth_sum d
JOIN rpt_nodesurcharge_sum c USING (result_id)
JOIN rpt_nodeflooding_sum f USING (result_id);

UPDATE config_form_fields SET columnname = 'mfull_depth', label = 'mfull_depth', tooltip = 'mfull_depth' WHERE columnname = 'mfull_dept';

-- 11/02/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_log_1', 'lyt_log_1', 'lytLog1', NULL) ON CONFLICT DO NOTHING;

DELETE FROM config_form_fields WHERE formname = 've_epa_valve' AND columnname = 'to_arc';

-- 17/02/2025
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'node', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'arc', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'connec', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'element', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'value_lock_level', 'gully', 'lock_level', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;

UPDATE config_form_fields SET "datatype"='integer', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_lock_level''', dv_orderby_id=true, dv_isnullvalue=true, dv_querytext_filterc=NULL
WHERE (formname='v_edit_arc' OR formname ILIKE 've_arc_%' OR formname='v_edit_connec' OR formname ILIKE 've_connec_%' OR formname='v_edit_node' OR formname ILIKE 've_node_%' OR formname='v_edit_element' OR formname ILIKE 've_element_%' OR formname='v_edit_gully' OR formname ILIKE 've_gully_%')
AND formtype='form_feature' AND columnname='lock_level' AND tabname='tab_data';

-- 25/02/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('tabname_typevalue', 'tab_relations_gully', 'tab_relations_gully', 'tabRelationsGully', NULL);
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('layout_name_typevalue', 'lyt_relations_gully_1', 'lyt_relations_gully_1', 'layoutRelationsGully1', '{
  "lytOrientation": "horizontal"
}'::json);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('psector', 'tab_relations_gully', 'Gully', 'Gully', 'role_basic', NULL, NULL, 0, '{5}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations_gully', 'table_view_gully', 'lyt_relations_gully_1', 0, NULL, 'tablewidget', '', 'Table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": false,
  "filter": false
}'::json, NULL, 'relations_gully_results', false, 0);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_relations', 'tab_relations_arc', 'lyt_relations_1', 0, NULL, 'tabwidget', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "tabs": [
    "tab_relations_arc",
    "tab_relations_node",
    "tab_relations_connec",
    "tab_relations_gully"
  ]
}'::json, NULL, NULL, false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('psector_tab_relations_gully', '{"layouts":["lyt_relations_gully_1"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('relations_gully_results', 'SELECT id, gully_id, arc_id, state, doable::TEXT FROM plan_psector_x_gully WHERE id IS NOT NULL', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, '{
  "enableGlobalFilter": false,
  "enableStickyHeader": true,
  "positionToolbarAlertBanner": "bottom",
  "enableGrouping": false,
  "enablePinning": true,
  "enableColumnOrdering": true,
  "enableColumnFilterModes": true,
  "enableFullScreenToggle": false,
  "enablePagination": true,
  "enableExporting": true,
  "muiTablePaginationProps": {
    "rowsPerPageOptions": [
      5,
      10,
      15,
      20,
      50,
      100
    ],
    "showFirstButton": true,
    "showLastButton": true
  },
  "enableRowSelection": false,
  "multipleRowSelection": true,
  "initialState": {
    "showColumnFilters": false,
    "pagination": {
      "pageSize": 5,
      "pageIndex": 0
    },
    "density": "compact",
    "columnFilters": [
      {
        "id": "id",
        "value": "",
        "filterVariant": "text"
      }
    ],
    "sorting": [
      {
        "id": "id",
        "desc": false
      }
    ]
  },
  "modifyTopToolBar": true,
  "renderTopToolbarCustomActions": [],
  "enableRowActions": false,
  "renderRowActionMenuItems": [
    {
      "widgetfunction": {
        "functionName": "open",
        "params": {}
      },
      "icon": "OpenInBrowser",
      "text": "Open"
    }
  ]
}'::json);

-- 27/02/2025
-- man_wwtp
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_wwtp_wwtptype', '0', 'UNDEFINED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_wwtp_wwtptype', 'man_wwtp', 'wwtp_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_wwtp_wwtptype''', dv_isnullvalue=False
WHERE formname ILIKE 've_node%_wwtp' AND formtype='form_feature' AND columnname='wwtp_type' AND tabname='tab_data';


INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('man_wwtp_treatmenttype', '0', 'UNDEFINED', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'man_wwtp_treatmenttype', 'man_wwtp', 'treatment_type', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields
SET widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''man_wwtp_treatmenttype''', dv_isnullvalue=False
WHERE formname ILIKE 've_node%_wwtp' AND formtype='form_feature' AND columnname='treatment_type' AND tabname='tab_data';

-- node
UPDATE config_form_fields SET widgettype='typeahead', dv_querytext='SELECT id, id AS idval FROM cat_pavement WHERE id IS NOT NULL', dv_isnullvalue=True WHERE formname='v_edit_node' AND formtype='form_feature' AND columnname='pavcat_id' AND tabname='tab_data';
UPDATE config_form_fields SET widgettype='typeahead', dv_querytext='SELECT id, id AS idval FROM cat_pavement WHERE id IS NOT NULL', dv_isnullvalue=True WHERE formname ILIKE 've_node_%' AND formtype='form_feature' AND columnname='pavcat_id' AND tabname='tab_data';

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_edit_arc', 'form_feature', 'tab_data', 'cat_dr', 'lyt_data_1', 55, 'integer', 'text', 'cat_dr', 'cat_dr', NULL, false, NULL, false, NULL, NULL, NULL, true, true, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

-- arc
UPDATE config_form_fields SET columnname='registration_date', widgettype='datetime' WHERE (formname ILIKE 've_arc%' OR formname='v_edit_arc') AND formtype='form_feature' AND columnname='registre_date' AND tabname='tab_data';

-- 10/03/2025
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('discharge_medium_typevalue', '0', 'Undefined', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active) VALUES('edit_typevalue', 'discharge_medium_typevalue', 'man_outfall', 'discharge_medium', NULL, true) ON CONFLICT (typevalue_table, typevalue_name, target_table, target_field) DO NOTHING;
UPDATE config_form_fields SET layoutname='lyt_data_1', widgettype='combo', dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue = ''discharge_medium_typevalue''', dv_isnullvalue=TRUE WHERE columnname='discharge_medium' AND formname ILIKE '%outfall%';

DELETE FROM config_form_fields WHERE columnname='buildercat_id';

INSERT INTO macroexploitation (macroexpl_id, code, "name", descript, lock_level, active, updated_at)
SELECT macroexpl_id, macroexpl_id::text, "name", descript, NULL, active, now()
FROM _macroexploitation;

INSERT INTO exploitation (expl_id, code, "name", descript, macroexpl_id, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT expl_id, expl_id::text, "name", descript, macroexpl_id, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _exploitation;

INSERT INTO macrosector (macrosector_id, code, "name", descript, lock_level, active, the_geom, updated_at)
SELECT macrosector_id, macrosector_id::text, "name", descript, NULL, active, the_geom, now()
FROM _macrosector;

INSERT INTO macroomzone (macroomzone_id, code, "name", descript, expl_id, lock_level, active, the_geom, updated_at)
SELECT macrodma_id, macrodma_id::text, "name", descript, ARRAY[expl_id], NULL, active, the_geom, now()
FROM _macrodma;

INSERT INTO omzone (omzone_id, code, "name", descript, omzone_type, expl_id, macroomzone_id, minc, maxc, effc, link,
graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT dma_id, dma_id::text, "name", descript, dma_type, expl_id, macrodma_id, minc, maxc, effc, link,
graphconfig, stylesheet, lock_level, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _dma;

INSERT INTO drainzone (drainzone_id, code, "name", drainzone_type, descript, expl_id, link, graphconfig, stylesheet, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT drainzone_id, drainzone_id::text, "name", drainzone_type, descript, ARRAY[expl_id], link, graphconfig, stylesheet, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _drainzone;

INSERT INTO sector (sector_id, code, "name", descript, macrosector_id, parent_id, lock_level, active, the_geom, created_at, created_by, updated_at, updated_by)
SELECT sector_id, sector_id::text, "name", descript, macrosector_id, parent_id, NULL, active, the_geom, tstamp, insert_user, lastupdate, lastupdate_user
FROM _sector;

-- 20/03/2025
-- todo: disable triggers

INSERT INTO node (node_id, code, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, node_type, nodecat_id, epa_type, sector_id, state, state_type,
annotation, observ, "comment", omzone_id, soilcat_id, function_type, category_type, _fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, rotation, link, verified, the_geom,
label_x, label_y, label_rotation, publish, inventory, xyz_date, uncertain, unconnected, expl_id, num_value, feature_type, created_at, arc_id, updated_at,
updated_by, created_by, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, parent_id, expl_visibility, adate, adescript, hemisphere, placement_type,
access_type, label_quadrant, minsector_id, brand_id, model_id, serial_number)
SELECT node_id::integer, code, top_elev, ymax, elev, custom_top_elev, custom_ymax, custom_elev, node_type, nodecat_id, epa_type, sector_id, state, state_type,
annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, rotation, link, verified::integer, the_geom,
label_x, label_y, label_rotation, publish, inventory, xyz_date, uncertain, unconnected, expl_id, num_value, feature_type, tstamp, arc_id::integer, lastupdate,
lastupdate_user, insert_user, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, parent_id::integer, ARRAY[expl_id2], adate, adescript, hemisphere, placement_type,
access_type, label_quadrant, minsector_id, brand_id, model_id, serial_number
FROM _node;


INSERT INTO arc (arc_id, code, sys_code, node_1, node_2, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2, sys_elev1, sys_elev2, arc_type, arccat_id,
matcat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", sys_slope, inverted_slope, custom_length, omzone_id, soilcat_id, function_type,
category_type, _fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement,
streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, the_geom, label_x, label_y, label_rotation, publish, inventory, uncertain, expl_id,
num_value, feature_type, created_at, updated_at, created_by, updated_by, district_id, workcat_id_plan, asset_id, pavcat_id, drainzone_id, nodetype_1,
node_sys_top_elev_1, node_sys_elev_1, nodetype_2, node_sys_top_elev_2, node_sys_elev_2, parent_id, expl_visibility, adate, adescript, visitability, label_quadrant,
minsector_id, brand_id, model_id, serial_number)
SELECT arc_id::integer, code, code, node_1::integer, node_2::integer, y1, y2, elev1, elev2, custom_y1, custom_y2, custom_elev1, custom_elev2, sys_elev1, sys_elev2, arc_type, arccat_id,
matcat_id, epa_type, sector_id, state, state_type, annotation, observ, "comment", sys_slope, inverted_slope, custom_length, dma_id, soilcat_id, function_type,
category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement,
streetaxis2_id, postnumber2, postcomplement2, descript, link, verified::integer, the_geom, label_x, label_y, label_rotation, publish, inventory, uncertain, expl_id,
num_value, feature_type, tstamp, lastupdate, lastupdate_user, insert_user, district_id, workcat_id_plan, asset_id, pavcat_id, drainzone_id, nodetype_1,
node_sys_top_elev_1, node_sys_elev_1, nodetype_2, node_sys_top_elev_2, node_sys_elev_2, parent_id::integer, ARRAY[expl_id2], adate, adescript, visitability, label_quadrant,
minsector_id, brand_id, model_id, serial_number
FROM _arc;


INSERT INTO connec (connec_id, code, top_elev, y1, y2, connec_type, conneccat_id, sector_id, customer_code,
demand, state, state_type, connec_depth, connec_length, arc_id, annotation, observ, "comment",
omzone_id, soilcat_id, function_type, category_type, _fluid_type, location_type, workcat_id, workcat_id_end, builtdate,
enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2,
postcomplement2, descript, link, verified, rotation, the_geom, label_x, label_y, label_rotation, accessibility,
diagonal, publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, pjoint_type, pjoint_id, updated_at,
created_by, updated_by, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, expl_visibility, adate, adescript,
plot_code, placement_type, access_type, label_quadrant, n_hydrometer, minsector_id)
SELECT connec_id::integer, code, top_elev, y1, y2, connec_type, conneccat_id, sector_id, customer_code,
demand, state, state_type, connec_depth, connec_length, arc_id::integer, annotation, observ, "comment",
dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, builtdate,
enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2,
postcomplement2, descript, link, verified::integer, rotation, the_geom, label_x, label_y, label_rotation, accessibility,
diagonal, publish, inventory, uncertain, expl_id, num_value, feature_type, tstamp, pjoint_type, pjoint_id::integer, lastupdate,
lastupdate_user, insert_user, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, ARRAY[expl_id2], adate, adescript,
plot_code, placement_type, access_type, label_quadrant, n_hydrometer, minsector_id
FROM _connec;


INSERT INTO gully (gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, gullycat_id, units, groove, siphon,
_connec_arccat_id, arc_id, "_pol_id_", sector_id, state, state_type, annotation, observ,
"comment", omzone_id, soilcat_id, function_type, category_type, _fluid_type, location_type, workcat_id, workcat_id_end,
builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id,
postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, label_x, label_y, label_rotation,
publish, inventory, uncertain, expl_id, num_value, feature_type, created_at, pjoint_type, pjoint_id, updated_at,
created_by, updated_by, district_id, workcat_id_plan, asset_id, _connec_matcat_id, connec_y2, _gratecat2_id,
epa_type, groove_height, groove_length, units_placement, drainzone_id, expl_visibility, adate, adescript, siphon_type,
odorflap, placement_type, access_type, label_quadrant, minsector_id)
SELECT gully_id::integer, code, top_elev, ymax, sandbox, matcat_id, gully_type, gullycat_id, units, groove, siphon,
connec_arccat_id, arc_id::integer, "_pol_id_", sector_id, state, state_type, annotation, observ,
"comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id,
postnumber2, postcomplement2, descript, link, verified::integer, rotation, the_geom, label_x, label_y, label_rotation,
publish, inventory, uncertain, expl_id, num_value, feature_type, tstamp, pjoint_type, pjoint_id::integer, lastupdate,
lastupdate_user, insert_user, district_id, workcat_id_plan, asset_id, connec_matcat_id, connec_y2, gullycat2_id,
epa_type, groove_height, groove_length, units_placement, drainzone_id, ARRAY[expl_id2], adate, adescript, siphon_type,
odorflap, placement_type, access_type, label_quadrant, minsector_id
NULL
FROM _gully;


INSERT INTO element (element_id, code, sys_code, elementcat_id, serial_number, num_elements, state, state_type, observ,
"comment", function_type, category_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, rotation, link, verified, the_geom, label_x, label_y, label_rotation, publish, inventory,
expl_id, feature_type, created_at, updated_at, created_by, updated_by, top_elev, expl_visibility, trace_featuregeom,
muni_id, sector_id, brand_id, model_id, asset_id)
SELECT element_id::integer, code, code, elementcat_id, serial_number, num_elements, state, state_type, observ,
"comment", function_type, category_type, location_type, workcat_id, workcat_id_end, builtdate, enddate,
ownercat_id, rotation, link, verified::integer, the_geom, label_x, label_y, label_rotation, publish, inventory,
expl_id, feature_type, tstamp, lastupdate, lastupdate_user, insert_user, top_elev, ARRAY[expl_id2], trace_featuregeom,
muni_id, sector_id, brand_id, model_id, asset_id
FROM _element;

-- 26/03/2025
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('v_edit_link','form_feature','tab_none','datasource','lyt_data_1',36,'integer','combo','Datasource','Datasource',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue = ''value_datasource''', true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_link','form_feature','tab_none','custom_length','lyt_data_1',37,'double','text','Custom length','Custom length',false,false,true,false,'{"setMultiline":false}'::json,false);

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('cat_connec','form_feature','tab_none','estimated_depth','double','text','Estimated depth:','Estimated depth',false,false,true,false,'{"setMultiline":false}'::json,false);



-- 28/03/2025
UPDATE sys_fprocess
SET query_text='select link_id as arc_id, linkcat_id as arccat_id, a.expl_id, l.the_geom FROM t_link l, temp_t_arc a WHERE st_dwithin(st_endpoint(l.the_geom), a.the_geom, 0.001) AND a.epa_type NOT IN (''CONDUIT'', ''PIPE'', ''VIRTUALVALVE'', ''VIRTUALPUMP'')'
WHERE fid=404;


DO $func$
DECLARE
  gullyr record;
  connecr record;
BEGIN
  FOR gullyr IN (SELECT gully_id, _connec_arccat_id FROM gully)
  LOOP
    IF NOT EXISTS(SELECT 1 FROM link WHERE feature_id = gullyr.gully_id) THEN
      EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || gullyr.gully_id || ']"},
     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "GULLY", "linkcatId":"UPDATE_LINK_40"}}$$);';
      UPDATE link SET uncertain=true WHERE feature_id = gullyr.gully_id;
    END IF;
  END LOOP;

  FOR connecr IN (SELECT connec_id, conneccat_id  FROM connec)
  LOOP
    IF NOT EXISTS(SELECT 1 FROM link WHERE feature_id = connecr.connec_id) THEN
      EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client": {"device": 4, "lang": "en_US", "infoType": 1, "epsg": SRID_VALUE}, "form": {}, "feature": {"id": "[' || connecr.connec_id || ']"},
     "data": {"filterFields": {}, "pageInfo": {}, "feature_type": "CONNEC", "linkcatId":"UPDATE_LINK_40"}}$$);';
      UPDATE link SET uncertain=true WHERE feature_id = connecr.connec_id;
    END IF;
  END LOOP;
END $func$;


UPDATE edit_typevalue SET typevalue='omzone_type' WHERE typevalue='dma_type' AND id='UNDEFINED';


UPDATE config_form_fields SET label = replace(label, 'dma', 'omzone'), tooltip = replace(tooltip, 'dma', 'omzone'), dv_querytext = replace(dv_querytext, 'dma', 'omzone'), dv_querytext_filterc = replace(dv_querytext_filterc, 'dma', 'omzone');
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

-- 30/04/2025
INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('formtype_typevalue', 'link_to_gully', 'link_to_gully', 'linkToGully', NULL);

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', '', 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{
  "functionName": "accept",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_add', 'lyt_connect_link_2', 1, NULL, 'button', NULL, 'Add', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "111"
}'::json, NULL, '{
  "functionName": "add",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', '', 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "text": "Close"
}'::json, '{
  "functionName": "close",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_remove', 'lyt_connect_link_2', 2, NULL, 'button', NULL, 'Remove', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "112"
}'::json, NULL, '{
  "functionName": "remove",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_snapping', 'lyt_connect_link_2', 3, NULL, 'button', NULL, 'Select on canvas', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "137"
}'::json, NULL, '{
  "functionName": "snapping",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'btn_filter_expression', 'lyt_connect_link_2', 4, NULL, 'button', NULL, 'Filter by expression', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{
  "icon": "178"
}'::json, NULL, '{
  "functionName": "filter_expression",
  "module": "connect_link_btn"
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'linkcat', 'lyt_connect_link_1', 2, 'text', 'combo', 'Link catalog:', 'Link catalog', NULL, true, NULL, true, NULL, NULL, 'SELECT id, id AS idval FROM cat_link WHERE id IS NOT NULL', NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'max_distance', 'lyt_connect_link_1', 1, 'text', 'text', 'Maximum distance:', 'Maximum distance', '300', true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'pipe_diameter', 'lyt_connect_link_1', 0, 'text', 'text', 'Pipe diameter:', 'Pipe diameter', '150', true, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'spacer_1', 'lyt_buttons', 0, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'tbl_ids', 'lyt_connect_link_3', 0, NULL, 'tableview', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'link_to_gully', 'tab_none', 'id', 'lyt_connect_link_2', 0, 'text', 'combo', 'Gully Id:', 'Gully Id', NULL, NULL, NULL, true, NULL, NULL, 'SELECT gully_id AS id, gully_id AS idval FROM gully WHERE gully_id IS NOT NULL', NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, false, 0);

-- 19/05/2025
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '0', 'NOT INFORMED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '1', 'RAINWATER', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '2', 'DILUTED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '3', 'FECAL', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('fluid_type', '4', 'UNITARY', NULL, NULL);

UPDATE config_form_fields
SET	dv_querytext = 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''',
widgettype = 'combo'
WHERE columnname = 'fluid_type';

UPDATE sys_param_user
SET	dv_querytext = 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type'''
WHERE dv_querytext ILIKE '%man_type_fluid%';

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_gully_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_link_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_arc_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_connec_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'archived_psector_node_traceability', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'gully', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'link', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'arc', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'connec', 'fluid_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'fluid_type', 'node', 'fluid_type', NULL, true);


DROP TRIGGER gw_trg_typevalue_fk ON sys_table;
DELETE FROM sys_foreignkey WHERE typevalue_table = 'config_typevalue' AND typevalue_name = 'sys_table_context' AND target_table = 'sys_table' AND target_field = 'context';

-- 30/06/2025
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('treatment_type', '0', 'NOT INFORMED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('treatment_type', '1', 'TREATED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('treatment_type', '2', 'NOT TREATED', NULL, NULL);
INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('treatment_type', '3', 'PRETRESTED', NULL, NULL);

UPDATE config_form_fields
SET	dv_querytext = 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''treatment_type''',
widgettype = 'combo'
WHERE columnname = 'treatment_type';

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'treatment_type', 'gully', 'treatment_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'treatment_type', 'node', 'treatment_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'treatment_type', 'arc', 'treatment_type', NULL, true);

INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, parameter_id, active)
VALUES('om_typevalue', 'treatment_type', 'connec', 'treatment_type', NULL, true);

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

-- 17/07/2025
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

    INSERT INTO utils.municipality (muni_id, name, observ, the_geom, active, region_id, province_id, ext_code)
    SELECT muni_id, name, observ, the_geom, active, region_id, province_id, ext_code FROM utils.municipality;

  ELSE

    INSERT INTO ext_municipality (muni_id, name, observ, the_geom, active, region_id, province_id, ext_code)
    SELECT muni_id, name, observ, the_geom, active, region_id, province_id, ext_code FROM _ext_municipality;

  END IF;
END; $$;