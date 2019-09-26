/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-----------------------
-- config api values
-----------------------



INSERT INTO config_api_cat_datatype VALUES ('nodatatype', NULL);
INSERT INTO config_api_cat_datatype VALUES ('string', NULL);
INSERT INTO config_api_cat_datatype VALUES ('double', NULL);
INSERT INTO config_api_cat_datatype VALUES ('date', NULL);
INSERT INTO config_api_cat_datatype VALUES ('boolean', NULL);
INSERT INTO config_api_cat_datatype VALUES ('integer', NULL);

INSERT INTO config_api_cat_formtemplate VALUES ('generic', NULL);
INSERT INTO config_api_cat_formtemplate VALUES ('custom_feature', NULL);
INSERT INTO config_api_cat_formtemplate VALUES ('config', NULL);
INSERT INTO config_api_cat_formtemplate VALUES ('go2epa', NULL);

INSERT INTO config_api_cat_widgettype VALUES ('label', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('hspacer', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('nowidget', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('checkbox', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('button', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('line', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('date', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('spinbox', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('areatext', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('linetext', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('combo', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('combotext', NULL);
INSERT INTO config_api_cat_widgettype VALUES ('hyperlink', NULL);


UPDATE node_type SET active = TRUE WHERE active IS FALSE;
UPDATE arc_type SET active = TRUE WHERE active IS FALSE;
UPDATE connec_type SET active = TRUE WHERE active IS FALSE;

INSERT INTO config_api_form VALUES (40, 'v_edit_node', 'utils', '[{"actionName":"actionEdit"},{"actionName":"actionCopyPaste"},{"actionName":"actionCatalog"},{"actionName":"actionWorkcat"},{"actionName":"actionRotation"},{"actionName":"actionZoomIn"},{"actionName":"actionZoomOut"},{"actionName":"actionCentered"},{"actionName":"actionLink"},{"actionName":"actionHelp"}]', '{"activeLayer":"ve_node", "visibleLayer":[]}');
INSERT INTO config_api_form VALUES (50, 'v_edit_arc', 'utils', '[{"actionName":"actionEdit"},{"actionName":"actionZoom"},{"actionName":"actionCentered"},{"actionName":"actionZoomOut"},{"actionName":"actionCatalog"},{"actionName":"actionWorkcat"},{"actionName":"actionCopyPaste"},{"actionName":"actionSection"},{"actionName":"actionLink"},{"actionName":"actionHelp"}]', '{"activeLayer":"", "visibleLayer":[]}');
INSERT INTO config_api_form VALUES (60, 'v_edit_connec', 'utils', '[{"actionName":"actionEdit"},{"actionName":"actionCopyPaste"},{"actionName":"actionCatalog"},{"actionName":"actionWorkcat"},{"actionName":"actionRotation"},{"actionName":"actionZoomIn"},{"actionName":"actionZoomOut"},{"actionName":"actionCentered"},{"actionName":"actionLink"},{"actionName":"actionHelp"}]', '{"activeLayer":"ve_connec", "visibleLayer":[]}');



UPDATE config_api_form_tabs 
SET tabtext='{"Elementos aguas arriba","Elementos aguas abajo"}', sys_role='role_basic', tooltip='Elements', 
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]'
WHERE id=206;

UPDATE config_api_form_tabs SET sys_role='role_basic', tooltip='Elements',
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=207;

UPDATE config_api_form_tabs SET sys_role='role_basic',tooltip='Elements',
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=208;

UPDATE config_api_form_tabs SET sys_role='role_basic',tooltip='Elements',
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=210;

UPDATE config_api_form_tabs SET sys_role='role_basic', tooltip='Elements',  
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=302;

UPDATE config_api_form_tabs SET sys_role='role_basic', tooltip='Elements',  
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=303;

UPDATE config_api_form_tabs SET sys_role='role_basic', tooltip='Elements',  
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=306;

UPDATE config_api_form_tabs SET sys_role='role_basic', tooltip='Elements',  
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=307;

UPDATE config_api_form_tabs SET sys_role='role_basic', tooltip='Elements',  
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false},{"actionName":"actionSection", "actionFunction":"", "actionTooltip":"actionSection", "disabled":false}]'
WHERE id=309;

UPDATE config_api_form_tabs SET sys_role='role_basic', tooltip='Elements',  
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=311;

UPDATE config_api_form_tabs SET sys_role='role_basic', tooltip='Elements',  
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=561;

UPDATE config_api_form_tabs SET  sys_role='role_basic', tooltip='Elements', 
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=562;

UPDATE config_api_form_tabs SET sys_role='role_basic', tooltip='Elements',  
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=563;

UPDATE config_api_form_tabs SET sys_role='role_basic',tooltip='Elements',   
tabactions='[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]' 
WHERE id=564;


-- 14/05/2019
UPDATE cat_feature SET parent_layer = 'v_edit_arc' WHERE feature_type = 'ARC';
UPDATE cat_feature SET parent_layer = 'v_edit_node' WHERE feature_type = 'NODE';
UPDATE cat_feature SET parent_layer = 'v_edit_connec'  WHERE feature_type = 'CONNEC';


INSERT INTO config_api_form_tabs VALUES (567, 've_arc', 'tab_data', 'Data', 'Data', 'role_basic', 'Dades',NULL, '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]', 9);
INSERT INTO config_api_form_tabs VALUES (568, 've_node', 'tab_data', 'Data', 'Data', 'role_basic', 'Dades',NULL, '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]', 9);
INSERT INTO config_api_form_tabs VALUES (569, 've_connec', 'tab_data', 'Data', 'Data', 'role_basic', 'Dades',NULL, '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]', 9);


-- 24/05/2019

UPDATE config_param_system SET value = '{"sys_table_id":"exploitation", "sys_id_field":"expl_id", "sys_search_field":"name", "sys_geom_field":"the_geom", "alias":"Explotation"}' WHERE parameter = 'api_search_exploitation';