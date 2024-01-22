/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 20/12/2023
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_cat", "column":"feature_type", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_visit_cat", "column":"alias", "dataType":"text"}}$$);

--22/01/23
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"plot_code", "dataType":"varchar"}}$$);