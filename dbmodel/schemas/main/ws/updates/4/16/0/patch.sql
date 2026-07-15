/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES
('scada_graph', 'scada_graph', 'tab_none', 'object_1', 'lyt_scada_node_1', 0, 'integer', 'text', 'Node 1:', 'object_1', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'btn_pick_object_1', 'lyt_scada_node_1', 1, NULL, 'button', NULL, 'Pick node 1', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon": "137"}'::json, NULL, '{"functionName": "pick_node", "module": "scada_graph", "parameters": {"target": "object_1"}}'::json, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'object_2', 'lyt_scada_node_2', 0, 'integer', 'text', 'Node 2:', 'object_2', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'btn_pick_object_2', 'lyt_scada_node_2', 1, NULL, 'button', NULL, 'Pick node 2', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon": "137"}'::json, NULL, '{"functionName": "pick_node", "module": "scada_graph", "parameters": {"target": "object_2"}}'::json, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'btn_accept', 'lyt_buttons', 1, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Accept"}'::json, '{"functionName": "accept", "module": "scada_graph"}'::json, NULL, false, 0),
('scada_graph', 'scada_graph', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Close"}'::json, '{"functionName": "close", "module": "scada_graph"}'::json, NULL, false, 0);
