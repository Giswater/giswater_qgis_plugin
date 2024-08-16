/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 07/08/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"visitability", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"placement_type", "dataType":"varchar(50)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_outfall", "column":"reception_env_name", "dataType":"varchar(16)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_arc_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_arc_traceability", "column":"visitability", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_node_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_connec_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"audit_psector_gully_traceability", "column":"placement_type", "dataType":"varchar(50)"}}$$);
