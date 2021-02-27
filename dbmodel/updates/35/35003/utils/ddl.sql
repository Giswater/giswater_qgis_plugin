/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/12/14
ALTER TABLE sys_feature_cat ADD COLUMN man_table character varying(30);

UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_node f WHERE sys_feature_cat.id=f.type;
UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_arc f WHERE sys_feature_cat.id=f.type;
UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_connec f WHERE sys_feature_cat.id=f.type;

ALTER TABLE cat_feature_node DROP COLUMN man_table;
ALTER TABLE cat_feature_arc DROP COLUMN man_table;
ALTER TABLE cat_feature_connec DROP COLUMN man_table;


CREATE TABLE sys_feature_epa_type
(
  id character varying(30) NOT NULL,
  feature_type character varying(30),
  epa_table character varying(50),
  descript text,
  active boolean,
  CONSTRAINT sys_feature_inp_pkey PRIMARY KEY (id, feature_type)
  );

DELETE FROM sys_table WHERE id  IN ('inp_arc_type', 'inp_node_type');
INSERT INTO sys_table VALUES ('sys_feature_epa_type', 'epa types', 'role_admin', 0, null, null, null, null, null, null, null, null, 'giswater');