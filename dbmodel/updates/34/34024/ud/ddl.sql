/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/10/22
UPDATE inp_subcatchment SET outlet_id = _parent_id WHERE _parent_id IS NOT NULL;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_subcatchment", "column":"_parent_id", "isUtils":"False"}}$$);