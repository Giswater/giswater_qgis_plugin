/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE inp_report DROP CONSTRAINT inp_report_demand_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_diameter_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_elevation_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_energy_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_f_factor_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_flow_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_head_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_headloss_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_length_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_pressure_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_quality_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_reaction_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_setting_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_status_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_summary_fkey;
ALTER TABLE inp_report DROP CONSTRAINT inp_report_velocity_fkey;