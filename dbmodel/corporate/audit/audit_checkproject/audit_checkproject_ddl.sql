/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


/*
-- to run use initProject=false and isAudit=true

SELECT SCHEMA_NAME.gw_fct_setcheckproject ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"initProject":false, "isAudit":true}}$$);
*/

CREATE TABLE audit.audit_fid_log
(
  id bigserial NOT NULL PRIMARY KEY,
  fid smallint,
  fcount integer,
  groupby text,
  criticity integer,
  tstamp timestamp without time zone DEFAULT now(),
  source json
);


CREATE TABLE audit.anl_arc
(
  id bigserial NOT NULL PRIMARY KEY,
  arc_id character varying(16) NOT NULL,
  arccat_id character varying(30),
  state integer,
  arc_id_aux character varying(16),
  expl_id integer,
  fid integer NOT NULL,
  cur_user character varying(30) NOT NULL DEFAULT "current_user"(),
  the_geom geometry(LineString,SRID_VALUE),
  the_geom_p geometry(Point,SRID_VALUE),
  descript text,
  result_id character varying(16),
  node_1 character varying(16),
  node_2 character varying(16),
  sys_type character varying(30),
  code character varying(30),
  cat_geom1 double precision,
  length double precision,
  slope double precision,
  total_length numeric(12,3),
  z1 double precision,
  z2 double precision,
  y1 double precision,
  y2 double precision,
  elev1 double precision,
  elev2 double precision,
  losses numeric(12,4),
  tstamp timestamp DEFAULT now(),
  source json
);



CREATE TABLE audit.anl_node
(
  id bigserial NOT NULL PRIMARY KEY,
  node_id character varying(16) NOT NULL,
  nodecat_id character varying(30),
  state integer,
  num_arcs integer,
  node_id_aux character varying(16),
  nodecat_id_aux character varying(30),
  state_aux integer,
  expl_id integer,
  fid integer NOT NULL,
  cur_user character varying(30) NOT NULL DEFAULT "current_user"(),
  the_geom geometry(Point,SRID_VALUE),
  arc_distance numeric(12,3),
  arc_id character varying(16),
  descript text,
  result_id character varying(16),
  total_distance numeric(12,3),
  sys_type character varying(30),
  code character varying(30),
  cat_geom1 double precision,
  elevation double precision,
  elev double precision,
  depth double precision,
  state_type integer,
  sector_id integer,
  losses numeric(12,4),
  tstamp timestamp DEFAULT now(),
  source json
);



CREATE INDEX anl_node_fprocesscat_id_index
  ON audit.anl_node
  USING btree
  (fid);

CREATE INDEX anl_node_index
  ON audit.anl_node
  USING gist
  (the_geom);

CREATE INDEX anl_node_node_id_index
  ON audit.anl_node
  USING btree
  (node_id COLLATE pg_catalog."default");
  
CREATE INDEX anl_arc_arc_id
  ON audit.anl_arc
  USING btree
  (arc_id COLLATE pg_catalog."default");

CREATE INDEX anl_arc_index
  ON audit.anl_arc
  USING gist
  (the_geom);

