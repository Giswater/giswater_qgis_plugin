/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/18
CREATE OR REPLACE VIEW v_ui_rpt_cat_result AS 
 SELECT 
    rpt_cat_result.result_id,
    rpt_cat_result.n_junction,
    rpt_cat_result.n_reservoir,
    rpt_cat_result.n_tank,
    rpt_cat_result.n_pipe,
    rpt_cat_result.n_pump,
    rpt_cat_result.n_valve,
    rpt_cat_result.head_form,
    rpt_cat_result.hydra_time,
    rpt_cat_result.hydra_acc,
    rpt_cat_result.st_ch_freq,
    rpt_cat_result.max_tr_ch,
    rpt_cat_result.dam_li_thr,
    rpt_cat_result.max_trials,
    rpt_cat_result.q_analysis,
    rpt_cat_result.spec_grav,
    rpt_cat_result.r_kin_visc,
    rpt_cat_result.r_che_diff,
    rpt_cat_result.dem_multi,
    rpt_cat_result.total_dura,
    rpt_cat_result.exec_date,
    rpt_cat_result.q_timestep,
    rpt_cat_result.q_tolerance
   FROM rpt_cat_result;


CREATE TRIGGER gw_trg_ui_rpt_cat_result
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_ui_rpt_cat_result
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_ui_rpt_cat_result();
