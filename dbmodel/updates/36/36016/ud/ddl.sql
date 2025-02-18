/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"serial_number", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"serial_number", "dataType":"varchar(100)"}}$$);

update node n set serial_number = a.serial_number from (
select node_id, serial_number from man_netelement
)a where n.node_id = a.node_id;

--SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
-- "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_netelement", "column":"serial_number"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"brand", "newName":"brand_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_arc", "column":"model", "newName":"model_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_node", "column":"brand", "newName":"brand_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_node", "column":"model", "newName":"model_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_connec", "column":"brand", "newName":"brand_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_connec", "column":"model", "newName":"model_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_grate", "column":"brand", "newName":"brand_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"cat_grate", "column":"model", "newName":"model_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_arc_traceability", "column":"serial_number", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"brand_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"model_id", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_psector_node_traceability", "column":"serial_number", "dataType":"varchar(100)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_subcatchment", "column":"muni_id", "dataType":"integer"}}$$);

