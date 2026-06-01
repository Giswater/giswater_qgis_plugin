/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector", "column":"code", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector", "column":"descript", "dataType":"text", "isUtils":"False"}}$$);

ALTER TABLE ext_rtc_hydrometer_state ALTER COLUMN is_operative SET DEFAULT true;

DROP VIEW IF EXISTS v_minsector;

CREATE OR REPLACE VIEW v_edit_minsector AS 
SELECT 
minsector_id, 
code,
dma_id, 
dqa_id, 
presszone_id, 
sector_id, 
m.expl_id, 
num_border, 
num_connec, 
num_hydro, 
length,
descript,
addparam, 
the_geom
FROM selector_expl, minsector m
  WHERE m.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_vertices AS 
 SELECT arc.arc_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    arc.point AS the_geom
   FROM ( SELECT (st_dumppoints(temp_arc.the_geom)).geom AS point,
            st_startpoint(temp_arc.the_geom) AS startpoint,
            st_endpoint(temp_arc.the_geom) AS endpoint,
            temp_arc.sector_id,
            temp_arc.arc_id
           FROM selector_inp_result,
            temp_arc
          WHERE temp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text) arc
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint);



CREATE OR REPLACE VIEW vi_status AS 
 SELECT temp_arc.arc_id,
    temp_arc.status
   FROM selector_inp_result,
    temp_arc
  WHERE (temp_arc.status::text = 'CLOSED'::text OR temp_arc.status::text = 'OPEN'::text) 
  AND temp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text 
  AND temp_arc.epa_type::text = 'VALVE'::text
UNION
 SELECT temp_arc.arc_id,
    temp_arc.status
   FROM selector_inp_result,
    temp_arc
  WHERE temp_arc.status::text = 'CLOSED'::text AND temp_arc.result_id::text = selector_inp_result.result_id::text 
  AND selector_inp_result.cur_user = "current_user"()::text AND temp_arc.epa_type::text = 'PUMP'::text
UNION
 SELECT temp_arc.arc_id,
    temp_arc.status
   FROM selector_inp_result,
    temp_arc
  WHERE temp_arc.status::text = 'CLOSED'::text AND temp_arc.result_id::text = selector_inp_result.result_id::text 
  AND selector_inp_result.cur_user = "current_user"()::text AND temp_arc.epa_type::text = 'PUMP'::text;


CREATE OR REPLACE VIEW vi_coordinates AS 
 SELECT temp_node.node_id,
    NULL::numeric(16,3) AS xcoord,
    NULL::numeric(16,3) AS ycoord,
    temp_node.the_geom
   FROM temp_node,
    selector_inp_result a
  WHERE a.result_id::text = temp_node.result_id::text AND a.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS vi_pjointpattern ;

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

ALTER TABLE inp_dscenario_pump_additional
  ADD CONSTRAINT inp_dscenario_pump_additional_pump_id_fkey FOREIGN KEY (node_id, order_id)
      REFERENCES inp_pump_additional (node_id, order_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

UPDATE config_form_fields
	SET widgettype='combo'
	WHERE formname='v_edit_inp_dscenario_pump_additional' AND columnname='order_id';

UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="44,171,255,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="square" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2.8" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE idval='v_edit_inp_reservoir';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="0,106,253,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="50,87,128,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0.4" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="3.2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE idval='v_edit_inp_tank';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="0,106,253,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="square" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2.8" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE idval='v_edit_inp_inlet';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="5,163,242,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE idval='v_edit_inp_junction';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.28.4-Firenze">
  <renderer-v2 referencescale="-1" enableorderby="0" forceraster="0" type="categorizedSymbol" symbollevels="0" attr="status">
    <categories>
      <category symbol="0" render="true" type="string" label="CLOSED" value="CLOSED"/>
      <category symbol="1" render="true" type="string" label="CV" value="CV"/>
      <category symbol="2" render="true" type="string" label="OPEN" value="OPEN"/>
      <category symbol="3" render="true" type="string" label="OTHER VALUES" value=""/>
    </categories>
    <symbols>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="0" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="227,26,28,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.4"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="2.4"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="1" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="253,191,111,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.4"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="2.4"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="2" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="31,120,180,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.4"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="2.4"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="3" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.4"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="2.4"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol is_animated="0" alpha="1" clip_to_extent="1" name="0" force_rhr="0" frame_rate="10" type="marker">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" type="QString" value=""/>
            <Option name="properties"/>
            <Option name="type" type="QString" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
          <Option type="Map">
            <Option name="angle" type="QString" value="0"/>
            <Option name="cap_style" type="QString" value="square"/>
            <Option name="color" type="QString" value="255,255,255,255"/>
            <Option name="horizontal_anchor_point" type="QString" value="1"/>
            <Option name="joinstyle" type="QString" value="bevel"/>
            <Option name="name" type="QString" value="circle"/>
            <Option name="offset" type="QString" value="0,0"/>
            <Option name="offset_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="offset_unit" type="QString" value="MM"/>
            <Option name="outline_color" type="QString" value="0,0,0,255"/>
            <Option name="outline_style" type="QString" value="solid"/>
            <Option name="outline_width" type="QString" value="0.4"/>
            <Option name="outline_width_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="outline_width_unit" type="QString" value="MM"/>
            <Option name="scale_method" type="QString" value="diameter"/>
            <Option name="size" type="QString" value="2.4"/>
            <Option name="size_map_unit_scale" type="QString" value="3x:0,0,0,0,0,0"/>
            <Option name="size_unit" type="QString" value="MM"/>
            <Option name="vertical_anchor_point" type="QString" value="1"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" type="QString" value=""/>
              <Option name="properties"/>
              <Option name="type" type="QString" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>' WHERE idval='v_edit_inp_shortpipe';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="255,255,255,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="0,0,0,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0.2" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="area" name="scale_method"/>
            <Option type="QString" value="2.6" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="0,0,0,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="0,0,0,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0.4" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="area" name="scale_method"/>
            <Option type="QString" value="0.5" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE idval='v_edit_inp_valve';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="0,106,253,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="83,83,83,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0.4" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="3.2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" locked="0" class="FontMarker" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="P" name="chr"/>
            <Option type="QString" value="255,255,255,255" name="color"/>
            <Option type="QString" value="Arial" name="font"/>
            <Option type="QString" value="Normal" name="font_style"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="0,-0.20000000000000001" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="35,35,35,255" name="outline_color"/>
            <Option type="QString" value="0" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="2.88" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE idval='v_edit_inp_pump';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="angle"/>
            <Option type="QString" value="square" name="cap_style"/>
            <Option type="QString" value="5,163,242,255" name="color"/>
            <Option type="QString" value="1" name="horizontal_anchor_point"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="circle" name="name"/>
            <Option type="QString" value="0,0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="50,87,128,255" name="outline_color"/>
            <Option type="QString" value="solid" name="outline_style"/>
            <Option type="QString" value="0.4" name="outline_width"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
            <Option type="QString" value="MM" name="outline_width_unit"/>
            <Option type="QString" value="diameter" name="scale_method"/>
            <Option type="QString" value="1.2" name="size"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
            <Option type="QString" value="MM" name="size_unit"/>
            <Option type="QString" value="1" name="vertical_anchor_point"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE idval='v_edit_inp_connec';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis labelsEnabled="1" version="3.28.4-Firenze" styleCategories="Symbology|Labeling">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="line" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="align_dash_pattern"/>
            <Option type="QString" value="square" name="capstyle"/>
            <Option type="QString" value="5;2" name="customdash"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale"/>
            <Option type="QString" value="MM" name="customdash_unit"/>
            <Option type="QString" value="0" name="dash_pattern_offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="dash_pattern_offset_unit"/>
            <Option type="QString" value="0" name="draw_inside_polygon"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="5,163,242,255" name="line_color"/>
            <Option type="QString" value="solid" name="line_style"/>
            <Option type="QString" value="0.5" name="line_width"/>
            <Option type="QString" value="MM" name="line_width_unit"/>
            <Option type="QString" value="0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="0" name="ring_filter"/>
            <Option type="QString" value="0" name="trim_distance_end"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale"/>
            <Option type="QString" value="MM" name="trim_distance_end_unit"/>
            <Option type="QString" value="0" name="trim_distance_start"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale"/>
            <Option type="QString" value="MM" name="trim_distance_start_unit"/>
            <Option type="QString" value="0" name="tweak_dash_pattern_on_corners"/>
            <Option type="QString" value="0" name="use_custom_dash"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="width_map_unit_scale"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style fieldName="arccat_id" multilineHeight="1" namedStyle="Normal" textOpacity="1" isExpression="0" useSubstitutions="0" blendMode="0" fontItalic="0" legendString="Aa" fontFamily="Arial" allowHtml="0" fontSizeUnit="Point" multilineHeightUnit="Percentage" fontKerning="1" previewBkgrdColor="255,255,255,255" fontSize="8" fontSizeMapUnitScale="3x:0,0,0,0,0,0" textColor="50,50,50,255" fontWeight="50" textOrientation="horizontal" fontStrikeout="0" fontLetterSpacing="0" forcedItalic="0" capitalization="0" fontWordSpacing="0" fontUnderline="0" forcedBold="0">
        <families/>
        <text-buffer bufferSize="1" bufferSizeUnits="MM" bufferColor="250,250,250,255" bufferBlendMode="0" bufferDraw="0" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferOpacity="1" bufferJoinStyle="128" bufferNoFill="1"/>
        <text-mask maskType="0" maskSize="0" maskedSymbolLayers="" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskOpacity="1" maskEnabled="0" maskJoinStyle="128" maskSizeUnits="MM"/>
        <background shapeType="0" shapeBorderWidth="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeSVGFile="" shapeSizeX="0" shapeBorderWidthUnit="Point" shapeBlendMode="0" shapeRotationType="0" shapeSizeType="0" shapeFillColor="255,255,255,255" shapeRadiiUnit="Point" shapeDraw="0" shapeOpacity="1" shapeRadiiY="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeRotation="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeSizeY="0" shapeOffsetUnit="Point" shapeRadiiX="0" shapeSizeUnit="Point" shapeJoinStyle="64" shapeOffsetX="0" shapeBorderColor="128,128,128,255" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0">
          <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="markerSymbol">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
              <Option type="Map">
                <Option type="QString" value="0" name="angle"/>
                <Option type="QString" value="square" name="cap_style"/>
                <Option type="QString" value="231,113,72,255" name="color"/>
                <Option type="QString" value="1" name="horizontal_anchor_point"/>
                <Option type="QString" value="bevel" name="joinstyle"/>
                <Option type="QString" value="circle" name="name"/>
                <Option type="QString" value="0,0" name="offset"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
                <Option type="QString" value="MM" name="offset_unit"/>
                <Option type="QString" value="35,35,35,255" name="outline_color"/>
                <Option type="QString" value="solid" name="outline_style"/>
                <Option type="QString" value="0" name="outline_width"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
                <Option type="QString" value="MM" name="outline_width_unit"/>
                <Option type="QString" value="diameter" name="scale_method"/>
                <Option type="QString" value="2" name="size"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
                <Option type="QString" value="MM" name="size_unit"/>
                <Option type="QString" value="1" name="vertical_anchor_point"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option name="properties"/>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol is_animated="0" type="fill" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="fillSymbol">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" locked="0" class="SimpleFill" enabled="1">
              <Option type="Map">
                <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
                <Option type="QString" value="255,255,255,255" name="color"/>
                <Option type="QString" value="bevel" name="joinstyle"/>
                <Option type="QString" value="0,0" name="offset"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
                <Option type="QString" value="MM" name="offset_unit"/>
                <Option type="QString" value="128,128,128,255" name="outline_color"/>
                <Option type="QString" value="no" name="outline_style"/>
                <Option type="QString" value="0" name="outline_width"/>
                <Option type="QString" value="Point" name="outline_width_unit"/>
                <Option type="QString" value="solid" name="style"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option name="properties"/>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowDraw="0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1" shadowOpacity="0.69999999999999996" shadowScale="100" shadowUnder="0" shadowColor="0,0,0,255" shadowOffsetAngle="135" shadowBlendMode="6" shadowOffsetDist="1" shadowRadiusAlphaOnly="0" shadowRadiusUnit="MM" shadowRadius="1.5" shadowOffsetUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0"/>
        <dd_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format useMaxLineLengthForAutoWrap="1" leftDirectionSymbol="&lt;" autoWrapLength="0" reverseDirectionSymbol="0" decimals="3" placeDirectionSymbol="0" wrapChar="" addDirectionSymbol="0" rightDirectionSymbol=">" formatNumbers="0" plussign="0" multilineAlign="0"/>
      <placement geometryGeneratorType="PointGeometry" priority="5" centroidWhole="0" rotationUnit="AngleDegrees" maxCurvedCharAngleOut="-25" placement="2" fitInPolygonOnly="0" polygonPlacementFlags="2" xOffset="0" maxCurvedCharAngleIn="25" layerType="LineGeometry" rotationAngle="0" preserveRotation="1" lineAnchorTextPoint="CenterOfText" centroidInside="0" repeatDistance="0" lineAnchorPercent="0.5" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" repeatDistanceUnits="MM" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" distMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" overrunDistance="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" distUnits="MM" offsetUnits="MM" geometryGenerator="" lineAnchorClipping="0" geometryGeneratorEnabled="0" overrunDistanceUnit="MM" overlapHandling="PreventOverlap" placementFlags="10" offsetType="0" allowDegraded="0" dist="0" lineAnchorType="0" yOffset="0"/>
      <rendering scaleMax="2000" obstacleType="1" fontMaxPixelSize="10000" limitNumLabels="0" obstacle="1" labelPerPart="0" scaleVisibility="1" upsidedownLabels="0" maxNumLabels="2000" drawLabels="1" unplacedVisibility="0" fontLimitPixelSize="0" obstacleFactor="1" fontMinPixelSize="3" mergeLines="0" zIndex="0" scaleMin="0" minFeatureSize="0"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" value="" name="name"/>
          <Option name="properties"/>
          <Option type="QString" value="collection" name="type"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option type="QString" value="pole_of_inaccessibility" name="anchorPoint"/>
          <Option type="int" value="0" name="blendMode"/>
          <Option type="Map" name="ddProperties">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
          <Option type="bool" value="false" name="drawToAllParts"/>
          <Option type="QString" value="0" name="enabled"/>
          <Option type="QString" value="point_on_exterior" name="labelAnchorPoint"/>
          <Option type="QString" value="&lt;symbol is_animated=&quot;0&quot; type=&quot;line&quot; clip_to_extent=&quot;1&quot; force_rhr=&quot;0&quot; frame_rate=&quot;10&quot; alpha=&quot;1&quot; name=&quot;symbol&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; value=&quot;&quot; name=&quot;name&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;collection&quot; name=&quot;type&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer pass=&quot;0&quot; locked=&quot;0&quot; class=&quot;SimpleLine&quot; enabled=&quot;1&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; value=&quot;0&quot; name=&quot;align_dash_pattern&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;square&quot; name=&quot;capstyle&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;5;2&quot; name=&quot;customdash&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;customdash_map_unit_scale&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;MM&quot; name=&quot;customdash_unit&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;0&quot; name=&quot;dash_pattern_offset&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;MM&quot; name=&quot;dash_pattern_offset_unit&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;0&quot; name=&quot;draw_inside_polygon&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;bevel&quot; name=&quot;joinstyle&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;60,60,60,255&quot; name=&quot;line_color&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;solid&quot; name=&quot;line_style&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;0.3&quot; name=&quot;line_width&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;MM&quot; name=&quot;line_width_unit&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;0&quot; name=&quot;offset&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;offset_map_unit_scale&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;MM&quot; name=&quot;offset_unit&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;0&quot; name=&quot;ring_filter&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;0&quot; name=&quot;trim_distance_end&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_end_map_unit_scale&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;MM&quot; name=&quot;trim_distance_end_unit&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;0&quot; name=&quot;trim_distance_start&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_start_map_unit_scale&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;MM&quot; name=&quot;trim_distance_start_unit&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;0&quot; name=&quot;tweak_dash_pattern_on_corners&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;0&quot; name=&quot;use_custom_dash&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;width_map_unit_scale&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; value=&quot;&quot; name=&quot;name&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;collection&quot; name=&quot;type&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol"/>
          <Option type="double" value="0" name="minLength"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale"/>
          <Option type="QString" value="MM" name="minLengthUnit"/>
          <Option type="double" value="0" name="offsetFromAnchor"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale"/>
          <Option type="QString" value="MM" name="offsetFromAnchorUnit"/>
          <Option type="double" value="0" name="offsetFromLabel"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale"/>
          <Option type="QString" value="MM" name="offsetFromLabelUnit"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>
' WHERE idval='v_edit_inp_pipe';


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="line" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="align_dash_pattern"/>
            <Option type="QString" value="square" name="capstyle"/>
            <Option type="QString" value="5;2" name="customdash"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale"/>
            <Option type="QString" value="MM" name="customdash_unit"/>
            <Option type="QString" value="0" name="dash_pattern_offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="dash_pattern_offset_unit"/>
            <Option type="QString" value="0" name="draw_inside_polygon"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="5,163,242,255" name="line_color"/>
            <Option type="QString" value="solid" name="line_style"/>
            <Option type="QString" value="0.541667" name="line_width"/>
            <Option type="QString" value="MM" name="line_width_unit"/>
            <Option type="QString" value="0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="0" name="ring_filter"/>
            <Option type="QString" value="0" name="trim_distance_end"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale"/>
            <Option type="QString" value="MM" name="trim_distance_end_unit"/>
            <Option type="QString" value="0" name="trim_distance_start"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale"/>
            <Option type="QString" value="MM" name="trim_distance_start_unit"/>
            <Option type="QString" value="0" name="tweak_dash_pattern_on_corners"/>
            <Option type="QString" value="0" name="use_custom_dash"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="width_map_unit_scale"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" locked="0" class="MarkerLine" enabled="1">
          <Option type="Map">
            <Option type="QString" value="4" name="average_angle_length"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale"/>
            <Option type="QString" value="MM" name="average_angle_unit"/>
            <Option type="QString" value="3" name="interval"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="interval_map_unit_scale"/>
            <Option type="QString" value="MM" name="interval_unit"/>
            <Option type="QString" value="0" name="offset"/>
            <Option type="QString" value="0" name="offset_along_line"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_along_line_unit"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="bool" value="true" name="place_on_every_part"/>
            <Option type="QString" value="CentralPoint" name="placements"/>
            <Option type="QString" value="0" name="ring_filter"/>
            <Option type="QString" value="1" name="rotate"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="@0@1">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
              <Option type="Map">
                <Option type="QString" value="0" name="angle"/>
                <Option type="QString" value="square" name="cap_style"/>
                <Option type="QString" value="255,255,255,255" name="color"/>
                <Option type="QString" value="1" name="horizontal_anchor_point"/>
                <Option type="QString" value="bevel" name="joinstyle"/>
                <Option type="QString" value="circle" name="name"/>
                <Option type="QString" value="0,0" name="offset"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
                <Option type="QString" value="MM" name="offset_unit"/>
                <Option type="QString" value="0,0,0,255" name="outline_color"/>
                <Option type="QString" value="solid" name="outline_style"/>
                <Option type="QString" value="0.4" name="outline_width"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
                <Option type="QString" value="MM" name="outline_width_unit"/>
                <Option type="QString" value="diameter" name="scale_method"/>
                <Option type="QString" value="2.6" name="size"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
                <Option type="QString" value="MM" name="size_unit"/>
                <Option type="QString" value="1" name="vertical_anchor_point"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option name="properties"/>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
              <Option type="Map">
                <Option type="QString" value="0" name="angle"/>
                <Option type="QString" value="square" name="cap_style"/>
                <Option type="QString" value="0,0,0,255" name="color"/>
                <Option type="QString" value="1" name="horizontal_anchor_point"/>
                <Option type="QString" value="bevel" name="joinstyle"/>
                <Option type="QString" value="circle" name="name"/>
                <Option type="QString" value="0,0" name="offset"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
                <Option type="QString" value="MM" name="offset_unit"/>
                <Option type="QString" value="35,35,35,255" name="outline_color"/>
                <Option type="QString" value="solid" name="outline_style"/>
                <Option type="QString" value="0" name="outline_width"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
                <Option type="QString" value="MM" name="outline_width_unit"/>
                <Option type="QString" value="diameter" name="scale_method"/>
                <Option type="QString" value="0.5" name="size"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
                <Option type="QString" value="MM" name="size_unit"/>
                <Option type="QString" value="1" name="vertical_anchor_point"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option name="properties"/>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>
' WHERE idval='v_edit_inp_virtualvalve';


INSERT INTO sys_style (id, idval, styletype, stylevalue, active) VALUES(169, 'v_edit_inp_virtualpump', 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.28.4-Firenze" styleCategories="Symbology">
  <renderer-v2 forceraster="0" type="singleSymbol" referencescale="-1" enableorderby="0" symbollevels="0">
    <symbols>
      <symbol is_animated="0" type="line" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" class="SimpleLine" enabled="1">
          <Option type="Map">
            <Option type="QString" value="0" name="align_dash_pattern"/>
            <Option type="QString" value="square" name="capstyle"/>
            <Option type="QString" value="5;2" name="customdash"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale"/>
            <Option type="QString" value="MM" name="customdash_unit"/>
            <Option type="QString" value="0" name="dash_pattern_offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="dash_pattern_offset_unit"/>
            <Option type="QString" value="0" name="draw_inside_polygon"/>
            <Option type="QString" value="bevel" name="joinstyle"/>
            <Option type="QString" value="5,163,242,255" name="line_color"/>
            <Option type="QString" value="solid" name="line_style"/>
            <Option type="QString" value="0.535714" name="line_width"/>
            <Option type="QString" value="MM" name="line_width_unit"/>
            <Option type="QString" value="0" name="offset"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="QString" value="0" name="ring_filter"/>
            <Option type="QString" value="0" name="trim_distance_end"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale"/>
            <Option type="QString" value="MM" name="trim_distance_end_unit"/>
            <Option type="QString" value="0" name="trim_distance_start"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale"/>
            <Option type="QString" value="MM" name="trim_distance_start_unit"/>
            <Option type="QString" value="0" name="tweak_dash_pattern_on_corners"/>
            <Option type="QString" value="0" name="use_custom_dash"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="width_map_unit_scale"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" locked="0" class="MarkerLine" enabled="1">
          <Option type="Map">
            <Option type="QString" value="4" name="average_angle_length"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale"/>
            <Option type="QString" value="MM" name="average_angle_unit"/>
            <Option type="QString" value="3" name="interval"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="interval_map_unit_scale"/>
            <Option type="QString" value="MM" name="interval_unit"/>
            <Option type="QString" value="0" name="offset"/>
            <Option type="QString" value="0" name="offset_along_line"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_along_line_unit"/>
            <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
            <Option type="QString" value="MM" name="offset_unit"/>
            <Option type="bool" value="true" name="place_on_every_part"/>
            <Option type="QString" value="CentralPoint" name="placements"/>
            <Option type="QString" value="0" name="ring_filter"/>
            <Option type="QString" value="1" name="rotate"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol is_animated="0" type="marker" clip_to_extent="1" force_rhr="0" frame_rate="10" alpha="1" name="@0@1">
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
            </data_defined_properties>
            <layer pass="0" locked="0" class="SimpleMarker" enabled="1">
              <Option type="Map">
                <Option type="QString" value="0" name="angle"/>
                <Option type="QString" value="square" name="cap_style"/>
                <Option type="QString" value="0,106,253,255" name="color"/>
                <Option type="QString" value="1" name="horizontal_anchor_point"/>
                <Option type="QString" value="bevel" name="joinstyle"/>
                <Option type="QString" value="circle" name="name"/>
                <Option type="QString" value="0,0" name="offset"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
                <Option type="QString" value="MM" name="offset_unit"/>
                <Option type="QString" value="0,0,0,255" name="outline_color"/>
                <Option type="QString" value="solid" name="outline_style"/>
                <Option type="QString" value="0.2" name="outline_width"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
                <Option type="QString" value="MM" name="outline_width_unit"/>
                <Option type="QString" value="diameter" name="scale_method"/>
                <Option type="QString" value="3" name="size"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
                <Option type="QString" value="MM" name="size_unit"/>
                <Option type="QString" value="1" name="vertical_anchor_point"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option name="properties"/>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
            <layer pass="0" locked="0" class="FontMarker" enabled="1">
              <Option type="Map">
                <Option type="QString" value="0" name="angle"/>
                <Option type="QString" value="P" name="chr"/>
                <Option type="QString" value="255,255,255,255" name="color"/>
                <Option type="QString" value="Arial" name="font"/>
                <Option type="QString" value="Normal" name="font_style"/>
                <Option type="QString" value="1" name="horizontal_anchor_point"/>
                <Option type="QString" value="bevel" name="joinstyle"/>
                <Option type="QString" value="0,0" name="offset"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
                <Option type="QString" value="MM" name="offset_unit"/>
                <Option type="QString" value="35,35,35,255" name="outline_color"/>
                <Option type="QString" value="0" name="outline_width"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale"/>
                <Option type="QString" value="MM" name="outline_width_unit"/>
                <Option type="QString" value="2.5" name="size"/>
                <Option type="QString" value="3x:0,0,0,0,0,0" name="size_map_unit_scale"/>
                <Option type="QString" value="MM" name="size_unit"/>
                <Option type="QString" value="1" name="vertical_anchor_point"/>
              </Option>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option name="properties"/>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>
', true);

DROP RULE IF EXISTS undelete_macrodqa ON macrodqa;
CREATE RULE undelete_macrodqa AS
ON DELETE TO macrodqa
WHERE (old.undelete = true) DO INSTEAD NOTHING;

DROP RULE IF EXISTS macrodqa_undefined ON macrodqa;
CREATE RULE macrodqa_undefined AS
ON UPDATE TO macrodqa
WHERE ((new.macrodqa_id = 0) OR (old.macrodqa_id = 0)) DO INSTEAD NOTHING;

DROP RULE IF EXISTS macrodqa_del_undefined ON macrodqa;
CREATE RULE macrodqa_del_undefined AS
ON DELETE TO macrodqa
WHERE (old.macrodqa_id = 0) DO INSTEAD NOTHING;

ALTER TABLE om_waterbalance_dma_graph  ADD CONSTRAINT om_waterbalance_dma_graph_unique UNIQUE (dma_id, node_id);

CREATE TRIGGER gw_trg_edit_minsector INSTEAD OF INSERT OR DELETE OR UPDATE 
 ON v_edit_minsector FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_minsector();
