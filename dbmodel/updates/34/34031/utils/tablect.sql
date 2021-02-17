/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/02/10
ALTER TABLE plan_psector_x_node DROP CONSTRAINT IF EXISTS plan_psector_x_node_unique;
ALTER TABLE plan_psector_x_arc DROP CONSTRAINT IF EXISTS plan_psector_x_arc_unique;
ALTER TABLE plan_psector_x_connec DROP CONSTRAINT IF EXISTS plan_psector_x_connec_unique;

ALTER TABLE plan_psector_x_node ADD CONSTRAINT plan_psector_x_node_unique UNIQUE(node_id, psector_id);
ALTER TABLE plan_psector_x_arc ADD CONSTRAINT plan_psector_x_arc_unique UNIQUE(arc_id, psector_id);
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_unique UNIQUE(connec_id, psector_id);


-- 2020/01/07
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_arc", "oldName":"arc_type_pkey", "newName":"cat_feature_arc_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_arc", "oldName":"arc_type_epa_default_fkey", "newName":"cat_feature_arc_epa_default_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_arc", "oldName":"arc_type_id_fkey", "newName":"cat_feature_arc_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_arc", "oldName":"arc_type_type_fkey", "newName":"cat_feature_arc_type_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_arc", "oldName":"arc_type_epa_table_check", "newName":"cat_feature_arc_epa_table_check"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_arc", "oldName":"arc_type_man_table_check", "newName":"cat_feature_arc_man_table_check"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_node", "oldName":"node_type_pkey", "newName":"cat_feature_node_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_node", "oldName":"node_type_epa_default_fkey", "newName":"cat_feature_node_epa_default_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_node", "oldName":"node_type_id_fkey", "newName":"cat_feature_node_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_node", "oldName":"node_type_type_fkey", "newName":"cat_feature_node_type_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_node", "oldName":"node_type_epa_table_check", "newName":"cat_feature_node_epa_table_check"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_node", "oldName":"node_type_man_table_check", "newName":"cat_feature_node_man_table_check"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_connec", "oldName":"connec_type_pkey", "newName":"cat_feature_connec_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_connec", "oldName":"connec_type_id_fkey", "newName":"cat_feature_connec_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_connec", "oldName":"connec_type_type_fkey", "newName":"cat_feature_connec_type_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"cat_feature_connec", "oldName":"connec_type_man_table_check", "newName":"cat_feature_connec_man_table_check"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_user_x_expl", "oldName":"exploitation_x_user_pkey", "newName":"config_user_x_expl_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_user_x_expl", "oldName":"exploitation_x_user_expl_id_fkey", "newName":"config_user_x_expl_expl_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_user_x_expl", "oldName":"exploitation_x_user_manager_id_fkey", "newName":"config_user_x_expl_manager_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_user_x_expl", "oldName":"exploitation_x_user_username_fkey", "newName":"config_user_x_expl_username_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_class", "oldName":"om_visit_class_pkey", "newName":"config_visit_class_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_class", "oldName":"om_visit_class_feature_type_fkey", "newName":"config_visit_class_feature_type_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_class", "oldName":"om_visit_class_sys_role_id_fkey", "newName":"config_visit_class_sys_role_id_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_class_x_feature", "oldName":"config_api_visit_x_table_pkey", "newName":"config_visit_class_x_feature_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_class_x_feature", "oldName":"config_api_visit_x_featuretable_visitclass_id_fkey", "newName":"config_visit_class_x_feature_visitclass_id_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_class_x_parameter", "oldName":"om_visit_class_x_parameter_class_fkey", "newName":"config_visit_class_x_parameter_class_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_class_x_parameter", "oldName":"om_visit_class_x_parameter_parameter_fkey", "newName":"config_visit_class_x_parameter_parameter_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_parameter", "oldName":"om_visit_parameter_pkey", "newName":"config_visit_parameter_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_parameter", "oldName":"om_visit_parameter_feature_type_check", "newName":"config_visit_parameter_feature_type_check"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_parameter_action", "oldName":"om_visit_parameter_x_parameter_parameter_id1_fkey", "newName":"config_visit_parameter_action_parameter_id1_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_parameter_action", "oldName":"om_visit_parameter_x_parameter_parameter_id2_fkey", "newName":"config_visit_parameter_action_parameter_id2_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_price", "oldName":"price_compost_pkey", "newName":"plan_price_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_price", "oldName":"price_compost_pricecat_id_fkey", "newName":"plan_price_pricecat_id_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_price_cat", "oldName":"price_cat_simple_pkey", "newName":"plan_price_cat_pkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_price_compost", "oldName":"price_compost_value_pkey", "newName":"plan_price_compost_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_price_compost", "oldName":"price_compost_value_compost_id_fkey", "newName":"plan_price_compost_compost_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_price_compost", "oldName":"price_compost_value_compost_id_fkey2", "newName":"plan_price_compost_compost_id_fkey2"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_rec_result_arc", "oldName":"om_rec_result_arc_result_id_fkey", "newName":"plan_rec_result_arc_result_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_rec_result_node", "oldName":"om_rec_result_node_result_id_fkey", "newName":"plan_rec_result_node_result_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_reh_result_arc", "oldName":"om_reh_result_arc_result_id_fkey", "newName":"plan_reh_result_arc_result_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_reh_result_node", "oldName":"om_reh_result_node_result_id_fkey", "newName":"plan_reh_result_node_result_id_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"plan_result_cat", "oldName":"om_result_cat_pkey", "newName":"plan_result_cat_pkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"sys_addfields", "oldName":"man_addfields_parameter_pkey", "newName":"sys_addfields_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"sys_addfields", "oldName":"man_addfields_parameter_cat_feature_id_fkey", "newName":"sys_addfields_cat_feature_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"sys_addfields", "oldName":"man_addfields_parameter_unique", "newName":"sys_addfields_unique"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"sys_image", "oldName":"config_web_images_pkey", "newName":"sys_image_pkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"sys_message", "oldName":"audit_cat_error_pkey", "newName":"sys_message_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"sys_message", "oldName":"audit_cat_error_log_level_check", "newName":"sys_message_log_level_check"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_visit_class", "oldName":"config_visit_class_sys_role_id_fkey", "newName":"config_visit_class_sys_role_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"sys_table", "oldName":"sys_table_qgis_role_id_fkey", "newName":"sys_table_qgis_role_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"sys_table", "oldName":"sys_table_sys_role_id_fkey", "newName":"sys_table_sys_role_fkey"}}$$);