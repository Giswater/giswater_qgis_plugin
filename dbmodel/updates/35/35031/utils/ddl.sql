/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch SCHEMA "public";

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_node", "column":"field_date", "dataType":"timestamp(6) without time zone", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_arc", "column":"field_date", "dataType":"timestamp(6) without time zone", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"review_connec", "column":"field_date", "dataType":"timestamp(6) without time zone", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"sector_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"dma_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"link", "column":"fluid_type", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"link", "column":"vnode_topelev", "newName":"exit_topelev"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_connec", "column":"link_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"plan_psector_x_connec", "column":"link_geom", "newName":"_link_geom_" }}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"plan_psector_x_connec", "column":"userdefined_geom", "newName":"_userdefined_geom_"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_arc", "column":"insert_tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_node", "column":"insert_tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_connec", "column":"insert_tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_other", "column":"insert_tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_arc", "column":"insert_user", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_node", "column":"insert_user", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_connec", "column":"insert_user", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_other", "column":"insert_user", "dataType":"text", "isUtils":"False"}}$$);

ALTER TABLE plan_psector_x_arc ALTER COLUMN tstamp SET DEFAULT NOW();
ALTER TABLE plan_psector_x_node ALTER COLUMN tstamp SET DEFAULT NOW();
ALTER TABLE plan_psector_x_connec ALTER COLUMN tstamp SET DEFAULT NOW();
ALTER TABLE plan_psector_x_other ALTER COLUMN tstamp SET DEFAULT NOW();

ALTER TABLE plan_psector_x_arc ALTER COLUMN insert_user SET DEFAULT CURRENT_USER;
ALTER TABLE plan_psector_x_node ALTER COLUMN insert_user SET DEFAULT CURRENT_USER;
ALTER TABLE plan_psector_x_connec ALTER COLUMN insert_user SET DEFAULT CURRENT_USER;
ALTER TABLE plan_psector_x_other ALTER COLUMN insert_user SET DEFAULT CURRENT_USER;


ALTER TABLE vnode RENAME TO _vnode_;

CREATE TABLE temp_vnode (
  id serial primary key,
  l1 integer,
  v1 integer,
  l2 integer,
  v2 integer
);

CREATE TABLE temp_link(
  link_id integer primary key,
  vnode_id integer,
  vnode_type text,
  feature_id varchar(16),
  feature_type character varying(16),
  exit_id varchar(16),
  exit_type varchar(16),
  state smallint,
  expl_id integer,
  sector_id integer,
  dma_id integer,
  exit_topelev float,
  exit_elev float,
  the_geom geometry(LineString,SRID_VALUE),
  the_geom_endpoint geometry(point, SRID_VALUE),
  flag boolean);


CREATE TABLE temp_link_x_arc(
  link_id integer primary key,
  vnode_id integer,
  arc_id character varying(16),
  feature_type character varying(16),
  feature_id character varying(16),
  node_1 character varying(16),
  node_2 character varying(16),
  vnode_distfromnode1 numeric(12,3),
  vnode_distfromnode2 numeric(12,3),
  exit_topelev double precision,
  exit_ymax numeric(12,3),
  exit_elev numeric(12,3)
);

ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_link_id_fkey FOREIGN KEY (link_id)
REFERENCES link (link_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE plan_psector_x_connec DROP CONSTRAINT plan_psector_x_connec_unique;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_unique UNIQUE(connec_id, psector_id, state);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_arc", "column":"active", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_node", "column":"active", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"plan_psector_x_connec", "column":"active", "dataType":"boolean"}}$$);

ALTER TABLE plan_psector_x_arc ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE plan_psector_x_node ALTER COLUMN active SET DEFAULT TRUE;
ALTER TABLE plan_psector_x_connec ALTER COLUMN active SET DEFAULT TRUE;
