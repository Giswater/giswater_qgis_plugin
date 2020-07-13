/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/31

CREATE OR REPLACE VIEW vi_junctions AS 
SELECT distinct on (node_id) * FROM (
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev as elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM selector_inp_result,
    rpt_inp_node
     JOIN inp_junction ON inp_junction.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM selector_inp_result,
    rpt_inp_node
     JOIN inp_valve ON inp_valve.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM selector_inp_result,
    rpt_inp_node
     JOIN inp_pump ON inp_pump.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM selector_inp_result,
    rpt_inp_node
     JOIN inp_tank ON inp_tank.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM selector_inp_result,
    rpt_inp_node
     JOIN inp_inlet ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND epa_type='JUNCTION' 
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM selector_inp_result,
    rpt_inp_node
     JOIN inp_shortpipe ON inp_shortpipe.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND epa_type='JUNCTION'
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    rpt_inp_node.demand,
    rpt_inp_node.pattern_id
   FROM selector_inp_result,
    rpt_inp_node
  WHERE (rpt_inp_node.epa_type::text = ANY (ARRAY['JUNCTION'::character varying::text, 'SHORTPIPE'::character varying::text])) 
  AND rpt_inp_node.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
  ) a 
  ORDER BY 1;



DROP VIEW IF EXISTS v_ui_rpt_cat_result;
CREATE OR REPLACE VIEW v_ui_rpt_cat_result AS 
 SELECT rpt_cat_result.result_id,
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
   FROM SCHEMA_NAME.rpt_cat_result;


CREATE TRIGGER gw_trg_ui_rpt_cat_result  INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_ui_rpt_cat_result  FOR EACH ROW  EXECUTE PROCEDURE gw_trg_ui_rpt_cat_result();


DROP VIEW IF EXISTS v_edit_samplepoint;
CREATE OR REPLACE VIEW v_edit_samplepoint AS 
 SELECT samplepoint.sample_id,
    samplepoint.code,
    samplepoint.lab_code,
    samplepoint.feature_id,
    samplepoint.featurecat_id,
    samplepoint.dma_id,
    dma.macrodma_id,
    samplepoint.presszone_id,
    samplepoint.state,
    samplepoint.builtdate,
    samplepoint.enddate,
    samplepoint.workcat_id,
    samplepoint.workcat_id_end,
    samplepoint.rotation,
    samplepoint.muni_id,
    samplepoint.streetaxis_id,
    samplepoint.postnumber,
    samplepoint.postcode,
    samplepoint.district_id,
    samplepoint.streetaxis2_id,
    samplepoint.postnumber2,
    samplepoint.postcomplement,
    samplepoint.postcomplement2,
    samplepoint.place_name,
    samplepoint.cabinet,
    samplepoint.observations,
    samplepoint.verified,
    samplepoint.the_geom,
    samplepoint.expl_id,
    samplepoint.link
   FROM selector_expl,
    samplepoint
     JOIN v_state_samplepoint ON samplepoint.sample_id::text = v_state_samplepoint.sample_id::text
     LEFT JOIN dma ON dma.dma_id = samplepoint.dma_id
  WHERE samplepoint.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
