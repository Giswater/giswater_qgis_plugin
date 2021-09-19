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
ALTER TABLE temp_node RENAME nodeparent TO parent;
ALTER TABLE rpt_inp_node RENAME nodeparent TO parent;

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


-- 2021/09/18
CREATE TABLE cat_dscenario(
  dscenario_id serial NOT NULL,
  name character varying(30),
  descript text,
  parent_id integer,
  dscenario_type text,
  active boolean DEFAULT true,
  CONSTRAINT cat_dscenario_pkey PRIMARY KEY (dscenario_id));


CREATE TABLE selector_inp_dscenario(
  dscenario_id integer NOT NULL,
  cur_user text NOT NULL DEFAULT "current_user"(),
  CONSTRAINT selector_inp_dscenario_pkey PRIMARY KEY (dscenario_id, cur_user),
  CONSTRAINT inp_selector_dscenario_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT);


CREATE TABLE inp_dscenario_raingage (
  dscenario_id integer NOT NULL,
  rg_id character varying(16) NOT NULL,
  form_type character varying(12) NOT NULL,
  intvl character varying(10),
  scf numeric(12,4) DEFAULT 1.00,
  rgage_type character varying(18) NOT NULL,
  timser_id character varying(16),
  fname character varying(254),
  sta character varying(12),
  units character varying(3),
  CONSTRAINT inp_dscenario_raingage_pkey PRIMARY KEY (dscenario_id, rg_id),
  CONSTRAINT inp_dscenario_raingage_expl_id_fkey FOREIGN KEY (expl_id)
      REFERENCES exploitation (expl_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX inp_dscenario_raingage_index
  ON inp_dscenario_raingage
  USING gist
  (the_geom);


CREATE TABLE inp_dscenario_conduit(
  dscenario_id integer NOT NULL,
  arc_id character varying(50) NOT NULL,
  barrels smallint,
  culvert character varying(10),
  kentry numeric(12,4),
  kexit numeric(12,4),
  kavg numeric(12,4),
  flap character varying(3),
  q0 numeric(12,4),
  qmax numeric(12,4),
  seepage numeric(12,4),
  custom_arccat_id character varying(30),
  custom_matcat_id character varying(30),
  custom_n numeric(12,4),
  CONSTRAINT inp_dscenario_conduit_pkey PRIMARY KEY (dscenario_id, arc_id),
  CONSTRAINT inp_dscenario_conduit_arc_id_fkey FOREIGN KEY (arc_id)  REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_conduit_custom_arccat_id_fkey FOREIGN KEY (custom_arccat_id)  REFERENCES cat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_conduit_custom_matcat_id_fkey FOREIGN KEY (custom_matcat_id)  REFERENCES cat_mat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE inp_dscenario_junction(
  dscenario_id integer NOT NULL,
  node_id character varying(50) NOT NULL,
  y0 numeric(12,4),
  ysur numeric(12,4),
  apond numeric(12,4),
  outfallparam json,
  CONSTRAINT inp_dscenario_junction_pkey PRIMARY KEY (dscenario_id, node_id),
  CONSTRAINT inp_dscenario_junction_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);


ALTER TABLE selector_inp_hydrology RENAME TO _selector_inp_hydrology_;

CREATE TABLE rpt_inp_raingage(
  result_id character varying(30) NOT NULL,
  rg_id character varying(16) NOT NULL,
  form_type character varying(12) NOT NULL,
  intvl character varying(10),
  scf numeric(12,4) DEFAULT 1.00,
  rgage_type character varying(18) NOT NULL,
  timser_id character varying(16),
  fname character varying(254),
  sta character varying(12),
  units character varying(3),
  the_geom geometry(POINT,SRID_VALUE),
  expl_id integer NOT NULL,
  CONSTRAINT rpt_inp_raingage_pkey PRIMARY KEY (result_id, rg_id));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"culvert", "dataType":"character varying(10)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"kentry", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"kexit", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"kavg", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"flap", "dataType":"character varying(3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc", "column":"seepage", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"culvert", "dataType":"character varying(10)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"kentry", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"kexit", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"kavg", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"flap", "dataType":"character varying(3)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"seepage", "dataType":"numeric(12,4)", "isUtils":"False"}}$$);

