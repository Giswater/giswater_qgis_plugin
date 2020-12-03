/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-----------------------
-- config api values
-----------------------

INSERT INTO config_api_form VALUES (70, 'v_edit_gully', 'ud', '[{"actionName":"actionEdit"},{"actionName":"actionCopyPaste"},{"actionName":"actionCatalog"},{"actionName":"actionWorkcat"},{"actionName":"actionRotation"},{"actionName":"actionZoomIn"},{"actionName":"actionZoomOut"},{"actionName":"actionCentered"},{"actionName":"actionLink"},{"actionName":"actionHelp"}]', '{"activeLayer":"v_edit_gully", "visibleLayer":[]}') ON CONFLICT (id) DO NOTHING;


UPDATE gully_type SET active = TRUE WHERE active IS FALSE;


INSERT INTO config_api_form_tabs VALUES (600,'v_edit_gully','tab_data','Data','Data','role_basic','data',NULL,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionCopyPaste", "actionFunction":"", "actionTooltip":"Copy Paste", "disabled":false},{"actionName":"actionCatalog", "actionFunction":"", "actionTooltip":"Change Catalog", "disabled":false},{"actionName":"actionWorkcat", "actionFunction":"", "actionTooltip":"Add Workcat", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false}]') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_api_form_tabs VALUES (610,'v_edit_gully','tab_elements','Elem','Elements','role_basic','Elements',NULL,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false}]') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_api_form_tabs VALUES (620,'v_edit_gully','tab_visit','Visit','Visit','role_basic','visit',NULL,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false}]') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_api_form_tabs VALUES (630,'v_edit_gully','tab_documents','Doc','Doc','role_basic','doc',NULL,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false}]') ON CONFLICT (id) DO NOTHING;

INSERT INTO config_api_layer VALUES ('v_edit_arc', true, 'vp_basic_arc', false, NULL, 'custom feature', 'Arc', 2, NULL, NULL, 'vp_epa_arc');
INSERT INTO config_api_layer VALUES ('v_edit_connec', true, 'vp_basic_connec', false, NULL, 'custom feature', 'Connec', 3, NULL, NULL, NULL);
INSERT INTO config_api_layer VALUES ('v_edit_cad_auxpoint', true, 'v_edit_cad_auxpoint_parent', true, NULL, 'GENERIC', 'Basic Info', 5, NULL, NULL, NULL);
INSERT INTO config_api_layer VALUES ('v_edit_node', true, 'vp_basic_node', false, NULL, 'custom feature', 'Node', 1, NULL, NULL, 'vp_epa_node');
INSERT INTO config_api_layer VALUES ('v_edit_gully', true, 'vp_basic_gully', false, NULL, 'custom feature', 'Gully', 4, NULL, NULL, NULL);


INSERT INTO config_api_form_tabs VALUES (640,'v_edit_node','tab_data','Data','Data','role_basic','data',NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (650,'v_edit_connec','tab_data','Data','Data','role_basic','data',NULL,NULL);
INSERT INTO config_api_form_tabs VALUES (660,'v_edit_arc','tab_data','Data','Data','role_basic','data',NULL,NULL);

INSERT INTO config_api_form_tabs VALUES (645,'v_edit_node','tab_connections','Connections','Connections','role_basic','connections',NULL,NULL);

INSERT INTO config_api_form_tabs VALUES (670,'v_edit_gully','tab_om','OM','Lista de eventos del elemento','role_basic','OM',NULL,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false},{"actionName":"actionSection", "actionFunction":"", "actionTooltip":"Show Section", "disabled":false}]');

update config_api_form_tabs SET tabactions='[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", 
"actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", 
"actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", 
"actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", 
"actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", 
"actionTooltip":"Help",  "disabled":false}]' where formname='v_edit_gully' or formname='v_edit_arc' or formname='v_edit_connec' or formname='v_edit_node';

UPDATE cat_feature SET parent_layer = 'v_edit_gully'  WHERE feature_type = 'GULLY';
