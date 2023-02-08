/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"minsector", "column":"num_valve", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"auth_bill", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"auth_unbill", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"loss_app", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"loss_real", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"total_in", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"total_out", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"total", "dataType":"double precision"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"auth", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"nrw", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"nrw_eff", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"loss", "dataType":"double precision"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"meters_in", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"meters_out", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"n_connec", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"n_hydro", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"arc_length", "dataType":"double precision"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"link_length", "dataType":"double precision"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"real_flow_max", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"real_flow_min", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"real_flow_avg", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"real_vel_max", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"real_vel_min", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc_add", "column":"real_vel_avg", "dataType":"numeric(12,2)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_add", "column":"real_press_max", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_add", "column":"real_press_min", "dataType":"numeric(12,2)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_add", "column":"real_press_avg", "dataType":"numeric(12,2)"}}$$);


