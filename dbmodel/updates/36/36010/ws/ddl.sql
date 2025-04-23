/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_meter", "column":"meter_code", "dataType":"varchar(30)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"avg_press", "dataType":"float"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"avg_press", "dataType":"float"}}$$);