/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/10/03
ALTER TABLE inp_dscenario_flwreg_outlet ALTER COLUMN outlet_type DROP NOT NULL;
ALTER TABLE inp_dscenario_flwreg_weir ALTER COLUMN weir_type DROP NOT NULL;
ALTER TABLE inp_dscenario_flwreg_orifice ALTER COLUMN ori_type DROP NOT NULL;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_inp_arc", "column":"minorloss", "dataType":"numeric(12,6)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"temp_arc", "column":"minorloss", "dataType":"numeric(12,6)", "isUtils":"False"}}$$);

--2022/10/22
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_dscenario_inflows", "column":"format_type", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_dscenario_inflows", "column":"mfactor", "isUtils":"False"}}$$);

