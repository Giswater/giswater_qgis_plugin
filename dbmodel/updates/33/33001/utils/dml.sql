/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id, descript","featureType":["cat_node"]}]' WHERE id = 'cat_node_shape';
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"macrodma_id, name","featureType":["v_edit_dma"]}]' WHERE id = 'macrodma';
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"macroexpl_id, name","featureType":["exploitation"]}]' WHERE id = 'macroexploitation';
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"macrosector_id, name","featureType":["v_edit_sector"]}]' WHERE id = 'macrosector';
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["cat_node","cat_arc","cat_connec","cat_grate"]}]' WHERE id = 'price_compost';
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_config_user_variables", "enabled":"true", "trg_fields":"parameter,value, cur_user","featureType":[""]}]' WHERE id = 'config_param_user';
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_config_system_variables", "enabled":"true", "trg_fields":"parameter, value, data_type, context, descript, label","featureType":[""]}]' WHERE id = 'config_param_system';


UPDATE audit_cat_param_user SET dv_querytext = 'SELECT id as id, id as idval FROM cat_node WHERE id IS null', isenabled = TRUE, layout_id = 5, layout_order = 6 , formname = 'config' WHERE id = 'cad_tools_base_layer_vdefault';