/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_inp_subcatch2node AS
 SELECT s1.subc_id,
        CASE
            WHEN s2.the_geom IS NOT NULL THEN st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))
            ELSE st_makeline(st_centroid(s1.the_geom), v_node.the_geom)
        END AS the_geom
   FROM v_edit_subcatchment s1
     LEFT JOIN v_edit_subcatchment s2 ON s2.subc_id::text = s1.outlet_id::text
     LEFT JOIN v_node ON v_node.node_id::text = s1.outlet_id::text;

	 

CREATE OR REPLACE VIEW vi_options AS 
SELECT a.idval AS parameter,
    b.value
   FROM audit_cat_param_user a
     JOIN config_param_user b ON a.id = b.parameter::text
  WHERE (a.layoutname = ANY (ARRAY['grl_general_1'::text, 'grl_general_2'::text, 'grl_hyd_3'::text, 'grl_hyd_4'::text, 
  'grl_date_13'::text, 'grl_date_14'::text])) AND b.cur_user::name = "current_user"() AND (a.epaversion::json ->> 'from'::text) = '5.0.022'::text AND b.value IS NOT NULL AND a.idval IS NOT NULL
UNION
 SELECT 'INFILTRATION'::text AS parameter,
    cat_hydrology.infiltration AS value
   FROM inp_selector_hydrology,
    cat_hydrology
  WHERE inp_selector_hydrology.cur_user = "current_user"()::text;
  

CREATE OR REPLACE VIEW v_rpt_comp_storagevol_sum AS 
 SELECT rpt_storagevol_sum.id,
    rpt_storagevol_sum.result_id,
    rpt_storagevol_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_storagevol_sum.aver_vol,
    rpt_storagevol_sum.avg_full,
    rpt_storagevol_sum.ei_loss,
    rpt_storagevol_sum.max_vol,
    rpt_storagevol_sum.max_full,
    rpt_storagevol_sum.time_days,
    rpt_storagevol_sum.time_hour,
    rpt_storagevol_sum.max_out,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_compare,
    rpt_inp_node
     JOIN rpt_storagevol_sum ON rpt_storagevol_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_storagevol_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text;

  
CREATE OR REPLACE VIEW v_rpt_comp_outfallflow_sum AS 
 SELECT rpt_outfallflow_sum.id,
    rpt_outfallflow_sum.result_id,
    rpt_outfallflow_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallflow_sum.flow_freq,
    rpt_outfallflow_sum.avg_flow,
    rpt_outfallflow_sum.max_flow,
    rpt_outfallflow_sum.total_vol,
    rpt_inp_node.the_geom,
    rpt_inp_node.sector_id
   FROM rpt_selector_compare,
    rpt_inp_node
     JOIN rpt_outfallflow_sum ON rpt_outfallflow_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_outfallflow_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_compare.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_comp_outfallload_sum AS 
 SELECT rpt_outfallload_sum.id,
    rpt_outfallload_sum.result_id,
    rpt_outfallload_sum.poll_id,
    rpt_outfallload_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallload_sum.value,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_compare,
    rpt_inp_node
     JOIN rpt_outfallload_sum ON rpt_outfallload_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_outfallload_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_compare.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_comp_nodedepth_sum AS 
 SELECT rpt_nodedepth_sum.id,
    rpt_nodedepth_sum.result_id,
    rpt_nodedepth_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodedepth_sum.swnod_type,
    rpt_nodedepth_sum.aver_depth,
    rpt_nodedepth_sum.max_depth,
    rpt_nodedepth_sum.max_hgl,
    rpt_nodedepth_sum.time_days,
    rpt_nodedepth_sum.time_hour,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_compare,
    rpt_inp_node
     JOIN rpt_nodedepth_sum ON rpt_nodedepth_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodedepth_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_compare.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_comp_nodeflooding_sum AS 
 SELECT rpt_nodeflooding_sum.id,
    rpt_selector_compare.result_id,
    rpt_nodeflooding_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodeflooding_sum.hour_flood,
    rpt_nodeflooding_sum.max_rate,
    rpt_nodeflooding_sum.time_days,
    rpt_nodeflooding_sum.time_hour,
    rpt_nodeflooding_sum.tot_flood,
    rpt_nodeflooding_sum.max_ponded,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_compare,
    rpt_inp_node
     JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodeflooding_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_compare.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_comp_nodeinflow_sum AS 
 SELECT rpt_nodeinflow_sum.id,
    rpt_nodeinflow_sum.result_id,
    rpt_nodeinflow_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodeinflow_sum.swnod_type,
    rpt_nodeinflow_sum.max_latinf,
    rpt_nodeinflow_sum.max_totinf,
    rpt_nodeinflow_sum.time_days,
    rpt_nodeinflow_sum.time_hour,
    rpt_nodeinflow_sum.latinf_vol,
    rpt_nodeinflow_sum.totinf_vol,
    rpt_nodeinflow_sum.flow_balance_error,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_compare,
    rpt_inp_node
     JOIN rpt_nodeinflow_sum ON rpt_nodeinflow_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodeinflow_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_compare.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_comp_nodesurcharge_sum AS 
 SELECT rpt_nodesurcharge_sum.id,
    rpt_nodesurcharge_sum.result_id,
    rpt_inp_node.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodesurcharge_sum.swnod_type,
    rpt_nodesurcharge_sum.hour_surch,
    rpt_nodesurcharge_sum.max_height,
    rpt_nodesurcharge_sum.min_depth,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_compare,
    rpt_inp_node
     JOIN rpt_nodesurcharge_sum ON rpt_nodesurcharge_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodesurcharge_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_compare.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_storagevol_sum AS 
 SELECT rpt_storagevol_sum.id,
    rpt_storagevol_sum.result_id,
    rpt_storagevol_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_storagevol_sum.aver_vol,
    rpt_storagevol_sum.avg_full,
    rpt_storagevol_sum.ei_loss,
    rpt_storagevol_sum.max_vol,
    rpt_storagevol_sum.max_full,
    rpt_storagevol_sum.time_days,
    rpt_storagevol_sum.time_hour,
    rpt_storagevol_sum.max_out,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_result,
    rpt_inp_node
     JOIN rpt_storagevol_sum ON rpt_storagevol_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_storagevol_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_outfallflow_sum AS 
 SELECT rpt_inp_node.id,
    rpt_outfallflow_sum.node_id,
    rpt_outfallflow_sum.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallflow_sum.flow_freq,
    rpt_outfallflow_sum.avg_flow,
    rpt_outfallflow_sum.max_flow,
    rpt_outfallflow_sum.total_vol,
    rpt_inp_node.the_geom,
    rpt_inp_node.sector_id
   FROM rpt_selector_result,
    rpt_inp_node
     JOIN rpt_outfallflow_sum ON rpt_outfallflow_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_outfallflow_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_outfallload_sum AS 
 SELECT rpt_inp_node.id,
    rpt_outfallload_sum.node_id,
    rpt_outfallload_sum.result_id,
    rpt_outfallload_sum.poll_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_outfallload_sum.value,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_result,
    rpt_inp_node
     JOIN rpt_outfallload_sum ON rpt_outfallload_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_outfallload_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_nodedepth_sum AS 
 SELECT rpt_nodedepth_sum.id,
    rpt_nodedepth_sum.result_id,
    rpt_nodedepth_sum.node_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodedepth_sum.swnod_type,
    rpt_nodedepth_sum.aver_depth,
    rpt_nodedepth_sum.max_depth,
    rpt_nodedepth_sum.max_hgl,
    rpt_nodedepth_sum.time_days,
    rpt_nodedepth_sum.time_hour,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_result,
    rpt_inp_node
     JOIN rpt_nodedepth_sum ON rpt_nodedepth_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodedepth_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_nodeflooding_sum AS 
 SELECT rpt_inp_node.id,
    rpt_nodeflooding_sum.node_id,
    rpt_selector_result.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodeflooding_sum.hour_flood,
    rpt_nodeflooding_sum.max_rate,
    rpt_nodeflooding_sum.time_days,
    rpt_nodeflooding_sum.time_hour,
    rpt_nodeflooding_sum.tot_flood,
    rpt_nodeflooding_sum.max_ponded,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_result,
    rpt_inp_node
     JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodeflooding_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_nodeinflow_sum AS 
 SELECT rpt_inp_node.id,
    rpt_nodeinflow_sum.node_id,
    rpt_nodeinflow_sum.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodeinflow_sum.swnod_type,
    rpt_nodeinflow_sum.max_latinf,
    rpt_nodeinflow_sum.max_totinf,
    rpt_nodeinflow_sum.time_days,
    rpt_nodeinflow_sum.time_hour,
    rpt_nodeinflow_sum.latinf_vol,
    rpt_nodeinflow_sum.totinf_vol,
    rpt_nodeinflow_sum.flow_balance_error,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_result,
    rpt_inp_node
     JOIN rpt_nodeinflow_sum ON rpt_nodeinflow_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodeinflow_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_nodesurcharge_sum AS 
 SELECT rpt_inp_node.id,
    rpt_inp_node.node_id,
    rpt_nodesurcharge_sum.result_id,
    rpt_inp_node.node_type,
    rpt_inp_node.nodecat_id,
    rpt_nodesurcharge_sum.swnod_type,
    rpt_nodesurcharge_sum.hour_surch,
    rpt_nodesurcharge_sum.max_height,
    rpt_nodesurcharge_sum.min_depth,
    rpt_inp_node.sector_id,
    rpt_inp_node.the_geom
   FROM rpt_selector_result,
    rpt_inp_node
     JOIN rpt_nodesurcharge_sum ON rpt_nodesurcharge_sum.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_nodesurcharge_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_node.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_comp_pumping_sum AS 
 SELECT rpt_pumping_sum.id,
    rpt_pumping_sum.result_id,
    rpt_pumping_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_pumping_sum.percent,
    rpt_pumping_sum.num_startup,
    rpt_pumping_sum.min_flow,
    rpt_pumping_sum.avg_flow,
    rpt_pumping_sum.max_flow,
    rpt_pumping_sum.vol_ltr,
    rpt_pumping_sum.powus_kwh,
    rpt_pumping_sum.timoff_min,
    rpt_pumping_sum.timoff_max,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM rpt_selector_compare,
    rpt_inp_arc
     JOIN rpt_pumping_sum ON rpt_pumping_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_pumping_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_compare.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_comp_arcflow_sum AS 
 SELECT rpt_arcflow_sum.id,
    rpt_selector_compare.result_id,
    rpt_arcflow_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    rpt_arcflow_sum.mfull_flow,
    rpt_arcflow_sum.mfull_dept,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM rpt_selector_compare,
    rpt_inp_arc
     JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_arcflow_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_compare.result_id::text;


CREATE OR REPLACE VIEW v_rpt_comp_condsurcharge_sum AS 
 SELECT rpt_condsurcharge_sum.id,
    rpt_condsurcharge_sum.result_id,
    rpt_condsurcharge_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_condsurcharge_sum.both_ends,
    rpt_condsurcharge_sum.upstream,
    rpt_condsurcharge_sum.dnstream,
    rpt_condsurcharge_sum.hour_nflow,
    rpt_condsurcharge_sum.hour_limit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM rpt_selector_compare,
    rpt_inp_arc
     JOIN rpt_condsurcharge_sum ON rpt_condsurcharge_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_condsurcharge_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_compare.result_id::text;


CREATE OR REPLACE VIEW v_rpt_comp_condsurcharge_sum AS 
 SELECT rpt_condsurcharge_sum.id,
    rpt_condsurcharge_sum.result_id,
    rpt_condsurcharge_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_condsurcharge_sum.both_ends,
    rpt_condsurcharge_sum.upstream,
    rpt_condsurcharge_sum.dnstream,
    rpt_condsurcharge_sum.hour_nflow,
    rpt_condsurcharge_sum.hour_limit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM rpt_selector_compare,
    rpt_inp_arc
     JOIN rpt_condsurcharge_sum ON rpt_condsurcharge_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_condsurcharge_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_compare.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_comp_flowclass_sum AS 
 SELECT rpt_flowclass_sum.id,
    rpt_flowclass_sum.result_id,
    rpt_flowclass_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_flowclass_sum.length,
    rpt_flowclass_sum.dry,
    rpt_flowclass_sum.up_dry,
    rpt_flowclass_sum.down_dry,
    rpt_flowclass_sum.sub_crit,
    rpt_flowclass_sum.sub_crit_1,
    rpt_flowclass_sum.up_crit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM rpt_selector_compare,
    rpt_inp_arc
     JOIN rpt_flowclass_sum ON rpt_flowclass_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_flowclass_sum.result_id::text = rpt_selector_compare.result_id::text AND rpt_selector_compare.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_compare.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_pumping_sum AS 
 SELECT rpt_pumping_sum.id,
    rpt_pumping_sum.result_id,
    rpt_pumping_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_pumping_sum.percent,
    rpt_pumping_sum.num_startup,
    rpt_pumping_sum.min_flow,
    rpt_pumping_sum.avg_flow,
    rpt_pumping_sum.max_flow,
    rpt_pumping_sum.vol_ltr,
    rpt_pumping_sum.powus_kwh,
    rpt_pumping_sum.timoff_min,
    rpt_pumping_sum.timoff_max,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM rpt_selector_result,
    rpt_inp_arc
     JOIN rpt_pumping_sum ON rpt_pumping_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_pumping_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_arcflow_sum AS 
 SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcflow_sum.arc_type AS swarc_type,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    rpt_arcflow_sum.mfull_flow,
    rpt_arcflow_sum.mfull_dept,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   FROM rpt_selector_result,
    rpt_inp_arc
     JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_arcflow_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_arcpolload_sum AS 
 SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcpolload_sum.poll_id
   FROM rpt_selector_result,
    rpt_inp_arc
     JOIN rpt_arcpolload_sum ON rpt_arcpolload_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_arcpolload_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_condsurcharge_sum AS 
 SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_condsurcharge_sum.both_ends,
    rpt_condsurcharge_sum.upstream,
    rpt_condsurcharge_sum.dnstream,
    rpt_condsurcharge_sum.hour_nflow,
    rpt_condsurcharge_sum.hour_limit
   FROM rpt_selector_result,
    rpt_inp_arc
     JOIN rpt_condsurcharge_sum ON rpt_condsurcharge_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_condsurcharge_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_rpt_flowclass_sum AS 
 SELECT rpt_flowclass_sum.id,
    rpt_flowclass_sum.result_id,
    rpt_flowclass_sum.arc_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_flowclass_sum.length,
    rpt_flowclass_sum.dry,
    rpt_flowclass_sum.up_dry,
    rpt_flowclass_sum.down_dry,
    rpt_flowclass_sum.sub_crit,
    rpt_flowclass_sum.sub_crit_1,
    rpt_flowclass_sum.up_crit,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom
   FROM rpt_selector_result,
    rpt_inp_arc
     JOIN rpt_flowclass_sum ON rpt_flowclass_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_flowclass_sum.result_id::text = rpt_selector_result.result_id::text AND rpt_selector_result.cur_user = "current_user"()::text 
  AND rpt_inp_arc.result_id::text = rpt_selector_result.result_id::text;

  
CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream AS 
 SELECT row_number() OVER (ORDER BY v_edit_arc.node_2) + 1000000 AS rid,
    v_edit_arc.node_2 AS node_id,
    v_edit_arc.arc_id AS feature_id,
    v_edit_arc.code AS feature_code,
    v_edit_arc.arc_type AS featurecat_id,
    v_edit_arc.arccat_id,
    v_edit_arc.y1 AS depth,
    st_length2d(v_edit_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_edit_arc.y2 AS upstream_depth,
    v_edit_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_edit_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state
   FROM v_edit_arc
     JOIN node ON v_edit_arc.node_1::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_edit_arc.arc_type::text
     LEFT JOIN cat_arc ON v_edit_arc.arccat_id=cat_arc.id
     JOIN value_state ON v_edit_arc.state = value_state.id
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    v_edit_connec.connec_id AS feature_id,
    v_edit_connec.code::text AS feature_code,
    v_edit_connec.connec_type AS featurecat_id,
    v_edit_connec.connecat_id AS arccat_id,
    v_edit_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_edit_connec.connec_id AS upstream_id,
    v_edit_connec.code AS upstream_code,
    v_edit_connec.connec_type AS upstream_type,
    v_edit_connec.y2 AS upstream_depth,
    v_edit_connec.sys_type,
    st_x(v_edit_connec.the_geom) AS x,
    st_y(v_edit_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state
   FROM v_edit_connec
     JOIN link ON link.feature_id::text = v_edit_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON link.exit_id::text = node.node_id::text AND link.exit_type::text = 'NODE'::text
     JOIN connec_type ON connec_type.id::text = v_edit_connec.connec_type::text
     LEFT JOIN cat_connec ON v_edit_connec.connecat_id=cat_connec.id
     JOIN value_state ON v_edit_connec.state = value_state.id
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    v_edit_gully.gully_id AS feature_id,
    v_edit_gully.code::text AS feature_code,
    v_edit_gully.gully_type AS featurecat_id,
    v_edit_gully.connec_arccat_id AS arccat_id,
    v_edit_gully.ymax - v_edit_gully.sandbox AS depth,
    v_edit_gully.connec_length AS length,
    v_edit_gully.gully_id AS upstream_id,
    v_edit_gully.code AS upstream_code,
    v_edit_gully.gully_type AS upstream_type,
    v_edit_gully.connec_depth AS upstream_depth,
    v_edit_gully.sys_type,
    st_x(v_edit_gully.the_geom) AS x,
    st_y(v_edit_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state
   FROM v_edit_gully
     JOIN link ON link.feature_id::text = v_edit_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text
     JOIN node ON link.exit_id::text = node.node_id::text AND link.exit_type::text = 'NODE'::text
     JOIN gully_type ON gully_type.id::text = v_edit_gully.gully_type::text
     LEFT JOIN cat_connec ON v_edit_gully.connec_arccat_id = cat_connec.id
     JOIN value_state ON v_edit_gully.state = value_state.id;