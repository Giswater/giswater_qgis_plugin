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

INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_connection_upstream', 'SELECT * FROM v_ui_node_x_connection_upstream WHERE rid IS NOT NULL', 4, 'tab', 'list');
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_connection_downstream', 'SELECT * FROM v_ui_node_x_connection_downstream WHERE rid IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
    VALUES ('node', 'form_feature', 'connection', 'tbl_upstream', 'lyt_connection_2', 1, 'tableview', 'Upstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_upstream', 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, web_layoutorder)
    VALUES ('node', 'form_feature', 'connection', 'tbl_downstream', 'lyt_connection_3', 1, 'tableview', 'Downstream features:', false, false, false, false, false, '{"saveValue": false, "labelPosition": "top"}', '{"functionName": "open_selected_feature", "module": "info", "parameters":{"columnfind":"feature_id", "tablefind":"sys_table_id"}}', 'tbl_connection_downstream', 2);


INSERT INTO config_form_tabs(formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device)
VALUES('v_edit_gully', 'tab_epa', 'EPA inp', NULL, 'role_basic', NULL, '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste", "disabled":false},
{"actionName":"actionLink", "disabled":false},
{"actionName":"actionHelp", "disabled":false}, 
{"actionName":"actionGetArcId", "disabled":false}]'::json, 8, '{4}') ON CONFLICT (formname, tabname) DO NOTHING;

--junction
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_junction', 'SELECT dscenario_id, y0, ysur, apond, outfallparam, elev, ymax FROM v_edit_inp_dscenario_junction WHERE node_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'y0', 'lyt_epa_data_1', 1, 'string', 'text', 'y0:', 'y0', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'ysur', 'lyt_epa_data_1', 2, 'string', 'text', 'ysur:', 'ysur', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'apond', 'lyt_epa_data_1', 3, 'string', 'text', 'apond:', 'apond', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'outfallparam', 'lyt_epa_data_1', 4, 'string', 'text', 'outfallparam:', 'outfallparam', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_average', 'lyt_epa_data_2', 1, 'string', 'text', 'Average depth:', 'Average depth', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_max', 'lyt_epa_data_2', 2, 'string', 'text', 'Max depth:', 'Max depth', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_max_day', 'lyt_epa_data_2', 3, 'string', 'text', 'Max depth/day:', 'Max depth per day', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'depth_max_hour', 'lyt_epa_data_2', 4, 'string', 'text', 'Max depth/hour:', 'Max depth per hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'surcharge_hour', 'lyt_epa_data_2', 5, 'string', 'text', 'Surcharge/hour:', 'Surcharge per hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'surgarge_max_height', 'lyt_epa_data_2', 6, 'string', 'text', 'max height of surgarge:', 'Max height of surgarge', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_hour', 'lyt_epa_data_2', 7, 'string', 'text', 'Flood hour:', 'Flood hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_max_rate', 'lyt_epa_data_2', 8, 'string', 'text', 'Maximum food rate:', 'Maximum food rate', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'time_day', 'lyt_epa_data_2', 9, 'string', 'text', 'Day:', 'Day', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'time_hour', 'lyt_epa_data_2', 10, 'string', 'text', 'Hour:', 'Hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_total', 'lyt_epa_data_2', 11, 'string', 'text', 'Total flood:', 'Total flood', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'flood_max_ponded', 'lyt_epa_data_2', 12, 'string', 'text', 'Max ponded flood :', 'Max ponded flood', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_junction', 'form_feature', 'epa', 'tbl_inp_junction', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_junction');

--outfall

INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_outfall', 'SELECT dscenario_id, elev, ymax, outfall_type, stage, curve_id, timser_id, gate FROM v_edit_inp_dscenario_outfall WHERE node_id IS NOT NULL', 4, 'tab', 'list'); 

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'outfall_type', 'lyt_epa_data_1', 1, 'string', 'combo', 'Outfall type:', 'Outfall type', false, false, true, false, 'SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_outfall''','{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'stage', 'lyt_epa_data_1', 2, 'string', 'text', 'stage:', 'stage', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 3, 'string', 'combo', 'curve_id:', 'curve_id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'timser_id', 'lyt_epa_data_1', 4, 'string', 'combo', 'timser_id:', 'timser_id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'gate', 'lyt_epa_data_1', 5, 'string', 'text', 'gate:', 'gate', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'flow_freq', 'lyt_epa_data_2', 1, 'string', 'text', 'Flow frequency:', 'Flow frequency', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'avg_flow', 'lyt_epa_data_2', 2, 'string', 'text', 'Average flow:', 'Average flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 3, 'string', 'text', 'Max flow:', 'Max flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'total_vol', 'lyt_epa_data_2', 4, 'string', 'text', 'Total volume:', 'Total volume', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_outfall', 'form_feature', 'epa', 'tbl_inp_outfall', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_outfall');

--storage
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_storage', 'SELECT dscenario_id, elev, ymax, storage_type, curve_id, a1, 
       a2, a0, fevap, sh, hc, imd, y0, ysur, apond FROM v_edit_inp_dscenario_storage WHERE node_id IS NOT NULL', 4, 'tab', 'list'); 
 
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'storage_type', 'lyt_epa_data_1', 1, 'string', 'text', 'Storage type:', 'Storage type', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);     
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 2, 'string', 'combo', 'curve_id:', 'curve_id', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'a1', 'lyt_epa_data_1', 3, 'string', 'text', 'a1:', 'a1', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'a2', 'lyt_epa_data_1', 4, 'string', 'text', 'a2:', 'a2', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'a0', 'lyt_epa_data_1', 5, 'string', 'text', 'a0:', 'a0', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'fevap', 'lyt_epa_data_1', 6, 'string', 'text', 'fevap:', 'fevap', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'sh', 'lyt_epa_data_1', 7, 'string', 'text', 'sh:', 'sh', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'hc', 'lyt_epa_data_1', 8, 'string', 'text', 'hc:', 'hc', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'imd', 'lyt_epa_data_1', 9, 'string', 'text', 'imd:', 'imd', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'y0', 'lyt_epa_data_1', 10, 'string', 'text', 'y0:', 'y0', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'ysur', 'lyt_epa_data_1', 11, 'string', 'text', 'ysur:', 'ysur', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'apond', 'lyt_epa_data_1', 12, 'string', 'text', 'apond:', 'apond', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'aver_vol', 'lyt_epa_data_2', 1, 'string', 'text', 'aver_vol:', 'aver_vol', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'avg_full', 'lyt_epa_data_2', 2, 'string', 'text', 'avg_full :', 'avg_full', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'ei_loss', 'lyt_epa_data_2', 3, 'string', 'text', 'ei_loss:', 'ei_loss', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'max_vol', 'lyt_epa_data_2', 4, 'string', 'text', 'max_vol:', 'max_vol', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'max_full', 'lyt_epa_data_2', 5, 'string', 'text', 'max_full:', 'max_full', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'time_days', 'lyt_epa_data_2', 6, 'string', 'text', 'time_days:', 'time_days', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'time_hour', 'lyt_epa_data_2', 7, 'string', 'text', 'time_hour:', 'time_hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'max_out', 'lyt_epa_data_2', 8, 'string', 'text', 'max_out:', 'max_out', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_storage', 'form_feature', 'epa', 'tbl_inp_storage', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_storage');


--conduit
INSERT INTO config_form_list(listname, query_text, device, listtype, listclass)
    VALUES ('tbl_inp_conduit', 'SELECT dscenario_id, arccat_id, matcat_id, elev1, elev2, custom_n, 
       barrels, culvert, kentry, kexit, kavg, flap, q0, qmax, seepage FROM v_edit_inp_dscenario_conduit WHERE arc_id IS NOT NULL', 4, 'tab', 'list');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'barrels', 'lyt_epa_data_1', 1, 'string', 'text', 'barrels:', 'barrels', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'culvert', 'lyt_epa_data_1', 2, 'string', 'text', 'culvert:', 'culvert', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'kentry', 'lyt_epa_data_1', 3, 'string', 'text', 'kentry:', 'kentry', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'kexit', 'lyt_epa_data_1', 4, 'string', 'text', 'kexit:', 'kexit', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'kavg', 'lyt_epa_data_1', 5, 'string', 'text', 'kavg:', 'kavg', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'flap', 'lyt_epa_data_1', 6, 'string', 'text', 'flap:', 'flap', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'q0', 'lyt_epa_data_1', 7, 'string', 'text', 'q0:', 'q0', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'qmax', 'lyt_epa_data_1', 8, 'string', 'text', 'qmax:', 'qmax', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'seepage', 'lyt_epa_data_1', 9, 'string', 'text', 'seepage:', 'seepage', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'custom_n', 'lyt_epa_data_1', 10, 'string', 'text', 'custom_n:', 'custom_n', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 1, 'string', 'text', 'max_flow:', 'max_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_days', 'lyt_epa_data_2', 2, 'string', 'text', 'time_days:', 'time_days', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'time_hour', 'lyt_epa_data_2', 3, 'string', 'text', 'time_hour:', 'time_hour', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'max_veloc', 'lyt_epa_data_2', 4, 'string', 'text', 'max_veloc:', 'max_veloc', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'mfull_flow', 'lyt_epa_data_2', 5, 'string', 'text', 'mfull_flow:', 'mfull_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'mfull_dept', 'lyt_epa_data_2', 6, 'string', 'text', 'mfull_dept:', 'mfull_dept', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype, ismandatory, isparent, iseditable, isautoupdate, widgetcontrols, widgetfunction, isfilter, linkedobject)
    VALUES ('ve_epa_conduit', 'form_feature', 'epa', 'tbl_inp_conduit', 'lyt_epa_3', 1, 'tableview', false, false, false, false, '{"saveValue": false}', NULL, false, 'tbl_inp_conduit');

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_storage' AND a.columnname='curve_id' AND c.columnname='curve_id' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_storage' AND a.columnname='storage_type' AND c.columnname='storage_type' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_outfall' AND a.columnname='timser_id' AND c.columnname='timser_id' AND c.formname ILIKE 've_epa%';

UPDATE config_form_fields c SET widgettype=a.widgettype, dv_querytext=a.dv_querytext, dv_orderby_id=a.dv_orderby_id, dv_isnullvalue=true,
widgetcontrols=a.widgetcontrols FROM config_form_fields a
WHERE a.formname='v_edit_inp_dscenario_outfall' AND a.columnname='outfall_type' AND c.columnname='outfall_type' AND c.formname ILIKE 've_epa%';

UPDATE link l SET epa_type = c.epa_type, is_operative = v.is_operative 
FROM gully c
JOIN value_state_type v ON v.id = c.state_type WHERE l.feature_id = c.gully_id;

UPDATE link l SET is_operative = v.is_operative 
FROM connec c
JOIN value_state_type v ON v.id = c.state_type WHERE l.feature_id = c.connec_id;

UPDATE config_form_fields SET iseditable= true WHERE columnname='order_id' AND formname='v_edit_inp_inflows';

UPDATE sys_param_user SET dv_isnullvalue= true WHERE id='inp_options_dwfscenario';

INSERT INTO config_function(id, function_name, "style", layermanager, actions)
VALUES(2928, 'gw_fct_getstylemapzones', '{"DRAINZONE":{"mode":"Random", "column":"drainzone_id"}}'::json, NULL, NULL);

UPDATE config_toolbox SET
inputparams = '[{"widgetname":"target", "label":"Target:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT distinct(hydrology_id) as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters", "layoutorder":1, "selectedId":""},
  {"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user UNION SELECT -999,''ALL VISIBLE SECTORS'' ORDER BY 1 DESC", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userSector"},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["DELETE & COPY", "KEEP & COPY", "DELETE ONLY"], "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"DELETE-ONLY"},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT distinct(hydrology_id) as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters", "layoutorder":4, "selectedId":"$userHydrology"}  ]'::json WHERE
id = 3100;


INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3234, 'gw_fct_settimeseries', 'utils', 'function', 'varchar', 'json', 'Set timeseries values for any objects (1st version for raingage)', 'role_epa', NULL, 'core')
ON CONFLICT (id) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'bottom_mat', 'lyt_data_1', max(layoutorder)+1, 
'string', 'text', 'bottom_mat', 'bottom_mat',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'CONDUIT' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'bottom_mat', 'lyt_data_1', max(layoutorder)+1, 
'string', 'text', 'bottom_mat', 'bottom_mat',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'CHAMBER' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'bottom_mat', 'lyt_data_1', max(layoutorder)+1, 
'string', 'text', 'bottom_mat', 'bottom_mat',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'MANHOLE' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, 
datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate,  hidden)
SELECT distinct child_layer, formtype, tabname, 'slope', 'lyt_data_2', max(layoutorder)+1, 
'string', 'text', 'slope', 'slope',  false, false, true, false, true
FROM cat_feature
join config_form_fields on formname = child_layer
WHERE  system_id ilike 'CHAMBER' group by child_layer,formname,formtype, tabname ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'adate', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Adate', 'adate', NULL, false, false, true, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully')
AND columnname='observ'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'adescript', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Adescript', 'adescript', NULL, false, false, true, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully')
AND columnname='observ'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'siphon_type', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Siphon_type', 'siphon_type', NULL, false, false, true, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_gully', 've_gully') AND columnname='observ'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'odorflap', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Odorflap', 'odorflap', NULL, false, false, true, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_gully', 've_gully') AND columnname='observ'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields 
where layoutname ='lyt_data_2' and formname  in ('v_edit_arc', 've_arc') group by formname)
SELECT c.formname, formtype, tabname, 'visitability', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Visitability', 'visitability', NULL, false, false, false, false, true
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_arc', 've_arc') AND columnname='inventory'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET iseditable = true WHERE  formname ilike 'v_edit_inp_dscenario%' and columnname ='node_id';


    
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'curve_id', 'lyt_epa_data_1', 1, 'string', 'combo', 'curve_id:', 'curve_id', false, false, true, false, 'SELECT id, id AS idval FROM inp_curve 
WHERE id IS NOT NULL','{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'status', 'lyt_epa_data_1', 2, 'string', 'combo', 'status:', 'status', false, false, true, false, 'SELECT  id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status''','{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'startup', 'lyt_epa_data_1', 3, 'double', 'text', 'startup:', 'startup', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'shutoff', 'lyt_epa_data_1', 4, 'double', 'text', 'shutoff:', 'shutoff', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'percent', 'lyt_epa_data_2', 1, 'string', 'text', 'percent:', 'percent', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'num_startup', 'lyt_epa_data_2', 2, 'string', 'text', 'num_startup :', 'num_startup', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'min_flow', 'lyt_epa_data_2', 3, 'string', 'text', 'min_flow:', 'min_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'avg_flow', 'lyt_epa_data_2', 4, 'string', 'text', 'avg_flow:', 'avg_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'max_flow', 'lyt_epa_data_2', 5, 'string', 'text', 'max_flow:', 'max_flow', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'vol_ltr', 'lyt_epa_data_2', 6, 'string', 'text', 'vol_ltr:', 'vol_ltr', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'powus_kwh', 'lyt_epa_data_2', 7, 'string', 'text', 'powus_kwh:', 'powus_kwh', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'timoff_min', 'lyt_epa_data_2', 8, 'string', 'text', 'timoff_min:', 'timoff_min', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
    VALUES ('ve_epa_pump', 'form_feature', 'epa', 'timoff_max', 'lyt_epa_data_2', 9, 'string', 'text', 'timoff_max:', 'timoff_max', false, false, false, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_netgully', formtype, tabname, columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='v_edit_inp_netgully' and columnname in ('y0', 'ysur', 'apond', 'outlet_type', 'custom_width', 'custom_length', 'custom_depth',
'method', 'weir_cd', 'orifice_cd', 'custom_a_param', 'custom_b_param', 'efficiency') 
order by columnname ;

UPDATE config_form_fields SET  layoutorder = ordinal_position -1 
FROM  information_schema.columns
WHERE table_schema = 'SCHEMA_NAME'
AND table_name   = 've_epa_netgully' AND table_name=formname AND columnname=column_name  ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_orifice', formtype, tabname, columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, TRUE, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='v_edit_inp_orifice' and columnname in ('ori_type', 'offsetval', 'cd', 'orate', 'flap', 'shape', 'geom1',
'geom2', 'geom3', 'geom4', 'close_time') 
order by columnname ;

UPDATE config_form_fields SET  layoutorder = ordinal_position -1 
FROM  information_schema.columns
WHERE table_schema = 'SCHEMA_NAME'
AND table_name   = 've_epa_orifice' AND table_name=formname AND columnname=column_name ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_orifice', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='ve_epa_conduit' and layoutname = 'lyt_epa_data_2' order by columnname ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_weir', formtype, tabname, columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, TRUE, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='v_edit_inp_weir' and columnname in ('weir_type', 'offsetval', 'cd', 'ec', 'cd2','flap',  'geom1',
'geom2', 'geom3', 'geom4', 'surcharge', 'road_width', 'road_surf', 'coef_curve') 
order by columnname ;

UPDATE config_form_fields SET  layoutorder = ordinal_position -1 
FROM  information_schema.columns
WHERE table_schema = 'SCHEMA_NAME'
AND table_name   = 've_epa_weir' AND table_name=formname AND columnname=column_name ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_weir', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='ve_epa_conduit' and layoutname = 'lyt_epa_data_2' order by columnname ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_outlet', formtype, tabname, columnname, 'lyt_epa_data_1', layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, TRUE, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='v_edit_inp_outlet' and columnname in ('outlet_type', 'offsetval', 'curve_id', 'cd1', 'cd2','flap') 
order by columnname ;

UPDATE config_form_fields SET  layoutorder = ordinal_position -1 
FROM  information_schema.columns
WHERE table_schema = 'SCHEMA_NAME'
AND table_name   = 've_epa_outlet' AND table_name=formname AND columnname=column_name ;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 've_epa_outlet', formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, 
ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, 
dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields
where formname ='ve_epa_conduit' and layoutname = 'lyt_epa_data_2' order by columnname ;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
VALUES ('ve_epa_virtual', 'form_feature', 'epa', 'fusion_node', 'lyt_epa_data_1', 1, 'string', 'typeahead', 'fusion_node:', 'fusion_node', false, false, true, false, 'SELECT node_id as id, node_id as idval FROM v_edit_node WHERE 1=1 ','{"filterSign":"ILIKE"}', NULL, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, widgetcontrols, widgetfunction, isfilter)
VALUES ('ve_epa_virtual', 'form_feature', 'epa', 'add_length', 'lyt_epa_data_1', 2, 'boolean', 'check', 'add_length:', 'add_length', false, false, true, false, NULL,'{"filterSign":"ILIKE"}', NULL, false);

UPDATE sys_table SET context = NULL, orderby=NULL WHERE id='v_edit_inp_divider';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname,datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_inp_curve', 'form_feature', 'main','active','boolean','check','active',false, false, true, false, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_inp_pattern', 'form_feature', 'main','active','boolean','check','active',false, false, true, false, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname,datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('v_edit_inp_timeseries', 'form_feature', 'main','active','boolean','check','active',false, false, true, false, false);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, datatype, widgettype, label, ismandatory, isparent, iseditable, isautoupdate, hidden)
VALUES ('inp_lid', 'form_feature', 'main','active','boolean','check','active',false, false, true, false, false);


-- search
INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) 
    VALUES('basic_search_v2_network_gully', '{"sys_display_name":"concat(gully_id, '' : '', gratecat_id)", "sys_tablename":"v_edit_gully", "sys_pk":"gully_id", "sys_fct":"gw_fct_getinfofromid", "sys_filter":""}', 'Search configuration parameteres', 'Gully:', NULL, NULL, false, NULL, 'utils', NULL, NULL, 'string', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

DELETE FROM config_toolbox where id IN (SELECT id FROM sys_function WHERE project_type  ='ws');


-- update sys_table registers according current relations
/*
SELECT * FROM information_schema.tables WHERE table_schema='SCHEMA_NAME' and table_name NOT IN (SELECT id FROM sys_table);
SELECT * FROM sys_table WHERE id NOT IN (SELECT table_name FROM information_schema.tables WHERE table_schema='SCHEMA_NAME');
*/

DELETE FROM sys_table where id not in (SELECT table_name FROM information_schema.tables WHERE table_schema='SCHEMA_NAME');

INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ext_rtc_scada_x_data', 'Data for external data of scada', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('v_anl_graphanalytics_mapzones', 'View for graphanalytics', 'role_om', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_gully', 'Editable view for epa gully', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_junction', 'Editable view for epa junction', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_conduit', 'Editable view for epa counduit', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_outfall', 'Editable view for epa outfall', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_storage', 'Editable view for epa storage', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_pump', 'Editable view for epa pump', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_virtual', 'Editable view for epa virtual', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_netgully', 'Editable view for epa netgully', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_weir', 'Editable view for epa weir', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_orifice', 'Editable view for epa orifice', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_table(id, descript, sys_role, source) VALUES ('ve_epa_outlet', 'Editable view for epa outlet', 'role_epa', 'core') ON CONFLICT (id) DO NOTHING;


-- update sys_function registers according current relations
/*
SELECT routine_name FROM information_schema.routines WHERE routine_type='FUNCTION' AND specific_schema='SCHEMA_NAME' and routine_name not in (select function_name FROM sys_function);
select project_type, id, function_name FROM sys_function WHERE function_name NOT IN (SELECT routine_name FROM information_schema.routines WHERE routine_type='FUNCTION' AND specific_schema='SCHEMA_NAME');
*/

DELETE FROM config_toolbox WHERE id in (2302, 2706, 2712, 2790);

DELETE FROM sys_function WHERE project_type ='ws';

INSERT INTO sys_function (id, function_name, project_type, function_type) VALUES (3240, 'gw_fct_getvisit_manager', 'utils', 'function')ON CONFLICT (id) DO NOTHING;

-- harmonize tabs 24/05/2023
ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

UPDATE config_form_fields set tabname = 'tab_data' where tabname = 'data';
UPDATE config_form_fields set tabname = 'tab_documents' where tabname = 'document';
UPDATE config_form_fields set tabname = 'tab_hydrometer' where tabname = 'hydrometer';
UPDATE config_form_fields set tabname = 'tab_elements' where tabname = 'element';
UPDATE config_form_fields set tabname = 'tab_mincut' where tabname = 'mincut';
UPDATE config_form_fields set tabname = 'tab_epa' where tabname = 'epa';
UPDATE config_form_fields set tabname = 'tab_hydrometer_val' where tabname = 'hydro_val';
UPDATE config_form_fields set tabname = 'tab_none' where tabname = 'main';
UPDATE config_form_fields set tabname = 'tab_visit' where tabname = 'visit';
UPDATE config_form_fields set tabname = 'tab_event' where tabname = 'event';
UPDATE config_form_fields set tabname = 'tab_relation' where tabname = 'relation';

ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;


INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(495, 'Set optimum outlet', 'ud', NULL, 'core', true, 'Function process', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type) 
VALUES (3242, 'gw_fct_epa_setoptimumoutlet', 'ud', 'function')ON CONFLICT (id) DO NOTHING;

-- 2023/06/07
-- FLWREG LISTS
-- orifice
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_flwreg_orifice', 'SELECT nodarc_id, to_arc, order_id, flwreg_length, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4, close_time FROM inp_flwreg_orifice WHERE id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_dscenario_flwreg_orifice', 'SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.ori_type, d.offsetval, d.cd, d.orate, d.flap, d.shape, d.geom1, d.geom2, d.geom3, d.geom4, d.close_time 
FROM inp_dscenario_flwreg_orifice d
JOIN inp_flwreg_orifice f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
-- outlet
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_flwreg_outlet', 'SELECT nodarc_id, to_arc, order_id, flwreg_length, outlet_type, offsetval, curve_id, cd1, cd2, flap FROM inp_flwreg_outlet WHERE id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_dscenario_flwreg_outlet', 'SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.outlet_type, d.offsetval, d.curve_id, d.cd1, d.cd2, d.flap 
FROM inp_dscenario_flwreg_outlet d
JOIN inp_flwreg_outlet f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
-- pump
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_flwreg_pump', 'SELECT nodarc_id, to_arc, order_id, flwreg_length, curve_id, status, startup, shutoff FROM inp_flwreg_pump WHERE id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_dscenario_flwreg_pump', 'SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.curve_id, d.status, d.startup, d.shutoff 
FROM inp_dscenario_flwreg_pump d
JOIN inp_flwreg_pump f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
-- weir
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_flwreg_weir', 'SELECT nodarc_id, to_arc, order_id, flwreg_length, weir_type, offsetval, cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve FROM inp_flwreg_weir WHERE id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam)
 VALUES('inp_dscenario_flwreg_weir', 'SELECT d.dscenario_id, d.nodarc_id, f.node_id, d.weir_type, d.offsetval, d.cd, d.ec, d.cd2, d.flap, d.geom1, d.geom2, d.geom3, d.geom4, d.surcharge, d.road_width, d.road_surf, d.coef_curve 
FROM inp_dscenario_flwreg_weir d
JOIN inp_flwreg_weir f USING (nodarc_id)
WHERE dscenario_id IS NOT NULL AND nodarc_id IS NOT NULL', 4, 'tab', 'list', NULL, NULL);

-- epa actions
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) 
VALUES('ve_epa_junction', 'tab_epa', 'EPA', NULL, 'role_basic', NULL, 
'[{"actionName":"actionEdit","actionTooltip":"Edit","disabled":false},
{"actionName":"actionZoom","actionTooltip":"Zoom In","disabled":false},
{"actionName":"actionCentered","actionTooltip":"Center","disabled":false},
{"actionName":"actionZoomOut","actionTooltip":"Zoom Out","disabled":false},
{"actionName":"actionCatalog","actionTooltip":"Change Catalog","disabled":false},
{"actionName":"actionWorkcat","actionTooltip":"Add Workcat","disabled":false},
{"actionName":"actionCopyPaste","actionTooltip":"Copy Paste","disabled":false},
{"actionName":"actionLink","actionTooltip":"Open Link","disabled":false},
{"actionName":"actionHelp","actionTooltip":"Help","disabled":false},
{"actionName":"actionInterpolate", "actionTooltip":"Interpolate", "disabled":false},
{"actionName":"actionSetToArc","actionTooltip":"Set to_arc","disabled":false},
{"actionName":"actionGetArcId","actionTooltip":"Set arc_id","disabled":false},
{"actionName":"actionOrifice","actionTooltip":"Orifice","disabled":false},
{"actionName":"actionOutlet","actionTooltip":"Outlet","disabled":false},
{"actionName":"actionPump","actionTooltip":"Pump","disabled":false},
{"actionName":"actionWeir","actionTooltip":"Weir","disabled":false},
{"actionName":"actionDemand","actionTooltip":"DWF","disabled":false}]'::json, 2, '{4}');
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) 
VALUES('ve_epa_storage', 'tab_epa', 'EPA', NULL, 'role_basic', NULL, 
'[{"actionName":"actionEdit","actionTooltip":"Edit","disabled":false},
{"actionName":"actionZoom","actionTooltip":"Zoom In","disabled":false},
{"actionName":"actionCentered","actionTooltip":"Center","disabled":false},
{"actionName":"actionZoomOut","actionTooltip":"Zoom Out","disabled":false},
{"actionName":"actionCatalog","actionTooltip":"Change Catalog","disabled":false},
{"actionName":"actionWorkcat","actionTooltip":"Add Workcat","disabled":false},
{"actionName":"actionCopyPaste","actionTooltip":"Copy Paste","disabled":false},
{"actionName":"actionInterpolate", "actionTooltip":"Interpolate", "disabled":false},
{"actionName":"actionLink","actionTooltip":"Open Link","disabled":false},
{"actionName":"actionHelp","actionTooltip":"Help","disabled":false},
{"actionName":"actionSetToArc","actionTooltip":"Set to_arc","disabled":false},
{"actionName":"actionGetArcId","actionTooltip":"Set arc_id","disabled":false},
{"actionName":"actionOrifice","actionTooltip":"Orifice","disabled":false},
{"actionName":"actionOutlet","actionTooltip":"Outlet","disabled":false},
{"actionName":"actionPump","actionTooltip":"Pump","disabled":false},
{"actionName":"actionWeir","actionTooltip":"Weir","disabled":false}]'::json, 2, '{4}');

-- add node_id widget
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutorder,"datatype",widgettype,"label",ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_inp_dscenario_flwreg_orifice','form_feature','tab_none','node_id',3,'string','text','node_id',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutorder,"datatype",widgettype,"label",ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_inp_dscenario_flwreg_outlet','form_feature','tab_none','node_id',3,'string','text','node_id',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutorder,"datatype",widgettype,"label",ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_inp_dscenario_flwreg_pump','form_feature','tab_none','node_id',3,'string','text','node_id',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutorder,"datatype",widgettype,"label",ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('v_edit_inp_dscenario_flwreg_weir','form_feature','tab_none','node_id',3,'string','text','node_id',false,false,false,false,'{"setMultiline":false}'::json,false);

-- set layoutorder for flwreg widgets
UPDATE config_form_fields 
SET layoutorder = (SELECT attnum FROM pg_attribute WHERE attrelid = formname::regclass AND attname = columnname and attnum > 0 AND NOT attisdropped ORDER BY attnum LIMIT 1)
WHERE formname like 'v_edit_inp%flwreg%';
-- make widgets not editable
UPDATE config_form_fields 
SET iseditable = false 
WHERE formname like 'v_edit_inp%flwreg%' and columnname IN ('nodarc_id', 'node_id');

-- insert flwreg tables into config_form_tableview
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, addparam)
SELECT 'epa form', 'ud', v.table_name, c.column_name, c.ordinal_position, true, NULL
FROM information_schema.tables v
JOIN information_schema.columns c ON v.table_schema = c.table_schema AND v.table_name = c.table_name
WHERE v.table_schema = 'SCHEMA_NAME'
  AND v.table_name LIKE 'inp%flwreg%'
ORDER BY v.table_name, c.ordinal_position;

-- disable columns
UPDATE config_form_tableview SET addparam = '{"editable": false}' WHERE objectname like 'inp%flwreg%' AND columnname IN ('id', 'node_id', 'nodarc_id', 'dscenario_id');

-- config_form_fields
-- hide order_id in dscenarios
UPDATE config_form_fields
	SET hidden=true
	WHERE formname like 'v_edit_inp_dscenario_flwreg%' AND columnname='order_id';
-- nodarc_id combos
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true,dv_querytext_filterc='AND node_id',dv_parent_id='node_id',dv_querytext='SELECT nodarc_id as id, nodarc_id as idval FROM inp_flwreg_orifice WHERE nodarc_id IS NOT NULL',widgettype='combo',dv_isnullvalue=false,dv_orderby_id=true
	WHERE formname='v_edit_inp_dscenario_flwreg_orifice' AND columnname='nodarc_id';
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true,dv_querytext_filterc='AND node_id',dv_parent_id='node_id',dv_querytext='SELECT nodarc_id as id, nodarc_id as idval FROM inp_flwreg_outlet WHERE nodarc_id IS NOT NULL',widgettype='combo',dv_isnullvalue=false,dv_orderby_id=true
	WHERE formname='v_edit_inp_dscenario_flwreg_outlet' AND columnname='nodarc_id';
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true,dv_querytext_filterc='AND node_id',dv_parent_id='node_id',dv_querytext='SELECT nodarc_id as id, nodarc_id as idval FROM inp_flwreg_pump WHERE nodarc_id IS NOT NULL',widgettype='combo',dv_isnullvalue=false,dv_orderby_id=true
	WHERE formname='v_edit_inp_dscenario_flwreg_pump' AND columnname='nodarc_id';
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true,dv_querytext_filterc='AND node_id',dv_parent_id='node_id',dv_querytext='SELECT nodarc_id as id, nodarc_id as idval FROM inp_flwreg_weir WHERE nodarc_id IS NOT NULL',widgettype='combo',dv_isnullvalue=false,dv_orderby_id=true
	WHERE formname='v_edit_inp_dscenario_flwreg_weir' AND columnname='nodarc_id';
