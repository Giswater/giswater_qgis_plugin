/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_presszone", "column":"the_geom", "dataType":"geometry(MULTIPOLYGON, SRID_VALUE)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"sector", "column":"sector_type", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"to_arc", "dataType":"varchar(16)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_rules_x_arc", "column":"active", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_rules_x_node", "column":"active", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_rules_x_sector", "column":"active", "dataType":"boolean"}}$$);


ALTER TABLE inp_controls_x_node RENAME TO _inp_controls_x_node_;

CREATE TABLE IF NOT EXISTS inp_inlet
(
  node_id varchar(16) PRIMARY KEY,
  initlevel numeric(12,4),
  minlevel numeric(12,4),
  maxlevel numeric(12,4),
  diameter numeric(12,4),
  minvol numeric(12,4),
  curve_id character varying(16),
  pattern_id varchar (16),
  to_arc varchar (16)
  );


  CREATE TABLE IF NOT EXISTS minsector(
  minsector_id SERIAL PRIMARY KEY,
  dma_id integer,
  dqa_id integer,
  presszonecat_id varchar(30),
  sector_id integer,
  expl_id integer,
  the_geom geometry (POLYGON, SRID_VALUE)
   );
   
   
  CREATE TABLE IF NOT EXISTS minsector_graf(
  node_id varchar (16) PRIMARY KEY,
  nodecat_id varchar (30),
  minsector_1 integer,
  minsector_2 integer
    );
    
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_mincut_result_cat", "column":"notified", "dataType":"json"}}$$);


--2019/09/02
ALTER TABLE inp_typevalue_energy RENAME TO _inp_typevalue_energy_;
ALTER TABLE inp_typevalue_pump RENAME TO _inp_typevalue_pump_;
ALTER TABLE inp_typevalue_reactions_gl RENAME TO _inp_typevalue_reactions_gl_;
ALTER TABLE inp_typevalue_valve RENAME TO _inp_typevalue_valve_;
ALTER TABLE inp_value_ampm RENAME TO _inp_value_ampm_;
ALTER TABLE inp_value_curve RENAME TO _inp_value_curve_;
ALTER TABLE inp_value_mixing RENAME TO _inp_value_mixing_;
ALTER TABLE inp_value_noneall RENAME TO _inp_value_noneall_;
ALTER TABLE inp_value_opti_headloss RENAME TO _inp_value_opti_headloss_;
ALTER TABLE inp_value_opti_hyd RENAME TO _inp_value_opti_hyd_;
ALTER TABLE inp_value_opti_qual RENAME TO _inp_value_opti_qual_;
ALTER TABLE inp_value_opti_rtc_coef RENAME TO _inp_value_opti_rtc_coef_;
ALTER TABLE inp_value_opti_unbal RENAME TO _inp_value_opti_unbal_;
ALTER TABLE inp_value_opti_units RENAME TO _inp_value_opti_units_;
ALTER TABLE inp_value_opti_valvemode RENAME TO _inp_value_opti_valvemode_;
ALTER TABLE inp_value_param_energy RENAME TO _inp_value_param_energy_;
ALTER TABLE inp_value_reactions_el RENAME TO _inp_value_reactions_el_;
ALTER TABLE inp_value_reactions_gl RENAME TO _inp_value_reactions_gl_;
ALTER TABLE inp_value_status_pipe RENAME TO _inp_value_status_pipe_;
ALTER TABLE inp_value_status_pump RENAME TO _inp_value_status_pump_;
ALTER TABLE inp_value_status_valve RENAME TO _inp_value_status_valve_;
ALTER TABLE inp_value_times RENAME TO _inp_value_times_;
ALTER TABLE inp_value_yesno RENAME TO _inp_value_yesno_;
ALTER TABLE inp_reactions_el RENAME TO _inp_reactions_el_;
ALTER TABLE inp_reactions_gl RENAME TO _inp_reactions_gl_;
ALTER TABLE inp_energy_el RENAME TO _inp_energy_el_;
ALTER TABLE inp_energy_gl RENAME TO _inp_energy_gl_;


