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

ALTER TABLE config_api_visit RENAME TO _config_api_visit_;

ALTER SEQUENCE SCHEMA_NAME.config_api_form_fields_id_seq RENAME TO config_form_fields_id_seq;

