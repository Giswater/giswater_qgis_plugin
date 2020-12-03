/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_client_forms(location_type, project_type, table_id, column_id, column_index, status) VALUES ('node form', 'ud', 'v_ui_node_x_connection_upstream', 'node_id', 2, FALSE);
INSERT INTO config_client_forms(location_type, project_type, table_id, column_id, column_index, status) VALUES ('node form', 'ud', 'v_ui_node_x_connection_upstream', 'x', 14, FALSE);
INSERT INTO config_client_forms(location_type, project_type, table_id, column_id, column_index, status) VALUES ('node form', 'ud', 'v_ui_node_x_connection_upstream', 'y', 15, FALSE);
INSERT INTO config_client_forms(location_type, project_type, table_id, column_id, column_index, status) VALUES ('node form', 'ud', 'v_ui_node_x_connection_upstream', 'sys_table_id', 18, FALSE);

INSERT INTO config_client_forms(location_type, project_type, table_id, column_id, column_index, status) VALUES ('node form', 'ud', 'v_ui_node_x_connection_downstream', 'node_id', 2, FALSE);
INSERT INTO config_client_forms(location_type, project_type, table_id, column_id, column_index, status) VALUES ('node form', 'ud', 'v_ui_node_x_connection_downstream', 'x', 14, FALSE);
INSERT INTO config_client_forms(location_type, project_type, table_id, column_id, column_index, status) VALUES ('node form', 'ud', 'v_ui_node_x_connection_downstream', 'y', 15, FALSE);
INSERT INTO config_client_forms(location_type, project_type, table_id, column_id, column_index, status) VALUES ('node form', 'ud', 'v_ui_node_x_connection_downstream', 'sys_table_id', 18, FALSE);


UPDATE config_api_form_tabs SET tabactions= '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", 
"actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", 
"actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", 
"actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", 
"actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", 
"actionTooltip":"Help",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false}]'
WHERE formname ='v_edit_connec' AND tabname = 'tab_data';

UPDATE config_api_form_tabs SET tabactions= '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", 
"actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", 
"actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", 
"actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", 
"actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", 
"actionTooltip":"Help",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false}]'
WHERE formname ='v_edit_gully' AND tabname = 'tab_data';