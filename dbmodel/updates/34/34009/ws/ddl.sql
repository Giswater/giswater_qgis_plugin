/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
ALTER TABLE anl_mincut_inlet_x_exploitation RENAME to config_mincut_inlet;
ALTER TABLE anl_mincut_selector_valve RENAME to config_mincut_valve;
ALTER TABLE anl_mincut_checkvalve RENAME to config_mincut_checkvalve;

ALTER TABLE anl_mincut_result_selector RENAME to selector_mincut_result ;
ALTER TABLE inp_selector_dscenario RENAME to selector_inp_demand;
ALTER TABLE rpt_selector_hourly_compare RENAME to selector_rpt_compare_tstep;
ALTER TABLE rpt_selector_hourly RENAME to selector_rpt_main_tstep;

-- remove id from selectors
ALTER TABLE selector_inp_demand DROP CONSTRAINT IF EXISTS dscenario_id_cur_user_unique;
ALTER TABLE selector_inp_demand DROP CONSTRAINT IF EXISTS inp_selector_dscenario_pkey;
ALTER TABLE selector_inp_demand ADD CONSTRAINT selector_inp_demand_pkey PRIMARY KEY(dscenario_id, cur_user);
ALTER TABLE selector_inp_demand DROP COLUMN id;

ALTER TABLE selector_mincut_result DROP CONSTRAINT IF EXISTS result_id_cur_user_unique;
ALTER TABLE selector_mincut_result DROP CONSTRAINT IF EXISTS anl_mincut_result_selector_pkey;
ALTER TABLE selector_mincut_result ADD CONSTRAINT selector_mincut_result_pkey PRIMARY KEY(result_id, cur_user);
ALTER TABLE selector_mincut_result DROP COLUMN id;

ALTER TABLE selector_rpt_compare DROP CONSTRAINT IF EXISTS rpt_selector_compare_result_id_cur_user_unique;
ALTER TABLE selector_rpt_compare DROP CONSTRAINT IF EXISTS rpt_selector_compare_pkey;
ALTER TABLE selector_rpt_compare ADD CONSTRAINT selector_rpt_compare_pkey PRIMARY KEY(result_id, cur_user);
ALTER TABLE selector_rpt_compare DROP COLUMN id;

ALTER TABLE selector_rpt_compare_tstep DROP CONSTRAINT IF EXISTS rpt_selector_result_hourly_compare_pkey;
ALTER TABLE selector_rpt_compare_tstep ADD CONSTRAINT selector_rpt_compare_tstep_pkey PRIMARY KEY("time", cur_user);
ALTER TABLE selector_rpt_compare_tstep DROP COLUMN id;

ALTER TABLE selector_rpt_main DROP CONSTRAINT IF EXISTS rpt_selector_result_id_cur_user_unique;
ALTER TABLE selector_rpt_main DROP CONSTRAINT IF EXISTS rpt_selector_result_pkey;
ALTER TABLE selector_rpt_main ADD CONSTRAINT selector_rpt_main_pkey PRIMARY KEY(result_id, cur_user);
ALTER TABLE selector_rpt_main DROP COLUMN id;

ALTER TABLE selector_rpt_main_tstep DROP CONSTRAINT IF EXISTS rpt_selector_result_hourly_pkey;
ALTER TABLE selector_rpt_main_tstep ADD CONSTRAINT selector_rpt_main_tstep_pkey PRIMARY KEY("time", cur_user);
ALTER TABLE selector_rpt_main_tstep DROP COLUMN id;

ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_cat_seq RENAME TO om_mincut_seq;
  
-- harmonize mincut
ALTER TABLE anl_mincut_cat_cause RENAME to _anl_mincut_cat_cause_;
ALTER TABLE anl_mincut_cat_class RENAME to _anl_mincut_cat_class_;
ALTER TABLE anl_mincut_cat_state RENAME to _anl_mincut_cat_state_;
ALTER TABLE anl_mincut_cat_type RENAME to om_mincut_cat_type;
ALTER TABLE anl_mincut_result_cat RENAME to om_mincut;
ALTER TABLE anl_mincut_result_arc RENAME to om_mincut_arc;
ALTER TABLE anl_mincut_result_node RENAME to om_mincut_node;
ALTER TABLE anl_mincut_result_connec RENAME to om_mincut_connec;
ALTER TABLE anl_mincut_result_hydrometer RENAME to om_mincut_hydrometer;
ALTER TABLE anl_mincut_result_polygon RENAME to om_mincut_polygon;
ALTER TABLE anl_mincut_result_valve RENAME to om_mincut_valve;
ALTER TABLE anl_mincut_result_valve_unaccess RENAME to om_mincut_valve_unaccess;


ALTER SEQUENCE SCHEMA_NAME.anl_mincut_inlet_x_exploitation_id_seq RENAME TO config_mincut_inlet_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_arc_id_seq RENAME TO om_mincut_arc_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_connec_id_seq RENAME TO om_mincut_connec_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_hydrometer_id_seq RENAME TO om_mincut_hydrometer_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_node_id_seq RENAME TO om_mincut_node_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_polygon_id_seq RENAME TO om_mincut_polygon_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_valve_id_seq RENAME TO om_mincut_valve_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_valve_unaccess_id_seq RENAME TO om_mincut_valve_unaccess_id_seq;
ALTER SEQUENCE SCHEMA_NAME.anl_mincut_result_polygon_polygon_seq RENAME TO om_mincut_polygon_polygon_seq;
