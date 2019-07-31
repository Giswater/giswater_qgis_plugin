/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"vnode", "column":"elev", "dataType":"numeric(12,3)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"dqa_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"staticpressure", "dataType":"numeric(12,3)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"dqa_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"staticpressure", "dataType":"numeric(12,3)"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"minsector_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"dqa_id", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"staticpressure", "dataType":"numeric(12,3)"}}$$);



UPDATE cat_presszone SET descript=id WHERE descript IS NULL;