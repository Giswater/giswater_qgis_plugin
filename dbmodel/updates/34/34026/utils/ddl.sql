/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/30
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_fprocess", "column":"source", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_function", "column":"source", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_message", "column":"source", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_param_user", "column":"source", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_table", "column":"source", "dataType":"text", "isUtils":"False"}}$$);


-- 2021/01/14
CREATE INDEX IF NOT EXISTS anl_arc_arc_id ON anl_arc USING btree (arc_id);
CREATE INDEX IF NOT EXISTS anl_connec_connec_id ON anl_connec USING btree (connec_id);
CREATE INDEX IF NOT EXISTS anl_polygon_pol_id ON anl_polygon USING btree (pol_id);
CREATE INDEX IF NOT EXISTS anl_arc_x_node_arc_id ON anl_arc_x_node USING btree (arc_id);
CREATE INDEX IF NOT EXISTS anl_arc_x_node_node_id ON anl_arc_x_node USING btree (node_id);