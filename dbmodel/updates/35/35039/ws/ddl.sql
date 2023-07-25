/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);


ALTER TABLE presszone ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE presszone ALTER COLUMN insert_user SET DEFAULT current_user;

ALTER TABLE dqa ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE dqa ALTER COLUMN insert_user SET DEFAULT current_user;