/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE ext_rtc_hydrometer_state SET is_operative=TRUE;


UPDATE config_form_list set query_text = replace(query_text, 'v_ui_hydroval_x_connec', 'v_ui_hydroval') where listname = 'tbl_hydrometer_value';

UPDATE config_form_fields
	SET dv_querytext_filterc=NULL
	WHERE formtype='form_feature' AND columnname='cat_period_id' AND tabname='tab_hydrometer_val';
UPDATE config_form_fields
	SET dv_querytext_filterc='WHERE feature_id '
	WHERE formtype='form_feature' AND columnname='hydrometer_customer_code' AND tabname='tab_hydrometer_val';

UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters": {"field_id": "feature_id"}}'::json
	WHERE formtype='form_feature' AND columnname IN ('cat_period_id', 'hydrometer_customer_code') AND tabname='tab_hydrometer_val';
UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters": {"columnfind": "hydrometer_customer_code", "field_id": "feature_id"}}'::json
	WHERE formtype='form_feature' AND columnname='hydrometer_id' AND tabname='tab_hydrometer';
	

insert into sys_param_user (id,formname, descript, sys_role, idval, label, isenabled, layoutorder, project_type, "datatype", 
widgettype, ismandatory , layoutname,iseditable, placeholder, source)
select 'inp_report_nodes_2', formname, descript, sys_role, idval, label, isenabled, layoutorder+1, project_type, "datatype", 
widgettype, ismandatory , layoutname, iseditable, placeholder, source from sys_param_user spu where id = 'inp_report_nodes';

update sys_param_user set label = concat(label,'I-(max.40):') where id = 'inp_report_nodes';
update sys_param_user set label = concat(label,'II-(max.40):') where id = 'inp_report_nodes_2';

update sys_param_user set layoutorder = 10 where id = 'inp_report_links';

DELETE FROM sys_param_user WHERE id = 'inp_options_rtc_period_id';
DELETE FROM config_param_user WHERE parameter = 'inp_options_rtc_period_id';

-- 28/07/2023

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_junction', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
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
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_junction', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_junction', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_junction', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
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


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_outfall', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
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
   ]
  }
}'::json, 'tbl_inp_outfall', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_outfall', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_junction', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_outfall', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
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
   ]
  }
}'::json, 'tbl_inp_outfall', false, NULL);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_storage', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
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
   ]
  }
}'::json, 'tbl_inp_storage', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_storage', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_junction', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_storage', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
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
   ]
  }
}'::json, 'tbl_inp_storage', false, NULL);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_conduit', 'form_feature', 'tab_epa', 'add_to_dscenario', 'lyt_epa_dsc_1', 1, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"111b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "add_to_dscenario",
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
   ]
  }
}'::json, 'tbl_inp_conduit', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_conduit', 'form_feature', 'tab_epa', 'hspacer_epa_1', 'lyt_epa_dsc_1', 3, NULL, 'hspacer', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, NULL, 'tbl_inp_junction', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_epa_conduit', 'form_feature', 'tab_epa', 'remove_from_dscenario', 'lyt_epa_dsc_1', 2, NULL, 'button', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"112b", "size":"24x24"}'::json, '{"saveValue": false}'::json, '{
  "functionName": "remove_from_dscenario",
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
   ]
  }
}'::json, 'tbl_inp_conduit', false, NULL);


UPDATE config_form_list
	SET query_text='SELECT dscenario_id, arc_id, arccat_id, matcat_id, elev1, elev2, custom_n, barrels, culvert, kentry, kexit, kavg, flap, q0, qmax, seepage FROM v_edit_inp_dscenario_conduit WHERE arc_id IS NOT NULL'
	WHERE listname='tbl_inp_conduit';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, y0, ysur, apond, outfallparam, elev, ymax FROM v_edit_inp_dscenario_junction WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_junction';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, elev, ymax, outfall_type, stage, curve_id, timser_id, gate FROM v_edit_inp_dscenario_outfall WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_outfall';
UPDATE config_form_list
	SET query_text='SELECT dscenario_id, node_id, elev, ymax, storage_type, curve_id, a1, a2, a0, fevap, sh, hc, imd, y0, ysur, apond FROM v_edit_inp_dscenario_storage WHERE node_id IS NOT NULL'
	WHERE listname='tbl_inp_storage';

ALTER TABLE inp_dscenario_flwreg_weir DROP CONSTRAINT IF EXISTS inp_dscenario_flwreg_weir_check_type;
ALTER TABLE inp_dscenario_flwreg_weir ADD CONSTRAINT inp_dscenario_flwreg_weir_check_type 
CHECK (weir_type::text = ANY (ARRAY['ROADWAY', 'SIDEFLOW', 'TRANSVERSE', 'V-NOTCH', 'TRAPEZOIDAL_WEIR']));
ALTER TABLE inp_flwreg_weir ADD CONSTRAINT inp_dscenario_flwreg_weir_check_type 
CHECK (weir_type::text = ANY (ARRAY['ROADWAY', 'SIDEFLOW', 'TRANSVERSE', 'V-NOTCH', 'TRAPEZOIDAL_WEIR']));

-- configure pkey for flwreg tables
UPDATE sys_table
	SET addparam='{"pkey":"dscenario_id, nodarc_id"}'::json
	WHERE id IN ('inp_dscenario_flwreg_orifice', 'inp_dscenario_flwreg_outlet', 'inp_dscenario_flwreg_pump', 'inp_dscenario_flwreg_weir');

-- configure tab epa for gullies
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_gully', formtype, 'tab_epa', columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, TRUE, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='ve_node_netgully' and columnname in ('custom_top_elev')
order by layoutorder;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_gully', formtype, 'tab_epa', columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, TRUE, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='ve_epa_netgully' and columnname in ('outlet_type', 'custom_width', 'custom_length', 'custom_depth', 'method', 'weir_cd', 'orifice_cd', 'custom_a_param', 'custom_b_param', 'efficiency')
order by layoutorder;

UPDATE config_form_fields set layoutorder=2 WHERE formname='ve_epa_gully' AND columnname='outlet_type';

UPDATE config_form_fields set tabname='tab_epa' WHERE  formname ='ve_epa_netgully'