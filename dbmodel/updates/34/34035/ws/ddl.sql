/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/05/06
DROP VIEW IF EXISTS v_edit_review_audit_arc;
DROP VIEW IF EXISTS v_edit_review_arc;

ALTER TABLE review_arc DROP CONSTRAINT review_arc_pkey;
ALTER TABLE review_arc RENAME TO _review_arc2_;


CREATE TABLE review_arc
(
  arc_id character varying(16) NOT NULL,
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

ALTER TABLE review_audit_arc DROP CONSTRAINT review_audit_arc_pkey;
ALTER TABLE review_audit_arc RENAME TO _review_audit_arc2_;
ALTER SEQUENCE review_audit_arc_id_seq RENAME TO review_audit_arc_id_seq_old;


CREATE TABLE review_audit_arc
(
  id serial NOT NULL,
  arc_id character varying(16) NOT NULL,
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


DROP VIEW IF EXISTS v_edit_review_audit_node;
DROP VIEW IF EXISTS v_edit_review_node;

ALTER TABLE review_node DROP CONSTRAINT review_node_pkey;
ALTER TABLE review_node RENAME TO _review_node2_;


CREATE TABLE review_node
(
  node_id character varying(16) NOT NULL,
  elevation numeric(12,3),
  depth numeric(12,3),
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

ALTER TABLE review_audit_node DROP CONSTRAINT review_audit_node_pkey;
ALTER TABLE review_audit_node RENAME TO _review_audit_node2_;
ALTER SEQUENCE review_audit_node_id_seq RENAME TO review_audit_node_id_seq_old;

CREATE TABLE review_audit_node
(
  id serial NOT NULL,
  node_id character varying(16) NOT NULL,
  old_elevation numeric(12,3),
  new_elevation numeric(12,3),
  old_depth numeric(12,3),
  new_depth numeric(12,3),
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

ALTER TABLE review_connec DROP CONSTRAINT review_connec_pkey;
ALTER TABLE review_connec RENAME TO _review_connec2_;

CREATE TABLE review_connec
(
  connec_id character varying(16) NOT NULL,
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

ALTER TABLE review_audit_connec DROP CONSTRAINT review_audit_connec_pkey;
ALTER TABLE review_audit_connec RENAME TO _review_audit_connec2_;
ALTER SEQUENCE review_audit_connec_id_seq RENAME TO review_audit_connec_id_seq_old;

CREATE TABLE review_audit_connec
(
  id serial NOT NULL,
  connec_id character varying(16) NOT NULL,
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