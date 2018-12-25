/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

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



--DROP UNIQUE
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_unique";




-- ADD CHECK
ALTER TABLE inp_options ADD CONSTRAINT inp_options_check CHECK (id IN (1));

ALTER TABLE inp_project_id ADD CONSTRAINT inp_project_id_check CHECK (title IN (title));

ALTER TABLE inp_arc_type ADD CONSTRAINT inp_arc_type_check CHECK (id IN ('NOT DEFINED', 'PIPE'));
ALTER TABLE inp_node_type ADD CONSTRAINT inp_node_type_check CHECK (id IN ('JUNCTION','NOT DEFINED','PUMP','RESERVOIR','SHORTPIPE','TANK','VALVE'));
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_check CHECK (order_id IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20));



ALTER TABLE inp_typevalue ADD CONSTRAINT inp_typevalue_check CHECK 
((typevalue='inp_value_curve' AND id IN ('EFFICIENCY','HEADLOSS','PUMP','VOLUME')) OR
(typevalue='inp_value_yesno'  and id IN ('NO','YES')) OR
(typevalue='inp_typevalue_energy' AND id IN ('DEMAND CHARGE','GLOBAL')) OR
(typevalue='inp_typevalue_pump' AND id IN ('HEAD_PUMP','PATTERN_PUMP','POWER_PUMP','SPEED_PUMP')) OR
(typevalue='inp_typevalue_reactions_gl' AND id IN ('GLOBAL_GL','LIMITING POTENTIAL','ORDER','ROUGHNESS CORRELATION')) OR
(typevalue='inp_typevalue_source' AND id IN ('CONCEN','FLOWPACED','MASS','SETPOINT')) OR
(typevalue='inp_value_ampm' AND id IN ('AM','PM')) OR
(typevalue='inp_value_mixing' AND id IN  ('2COMP','FIFO','LIFO','MIXED')) OR
(typevalue='inp_value_noneall' AND id IN ('ALL','NONE')) OR
(typevalue='inp_value_opti_headloss' AND id IN ('C-M','D-W','H-W')) OR
(typevalue='inp_value_opti_hyd' AND id IN (' ','SAVE','USE')) OR
(typevalue='inp_value_opti_qual' AND id IN ('AGE','CHEMICAL mg/L','CHEMICAL ug/L','NONE_QUAL','TRACE')) OR
(typevalue='inp_value_opti_rtc_coef' AND id IN ('AVG','MAX','MIN','REAL')) OR
(typevalue='inp_value_opti_unbal' AND id IN ('CONTINUE','STOP')) OR
(typevalue='inp_value_opti_units' AND id IN ('AFD','CMD','CMH','GPM','IMGD','LPM','LPS','MGD','MLD')) OR
(typevalue='inp_value_opti_valvemode' AND id IN ('EPA TABLES','INVENTORY VALUES','MINCUT RESULTS')) OR
(typevalue='inp_value_param_energy' AND id IN ('EFFIC','PATTERN','PRICE')) OR
(typevalue='inp_value_reactions_el' AND id IN ('BULK_EL','TANK_EL','WALL_EL')) OR
(typevalue='inp_value_reactions_gl' AND id IN ('BULK_GL','TANK_GL','WALL_GL')) OR
(typevalue='inp_value_status_pipe' AND id IN ('CLOSED_PIPE','CV_PIPE','OPEN_PIPE')) OR
(typevalue='inp_value_status_pump' AND id IN ('CLOSED_PUMP','OPEN_PUMP')) OR
(typevalue='inp_value_status_valve' AND id IN ('ACTIVE_VALVE','CLOSED_VALVE','OPEN_VALVE')) OR
(typevalue='inp_value_times' AND id IN ('AVERAGED','MAXIMUM','MINIMUM','NONE_TIMES','RANGE')) OR
(typevalue='inp_value_yesnofull' AND id IN ('FULL_YNF','NO_YNF','YES_YNF')) OR
(typevalue='inp_typevalue_valve' AND id IN ('FCV','GPV','PBV','PRV','PSV','TCV')));

--check typevalue
ALTER TABLE inp_energy_el ADD CONSTRAINT inp_energy_el_parameter_check CHECK ( parameter IN ('EFFIC','PATTERN','PRICE'));
ALTER TABLE inp_energy_gl ADD CONSTRAINT inp_energy_gl_parameter_check CHECK ( parameter IN ('EFFIC','PATTERN','PRICE'));
ALTER TABLE inp_energy_gl ADD CONSTRAINT inp_energy_gl_energ_type_check CHECK ( energ_type IN ('DEMAND CHARGE','GLOBAL'));
ALTER TABLE inp_mixing ADD CONSTRAINT inp_mixing_mix_type_check CHECK ( mix_type IN ('2COMP','FIFO','LIFO','MIXED'));
ALTER TABLE inp_source ADD CONSTRAINT inp_source_source_type_check CHECK ( sourc_type IN ('CONCEN','FLOWPACED','MASS','SETPOINT'));
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
ALTER TABLE inp_report ADD CONSTRAINT inp_report_headloss_check CHECK ( headloss IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_setting_check CHECK ( setting IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_reaction_check CHECK ( reaction IN ('NO','YES'));
ALTER TABLE inp_report ADD CONSTRAINT inp_report_f_factor_check CHECK ( f_factor IN ('NO','YES'));

ALTER TABLE inp_times ADD CONSTRAINT inp_times_f_statistic_check CHECK ( statistic IN ('AVERAGED','MAXIMUM','MINIMUM','NONE_TIMES','RANGE'));
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_pattern_check CHECK ( pattern IN ('CLOSED_PUMP','OPEN_PUMP'));


-- ADD UNIQUE
ALTER TABLE "inp_pump_additional" ADD CONSTRAINT "inp_pump_additional_unique" UNIQUE (node_id, order_id);
