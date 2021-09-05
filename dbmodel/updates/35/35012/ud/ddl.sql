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
outlet_depth double precision,
y0 double precision,
ysur double precision,
custom_n double precision,
custom_length double precision,
q0 double precision,
qmax double precision,
flap varchar(3));

CREATE TABLE temp_gully (
gully_id character varying(16),
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
link_length double precision,
shape double precision,
n double precision,
z1 double precision,
z2 double precision,
geom1 double precision,
geom2 double precision,
geom3 double precision,
geom4 double precision,
q0 double precision,
qmax double precision,
flap varchar(3),

the_geom geometry(LineString,SRID_VALUE));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"connec_matcat_id", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"gratecat2_id", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_conduit", "column":"inlet_offset", "dataType":"double precision", "isUtils":"False"}}$$);