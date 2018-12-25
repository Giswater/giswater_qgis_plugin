/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


--DROP
--INP

ALTER TABLE "raingage" DROP CONSTRAINT IF EXISTS "raingage_form_type_fkey";
ALTER TABLE "raingage" DROP CONSTRAINT IF EXISTS "raingage_rgage_type_fkey" ;


ALTER TABLE "subcatchment" DROP CONSTRAINT IF EXISTS "subcatchment_routeto_fkey";

ALTER TABLE "cat_hydrology" DROP CONSTRAINT IF EXISTS "cat_hydrology_infiltration_id_fkey";

ALTER TABLE "inp_files" DROP CONSTRAINT  IF EXISTS "inp_files_actio_type_fkey";
ALTER TABLE "inp_files" DROP CONSTRAINT IF EXISTS  "inp_files_file_type_fkey";



ALTER TABLE "inp_pollutant" DROP CONSTRAINT IF EXISTS"inp_pollutant_units_type_fkey";


ALTER TABLE "inp_buildup_land_x_pol" DROP CONSTRAINT IF EXISTS "inp_buildup_land_x_pol_funcb_type_fkey";


ALTER TABLE "inp_divider" DROP CONSTRAINT IF EXISTS "inp_divider_divider_type_fkey";



ALTER TABLE "inp_evaporation" DROP CONSTRAINT IF EXISTS "inp_evaporation_evap_type_fkey";

ALTER TABLE "inp_inflows_pol_x_node" DROP CONSTRAINT IF EXISTS "inp_inflows_pol_x_node_form_type_fkey";


ALTER TABLE "inp_lid_control" DROP CONSTRAINT IF EXISTS "inp_lid_control_lidco_type_fkey";


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


--FLOW REGULATOR
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_shape_fkey";
ALTER TABLE "inp_flwreg_orifice" DROP CONSTRAINT IF EXISTS "inp_flwreg_orifice_ori_type_fkey";

ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_outlet_type_fkey";
ALTER TABLE "inp_flwreg_outlet" DROP CONSTRAINT IF EXISTS "inp_flwreg_outlet_to_arc_fkey";

ALTER TABLE "inp_flwreg_pump" DROP CONSTRAINT IF EXISTS "inp_flwreg_pump_status_fkey";

ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_weir_type_fkey";
ALTER TABLE "inp_flwreg_weir" DROP CONSTRAINT IF EXISTS "inp_flwreg_weir_flap_fkey";


--ADD
--INP
ALTER TABLE "inp_typevalue" ADD CONSTRAINT "inp_typevalue_id_unique" UNIQUE(id);

ALTER TABLE "raingage" ADD CONSTRAINT "raingage_form_type_fkey" FOREIGN KEY ("form_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "raingage" ADD CONSTRAINT "raingage_rgage_type_fkey" FOREIGN KEY ("rgage_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "subcatchment" ADD CONSTRAINT "subcatchment_routeto_fkey" FOREIGN KEY ("routeto") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_hydrology" ADD CONSTRAINT "cat_hydrology_infiltration_id_fkey" FOREIGN KEY ("infiltration") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_files" ADD CONSTRAINT "inp_files_actio_type_fkey" FOREIGN KEY ("actio_type") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_files" ADD CONSTRAINT "inp_files_file_type_fkey" FOREIGN KEY ("file_type") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_pollutant" ADD CONSTRAINT "inp_pollutant_units_type_fkey" FOREIGN KEY ("units_type") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_buildup_land_x_pol" ADD CONSTRAINT "inp_buildup_land_x_pol_funcb_type_fkey" FOREIGN KEY ("funcb_type") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_curve_id" ADD CONSTRAINT "inp_curve_id_curve_type_fkey" FOREIGN KEY ("curve_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_divider" ADD CONSTRAINT "inp_divider_divider_type_fkey" FOREIGN KEY ("divider_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_evaporation" ADD CONSTRAINT "inp_evaporation_evap_type_fkey" FOREIGN KEY ("evap_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_inflows_pol_x_node" ADD CONSTRAINT "inp_inflows_pol_x_node_form_type_fkey" FOREIGN KEY ("form_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_lid_control" ADD CONSTRAINT "inp_lid_control_lidco_type_fkey" FOREIGN KEY ("lidco_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_allow_ponding_fkey" FOREIGN KEY ("allow_ponding") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_normal_flow_limited_fkey" FOREIGN KEY ("normal_flow_limited") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_inertial_damping_fkey" FOREIGN KEY ("inertial_damping") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_skip_steady_state_fkey" FOREIGN KEY ("skip_steady_state") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_quality_fkey" FOREIGN KEY ("ignore_quality") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_routing_fkey" FOREIGN KEY ("ignore_routing") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_groundwater_fkey" FOREIGN KEY ("ignore_groundwater") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_snowmelt_fkey" FOREIGN KEY ("ignore_snowmelt") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_ignore_rainfall_fkey" FOREIGN KEY ("ignore_rainfall") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_force_main_equation_fkey" FOREIGN KEY ("force_main_equation") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_link_offsets_fkey" FOREIGN KEY ("link_offsets") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_flow_routing_fkey" FOREIGN KEY ("flow_routing") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_flow_units_fkey" FOREIGN KEY ("flow_units") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_orifice" ADD CONSTRAINT "inp_orifice_shape_fkey" FOREIGN KEY ("shape") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_orifice" ADD CONSTRAINT "inp_orifice_ori_type_fkey" FOREIGN KEY ("ori_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "inp_outfall" ADD CONSTRAINT "inp_outfall_type_fkey" FOREIGN KEY ("outfall_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "inp_outlet" ADD CONSTRAINT "inp_outlet_outlet_type_fkey" FOREIGN KEY ("outlet_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pattern" ADD CONSTRAINT "inp_pattern_pattern_type_fkey" FOREIGN KEY ("pattern_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_controls_fkey" FOREIGN KEY ("controls") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_input_fkey" FOREIGN KEY ("input") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_continuity_fkey" FOREIGN KEY ("continuity") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_flowstats_fkey" FOREIGN KEY ("flowstats") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "inp_storage" ADD CONSTRAINT "inp_storage_storage_type_fkey" FOREIGN KEY ("storage_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_temperature" ADD CONSTRAINT "inp_temperature_temp_type_fkey" FOREIGN KEY  ("temp_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_timser_id" ADD CONSTRAINT "inp_timser_id_timser_type_fkey" FOREIGN KEY ("timser_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_timser_id" ADD CONSTRAINT "inp_timser_id_times_type_fkey" FOREIGN KEY ("times_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_washoff_land_x_pol" ADD CONSTRAINT "inp_washoff_land_x_pol_funcw_type_fkey" FOREIGN KEY ("funcw_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_weir" ADD CONSTRAINT "inp_weir_weir_type_fkey" FOREIGN KEY ("weir_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_weir" ADD CONSTRAINT "inp_weir_flap_fkey" FOREIGN KEY ("flap") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;



--FLOW REGULATOR

ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_shape_fkey" FOREIGN KEY ("shape") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_orifice" ADD CONSTRAINT "inp_flwreg_orifice_ori_type_fkey" FOREIGN KEY ("ori_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_outlet" ADD CONSTRAINT "inp_flwreg_outlet_outlet_type_fkey" FOREIGN KEY ("outlet_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_pump" ADD CONSTRAINT "inp_flwreg_pump_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_weir_type_fkey" FOREIGN KEY ("weir_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_flwreg_weir" ADD CONSTRAINT "inp_flwreg_weir_flap_fkey" FOREIGN KEY ("flap") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
