/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2023/04/03

-- create active for non visual objects
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_curve", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_lid", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pattern", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"addparam", "dataType":"boolean", "isUtils":"False"}}$$);


-- create vdefault
ALTER TABLE inp_timeseries ALTER column active SET default true;
ALTER TABLE inp_curve ALTER column active SET default true;
ALTER TABLE inp_lid ALTER column active SET default true;
ALTER TABLE inp_pattern ALTER column active SET default true;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_conduit", "column":"bottom_mat", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_chamber", "column":"bottom_mat", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_manhole", "column":"bottom_mat", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_chamber", "column":"slope", "dataType":"numeric", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"adate", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"adescript", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"siphon_type", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"odorflap", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"adate", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"adescript", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"adate", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"adescript", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"adate", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"adescript", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_arc", "column":"visitability", "dataType":"boolean", "isUtils":"False"}}$$);


DROP VIEW IF EXISTS v_edit_man_chamber_pol;
DROP VIEW IF EXISTS v_edit_man_storage_pol;
DROP VIEW IF EXISTS v_edit_man_wwtp_pol;
DROP VIEW IF EXISTS v_edit_man_netgully_pol;

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"_pol_id_","action":"DELETE-FIELD","hasChilds":"True","onlyChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_man_chamber"], "fieldName":"_pol_id_","action":"DELETE-FIELD","hasChilds":"False","onlyChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_man_wwtp"], "fieldName":"_pol_id_","action":"DELETE-FIELD","hasChilds":"False","onlyChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_man_storage"], "fieldName":"_pol_id_","action":"DELETE-FIELD","hasChilds":"False","onlyChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_man_netgully"], "fieldName":"_pol_id_","action":"DELETE-FIELD","hasChilds":"False","onlyChilds":"True"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_chamber", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_storage", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_wwtp", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_netgully", "column":"_pol_id_", "dataType":"integer"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "action":"RESTORE-VIEW","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"drainzone", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);

ALTER TABLE drainzone ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE drainzone ALTER COLUMN insert_user SET DEFAULT current_user;
