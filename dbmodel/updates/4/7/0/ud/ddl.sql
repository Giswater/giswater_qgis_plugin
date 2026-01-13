/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 13/01/2026
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"treatment_type", "dataType":"int4", "isUtils":"False"}}$$);
