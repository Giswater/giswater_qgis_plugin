/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/10/03
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_connec", "column":"custom_roughness", "dataType":"double precision", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_connec", "column":"custom_length", "dataType":"double precision", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_connec", "column":"custom_dint", "dataType":"double precision", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"epa_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_dscenario_demand", "column":"id", "isUtils":"False"}}$$);


-- 2021/10/05
ALTER TABLE arc ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE node ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE connec ALTER COLUMN state_type SET NOT NULL;

DROP FUNCTION IF EXISTS gw_trg_man2inp_values;
DROP TRIGGER IF EXISTS gw_trg_man2inp_values ON node;


