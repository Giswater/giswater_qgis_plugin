/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE TABLE review_arc (  
arc_id character varying(16) NOT NULL,
the_geom geometry(LINESTRING,SRID_VALUE),
matcat_id varchar(30)  ,
pnom varchar(16)  ,
dnom varchar(16)  ,
annotation character varying(254),
observ character varying(254),
verified text,
field_checked boolean,
CONSTRAINT review_arc_pkey PRIMARY KEY (arc_id)
);


CREATE TABLE review_node ( 
node_id character varying(16) NOT NULL,
the_geom geometry(POINT,SRID_VALUE),
elevation numeric(12,3),
depth numeric(12,3),
from_plot numeric(12,3),
nodetype_id character varying(30),
nodecat_id character varying(30),
annotation character varying(254),
observ character varying(254),
verified text,
field_checked boolean,
CONSTRAINT review_node_pkey PRIMARY KEY (node_id)
);


CREATE TABLE review_connec( 
connec_id character varying(16) NOT NULL,
the_geom geometry(POINT,SRID_VALUE),
matcat_id varchar(30)  ,
pnom varchar(16)  ,
dnom varchar(16)  ,
annotation character varying(254),
observ character varying(254),
verified text,
field_checked boolean,
CONSTRAINT review_connec_pkey PRIMARY KEY (connec_id)
);
  
  
  
CREATE TABLE review_audit_arc(  
arc_id character varying(16) NOT NULL,
the_geom geometry(LINESTRING,SRID_VALUE),
matcat_id varchar(30)  ,
pnom varchar(16)  ,
dnom varchar(16)  ,
annotation character varying(254),
observ character varying(254),
field_checked boolean,
field_op character varying(25),
field_user varchar (50),  
field_date timestamp (6) without time zone,
field_verified character varying(16),
field_updated_geom boolean,
office_arccat_id character varying(30),
office_updated_geom boolean,
office_checked boolean,
CONSTRAINT review_audit_arc_pkey PRIMARY KEY (arc_id)
);
  
  
CREATE TABLE audit_review_node(  
node_id character varying(16) NOT NULL,
the_geom geometry(POINT,SRID_VALUE),
elevation numeric(12,3),
depth numeric(12,3),
from_plot numeric(12,3),
nodetype_id character varying(30),
nodecat_id character varying(30),
annotation character varying(254),
observ character varying(254),
field_checked boolean,
field_op character varying(25),
field_user varchar (50),  
field_date timestamp (6) without time zone,
field_verified character varying(16),
field_updated_geom boolean,
office_elevation numeric(12,3),
office_depth numeric(12,3),
office_from_plot numeric(12,3),
office_nodetype_id character varying(30),
office_nodecat_id character varying(30),
office_updated_geom boolean,
office_checked boolean,
CONSTRAINT audit_review_node_pkey PRIMARY KEY (node_id)
);
  
  
CREATE TABLE review_audit_connec (  
connec_id character varying(16) NOT NULL,
the_geom geometry(POINT,SRID_VALUE),
matcat_id varchar(30)  ,
pnom varchar(16)  ,
dnom varchar(16)  ,
annotation character varying(254),
observ character varying(254),
field_checked boolean,
field_op character varying(25),
field_user varchar (50),  
field_date timestamp (6) without time zone,
field_verified character varying(16),
field_updated_geom boolean,
office_arccat_id character varying(30),
office_updated_geom boolean,
office_checked boolean,
CONSTRAINT review_audit_connec_pkey PRIMARY KEY (connec_id)
);
