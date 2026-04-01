/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


drop view if exists v_ext_raster_dem;
drop view if exists v_ext_municipality;
drop view if exists v_ext_streetaxis;
drop view if exists v_ext_address;
drop view if exists v_ext_plot;


drop view if exists v_plan_result_arc;
drop view if exists v_plan_psector;
drop view if exists v_plan_current_psector;
drop view if exists v_plan_psector_budget;
drop view if exists v_plan_psector_budget_arc;
drop view if exists v_plan_psector_budget_detail;
drop view if exists v_plan_psector_all;
drop view if exists v_ui_plan_arc_cost;
drop view if exists v_plan_arc;
drop view if exists v_ui_arc_x_relations;
drop view if exists ve_inp_dscenario_connec;
drop view if exists ve_inp_connec;
drop view if exists v_ui_workcat_x_feature_end;
drop view if exists v_ui_node_x_connection_upstream;

drop view if exists v_edit_connec;
drop view if exists ve_connec;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_municipality", "column":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_municipality", "column":"sector_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_address", "column":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_streetaxis", "column":"expl_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP", "table":"ext_plot", "column":"expl_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_address", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_municipality", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_district", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_plot", "column":"plot_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_province", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"ext_region", "column":"ext_code", "newName":"code"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"connec", "column":"plot_code", "newName":"plot_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_address", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_streetaxis", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_district", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_plot", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_municipality", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_province", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"ext_region", "column":"code", "dataType":"varchar(100)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"connec", "column":"plot_id", "dataType":"varchar(100)"}}$$);


CREATE SEQUENCE ext_plot_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

ALTER TABLE ext_plot ALTER COLUMN id SET DEFAULT nextval('ext_plot_id_seq');
ALTER TABLE ext_streetaxis ALTER COLUMN id SET DEFAULT nextval('ext_streetaxis_id_seq');
ALTER TABLE ext_address ALTER COLUMN id SET DEFAULT nextval('ext_address_id_seq');