/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 15/10/2024
INSERT INTO cat_arc (id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef)
SELECT id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand_id, model_id, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef
FROM _cat_arc;

INSERT INTO cat_node (id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", acoeff)
SELECT id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand_id, model_id, svg, estimated_y, cost_unit, "cost", active, "label", acoeff
FROM _cat_node;

INSERT INTO cat_connec (id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand_id, model_id, svg, active, "label")
SELECT id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand_id, model_id, svg, active, "label"
FROM _cat_connec;

INSERT INTO cat_gully (id, gully_type, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand_id, model_id, svg, active, "label")
SELECT id, gully_type, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand_id, model_id, svg, active, "label"
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

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('epa_selector', 'tab_time', 'Date time', 'Date time', 'role_baisc', NULL, NULL, 1, '{5}');

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
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('epa_results', 'SELECT result_id as id, expl_id::text, sector_id::text, network_type, status, iscorporate::text, descript, cur_user, exec_date, rpt_stats::text, addparam, export_options, network_stats, inp_options FROM v_ui_rpt_cat_result', 5, 'tab', 'list', '{"orderBy":"1", "orderType": "DESC"}'::json, '{
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
        "desc": true
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
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_flwreg_outlet', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_flwreg_orifice', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_flwreg_pump', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_flwreg_weir', 'tab_none', NULL, NULL, 'role_basic', NULL, '[
  {
    "actionName": "actionSetToArc",
    "disabled": false
  }
]'::json, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dwf', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');


UPDATE config_form_list
	SET query_text='SELECT nodarc_id, to_arc, order_id, flwreg_length, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4 FROM inp_flwreg_orifice WHERE id IS NOT NULL'
	WHERE listname='inp_flwreg_orifice' AND device=4;
UPDATE config_form_list
	SET query_text='SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.ori_type, d.offsetval, d.cd, d.orate, d.flap, d.shape, d.geom1, d.geom2, d.geom3, d.geom4
FROM inp_dscenario_flwreg_orifice d
JOIN inp_flwreg_orifice f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL'
	WHERE listname='inp_dscenario_flwreg_orifice' AND device=4;


DELETE FROM config_form_tableview
	WHERE objectname='inp_dscenario_flwreg_orifice' AND columnname='close_time';
DELETE FROM config_form_tableview
	WHERE objectname='inp_flwreg_orifice' AND columnname='close_time';
UPDATE config_form_tableview
	SET columnindex=16
	WHERE objectname='inp_flwreg_orifice' AND columnname='nodarc_id';

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

UPDATE sys_param_user SET dv_querytext='SELECT id, idval FROM cat_dwf WHERE id IS not null' WHERE id='inp_options_dwfscenario';

--05/12/2024
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_flwreg_orifice', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_flwreg_outlet', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_flwreg_pump', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_flwreg_weir', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_inp_dscenario_inflows', 'tab_none', NULL, NULL, 'role_basic', NULL, NULL, 0, '{4,5}');
