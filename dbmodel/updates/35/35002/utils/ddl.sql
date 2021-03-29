/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


set search_path = 'SCHEMA_NAME';

DROP TABLE IF EXISTS config_form_groupbox;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_fprocess", "column":"fields", "newName":"querytext"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_check_data", "column":"fcount", "dataType":"integer", "isUtils":"False"}}$$);


CREATE TABLE IF NOT EXISTS audit_fid_log
(id serial NOT NULL  PRIMARY KEY,
fid smallint,
fcount integer,
groupby text,
criticity integer,
tstamp timestamp without time zone DEFAULT now()
);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"layermanager"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"sytle"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"actions"}}$$);

--2020/09/24 
DROP FUNCTION IF EXISTS gw_fct_edit_check_data(json);
DROP FUNCTION IF EXISTS gw_fct_getinsertfeature(json);
DROP FUNCTION IF EXISTS gw_fct_admin_schema_copy(json);

--2020/10/19
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_fprocess", "column":"fid2"}}$$);

--2020/11/25
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"plan_psector", "column":"sector_id"}}$$);

--2020/12/14
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_brand", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_brand ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_brand_model", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_brand_model ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_builder", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_builder ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_mat_arc", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_mat_arc ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_mat_node", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_mat_node ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_mat_element", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_mat_element ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_owner", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_owner ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_pavement", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_pavement ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_soil", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_soil ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_work", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE cat_work ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_param_user", "column":"isdeprecated"}}$$);

--2020/12/15
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dma", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE dma ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrodma", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE macrodma ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macrosector", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE macrosector ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"macroexploitation", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE macroexploitation ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE sector ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_type_location", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE man_type_location ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_type_category", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE man_type_category ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_type_fluid", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE man_type_fluid ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_type_function", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);
ALTER TABLE man_type_function ALTER COLUMN active SET DEFAULT TRUE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"value_type", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"cat_feature_arc", "column":"addparam"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"cat_feature_connec", "column":"addparam"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_table", "column":"qgis_role_id", "newName":"qgis_role"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_visit_class", "column":"sys_role_id", "newName":"sys_role"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_addfields", "column":"field_length", "newName":"_field_length_"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_addfields", "column":"num_decimals", "newName":"_num_decimals_"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"sys_addfields", "column":"dv_value_column", "newName":"_dv_value_column_"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_table", "column":"sys_roleselect_id"}}$$);

ALTER TABLE IF EXISTS om_visit_parameter_index RENAME TO _om_visit_parameter_index_;

CREATE TABLE sys_feature_epa_type
(
  id character varying(30) NOT NULL,
  feature_type character varying(30),
  epa_table character varying(50),
  descript text,
  active boolean,
  CONSTRAINT sys_feature_inp_pkey PRIMARY KEY (id, feature_type)
  );

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_arc_type", "column":"epa_table", "dataType":"character varying(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_node_type", "column":"epa_table", "dataType":"character varying(30)", "isUtils":"False"}}$$);
