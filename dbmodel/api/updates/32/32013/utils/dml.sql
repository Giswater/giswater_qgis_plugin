/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 24/05/2019

UPDATE sys_feature_cat SET shortcut_key = 'P' WHERE id = 'PUMP' AND tablename = 'v_edit_man_pump';
UPDATE cat_feature SET shortcut_key = concat('Alt+',sys_feature_cat.shortcut_key) FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'NODE';
UPDATE cat_feature SET shortcut_key = concat('Ctrl+',sys_feature_cat.shortcut_key) FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'CONNEC';
UPDATE cat_feature SET shortcut_key = sys_feature_cat.shortcut_key FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'ARC';


UPDATE config_param_system SET value = '{"sys_table_id":"v_ui_workcat_polygon_all", "sys_id_field":"workcat_id", "sys_search_field":"workcat_id", "sys_geom_field":"the_geom", "filter_text":"code"}' 
	WHERE parameter = 'api_search_workcat';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2", "feature_type":"node_id"}' 
	WHERE parameter = 'api_search_node';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Escomeses", "cat_field":"connecat_id", "orderby":"3", "feature_type":"connec_id"}' 
	WHERE parameter = 'api_search_connec';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5", "feature_type":"element_id"}' 
	WHERE parameter = 'api_search_element';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby" :"1", "feature_type":"arc_id"}' 
	WHERE parameter = 'api_search_arc';

	
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='arccat_id';
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='nodecat_id';
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='connecat_id';
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='connecat_id';
UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='gratecat_id';
UPDATE config_api_form_fields set widgettype='typeahead', typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='workcat_id';
UPDATE config_api_form_fields set widgettype='typeahead', typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id='workcat_id_end';



UPDATE config_api_form_fields set layout_name = concat('data_',layout_id) WHERE layout_name IS NULL;


-- 28/05/2019

UPDATE cat_feature SET parent_layer = 'v_edit_node' where parent_layer = 've_node';
UPDATE cat_feature SET parent_layer = 'v_edit_arc' where parent_layer = 've_arc';
UPDATE cat_feature SET parent_layer = 'v_edit_connec' where parent_layer = 've_connec';


UPDATE config_api_form_fields SET formname='unexpected_noinfra' WHERE formname='unspected_noinfra';
UPDATE config_api_form_fields SET formname='unexpected_arc' WHERE formname= 'unspected_arc';

UPDATE config_api_visit SET formname='unexpected_arc' WHERE formname= 'unspected_arc';
UPDATE config_api_visit SET formname='unexpected_noinfra' WHERE formname= 'unspected_noinfra';

-- 10/06/2019

UPDATE config_api_form_fields SET dv_querytext = 'SELECT id, id as idval FROM om_visit_lot WHERE active IS TRUE' WHERE id = 28490;
UPDATE config_api_form_fields SET dv_querytext = 'SELECT id, id as idval FROM om_visit_lot WHERE active IS TRUE' WHERE id = 28240;

UPDATE config_api_list SET query_text = 'SELECT DISTINCT ON (a.id) a.id AS sys_id, a.id AS lot_id, ''om_visit_lot'' as sys_table_id, ''id'' as sys_idname FROM om_visit_lot a' WHERE id = 28240;

UPDATE config_api_form_fields SET layout_order = 6 WHERE id = 30040;
UPDATE config_api_form_fields SET layout_order = 7 WHERE id = 30050;
INSERT INTO config_api_form_fields VALUES(30045, 'lot', 'lot','visitclass_id', 1, 5, TRUE, 'string', 'combo', 'Classe visita:', NULL, NULL, NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM om_visit_class WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

UPDATE config_api_form_fields SET dv_querytext='SELECT id, idval FROM edit_typevalue WHERE typevalue=''listlimit''' WHERE id='102718';