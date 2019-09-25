/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO audit_cat_table VALUES ('config_api_form', 'System', 'List of forms used by the API', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_form_fields', 'System', 'Table whichs saves all values, widgets and configurations for atribute tables and forms in QGIS', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_form_groupbox', 'System', NULL, 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_form_tabs', 'System', 'List of tabs in forms used by the API', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_images', 'System', 'Saves images used by the API', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_layer', 'System', 'List of layers used by the API', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_list', 'System', 'Saves diferent query_texts related to tables', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_message', 'System', 'List of messages used by the API', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_tableinfo_x_infotype', 'System', 'Table of relations between one table and the table which will be openend based', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_typevalue', 'System', 'Relation of id/idval for diferent typevalues in order to manage diferent combo values', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_visit', 'System', 'Allow the relation of a formname and a tablename to visitclass_id', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('config_api_visit_x_featuretable', 'System', 'Relates visitclass_id to a generic tablename', 'role_admin', 2, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_table VALUES ('ve_config_addfields', 'System', 'View which shows existent addfields and its configuration', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;
INSERT INTO audit_cat_table VALUES ('ve_config_sys_fields', 'System', 'Shows ', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL) ON CONFLICT (id) DO NOTHING;


update config_api_form_fields set ismandatory=false where column_id = 'arc_id';
update config_api_form_fields set ismandatory=false where column_id = 'node_id';
update config_api_form_fields set ismandatory=false where column_id = 'connec_id';
