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


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"cat_feature_node", "column":"man_table"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"cat_feature_arc", "column":"man_table"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"cat_feature_connec", "column":"man_table"}}$$);

CREATE TABLE IF NOT EXISTS sys_feature_epa_type
(
  id character varying(30) NOT NULL,
  feature_type character varying(30),
  epa_table character varying(50),
  descript text,
  active boolean,
  CONSTRAINT sys_feature_inp_pkey PRIMARY KEY (id, feature_type)
  );


