/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"matcat_id", "dataType":"character varying(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"matcat_id", "dataType":"character varying(16)"}}$$);

-- REVIEW NODE
DROP VIEW IF EXISTS v_edit_review_node;
DROP VIEW IF EXISTS v_edit_review_audit_node;

ALTER TABLE review_node DROP CONSTRAINT review_node_pkey;
ALTER TABLE IF EXISTS review_node RENAME TO _review_node_;

CREATE TABLE review_node
(
  node_id character varying(16) NOT NULL,
  top_elev numeric(12,3),
  ymax numeric(12,3),
  node_type character varying(18),
  matcat_id character varying(30),
  nodecat_id character varying(30),
  annotation character varying(254),
  observ character varying(254),
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  field_checked boolean,
  is_validated integer,
  CONSTRAINT review_node_pkey PRIMARY KEY (node_id)
);

ALTER TABLE review_audit_node DROP CONSTRAINT review_audit_node_pkey;
ALTER TABLE IF EXISTS review_audit_node RENAME TO _review_audit_node_;

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
  old_annotation character varying(254),
  new_annotation character varying(254),
  old_observ character varying(254),
  new_observ character varying(254),
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  review_status_id smallint,
  field_date timestamp(6) without time zone,
  field_user text,
  is_validated integer,
  CONSTRAINT review_audit_node_pkey PRIMARY KEY (id)
);

-- REVIEW ARC
DROP VIEW IF EXISTS v_edit_review_arc;
DROP VIEW IF EXISTS v_edit_review_audit_arc;

ALTER TABLE review_arc DROP CONSTRAINT review_arc_pkey;
ALTER TABLE IF EXISTS review_arc RENAME TO _review_arc_;

CREATE TABLE review_arc
(
  arc_id character varying(16) NOT NULL,
  y1 numeric(12,3),
  y2 numeric(12,3),
  arc_type character varying(18),
  matcat_id character varying(30),
  arccat_id character varying(30),
  annotation character varying(254),
  observ character varying(254),
  expl_id integer,
  the_geom geometry(LineString,SRID_VALUE),
  field_checked boolean,
  is_validated integer,
  CONSTRAINT review_arc_pkey PRIMARY KEY (arc_id)
);

ALTER TABLE review_audit_arc DROP CONSTRAINT review_audit_arc_pkey;
ALTER TABLE IF EXISTS review_audit_arc RENAME TO _review_audit_arc_;

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
  old_annotation character varying(254),
  new_annotation character varying(254),
  old_observ character varying(254),
  new_observ character varying(254),
  expl_id integer,
  the_geom geometry(LineString,SRID_VALUE),
  review_status_id smallint,
  field_date timestamp(6) without time zone,
  field_user text,
  is_validated integer,
  CONSTRAINT review_audit_arc_pkey PRIMARY KEY (id)
);

-- REVIEW CONNECT
DROP VIEW IF EXISTS v_edit_review_connec;
DROP VIEW IF EXISTS v_edit_review_audit_connec;

ALTER TABLE review_connec DROP CONSTRAINT review_connec_pkey;
ALTER TABLE IF EXISTS review_connec RENAME TO _review_connec_;

CREATE TABLE review_connec
(
  connec_id character varying(16) NOT NULL,
  y1 numeric(12,3),
  y2 numeric(12,3),
  connec_type character varying(18),
  matcat_id character varying(30),
  connecat_id character varying(30),
  annotation character varying(254),
  observ character varying(254),
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  field_checked boolean,
  is_validated integer,
  CONSTRAINT review_connec_pkey PRIMARY KEY (connec_id)
);

ALTER TABLE review_audit_connec DROP CONSTRAINT review_audit_connec_pkey;
ALTER TABLE IF EXISTS review_audit_connec RENAME TO _review_audit_connec_;

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
  old_annotation character varying(254),
  new_annotation character varying(254),
  old_observ character varying(254),
  new_observ character varying(254),
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  review_status_id smallint,
  field_date timestamp(6) without time zone,
  field_user text,
  is_validated integer,
  CONSTRAINT review_audit_connec_pkey PRIMARY KEY (id)
);

-- REVIEW GULLY
DROP VIEW IF EXISTS v_edit_review_gully;
DROP VIEW IF EXISTS v_edit_review_audit_gully;

ALTER TABLE review_gully DROP CONSTRAINT review_gully_pkey;
ALTER TABLE IF EXISTS review_gully RENAME TO _review_gully_;

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
  connec_matcat_id character varying(30),
  connec_arccat_id character varying(18),
  featurecat_id character varying(50),
  feature_id character varying(16),
  annotation character varying(254),
  observ character varying(254),
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  field_checked boolean,
  is_validated integer,
  CONSTRAINT review_gully_pkey PRIMARY KEY (gully_id)
);

ALTER TABLE review_audit_gully DROP CONSTRAINT review_audit_gully_pkey;
ALTER TABLE IF EXISTS review_audit_gully RENAME TO _review_audit_gully_;

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
  old_connec_matcat_id character varying(30),
  new_connec_matcat_id character varying(30),
  old_connec_arccat_id character varying(18),
  new_connec_arccat_id character varying(18),
  old_featurecat_id character varying(50),
  new_featurecat_id character varying(50),
  old_feature_id character varying(16),
  new_feature_id character varying(16),
  old_annotation character varying(254),
  new_annotation character varying(254),
  old_observ character varying(254),
  new_observ character varying(254),
  expl_id integer,
  the_geom geometry(Point,SRID_VALUE),
  review_status_id smallint,
  field_date timestamp(6) without time zone,
  field_user text,
  is_validated integer,
  CONSTRAINT review_audit_gully_pkey PRIMARY KEY (id)
);

