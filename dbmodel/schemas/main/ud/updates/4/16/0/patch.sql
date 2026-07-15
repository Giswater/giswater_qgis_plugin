/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM config_toolbox WHERE id = 3248;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES
('profile_interpolation', 'profile_interpolation', 'tab_none', 'type', 'lyt_profile_interp_1', 0, 'text', 'text', 'Type:', 'Interpolation type', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault_value":"FLOWEXIT"}'::json, NULL, NULL, true, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'node1', 'lyt_profile_node_1', 0, 'integer', 'text', 'Node 1:', 'Source node (FLOWEXIT)', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'btn_pick_node1', 'lyt_profile_node_1', 1, NULL, 'button', NULL, 'Pick node 1 on map', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon": "137"}'::json, NULL, '{"functionName": "pick_node", "module": "profile_interpolation", "parameters": {"target": "node1"}}'::json, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'node2', 'lyt_profile_node_2', 0, 'integer', 'text', 'Node 2:', 'Target node (FLOWEXIT)', NULL, true, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'btn_pick_node2', 'lyt_profile_node_2', 1, NULL, 'button', NULL, 'Pick node 2 on map', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon": "137"}'::json, NULL, '{"functionName": "pick_node", "module": "profile_interpolation", "parameters": {"target": "node2"}}'::json, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'profileMode', 'lyt_profile_interp_1', 1, 'text', 'combo', 'Profile mode:', 'Profile mode', NULL, false, false, true, false, false, 'SELECT ''SMOOTH'' AS id, ''SMOOTH'' AS idval UNION SELECT ''SHALLOW'', ''SHALLOW'' UNION SELECT ''DEEP'', ''DEEP'' UNION SELECT ''CENTERED'', ''CENTERED''', NULL, NULL, NULL, NULL, NULL, '{"vdefault_value":"SMOOTH"}'::json, NULL, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'minYmax', 'lyt_profile_interp_1', 2, 'numeric', 'text', 'Min Ymax:', 'Min Ymax (INIT/FLOWEXIT)', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'maxYmax', 'lyt_profile_interp_1', 3, 'numeric', 'text', 'Max Ymax:', 'Max Ymax (INIT/FLOWEXIT)', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'minSlope', 'lyt_profile_interp_1', 4, 'numeric', 'text', 'Min slope:', 'Min slope (INIT/FLOWEXIT)', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'maxSlope', 'lyt_profile_interp_1', 5, 'numeric', 'text', 'Max slope:', 'Max slope (INIT/FLOWEXIT)', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'smoothFactor', 'lyt_profile_interp_1', 6, 'numeric', 'text', 'Smooth factor:', 'Smooth factor (SMOOTH)', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'btn_run', 'lyt_buttons', 1, NULL, 'button', NULL, 'Run interpolation and show profile', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Run"}'::json, '{"functionName": "run", "module": "profile_interpolation"}'::json, NULL, false, 0),
('profile_interpolation', 'profile_interpolation', 'tab_none', 'btn_close', 'lyt_buttons', 2, NULL, 'button', NULL, 'Close', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text": "Close"}'::json, '{"functionName": "close", "module": "profile_interpolation"}'::json, NULL, false, 0);
