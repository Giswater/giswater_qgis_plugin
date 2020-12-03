/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
-- config_mincut_inlet
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_mincut_inlet", "column":"config", "newName":"parameters"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_mincut_inlet", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_mincut_valve", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_mincut_checkvalve", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);

-- tstep on selector
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"selector_rpt_compare_tstep", "column":"time", "newName":"timestep"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"selector_rpt_main_tstep", "column":"time", "newName":"timestep"}}$$);
