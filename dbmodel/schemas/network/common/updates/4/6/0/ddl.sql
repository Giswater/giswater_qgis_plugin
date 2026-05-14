/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS ve_exploitation;
DROP VIEW IF EXISTS v_ui_om_visit;
DROP VIEW IF EXISTS v_ui_workcat_x_feature;
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
DROP VIEW IF EXISTS v_ui_mincut;
DROP VIEW IF EXISTS v_anl_arc;
DROP VIEW IF EXISTS v_anl_arc_point;
DROP VIEW IF EXISTS v_anl_arc_x_node;
DROP VIEW IF EXISTS v_anl_arc_x_node_point;
DROP VIEW IF EXISTS v_anl_connec;
DROP VIEW IF EXISTS v_anl_node;
DROP VIEW IF EXISTS v_om_mincut;
DROP VIEW IF EXISTS v_om_waterbalance;
DROP VIEW IF EXISTS v_om_waterbalance_report;
DROP VIEW IF EXISTS v_ui_hydrometer;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_connec;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_node;
DROP VIEW IF EXISTS v_rtc_hydrometer;
DROP VIEW IF EXISTS v_om_mincut_initpoint;
DROP VIEW IF EXISTS ve_macroexploitation;
DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS ve_sector;
DROP VIEW IF EXISTS v_ui_macrosector;
DROP VIEW IF EXISTS ve_macrosector;
DROP VIEW IF EXISTS v_ui_omzone;
DROP VIEW IF EXISTS ve_omzone;
DROP VIEW IF EXISTS v_ui_macroomzone;
DROP VIEW IF EXISTS ve_macroomzone;
DROP VIEW IF EXISTS v_ui_dma;
DROP VIEW IF EXISTS ve_dma;

ALTER TABLE exploitation ALTER COLUMN code TYPE varchar(100);
ALTER TABLE exploitation ALTER COLUMN name TYPE varchar(100);
ALTER TABLE exploitation ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE macroexploitation ALTER COLUMN code TYPE varchar(100);
ALTER TABLE macroexploitation ALTER COLUMN name TYPE varchar(100);
ALTER TABLE macroexploitation ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE sector ALTER COLUMN code TYPE varchar(100);
ALTER TABLE sector ALTER COLUMN name TYPE varchar(100);
ALTER TABLE sector ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE macrosector ALTER COLUMN code TYPE varchar(100);
ALTER TABLE macrosector ALTER COLUMN name TYPE varchar(100);
ALTER TABLE macrosector ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE omzone ALTER COLUMN code TYPE varchar(100);
ALTER TABLE omzone ALTER COLUMN name TYPE varchar(100);
ALTER TABLE omzone ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE macroomzone ALTER COLUMN code TYPE varchar(100);
ALTER TABLE macroomzone ALTER COLUMN name TYPE varchar(100);
ALTER TABLE macroomzone ALTER COLUMN descript TYPE varchar(255);

ALTER TABLE dma ALTER COLUMN code TYPE varchar(100);
ALTER TABLE dma ALTER COLUMN name TYPE varchar(100);
ALTER TABLE dma ALTER COLUMN descript TYPE varchar(255);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_arc", "column":"code", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_node", "column":"code", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_connec", "column":"code", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_link", "column":"code", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_element", "column":"code", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_pavement", "column":"code", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_soil", "column":"code", "dataType":"text", "isUtils":"False"}}$$);