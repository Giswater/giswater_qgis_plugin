/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
-----------------------
-- config api values
-----------------------

INSERT INTO config_api_form VALUES (70, 've_gully', 'ud', '[{"actionName":"actionEdit"},{"actionName":"actionCopyPaste"},{"actionName":"actionCatalog"},{"actionName":"actionWorkcat"},{"actionName":"actionRotation"},{"actionName":"actionZoomIn"},{"actionName":"actionZoomOut"},{"actionName":"actionCentered"},{"actionName":"actionLink"},{"actionName":"actionHelp"}]', '{"activeLayer":"ve_gully", "visibleLayer":[]}');


INSERT INTO config_api_form_tabs VALUES (600,'ve_gully','tab_data','Data','Data','role_basic','data',NULL,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionCopyPaste", "actionFunction":"", "actionTooltip":"actionCopyPaste", "disabled":false},{"actionName":"actionCatalog", "actionFunction":"", "actionTooltip":"actionCatalog", "disabled":false},{"actionName":"actionWorkcat", "actionFunction":"", "actionTooltip":"actionWorkcat", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]');
INSERT INTO config_api_form_tabs VALUES (610,'ve_gully','tab_elements','Elem','Elements','role_basic','Elements',NULL,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]');
INSERT INTO config_api_form_tabs VALUES (620,'ve_gully','tab_visit','Visit','Visit','role_basic','visit',NULL,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]');
INSERT INTO config_api_form_tabs VALUES (630,'ve_gully','tab_documents','Doc','Doc','role_basic','doc',NULL,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"actionEdit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"actionZoomIn", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"actionZoomOut", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"actionCentered", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"actionLink", "disabled":false}]');

INSERT INTO config_api_layer VALUES ('v_edit_arc', true, 'vp_basic_arc', false, NULL, 'custom feature', 'Arc', 2, NULL, NULL, 'vp_epa_arc');
INSERT INTO config_api_layer VALUES ('v_edit_connec', true, 'vp_basic_connec', false, NULL, 'custom feature', 'Connec', 3, NULL, NULL, NULL);
INSERT INTO config_api_layer VALUES ('v_edit_cad_auxpoint', true, 'v_edit_cad_auxpoint_parent', true, NULL, 'GENERIC', 'Basic Info', 5, NULL, NULL, NULL);
INSERT INTO config_api_layer VALUES ('v_edit_node', true, 'vp_basic_node', false, NULL, 'custom feature', 'Node', 1, NULL, NULL, 'vp_epa_node');
INSERT INTO config_api_layer VALUES ('v_edit_gully', true, 'vp_basic_gully', false, NULL, 'custom feature', 'Gully', 4, NULL, NULL, NULL);
