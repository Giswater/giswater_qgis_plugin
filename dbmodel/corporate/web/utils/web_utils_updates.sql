/*This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);


-- 3.1.103
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_layer", "column":"is_tiled", "dataType":"boolean"}}$$);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('api_config_parameters', '{"istiled_filterstate":"publish_user", "other":"other"}', 'json', 'System', 'API')
ON CONFLICT (parameter) DO NOTHING;


-- 3.1.105
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"table_type", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"iseditable", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"dv_querytext", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"dv_querytext_filterc", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"dv_parent_id", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"widgetfunction", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"isautoupdate", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"action_function", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"tooltip", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"layout_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"layout_order", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_fields", "column":"isparent", "dataType":"boolean"}}$$);


UPDATE config_web_fields SET widgetfunction='gw_fct_updateprint' WHERE table_id='F32' and name='composer';
UPDATE config_web_fields SET widgetfunction='gw_fct_updateprint' WHERE table_id='F32' and name='scale';

INSERT INTO config_param_system (parameter, value, data_type, context, descript)  
VALUES ('api_search_samplepoint', '{"sys_table_id":"samplepoint", "sys_id_field":"sample_id", "sys_search_field":"code", "alias":"Punt de mostreig", "cat_field":"lab_code", "orderby":"7"}', 'text', 'api_search_network', NULL)
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('api_bmaps_client', 'FALSE', 'boolean', 'System', 'Utils')
ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_web_layer_cat_formtab 
VALUES ('tabLotSelector')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_web_tabs (id, layer_id, formtab, tablabel, tabtext)  
VALUES ((SELECT max(id)+1 FROM config_web_tabs), 'F33', 'tabLotSelector', 'Lots', 'Selector de lots')
ON CONFLICT (id) DO NOTHING;


--3.1.110
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_tabs", "column":"inforole_id", "dataType":"integer"}}$$);

INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('api_search_character_number', '3', 'integer', 'System', 'API')
ON CONFLICT (parameter) DO NOTHING;


--3.2.010
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_layer", "column":"is_tiled_add", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_web_layer", "column":"observ", "dataType":"text"}}$$);


--3.2.014
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('api_getinfoelements', '{"key":"", "queryText":"SELECT id as \"Identifier:\" FROM table WHERE id IS NOT NULL ", "idName":"id"}', 'json', 'basic', 'Variable to customize table about getinfoelements function for api. Use \"your_text\" to use alias')
ON CONFLICT (parameter) DO NOTHING;

