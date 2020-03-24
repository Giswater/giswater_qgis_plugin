/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

update config_api_form_fields SET dv_parent_id = 'arccat_id' WHERE formname = 'upsert_catalog_arc' and formtype = 'catalog' and column_id ='matcat_id';
update config_api_form_fields SET dv_parent_id = 'nodecat_id' WHERE formname = 'upsert_catalog_node' and formtype = 'catalog' and column_id ='matcat_id';
update config_api_form_fields SET dv_parent_id = 'connecat_id' WHERE formname = 'upsert_catalog_connec' and formtype = 'catalog' and column_id ='matcat_id';

INSERT INTO audit_cat_error (id, log_level, error_message, hint_message, message_type) SELECT * FROM config_api_message;

ALTER TABLE config_api_message RENAME TO _config_api_message_;

UPDATE audit_cat_table SET isdeprecated = true WHERE id = 'config_api_message';

--2020/03/13
UPDATE config_api_form_fields SET dv_querytext_filterc = replace(dv_querytext_filterc,'=','') WHERE dv_querytext_filterc is not null;

-- 2020/03/16
UPDATE config_api_form_fields SET layoutname = 'lyt_data_1' WHERE layoutname = 'layout_data_1';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_2' WHERE layoutname = 'layout_data_2';
UPDATE config_api_form_fields SET layoutname = 'lyt_data_3' WHERE layoutname = 'layout_data_3';
UPDATE config_api_form_fields SET layoutname = 'lyt_bot_1' WHERE layoutname = 'bot_layout_1';
UPDATE config_api_form_fields SET layoutname = 'lyt_bot_2' WHERE layoutname = 'bot_layout_2';
UPDATE config_api_form_fields SET layoutname = 'lyt_top_1' WHERE layoutname = 'top_layout';

UPDATE config_api_form_fields SET layoutname = 'lyt_top_1' WHERE formtype='catalog' AND layoutname = 'top_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_distance' WHERE formtype='catalog' AND layoutname = 'distance_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_depth' WHERE formtype='catalog' AND layoutname = 'depth_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_symbology' WHERE formtype='catalog' AND layoutname = 'symbology_layout';
UPDATE config_api_form_fields SET layoutname = 'lyt_other' WHERE formtype='catalog' AND layoutname = 'other_layout';

-- 2020/03/19
UPDATE typevalue_fk SET target_table = 'audit_cat_error', target_field = 'message_type' WHERE typevalue_name = 'mtype_typevalue';

-- 2020/03/24
UPDATE config_api_form_fields SET formtype= 'feature'  WHERE formname = 've_config_sysfields';

