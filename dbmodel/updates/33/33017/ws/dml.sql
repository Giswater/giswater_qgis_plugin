/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_api_form_tabs SET tabactions= '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}, {"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false}]'
WHERE formname ='v_edit_connec' AND tabname = 'tab_data';

UPDATE config_api_form_tabs SET tabactions= '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}, {"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}]'
WHERE formname ='v_edit_node' AND tabname = 'tab_data';
