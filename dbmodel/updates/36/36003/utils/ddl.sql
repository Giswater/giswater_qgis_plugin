/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"audit_log_data", "column":"feature_id", "dataType":"character varying(30)"}}$$);

DROP TABLE config_visit_class_x_feature; 

DROP TABLE IF EXISTS temp_vnode;
DROP TABLE IF EXISTS temp_link;
DROP TABLE IF EXISTS temp_link_x_arc;

DELETE FROM sys_table WHERE id IN ('config_visit_class_x_feature','temp_vnode','temp_link','temp_link_x_arc');

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD",
"table":"audit_psector_arc_traceability", "column":"adate", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD",
"table":"audit_psector_arc_traceability", "column":"adescript", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD",
"table":"audit_psector_node_traceability", "column":"adate", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD",
"table":"audit_psector_node_traceability", "column":"adescript", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD",
"table":"audit_psector_connec_traceability", "column":"adate", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD",
"table":"audit_psector_connec_traceability", "column":"adescript", "dataType":"text"}}$$);
