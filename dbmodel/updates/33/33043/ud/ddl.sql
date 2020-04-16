/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node_type", "column":"isexitupperintro", "dataType":"int2"}}$$);
ALTER TABLE node_type ALTER COLUMN isexitupperintro SET DEFAULT 0;
COMMENT ON TABLE node_type IS 'FIELD isexitupperintro has three values 0-false (by default), 1-true, 2-maybe';

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"q0", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"qmax", "dataType":"float"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"barrels", "dataType":"integer"}}$$);
