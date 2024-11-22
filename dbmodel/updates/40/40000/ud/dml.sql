/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 15/10/2024
INSERT INTO cat_arc (id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef)
SELECT id, arc_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6, geom7, geom8, geom_r, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, "cost", m2bottom_cost, m3protec_cost, active, "label", tsect_id, curve_id, acoeff, connect_cost, visitability_vdef
FROM _cat_arc;

INSERT INTO cat_node (id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", acoeff)
SELECT id, node_type, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, "cost", active, "label", acoeff
FROM _cat_node;

INSERT INTO cat_connec (id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand, model, svg, active, "label")
SELECT id, connec_type, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand, model, svg, active, "label"
FROM _cat_connec;

INSERT INTO cat_gully (id, gully_type, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, "label")
SELECT id, gully_type, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, "label"
FROM _cat_grate;


-- INSERT INTO connec (connec_id, code, top_elev, y1, y2, connec_type, conneccat_id, sector_id, customer_code, private_conneccat_id, demand, state, state_type, connec_depth, connec_length, arc_id, annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, undelete, label_x, label_y, label_rotation, accessibility, diagonal, publish, inventory, uncertain, expl_id, num_value, feature_type, tstamp, pjoint_type, pjoint_id, lastupdate, lastupdate_user, insert_user, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, expl_id2, adate, adescript, plot_code, placement_type, access_type, label_quadrant, n_hydrometer, minsector_id, macrominsector_id)
-- SELECT connec_id, code, top_elev, y1, y2, connec_type, connecat_id, sector_id, customer_code, private_connecat_id, demand, state, state_type, connec_depth, connec_length, arc_id, annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, undelete, label_x, label_y, label_rotation, accessibility, diagonal, publish, inventory, uncertain, expl_id, num_value, feature_type, tstamp, pjoint_type, pjoint_id, lastupdate, lastupdate_user, insert_user, matcat_id, district_id, workcat_id_plan, asset_id, drainzone_id, expl_id2, adate, adescript, plot_code, placement_type, access_type, label_quadrant, n_hydrometer, minsector_id, macrominsector_id
-- FROM _connec;

-- INSERT INTO gully (gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, gullycat_id, units, groove, siphon, connec_arccat_id, connec_length, connec_depth, arc_id, "_pol_id_", sector_id, state, state_type, annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, undelete, label_x, label_y, label_rotation, publish, inventory, uncertain, expl_id, num_value, feature_type, tstamp, pjoint_type, pjoint_id, lastupdate, lastupdate_user, insert_user, district_id, workcat_id_plan, asset_id, connec_matcat_id, connec_y2, gullycat2_id, epa_type, groove_height, groove_length, units_placement, drainzone_id, expl_id2, adate, adescript, siphon_type, odorflap, placement_type, access_type, label_quadrant, minsector_id, macrominsector_id)
-- SELECT gully_id, code, top_elev, ymax, sandbox, matcat_id, gully_type, gratecat_id, units, groove, siphon, connec_arccat_id, connec_length, connec_depth, arc_id, "_pol_id_", sector_id, state, state_type, annotation, observ, "comment", dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, descript, link, verified, rotation, the_geom, undelete, label_x, label_y, label_rotation, publish, inventory, uncertain, expl_id, num_value, feature_type, tstamp, pjoint_type, pjoint_id, lastupdate, lastupdate_user, insert_user, district_id, workcat_id_plan, asset_id, connec_matcat_id, connec_y2, gratecat2_id, epa_type, groove_height, groove_length, units_placement, drainzone_id, expl_id2, adate, adescript, siphon_type, odorflap, placement_type, access_type, label_quadrant, minsector_id, macrominsector_id
-- FROM _gully;

-- INSERT INTO man_netgully (node_id, sander_depth, gullycat_id, units, groove, siphon, gullycat2_id, groove_height, groove_length, units_placement)
-- SELECT node_id, sander_depth, gratecat_id, units, groove, siphon, gratecat2_id, groove_height, groove_length, units_placement
-- FROM _man_netgully;

-- INSERT INTO review_gully (gully_id, top_elev, ymax, sandbox, gully_type, matcat_id, gullycat_id, units, groove, siphon, connec_arccat_id, annotation, observ, review_obs, expl_id, the_geom, field_checked, is_validated, field_date)
-- SELECT gully_id, top_elev, ymax, sandbox, gully_type, matcat_id, gratecat_id, units, groove, siphon, connec_arccat_id, annotation, observ, review_obs, expl_id, the_geom, field_checked, is_validated, field_date
-- FROM _review_gully;

-- INSERT INTO link (link_id, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, expl_id, the_geom, tstamp, exit_topelev, sector_id, dma_id, fluid_type, exit_elev, expl_id2, epa_type, is_operative, insert_user, lastupdate, lastupdate_user, conneccat_id, workcat_id, workcat_id_end, builtdate, enddate, drainzone_id, uncertain, muni_id)
-- SELECT link_id, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, expl_id, the_geom, tstamp, exit_topelev, sector_id, dma_id, fluid_type, exit_elev, expl_id2, epa_type, is_operative, insert_user, lastupdate, lastupdate_user, connecat_id, workcat_id, workcat_id_end, builtdate, enddate, drainzone_id, uncertain, muni_id
-- FROM _link;


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
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'compare_date', 'lyt_time_2', 0, 'string', 'combo', 'Compare date', 'Compare date', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "setComboValues",
  "parameters": {
    "cmbListToChange": [
      "compare_time"
    ]
  }
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_compare', 'lyt_result_1', 1, 'string', 'combo', 'Result name (to compare):', 'Result name (to compare)', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "setComboValues",
  "parameters": {
    "cmbListToChange": [
      "compare_date",
      "compare_time"
    ]
  }
}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'selector_time', 'lyt_time_1', 1, 'string', 'combo', 'Selector time', 'Selector time', NULL, false, false, true, false, false, NULL, NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'compare_time', 'lyt_time_2', 1, 'string', 'combo', 'Compare time', 'Compare time', NULL, false, false, true, false, false, NULL, NULL, true, NULL, NULL, NULL, '{"setMultiline":false}'::json, NULL, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_time', 'selector_date', 'lyt_time_1', 0, 'string', 'combo', 'Selector date', 'Selector date', NULL, false, false, true, false, false, NULL, NULL, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "setComboValues",
  "parameters": {
    "cmbListToChange": [
      "selector_time"
    ]
  }
}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'epa_selector', 'tab_result', 'result_name_show', 'lyt_result_1', 0, 'string', 'combo', 'Result name (to show):', 'Result name', NULL, false, false, true, false, false, 'SELECT result_id AS id, result_id AS idval FROM v_ui_rpt_cat_result WHERE status = ''COMPLETED''', NULL, false, NULL, NULL, NULL, '{"setMultiline":false}'::json, '{
  "functionName": "setComboValues",
  "parameters": {
    "cmbListToChange": [
      "selector_date",
      "selector_time"
    ]
  }
}'::json, NULL, false, 0);

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('epa_selector_tab_time', '{"layouts":["lyt_time_1","lyt_time_2"]}', NULL, NULL, NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);