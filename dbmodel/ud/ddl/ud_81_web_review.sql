/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- REVIEW AND UPDATE DATA ON WEB/MOBILE CLIENT
-- ----------------------------
	
CREATE TABLE review_arc(  
arc_id character varying(16) NOT NULL,
the_geom geometry(LINESTRING,SRID_VALUE),
y1 numeric(12,3),
y2 numeric(12,3),
arc_type character varying(18),
matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
annotation character varying(254),
observ character varying(254),
verified text,
field_checked boolean,
CONSTRAINT review_arc_pkey PRIMARY KEY (arc_id)
);



CREATE TABLE review_node( 
node_id character varying(16) NOT NULL,
the_geom geometry(POINT,SRID_VALUE),
top_elev numeric(12,3),
ymax numeric(12,3),
node_type character varying(18),
matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
annotation character varying(254),
observ character varying(254),
verified text,
field_checked boolean,
CONSTRAINT review_node_pkey PRIMARY KEY (node_id)
);
  
  

CREATE TABLE review_connec( 
connec_id character varying(16) NOT NULL,
the_geom geometry(POINT,SRID_VALUE),
y1 numeric(12,3),
y2 numeric(12,3),
arc_type character varying(18),
matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
annotation character varying(254),
observ character varying(254),
verified text,
field_checked boolean,
CONSTRAINT review_connec_pkey PRIMARY KEY (connec_id)
);
  

CREATE TABLE review_gully( 
gully_id character varying(16) NOT NULL,
the_geom geometry(POINT,SRID_VALUE),
top_elev numeric(12,3),
ymax numeric(12,3),
sandbox numeric(12,3),
matcat_id character varying(30),
gratecat_id character varying(30),
units smallint,
groove boolean,
siphon boolean,
connec_matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
featurecat_id character varying(50),
feature_id character varying(16),
annotation character varying(254),
observ character varying(254),
field_checked boolean,
CONSTRAINT review_gully_pkey PRIMARY KEY (gully_id)
);

  

CREATE TABLE review_audit_arc(
arc_id character varying(16) NOT NULL PRIMARY KEY,
the_geom geometry(LINESTRING,SRID_VALUE),
y1 numeric(12,3),
y2 numeric(12,3),
arc_type character varying(18),
matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
annotation character varying(254),
observ character varying(254),
field_checked boolean,
field_op character varying(25),
field_user varchar (50),  
field_date timestamp (6) without time zone,
field_verified character varying(16),
field_updated_geom boolean,
office_y1 numeric(12,3),
office_y2 numeric(12,3),
office_arc_type character varying(18),
office_arccat_id character varying(30),
office_updated_geom boolean,
office_checked boolean
);

  

CREATE TABLE review_audit_node(  
node_id character varying(16) NOT NULL,
the_geom geometry(POINT,SRID_VALUE),
top_elev numeric(12,3),
ymax numeric(12,3),
node_type character varying(18),
matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
annotation character varying(254),
observ character varying(254),
field_checked boolean,
field_op character varying(25),
field_user varchar (50),  
field_date timestamp (6) without time zone,
field_verified character varying(16),
field_updated_geom boolean,
office_top_elev numeric(12,3),
office_ymax numeric(12,3),
office_node_type character varying(18),
office_arccat_id character varying(30),
office_updated_geom boolean,
office_checked boolean,
CONSTRAINT review_audit_node_pkey PRIMARY KEY (node_id)
);


  

CREATE TABLE review_audit_connec(  
connec_id character varying(16) NOT NULL,
the_geom geometry(LINESTRING,SRID_VALUE),
y1 numeric(12,3),
y2 numeric(12,3),
connec_type character varying(18),
matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
annotation character varying(254),
observ character varying(254),
field_checked boolean,
field_op character varying(25),
field_user varchar (50),  
field_date timestamp (6) without time zone,
field_verified character varying(16),
field_updated_geom boolean,
office_y1 numeric(12,3),
office_y2 numeric(12,3),
office_connec_type character varying(18),
office_connecat_id character varying(30),
office_updated_geom boolean,
office_checked boolean,
CONSTRAINT review_audit_connec_pkey PRIMARY KEY (connec_id)
);




CREATE TABLE review_audit_gully(
gully_id character varying(16) NOT NULL,
the_geom geometry(POINT,SRID_VALUE),
top_elev numeric(12,3),
ymax numeric(12,3),
sandbox numeric(12,3),
matcat_id character varying(30),
gratecat_id character varying(30),
units smallint,
groove boolean,
siphon boolean,
connec_matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
featurecat_id character varying(50),
feature_id character varying(16),
annotation character varying(254),
observ character varying(254),
field_checked boolean,
field_op character varying(25),
field_user varchar (50),  
field_date timestamp (6) without time zone,
field_verified character varying(16),
field_updated_geom boolean,
office_top_elev numeric(12,3),
office_ymax numeric(12,3),
office_sandbox numeric(12,3),
office_matcat_id character varying(30),
office_gratecat_id character varying(30),
office_units smallint,
office_groove boolean,
office_siphon boolean,
office_connec_arccat_id character varying(30),
office_featurecat_id character varying(50),
office_feature_id character varying(16),
office_updated_geom boolean,
office_checked boolean,
CONSTRAINT review_audit_gully_pkey PRIMARY KEY (gully_id)
);




 