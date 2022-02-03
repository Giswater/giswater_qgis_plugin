/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/31
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_pattern", "column":"sector_id", "newName":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_curve", "column":"sector_id", "newName":"expl_id"}}$$);

--2022/02/03
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_table", "column":"addparam", "dataType":"json", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_table", "column":"sys_sequence"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_table", "column":"sys_sequence_field"}}$$);
