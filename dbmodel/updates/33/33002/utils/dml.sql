/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE arc_type SET active = TRUE WHERE active IS NULL;
UPDATE connec_type SET active = TRUE WHERE active IS NULL;
UPDATE node_type SET active = TRUE WHERE active IS NULL;

INSERT INTO sys_fprocess_cat VALUES (63, 'Get layers name into TOC', 'config', 'Get layer name into TOC', 'utils');

-- 01/10/2019
UPDATE audit_cat_param_user SET label = 'Keep opened edition on update feature:' WHERE id = 'cf_keep_opened_edition';

-- 03/10/2019
UPDATE audit_cat_param_user SET dv_querytext = 'SELECT UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] from temp_table where fprocesscat_id = 63)) as id, UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] 
FROM temp_table WHERE fprocesscat_id = 63)) as idval ' WHERE id = 'cad_tools_base_layer_vdefault';

-- 08/10/2019
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"macrodma_id, name","featureType":["v_edit_dma"]}]' WHERE id='macrodma';
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"macrosector_id, name","featureType":["v_edit_sector"]}]' WHERE id='macrosector';
UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"macroexpl_id, name","featureType":["v_edit_exploitation"]}]' WHERE id='macroexploitation';

UPDATE audit_cat_table SET notify_action = '[{"action":"user","name":"refresh_config_system_variables", "enabled":"true", "trg_fields":"parameter, value, data_type, context, descript, label","featureType":[""]}]' WHERE id = 'config_param_system';

-- 08/10/2019
update config_api_form_fields set ismandatory = false where column_id='private_connecat_id';

UPDATE config_api_form_fields SET widgettype='typeahead', dv_querytext = 'SELECT pol_id AS id, pol_id AS idval FROM polygon WHERE pol_id is not null ', 
typeahead='{"fieldToSearch": "pol_id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id = 'pol_id';


UPDATE  config_api_form_fields SET widgettype='typeahead', dv_querytext = 'SELECT id, id as idval FROM cat_grate WHERE id IS NOT NULL', isreload = false,
typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' WHERE column_id = 'gratecat_id';
