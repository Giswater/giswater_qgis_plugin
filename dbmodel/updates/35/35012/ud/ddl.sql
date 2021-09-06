/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/08/19
ALTER TABLE selector_inp_hydrology ALTER COLUMN cur_user SET DEFAULT "current_user"();

--2021/09/05
ALTER TABLE cat_grate RENAME efective_area TO effective_area;

--2021/08/19
CREATE TABLE inp_gully(
gully_id character varying(16) PRIMARY KEY,
isepa boolean,
efficiency double precision,
y0 double precision,
ysur double precision,
custom_n double precision,
custom_length double precision,
q0 double precision,
qmax double precision,
flap varchar(3));


CREATE TABLE temp_gully (
gully_id character varying(16) PRIMARY KEY,
gully_type character varying(30),
gratecat_id character varying(30),
sector_id integer,
state smallint,
state_type smallint,
top_elev double precision,
elev double precision,
sandbox double precision,
units integer,
groove boolean,
annotation character varying(254),
xcoord double precision,
ycoord double precision,
y0 double precision,
ysur double precision,

grate_length double precision,
grate_width double precision,
total_area double precision,
effective_area double precision,
efficiency double precision,
n_barr_l double precision,
n_barr_w double precision,
n_barr_diag double precision,
a_param double precision,
b_param double precision,

pjoint_id character varying(30),
pjoint_type character varying(30),
link_length double precision,
shape text,
n double precision,
y1 double precision,
y2 double precision,
geom1 double precision,
geom2 double precision,
geom3 double precision,
geom4 double precision,
q0 double precision,
qmax double precision,
flap varchar(3),

the_geom geometry(Point,SRID_VALUE));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"connec_matcat_id", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"connec_y2", "dataType":"numeric(12,3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"gratecat2_id", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_node", "column":"fusioned_node", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_node", "column":"fusioned_node", "dataType":"text", "isUtils":"False"}}$$);


ALTER TABLE temp_go2epa RENAME TO _temp_go2epa_;
DROP INDEX temp_go2epa_arc_id;

ALTER TABLE temp_arc ALTER result_id DROP NOT NULL;
ALTER TABLE temp_node ALTER result_id DROP NOT NULL;

CREATE TABLE temp_go2epa (
  id serial NOT NULL,
  arc_id character varying(20),
  vnode_id character varying(20),
  locate double precision,
  top_elev double precision,
  ymax double precision,
   idmin integer
);
CREATE INDEX temp_go2epa_arc_id  ON temp_go2epa
  USING btree (arc_id COLLATE pg_catalog."default");