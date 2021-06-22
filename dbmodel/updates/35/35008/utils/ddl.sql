/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/15
DROP TABLE IF EXISTS inp_report;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_brand", "column":"featurecat_id", "dataType":"character varying(300)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_brand_model", "column":"featurecat_id", "dataType":"character varying(300)", "isUtils":"False"}}$$);


-- 2021/06/08
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_version", "column":"sample"}}$$);

-- 2021/06/22
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_csv", "column":"readheader"}}$$);