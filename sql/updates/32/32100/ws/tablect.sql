/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- incorporate constraints not defined on 31
--------------------------------------------
ALTER TABLE node ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE arc ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE connec ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE element ALTER COLUMN state_type SET NOT NULL;

ALTER TABLE node ALTER COLUMN state SET NOT NULL;
ALTER TABLE arc ALTER COLUMN state SET NOT NULL;
ALTER TABLE connec ALTER COLUMN state SET NOT NULL;
ALTER TABLE element ALTER COLUMN state SET NOT NULL;


-- ----------------------------
-- Fk 11
-- ----------------------------

--DROP FK
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
ALTER TABLE "inp_source" DROP CONSTRAINT IF EXISTS "inp_source_sourc_type_fkey" ;
ALTER TABLE "inp_tank" DROP CONSTRAINT IF EXISTS "inp_tank_curve_id_fkey";
ALTER TABLE "inp_times" DROP CONSTRAINT IF EXISTS "inp_times_statistic_fkey";
ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_valv_type_fkey";
ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_status_fkey";
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_status_fkey";


--DROP CHECK
ALTER TABLE inp_typevalue DROP CONSTRAINT IF EXISTS inp_typevalue_check;

ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_check";
ALTER TABLE "inp_project_id" DROP CONSTRAINT IF EXISTS "inp_project_id_check";

ALTER TABLE "inp_arc_type" DROP CONSTRAINT IF EXISTS "inp_arc_type_check";
ALTER TABLE "inp_node_type" DROP CONSTRAINT IF EXISTS "inp_node_type_check";
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_check";



ALTER TABLE inp_energy_el DROP CONSTRAINT IF EXISTS inp_energy_el_parameter_check;
ALTER TABLE inp_energy_gl DROP CONSTRAINT IF EXISTS inp_energy_gl_parameter_check;
ALTER TABLE inp_energy_gl DROP CONSTRAINT IF EXISTS inp_energy_gl_energ_type_check;
ALTER TABLE inp_mixing DROP CONSTRAINT IF EXISTS inp_mixing_mix_type_check;
ALTER TABLE inp_source DROP CONSTRAINT IF EXISTS inp_source_sourc_type_check;
ALTER TABLE inp_shortpipe DROP CONSTRAINT IF EXISTS inp_shortpipe_status_check;
ALTER TABLE inp_pump DROP CONSTRAINT IF EXISTS inp_pumpe_status_check;
ALTER TABLE inp_pipe DROP CONSTRAINT IF EXISTS inp_pipe_status_check;
ALTER TABLE inp_valve DROP CONSTRAINT IF EXISTS inp_valve_status_check;
ALTER TABLE inp_valve DROP CONSTRAINT IF EXISTS inp_valve_valv_type_check;
ALTER TABLE inp_curve_id DROP CONSTRAINT IF EXISTS inp_curve_id_curve_type_check;

ALTER TABLE inp_options DROP CONSTRAINT IF EXISTS inp_options_units_check;
ALTER TABLE inp_options DROP CONSTRAINT IF EXISTS inp_options_hydraulics_check;
ALTER TABLE inp_options DROP CONSTRAINT IF EXISTS inp_options_headloss_check;
ALTER TABLE inp_options DROP CONSTRAINT IF EXISTS inp_options_quality_check;
ALTER TABLE inp_options DROP CONSTRAINT IF EXISTS inp_options_unbalanced_check;
ALTER TABLE inp_options DROP CONSTRAINT IF EXISTS inp_options_rtc_coefficient_check;
ALTER TABLE inp_options DROP CONSTRAINT IF EXISTS inp_options_valve_mode_check;

ALTER TABLE inp_reactions_el DROP CONSTRAINT IF EXISTS inp_reactions_el_parameter_check;
ALTER TABLE inp_reactions_gl DROP CONSTRAINT IF EXISTS inp_reactions_gl_parameter_check;
ALTER TABLE inp_reactions_gl DROP CONSTRAINT IF EXISTS inp_reactions_gl_react_type_check;

ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_pressure_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_demand_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_status_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_summary_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_energy_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_elevation_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_head_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_quality_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_length_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_diameter_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_flow_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_velocity_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_headloss_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_setting_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_reaction_check;
ALTER TABLE inp_report DROP CONSTRAINT IF EXISTS inp_report_f_factor_check;

ALTER TABLE inp_times DROP CONSTRAINT IF EXISTS inp_times_f_statistic_check;
ALTER TABLE inp_pump_additional DROP CONSTRAINT IF EXISTS inp_pump_additional_pattern_check;


ALTER TABLE inp_pump_importinp DROP CONSTRAINT IF EXISTS inp_pump_importinp_curve_id_fkey;
ALTER TABLE inp_valve_importinp DROP CONSTRAINT IF EXISTS inp_valve_importinp_to_arc_fkey;
ALTER TABLE inp_valve_importinp DROP CONSTRAINT IF EXISTS inp_valve_importinp_curve_id_fkey;


--DROP UNIQUE
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_unique";

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

ALTER TABLE "inp_source" ADD CONSTRAINT "inp_source_sourc_type_fkey" FOREIGN KEY ("sourc_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_times" ADD CONSTRAINT "inp_times_statistic_fkey" FOREIGN KEY ("statistic") REFERENCES "inp_typevalue" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "inp_valve" ADD CONSTRAINT "inp_valve_valv_type_fkey" FOREIGN KEY ("valv_type") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inp_valve" ADD CONSTRAINT "inp_valve_status_fkey" FOREIGN KEY ("status") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "inp_pump_additional" ADD CONSTRAINT "inp_pump_additional_status_fkey" FOREIGN KEY ("pattern") REFERENCES "inp_typevalue" ("id") ON DELETE CASCADE ON UPDATE CASCADE;



--check typevalue
ALTER TABLE inp_energy_el ADD CONSTRAINT inp_energy_el_parameter_check CHECK ( parameter IN ('EFFIC','PATTERN','PRICE'));
ALTER TABLE inp_energy_gl ADD CONSTRAINT inp_energy_gl_parameter_check CHECK ( parameter IN ('EFFIC','PATTERN','PRICE'));
ALTER TABLE inp_energy_gl ADD CONSTRAINT inp_energy_gl_energ_type_check CHECK ( energ_type IN ('DEMAND CHARGE','GLOBAL'));
ALTER TABLE inp_mixing ADD CONSTRAINT inp_mixing_mix_type_check CHECK ( mix_type IN ('2COMP','FIFO','LIFO','MIXED'));
ALTER TABLE inp_source ADD CONSTRAINT inp_source_sourc_type_check CHECK ( sourc_type IN ('CONCEN','FLOWPACED','MASS','SETPOINT'));
ALTER TABLE inp_shortpipe ADD CONSTRAINT inp_shortpipe_status_check CHECK ( status IN ('CLOSED_PIPE','CV_PIPE','OPEN_PIPE'));
ALTER TABLE inp_pump ADD CONSTRAINT inp_pumpe_status_check CHECK ( status IN ('CLOSED_PUMP','OPEN_PUMP'));
ALTER TABLE inp_pipe ADD CONSTRAINT inp_pipe_status_check CHECK ( status IN ('CLOSED_PIPE','CV_PIPE','OPEN_PIPE'));
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_status_check CHECK ( status IN ('ACTIVE_VALVE','CLOSED_VALVE','OPEN_VALVE'));
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_valv_type_check CHECK ( valv_type IN ('FCV','GPV','PBV','PRV','PSV','TCV'));
ALTER TABLE inp_curve_id ADD CONSTRAINT inp_curve_id_curve_type_check CHECK ( curve_type IN ('EFFICIENCY','HEADLOSS','PUMP','VOLUME'));

ALTER TABLE inp_options ADD CONSTRAINT inp_options_units_check CHECK ( units IN ('AFD','CMD','CMH','GPM','IMGD','LPM','LPS','MGD','MLD'));
ALTER TABLE inp_options ADD CONSTRAINT inp_options_hydraulics_check CHECK ( hydraulics IN (' ','SAVE','USE'));
ALTER TABLE inp_options ADD CONSTRAINT inp_options_headloss_check CHECK ( headloss IN ('C-M','D-W','H-W'));
ALTER TABLE inp_options ADD CONSTRAINT inp_options_quality_check CHECK ( quality IN ('AGE','CHEMICAL mg/L','CHEMICAL ug/L','NONE_QUAL','TRACE'));
ALTER TABLE inp_options ADD CONSTRAINT inp_options_unbalanced_check CHECK ( unbalanced IN ('CONTINUE','STOP'));
ALTER TABLE inp_options ADD CONSTRAINT inp_options_rtc_coefficient_check CHECK ( rtc_coefficient IN ('AVG','MAX','MIN','REAL'));
ALTER TABLE inp_options ADD CONSTRAINT inp_options_valve_mode_check CHECK ( valve_mode IN ('EPA TABLES','INVENTORY VALUES','MINCUT RESULTS'));

ALTER TABLE inp_reactions_el ADD CONSTRAINT inp_reactions_el_parameter_check CHECK ( parameter IN ('BULK_EL','TANK_EL','WALL_EL'));
ALTER TABLE inp_reactions_gl ADD CONSTRAINT inp_reactions_gl_parameter_check CHECK ( parameter IN ('BULK_GL','TANK_GL','WALL_GL'));
ALTER TABLE inp_reactions_gl ADD CONSTRAINT inp_reactions_gl_react_type_check CHECK ( react_type IN  ('GLOBAL_GL','LIMITING POTENTIAL','ORDER','ROUGHNESS CORRELATION'));

ALTER TABLE inp_report ADD CONSTRAINT inp_report_pressure_check CHECK ( pressure IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_demand_check CHECK ( demand IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_status_check CHECK ( status IN ('FULL_YNF','NO_YNF','YES_YNF'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_summary_check CHECK ( summary IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_energy_check CHECK ( energy IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_elevation_check CHECK ( elevation IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_head_check CHECK ( head IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_quality_check CHECK ( quality IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_length_check CHECK ( length IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_diameter_check CHECK ( diameter IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_flow_check CHECK ( flow IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_velocity_check CHECK ( velocity IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_headloss_check CHECK ( headloss IN ('C-M','D-W','H-W'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_setting_check CHECK ( setting IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_reaction_check CHECK ( reaction IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_f_factor_check CHECK ( f_factor IN ('NO','YES'));

ALTER TABLE inp_times ADD CONSTRAINT inp_times_f_statistic_check CHECK ( statistic IN ('AVERAGED','MAXIMUM','MINIMUM','NONE_TIMES','RANGE'));
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_pattern_check CHECK ( pattern IN ('CLOSED_PUMP','OPEN_PUMP'));


-- ADD UNIQUE
ALTER TABLE "inp_pump_additional" ADD CONSTRAINT "inp_pump_additional_unique" UNIQUE (node_id, order_id);


ALTER TABLE inp_pump_importinp ADD CONSTRAINT inp_pump_importinp_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_valve_importinp ADD CONSTRAINT inp_valve_importinp_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_valve_importinp ADD CONSTRAINT inp_valve_importinp_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
