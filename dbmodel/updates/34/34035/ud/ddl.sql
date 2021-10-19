/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/04/22
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"plan_psector_x_gully", "column":"vnode_geom"}}$$);

-- 2021/05/05
DROP VIEW IF EXISTS v_edit_review_audit_arc;
DROP VIEW IF EXISTS v_edit_review_arc;

ALTER TABLE IF EXISTS review_arc DROP CONSTRAINT review_arc_pkey;
ALTER TABLE IF EXISTS review_arc RENAME TO _review_arc2_;


CREATE TABLE review_arc
(
  arc_id character varying(16) NOT NULL,
  y1 numeric(12,3),
  y2 numeric(12,3),
  arc_type character varying(18),
  matcat_id character varying(30),
  arccat_id character varying(30),
  annotation text,
  observ text,
  review_obs text,
  expl_id integer,
  the_geom geometry(LineString,SRID_VALUE),
  field_checked boolean,
  is_validated integer,
  CONSTRAINT review_arc_pkey PRIMARY KEY (arc_id)
);

ALTER TABLE IF EXISTS review_audit_arc DROP CONSTRAINT review_audit_arc_pkey;
ALTER TABLE IF EXISTS review_audit_arc RENAME TO _review_audit_arc2_;
ALTER SEQUENCE IF EXISTS review_audit_arc_id_seq RENAME TO review_audit_arc_id_seq_old;


CREATE TABLE review_audit_arc
(
  id serial NOT NULL,
  arc_id character varying(16),
  old_y1 double precision,
  new_y1 double precision,
  old_y2 double precision,
  new_y2 double precision,
  old_arc_type character varying(18),
  new_arc_type character varying(18),
  old_matcat_id character varying(30),
  new_matcat_id character varying(30),
  old_arccat_id character varying(30),
  new_arccat_id character varying(30),
  old_annotation text,
  new_annotation text,
  old_observ text,
  new_observ text,
  review_obs text,
  expl_id integer,
  the_geom geometry(LineString,SRID_VALUE),
  review_status_id smallint,
  field_date timestamp(6) without time zone,
  field_user text,
  is_validated integer,
  CONSTRAINT review_audit_arc_pkey PRIMARY KEY (id)
);


DROP VIEW IF EXISTS v_edit_review_audit_gully;
DROP VIEW IF EXISTS v_edit_review_gully;

ALTER TABLE IF EXISTS review_gully DROP CONSTRAINT review_gully_pkey;
ALTER TABLE IF EXISTS review_gully RENAME TO _review_gully2_;


CREATE TABLE review_gully
(
  gully_id character varying(16) NOT NULL,
  top_elev numeric(12,3),
  ymax numeric(12,3),
  sandbox numeric(12,3),
  gully_type character varying(30),
  matcat_id character varying(30),
  gratecat_id character varying(30),
  units smallint,
  groove boolean,
  siphon boolean,
  connec_arccat_id character varying(18),
  annotation text,
  observ text,
  review_obs text,
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  field_checked boolean,
  is_validated integer,
  CONSTRAINT review_gully_pkey PRIMARY KEY (gully_id)
);

ALTER TABLE IF EXISTS review_audit_gully DROP CONSTRAINT review_audit_gully_pkey;
ALTER TABLE IF EXISTS review_audit_gully RENAME TO _review_audit_gully2_;
ALTER SEQUENCE IF EXISTS review_audit_gully_id_seq RENAME TO review_audit_gully_id_seq_old;


CREATE TABLE review_audit_gully
(
  id serial NOT NULL,
  gully_id character varying(16) NOT NULL,
  old_top_elev numeric(12,3),
  new_top_elev numeric(12,3),
  old_ymax numeric(12,3),
  new_ymax numeric(12,3),
  old_sandbox numeric(12,3),
  new_sandbox numeric(12,3),
  new_gully_type character varying(30),
  old_gully_type character varying(30),
  old_matcat_id character varying(30),
  new_matcat_id character varying(30),
  old_gratecat_id character varying(30),
  new_gratecat_id character varying(30),
  old_units smallint,
  new_units smallint,
  old_groove boolean,
  new_groove boolean,
  old_siphon boolean,
  new_siphon boolean,
  old_connec_arccat_id character varying(18),
  new_connec_arccat_id character varying(18),
  old_annotation text,
  new_annotation text,
  old_observ text,
  new_observ text,
  review_obs text,
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  review_status_id smallint,
  field_date timestamp(6) without time zone,
  field_user text,
  is_validated integer,
  CONSTRAINT review_audit_gully_pkey PRIMARY KEY (id)
);

DROP VIEW IF EXISTS v_edit_review_audit_node;
DROP VIEW IF EXISTS v_edit_review_node;

ALTER TABLE IF EXISTS review_node DROP CONSTRAINT review_node_pkey;
ALTER TABLE IF EXISTS review_node RENAME TO _review_node2_;


CREATE TABLE review_node
(
  node_id character varying(16) NOT NULL,
  top_elev numeric(12,3),
  ymax numeric(12,3),
  node_type character varying(18),
  matcat_id character varying(30),
  nodecat_id character varying(30),
  annotation text,
  observ text,
  review_obs text,
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  field_checked boolean,
  is_validated integer,
  CONSTRAINT review_node_pkey PRIMARY KEY (node_id)
);

ALTER TABLE IF EXISTS review_audit_node DROP CONSTRAINT review_audit_node_pkey;
ALTER TABLE IF EXISTS review_audit_node RENAME TO _review_audit_node2_;
ALTER SEQUENCE IF EXISTS review_audit_node_id_seq RENAME TO review_audit_node_id_seq_old;

CREATE TABLE review_audit_node
(
  id serial NOT NULL,
  node_id character varying(16) NOT NULL,
  old_top_elev numeric(12,3),
  new_top_elev numeric(12,3),
  old_ymax numeric(12,3),
  new_ymax numeric(12,3),
  old_node_type character varying(18),
  new_node_type character varying(18),
  old_matcat_id character varying(30),
  new_matcat_id character varying(30),
  old_nodecat_id character varying(30),
  new_nodecat_id character varying(30),
  old_annotation text,
  new_annotation text,
  old_observ text,
  new_observ text,
  review_obs text,
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  review_status_id smallint,
  field_date timestamp(6) without time zone,
  field_user text,
  is_validated integer,
  CONSTRAINT review_audit_node_pkey PRIMARY KEY (id)
);

DROP VIEW IF EXISTS v_edit_review_audit_connec;
DROP VIEW IF EXISTS v_edit_review_connec;

ALTER TABLE IF EXISTS review_connec DROP CONSTRAINT review_connec_pkey;
ALTER TABLE IF EXISTS review_connec RENAME TO _review_connec2_;

CREATE TABLE review_connec
(
  connec_id character varying(16) NOT NULL,
  y1 numeric(12,3),
  y2 numeric(12,3),
  connec_type character varying(18),
  matcat_id character varying(30),
  connecat_id character varying(30),
  annotation text,
  observ text,
  review_obs text,
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  field_checked boolean,
  is_validated integer,
  CONSTRAINT review_connec_pkey PRIMARY KEY (connec_id)
);

ALTER TABLE IF EXISTS review_audit_connec DROP CONSTRAINT review_audit_connec_pkey;
ALTER TABLE IF EXISTS review_audit_connec RENAME TO _review_audit_connec2_;
ALTER SEQUENCE IF EXISTS review_audit_connec_id_seq RENAME TO review_audit_connec_id_seq_old;

CREATE TABLE review_audit_connec
(
  id serial NOT NULL,
  connec_id character varying(16) NOT NULL,
  old_y1 numeric(12,3),
  new_y1 numeric(12,3),
  old_y2 numeric(12,3),
  new_y2 numeric(12,3),
  old_connec_type character varying(18),
  new_connec_type character varying(18),
  old_matcat_id character varying(30),
  new_matcat_id character varying(30),
  old_connecat_id character varying(30),
  new_connecat_id character varying(30),
  old_annotation text,
  new_annotation text,
  old_observ text,
  new_observ text,
  review_obs text,
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  review_status_id smallint,
  field_date timestamp(6) without time zone,
  field_user text,
  is_validated integer,
  CONSTRAINT review_audit_connec_pkey PRIMARY KEY (id)
);