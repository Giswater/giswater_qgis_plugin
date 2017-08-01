/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- REVIEW AND UPDATE DATA ON WEB/MOBILE CLIENT
-- ----------------------------
	
DROP TABLE IF EXISTS review_arc;
CREATE TABLE review_arc
(  arc_id character varying(16) NOT NULL,
  the_geom geometry(LINESTRING,SRID_VALUE),
  y1 numeric(12,3),
  y2 numeric(12,3),
  arc_type character varying(18),
  arccat_id character varying(30),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_arc_pkey PRIMARY KEY (arc_id)
);

DROP TABLE IF EXISTS review_node;
CREATE TABLE review_node
( node_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  node_type character varying(18),
  nodecat_id character varying(30),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_node_pkey PRIMARY KEY (node_id)
  );
  
DROP TABLE IF EXISTS review_connec;
CREATE TABLE review_connec
( connec_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  connec_type character varying(18),
  connecat_id character varying(30),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_connec_pkey PRIMARY KEY (connec_id)
  );
  
DROP TABLE IF EXISTS review_gully;
CREATE TABLE review_gully
( gully_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  matcat_id character varying(30),
  gratecat_id character varying(30),
  units smallint,
  groove character varying(3),
  arccat_id character varying(30),
  arc_id character varying(16),
  siphon character varying(3),
  featurecat_id character varying(50),
  feature_id character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  field_checked boolean,
  office_checked boolean,
  CONSTRAINT review_gully_pkey PRIMARY KEY (gully_id)
  );
  
DROP TABLE IF EXISTS review_audit_arc;
CREATE TABLE review_audit_arc
(  arc_id character varying(16) NOT NULL,
  the_geom geometry(LINESTRING,SRID_VALUE),
  y1 numeric(12,3),
  y2 numeric(12,3),
  arc_type character varying(18),
  arccat_id character varying(30),
  annotation character varying(254),
  observ character varying(254),
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
(  node_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  node_type character varying(18),
  nodecat_id character varying(30),
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
  
DROP TABLE IF EXISTS review_audit_connec;
CREATE TABLE review_audit_connec
(  connec_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  connec_type character varying(18),
  connecat_id character varying(30),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  moved_geom boolean,
  field_checked boolean,
  "operation" character varying(25),
  "user" varchar (50),  
  date_field timestamp (6) without time zone,
  office_checked boolean,
  CONSTRAINT review_audit_connec_pkey PRIMARY KEY (connec_id)
  );

 DROP TABLE IF EXISTS  review_audit_gully;
 CREATE TABLE review_audit_gully
(  gully_id character varying(16) NOT NULL,
  the_geom geometry(POINT,SRID_VALUE),
  top_elev numeric(12,3),
  ymax numeric(12,3),
  matcat_id character varying(30),
  gratecat_id character varying(30),
  units smallint,
  groove character varying(3),
  arccat_id character varying(30),
  arc_id character varying(16),
  siphon character varying(3),
  featurecat_id character varying(50),
  feature_id character varying(16),
  annotation character varying(254),
  observ character varying(254),
  verified character varying(16),
  moved_geom boolean,
  field_checked boolean,
  "operation" character varying(25),
  "user" varchar (50),  
  date_field timestamp (6) without time zone,
  office_checked boolean,
  CONSTRAINT review_audit_gully_pkey PRIMARY KEY (gully_id)
  );




 