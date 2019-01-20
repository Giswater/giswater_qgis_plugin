/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP CHECK

ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_check";
ALTER TABLE "inp_value_curve" DROP CONSTRAINT IF EXISTS "inp_value_curve_check";
ALTER TABLE "inp_value_yesno" DROP CONSTRAINT IF EXISTS "inp_value_yesno_check";
ALTER TABLE "inp_project_id" DROP CONSTRAINT IF EXISTS "inp_project_id_check";
ALTER TABLE "inp_value_times" DROP CONSTRAINT IF EXISTS "inp_value_times_check";
ALTER TABLE "inp_value_status_valve" DROP CONSTRAINT IF EXISTS "inp_value_status_valve_check";
ALTER TABLE "inp_value_status_pump" DROP CONSTRAINT IF EXISTS "inp_value_status_pump_check";
ALTER TABLE "inp_value_status_pipe" DROP CONSTRAINT IF EXISTS "inp_value_status_pipe_check";
ALTER TABLE "inp_value_reactions_gl" DROP CONSTRAINT IF EXISTS "inp_value_reactions_gl_check";
ALTER TABLE "inp_typevalue_energy" DROP CONSTRAINT IF EXISTS "inp_typevalue_energy_check";
ALTER TABLE "inp_typevalue_pump" DROP CONSTRAINT IF EXISTS "inp_typevalue_pump_check";
ALTER TABLE "inp_value_yesnofull" DROP CONSTRAINT IF EXISTS "inp_value_yesnofull_check";
ALTER TABLE "inp_typevalue_source" DROP CONSTRAINT IF EXISTS "inp_typevalue_source_check";
ALTER TABLE "inp_typevalue_valve" DROP CONSTRAINT IF EXISTS "inp_typevalue_valve_check";
ALTER TABLE "inp_value_ampm" DROP CONSTRAINT IF EXISTS "inp_value_ampm_check";
ALTER TABLE "inp_value_noneall" DROP CONSTRAINT IF EXISTS "inp_value_noneall_check";
ALTER TABLE "inp_value_mixing" DROP CONSTRAINT IF EXISTS "inp_value_mixing_check";
ALTER TABLE "inp_value_param_energy" DROP CONSTRAINT IF EXISTS "inp_value_param_energy_check";
ALTER TABLE "inp_typevalue_reactions_gl" DROP CONSTRAINT IF EXISTS "inp_typevalue_reactions_gl_check";
ALTER TABLE "inp_value_reactions_el" DROP CONSTRAINT IF EXISTS "inp_value_reactions_el_check";
ALTER TABLE "inp_value_opti_hyd" DROP CONSTRAINT IF EXISTS "inp_value_opti_hyd_check";
ALTER TABLE "inp_value_opti_unbal" DROP CONSTRAINT IF EXISTS "inp_value_opti_unbal_check";
ALTER TABLE "inp_value_opti_units" DROP CONSTRAINT IF EXISTS "inp_value_opti_units_check";
ALTER TABLE "inp_value_opti_headloss" DROP CONSTRAINT IF EXISTS "inp_value_opti_headloss_check";
ALTER TABLE "inp_value_reactions_el" DROP CONSTRAINT IF EXISTS "inp_value_reactions_el_check";
ALTER TABLE "inp_value_opti_qual" DROP CONSTRAINT IF EXISTS "inp_value_opti_qual_check";
ALTER TABLE "inp_value_opti_valvemode" DROP CONSTRAINT IF EXISTS "inp_value_opti_valvemode_check";
ALTER TABLE "inp_value_opti_rtc_coef" DROP CONSTRAINT IF EXISTS "inp_value_opti_rtc_coef_check";
ALTER TABLE "inp_arc_type" DROP CONSTRAINT IF EXISTS "inp_arc_type_check";
ALTER TABLE "inp_node_type" DROP CONSTRAINT IF EXISTS "inp_node_type_check";
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_check";


--DROP UNIQUE
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_unique";
ALTER TABLE "inp_cat_mat_roughness" DROP CONSTRAINT IF EXISTS "inp_cat_mat_roughness_unique";



-- ADD CHECK
ALTER TABLE inp_options ADD CONSTRAINT inp_options_check CHECK (id IN (1));
ALTER TABLE inp_value_curve ADD CONSTRAINT inp_value_curve_check CHECK (id IN ('EFFICIENCY','HEADLOSS','PUMP','VOLUME'));
ALTER TABLE inp_value_yesno ADD CONSTRAINT inp_value_yesno_check CHECK (id IN ('NO','YES'));
ALTER TABLE inp_project_id ADD CONSTRAINT inp_project_id_check CHECK (title IN (title));
ALTER TABLE inp_value_times ADD CONSTRAINT inp_value_times_check CHECK (id IN ('AVERAGED','MAXIMUM','MINIMUM','NONE','RANGE'));
ALTER TABLE inp_value_status_valve ADD CONSTRAINT inp_value_status_valve_check CHECK (id IN ('ACTIVE','CLOSED','OPEN'));
ALTER TABLE inp_value_status_pump ADD CONSTRAINT inp_value_status_pump_check CHECK (id IN ('CLOSED','OPEN'));
ALTER TABLE inp_value_status_pipe ADD CONSTRAINT inp_value_status_pipe_check CHECK (id IN ('CLOSED','CV','OPEN'));
ALTER TABLE inp_value_reactions_gl ADD CONSTRAINT inp_value_reactions_gl_check CHECK (id IN ('BULK','TANK','WALL'));
ALTER TABLE inp_typevalue_energy ADD CONSTRAINT inp_typevalue_energy_check CHECK (id IN ('DEMAND CHARGE','GLOBAL'));
ALTER TABLE inp_typevalue_pump ADD CONSTRAINT inp_typevalue_pump_check CHECK (id IN ('HEAD','PATTERN','POWER','SPEED'));
ALTER TABLE inp_value_yesnofull ADD CONSTRAINT inp_value_yesnofull_check CHECK (id IN ('FULL','NO','YES'));
ALTER TABLE inp_typevalue_source ADD CONSTRAINT inp_typevalue_source_check CHECK (id IN ('CONCEN','FLOWPACED','MASS','SETPOINT'));
ALTER TABLE inp_typevalue_valve ADD CONSTRAINT inp_typevalue_valve_check CHECK (id IN ('FCV','GPV','PBV','PRV','PSV','TCV'));
ALTER TABLE inp_value_ampm ADD CONSTRAINT inp_value_ampm_check CHECK (id IN ('AM','PM'));
ALTER TABLE inp_value_noneall ADD CONSTRAINT inp_value_noneall_check CHECK (id IN ('ALL','NONE'));
ALTER TABLE inp_value_mixing ADD CONSTRAINT inp_value_mixing_check CHECK (id IN ('2COMP','FIFO','LIFO','MIXED'));
ALTER TABLE inp_value_param_energy ADD CONSTRAINT inp_value_param_energy_check CHECK (id IN ('EFFIC','PATTERN','PRICE'));
ALTER TABLE inp_typevalue_reactions_gl ADD CONSTRAINT inp_typevalue_reactions_gl_check CHECK (id IN ('GLOBAL','LIMITING POTENTIAL','ORDER','ROUGHNESS CORRELATION'));
ALTER TABLE inp_value_reactions_el ADD CONSTRAINT inp_value_reactions_el_check CHECK (id IN ('BULK','TANK','WALL'));
ALTER TABLE inp_value_opti_hyd ADD CONSTRAINT inp_value_opti_hyd_check CHECK (id IN (' ','SAVE','USE'));
ALTER TABLE inp_value_opti_unbal ADD CONSTRAINT inp_value_opti_unbal_check CHECK (id IN ('CONTINUE','STOP'));
ALTER TABLE inp_value_opti_units ADD CONSTRAINT inp_value_opti_units_check CHECK (id IN ('AFD','CMD','CMH','GPM','IMGD','LPM','LPS','MGD','MLD'));
ALTER TABLE inp_value_opti_headloss ADD CONSTRAINT inp_value_opti_headloss_check CHECK (id IN ('C-M','D-W','H-W'));
ALTER TABLE inp_value_opti_qual ADD CONSTRAINT inp_value_opti_qual_check CHECK (id IN ('AGE','CHEMICAL mg/L','CHEMICAL ug/L','NONE','TRACE'));
ALTER TABLE inp_value_opti_valvemode ADD CONSTRAINT inp_value_opti_valvemode_check CHECK (id IN ('EPA TABLES','INVENTORY VALUES','MINCUT RESULTS'));
ALTER TABLE inp_value_opti_rtc_coef ADD CONSTRAINT inp_value_opti_rtc_coef_check CHECK (id IN ('AVG','MAX','MIN','REAL'));
ALTER TABLE inp_arc_type ADD CONSTRAINT inp_arc_type_check CHECK (id IN ('NOT DEFINED', 'PIPE'));
ALTER TABLE inp_node_type ADD CONSTRAINT inp_node_type_check CHECK (id IN ('JUNCTION','NOT DEFINED','PUMP','RESERVOIR','SHORTPIPE','TANK','VALVE'));
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_check CHECK (order_id IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20));


-- ADD UNIQUE
ALTER TABLE "inp_pump_additional" ADD CONSTRAINT "inp_pump_additional_unique" UNIQUE (node_id, order_id);
ALTER TABLE "inp_cat_mat_roughness" ADD CONSTRAINT "inp_cat_mat_roughness_unique" UNIQUE (matcat_id, init_age, end_age);