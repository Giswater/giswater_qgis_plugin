/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE SCHEMA_NAME.inp_options ADD CONSTRAINT inp_options_check CHECK (id IN (1));
ALTER TABLE SCHEMA_NAME.inp_value_curve ADD CONSTRAINT inp_value_curve_check CHECK (id IN ('EFFICIENCY','HEADLOSS','PUMP','VOLUME'));
ALTER TABLE SCHEMA_NAME.inp_value_yesno ADD CONSTRAINT inp_value_yesno_check CHECK (id IN ('NO','YES'));
ALTER TABLE SCHEMA_NAME.inp_project_id ADD CONSTRAINT inp_project_id_check CHECK (title IN (title));
ALTER TABLE SCHEMA_NAME.inp_value_times ADD CONSTRAINT inp_value_times_check CHECK (id IN ('AVERAGED','MAXIMUM','MINIMUM','NONE','RANGE'));
ALTER TABLE SCHEMA_NAME.inp_value_status_valve ADD CONSTRAINT inp_value_status_valve_check CHECK (id IN ('ACTIVE','CLOSED','OPEN'));
ALTER TABLE SCHEMA_NAME.inp_value_status_pump ADD CONSTRAINT inp_value_status_pump_check CHECK (id IN ('CLOSED','OPEN'));
ALTER TABLE SCHEMA_NAME.inp_value_status_pipe ADD CONSTRAINT inp_value_status_pipe_check CHECK (id IN ('CLOSED','CV','OPEN'));
ALTER TABLE SCHEMA_NAME.inp_value_reactions_gl ADD CONSTRAINT inp_value_reactions_gl_check CHECK (id IN ('BULK','TANK','WALL'));
ALTER TABLE SCHEMA_NAME.inp_typevalue_energy ADD CONSTRAINT inp_typevalue_energy_check CHECK (id IN ('DEMAND CHARGE','GLOBAL'));
ALTER TABLE SCHEMA_NAME.inp_typevalue_pump ADD CONSTRAINT inp_typevalue_pump_check CHECK (id IN ('HEAD','PATTERN','POWER','SPEED'));
ALTER TABLE SCHEMA_NAME.inp_value_yesnofull ADD CONSTRAINT inp_value_yesnofull_check CHECK (id IN ('FULL','NO','YES'));
ALTER TABLE SCHEMA_NAME.inp_typevalue_source ADD CONSTRAINT inp_typevalue_source_check CHECK (id IN ('CONCEN','FLOWPACED','MASS','SETPOINT'));
ALTER TABLE SCHEMA_NAME.inp_typevalue_valve ADD CONSTRAINT inp_typevalue_valve_check CHECK (id IN ('FCV','GTV','PBV','PRV','PSV','TCV','VPG'));
ALTER TABLE SCHEMA_NAME.inp_value_ampm ADD CONSTRAINT inp_value_ampm_check CHECK (id IN ('AM','PM'));
ALTER TABLE SCHEMA_NAME.inp_value_noneall ADD CONSTRAINT inp_value_noneall_check CHECK (id IN ('ALL','NONE'));
ALTER TABLE SCHEMA_NAME.inp_value_mixing ADD CONSTRAINT inp_value_mixing_check CHECK (id IN ('2COMP','FIFO','LIFO','MIXED'));
ALTER TABLE SCHEMA_NAME.inp_value_param_energy ADD CONSTRAINT inp_value_param_energy_check CHECK (id IN ('EFFIC','PATTERN','PRICE'));
ALTER TABLE SCHEMA_NAME.inp_typevalue_reactions_gl ADD CONSTRAINT inp_typevalue_reactions_gl_check CHECK (id IN ('GLOBAL','LIMITING POTENTIAL','ORDER','ROUGHNESS CORRELATION'));
ALTER TABLE SCHEMA_NAME.inp_value_reactions_el ADD CONSTRAINT inp_value_reactions_el_check CHECK (id IN ('BULK','TANK','WALL'));
ALTER TABLE SCHEMA_NAME.inp_value_opti_hyd ADD CONSTRAINT inp_value_opti_hyd_check CHECK (id IN ('NO DATA','SAVE','USE'));
ALTER TABLE SCHEMA_NAME.inp_value_opti_unbal ADD CONSTRAINT inp_value_opti_unbal_check CHECK (id IN ('CONTINUE','STOP'));
ALTER TABLE SCHEMA_NAME.inp_value_opti_units ADD CONSTRAINT inp_value_opti_units_check CHECK (id IN ('AFD','CMD','CMH','GPM','IMGD','LPM','LPS','MGD','MLD'));
ALTER TABLE SCHEMA_NAME.inp_value_opti_headloss ADD CONSTRAINT inp_value_opti_headloss_check CHECK (id IN ('C-M','D-W','H-W'));
ALTER TABLE SCHEMA_NAME.inp_value_opti_qual ADD CONSTRAINT inp_value_opti_qual_check CHECK (id IN ('AGE','CHEMICAL mg/L','CHEMICAL ug/L','NONE','TRACE'));
ALTER TABLE SCHEMA_NAME.inp_value_opti_valvemode ADD CONSTRAINT inp_value_opti_valvemode_check CHECK (id IN ('EPA TABLES','INVENTORY VALUES','MINCUT RESULTS'));
ALTER TABLE SCHEMA_NAME.inp_value_opti_rtc_coef ADD CONSTRAINT inp_value_opti_rtc_coef_check CHECK (id IN ('AVG','MAX','MIN','REAL'));
ALTER TABLE SCHEMA_NAME.inp_arc_type ADD CONSTRAINT inp_arc_type_check CHECK (id IN ('NOT DEFINED', 'PIPE'));
ALTER TABLE SCHEMA_NAME.inp_node_type ADD CONSTRAINT inp_node_type_check CHECK (id IN ('JUNCTION','NOT DEFINED','PUMP','RESERVOIR','SHORTPIPE','TANK','VALVE'));





