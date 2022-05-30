/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/05/23

ALTER VIEW v_edit_cat_dwf_dscenario RENAME TO v_edit_cat_dwf_scenario;


--2022/05/30
DROP VIEW vi_lid_controls;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_lid_value", "column":"value_8"}}$$)
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CREATE","table":"inp_lid_value", "column":"value_8", "dataType":"text", "isUtils":"False"}}$$)