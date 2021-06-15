/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/06/10
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_lidusage_subc_x_lidco", "column":"hydrology_id", "dataType":"integer", "isUtils":"False"}}$$);
ALTER TABLE inp_lidusage_subc_x_lidco ALTER COLUMN hydrology_id SET DEFAULT 1;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_lidusage_subc_x_lidco", "column":"descript", "dataType":"text", "isUtils":"False"}}$$);



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_curve", "column":"descript", "dataType":"text", "isUtils":"False"}}$$);
