/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/03/02

-- TAB CONNECTIONS 
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_1', 'lyt_connection_1','lytConnection1');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_2', 'lyt_connection_2','lytConnection2');
INSERT INTO config_typevalue VALUES('layout_name_typevalue', 'lyt_connection_3', 'lyt_connection_3','lytConnection3');

INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_connection_upstream', 'SELECT * FROM v_ui_node_x_connection_upstream WHERE rid IS NOT NULL', 4);
INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_connection_downstream', 'SELECT * FROM v_ui_node_x_connection_downstream WHERE rid IS NOT NULL', 4);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('node', 'form_feature', 'connection', 'tbl_upstream', 'lyt_connection_2', 1, 'tableview', 'Upstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_upstream');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject)
    VALUES ('node', 'form_feature', 'connection', 'tbl_downstream', 'lyt_connection_3', 1, 'tableview', 'Downstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_downstream');


INSERT INTO config_form_tabs VALUES ('v_edit_gully','tab_epa','EPA results',NULL,'role_basic',NULL,'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false}, {"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false}, {"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false}, {"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false}, {"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false}, {"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]',4, 1) ON CONFLICT (formname, tabname, device) DO NOTHING;

--junction
INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_junction', 'SELECT dscenario_id, y0, ysur, apond, outfallparam, elev, ymax FROM v_edit_inp_dscenario_junction WHERE node_id IS NOT NULL', 4); -- SELECT dscenario_id, demand, pattern_id, emitter_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_junction WHERE node_id IS NOT NULL

/*INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'manage_demands', 'lyt_epa_1', 1, 'button', 'Manage demands', false, false, true, false, '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', NULL, false, '');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'hspacer_lyt_epa', 'lyt_epa_1', 10, 'hspacer', false, false, true, false);*/

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'y0', 'lyt_epa_data_1', 1, 'string', 'text', 'y0:', 'y0', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'ysur', 'lyt_epa_data_1', 2, 'string', 'text', 'ysur:', 'ysur', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'apond', 'lyt_epa_data_1', 3, 'string', 'text', 'apond:', 'apond', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'outfallparam', 'lyt_epa_data_1', 4, 'string', 'text', 'outfallparam:', 'outfallparam', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_average', 'lyt_epa_data_2', 1, 'string', 'text', 'Average depth:', 'Average depth', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_max', 'lyt_epa_data_2', 2, 'string', 'text', 'Max depth:', 'Max depth', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_max_day', 'lyt_epa_data_2', 3, 'string', 'text', 'Max depth/day:', 'Max depth per day', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_max_hour', 'lyt_epa_data_2', 4, 'string', 'text', 'Max depth/hour:', 'Max depth per hour', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'surcharge_hour', 'lyt_epa_data_2', 5, 'string', 'text', 'Surcharge/hour:', 'Surcharge per hour', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'surgarge_max_height', 'lyt_epa_data_2', 6, 'string', 'text', 'max height of surgarge:', 'Max height of surgarge', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_hour', 'lyt_epa_data_2', 7, 'string', 'text', 'Flood hour:', 'Flood hour', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_max_rate', 'lyt_epa_data_2', 8, 'string', 'text', 'Maximum food rate:', 'Maximum food rate', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'time_day', 'lyt_epa_data_2', 9, 'string', 'text', 'Day:', 'Day', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'time_hour', 'lyt_epa_data_2', 9, 'string', 'text', 'Hour:', 'Hour', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_total', 'lyt_epa_data_2', 9, 'string', 'text', 'Total flood:', 'Total flood', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_max_ponded', 'lyt_epa_data_2', 9, 'string', 'text', 'Max ponded flood :', 'Max ponded flood', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'tbl_inp_junction', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_junction');

--outfall

INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_outfall', 'SELECT dscenario_id, elev, ymax, outfall_type, stage, curve_id, timser_id, gate FROM v_edit_inp_dscenario_outfall WHERE node_id IS NOT NULL', 4); -- SELECT dscenario_id, demand, pattern_id, emitter_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_junction WHERE node_id IS NOT NULL

/*INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'manage_demands', 'lyt_epa_1', 1, 'button', 'Manage demands', false, false, true, false, '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', NULL, false, '');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'hspacer_lyt_epa', 'lyt_epa_1', 10, 'hspacer', false, false, true, false);*/

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'outfall_type', 'lyt_epa_data_1', 1, 'string', 'combo', 'Outfall type:', 'Outfall type', false, false, true, false, 'SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_outfall''','{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'stage', 'lyt_epa_data_1', 2, 'string', 'text', 'stage:', 'stage', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 3, 'string', 'combo', 'curve_id:', 'curve_id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'timser_id', 'lyt_epa_data_1', 4, 'string', 'combo', 'timser_id:', 'timser_id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'gate', 'lyt_epa_data_1', 5, 'string', 'text', 'gate:', 'gate', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'flow_freq', 'lyt_epa_data_2', 1, 'string', 'text', 'Flow frequency:', 'Flow frequency', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'avg_flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Average flow:', 'Average flow', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 3, 'string', 'text', 'Max flow:', 'Max flow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'total_vol', 'lyt_epa_data_2', 4, 'string', 'text', 'Total volume:', 'Total volume', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'tbl_inp_outfall', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_outfall');

--storage
INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_storage', 'SELECT dscenario_id, elev, ymax, storage_type, curve_id, a1, 
       a2, a0, fevap, sh, hc, imd, y0, ysur, apond FROM v_edit_inp_dscenario_storage WHERE node_id IS NOT NULL', 4); -- SELECT dscenario_id, demand, pattern_id, emitter_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_junction WHERE node_id IS NOT NULL

/*INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'manage_demands', 'lyt_epa_1', 1, 'button', 'Manage demands', false, false, true, false, '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', NULL, false, '');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'hspacer_lyt_epa', 'lyt_epa_1', 10, 'hspacer', false, false, true, false);*/
 
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'storage_type', 'lyt_epa_data_1', 1, 'string', 'text', 'Storage type:', 'Storage type', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);     
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 2, 'string', 'combo', 'curve_id:', 'curve_id', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'a1', 'lyt_epa_data_1', 3, 'string', 'text', 'a1:', 'a1', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'a2', 'lyt_epa_data_1', 4, 'string', 'text', 'a2:', 'a2', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'a0', 'lyt_epa_data_1', 5, 'string', 'text', 'a0:', 'a0', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'fevap', 'lyt_epa_data_1', 6, 'string', 'text', 'fevap:', 'fevap', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'sh', 'lyt_epa_data_1', 7, 'string', 'text', 'sh:', 'sh', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'hc', 'lyt_epa_data_1', 8, 'string', 'text', 'hc:', 'hc', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'imd', 'lyt_epa_data_1', 9, 'string', 'text', 'imd:', 'imd', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'y0', 'lyt_epa_data_1', 10, 'string', 'text', 'y0:', 'y0', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'ysur', 'lyt_epa_data_1', 11, 'string', 'text', 'ysur:', 'ysur', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'apond', 'lyt_epa_data_1', 12, 'string', 'text', 'apond:', 'apond', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'aver_vol', 'lyt_epa_data_2', 1, 'string', 'text', 'aver_vol:', 'aver_vol', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'avg_full', 'lyt_epa_data_2', 2, 'string', 'text', 'avg_full :', 'avg_full', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'ei_loss', 'lyt_epa_data_2', 3, 'string', 'text', 'ei_loss:', 'ei_loss', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'max_vol', 'lyt_epa_data_2', 4, 'string', 'text', 'max_vol:', 'max_vol', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'max_full', 'lyt_epa_data_2', 5, 'string', 'text', 'max_full:', 'max_full', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'time_days', 'lyt_epa_data_2', 6, 'string', 'text', 'time_days:', 'time_days', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'time_hour', 'lyt_epa_data_2', 7, 'string', 'text', 'time_hour:', 'time_hour', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'max_out', 'lyt_epa_data_2', 8, 'string', 'text', 'max_out:', 'max_out', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'tbl_inp_storage', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_storage');


--conduit
INSERT INTO config_form_list(listname, query_text, device)
    VALUES ('tbl_inp_conduit', 'SELECT dscenario_id, elev, ymax, conduit_type, curve_id, a1, 
       a2, a0, fevap, sh, hc, imd, y0, ysur, apond FROM v_edit_inp_dscenario_conduit WHERE node_id IS NOT NULL', 4); -- SELECT dscenario_id, demand, pattern_id, emitter_coeff, initial_quality, source_type, source_quality, source_pattern FROM ve_inp_dscenario_junction WHERE node_id IS NOT NULL

/*INSERT INTO config_form_fields (formname, formtype, tabname,  columnname, layoutname, layoutorder,  widgettype, tooltip, ismandatory, isparent, iseditable, isautoupdate, stylesheet, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'manage_demands', 'lyt_epa_1', 1, 'button', 'Manage demands', false, false, true, false, '{"icon":"111b", "size":"24x24"}', '{"saveValue":false, "filterSign":"="}', NULL, false, '');
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'hspacer_lyt_epa', 'lyt_epa_1', 10, 'hspacer', false, false, true, false);*/


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'barrels', 'lyt_epa_data_1', 1, 'string', 'text', 'barrels:', 'barrels', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'culvert', 'lyt_epa_data_1', 2, 'string', 'text', 'culvert:', 'culvert', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'kentry', 'lyt_epa_data_1', 3, 'string', 'text', 'kentry:', 'kentry', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'kexit', 'lyt_epa_data_1', 4, 'string', 'text', 'kexit:', 'kexit', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'kavg', 'lyt_epa_data_2', 1, 'string', 'text', 'kavg:', 'kavg', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'flap', 'lyt_epa_data_2', 2, 'string', 'text', 'flap:', 'flap', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'q0', 'lyt_epa_data_2', 3, 'string', 'text', 'q0:', 'q0', false, false, true, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'qmax', 'lyt_epa_data_2', 4, 'string', 'text', 'qmax:', 'qmax', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'seepage', 'lyt_epa_data_2', 5, 'string', 'text', 'seepage:', 'seepage', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'custom_n', 'lyt_epa_data_2', 6, 'string', 'text', 'custom_n:', 'custom_n', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 7, 'string', 'text', 'max_flow:', 'max_flow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_days', 'lyt_epa_data_2', 8, 'string', 'text', 'time_days:', 'time_days', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_hour', 'lyt_epa_data_2', 9, 'string', 'text', 'time_hour:', 'time_hour', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_veloc', 'lyt_epa_data_2', 9, 'string', 'text', 'max_veloc:', 'max_veloc', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'mfull_flow', 'lyt_epa_data_2', 9, 'string', 'text', 'mfull_flow:', 'mfull_flow', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'mfull_dept', 'lyt_epa_data_2', 9, 'string', 'text', 'mfull_dept:', 'mfull_dept', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_shear', 'lyt_epa_data_2', 9, 'string', 'text', 'max_shear:', 'max_shear', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_hr', 'lyt_epa_data_2', 9, 'string', 'text', 'max_hr:', 'max_hr', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_slope', 'lyt_epa_data_2', 9, 'string', 'text', 'max_slope:', 'max_slope', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'day_max', 'lyt_epa_data_2', 9, 'string', 'text', 'day_max:', 'day_max', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_max', 'lyt_epa_data_2', 9, 'string', 'text', 'time_max:', 'time_max', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'min_shear', 'lyt_epa_data_2', 9, 'string', 'text', 'min_shear:', 'min_shear', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'day_min', 'lyt_epa_data_2', 9, 'string', 'text', 'day_min:', 'day_min', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_min', 'lyt_epa_data_2', 9, 'string', 'text', 'time_min:', 'time_min', false, false, false, false, NULL,'{"saveValue": false, "filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'tbl_inp_conduit', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_conduit');
