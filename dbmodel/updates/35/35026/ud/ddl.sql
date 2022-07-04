/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/11
ALTER TABLE cat_feature_gully ADD COLUMN epa_default character varying(30);
UPDATE cat_feature_gully SET epa_default = 'GULLY';
ALTER TABLE cat_feature_gully ALTER COLUMN epa_default SET NOT NULL;
ALTER TABLE cat_feature_gully ALTER COLUMN epa_default SET DEFAULT 'GULLY'::character varying;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"epa_type", "dataType":"character varying(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"groove_height", "dataType":"double precision", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"groove_length", "dataType":"double precision", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"gully", "column":"units_placement", "dataType":"character varying(16)", "isUtils":"False"}}$$);

UPDATE gully SET epa_type ='GULLY';
ALTER TABLE gully ALTER COLUMN epa_type SET NOT NULL;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_netgully", "column":"gratecat2_id", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_netgully", "column":"groove_height", "dataType":"double precision", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_netgully", "column":"groove_length", "dataType":"double precision", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_netgully", "column":"units_placement", "dataType":"character varying(16)", "isUtils":"False"}}$$);

ALTER TABLE inp_gully RENAME to _inp_gully_;
ALTER TABLE _inp_gully_ DROP CONSTRAINT inp_gully_pkey;
ALTER TABLE _inp_gully_ DROP CONSTRAINT inp_gully_gully_id_fkey;


CREATE TABLE inp_netgully (
  node_id character varying(16) NOT NULL,
  y0 numeric(12,4),
  ysur numeric(12,4),
  apond numeric(12,4),
  outlet_type varchar(30),
  custom_width double precision,
  custom_length double precision,
  custom_depth double precision,
  method varchar(30),
  weir_cd  double precision,
  orifice_cd  double precision,
  custom_a_param  double precision,
  custom_b_param  double precision,
  efficiency double precision,
  CONSTRAINT inp_netgully_pkey PRIMARY KEY (node_id),
  CONSTRAINT inp_netgully_gully_id_fkey FOREIGN KEY (node_id)
      REFERENCES node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE inp_gully(
  gully_id character varying(16) NOT NULL,
  outlet_type varchar(30),
  custom_top_elev double precision,
  custom_width double precision,
  custom_length double precision,
  custom_depth double precision,
  method varchar(30),
  weir_cd  double precision,
  orifice_cd  double precision,
  custom_a_param  double precision,
  custom_b_param  double precision,
  efficiency double precision,
  CONSTRAINT inp_gully_pkey PRIMARY KEY (gully_id),
  CONSTRAINT inp_gully_gully_id_fkey FOREIGN KEY (gully_id)
      REFERENCES gully (gully_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


DROP VIEW vi_grate;
DROP VIEW vi_gully;
DROP VIEW vi_lxsections;
DROP VIEW vi_gully2pjoint;
DROP VIEW vi_link;

DROP TABLE temp_gully;
CREATE TABLE temp_gully(
  gully_id character varying(16) NOT NULL,
  gully_type character varying(30),
  gratecat_id character varying(30),
  arc_id varchar(16),
  node_id varchar(16),
  sector_id integer,
  state smallint,
  state_type smallint,
  top_elev double precision,
  units integer,
  units_placement varchar(16),
  outlet_type varchar(30),
  width double precision,
  length double precision,
  depth double precision,
  method varchar(30),
  weir_cd  double precision,
  orifice_cd  double precision,
  a_param  double precision,
  b_param  double precision,
  efficiency integer,
  the_geom geometry(Point,SRID_VALUE),
  CONSTRAINT temp_gully_pkey PRIMARY KEY (gully_id)
);


ALTER TABLE inp_pattern_value DROP CONSTRAINT inp_pattern_value_pkey;
ALTER TABLE inp_pattern_value ADD CONSTRAINT inp_pattern_value_pkey PRIMARY KEY(pattern_id);
DROP VIEW IF EXISTS v_edit_inp_pattern_value;
DROP VIEW IF EXISTS vi_patterns;
ALTER TABLE inp_pattern_value DROP column id;