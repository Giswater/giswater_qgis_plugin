/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



ALTER TABLE inp_typevalue_source RENAME TO _inp_typevalue_source_;


--29/10/2019 --reorganize mapzones

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"grafconfig", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"grafconfig", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"grafconfig", "dataType":"json"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_presszone", "column":"grafconfig", "dataType":"json"}}$$);


DROP VIEW v_edit_inp_reservoir;
DROP VIEW v_edit_inp_tank;
DROP VIEW v_edit_inp_inlet;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_inlet", "column":"to_arc"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_reservoir", "column":"to_arc"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_tank", "column":"to_arc"}}$$);