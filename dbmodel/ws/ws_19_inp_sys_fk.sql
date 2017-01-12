/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Fk 11
-- ----------------------------
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_epa_type_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_epa_type_fkey" FOREIGN KEY ("epa_type") REFERENCES "inp_arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_epa_type_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_epa_type_fkey" FOREIGN KEY ("epa_type") REFERENCES "inp_node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_cat_mat_roughness" DROP CONSTRAINT IF EXISTS "inp_cat_mat_roughness_matcat_id_fkey";
ALTER TABLE "inp_cat_mat_roughness" ADD CONSTRAINT "inp_cat_mat_roughness_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_arc" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_curve" DROP CONSTRAINT IF EXISTS "inp_curve_curve_id_fkey";
ALTER TABLE "inp_curve" ADD CONSTRAINT "inp_curve_curve_id_fkey" FOREIGN KEY ("curve_id") REFERENCES "inp_curve_id" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_demand" DROP CONSTRAINT IF EXISTS "inp_demand_node_id_fkey";
ALTER TABLE "inp_demand" ADD CONSTRAINT "inp_demand_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_emitter" DROP CONSTRAINT IF EXISTS "inp_emitter_node_id_fkey";
ALTER TABLE "inp_emitter" ADD CONSTRAINT "inp_emitter_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_junction" DROP CONSTRAINT IF EXISTS "inp_junction_node_id_fkey";
ALTER TABLE "inp_junction" ADD CONSTRAINT "inp_junction_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_mixing" DROP CONSTRAINT IF EXISTS "inp_mixing_node_id_fkey";
ALTER TABLE "inp_mixing" ADD CONSTRAINT "inp_mixing_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_units_fkey";
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_units_fkey" FOREIGN KEY ("units") REFERENCES "inp_value_opti_units" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_hydraulics_fkey";
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_hydraulics_fkey" FOREIGN KEY ("hydraulics") REFERENCES "inp_value_opti_hyd" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_headloss_fkey";
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_headloss_fkey" FOREIGN KEY ("headloss") REFERENCES "inp_value_opti_headloss" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_quality_fkey";
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_quality_fkey" FOREIGN KEY ("quality") REFERENCES "inp_value_opti_qual" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_unbalanced_fkey";
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_unbalanced_fkey" FOREIGN KEY ("unbalanced") REFERENCES "inp_value_opti_unbal" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_pipe" DROP CONSTRAINT IF EXISTS "inp_pipe_arc_id_fkey";
ALTER TABLE "inp_pipe" ADD CONSTRAINT "inp_pipe_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_node_id_fkey";
ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_shortpipe" DROP CONSTRAINT IF EXISTS "inp_shortpipe_node_id_fkey";
ALTER TABLE "inp_shortpipe" ADD CONSTRAINT "inp_shortpipe_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_pressure_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_pressure_fkey" FOREIGN KEY ("pressure") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_demand_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_demand_fkey" FOREIGN KEY ("demand") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_status_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_value_yesnofull" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_summary_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_summary_fkey" FOREIGN KEY ("summary") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_energy_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_energy_fkey" FOREIGN KEY ("energy") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_elevation_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_elevation_fkey" FOREIGN KEY ("elevation") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_head_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_head_fkey" FOREIGN KEY ("head") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_quality_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_quality_fkey" FOREIGN KEY ("quality") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_length_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_length_fkey" FOREIGN KEY ("length") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_diameter_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_diameter_fkey" FOREIGN KEY ("diameter") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_flow_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_flow_fkey" FOREIGN KEY ("flow") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_velocity_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_velocity_fkey" FOREIGN KEY ("velocity") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_headloss_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_headloss_fkey" FOREIGN KEY ("headloss") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_setting_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_setting_fkey" FOREIGN KEY ("setting") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_reaction_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_reaction_fkey" FOREIGN KEY ("reaction") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_f_factor_fkey";
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_f_factor_fkey" FOREIGN KEY ("f_factor") REFERENCES "inp_value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_reservoir" DROP CONSTRAINT IF EXISTS "inp_reservoir_node_id_fkey";
ALTER TABLE "inp_reservoir" ADD CONSTRAINT "inp_reservoir_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_source" DROP CONSTRAINT IF EXISTS "inp_source_node_id_fkey";
ALTER TABLE "inp_source" ADD CONSTRAINT "inp_source_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_tank" DROP CONSTRAINT IF EXISTS "inp_tank_node_id_fkey";
ALTER TABLE "inp_tank" ADD CONSTRAINT "inp_tank_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_times" DROP CONSTRAINT IF EXISTS "inp_times_statistic_fkey";
ALTER TABLE "inp_times" ADD CONSTRAINT "inp_times_statistic_fkey" FOREIGN KEY ("statistic") REFERENCES "inp_value_times" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_node_id_fkey";
ALTER TABLE "inp_valve" ADD CONSTRAINT "inp_valve_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_arc" DROP CONSTRAINT IF EXISTS "rpt_arc_result_id_fkey";
ALTER TABLE "rpt_arc" ADD CONSTRAINT "rpt_arc_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;
--ALTER TABLE "rpt_arc" DROP CONSTRAINT IF EXISTS "rpt_arc_arc_id_fkey";
-- ALTER TABLE "rpt_arc" ADD CONSTRAINT "rpt_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_energy_usage" DROP CONSTRAINT IF EXISTS "rpt_energy_usage_result_id_fkey";
ALTER TABLE "rpt_energy_usage" ADD CONSTRAINT "rpt_energy_usage_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;
--ALTER TABLE "rpt_energy_usage" DROP CONSTRAINT IF EXISTS "rpt_energy_usage_node_id_fkey";
--ALTER TABLE "rpt_energy_usage" ADD CONSTRAINT "rpt_energy_usage_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "rpt_hydraulic_status" DROP CONSTRAINT IF EXISTS "rpt_hydraulic_status_result_id_fkey";
ALTER TABLE "rpt_hydraulic_status" ADD CONSTRAINT "rpt_hydraulic_status_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "rpt_node" DROP CONSTRAINT IF EXISTS "rpt_node_result_id_fkey";
ALTER TABLE "rpt_node" ADD CONSTRAINT "rpt_node_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "rpt_cat_result" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;
--ALTER TABLE "rpt_node" DROP CONSTRAINT IF EXISTS "rpt_node_node_id_fkey";
-- ALTER TABLE "rpt_node" ADD CONSTRAINT "rpt_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_selector_state" DROP CONSTRAINT IF EXISTS "inp_selector_state_id_fkey";
ALTER TABLE "inp_selector_state" ADD CONSTRAINT "inp_selector_state_id_fkey" FOREIGN KEY ("id") REFERENCES "value_state" ("id");
