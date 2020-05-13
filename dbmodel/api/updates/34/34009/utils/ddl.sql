/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE config_api_form_actions RENAME TO config_form_actions;
ALTER TABLE config_api_form_fields RENAME TO config_form_fields;
ALTER TABLE config_api_form_groupbox RENAME TO config_form_groupbox;
ALTER TABLE config_api_form_tabs RENAME TO config_form_tabs;
ALTER TABLE config_api_images RENAME TO config_form_images;
ALTER TABLE config_api_layer RENAME TO config_info_layer;
ALTER TABLE config_api_list RENAME TO config_form_list;
ALTER TABLE config_api_tableinfo_x_infotype RENAME TO config_info_table_x_type;
ALTER TABLE config_api_typevalue RENAME TO config_form_typevalue;
ALTER TABLE config_client_forms RENAME TO config_form_tableview;
ALTER TABLE config_api_form RENAME TO config_form;
ALTER TABLE config_api_visit_x_featuretable RENAME TO config_visit_x_feature;


ALTER TABLE config_api_visit RENAME TO _config_api_visit_;

ALTER SEQUENCE SCHEMA_NAME.config_api_form_fields_id_seq RENAME TO config_form_fields_id_seq;


ALTER SEQUENCE SCHEMA_NAME.config_api_form_groupbox_id_seq RENAME TO config_form_groupbox_id_seq;
ALTER SEQUENCE SCHEMA_NAME.config_api_form_id_seq RENAME TO config_form_id_seq;
ALTER SEQUENCE SCHEMA_NAME.config_api_form_layout_id_seq RENAME TO config_form_layout_id_seq;
ALTER SEQUENCE SCHEMA_NAME.config_api_images_id_seq RENAME TO config_form_images_id_seq;
ALTER SEQUENCE SCHEMA_NAME.config_api_list_id_seq RENAME TO config_form_list_id_seq;
ALTER SEQUENCE SCHEMA_NAME.config_api_tableinfo_x_inforole_id_seq RENAME TO config_info_table_x_type_id_seq;
ALTER SEQUENCE SCHEMA_NAME.config_client_forms_id_seq RENAME TO config_form_tableview_id_seq;

ALTER SEQUENCE SCHEMA_NAME.anl_mincut_inlet_x_exploitation_id_seq RENAME TO config_mincut_inlet_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_arc_id_seq RENAME TO om_mincut_arc_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_connec_id_seq RENAME TO om_mincut_connec_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_hydrometer_id_seq RENAME TO om_mincut_hydrometer_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_node_id_seq RENAME TO om_mincut_node_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_polygon_id_seq RENAME TO om_mincut_polygon_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_valve_id_seq RENAME TO om_mincut_valve_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_valve_unaccess_id_seq RENAME TO om_mincut_valve_unaccess_id_seq;

ALTER SEQUENCE SCHEMA_NAME.sys_csv2pg_cat_id_seq RENAME TO config_csv_id_seq;
ALTER SEQUENCE SCHEMA_NAME.sys_csv2pg_config_id_seq RENAME TO config_csv_param_id_seq;
ALTER SEQUENCE SCHEMA_NAME.sample_id_seq RENAME TO samplepoint_id_seq;
ALTER SEQUENCE SCHEMA_NAME.audit_log_arc_traceability_id_seq RENAME TO audit_arc_traceability_id_seq;
ALTER SEQUENCE SCHEMA_NAME.typevalue_fk_id_seq RENAME TO config_typevalue_fk_id_seq;

ALTER TABLE config_toolbox ADD CONSTRAINT config_toolbox_id_fkey FOREIGN KEY (id)
REFERENCES sys_function (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE sys_function ADD CONSTRAINT sys_function_function_name_unique UNIQUE (function_name, project_type);

