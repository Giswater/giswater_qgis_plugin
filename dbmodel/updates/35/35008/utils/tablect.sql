/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/06/15
ALTER TABLE sys_function RENAME CONSTRAINT audit_cat_function_pkey TO sys_function_pkey;
ALTER TABLE sys_function RENAME CONSTRAINT audit_cat_function_sys_role_id_fkey TO sys_function_sys_role_id_fkey;
ALTER TABLE sys_param_user RENAME CONSTRAINT audit_cat_param_user_pkey TO sys_param_user_pkey;
ALTER TABLE sys_version RENAME CONSTRAINT version_pkey TO sys_version_pkey;
ALTER TABLE config_csv RENAME CONSTRAINT sys_csv2pg_cat_pkey TO config_csv_pkey;
ALTER TABLE config_file RENAME CONSTRAINT om_visit_filetype_x_extension_pkey TO config_file_pkey;
ALTER TABLE config_fprocess RENAME CONSTRAINT config_csv_param_pkey TO config_fprocess_pkey;
ALTER TABLE config_info_layer RENAME CONSTRAINT config_api_layer_pkey TO config_info_layer_pkey;
ALTER TABLE config_typevalue RENAME CONSTRAINT config_api_typevalue_pkey TO config_typevalue_pkey;
ALTER TABLE config_visit_parameter_action RENAME CONSTRAINT config_visit_param_x_param_pkey TO config_visit_parameter_action_pkey;

DROP TRIGGER IF EXISTS gw_trg_config_control ON cat_brand;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON cat_brand
FOR EACH ROW EXECUTE PROCEDURE gw_trg_config_control('cat_brand');

DROP TRIGGER IF EXISTS gw_trg_config_control ON cat_brand_model;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF featurecat_id ON cat_brand_model
FOR EACH ROW EXECUTE PROCEDURE gw_trg_config_control('cat_brand_model');