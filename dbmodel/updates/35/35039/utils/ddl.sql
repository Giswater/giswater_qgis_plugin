/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);;

ALTER TABLE sector ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE sector ALTER COLUMN insert_user SET DEFAULT current_user;

ALTER TABLE dma ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE dma ALTER COLUMN insert_user SET DEFAULT current_user;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_arc", "column":"sector_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"sector_id", "dataType":"integer", "isUtils":"False"}}$$);