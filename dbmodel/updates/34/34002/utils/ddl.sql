/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/06/15
ALTER TABLE version RENAME to sys_version;
ALTER TABLE sys_version RENAME wsoftware to project_type;

-- 2020/01/30
CREATE TABLE IF NOT EXISTS doc_x_workcat
(
  id serial NOT NULL,
  doc_id character varying(30),
  workcat_id character varying (30),
  CONSTRAINT doc_x_workcat_pkey PRIMARY KEY (id),
  CONSTRAINT doc_x_workcat_doc_id_fkey FOREIGN KEY (doc_id)
      REFERENCES doc (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT doc_x_workcat_workcat_id_fkey FOREIGN KEY (workcat_id)
      REFERENCES cat_work (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_cat_function", "column":"sample_query", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"addparam", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_node", "column":"addparam", "dataType":"text", "isUtils":"False"}}$$);

CREATE TABLE IF NOT EXISTS temp_go2epa
(id serial,
arc_id varchar(20),
vnode_id varchar(20),
locate float,
elevation float,
depth float);


-- 2020/02/20
ALTER TABLE anl_polygon ALTER COLUMN the_geom TYPE geometry('MULTIPOLYGON');

-- create index on rpt_inp_arc
CREATE INDEX rpt_inp_arc_result_id ON rpt_inp_arc
USING btree (result_id COLLATE pg_catalog."default");

CREATE INDEX rpt_inp_arc_node_1_type ON rpt_inp_arc
USING btree (node_1 COLLATE pg_catalog."default");

CREATE INDEX rpt_inp_arc_node_2_type ON rpt_inp_arc
USING btree (node_2 COLLATE pg_catalog."default");

CREATE INDEX rpt_inp_arc_arc_type ON rpt_inp_arc
USING btree (arc_type COLLATE pg_catalog."default");

CREATE INDEX rpt_inp_arc_epa_type ON rpt_inp_arc
USING btree (epa_type COLLATE pg_catalog."default");

-- create index on rpt_inp_node
CREATE INDEX rpt_inp_node_result_id ON rpt_inp_node
USING btree (result_id COLLATE pg_catalog."default");

CREATE INDEX rpt_inp_node_node_type ON rpt_inp_node
USING btree (node_type COLLATE pg_catalog."default");

CREATE INDEX rpt_inp_node_epa_type ON rpt_inp_node
USING btree (epa_type COLLATE pg_catalog."default");

-- create index on temp_go2epa
CREATE INDEX temp_go2epa_arc_id ON temp_go2epa
USING btree (arc_id COLLATE pg_catalog."default");

--2020/02/24
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_anlgraf", "column":"length", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_anlgraf", "column":"cost", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_anlgraf", "column":"value", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);




--mandatory update on ddl to save value of editability, typeahead, reg_exp columns
UPDATE config_api_form_fields  SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols,'autoupdateReloadFields', (reload_field->>'reload')::json) where reload_field is not null; --reload

DROP VIEW IF EXISTS ve_config_addfields;
DROP VIEW IF EXISTS ve_config_sys_fields;
DROP VIEW IF EXISTS ve_config_sysfields;

-- drop fields
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"isenabled"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"layout_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"isnotupdate"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"editability"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"reload_field"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"typeahead"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"field_length"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"num_decimals"}}$$);

--rename fields
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_api_form_fields", "column":"action_function", "newName":"linkedaction"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_api_form_fields", "column":"layout_name", "newName":"layoutname"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_api_form_groupbox", "column":"tooltip", "dataType":"text"}}$$);


CREATE TABLE config_api_form_actions(
  actionname text primary key,
  label text,
  tooltip text); 

  
--2020/03/11
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_tabs", "column":"tooltip"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_api_form_tabs", "column":"tabtext", "newName":"tooltip"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_api_form_tabs", "column":"tablabel", "newName":"label"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_api_form_groupbox", "column":"label", "newName":"label_"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_api_form_groupbox", "column":"layoutname", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_api_form_groupbox", "column":"label", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_api_form_groupbox", "column":"tooltip", "dataType":"text"}}$$);

UPDATE config_api_form_groupbox SET layoutname = layout_id;
UPDATE config_api_form_groupbox SET label = label_;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_groupbox", "column":"layout_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_groupbox", "column":"label_"}}$$);