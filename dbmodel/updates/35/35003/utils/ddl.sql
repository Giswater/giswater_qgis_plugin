/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sys_feature_cat", "column":"man_table", "dataType":"character varying(30)", "isUtils":"False"}}$$);

UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_node f WHERE sys_feature_cat.id=f.type;
UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_arc f WHERE sys_feature_cat.id=f.type;
UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_connec f WHERE sys_feature_cat.id=f.type;

ALTER TABLE cat_feature_node DROP COLUMN man_table;
ALTER TABLE cat_feature_arc DROP COLUMN man_table;
ALTER TABLE cat_feature_connec DROP COLUMN man_table;

DELETE FROM sys_table WHERE id  IN ('inp_arc_type', 'inp_node_type');
INSERT INTO sys_table VALUES ('sys_feature_epa_type', 'epa types', 'role_admin', 0, null, null, null, null, null, null, null, null, 'giswater');

--2021/03/18

CREATE TABLE IF NOT EXISTS crm_typevalue
( typevalue character varying(50) NOT NULL,
  id character varying(30) NOT NULL,
  idval character varying(100),
  descript text,
  addparam json,
  CONSTRAINT crm_typevalue_pkey PRIMARY KEY (typevalue, id)
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"value_type", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"value_status", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"value_state", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_form_list", "column":"actionfields"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_form_list", "column":"columnname", "dataType":"varchar(30)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_form_fields", "column":"isfilter", "dataType":"boolean", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_form_fields", "column":"tabname", "dataType":"varchar(30)", "isUtils":"False"}}$$);

--2021/03/29
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_feature_node", "column":"grafconfig", "dataType":"varchar(30)", "isUtils":"False"}}$$);
