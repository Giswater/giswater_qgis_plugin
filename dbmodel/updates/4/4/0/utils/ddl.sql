/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 25/09/2025 add uuid to tables
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element", "column":"uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"uuid", "dataType":"uuid"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element_x_node", "column":"node_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element_x_arc", "column":"arc_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element_x_connec", "column":"connec_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"element_x_link", "column":"link_uuid", "dataType":"uuid"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_x_node", "column":"node_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_x_arc", "column":"arc_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_x_connec", "column":"connec_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_x_link", "column":"link_uuid", "dataType":"uuid"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"doc_x_node", "column":"node_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"doc_x_arc", "column":"arc_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"doc_x_connec", "column":"connec_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"doc_x_link", "column":"link_uuid", "dataType":"uuid"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"doc_x_element", "column":"element_uuid", "dataType":"uuid"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"code", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"dma_type", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"avg_press", "dataType":"numeric", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"effc", "dataType":"numeric", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"stylesheet", "dataType":"json", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"link", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"addparam", "dataType":"json", "isUtils":"False"}}$$);


