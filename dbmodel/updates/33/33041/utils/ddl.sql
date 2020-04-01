/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

create table IF NOT EXISTS om_profile (
profile_id text PRIMARY KEY,
values json);

-- refactor config_param_system.isdeprecated to boolean
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_param_system", "column":"isdep", "dataType":"boolean"}}$$);
UPDATE config_param_system SET isdep = isdeprecated::boolean;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_param_system", "column":"isdeprecated"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_param_system", "column":"isdep", "newName":"isdeprecated"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"ext_rtc_dma_period", "column":"m3_min"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"ext_rtc_dma_period", "column":"m3_max"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"ext_rtc_dma_period", "column":"m3_avg"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"ext_rtc_dma_period", "column":"isscada"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"vnode_topelev", "dataType":"float"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"node_1", "dataType":"character varying(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"node_2", "dataType":"character varying(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"sys_type", "dataType":"character varying(30)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"code", "dataType":"character varying(30)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"cat_geom1", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"length", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"slope", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"total_length", "dataType":"numeric(12,3)"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"total_distance", "dataType":"numeric(12,3)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"sys_type", "dataType":"character varying(30)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"code", "dataType":"character varying(30)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"cat_geom1", "dataType":"float"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_type", "column":"isprofilesurface", "dataType":"boolean"}}$$);
