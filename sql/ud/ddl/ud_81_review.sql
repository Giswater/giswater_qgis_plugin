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
arc_id character varying(16) NOT NULL PRIMARY KEY,
y1 numeric(12,3),
y2 numeric(12,3),
arc_type character varying(18),
matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(LINESTRING,SRID_VALUE),
field_checked boolean,
is_validated integer
);


CREATE TABLE review_audit_arc (
id serial PRIMARY KEY, 
arc_id varchar(16),
old_y1 float, 
new_y1 float, 
old_y2 float, 
new_y2 float, 
old_arc_type character varying(18),
new_arc_type character varying(18),
old_matcat_id varchar (30),
new_matcat_id varchar (30),
old_shape varchar (30),
new_shape varchar (30),
old_geom1 float,
new_geom1 float,
old_geom2 float,
new_geom2 float,
old_arccat_id varchar (30),
new_arccat_id varchar (30), 
annotation text,
observ text,
expl_id integer,
the_geom geometry(LINESTRING,SRID_VALUE),
review_status_id smallint,
field_date timestamp (6) without time zone,
field_user text,
is_validated integer
);


CREATE TABLE review_node( 
node_id character varying(16) NOT NULL PRIMARY KEY,
top_elev numeric(12,3),
ymax numeric(12,3),
node_type character varying(18),
matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(POINT,SRID_VALUE),
field_checked boolean,
is_validated integer
);


CREATE TABLE review_audit_node( 
id serial PRIMARY KEY,
node_id character varying(16) NOT NULL,
old_top_elev numeric(12,3),
new_top_elev numeric(12,3),
old_ymax numeric(12,3),
new_ymax numeric(12,3),
old_node_type character varying(18),
new_node_type character varying(18),
old_matcat_id character varying(30),
new_matcat_id character varying(30),
old_shape character varying(30),
new_shape character varying(30),
old_geom1 numeric(12,3),
new_geom1 numeric(12,3),
old_geom2 numeric(12,3),
new_geom2 numeric(12,3),
old_nodecat_id varchar (30),
new_nodecat_id varchar (30), 
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(POINT,SRID_VALUE),
review_status_id smallint,
field_date timestamp (6) without time zone,
field_user text,
is_validated integer
);
  
 
  

CREATE TABLE review_connec( 
connec_id character varying(16) NOT NULL PRIMARY KEY,
y1 numeric(12,3),
y2 numeric(12,3),
connec_type character varying(18),
matcat_id character varying(30),
shape character varying(30),
geom1 numeric(12,3),
geom2 numeric(12,3),
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(POINT,SRID_VALUE),
field_checked boolean,
is_validated integer
);
 
 
CREATE TABLE review_audit_connec( 
id serial PRIMARY KEY,
connec_id character varying(16) NOT NULL,
old_y1 numeric(12,3),
new_y1 numeric(12,3),
old_y2 numeric(12,3),
new_y2 numeric(12,3),
old_connec_type character varying(18),
new_connec_type character varying(18),
old_matcat_id character varying(30),
new_matcat_id character varying(30),
old_shape character varying(30),
new_shape character varying(30),
old_geom1 numeric(12,3),
new_geom1 numeric(12,3),
old_geom2 numeric(12,3),
new_geom2 numeric(12,3),
old_connecat_id varchar (30),
new_connecat_id varchar (30), 
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(POINT,SRID_VALUE),
review_status_id smallint,
field_date timestamp (6) without time zone,
field_user text,
is_validated integer
);
  
 

CREATE TABLE review_gully( 
gully_id character varying(16) NOT NULL PRIMARY KEY,
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
connec_shape character varying(30),
connec_geom1 numeric(12,3),
connec_geom2 numeric(12,3),
connec_arccat_id character varying(18),
featurecat_id character varying(50),
feature_id character varying(16),
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(POINT,SRID_VALUE),
field_checked boolean,
is_validated integer
);



CREATE TABLE review_audit_gully( 
id serial PRIMARY KEY,
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
old_connec_shape character varying(30),
new_connec_shape character varying(30),
old_connec_geom1 numeric(12,3),
new_connec_geom1 numeric(12,3),
old_connec_geom2 numeric(12,3),
new_connec_geom2 numeric(12,3),
old_connec_arccat_id character varying(18),
new_connec_arccat_id character varying(18),
old_featurecat_id character varying(50),
new_featurecat_id character varying(50),
old_feature_id character varying(16),
new_feature_id character varying(16),
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(POINT,SRID_VALUE),
review_status_id smallint,
field_date timestamp (6) without time zone,
field_user text,
is_validated integer
);