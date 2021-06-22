/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/06/10
ALTER TABLE inp_lidusage_subc_x_lidco RENAME TO inp_lid_usage;
ALTER TABLE inp_lid_usage RENAME CONSTRAINT inp_lidusage_subc_x_lidco_pkey TO inp_lid_usage_pkey;
ALTER TABLE inp_lid_usage RENAME CONSTRAINT inp_lidusage_subc_x_lidco_subc_id_fkey TO inp_lid_usage_subc_id_fkey;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_lid_usage", "column":"descript", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_curve", "column":"descript", "dataType":"text", "isUtils":"False"}}$$);

--2021/06/17
ALTER SEQUENCE inp_curve_seq RENAME TO inp_curve_value_id_seq;
ALTER SEQUENCE inp_timeseries_value_seq RENAME TO inp_timeseries_value_id_seq;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"descript", "dataType":"text", "isUtils":"False"}}$$);
