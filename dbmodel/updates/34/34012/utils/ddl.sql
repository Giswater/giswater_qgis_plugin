/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25



ALTER TABLE config_typevalue RENAME COLUMN descript TO camelstyle;


ALTER TABLE config_form_tableview RENAME column_id TO columnname;
ALTER TABLE config_form_tableview RENAME column_index TO columnindex;
ALTER TABLE config_form_tableview RENAME table_id TO tablename;


ALTER TABLE audit_check_project RENAME fprocesscat_id TO fid;

-- sys_fprocess
ALTER TABLE sys_fprocess RENAME id TO fid;
ALTER TABLE sys_fprocess ADD column parameters JSON;
ALTER TABLE sys_fprocess DROP column context;

-- config_csv
DELETE FROM config_csv WHERE id IN(14,15,16);
ALTER TABLE config_csv RENAME id TO fid;
ALTER TABLE config_csv RENAME isdeprecated TO active;
ALTER TABLE config_csv ALTER COLUMN active set DEFAULT true;
ALTER TABLE config_csv RENAME csv_structure TO descript;
ALTER TABLE config_csv DROP column formname;
ALTER TABLE config_csv ADD COLUMN addparam JSON;

-- config_info_layer
ALTER TABLE config_info_layer RENAME add_param TO addparam;

-- temp_csv
ALTER TABLE temp_csv2pg RENAME TO temp_csv;
ALTER TABLE temp_csv DROP CONSTRAINT temp_csv2pg_csv2pgcat_id_fkey2;
ALTER TABLE temp_csv DROP CONSTRAINT temp_csv2pg_pkey1;
ALTER TABLE temp_csv RENAME csv2pgcat_id TO fid;
ALTER TABLE temp_csv ADD CONSTRAINT temp_csv_pkey PRIMARY KEY(id);
ALTER TABLE temp_csv ADD CONSTRAINT temp_csv_fkey FOREIGN KEY (fid) REFERENCES sys_fprocess (fid) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


-- config_fprocess
ALTER TABLE config_csv_param RENAME TO config_fprocess;
ALTER TABLE config_fprocess RENAME pg2csvcat_id TO fid;
ALTER TABLE config_fprocess RENAME reverse_pg2csvcat_id TO fid2;
ALTER TABLE config_fprocess DROP column csvversion;
ALTER TABLE config_fprocess ADD column addparam JSON;

-- fid
ALTER TABLE audit_check_data RENAME fprocesscat_id TO fid;
ALTER TABLE audit_log_data RENAME fprocesscat_id TO fid;
ALTER TABLE anl_arc RENAME fprocesscat_id TO fid;
ALTER TABLE anl_arc_x_node RENAME fprocesscat_id TO fid;
ALTER TABLE anl_connec RENAME fprocesscat_id TO fid;
ALTER TABLE anl_node RENAME fprocesscat_id TO fid;
ALTER TABLE temp_table RENAME fprocesscat_id TO fid;

-- sys_foreignkey
ALTER TABLE sys_foreignkey DROP constraint typevalue_fk_pkey ;
ALTER TABLE sys_foreignkey DROP constraint sys_foreingkey_unique;
ALTER TABLE sys_foreignkey ADD CONSTRAINT sys_foreingkey_pkey PRIMARY KEY (typevalue_table, typevalue_name, target_table, target_field);
ALTER TABLE sys_foreignkey DROP column id;

-- sys_typevalue
ALTER TABLE sys_typevalue DROP constraint sys_typevalue_cat_pkey;
ALTER TABLE sys_typevalue DROP constraint sys_typevalue_unique;
ALTER TABLE sys_typevalue ADD CONSTRAINT sys_typevalue_pkey PRIMARY KEY (typevalue_table, typevalue_name);
ALTER TABLE sys_typevalue DROP column id;

-- active
ALTER TABLE config_toolbox ADD column active boolean;
ALTER TABLE config_file ADD column active boolean;
ALTER TABLE config_visit_parameter_action ADD column active boolean;
ALTER TABLE config_visit_parameter ADD column active boolean;
ALTER TABLE config_user_x_expl ADD column active boolean;
ALTER TABLE config_visit_class_x_feature ADD column active boolean;
ALTER TABLE config_visit_class_x_parameter ADD column active boolean;
ALTER TABLE config_visit_class_x_workorder ADD column active boolean;

ALTER TABLE config_toolbox ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_file ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_parameter_action ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_parameter ALTER COLUMN active SET DEFAULT TRUE;;
ALTER TABLE config_user_x_expl ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_class_x_feature ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_class_x_parameter ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE config_visit_class_x_workorder ALTER COLUMN active SET DEFAULT TRUE;

ALTER TABLE sys_foreignkey ADD column active boolean;
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