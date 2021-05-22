/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/22
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"export_options", "dataType":"json", "isUtils":"False"}}$$)
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"network_stats", "dataType":"json", "isUtils":"False"}}$$)
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"status", "dataType":"int2", "isUtils":"False"}}$$)


SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rpt_cat_result", "column":"inpoptions", "newName":"inp_options"}}$$)
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rpt_cat_result", "column":"stats", "newName":"rpt_stats"}}$$)