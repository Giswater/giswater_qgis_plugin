/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE inp_timser_id DROP CONSTRAINT IF EXISTS inp_timser_id_check;

ALTER TABLE arc_type DROP CONSTRAINT IF EXISTS arc_type_epa_table_check;
ALTER TABLE arc_type DROP CONSTRAINT IF EXISTS arc_type_man_table_check;

ALTER TABLE node_type DROP CONSTRAINT IF EXISTS node_type_epa_table_check;
ALTER TABLE node_type DROP CONSTRAINT IF EXISTS node_type_man_table_check;

ALTER TABLE connec_type DROP CONSTRAINT IF EXISTS connec_type_man_table_check;

ALTER TABLE gully_type DROP CONSTRAINT IF EXISTS gully_type_man_table_check;


--INP
ALTER TABLE "raingage" DROP CONSTRAINT IF EXISTS "raingage_form_type_fkey";

ALTER TABLE subcatchment DROP CONSTRAINT IF EXISTS subcatchment_snow_id_fkey;
ALTER TABLE "subcatchment" DROP CONSTRAINT IF EXISTS "subcatchment_routeto_fkey";

ALTER TABLE "cat_hydrology" DROP CONSTRAINT IF EXISTS "cat_hydrology_infiltration_id_fkey";

ALTER TABLE "inp_files" DROP CONSTRAINT  IF EXISTS "inp_files_actio_type_fkey";
ALTER TABLE "inp_files" DROP CONSTRAINT IF EXISTS  "inp_files_file_type_fkey";


ALTER TABLE "inp_pollutant" DROP CONSTRAINT IF EXISTS"inp_pollutant_units_type_fkey";


ALTER TABLE "inp_buildup_land_x_pol" DROP CONSTRAINT IF EXISTS "inp_buildup_land_x_pol_funcb_type_fkey";
ALTER TABLE "inp_curve_id" DROP CONSTRAINT 	IF EXISTS "inp_curve_id_curve_type_fkey";

ALTER TABLE "inp_divider" DROP CONSTRAINT IF EXISTS "inp_divider_divider_type_fkey";

ALTER TABLE "inp_evaporation" DROP CONSTRAINT IF EXISTS "inp_evaporation_evap_type_fkey";

ALTER TABLE "inp_inflows_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_inflows_pol_x_node_form_type_fkey";


ALTER TABLE "inp_lid_control" DROP CONSTRAINT IF EXISTS "inp_lid_control_lidco_type_fkey";


ALTER TABLE inp_dwf DROP CONSTRAINT IF EXISTS inp_dwf_pat1_fkey;
ALTER TABLE inp_dwf DROP CONSTRAINT IF EXISTS inp_dwf_pat2_fkey;
ALTER TABLE inp_dwf DROP CONSTRAINT IF EXISTS inp_dwf_pat3_fkey;
ALTER TABLE inp_dwf DROP CONSTRAINT IF EXISTS inp_dwf_pat4_fkey;

ALTER TABLE inp_dwf_pol_x_node DROP CONSTRAINT IF EXISTS inp_dwf_pol_x_node_pat1_fkey;
ALTER TABLE inp_dwf_pol_x_node DROP CONSTRAINT IF EXISTS inp_dwf_pol_x_node_pat2_fkey;
ALTER TABLE inp_dwf_pol_x_node DROP CONSTRAINT IF EXISTS inp_dwf_pol_x_node_pat3_fkey;
ALTER TABLE inp_dwf_pol_x_node DROP CONSTRAINT IF EXISTS inp_dwf_pol_x_node_pat4_fkey;

ALTER TABLE inp_inflows DROP CONSTRAINT IF EXISTS inp_inflows_pattern_id_fkey;
ALTER TABLE inp_inflows_pol_x_node DROP CONSTRAINT IF EXISTS inp_inflows_pol_x_node_pattern_id_fkey;


ALTER TABLE inp_aquifer DROP CONSTRAINT IF EXISTS inp_aquifer_pattern_id_fkey;


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

ALTER TABLE "inp_orifice" DROP CONSTRAINT IF EXISTS "inp_orifice_shape_fkey";
ALTER TABLE "inp_orifice" DROP CONSTRAINT IF EXISTS "inp_orifice_ori_type_fkey";

ALTER TABLE "inp_outfall" DROP CONSTRAINT IF EXISTS "inp_outfall_type_fkey";

ALTER TABLE "inp_outlet" DROP CONSTRAINT IF EXISTS "inp_outlet_outlet_type_fkey";

ALTER TABLE "inp_pattern" DROP CONSTRAINT IF EXISTS "inp_pattern_pattern_type_fkey";

ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_status_fkey";

ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_controls_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_input_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_continuity_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_flowstats_fkey";

ALTER TABLE "inp_storage" DROP CONSTRAINT IF EXISTS "inp_storage_storage_type_fkey";

ALTER TABLE "inp_temperature" DROP CONSTRAINT IF EXISTS "inp_temperature_temp_type_fkey";

ALTER TABLE "inp_timser_id" DROP CONSTRAINT IF EXISTS "inp_timser_id_timser_type_fkey";
ALTER TABLE "inp_timser_id" DROP CONSTRAINT IF EXISTS "inp_timser_id_times_type_fkey";


ALTER TABLE "inp_washoff_land_x_pol" DROP CONSTRAINT IF EXISTS "inp_washoff_land_x_pol_funcw_type_fkey";

ALTER TABLE "inp_weir" DROP CONSTRAINT IF EXISTS "inp_weir_weir_type_fkey";
ALTER TABLE "inp_weir" DROP CONSTRAINT IF EXISTS "inp_weir_flap_fkey";


ALTER TABLE cat_arc_shape DROP CONSTRAINT cat_arc_shape_epa_fkey;

ALTER TABLE inp_flwreg_orifice DROP CONSTRAINT IF EXISTS inp_flwreg_orifice_ori_type_fkey;
ALTER TABLE inp_flwreg_orifice DROP CONSTRAINT IF EXISTS inp_flwreg_orifice_shape_fkey;
ALTER TABLE inp_flwreg_outlet DROP CONSTRAINT IF EXISTS inp_flwreg_outlet_outlet_type_fkey;
ALTER TABLE inp_flwreg_pump DROP CONSTRAINT IF EXISTS inp_flwreg_pump_status_fkey;
ALTER TABLE inp_flwreg_weir DROP CONSTRAINT IF EXISTS inp_flwreg_weir_weir_type_fkey;




--DROP CHECK

ALTER TABLE "inp_typevalue_timeseries" DROP CONSTRAINT IF EXISTS "inp_typevalue_timeseries_check";
ALTER TABLE "inp_timser_id" DROP CONSTRAINT IF EXISTS "inp_timser_id_check";
ALTER TABLE "inp_value_files_actio" DROP CONSTRAINT IF EXISTS "inp_value_files_actio_check";
ALTER TABLE "inp_typevalue_storage" DROP CONSTRAINT IF EXISTS "inp_typevalue_storage_check";
ALTER TABLE "inp_value_weirs" DROP CONSTRAINT IF EXISTS "inp_value_weirs_check";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_check";
ALTER TABLE "inp_value_curve" DROP CONSTRAINT IF EXISTS "inp_value_curve_check";
ALTER TABLE "inp_typevalue_divider" DROP CONSTRAINT IF EXISTS "inp_typevalue_divider_check";
ALTER TABLE "inp_value_routeto" DROP CONSTRAINT IF EXISTS "inp_value_routeto_check";
ALTER TABLE "inp_typevalue_outlet" DROP CONSTRAINT IF EXISTS "inp_typevalue_outlet_check";
ALTER TABLE "inp_typevalue_orifice" DROP CONSTRAINT IF EXISTS "inp_typevalue_orifice_check";
ALTER TABLE "inp_typevalue_pattern" DROP CONSTRAINT IF EXISTS "inp_typevalue_pattern_check";
ALTER TABLE "inp_value_catarc" DROP CONSTRAINT IF EXISTS "inp_value_catarc_check";
ALTER TABLE "inp_typevalue_windsp" DROP CONSTRAINT IF EXISTS "inp_typevalue_windsp_check";
ALTER TABLE "inp_value_files_type" DROP CONSTRAINT IF EXISTS "inp_value_files_type_check";
ALTER TABLE "inp_value_lidcontrol" DROP CONSTRAINT IF EXISTS "inp_value_lidcontrol_check";
ALTER TABLE "inp_typevalue_evap" DROP CONSTRAINT IF EXISTS "inp_typevalue_evap_check";
ALTER TABLE "inp_value_treatment" DROP CONSTRAINT IF EXISTS "inp_value_treatment_check";
ALTER TABLE "inp_typevalue_temp" DROP CONSTRAINT IF EXISTS "inp_typevalue_temp_check";
ALTER TABLE "inp_value_orifice" DROP CONSTRAINT IF EXISTS "inp_value_orifice_check";
ALTER TABLE "inp_typevalue_outfall" DROP CONSTRAINT IF EXISTS "inp_typevalue_outfall_check";
ALTER TABLE "inp_value_pollutants" DROP CONSTRAINT IF EXISTS "inp_value_pollutants_check";
ALTER TABLE "inp_value_inflows" DROP CONSTRAINT IF EXISTS "inp_value_inflows_check";
ALTER TABLE "inp_value_status" DROP CONSTRAINT IF EXISTS "inp_value_status_check";
ALTER TABLE "inp_value_raingage" DROP CONSTRAINT IF EXISTS "inp_value_raingage_check";
ALTER TABLE "inp_value_washoff" DROP CONSTRAINT IF EXISTS "inp_value_washoff_check";
ALTER TABLE "inp_value_yesno" DROP CONSTRAINT IF EXISTS "inp_value_yesno_check";
ALTER TABLE "inp_value_buildup" DROP CONSTRAINT IF EXISTS "inp_value_buildup_check";
ALTER TABLE "inp_value_allnone" DROP CONSTRAINT IF EXISTS "inp_value_allnone_check";
ALTER TABLE "inp_typevalue_raingage" DROP CONSTRAINT IF EXISTS "inp_typevalue_raingage_check";
ALTER TABLE "inp_value_options_fr" DROP CONSTRAINT IF EXISTS "inp_value_options_fr_check";
ALTER TABLE "inp_value_options_lo" DROP CONSTRAINT IF EXISTS "inp_value_options_lo_check";
ALTER TABLE "inp_value_mapunits" DROP CONSTRAINT IF EXISTS "inp_value_mapunits_check";
ALTER TABLE "inp_value_options_fme" DROP CONSTRAINT IF EXISTS "inp_value_options_fme_check";
ALTER TABLE "inp_value_options_nfl" DROP CONSTRAINT IF EXISTS "inp_value_options_nfl_check";
ALTER TABLE "inp_value_options_id" DROP CONSTRAINT IF EXISTS "inp_value_options_id_check";
ALTER TABLE "inp_arc_type" DROP CONSTRAINT IF EXISTS "inp_arc_type_check";
ALTER TABLE "inp_node_type" DROP CONSTRAINT IF EXISTS "inp_node_type_check";
ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_check";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_check";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_check" ;
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_check" ;