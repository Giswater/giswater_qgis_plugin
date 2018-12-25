/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


--DROP
--INP

ALTER TABLE "raingage" DROP CONSTRAINT IF EXISTS "raingage_timser_id_fkey";
ALTER TABLE "raingage" DROP CONSTRAINT IF EXISTS "raingage_expl_id_fkey";
ALTER TABLE "raingage" DROP CONSTRAINT IF EXISTS "raingage_form_type_fkey";
ALTER TABLE "raingage" DROP CONSTRAINT IF EXISTS "raingage_rgage_type_fkey" ;

ALTER TABLE "subcatchment" DROP CONSTRAINT IF EXISTS "subcatchment_node_id_fkey";
ALTER TABLE "subcatchment" DROP CONSTRAINT IF EXISTS "subcatchment_rg_id_fkey";
ALTER TABLE "subcatchment" DROP CONSTRAINT IF EXISTS "subcatchment_snow_id_fkey";
ALTER TABLE "subcatchment" DROP CONSTRAINT IF EXISTS "subcatchment_sector_id_fkey";
ALTER TABLE "subcatchment" DROP CONSTRAINT IF EXISTS "subcatchment_hydrology_id_fkey";

ALTER TABLE "cat_hydrology" DROP CONSTRAINT IF EXISTS "cat_hydrology_infiltration_id_fkey";

ALTER TABLE "inp_selector_hydrology" DROP CONSTRAINT IF EXISTS "inp_selector_hydrology_hydrology_id_cur_user";
ALTER TABLE "inp_selector_hydrology" DROP CONSTRAINT IF EXISTS "inp_selector_hydrology_hydrology_id_fkey";

ALTER TABLE "inp_aquifer" DROP CONSTRAINT IF EXISTS "inp_aquifer_pattern_id_fkey";

ALTER TABLE "inp_buildup_land_x_pol"  DROP CONSTRAINT IF EXISTS "inp_buildup_land_x_pol_landus_id_fkey";
ALTER TABLE "inp_buildup_land_x_pol" DROP CONSTRAINT IF EXISTS "inp_buildup_land_x_pol_poll_id_fkey";

ALTER TABLE "inp_conduit" DROP CONSTRAINT IF EXISTS "inp_conduit_arc_id_fkey";

ALTER TABLE "inp_controls_x_node" DROP CONSTRAINT IF EXISTS "inp_controls_x_node_id_fkey";

ALTER TABLE "inp_controls_x_arc" DROP CONSTRAINT IF EXISTS "inp_controls_x_arc_id_fkey";

ALTER TABLE "inp_coverage_land_x_subc" DROP CONSTRAINT IF EXISTS "inp_coverage_land_x_subc_landus_id_fkey";
ALTER TABLE "inp_coverage_land_x_subc" DROP CONSTRAINT IF EXISTS "inp_coverage_land_x_subc_subc_id_fkey";

ALTER TABLE "inp_curve" DROP CONSTRAINT IF EXISTS "inp_curve_curve_id_fkey";

ALTER TABLE "inp_curve_id" DROP CONSTRAINT IF EXISTS "inp_curve_id_curve_type_fkey";

ALTER TABLE "inp_divider" DROP CONSTRAINT IF EXISTS "inp_divider_node_id_fkey";
ALTER TABLE "inp_divider" DROP CONSTRAINT IF EXISTS "inp_divider_curve_id_fkey";
ALTER TABLE "inp_divider" DROP CONSTRAINT IF EXISTS "inp_divider_arc_id_fkey";
ALTER TABLE "inp_divider" DROP CONSTRAINT IF EXISTS "inp_divider_divider_type_fkey";

ALTER TABLE "inp_dwf" DROP CONSTRAINT IF EXISTS "inp_dwf_node_id_fkey";
ALTER TABLE "inp_dwf" DROP CONSTRAINT IF EXISTS "inp_dwf_pat1_fkey";
ALTER TABLE "inp_dwf" DROP CONSTRAINT IF EXISTS "inp_dwf_pat2_fkey";
ALTER TABLE "inp_dwf" DROP CONSTRAINT IF EXISTS "inp_dwf_pat3_fkey";
ALTER TABLE "inp_dwf" DROP CONSTRAINT IF EXISTS "inp_dwf_pat4_fkey";

ALTER TABLE "inp_dwf_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_dwf_pol_x_node_node_id_fkey";
ALTER TABLE "inp_dwf_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_dwf_pol_x_node_poll_id_fkey";
ALTER TABLE "inp_dwf_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_dwf_pol_x_node_pat1_fkey";
ALTER TABLE "inp_dwf_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_dwf_pol_x_node_pat2_fkey";
ALTER TABLE "inp_dwf_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_dwf_pol_x_node_pat3_fkey";
ALTER TABLE "inp_dwf_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_dwf_pol_x_node_pat4_fkey";

ALTER TABLE "inp_evaporation" DROP CONSTRAINT IF EXISTS "inp_evaporation_timser_id_fkey";
ALTER TABLE "inp_evaporation" DROP CONSTRAINT IF EXISTS "inp_evaporation_evap_type_fkey";

ALTER TABLE "inp_groundwater" DROP CONSTRAINT IF EXISTS "inp_groundwater_subc_id_fkey";
ALTER TABLE "inp_groundwater" DROP CONSTRAINT IF EXISTS "inp_groundwater_aquif_id_fkey";
ALTER TABLE "inp_groundwater" DROP CONSTRAINT IF EXISTS "inp_groundwater_node_id_fkey";

ALTER TABLE "inp_inflows" DROP CONSTRAINT IF EXISTS "inp_inflows_node_id_fkey";
ALTER TABLE "inp_inflows" DROP CONSTRAINT IF EXISTS "inp_inflows_timser_id_fkey";
ALTER TABLE "inp_inflows" DROP CONSTRAINT IF EXISTS "inp_inflows_pattern_id_fkey";

ALTER TABLE "inp_inflows_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_inflows_pol_x_node_node_id_fkey";
ALTER TABLE "inp_inflows_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_inflows_pol_x_node_poll_id_fkey";
ALTER TABLE "inp_inflows_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_inflows_pol_x_node_timser_id_fkey";
ALTER TABLE "inp_inflows_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_inflows_pol_x_node_pattern_id_fkey";
ALTER TABLE "inp_inflows_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_inflows_pol_x_node_form_type_fkey";

ALTER TABLE "inp_junction" DROP CONSTRAINT IF EXISTS "inp_junction_node_id_fkey";

ALTER TABLE "inp_lid_control" DROP CONSTRAINT IF EXISTS "inp_lid_control_lidco_type_fkey";

ALTER TABLE "inp_lidusage_subc_x_lidco" DROP CONSTRAINT IF EXISTS "inp_lidusage_subc_x_lidco_subc_id_fkey";
ALTER TABLE "inp_lidusage_subc_x_lidco" DROP CONSTRAINT IF EXISTS "inp_lidusage_subc_x_lidco_lidco_id_fkey";

ALTER TABLE "inp_loadings_pol_x_subc" DROP CONSTRAINT IF EXISTS "inp_loadings_pol_x_subc_subc_id_fkey";
ALTER TABLE "inp_loadings_pol_x_subc" DROP CONSTRAINT IF EXISTS "inp_loadings_pol_x_subc_pattern_id_fkey";
ALTER TABLE "inp_loadings_pol_x_subc" DROP CONSTRAINT IF EXISTS "inp_loadings_pol_x_subc_poll_id_fkey";

ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_allow_ponding_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_normal_flow_limited_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_inertial_damping_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_skip_steady_state_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_quality_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_routing_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_groundwater_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_snowmelt_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_ignore_rainfall_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_force_main_equation_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_link_offsets_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_flow_routing_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_flow_units_fkey";

ALTER TABLE "inp_orifice" DROP CONSTRAINT IF EXISTS "inp_orifice_arc_id_fkey";
ALTER TABLE "inp_orifice" DROP CONSTRAINT IF EXISTS "inp_orifice_node_id_fkey";
ALTER TABLE "inp_orifice" DROP CONSTRAINT IF EXISTS "inp_orifice_to_arc_fkey";
ALTER TABLE "inp_orifice" DROP CONSTRAINT IF EXISTS "inp_orifice_shape_fkey";
ALTER TABLE "inp_orifice" DROP CONSTRAINT IF EXISTS "inp_orifice_ori_type_fkey";

ALTER TABLE "inp_outfall" DROP CONSTRAINT IF EXISTS "inp_outfall_node_id_fkey";
ALTER TABLE "inp_outfall" DROP CONSTRAINT IF EXISTS "inp_outfall_curve_id_fkey";
ALTER TABLE "inp_outfall" DROP CONSTRAINT IF EXISTS "inp_outfall_timser_id_fkey";
ALTER TABLE "inp_outfall" DROP CONSTRAINT IF EXISTS "inp_outfall_type_fkey";

ALTER TABLE "inp_outlet" DROP CONSTRAINT IF EXISTS "inp_outlet_arc_id_fkey";
ALTER TABLE "inp_outlet" DROP CONSTRAINT IF EXISTS "inp_outlet_node_id_fkey";
ALTER TABLE "inp_outlet" DROP CONSTRAINT IF EXISTS "inp_outlet_curve_id_fkey";
ALTER TABLE "inp_outlet" DROP CONSTRAINT IF EXISTS "inp_outlet_outlet_type_fkey";

ALTER TABLE "inp_pattern" DROP CONSTRAINT IF EXISTS "inp_pattern_pattern_type_fkey";

ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_arc_id_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_node_id_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_curve_id_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_to_arc_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_status_fkey";

ALTER TABLE "inp_rdii" DROP CONSTRAINT IF EXISTS "inp_rdii_node_id_fkey";
ALTER TABLE "inp_rdii" DROP CONSTRAINT IF EXISTS "inp_rdii_hydro_id_fkey";

ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_controls_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_input_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_continuity_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_flowstats_fkey";

ALTER TABLE "inp_storage" DROP CONSTRAINT IF EXISTS "inp_storage_node_id_fkey";
ALTER TABLE "inp_storage" DROP CONSTRAINT IF EXISTS "inp_storage_curve_id_fkey";
ALTER TABLE "inp_storage" DROP CONSTRAINT IF EXISTS "inp_storage_storage_type_fkey";

ALTER TABLE "inp_temperature" DROP CONSTRAINT IF EXISTS "inp_temperature_timser_id_fkey";

ALTER TABLE "inp_timeseries" DROP CONSTRAINT IF EXISTS "inp_timeseries_timser_id_fkey";

ALTER TABLE "inp_timser_id" DROP CONSTRAINT IF EXISTS "inp_timser_id_timser_type_fkey";
ALTER TABLE "inp_timser_id" DROP CONSTRAINT IF EXISTS "inp_timser_id_times_type_fkey";

ALTER TABLE "inp_transects" DROP CONSTRAINT IF EXISTS "inp_transects_tsect_id_fkey";

ALTER TABLE "inp_treatment_node_x_pol" DROP CONSTRAINT IF EXISTS "inp_treatment_node_x_pol_node_id_fkey";
ALTER TABLE "inp_treatment_node_x_pol" DROP CONSTRAINT IF EXISTS "inp_treatment_node_x_pol_poll_id_fkey";

ALTER TABLE "inp_washoff_land_x_pol" DROP CONSTRAINT IF EXISTS "inp_washoff_land_x_pol_poll_id_fkey";
ALTER TABLE "inp_washoff_land_x_pol" DROP CONSTRAINT IF EXISTS "inp_washoff_land_x_pol_landus_id_fkey";

ALTER TABLE "inp_weir" DROP CONSTRAINT IF EXISTS "inp_weir_arc_id_fkey";
ALTER TABLE "inp_weir" DROP CONSTRAINT IF EXISTS "inp_weir_node_id_fkey";
ALTER TABLE "inp_weir" DROP CONSTRAINT IF EXISTS "inp_weir_to_arc_fkey";
ALTER TABLE "inp_weir" DROP CONSTRAINT IF EXISTS "inp_weir_weir_type_fkey";
ALTER TABLE "inp_weir" DROP CONSTRAINT IF EXISTS "inp_weir_flap_fkey";

ALTER TABLE "inp_windspeed" DROP CONSTRAINT IF EXISTS "inp_windspeed_wind_type_fkey";

--FLOW REGULATOR
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_node_id_fkey";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_to_arc_fkey";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_shape_fkey";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_ori_type_fkey";

ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_node_id_fkey";
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_curve_id_fkey";
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_outlet_type_fkey";
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_to_arc_fkey";

ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_node_id_fkey";
ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_curve_id_fkey";
ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_to_arc_fkey";
ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_status_fkey";

ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_node_id_fkey";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_to_arc_fkey";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_weir_type_fkey";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_flap_fkey";




--RPT
ALTER TABLE "rpt_inp_node" DROP CONSTRAINT IF EXISTS "rpt_inp_node_result_id_fkey";

ALTER TABLE "rpt_inp_arc" DROP CONSTRAINT IF EXISTS "rpt_inp_arc_result_id_fkey";

ALTER TABLE "rpt_arcflow_sum" DROP CONSTRAINT IF EXISTS "rpt_arcflow_sum_result_id_fkey";

ALTER TABLE "rpt_arcpolload_sum" DROP CONSTRAINT IF EXISTS "rpt_arcpolload_sum_result_id_fkey";

ALTER TABLE "rpt_condsurcharge_sum" DROP CONSTRAINT IF EXISTS "rpt_condsurcharge_sum_result_id_fkey";

ALTER TABLE "rpt_continuity_errors" DROP CONSTRAINT IF EXISTS "rpt_continuity_errors_result_id_fkey";

ALTER TABLE "rpt_critical_elements" DROP CONSTRAINT IF EXISTS "rpt_critical_elements_result_id_fkey";

ALTER TABLE "rpt_flowclass_sum" DROP CONSTRAINT IF EXISTS "rpt_flowclass_sum_result_id_fkey";

ALTER TABLE "rpt_flowrouting_cont" DROP CONSTRAINT IF EXISTS "rpt_flowrouting_cont_result_id_fkey";

ALTER TABLE "rpt_groundwater_cont" DROP CONSTRAINT IF EXISTS "rpt_groundwater_cont_result_id_fkey";

ALTER TABLE "rpt_high_conterrors" DROP CONSTRAINT IF EXISTS "rpt_high_conterrors_result_id_fkey";

ALTER TABLE "rpt_high_flowinest_ind" DROP CONSTRAINT IF EXISTS "rpt_high_flowinest_ind_result_id_fkey";

ALTER TABLE "rpt_instability_index" DROP CONSTRAINT IF EXISTS "rpt_instability_index_result_id_fkey";

ALTER TABLE "rpt_lidperformance_sum" DROP CONSTRAINT IF EXISTS "rpt_lidperformance_sum_result_id_fkey";

ALTER TABLE "rpt_nodedepth_sum" DROP CONSTRAINT IF EXISTS "rpt_nodedepth_sum_result_id_fkey";

ALTER TABLE "rpt_nodeflooding_sum" DROP CONSTRAINT IF EXISTS "rpt_nodeflooding_sum_result_id_fkey";

ALTER TABLE "rpt_nodeinflow_sum" DROP CONSTRAINT IF EXISTS "rpt_nodeinflow_sum_result_id_fkey";

ALTER TABLE "rpt_nodesurcharge_sum" DROP CONSTRAINT IF EXISTS "rpt_nodesurcharge_sum_result_id_fkey";

ALTER TABLE "rpt_outfallflow_sum" DROP CONSTRAINT IF EXISTS "rpt_outfallflow_sum_result_id_fkey";

ALTER TABLE "rpt_outfallload_sum" DROP CONSTRAINT IF EXISTS "rpt_outfallload_sum_result_id_fkey";

ALTER TABLE "rpt_pumping_sum" DROP CONSTRAINT IF EXISTS "rpt_pumping_sum_result_id_fkey";

ALTER TABLE "rpt_qualrouting_cont" DROP CONSTRAINT IF EXISTS "rpt_qualrouting_cont_result_id_fkey";

ALTER TABLE "rpt_rainfall_dep" DROP CONSTRAINT IF EXISTS "rpt_rainfall_dep_result_id_fkey";

ALTER TABLE "rpt_routing_timestep" DROP CONSTRAINT IF EXISTS "rpt_routing_timestep_result_id_fkey";

ALTER TABLE "rpt_runoff_qual" DROP CONSTRAINT IF EXISTS "rpt_runoff_qual_result_id_fkey";

ALTER TABLE "rpt_runoff_quant" DROP CONSTRAINT IF EXISTS "rpt_runoff_quant_result_id_fkey";

ALTER TABLE "rpt_storagevol_sum" DROP CONSTRAINT IF EXISTS "rpt_storagevol_sum_result_id_fkey";

ALTER TABLE "rpt_subcatchwashoff_sum" DROP CONSTRAINT IF EXISTS "rpt_subcatchwashoff_sum_result_id_fkey";

ALTER TABLE "rpt_subcathrunoff_sum" DROP CONSTRAINT IF EXISTS "rpt_subcathrunoff_sum_result_id_fkey";

ALTER TABLE "rpt_timestep_critelem" DROP CONSTRAINT IF EXISTS "rpt_timestep_critelem_result_id_fkey";

--ADD
--INP
--ALTER TABLE "raingage" ADD CONSTRAINT "raingage_timser_id_fkey" FOREIGN KEY ("timser_id") REFERENCES "inp_timser_id" ("timser_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "raingage" ADD CONSTRAINT "raingage_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "raingage" ADD CONSTRAINT "raingage_form_type_fkey" FOREIGN KEY ("form_type") REFERENCES "inp_value_raingage" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "raingage" ADD CONSTRAINT "raingage_rgage_type_fkey" FOREIGN KEY ("rgage_type") REFERENCES "inp_typevalue_raingage" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "subcatchment" ADD CONSTRAINT "subcatchment_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "subcatchment" ADD CONSTRAINT "subcatchment_rg_id_fkey" FOREIGN KEY ("rg_id") REFERENCES "raingage" ("rg_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "subcatchment" ADD CONSTRAINT "subcatchment_snow_id_fkey" FOREIGN KEY ("snow_id") REFERENCES "inp_snowpack" ("snow_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "subcatchment" ADD CONSTRAINT "subcatchment_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "subcatchment" ADD CONSTRAINT "subcatchment_hydrology_id_fkey" FOREIGN KEY ("hydrology_id") REFERENCES "cat_hydrology" ("hydrology_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_hydrology" ADD CONSTRAINT "cat_hydrology_infiltration_id_fkey" FOREIGN KEY ("infiltration") REFERENCES "inp_value_options_in" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_selector_hydrology" ADD CONSTRAINT "inp_selector_hydrology_hydrology_id_cur_user" UNIQUE(hydrology_id, cur_user);
ALTER TABLE "inp_selector_hydrology" ADD CONSTRAINT "inp_selector_hydrology_hydrology_id_fkey" FOREIGN KEY ("hydrology_id") REFERENCES "cat_hydrology" ("hydrology_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_aquifer" ADD CONSTRAINT "inp_aquifer_pattern_id_fkey" FOREIGN KEY ("pattern_id") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_buildup_land_x_pol" ADD CONSTRAINT "inp_buildup_land_x_pol_landus_id_fkey" FOREIGN KEY ("landus_id") REFERENCES "inp_landuses" ("landus_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_buildup_land_x_pol" ADD CONSTRAINT "inp_buildup_land_x_pol_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "inp_pollutant" ("poll_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_conduit" ADD CONSTRAINT "inp_conduit_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_controls_x_node" ADD CONSTRAINT "inp_controls_x_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_controls_x_arc" ADD CONSTRAINT "inp_controls_x_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_coverage_land_x_subc" ADD CONSTRAINT "inp_coverage_land_x_subc_landus_id_fkey" FOREIGN KEY ("landus_id") REFERENCES "inp_landuses" ("landus_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_coverage_land_x_subc" ADD CONSTRAINT "inp_coverage_land_x_subc_subc_id_fkey" FOREIGN KEY ("subc_id") REFERENCES "subcatchment" ("subc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_curve" ADD CONSTRAINT "inp_curve_curve_id_fkey" FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_curve_id" ADD CONSTRAINT "inp_curve_id_curve_type_fkey" FOREIGN KEY ("curve_type") REFERENCES "inp_value_curve" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_divider" ADD CONSTRAINT "inp_divider_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_divider" ADD CONSTRAINT "inp_divider_curve_id_fkey" FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_divider" ADD CONSTRAINT "inp_divider_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_divider" ADD CONSTRAINT "inp_divider_divider_type_fkey" FOREIGN KEY ("divider_type") REFERENCES "inp_typevalue_divider" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_dwf" ADD CONSTRAINT "inp_dwf_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_dwf" ADD CONSTRAINT "inp_dwf_pat1_fkey" FOREIGN KEY ("pat1") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_dwf" ADD CONSTRAINT "inp_dwf_pat2_fkey" FOREIGN KEY ("pat1") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_dwf" ADD CONSTRAINT "inp_dwf_pat3_fkey" FOREIGN KEY ("pat1") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_dwf" ADD CONSTRAINT "inp_dwf_pat4_fkey" FOREIGN KEY ("pat1") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_dwf_pol_x_node" ADD CONSTRAINT "inp_dwf_pol_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_dwf_pol_x_node" ADD CONSTRAINT "inp_dwf_pol_x_node_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "inp_pollutant" ("poll_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_dwf_pol_x_node" ADD CONSTRAINT "inp_dwf_pol_x_node_pat1_fkey" FOREIGN KEY ("pat1") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_dwf_pol_x_node" ADD CONSTRAINT "inp_dwf_pol_x_node_pat2_fkey" FOREIGN KEY ("pat1") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_dwf_pol_x_node" ADD CONSTRAINT "inp_dwf_pol_x_node_pat3_fkey" FOREIGN KEY ("pat1") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_dwf_pol_x_node" ADD CONSTRAINT "inp_dwf_pol_x_node_pat4_fkey" FOREIGN KEY ("pat1") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "inp_evaporation" ADD CONSTRAINT "inp_evaporation_timser_id_fkey" FOREIGN KEY ("timser_id") REFERENCES "inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_evaporation" ADD CONSTRAINT "inp_evaporation_evap_type_fkey" FOREIGN KEY ("evap_type") REFERENCES "inp_typevalue_evap" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_groundwater" ADD CONSTRAINT "inp_groundwater_subc_id_fkey" FOREIGN KEY ("subc_id") REFERENCES "subcatchment" ("subc_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_groundwater" ADD CONSTRAINT "inp_groundwater_aquif_id_fkey" FOREIGN KEY ("aquif_id") REFERENCES "inp_aquifer" ("aquif_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_groundwater" ADD CONSTRAINT "inp_groundwater_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_inflows" ADD CONSTRAINT "inp_inflows_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_inflows" ADD CONSTRAINT "inp_inflows_timser_id_fkey" FOREIGN KEY ("timser_id") REFERENCES "inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_inflows" ADD CONSTRAINT "inp_inflows_pattern_id_fkey" FOREIGN KEY ("pattern_id") REFERENCES "inp_pattern" ("pattern_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_inflows_pol_x_node" ADD CONSTRAINT "inp_inflows_pol_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_inflows_pol_x_node" ADD CONSTRAINT "inp_inflows_pol_x_node_pattern_id_fkey" FOREIGN KEY ("pattern_id") REFERENCES "inp_pattern" ("pattern_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_inflows_pol_x_node" ADD CONSTRAINT "inp_inflows_pol_x_node_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "inp_pollutant" ("poll_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_inflows_pol_x_node" ADD CONSTRAINT "inp_inflows_pol_x_node_timser_id_fkey" FOREIGN KEY ("timser_id") REFERENCES "inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_inflows_pol_x_node" ADD CONSTRAINT "inp_inflows_pol_x_node_form_type_fkey" FOREIGN KEY ("form_type") REFERENCES "inp_value_inflows" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_junction" ADD CONSTRAINT "inp_junction_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_lid_control" ADD CONSTRAINT "inp_lid_control_lidco_type_fkey" FOREIGN KEY ("lidco_type") REFERENCES "inp_value_lidcontrol" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_lidusage_subc_x_lidco" ADD CONSTRAINT "inp_lidusage_subc_x_lidco_subc_id_fkey" FOREIGN KEY ("subc_id") REFERENCES "subcatchment" ("subc_id") ON DELETE CASCADE ON UPDATE CASCADE;

--ALTER TABLE "inp_lidusage_subc_x_lidco" ADD CONSTRAINT "inp_lidusage_subc_x_lidco_lidco_id_fkey" FOREIGN KEY ("lidco_id") REFERENCES "inp_lid_control" ("lidco_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_loadings_pol_x_subc" ADD CONSTRAINT "inp_loadings_pol_x_subc_subc_id_fkey" FOREIGN KEY ("subc_id") REFERENCES "subcatchment" ("subc_id") ON DELETE CASCADE ON UPDATE CASCADE;
--ALTER TABLE "inp_loadings_pol_x_subc" ADD CONSTRAINT "inp_loadings_pol_x_subc_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "inp_pollutant" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_allow_ponding_fkey" FOREIGN KEY ("allow_ponding") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_normal_flow_limited_fkey" FOREIGN KEY ("normal_flow_limited") REFERENCES "inp_value_options_nfl" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_inertial_damping_fkey" FOREIGN KEY ("inertial_damping") REFERENCES "inp_value_options_id" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_skip_steady_state_fkey" FOREIGN KEY ("skip_steady_state") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_quality_fkey" FOREIGN KEY ("ignore_quality") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_routing_fkey" FOREIGN KEY ("ignore_routing") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_groundwater_fkey" FOREIGN KEY ("ignore_groundwater") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_snowmelt_fkey" FOREIGN KEY ("ignore_snowmelt") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_rainfall_fkey" FOREIGN KEY ("ignore_rainfall") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_force_main_equation_fkey" FOREIGN KEY ("force_main_equation") REFERENCES "inp_value_options_fme" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_link_offsets_fkey" FOREIGN KEY ("link_offsets") REFERENCES "inp_value_options_lo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_flow_routing_fkey" FOREIGN KEY ("flow_routing") REFERENCES "inp_value_options_fr" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_flow_units_fkey" FOREIGN KEY ("flow_units") REFERENCES "inp_value_options_fu" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_orifice" ADD CONSTRAINT "inp_orifice_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_orifice" ADD CONSTRAINT "inp_orifice_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_orifice" ADD CONSTRAINT "inp_orifice_to_arc_fkey" FOREIGN KEY ("to_arc") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_orifice" ADD CONSTRAINT "inp_orifice_shape_fkey" FOREIGN KEY ("shape") REFERENCES "inp_value_orifice" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_orifice" ADD CONSTRAINT "inp_orifice_ori_type_fkey" FOREIGN KEY ("ori_type") REFERENCES "inp_typevalue_orifice" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_outfall" ADD CONSTRAINT "inp_outfall_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_outfall" ADD CONSTRAINT "inp_outfall_curve_id_fkey" FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_outfall" ADD CONSTRAINT "inp_outfall_timser_id_fkey" FOREIGN KEY ("timser_id") REFERENCES "inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_outfall" ADD CONSTRAINT "inp_outfall_type_fkey" FOREIGN KEY ("outfall_type") REFERENCES "inp_typevalue_outfall" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_outlet" ADD CONSTRAINT "inp_outlet_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_outlet" ADD CONSTRAINT "inp_outlet_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_outlet" ADD CONSTRAINT "inp_outlet_curve_id_fkey" FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_outlet" ADD CONSTRAINT "inp_outlet_outlet_type_fkey" FOREIGN KEY ("outlet_type") REFERENCES "inp_typevalue_outlet" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pattern" ADD CONSTRAINT "inp_pattern_pattern_type_fkey" FOREIGN KEY ("pattern_type") REFERENCES "inp_typevalue_pattern" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_curve_id_fkey" FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_to_arc_fkey" FOREIGN KEY ("to_arc") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_value_status" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_rdii" ADD CONSTRAINT "inp_rdii_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
--ALTER TABLE "inp_rdii" ADD CONSTRAINT "inp_rdii_hydro_id_fkey" FOREIGN KEY ("hydro_id") REFERENCES "inp_hydrograph" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_controls_fkey" FOREIGN KEY ("controls") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_input_fkey" FOREIGN KEY ("input") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_continuity_fkey" FOREIGN KEY ("continuity") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_flowstats_fkey" FOREIGN KEY ("flowstats") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_storage" ADD CONSTRAINT "inp_storage_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_storage" ADD CONSTRAINT "inp_storage_curve_id_fkey" FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_storage" ADD CONSTRAINT "inp_storage_storage_type_fkey" FOREIGN KEY ("storage_type") REFERENCES "inp_typevalue_storage" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_temperature" ADD CONSTRAINT "inp_temperature_timser_id_fkey" FOREIGN KEY  ("timser_id") REFERENCES "inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_timeseries" ADD CONSTRAINT "inp_timeseries_timser_id_fkey" FOREIGN KEY ("timser_id") REFERENCES "inp_timser_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_timser_id" ADD CONSTRAINT "inp_timser_id_timser_type_fkey" FOREIGN KEY ("timser_type") REFERENCES "inp_value_timserid" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_timser_id" ADD CONSTRAINT "inp_timser_id_times_type_fkey" FOREIGN KEY ("times_type") REFERENCES "inp_typevalue_timeseries" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_transects" ADD CONSTRAINT "inp_transects_tsect_id_fkey" FOREIGN KEY ("tsect_id") REFERENCES "inp_transects_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_treatment_node_x_pol" ADD CONSTRAINT "inp_treatment_node_x_pol_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_treatment_node_x_pol" ADD CONSTRAINT "inp_treatment_node_x_pol_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "inp_pollutant" ("poll_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_washoff_land_x_pol" ADD CONSTRAINT "inp_washoff_land_x_pol_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "inp_pollutant" ("poll_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_washoff_land_x_pol" ADD CONSTRAINT "inp_washoff_land_x_pol_landus_id_fkey" FOREIGN KEY ("landus_id") REFERENCES "inp_landuses" ("landus_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_weir" ADD CONSTRAINT "inp_weir_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_weir" ADD CONSTRAINT "inp_weir_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_weir" ADD CONSTRAINT "inp_weir_to_arc_fkey" FOREIGN KEY ("to_arc") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_weir" ADD CONSTRAINT "inp_weir_weir_type_fkey" FOREIGN KEY ("weir_type") REFERENCES "inp_value_weirs" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_weir" ADD CONSTRAINT "inp_weir_flap_fkey" FOREIGN KEY ("flap") REFERENCES "inp_value_yesno" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_windspeed" ADD CONSTRAINT "inp_windspeed_wind_type_fkey" FOREIGN KEY ("wind_type") REFERENCES "inp_typevalue_windsp" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


--FLOW REGULATOR
ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_to_arc_fkey" FOREIGN KEY ("to_arc") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_shape_fkey" FOREIGN KEY ("shape") REFERENCES "inp_value_orifice" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_ori_type_fkey" FOREIGN KEY ("ori_type") REFERENCES "inp_typevalue_orifice" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_outlet" ADD CONSTRAINT "inp_flwreg_outlet_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_outlet" ADD CONSTRAINT "inp_flwreg_outlet_curve_id_fkey" FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_outlet" ADD CONSTRAINT "inp_flwreg_outlet_outlet_type_fkey" FOREIGN KEY ("outlet_type") REFERENCES "inp_typevalue_outlet" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_outlet" ADD CONSTRAINT "inp_flwreg_outlet_to_arc_fkey" FOREIGN KEY ("to_arc") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_pump" ADD CONSTRAINT "inp_flwreg_pump_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_pump" ADD CONSTRAINT "inp_flwreg_pump_curve_id_fkey" FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_pump" ADD CONSTRAINT "inp_flwreg_pump_to_arc_fkey" FOREIGN KEY ("to_arc") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_pump" ADD CONSTRAINT "inp_flwreg_pump_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_value_status" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_to_arc_fkey" FOREIGN KEY ("to_arc") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_weir_type_fkey" FOREIGN KEY ("weir_type") REFERENCES "inp_value_weirs" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_flap_fkey" FOREIGN KEY ("flap") REFERENCES "inp_value_yesno" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

--RPT
ALTER TABLE "rpt_inp_node" ADD CONSTRAINT "rpt_inp_node_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_inp_arc" ADD CONSTRAINT "rpt_inp_arc_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_arcflow_sum" ADD CONSTRAINT "rpt_arcflow_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_arcpolload_sum" ADD CONSTRAINT "rpt_arcpolload_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_condsurcharge_sum" ADD CONSTRAINT "rpt_condsurcharge_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_continuity_errors" ADD CONSTRAINT "rpt_continuity_errors_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_critical_elements" ADD CONSTRAINT "rpt_critical_elements_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_flowclass_sum" ADD CONSTRAINT "rpt_flowclass_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_flowrouting_cont" ADD CONSTRAINT "rpt_flowrouting_cont_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_groundwater_cont" ADD CONSTRAINT "rpt_groundwater_cont_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_high_conterrors" ADD CONSTRAINT "rpt_high_conterrors_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_high_flowinest_ind" ADD CONSTRAINT "rpt_high_flowinest_ind_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_instability_index" ADD CONSTRAINT "rpt_instability_index_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_lidperformance_sum" ADD CONSTRAINT "rpt_lidperformance_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_nodedepth_sum" ADD CONSTRAINT "rpt_nodedepth_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_nodeflooding_sum" ADD CONSTRAINT "rpt_nodeflooding_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_nodeinflow_sum" ADD CONSTRAINT "rpt_nodeinflow_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_nodesurcharge_sum" ADD CONSTRAINT "rpt_nodesurcharge_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_outfallflow_sum" ADD CONSTRAINT "rpt_outfallflow_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_outfallload_sum" ADD CONSTRAINT "rpt_outfallload_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_pumping_sum" ADD CONSTRAINT "rpt_pumping_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_qualrouting_cont" ADD CONSTRAINT "rpt_qualrouting_cont_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_rainfall_dep" ADD CONSTRAINT "rpt_rainfall_dep_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_routing_timestep" ADD CONSTRAINT "rpt_routing_timestep_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_runoff_qual" ADD CONSTRAINT "rpt_runoff_qual_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_runoff_quant" ADD CONSTRAINT "rpt_runoff_quant_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_storagevol_sum" ADD CONSTRAINT "rpt_storagevol_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_subcatchwashoff_sum" ADD CONSTRAINT "rpt_subcatchwashoff_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_subcathrunoff_sum" ADD CONSTRAINT "rpt_subcathrunoff_sum_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_timestep_critelem" ADD CONSTRAINT "rpt_timestep_critelem_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

