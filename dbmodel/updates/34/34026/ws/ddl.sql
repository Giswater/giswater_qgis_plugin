/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/04
CREATE TABLE IF NOT EXISTS temp_mincut (
id bigserial PRIMARY KEY,
source int8,
target int8,
cost int2,
reverse_cost int2);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_state", "column":"is_operative", "dataType":"boolean"}}$$);