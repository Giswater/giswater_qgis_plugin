/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_typevalue", "column":"descript", "newName":"camelstyle"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_form_tableview", "column":"column_id", "newName":"columnname"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_form_tableview", "column":"column_index", "newName":"columnindex"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_form_tableview", "column":"table_id", "newName":"tablename"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"audit_check_project", "column":"fprocesscat_id", "newName":"fid"}}$$);

-- sys_fprocess
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_fprocess", "column":"id", "newName":"fid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"parameters", "dataType":"json", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_fprocess", "column":"context"}}$$);

-- config_csv
DELETE FROM config_csv WHERE id IN(14,15,16);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_csv", "column":"id", "newName":"fid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_csv", "column":"isdeprecated", "newName":"active"}}$$);
ALTER TABLE config_csv ALTER COLUMN active set DEFAULT true;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_csv", "column":"csv_structure", "newName":"descript"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_csv", "column":"formname"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_csv", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);

-- config_info_layer
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_info_layer", "column":"add_param", "newName":"addparam"}}$$);

-- temp_csv
ALTER TABLE temp_csv2pg RENAME TO temp_csv;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"temp_csv", "column":"temp_csv2pg_csv2pgcat_id_fkey2"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"temp_csv", "column":"temp_csv2pg_pkey1"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"temp_csv", "column":"csv2pgcat_id", "newName":"fid"}}$$);

ALTER TABLE temp_csv DROP CONSTRAINT IF EXISTS temp_csv2pg_pkey1;
ALTER TABLE temp_csv ADD CONSTRAINT temp_csv_pkey PRIMARY KEY(id);
ALTER TABLE temp_csv ADD CONSTRAINT temp_csv_fkey FOREIGN KEY (fid) REFERENCES sys_fprocess (fid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


-- config_fprocess
ALTER TABLE config_csv_param RENAME TO config_fprocess;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_fprocess", "column":"pg2csvcat_id", "newName":"fid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_fprocess", "column":"reverse_pg2csvcat_id", "newName":"fid2"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_fprocess", "column":"csvversion"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_fprocess", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);

-- fid
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"audit_check_data", "column":"fprocesscat_id", "newName":"fid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"audit_log_data", "column":"fprocesscat_id", "newName":"fid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"anl_arc", "column":"fprocesscat_id", "newName":"fid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"anl_arc_x_node", "column":"fprocesscat_id", "newName":"fid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"anl_connec", "column":"fprocesscat_id", "newName":"fid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"anl_node", "column":"fprocesscat_id", "newName":"fid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"temp_table", "column":"fprocesscat_id", "newName":"fid"}}$$);

-- sys_foreignkey
ALTER TABLE sys_foreignkey DROP constraint typevalue_fk_pkey ;
ALTER TABLE sys_foreignkey ADD CONSTRAINT sys_foreingkey_pkey PRIMARY KEY (id);

-- sys_typevalue
ALTER TABLE sys_typevalue DROP constraint sys_typevalue_cat_pkey;
ALTER TABLE sys_typevalue DROP constraint sys_typevalue_unique;
ALTER TABLE sys_typevalue ADD CONSTRAINT sys_typevalue_pkey PRIMARY KEY (typevalue_table, typevalue_name);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_typevalue", "column":"id"}}$$);

-- active
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_toolbox", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_file", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_visit_parameter_action", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_visit_parameter", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_user_x_expl", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_visit_class_x_feature", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_visit_class_x_parameter", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_visit_class_x_workorder", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);


ALTER TABLE config_toolbox ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_file ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_parameter_action ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_parameter ALTER COLUMN active SET DEFAULT TRUE;;
ALTER TABLE config_user_x_expl ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_class_x_feature ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_class_x_parameter ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_class_x_workorder ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_foreignkey", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE sys_foreignkey ALTER column active SET DEFAULT TRUE;


--DROP SEQUENCE config_csv_id_seq;
--DROP SEQUENCE sys_images_id_seq;
--DROP SEQUENCE config_form_layout_id_seq;
--DROP SEQUENCE config_info_layer_x_type_id_seq;

ALTER SEQUENCE man_addfields_parameter_id_seq RENAME TO sys_addfields_id_seq;

ALTER SEQUENCE temp_csv2pg_id_seq RENAME TO temp_csv_id_seq;

-- rename constraints (fid, audit_check_project)

--2020/06/02
ALTER TABLE om_visit_type RENAME TO _om_visit_type_;
ALTER TABLE om_visit_cat_status RENAME TO _om_visit_cat_status_;
ALTER TABLE om_visit_parameter_cat_action RENAME TO _om_visit_parameter_cat_action_;
ALTER TABLE om_visit_parameter_form_type RENAME TO _om_visit_parameter_form_type_;
ALTER TABLE om_visit_parameter_type RENAME TO _om_visit_parameter_type_;
ALTER TABLE plan_psector_cat_type RENAME TO _plan_psector_cat_type_;
ALTER TABLE plan_result_type RENAME TO _plan_result_type_;
ALTER TABLE price_value_unit RENAME TO _price_value_unit_;