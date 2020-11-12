/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Deprecated sequences
-- todo: insert all deprecated sequences on audit_cat_sequence

-- Deprecated tables and views
-- todo: UPDATE audit_cat_table SET isdeprecated=TRUE where id='config';

-- Deprecated functions
--todo: UPDATE audit_cat_functions SET isdeprecated=TRUE where id='config';


INSERT INTO config_param_system VALUES (1000,'api_search_muni','{"sys_table_id":"ext_municipality", "sys_id_field":"muni_id", "sys_search_field":"name", "sys_geom_field":"the_geom"}',NULL, 'api_search_adress') ON CONFLICT (parameter) DO NOTHING;

-----------------------
-- config_param_system
-----------------------
-- network 
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby" :"1", "feature_type":"arc_id"}' WHERE parameter='api_search_arc';
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2", "feature_type":"node_id"}' WHERE parameter='api_search_node';
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Escomeses", "cat_field":"connecat_id", "orderby":"3", "feature_type":"connec_id"}' WHERE parameter='api_search_connec';
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5", "feature_type":"element_id"}' WHERE parameter='api_search_element';


-- psector
UPDATE config_param_system SET value='{"sys_table_id":"v_edit_plan_psector","WARNING":"sys_table_id only web, python is hardcoded: v_edit_plan_psector as self.plan_om =''plan''", "sys_id_field":"psector_id", "sys_search_field":"name", "sys_parent_field":"expl_id", "sys_geom_field":"the_geom"}'
WHERE parameter='api_search_psector';

UPDATE config_param_system SET value='{"id":"EUR", "descript":"EURO", "symbol":"€"}' WHERE parameter='sys_currency';


-----------------------
-- audit_cat_function
-----------------------
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE function_name='gw_trg_edit_man_arc';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE function_name='gw_trg_edit_man_node';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE function_name='gw_trg_edit_man_connec';
UPDATE audit_cat_function SET isdeprecated=TRUE WHERE function_name='gw_trg_edit_man_gully';

-----------------------
-- sys_csv2pg_cat
-----------------------
INSERT INTO sys_csv2pg_cat (id, name, name_i18n, sys_role, functionname, isdeprecated) VALUES (19, 'Exmport ui', 'Export ui', 'role_admin', 'gw_fct_export_ui_xml', FALSE);
INSERT INTO sys_csv2pg_cat (id, name, name_i18n, sys_role, functionname, isdeprecated) VALUES (20, 'Import ui', 'Import ui', 'role_admin', 'gw_fct_import_ui_xml', FALSE);


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

INSERT INTO config_api_form VALUES (40, 'v_edit_node', 'utils', '[{"actionName":"actionEdit"},{"actionName":"actionCopyPaste"},{"actionName":"actionCatalog"},{"actionName":"actionWorkcat"},{"actionName":"actionRotation"},{"actionName":"actionZoomIn"},{"actionName":"actionZoomOut"},{"actionName":"actionCentered"},{"actionName":"actionLink"},{"actionName":"actionHelp"}]', '{"activeLayer":"ve_node", "visibleLayer":[]}') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_api_form VALUES (50, 'v_edit_arc', 'utils', '[{"actionName":"actionEdit"},{"actionName":"actionZoom"},{"actionName":"actionCentered"},{"actionName":"actionZoomOut"},{"actionName":"actionCatalog"},{"actionName":"actionWorkcat"},{"actionName":"actionCopyPaste"},{"actionName":"actionSection"},{"actionName":"actionLink"},{"actionName":"actionHelp"}]', '{"activeLayer":"", "visibleLayer":[]}') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_api_form VALUES (60, 'v_edit_connec', 'utils', '[{"actionName":"actionEdit"},{"actionName":"actionCopyPaste"},{"actionName":"actionCatalog"},{"actionName":"actionWorkcat"},{"actionName":"actionRotation"},{"actionName":"actionZoomIn"},{"actionName":"actionZoomOut"},{"actionName":"actionCentered"},{"actionName":"actionLink"},{"actionName":"actionHelp"}]', '{"activeLayer":"ve_connec", "visibleLayer":[]}') ON CONFLICT (id) DO NOTHING;



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


INSERT INTO config_api_form_tabs VALUES (567, 've_arc', 'tab_data', 'Data', 'Data', 'role_basic', 'Dades',NULL, '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]', 9) ON CONFLICT (id) DO NOTHING;
INSERT INTO config_api_form_tabs VALUES (568, 've_node', 'tab_data', 'Data', 'Data', 'role_basic', 'Dades',NULL, '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]', 9) ON CONFLICT (id) DO NOTHING;
INSERT INTO config_api_form_tabs VALUES (569, 've_connec', 'tab_data', 'Data', 'Data', 'role_basic', 'Dades',NULL, '[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]', 9) ON CONFLICT (id) DO NOTHING;


-- 24/05/2019

UPDATE config_param_system SET value = '{"sys_table_id":"exploitation", "sys_id_field":"expl_id", "sys_search_field":"name", "sys_geom_field":"the_geom", "alias":"Explotation"}' WHERE parameter = 'api_search_exploitation';
