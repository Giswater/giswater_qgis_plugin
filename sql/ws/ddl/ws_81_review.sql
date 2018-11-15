/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE TABLE review_arc (  
arc_id character varying(16) NOT NULL,
matcat_id varchar(30)  ,
pnom varchar(16)  ,
dnom varchar(16)  ,
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(LINESTRING,SRID_VALUE),
field_checked boolean,
is_validated integer,
CONSTRAINT review_arc_pkey PRIMARY KEY (arc_id)
);
 
  
CREATE TABLE review_audit_arc(  
id serial PRIMARY KEY,
arc_id character varying(16) NOT NULL,
old_matcat_id varchar(30)  ,
new_matcat_id varchar(30)  ,
old_pnom varchar(16)  ,
new_pnom varchar(16)  ,
old_dnom varchar(16)  ,
new_dnom varchar(16)  ,
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


CREATE TABLE review_node ( 
node_id character varying(16) NOT NULL,
elevation numeric(12,3),
depth numeric(12,3),
nodetype_id character varying(30),
nodecat_id character varying(30),
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(POINT,SRID_VALUE),
field_checked boolean,
is_validated integer,
CONSTRAINT review_node_pkey PRIMARY KEY (node_id)
);
  
  
CREATE TABLE review_audit_node(  
id serial PRIMARY KEY,
node_id character varying(16) NOT NULL,
old_elevation numeric(12,3),
new_elevation numeric(12,3),
old_depth numeric(12,3),
new_depth numeric(12,3),
old_nodetype_id character varying(30),
new_nodetype_id character varying(30),
old_nodecat_id character varying(30),
new_nodecat_id character varying(30),
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
connec_id character varying(16) NOT NULL,
matcat_id varchar(30)  ,
pnom varchar(16)  ,
dnom varchar(16)  ,
connectype_id character varying(30),
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(POINT,SRID_VALUE),
field_checked boolean,
is_validated integer,
CONSTRAINT review_connec_pkey PRIMARY KEY (connec_id)
);

CREATE TABLE review_audit_connec (  
id serial PRIMARY KEY,
connec_id character varying(16) NOT NULL,
old_matcat_id varchar(30)  ,
new_matcat_id varchar(30)  ,
old_pnom varchar(16)  ,
new_pnom varchar(16)  ,
old_dnom varchar(16)  ,
new_dnom varchar(16)  ,
old_connectype_id character varying(30),
new_connectype_id character varying(30),
old_connecat_id varchar(30),
new_connecat_id varchar(30),
annotation character varying(254),
observ character varying(254),
expl_id integer,
the_geom geometry(POINT,SRID_VALUE),
review_status_id smallint,
field_date timestamp (6) without time zone,
field_user text,
is_validated integer
);
