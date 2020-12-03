/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 08/10/2019
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"macrodqa_id, name","featureType":["v_edit_dqa"]}]' WHERE id='macrodqa';

UPDATE  config_api_form_fields SET widgettype='typeahead', 
dv_querytext = 'SELECT cat_node.id, cat_node.id as idval FROM cat_node JOIN cat_feature ON cat_feature.id=cat_node.nodetype_id WHERE system_id = ''VALVE''', 
typeahead = '{"fieldToSearch": "cat_node.id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id = 'cat_valve2' or column_id = 'cat_valve' or column_id = 'valve';

UPDATE  config_api_form_fields SET widgettype='typeahead', dv_querytext = 'SELECT connec_id, connec_id as idval FROM connec WHERE id IS NOT NULL', 
isreload = false,typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id = 'linked_connec';
