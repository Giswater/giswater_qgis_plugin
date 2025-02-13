/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 13/02/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"connec", "column":"n_inhabitants", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"om_waterbalance", "column":"n_inhabitants", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"om_waterbalance", "column":"avg_press", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);

