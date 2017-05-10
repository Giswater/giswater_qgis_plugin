/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- EXPLOTITATION STRATEGY
-- ----------------------------

CREATE TABLE exploitation(
expl_id integer  NOT NULL PRIMARY KEY,
short_descript character varying(50) NOT NULL,
descript character varying(100),
the_geom geometry(POLYGON,SRID_VALUE),
undelete boolean
);


CREATE TABLE expl_selector (
expl_id integer NOT NULL PRIMARY KEY,
cur_user text
);

-- ----------------------------
-- ADDING GEOMETRY TO CATALOG OF WORKS
-- ----------------------------

ALTER TABLE cat_works ADD COLUMN the_geom public.geometry(MULTIPOLYGON, SRID_VALUE);




-- ----------------------------
-- TRACEABILITY
-- ----------------------------


CREATE TABLE om_traceability (
id serial,
type character varying(50),
arc_id character varying(16),
arc_id1 character varying(16),
arc_id2 character varying(16),
node_id character varying(16),
tstamp timestamp(6) without time zone,
"user" character varying(50)
);



-- ----------------------------
-- REVIEW AND UPDATE DATA ON WEB/MOBILE CLIENT
-- ----------------------------

DROP TABLE IF EXISTS review_arc;
CREATE TABLE review_arc
(  arc_id character varying(16),
  the_geom geometry(MULTILINESTRING,SRID_VALUE),
  y1 numeric(12,3),
  y2 numeric(12,3),
  arc_type character varying(16),
  arccat_id character varying(30),
  annotation character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_arc_pkey PRIMARY KEY (arc_id)
);

DROP TABLE IF EXISTS review_node;
CREATE TABLE review_node
( node_id character varying(16),
  the_geom geometry(MULTIPOINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  node_type character varying(16),
  cat_matcat character varying(16),
  dimensions character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_node_pkey PRIMARY KEY (node_id)
  );
  
DROP TABLE IF EXISTS review_audit_arc;
CREATE TABLE review_audit_arc
(  arc_id character varying(16) NOT NULL,
  the_geom geometry(MULTILINESTRING,SRID_VALUE),
  y1 numeric(12,3),
  y2 numeric(12,3),
  arc_type character varying(16),
  arccat_id character varying(30),
  annotation character varying(254),
  verified character varying(16),
   moved_geom boolean,
  field_checked boolean,
  "operation" character varying(25),
  "user" varchar (50),  
  date_field timestamp (6) without time zone,
  office_checked boolean,
  CONSTRAINT review_audit_arc_pkey PRIMARY KEY (arc_id)
  );
  
DROP TABLE IF EXISTS review_audit_node;
CREATE TABLE review_audit_node
(  node_id character varying(16),
  the_geom geometry(MULTIPOINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  node_type character varying(16),
  cat_matcat character varying(16),
  dimensions character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  moved_geom boolean,
  field_checked boolean,
  "operation" character varying(25),
  "user" varchar (50),  
  date_field timestamp (6) without time zone,
  office_checked boolean,
  CONSTRAINT review_audit_node_pkey PRIMARY KEY (node_id)
  );
  
  
  
  -- ----------------------------
-- VALUE DOMAIN ON WEB/MOBILE CLIENT
-- ----------------------------
  
  CREATE TABLE config_client_dvalue
(
  id serial NOT NULL,
  table_id text,
  column_id text,
  dv_table text,
  dv_key_column text,
  dv_value_column text,
  orderby_value boolean,
  allow_null boolean,
  CONSTRAINT config_client_dvalue_pkey PRIMARY KEY (id),
  CONSTRAINT config_client_value_colum_id_fkey FOREIGN KEY (dv_table, dv_key_column)
      REFERENCES db_cat_table_x_column (db_cat_table_id, column_name) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT config_client_value_origin_id_fkey FOREIGN KEY (table_id, column_id)
      REFERENCES db_cat_table_x_column (db_cat_table_id, column_name) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
);




-- ----------------------------
-- IMPROVE VISIT STRATEGY
-- ----------------------------

CREATE TABLE om_visit_cat
(
  id serial NOT NULL,
  type character varying (18),
  short_des character varying (30),
  descript text,
  startdate date DEFAULT now(),
  enddate date,
  CONSTRAINT om_visit_cat_pkey PRIMARY KEY (id)
);



ALTER TABLE om_visit ADD COLUMN visitcat_id integer;


ALTER TABLE om_visit
  ADD CONSTRAINT om_visit_om_visit_cat_id_fkey FOREIGN KEY (visitcat_id)
      REFERENCES om_visit_cat (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT;

 
 
CREATE TABLE om_visit_event_photo
(
  id serial NOT NULL,
  visit_id bigint NOT NULL,
  event_id bigint NOT NULL,
  tstamp timestamp(6) without time zone DEFAULT now(),
  value text,
  text text,
  compass double precision,
  CONSTRAINT om_visit_event_foto_pkey PRIMARY KEY (id),
  CONSTRAINT om_visit_event_foto_event_id_fkey FOREIGN KEY (event_id)
      REFERENCES om_visit_event (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT om_visit_event_foto_visit_id_fkey FOREIGN KEY (visit_id)
      REFERENCES om_visit (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT
);

  
