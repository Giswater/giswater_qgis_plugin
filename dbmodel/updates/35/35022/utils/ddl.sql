/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/31
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_pattern", "column":"sector_id", "newName":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_curve", "column":"sector_id", "newName":"expl_id"}}$$);

ALTER TABLE cat_soil ALTER COLUMN y_param SET DEFAULT 1;