/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/28
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"nodetype_1", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"elev1", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"y1", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"nodetype_2", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"elev2", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"y2", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);

--2022/10/03
ALTER TABLE inp_dscenario_flwreg_outlet ALTER COLUMN outlet_type DROP NOT NULL;
ALTER TABLE inp_dscenario_flwreg_weir ALTER COLUMN weir_type DROP NOT NULL;
ALTER TABLE inp_dscenario_flwreg_orifice ALTER COLUMN ori_type DROP NOT NULL;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_inp_arc", "column":"minorloss", "dataType":"numeric(12,6)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"temp_arc", "column":"minorloss", "dataType":"numeric(12,6)", "isUtils":"False"}}$$);