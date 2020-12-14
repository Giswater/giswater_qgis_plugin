/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/25
UPDATE config_fprocess SET target = 'Routing Time Step' WHERE target = 'FRouting Time Step';

-- 2020/12/03
UPDATE cat_grate SET active = TRUE WHERE active IS NULL;
UPDATE cat_node_shape SET active = TRUE WHERE active IS NULL;

UPDATE inp_typevalue SET idval = 'RECT_CLOSED' WHERE typevalue = 'inp_value_orifice' AND idval = 'RECT-CLOSED';

UPDATE sys_param_user SET id='edit_gullyrotation_disable', descript='If true, the automatic rotation calculation on the gullys is disabled. Used for an absolute manual update of rotation field',
label='Disable automatic gully rotation:', project_type='ud' WHERE id='edit_noderotation_disable_update';

UPDATE config_form_tabs SET tabactions = '[{"disabled": false, "actionName": "actionEdit", "actionTooltip": "Edit"}, 
{"disabled": false, "actionName": "actionZoom", "actionTooltip": "Zoom In"}, 
{"disabled": false, "actionName": "actionCentered", "actionTooltip": "Center"}, 
{"disabled": false, "actionName": "actionZoomOut", "actionTooltip": "Zoom Out"}, 
{"disabled": false, "actionName": "actionCatalog", "actionTooltip": "Change Catalog"}, 
{"disabled": false, "actionName": "actionWorkcat", "actionTooltip": "Add Workcat"}, 
{"disabled": false, "actionName": "actionCopyPaste", "actionTooltip": "Copy Paste"}, 
{"disabled": false, "actionName": "actionLink", "actionTooltip": "Open Link"}, 
{"disabled": false, "actionName": "actionHelp", "actionTooltip": "Help"}]' WHERE formname ='v_edit_node';
