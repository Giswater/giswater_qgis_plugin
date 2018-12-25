/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;
-- WARNING: SCHEMA_NAME IS NOT ONLY PRESENT ON THE HEADER OF THIS FILE. IT EXISTS ALSO INTO IT. PLEASE REVIEW IT BEFORE REPLACE....



-- ----------------------------
-- View structure for v_rpt_result
-- ----------------------------

DROP VIEW IF EXISTS "v_rpt_arcflow_sum" CASCADE;
CREATE VIEW "v_rpt_arcflow_sum" AS 
SELECT 
rpt_inp_arc.id,
rpt_inp_arc.arc_id, 
rpt_inp_arc.result_id, 
rpt_inp_arc.arc_type,
rpt_inp_arc.arccat_id, 
rpt_inp_arc.sector_id, 
rpt_inp_arc.the_geom,
rpt_arcflow_sum.arc_type as swarc_type, 
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
FROM rpt_selector_result, rpt_inp_arc
	JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id=rpt_inp_arc.arc_id
	WHERE rpt_arcflow_sum.result_id = rpt_selector_result.result_id 
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_result.result_id;



DROP VIEW IF EXISTS "v_rpt_arcpolload_sum" CASCADE;
CREATE VIEW "v_rpt_arcpolload_sum" AS 
SELECT 
rpt_inp_arc.id,
rpt_inp_arc.arc_id, 
rpt_inp_arc.result_id, 
rpt_inp_arc.arc_type,
rpt_inp_arc.arccat_id, 
rpt_inp_arc.sector_id, 
rpt_inp_arc.the_geom,
rpt_arcpolload_sum.poll_id 
FROM rpt_selector_result, rpt_inp_arc
	JOIN rpt_arcpolload_sum ON rpt_arcpolload_sum.arc_id=rpt_inp_arc.arc_id
	WHERE rpt_arcpolload_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_result.result_id;



DROP VIEW IF EXISTS "v_rpt_condsurcharge_sum" CASCADE;
CREATE VIEW "v_rpt_condsurcharge_sum" AS 
SELECT 
rpt_inp_arc.id,
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
FROM rpt_selector_result, rpt_inp_arc
	JOIN rpt_condsurcharge_sum ON rpt_condsurcharge_sum.arc_id=rpt_inp_arc.arc_id
	WHERE rpt_condsurcharge_sum.result_id=rpt_selector_result.result_id		
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_result.result_id;



DROP VIEW IF EXISTS "v_rpt_continuity_errors" CASCADE;
CREATE VIEW "v_rpt_continuity_errors" AS 
SELECT 
rpt_continuity_errors.id, 
rpt_continuity_errors.result_id, 
rpt_continuity_errors.text 
FROM rpt_selector_result, rpt_continuity_errors
	WHERE rpt_continuity_errors.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_critical_elements" CASCADE;
CREATE VIEW "v_rpt_critical_elements" AS 
SELECT 
rpt_critical_elements.id, 
rpt_critical_elements.result_id, 
rpt_critical_elements.text 
FROM rpt_selector_result, rpt_critical_elements
	WHERE rpt_critical_elements.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_flowclass_sum" CASCADE;
CREATE VIEW "v_rpt_flowclass_sum" AS 
SELECT 
rpt_flowclass_sum.id, 
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
FROM rpt_selector_result, rpt_inp_arc 
	JOIN rpt_flowclass_sum ON (rpt_flowclass_sum.arc_id=rpt_inp_arc.arc_id)
	WHERE rpt_flowclass_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_result.result_id;



DROP VIEW IF EXISTS "v_rpt_flowrouting_cont" CASCADE;
CREATE VIEW "v_rpt_flowrouting_cont" AS 
SELECT 
rpt_flowrouting_cont.id, 
rpt_flowrouting_cont.result_id, 
rpt_flowrouting_cont.dryw_inf, 
rpt_flowrouting_cont.wetw_inf, 
rpt_flowrouting_cont.ground_inf, 
rpt_flowrouting_cont.rdii_inf, 
rpt_flowrouting_cont.ext_inf, 
rpt_flowrouting_cont.ext_out, 
rpt_flowrouting_cont.int_out, 
rpt_flowrouting_cont.evap_losses, 
rpt_flowrouting_cont.seepage_losses, 
rpt_flowrouting_cont.stor_loss,
rpt_flowrouting_cont.initst_vol, 
rpt_flowrouting_cont.finst_vol, 
rpt_flowrouting_cont.cont_error 
FROM rpt_selector_result, rpt_flowrouting_cont
	WHERE rpt_flowrouting_cont.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_groundwater_cont" CASCADE;
CREATE VIEW "v_rpt_groundwater_cont" AS 
SELECT
rpt_groundwater_cont.id, 
rpt_groundwater_cont.result_id, 
rpt_groundwater_cont.init_stor, 
rpt_groundwater_cont.infilt, 
rpt_groundwater_cont.upzone_et, 
rpt_groundwater_cont.lowzone_et, 
rpt_groundwater_cont.deep_perc, 
rpt_groundwater_cont.groundw_fl,
rpt_groundwater_cont.final_stor, 
rpt_groundwater_cont.cont_error 
FROM rpt_selector_result, rpt_groundwater_cont
	WHERE rpt_groundwater_cont.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_high_cont_errors" CASCADE;
CREATE VIEW "v_rpt_high_cont_errors" AS 
SELECT 
rpt_continuity_errors.id, 
rpt_continuity_errors.result_id, 
rpt_continuity_errors.text 
FROM rpt_selector_result, rpt_continuity_errors
	WHERE rpt_continuity_errors.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_high_flowinest_ind" CASCADE;
CREATE VIEW "v_rpt_high_flowinest_ind" AS 
SELECT 
rpt_high_flowinest_ind.id, 
rpt_high_flowinest_ind.result_id,
rpt_high_flowinest_ind.text 
FROM rpt_selector_result, rpt_high_flowinest_ind
	WHERE rpt_high_flowinest_ind.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_instability_index" CASCADE;
CREATE VIEW "v_rpt_instability_index" AS 
SELECT 
rpt_instability_index.id, 
rpt_instability_index.result_id, 
rpt_instability_index.text 
FROM rpt_selector_result, rpt_instability_index
	WHERE rpt_instability_index.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_lidperfomance_sum" CASCADE;
CREATE VIEW "v_rpt_lidperfomance_sum" AS 
SELECT 
rpt_lidperformance_sum.id, 
rpt_lidperformance_sum.result_id, 
rpt_lidperformance_sum.subc_id,
rpt_lidperformance_sum.lidco_id, 
rpt_lidperformance_sum.tot_inflow, 
rpt_lidperformance_sum.evap_loss, 
rpt_lidperformance_sum.infil_loss, 
rpt_lidperformance_sum.surf_outf, 
rpt_lidperformance_sum.drain_outf, 
rpt_lidperformance_sum.init_stor, 
rpt_lidperformance_sum.final_stor, 
rpt_lidperformance_sum.per_error, 
subcatchment.sector_id, 
subcatchment.the_geom 
FROM rpt_selector_result, subcatchment
	JOIN rpt_lidperformance_sum ON rpt_lidperformance_sum.subc_id=subcatchment.subc_id
	WHERE rpt_lidperformance_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_nodedepth_sum" CASCADE;
CREATE VIEW "v_rpt_nodedepth_sum" AS 
SELECT 
rpt_nodedepth_sum.id, 
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
FROM  rpt_selector_result, rpt_inp_node
	JOIN rpt_nodedepth_sum ON rpt_nodedepth_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_nodedepth_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_result.result_id;

	
		
		
DROP VIEW IF EXISTS "v_rpt_nodeflooding_sum" CASCADE;
CREATE VIEW "v_rpt_nodeflooding_sum" AS 
SELECT 
rpt_inp_node.id,
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
FROM rpt_selector_result, rpt_inp_node
	JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_nodeflooding_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_result.result_id;


		

DROP VIEW IF EXISTS "v_rpt_nodeinflow_sum" CASCADE;
CREATE VIEW "v_rpt_nodeinflow_sum" AS 
SELECT 
rpt_inp_node.id,
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
FROM rpt_selector_result, rpt_inp_node
	JOIN rpt_nodeinflow_sum ON rpt_nodeinflow_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_nodeinflow_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_result.result_id;

		
		


DROP VIEW IF EXISTS "v_rpt_nodesurcharge_sum" CASCADE;
CREATE VIEW "v_rpt_nodesurcharge_sum" AS 
SELECT 
rpt_inp_node.id,
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
FROM rpt_selector_result, rpt_inp_node
	JOIN rpt_nodesurcharge_sum ON rpt_nodesurcharge_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_nodesurcharge_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_result.result_id;



DROP VIEW IF EXISTS "v_rpt_outfallflow_sum" CASCADE;
CREATE VIEW "v_rpt_outfallflow_sum" AS 
SELECT 
rpt_inp_node.id,
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
FROM rpt_selector_result, rpt_inp_node
	JOIN rpt_outfallflow_sum ON rpt_outfallflow_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_outfallflow_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_result.result_id;



DROP VIEW IF EXISTS "v_rpt_outfallload_sum" CASCADE;
CREATE VIEW "v_rpt_outfallload_sum" AS 
SELECT 
rpt_inp_node.id,
rpt_outfallload_sum.node_id, 
rpt_outfallload_sum.result_id,
rpt_outfallload_sum.poll_id,
rpt_inp_node.node_type,
rpt_inp_node.nodecat_id, 
rpt_outfallload_sum.value, 
rpt_inp_node.sector_id, 
rpt_inp_node.the_geom 
FROM rpt_selector_result, rpt_inp_node
	JOIN rpt_outfallload_sum ON rpt_outfallload_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_outfallload_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_result.result_id;



DROP VIEW IF EXISTS "v_rpt_pumping_sum" CASCADE;
CREATE VIEW "v_rpt_pumping_sum" AS 
SELECT 
rpt_pumping_sum.id, 
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
FROM rpt_selector_result, rpt_inp_arc
	JOIN rpt_pumping_sum ON rpt_pumping_sum.arc_id=rpt_inp_arc.arc_id
	WHERE rpt_pumping_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_result.result_id;;

	

DROP VIEW IF EXISTS "v_rpt_qualrouting" CASCADE;
CREATE VIEW "v_rpt_qualrouting" AS 
SELECT 
rpt_qualrouting_cont.id, 
rpt_qualrouting_cont.result_id, 
rpt_qualrouting_cont.poll_id, 
rpt_qualrouting_cont.dryw_inf, 
rpt_qualrouting_cont.wetw_inf, 
rpt_qualrouting_cont.ground_inf,
rpt_qualrouting_cont.rdii_inf, 
rpt_qualrouting_cont.ext_inf, 
rpt_qualrouting_cont.int_inf, 
rpt_qualrouting_cont.ext_out, 
rpt_qualrouting_cont.mass_reac, 
rpt_qualrouting_cont.initst_mas, 
rpt_qualrouting_cont.finst_mas, 
rpt_qualrouting_cont.cont_error 
FROM rpt_selector_result, rpt_qualrouting_cont
	WHERE rpt_qualrouting_cont.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_rainfall_dep" CASCADE;
CREATE VIEW "v_rpt_rainfall_dep" AS 
SELECT 
rpt_rainfall_dep.id, 
rpt_rainfall_dep.result_id, 
rpt_rainfall_dep.sewer_rain, 
rpt_rainfall_dep.rdiip_prod, 
rpt_rainfall_dep.rdiir_rat 
FROM rpt_selector_result, rpt_rainfall_dep
	WHERE rpt_rainfall_dep.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_routing_timestep" CASCADE;
CREATE VIEW "v_rpt_routing_timestep" AS 
SELECT 
rpt_routing_timestep.id, 
rpt_routing_timestep.result_id,
rpt_routing_timestep.text 
FROM rpt_selector_result, rpt_routing_timestep
	WHERE rpt_routing_timestep.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_runoff_qual" CASCADE;
CREATE VIEW "v_rpt_runoff_qual" AS 
SELECT 
rpt_runoff_qual.id, 
rpt_runoff_qual.result_id, 
rpt_runoff_qual.poll_id, 
rpt_runoff_qual.init_buil, 
rpt_runoff_qual.surf_buil,
rpt_runoff_qual.wet_dep, 
rpt_runoff_qual.sweep_re, 
rpt_runoff_qual.infil_loss, 
rpt_runoff_qual.bmp_re,
rpt_runoff_qual.surf_runof, 
rpt_runoff_qual.rem_buil, 
rpt_runoff_qual.cont_error 
FROM rpt_selector_result, rpt_runoff_qual
	WHERE rpt_runoff_qual.result_id = rpt_selector_result.result_id AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_runoff_quant" CASCADE;
CREATE VIEW "v_rpt_runoff_quant" AS 
SELECT 
rpt_runoff_quant.id, 
rpt_runoff_quant.result_id, 
rpt_runoff_quant.initsw_co, 
rpt_runoff_quant.total_prec, 
rpt_runoff_quant.evap_loss, 
rpt_runoff_quant.infil_loss, 
rpt_runoff_quant.surf_runof, 
rpt_runoff_quant.snow_re, 
rpt_runoff_quant.finalsw_co, 
rpt_runoff_quant.finals_sto,
rpt_runoff_quant.cont_error 
FROM rpt_selector_result, rpt_runoff_quant
	WHERE rpt_runoff_quant.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_storagevol_sum" CASCADE;
CREATE VIEW "v_rpt_storagevol_sum" AS 
SELECT
rpt_storagevol_sum.id, 
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
FROM rpt_selector_result, rpt_inp_node
	JOIN rpt_storagevol_sum ON rpt_storagevol_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_storagevol_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_result.result_id;




DROP VIEW IF EXISTS "v_rpt_subcatchrunoff_sum" CASCADE;
CREATE VIEW "v_rpt_subcatchrunoff_sum" AS 
SELECT 
rpt_subcathrunoff_sum.id, 
rpt_subcathrunoff_sum.result_id, 
rpt_subcathrunoff_sum.subc_id, 
rpt_subcathrunoff_sum.tot_precip, 
rpt_subcathrunoff_sum.tot_runon, 
rpt_subcathrunoff_sum.tot_evap, 
rpt_subcathrunoff_sum.tot_infil, 
rpt_subcathrunoff_sum.tot_runoff,
rpt_subcathrunoff_sum.tot_runofl, 
rpt_subcathrunoff_sum.peak_runof, 
rpt_subcathrunoff_sum.runoff_coe, 
rpt_subcathrunoff_sum.vxmax, 
rpt_subcathrunoff_sum.vymax, 
rpt_subcathrunoff_sum.depth, 
rpt_subcathrunoff_sum.vel, 
rpt_subcathrunoff_sum.vhmax, 
subcatchment.sector_id, 
subcatchment.the_geom 
FROM rpt_selector_result, subcatchment
	JOIN rpt_subcathrunoff_sum ON rpt_subcathrunoff_sum.subc_id=subcatchment.subc_id
	WHERE rpt_subcathrunoff_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_subcatchwasoff_sum" CASCADE;
CREATE VIEW "v_rpt_subcatchwasoff_sum" AS 
SELECT 
rpt_subcatchwashoff_sum.id, 
rpt_subcatchwashoff_sum.result_id, 
rpt_subcatchwashoff_sum.subc_id, 
rpt_subcatchwashoff_sum.poll_id,
rpt_subcatchwashoff_sum.value, 
subcatchment.sector_id, 
subcatchment.the_geom 
FROM rpt_selector_result, subcatchment
	JOIN rpt_subcatchwashoff_sum ON rpt_subcatchwashoff_sum.subc_id=subcatchment.subc_id
	WHERE rpt_subcatchwashoff_sum.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_timestep_critelem" CASCADE;
CREATE VIEW "v_rpt_timestep_critelem" AS 
SELECT 
rpt_timestep_critelem.id, 
rpt_timestep_critelem.result_id, 
rpt_timestep_critelem.text 
FROM rpt_selector_result, rpt_timestep_critelem
	WHERE rpt_timestep_critelem.result_id=rpt_selector_result.result_id
	AND rpt_selector_result.cur_user="current_user"();




-- ----------------------------
-- View structure for v_rpt_compare
-- ----------------------------

DROP VIEW IF EXISTS "v_rpt_comp_arcflow_sum" CASCADE;
CREATE VIEW "v_rpt_comp_arcflow_sum" AS 
SELECT 
rpt_arcflow_sum.id, rpt_selector_compare.result_id, rpt_arcflow_sum.arc_id, 
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
FROM rpt_selector_compare, rpt_inp_arc 
	JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id=rpt_inp_arc.arc_id
	WHERE rpt_arcflow_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_compare.result_id;



	
DROP VIEW IF EXISTS "v_rpt_comp_arcpolload_sum" CASCADE;
CREATE VIEW "v_rpt_comp_arcpolload_sum" AS 
SELECT 
rpt_arcpolload_sum.id, 
rpt_arcpolload_sum.result_id, 
rpt_arcpolload_sum.arc_id, 
rpt_inp_arc.arc_type,
rpt_inp_arc.arccat_id, 
rpt_arcpolload_sum.poll_id, 
rpt_inp_arc.sector_id, 
rpt_inp_arc.the_geom 
FROM rpt_selector_compare, rpt_inp_arc
JOIN rpt_arcpolload_sum ON rpt_arcpolload_sum.arc_id=rpt_inp_arc.arc_id
	WHERE rpt_arcpolload_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_compare.result_id;



DROP VIEW IF EXISTS "v_rpt_comp_condsurcharge_sum" CASCADE;
CREATE VIEW "v_rpt_comp_condsurcharge_sum" AS 
SELECT 
rpt_condsurcharge_sum.id, 
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
FROM rpt_selector_compare, rpt_inp_arc
	JOIN rpt_condsurcharge_sum ON rpt_condsurcharge_sum.arc_id=rpt_inp_arc.arc_id
	WHERE rpt_condsurcharge_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_compare.result_id;


	
	

DROP VIEW IF EXISTS "v_rpt_comp_continuity_errors" CASCADE;
CREATE VIEW "v_rpt_comp_continuity_errors" AS 
SELECT 
rpt_continuity_errors.id,
rpt_continuity_errors.result_id, 
rpt_continuity_errors.text 
FROM rpt_selector_compare, rpt_continuity_errors
	WHERE rpt_continuity_errors.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();


	
	
DROP VIEW IF EXISTS "v_rpt_comp_critical_elements" CASCADE;
CREATE VIEW "v_rpt_comp_critical_elements" AS 
SELECT 
rpt_critical_elements.id, 
rpt_critical_elements.result_id, 
rpt_critical_elements.text 
FROM rpt_selector_compare, rpt_critical_elements
	WHERE rpt_critical_elements.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



	
DROP VIEW IF EXISTS "v_rpt_comp_flowclass_sum" CASCADE;
CREATE VIEW "v_rpt_comp_flowclass_sum" AS 
SELECT 
rpt_flowclass_sum.id, 
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
FROM rpt_selector_compare, rpt_inp_arc 
	JOIN rpt_flowclass_sum ON (rpt_flowclass_sum.arc_id=rpt_inp_arc.arc_id)
	WHERE rpt_flowclass_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_compare.result_id;


	

DROP VIEW IF EXISTS "v_rpt_comp_flowrouting_cont" CASCADE;
CREATE VIEW "v_rpt_comp_flowrouting_cont" AS 
SELECT 
rpt_flowrouting_cont.id, 
rpt_flowrouting_cont.result_id, 
rpt_flowrouting_cont.dryw_inf, 
rpt_flowrouting_cont.wetw_inf, 
rpt_flowrouting_cont.ground_inf, 
rpt_flowrouting_cont.rdii_inf, 
rpt_flowrouting_cont.ext_inf, 
rpt_flowrouting_cont.ext_out, 
rpt_flowrouting_cont.int_out, 
rpt_flowrouting_cont.evap_losses, 
rpt_flowrouting_cont.seepage_losses, 
rpt_flowrouting_cont.stor_loss, 
rpt_flowrouting_cont.initst_vol, 
rpt_flowrouting_cont.finst_vol, 
rpt_flowrouting_cont.cont_error 
FROM rpt_selector_compare, rpt_flowrouting_cont
	WHERE rpt_flowrouting_cont.result_id=rpt_selector_compare.result_id 
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_groundwater_cont" CASCADE;
CREATE VIEW "v_rpt_comp_groundwater_cont" AS 
SELECT 
rpt_groundwater_cont.id, 
rpt_groundwater_cont.result_id,
rpt_groundwater_cont.init_stor,
rpt_groundwater_cont.infilt, 
rpt_groundwater_cont.upzone_et, 
rpt_groundwater_cont.lowzone_et, 
rpt_groundwater_cont.deep_perc, 
rpt_groundwater_cont.groundw_fl, 
rpt_groundwater_cont.final_stor, 
rpt_groundwater_cont.cont_error 
FROM rpt_selector_compare, rpt_groundwater_cont
	WHERE rpt_groundwater_cont.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_high_cont_errors" CASCADE;
CREATE VIEW "v_rpt_comp_high_cont_errors" AS 
SELECT 
rpt_continuity_errors.id, 
rpt_continuity_errors.result_id, 
rpt_continuity_errors.text 
FROM rpt_selector_compare, rpt_continuity_errors
	WHERE rpt_continuity_errors.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_high_flowinest_ind" CASCADE;
CREATE VIEW "v_rpt_comp_high_flowinest_ind" AS 
SELECT 
rpt_high_flowinest_ind.id, 
rpt_high_flowinest_ind.result_id, 
rpt_high_flowinest_ind.text 
FROM rpt_selector_compare, rpt_high_flowinest_ind
	WHERE rpt_high_flowinest_ind.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_instability_index" CASCADE;
CREATE VIEW "v_rpt_comp_instability_index" AS 
SELECT 
rpt_instability_index.id, 
rpt_instability_index.result_id, 
rpt_instability_index.text 
FROM rpt_selector_compare, rpt_instability_index
	WHERE rpt_instability_index.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_lidperfomance_sum" CASCADE;
CREATE VIEW "v_rpt_comp_lidperfomance_sum" AS 
SELECT 
rpt_lidperformance_sum.id,
rpt_lidperformance_sum.result_id, 
rpt_lidperformance_sum.subc_id, 
rpt_lidperformance_sum.lidco_id,
rpt_lidperformance_sum.tot_inflow, 
rpt_lidperformance_sum.evap_loss, 
rpt_lidperformance_sum.infil_loss, 
rpt_lidperformance_sum.surf_outf, 
rpt_lidperformance_sum.drain_outf, 
rpt_lidperformance_sum.init_stor, 
rpt_lidperformance_sum.final_stor, 
rpt_lidperformance_sum.per_error, 
subcatchment.sector_id, 
subcatchment.the_geom 
FROM rpt_selector_compare, subcatchment
	JOIN rpt_lidperformance_sum ON rpt_lidperformance_sum.subc_id=subcatchment.subc_id
	WHERE rpt_lidperformance_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();


	

DROP VIEW IF EXISTS "v_rpt_comp_nodedepth_sum" CASCADE;
CREATE VIEW "v_rpt_comp_nodedepth_sum" AS 
SELECT 
rpt_nodedepth_sum.id,
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
FROM  rpt_selector_compare, rpt_inp_node
	JOIN rpt_nodedepth_sum ON rpt_nodedepth_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_nodedepth_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_compare.result_id;

	


DROP VIEW IF EXISTS "v_rpt_comp_nodeflooding_sum" CASCADE;
CREATE VIEW "v_rpt_comp_nodeflooding_sum" AS 
SELECT 
rpt_nodeflooding_sum.id, 
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
FROM rpt_selector_compare, rpt_inp_node
	JOIN rpt_nodeflooding_sum ON rpt_nodeflooding_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_nodeflooding_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_compare.result_id;

	


DROP VIEW IF EXISTS "v_rpt_comp_nodeinflow_sum" CASCADE;
CREATE VIEW "v_rpt_comp_nodeinflow_sum" AS 
SELECT 
rpt_nodeinflow_sum.id, 
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
FROM rpt_selector_compare, rpt_inp_node
	JOIN rpt_nodeinflow_sum ON rpt_nodeinflow_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_nodeinflow_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_compare.result_id;



	

DROP VIEW IF EXISTS "v_rpt_comp_nodesurcharge_sum" CASCADE;
CREATE VIEW "v_rpt_comp_nodesurcharge_sum" AS 
SELECT 
rpt_nodesurcharge_sum.id, 
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
FROM rpt_selector_compare, rpt_inp_node
	JOIN rpt_nodesurcharge_sum ON rpt_nodesurcharge_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_nodesurcharge_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_compare.result_id;



	

DROP VIEW IF EXISTS "v_rpt_comp_outfallflow_sum" CASCADE;
CREATE VIEW "v_rpt_comp_outfallflow_sum" AS 
SELECT 
rpt_outfallflow_sum.id, rpt_outfallflow_sum.result_id, 
rpt_outfallflow_sum.node_id,
rpt_inp_node.node_type,
rpt_inp_node.nodecat_id, 
rpt_outfallflow_sum.flow_freq, 
rpt_outfallflow_sum.avg_flow, 
rpt_outfallflow_sum.max_flow, 
rpt_outfallflow_sum.total_vol, 
rpt_inp_node.the_geom, 
rpt_inp_node.sector_id 
FROM rpt_selector_compare, rpt_inp_node
	JOIN rpt_outfallflow_sum ON rpt_outfallflow_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_outfallflow_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_compare.result_id;




DROP VIEW IF EXISTS "v_rpt_comp_outfallload_sum" CASCADE;
CREATE VIEW "v_rpt_comp_outfallload_sum" AS 
SELECT 
rpt_outfallload_sum.id, 
rpt_outfallload_sum.result_id, 
rpt_outfallload_sum.poll_id, 
rpt_outfallload_sum.node_id, 
rpt_inp_node.node_type,
rpt_inp_node.nodecat_id, 
rpt_outfallload_sum.value,
rpt_inp_node.sector_id, 
rpt_inp_node.the_geom 
FROM rpt_selector_compare, rpt_inp_node
	JOIN rpt_outfallload_sum ON rpt_outfallload_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_outfallload_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_node.result_id=rpt_selector_compare.result_id;




DROP VIEW IF EXISTS "v_rpt_comp_pumping_sum" CASCADE;
CREATE VIEW "v_rpt_comp_pumping_sum" AS 
SELECT 
rpt_pumping_sum.id, 
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
FROM rpt_selector_compare, rpt_inp_arc
	JOIN rpt_pumping_sum ON rpt_pumping_sum.arc_id=rpt_inp_arc.arc_id
	WHERE rpt_pumping_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"()
	AND rpt_inp_arc.result_id=rpt_selector_compare.result_id;



	
DROP VIEW IF EXISTS "v_rpt_comp_qualrouting" CASCADE;
CREATE VIEW "v_rpt_comp_qualrouting" AS 
SELECT 
rpt_qualrouting_cont.id, 
rpt_qualrouting_cont.result_id, 
rpt_qualrouting_cont.poll_id, 
rpt_qualrouting_cont.dryw_inf, 
rpt_qualrouting_cont.wetw_inf, 
rpt_qualrouting_cont.ground_inf, 
rpt_qualrouting_cont.rdii_inf, 
rpt_qualrouting_cont.ext_inf, 
rpt_qualrouting_cont.int_inf, 
rpt_qualrouting_cont.ext_out,
rpt_qualrouting_cont.mass_reac, 
rpt_qualrouting_cont.initst_mas, 
rpt_qualrouting_cont.finst_mas, 
rpt_qualrouting_cont.cont_error 
FROM rpt_selector_compare, rpt_qualrouting_cont
	WHERE rpt_qualrouting_cont.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_rainfall_dep" CASCADE;
CREATE VIEW "v_rpt_comp_rainfall_dep" AS 
SELECT 
rpt_rainfall_dep.id, 
rpt_rainfall_dep.result_id, 
rpt_rainfall_dep.sewer_rain, 
rpt_rainfall_dep.rdiip_prod, 
rpt_rainfall_dep.rdiir_rat 
FROM rpt_selector_compare, rpt_rainfall_dep
	WHERE rpt_rainfall_dep.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_routing_timestep" CASCADE;
CREATE VIEW "v_rpt_comp_routing_timestep" AS 
SELECT 
rpt_routing_timestep.id, 
rpt_routing_timestep.result_id, 
rpt_routing_timestep.text 
FROM rpt_selector_compare, rpt_routing_timestep
	WHERE rpt_routing_timestep.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_runoff_qual" CASCADE;
CREATE VIEW "v_rpt_comp_runoff_qual" AS 
SELECT 
rpt_runoff_qual.id, 
rpt_runoff_qual.result_id, 
rpt_runoff_qual.poll_id, 
rpt_runoff_qual.init_buil, 
rpt_runoff_qual.surf_buil,
rpt_runoff_qual.wet_dep, 
rpt_runoff_qual.sweep_re, 
rpt_runoff_qual.infil_loss, 
rpt_runoff_qual.bmp_re, 
rpt_runoff_qual.surf_runof,
rpt_runoff_qual.rem_buil, 
rpt_runoff_qual.cont_error 
FROM rpt_selector_compare, rpt_runoff_qual
	WHERE rpt_runoff_qual.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_runoff_quant" CASCADE;
CREATE VIEW "v_rpt_comp_runoff_quant" AS 
SELECT 
rpt_runoff_quant.id, 
rpt_runoff_quant.result_id, 
rpt_runoff_quant.initsw_co,
rpt_runoff_quant.total_prec, 
rpt_runoff_quant.evap_loss, 
rpt_runoff_quant.infil_loss, 
rpt_runoff_quant.surf_runof, 
rpt_runoff_quant.snow_re, 
rpt_runoff_quant.finalsw_co, 
rpt_runoff_quant.finals_sto,
rpt_runoff_quant.cont_error 
FROM rpt_selector_compare, rpt_runoff_quant
	WHERE rpt_runoff_quant.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_storagevol_sum" CASCADE;
CREATE VIEW "v_rpt_comp_storagevol_sum" AS 
SELECT 
rpt_storagevol_sum.id, 
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
FROM rpt_selector_compare, rpt_inp_node
	JOIN rpt_storagevol_sum ON rpt_storagevol_sum.node_id=rpt_inp_node.node_id
	WHERE rpt_storagevol_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_subcatchrunoff_sum" CASCADE;
CREATE VIEW "v_rpt_comp_subcatchrunoff_sum" AS 
SELECT 
rpt_subcathrunoff_sum.id, 
rpt_subcathrunoff_sum.result_id, 
rpt_subcathrunoff_sum.subc_id, 
rpt_subcathrunoff_sum.tot_precip, 
rpt_subcathrunoff_sum.tot_runon, 
rpt_subcathrunoff_sum.tot_evap, 
rpt_subcathrunoff_sum.tot_infil, 
rpt_subcathrunoff_sum.tot_runoff, 
rpt_subcathrunoff_sum.tot_runofl, 
rpt_subcathrunoff_sum.peak_runof, 
rpt_subcathrunoff_sum.runoff_coe, 
rpt_subcathrunoff_sum.vxmax, 
rpt_subcathrunoff_sum.vymax, 
rpt_subcathrunoff_sum.depth, 
rpt_subcathrunoff_sum.vel, 
rpt_subcathrunoff_sum.vhmax, 
subcatchment.sector_id,
subcatchment.the_geom 
FROM rpt_selector_compare, subcatchment
	JOIN rpt_subcathrunoff_sum ON rpt_subcathrunoff_sum.subc_id=subcatchment.subc_id
	WHERE rpt_subcathrunoff_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_subcatchwasoff_sum" CASCADE;
CREATE VIEW "v_rpt_comp_subcatchwasoff_sum" AS 
SELECT 
rpt_subcatchwashoff_sum.id, 
rpt_subcatchwashoff_sum.result_id, 
rpt_subcatchwashoff_sum.subc_id, 
rpt_subcatchwashoff_sum.poll_id, 
rpt_subcatchwashoff_sum.value, 
subcatchment.sector_id, 
subcatchment.the_geom 
FROM rpt_selector_compare, subcatchment
	JOIN rpt_subcatchwashoff_sum ON rpt_subcatchwashoff_sum.subc_id=subcatchment.subc_id
	WHERE rpt_subcatchwashoff_sum.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();



DROP VIEW IF EXISTS "v_rpt_comp_timestep_critelem" CASCADE;
CREATE VIEW "v_rpt_comp_timestep_critelem" AS 
SELECT 
rpt_timestep_critelem.id, 
rpt_timestep_critelem.result_id, 
rpt_timestep_critelem.text 
	FROM rpt_selector_compare, rpt_timestep_critelem
	WHERE rpt_timestep_critelem.result_id=rpt_selector_compare.result_id
	AND rpt_selector_compare.cur_user="current_user"();
