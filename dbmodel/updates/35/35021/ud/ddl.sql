/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/29
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"sector_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"log", "dataType":"text", "isUtils":"False"}}$$);

DROP VIEW vi_options;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_param_user", "column":"epaversion", "dataType":"text", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_hydrology", "column":"expl_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dwf_scenario", "column":"expl_id", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_hydrology", "column":"log", "dataType":"text", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_dwf_scenario", "column":"log", "dataType":"text", "isUtils":"False"}}$$);


ALTER TABLE cat_hydrology DROP CONSTRAINT IF EXISTS cat_hydrology_expl_id_fkey;
ALTER TABLE cat_hydrology ADD CONSTRAINT cat_hydrology_expl_id_fkey FOREIGN KEY (expl_id) 
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_dwf_scenario DROP CONSTRAINT IF EXISTS cat_dwf_scenario_expl_id_fkey;
ALTER TABLE cat_dwf_scenario ADD CONSTRAINT cat_dwf_scenario_expl_id_fkey FOREIGN KEY (expl_id) 
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT IF EXISTS inp_dscenario_conduit_dscenario_id_fkey;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_junction DROP CONSTRAINT IF EXISTS inp_dscenario_junction_dscenario_id_fkey;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dscenario_raingage DROP CONSTRAINT IF EXISTS iinp_dscenario_raingage_dscenario_id_fkey;
ALTER TABLE inp_dscenario_raingage ADD CONSTRAINT iinp_dscenario_raingage_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_orifice", "column":"close_time", "dataType":"integer", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_weir", "column":"road_width", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_weir", "column":"road_surf", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_weir", "column":"coef_curve", "dataType":"float", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_subcatchment", "column":"nperv_pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_subcatchment", "column":"dstore_pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_subcatchment", "column":"infil_pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);




CREATE TABLE inp_dscenario_outfall (
 dscenario_id integer,
 node_id character varying(16) NOT NULL,
  outfall_type character varying(16),
  stage numeric(12,4),
  curve_id character varying(16),
  timser_id character varying(16),
  gate character varying(3),
  CONSTRAINT inp_dscenario_outfall_pkey PRIMARY KEY (dscenario_id,node_id),
  CONSTRAINT inp_dscenario_outfall_curve_id_fkey FOREIGN KEY (curve_id)
      REFERENCES ud_sample_bk_0.inp_curve (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_outfall_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_outfall_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_outfall_timser_id_fkey FOREIGN KEY (timser_id)
      REFERENCES ud_sample_bk_0.inp_timeseries (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE inp_dscenario_storage (
 dscenario_id integer,
node_id character varying(50) NOT NULL,
  storage_type character varying(18),
  curve_id character varying(16),
  a1 numeric(12,4),
  a2 numeric(12,4),
  a0 numeric(12,4),
  fevap numeric(12,4),
  sh numeric(12,4),
  hc numeric(12,4),
  imd numeric(12,4),
  y0 numeric(12,4),
  ysur numeric(12,4),
  apond numeric(12,4),
  CONSTRAINT inp_storage_pkey PRIMARY KEY (dscenario_id, node_id),
  CONSTRAINT inp_storage_curve_id_fkey FOREIGN KEY (curve_id)
      REFERENCES ud_sample_bk_0.inp_curve (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_storage_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_storage_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE



CREATE TABLE inp_dscenario_divider ( );
dscenario_id integer,
node_id character varying(50) NOT NULL,
  divider_type character varying(18),
  arc_id character varying(50),
  curve_id character varying(16),
  qmin numeric(16,6),
  ht numeric(12,4),
  cd numeric(12,4),
  y0 numeric(12,4),
  ysur numeric(12,4),
  apond numeric(12,4),
  CONSTRAINT inp_divider_pkey PRIMARY KEY (dscenario_id, node_id),
  CONSTRAINT inp_divider_arc_id_fkey FOREIGN KEY (arc_id)
      REFERENCES ud_sample_bk_0.arc (arc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_divider_curve_id_fkey FOREIGN KEY (curve_id)
      REFERENCES ud_sample_bk_0.inp_curve (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT inp_dscenario_divider_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_divider_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE



CREATE TABLE inp_dscenario_flwreg_weir (
id serial NOT NULL,
 dscenario_id integer,
  node_id character varying(16) NOT NULL,
  to_arc character varying(16) NOT NULL,
  flwreg_id smallint NOT NULL,
  flwreg_length double precision NOT NULL,
  weir_type character varying(18) NOT NULL,
  "offset" numeric(12,4),
  cd numeric(12,4),
  ec numeric(12,4),
  cd2 numeric(12,4),
  flap character varying(3),
  geom1 numeric(12,4),
  geom2 numeric(12,4) DEFAULT 0.00,
  geom3 numeric(12,4) DEFAULT 0.00,
  geom4 numeric(12,4) DEFAULT 0.00,
  surcharge character varying(3),
  road_width float,
  road_surf character varying(16),
  coef_curve float,
  CONSTRAINT inp_dscenario_flwreg_weir_pkey PRIMARY KEY (id),
  CONSTRAINT inp_dscenario_flwreg_weir_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_flwreg_weir_to_arc_fkey FOREIGN KEY (to_arc)
      REFERENCES ud_sample_bk_0.arc (arc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_flwreg_weir_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_flwreg_weir_unique UNIQUE (node_id, to_arc, flwreg_id),
  CONSTRAINT inp_dscenario_flwreg_weir_check CHECK (flwreg_id = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9])),
  CONSTRAINT inp_dscenario_flwreg_weir_check_type CHECK (weir_type::text = ANY (ARRAY['SIDEFLOW'::text, 'TRANSVERSE'::text, 'V-NOTCH'::text, 'TRAPEZOIDAL_WEIR'::text])));




CREATE TABLE inp_dscenario_flwreg_pump (
id serial NOT NULL,
  dscenario_id integer,
  node_id character varying(16) NOT NULL,
  to_arc character varying(16) NOT NULL,
  flwreg_id smallint NOT NULL,
  flwreg_length double precision NOT NULL,
  curve_id character varying(16) NOT NULL,
  status character varying(3),
  startup numeric(12,4),
  shutoff numeric(12,4),
  CONSTRAINT inp_flwreg_pump_pkey PRIMARY KEY (id),
  CONSTRAINT inp_flwreg_pump_curve_id_fkey FOREIGN KEY (curve_id)
      REFERENCES ud_sample_bk_0.inp_curve (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_flwreg_pump_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_flwreg_pump_to_arc_fkey FOREIGN KEY (to_arc)
      REFERENCES ud_sample_bk_0.arc (arc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT inp_dscenario_flwreg_pump_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_flwreg_pump_unique UNIQUE (node_id, to_arc, flwreg_id),
  CONSTRAINT inp_flwreg_pump_check CHECK (flwreg_id = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9])),
  CONSTRAINT inp_flwreg_pump_check_status CHECK (status::text = ANY (ARRAY['ON'::character varying, 'OFF'::character varying]::text[]))
  );




CREATE TABLE inp_dscenario_flwreg_orifice ( 
  id serial NOT NULL,
  dscenario_id integer,
  node_id character varying(16) NOT NULL,
  to_arc character varying(16) NOT NULL,
  flwreg_id smallint NOT NULL,
  flwreg_length double precision NOT NULL,
  ori_type character varying(18) NOT NULL,
  "offset" numeric(12,4),
  cd numeric(12,4) NOT NULL,
  orate numeric(12,4),
  flap character varying(3) NOT NULL,
  shape character varying(18) NOT NULL,
  geom1 numeric(12,4) NOT NULL,
  geom2 numeric(12,4) NOT NULL DEFAULT 0.00,
  geom3 numeric(12,4) DEFAULT 0.00,
  geom4 numeric(12,4) DEFAULT 0.00,
  close_time integer DEFAULT 0,
CONSTRAINT inp_dscenario_flwreg_orifice_pkey PRIMARY KEY (id),
  CONSTRAINT inp_dscenario_flwreg_orifice_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_flwreg_orifice_to_arc_fkey FOREIGN KEY (to_arc)
      REFERENCES ud_sample_bk_0.arc (arc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_flwreg_orifice_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_flwreg_orifice_unique UNIQUE (node_id, to_arc, flwreg_id),
  CONSTRAINT inp_dscenario_flwreg_orifice_check CHECK (flwreg_id = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9])),
  CONSTRAINT inp_dscenario_flwreg_orifice_check_ory_type CHECK (ori_type::text = ANY (ARRAY['SIDE'::character varying, 'BOTTOM'::character varying]::text[])),
  CONSTRAINT inp_dscenario_flwreg_orifice_check_shape CHECK (shape::text = ANY (ARRAY['CIRCULAR'::character varying, 'RECT-CLOSED'::character varying]::text[])));
  
  
CREATE TABLE inp_dscenario_flwreg_outlet ( );
id serial NOT NULL,
dscenario_id integer, 
  node_id character varying(16) NOT NULL,
  to_arc character varying(16) NOT NULL,
  flwreg_id smallint NOT NULL,
  flwreg_length double precision NOT NULL,
  outlet_type character varying(16) NOT NULL,
  "offset" numeric(12,4),
  curve_id character varying(16),
  cd1 numeric(12,4),
  cd2 numeric(12,4),
  flap character varying(3),
  CONSTRAINT inp_flwreg_outlet_pkey PRIMARY KEY (id),
  CONSTRAINT inp_flwreg_outlet_curve_id_fkey FOREIGN KEY (curve_id)
      REFERENCES ud_sample_bk_0.inp_curve (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_flwreg_outlet_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_flwreg_outlet_to_arc_fkey FOREIGN KEY (to_arc)
      REFERENCES ud_sample_bk_0.arc (arc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_dscenario_flwreg_outlet_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_flwreg_outlet_unique UNIQUE (node_id, to_arc, flwreg_id),
  CONSTRAINT inp_flwreg_outlet_check CHECK (flwreg_id = ANY (ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9])),
  CONSTRAINT inp_flwreg_outlet_check_type CHECK (outlet_type::text = ANY (ARRAY['FUNCTIONAL/DEPTH'::character varying, 'FUNCTIONAL/HEAD'::character varying, 'TABULAR/DEPTH'::character varying, 'TABULAR/HEAD'::character varying]::text[]))
);



CREATE TABLE inp_dscenario_inflows (
 id serial,
  dscenario_id integer,
  node_id character varying(50),
  timser_id character varying(16),
  format_type text,
  mfactor numeric(12,4),
  sfactor numeric(12,4),
  base numeric(12,4),
  pattern_id character varying(16),
  CONSTRAINT inp_inflows_pkey2 PRIMARY KEY (id),
  CONSTRAINT inp_inflows_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT inp_inflows_pattern_id_fkey FOREIGN KEY (pattern_id)
      REFERENCES ud_sample_bk_0.inp_pattern (pattern_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
   CONSTRAINT inp_dscenario_inflows_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);



CREATE TABLE ud_sample_bk_0.inp_inflows_pol_x_node
(
  dscenario_id integer,
  poll_id character varying(16) NOT NULL,
  node_id character varying(50) NOT NULL,
  timser_id character varying(16),
  form_type character varying(18),
  mfactor numeric(12,4),
  sfactor numeric(12,4),
  base numeric(12,4),
  pattern_id character varying(16),
  CONSTRAINT inp_inflows_pol_x_node_pkey PRIMARY KEY (dscenario_id, poll_id, node_id),
  CONSTRAINT inp_inflows_pol_x_node_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_inflows_pol_x_node_pattern_id_fkey FOREIGN KEY (pattern_id)
      REFERENCES ud_sample_bk_0.inp_pattern (pattern_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT inp_inflows_pol_x_node_poll_id_fkey FOREIGN KEY (poll_id)
      REFERENCES ud_sample_bk_0.inp_pollutant (poll_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_inflows_pol_x_node_timser_id_fkey FOREIGN KEY (timser_id)
      REFERENCES ud_sample_bk_0.inp_timeseries (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE   
   CONSTRAINT inp_dscenario_inflows_pol_x_node_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);




CREATE TABLE inp_dscenario_treatment_node_x_pol
 (
  dscenario_id integer,
  node_id character varying(50) NOT NULL,
  poll_id character varying(16),
  function character varying(100),
  CONSTRAINT inp_treatment_node_x_pol_pkey PRIMARY KEY (node_id),
  CONSTRAINT inp_treatment_node_x_pol_node_id_fkey FOREIGN KEY (node_id)
      REFERENCES ud_sample_bk_0.node (node_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_treatment_node_x_pol_poll_id_fkey FOREIGN KEY (poll_id)
      REFERENCES ud_sample_bk_0.inp_pollutant (poll_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE, 
  CONSTRAINT inp_dscenario_treatment_node_x_pol_dscenario_id_fkey FOREIGN KEY (dscenario_id)
      REFERENCES ud_sample_bk_0.cat_dscenario (dscenario_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE);


ALTER TABLE inp_hydrograph RENAME TO inp_hydrograph_value;
ALTER TABLE inp_hydrograph_id RENAME TO inp_hydrograph;

ALTER TABLE inp_treatment_node_x_pol RENAME TO inp_treatment;

ALTER TABLE inp_washoff_land_x_pol RENAME TO inp_washoff;
ALTER TABLE inp_buildup_land_x_pol RENAME TO inp_buildup;


ALTER TABLE inp_coverage_land_x_subc RENAME TO inp_coverage;
ALTER TABLE inp_loadings_pol_x_subc RENAME TO inp_loadings;



