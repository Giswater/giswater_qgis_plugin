/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Fk 11
-- ----------------------------

--DROP
--INP

ALTER TABLE "inp_curve_id" DROP CONSTRAINT IF EXISTS "inp_curve_id_curve_type_fkey";
ALTER TABLE "inp_energy_el" DROP CONSTRAINT IF EXISTS "inp_energy_el_parameter_fkey";
ALTER TABLE "inp_energy_gl" DROP CONSTRAINT IF EXISTS "inp_energy_gl_parameter_fkey";
ALTER TABLE "inp_energy_gl" DROP CONSTRAINT IF EXISTS "inp_energy_gl_energ_type_fkey";
ALTER TABLE "inp_mixing" DROP CONSTRAINT IF EXISTS "inp_mixing_mix_type_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_units_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_hydraulics_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_headloss_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_quality_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_unbalanced_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_coefficient_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_valve_mode_fkey";
ALTER TABLE "inp_pipe" DROP CONSTRAINT IF EXISTS "inp_pipe_status_fkey";
ALTER TABLE "inp_shortpipe" DROP CONSTRAINT IF EXISTS "inp_shortpipe_status_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_curve_id_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_to_arc_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_status_fkey";
ALTER TABLE "inp_reactions_el" DROP CONSTRAINT IF EXISTS "inp_reactions_el_parameter_fkey";
ALTER TABLE "inp_reactions_gl" DROP CONSTRAINT IF EXISTS "inp_reactions_gl_parameter_fkey";
ALTER TABLE "inp_reactions_gl" DROP CONSTRAINT IF EXISTS "inp_reactions_gl_react_type_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_pressure_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_demand_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_status_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_summary_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_energy_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_elevation_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_head_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_quality_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_length_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_diameter_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_flow_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_velocity_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_headloss_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_setting_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_reaction_fkey";
ALTER TABLE "inp_report" DROP CONSTRAINT IF EXISTS "inp_report_f_factor_fkey";
ALTER TABLE "inp_source" DROP CONSTRAINT IF EXISTS "inp_source_source_type_fkey" ;
ALTER TABLE "inp_tank" DROP CONSTRAINT IF EXISTS "inp_tank_curve_id_fkey";
ALTER TABLE "inp_times" DROP CONSTRAINT IF EXISTS "inp_times_statistic_fkey";
ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_valv_type_fkey";
ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_status_fkey";
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_status_fkey";

--ADD
--INP


ALTER TABLE  inp_typevalue add CONSTRAINT inp_typevalue_id_unique UNIQUE(id);
ALTER TABLE "inp_curve_id" ADD CONSTRAINT "inp_curve_id_curve_type_fkey" FOREIGN KEY ("curve_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_energy_el" ADD CONSTRAINT "inp_energy_el_parameter_fkey" FOREIGN KEY ("parameter") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_energy_gl" ADD CONSTRAINT "inp_energy_gl_parameter_fkey" FOREIGN KEY ("parameter") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_energy_gl" ADD CONSTRAINT "inp_energy_gl_energ_type_fkey" FOREIGN KEY ("energ_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_mixing" ADD CONSTRAINT "inp_mixing_mix_type_fkey" FOREIGN KEY ("mix_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_units_fkey" FOREIGN KEY ("units") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_hydraulics_fkey" FOREIGN KEY ("hydraulics") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_headloss_fkey" FOREIGN KEY ("headloss") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_quality_fkey" FOREIGN KEY ("quality") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_unbalanced_fkey" FOREIGN KEY ("unbalanced") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_coefficient_fkey" FOREIGN KEY ("rtc_coefficient") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_options" ADD CONSTRAINT "inp_options_valve_mode_fkey" FOREIGN KEY ("valve_mode") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pipe" ADD CONSTRAINT "inp_pipe_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_shortpipe" ADD CONSTRAINT "inp_shortpipe_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump" ADD CONSTRAINT "inp_pump_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_reactions_el" ADD CONSTRAINT "inp_reactions_el_parameter_fkey" FOREIGN KEY ("parameter") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_reactions_gl" ADD CONSTRAINT "inp_reactions_gl_parameter_fkey" FOREIGN KEY ("parameter") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_reactions_gl" ADD CONSTRAINT "inp_reactions_gl_react_type_fkey" FOREIGN KEY ("react_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_pressure_fkey" FOREIGN KEY ("pressure") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_demand_fkey" FOREIGN KEY ("demand") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_summary_fkey" FOREIGN KEY ("summary") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_energy_fkey" FOREIGN KEY ("energy") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_elevation_fkey" FOREIGN KEY ("elevation") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_head_fkey" FOREIGN KEY ("head") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_quality_fkey" FOREIGN KEY ("quality") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_length_fkey" FOREIGN KEY ("length") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_diameter_fkey" FOREIGN KEY ("diameter") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_flow_fkey" FOREIGN KEY ("flow") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_velocity_fkey" FOREIGN KEY ("velocity") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_headloss_fkey" FOREIGN KEY ("headloss") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_setting_fkey" FOREIGN KEY ("setting") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_reaction_fkey" FOREIGN KEY ("reaction") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "inp_report" ADD CONSTRAINT "inp_report_f_factor_fkey" FOREIGN KEY ("f_factor") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_source" ADD CONSTRAINT "inp_source_source_type_fkey" FOREIGN KEY ("source_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_times" ADD CONSTRAINT "inp_times_statistic_fkey" FOREIGN KEY ("statistic") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_valve" ADD CONSTRAINT "inp_valve_valv_type_fkey" FOREIGN KEY ("valv_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_valve" ADD CONSTRAINT "inp_valve_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump_additional" ADD CONSTRAINT "inp_pump_additional_status_fkey" FOREIGN KEY ("pattern") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
