/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP
ALTER TABLE inp_selector_dscenario ALTER COLUMN dscenario_id DROP NOT NULL;
ALTER TABLE inp_selector_dscenario ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE inp_cat_mat_roughness ALTER COLUMN matcat_id DROP NOT NULL;
ALTER TABLE inp_cat_mat_roughness ALTER COLUMN period_id DROP NOT NULL;
ALTER TABLE inp_cat_mat_roughness ALTER COLUMN init_age DROP NOT NULL;
ALTER TABLE inp_cat_mat_roughness ALTER COLUMN end_age DROP NOT NULL;

ALTER TABLE inp_controls_x_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_controls_x_node ALTER COLUMN text DROP NOT NULL;

ALTER TABLE inp_controls_x_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE inp_controls_x_arc ALTER COLUMN text DROP NOT NULL;

ALTER TABLE inp_curve ALTER COLUMN curve_id DROP NOT NULL;
ALTER TABLE inp_curve ALTER COLUMN x_value DROP NOT NULL;
ALTER TABLE inp_curve ALTER COLUMN y_value DROP NOT NULL;

ALTER TABLE inp_curve_id ALTER COLUMN curve_type DROP NOT NULL;

ALTER TABLE inp_demand ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE inp_pattern_value ALTER COLUMN pattern_id DROP NOT NULL;

ALTER TABLE inp_reactions_el ALTER COLUMN "parameter" DROP NOT NULL;
ALTER TABLE inp_reactions_el ALTER COLUMN "arc_id" DROP NOT NULL;
ALTER TABLE inp_reactions_el ALTER COLUMN "value" DROP NOT NULL;

ALTER TABLE inp_reactions_gl ALTER COLUMN react_type DROP NOT NULL;
ALTER TABLE inp_reactions_gl ALTER COLUMN "parameter" DROP NOT NULL;
ALTER TABLE inp_reactions_gl ALTER COLUMN "value" DROP NOT NULL;

ALTER TABLE inp_rules_x_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_rules_x_node ALTER COLUMN text DROP NOT NULL;

ALTER TABLE inp_rules_x_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE inp_rules_x_arc ALTER COLUMN text DROP NOT NULL;

ALTER TABLE inp_pump_additional ALTER COLUMN node_id DROP NOT NULL;

--RPT
ALTER TABLE rpt_inp_node ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_inp_arc ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_arc ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_energy_usage ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_hydraulic_status ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_node ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_selector_hourly ALTER COLUMN "time" DROP NOT NULL;

--SET
--INP
ALTER TABLE inp_selector_dscenario ALTER COLUMN dscenario_id SET NOT NULL;
ALTER TABLE inp_selector_dscenario ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE inp_cat_mat_roughness ALTER COLUMN matcat_id SET NOT NULL;
ALTER TABLE inp_cat_mat_roughness ALTER COLUMN period_id SET NOT NULL;
ALTER TABLE inp_cat_mat_roughness ALTER COLUMN init_age SET NOT NULL;
ALTER TABLE inp_cat_mat_roughness ALTER COLUMN end_age SET NOT NULL;

ALTER TABLE inp_controls_x_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_controls_x_node ALTER COLUMN text SET NOT NULL;

ALTER TABLE inp_controls_x_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE inp_controls_x_arc ALTER COLUMN text SET NOT NULL;

ALTER TABLE inp_curve ALTER COLUMN curve_id SET NOT NULL;
ALTER TABLE inp_curve ALTER COLUMN x_value SET NOT NULL;
ALTER TABLE inp_curve ALTER COLUMN y_value SET NOT NULL;

ALTER TABLE inp_curve_id ALTER COLUMN curve_type SET NOT NULL;

ALTER TABLE inp_demand ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE inp_pattern_value ALTER COLUMN pattern_id SET NOT NULL;

ALTER TABLE inp_reactions_el ALTER COLUMN "parameter" SET NOT NULL;
ALTER TABLE inp_reactions_el ALTER COLUMN "arc_id" SET NOT NULL;
ALTER TABLE inp_reactions_el ALTER COLUMN "value" SET NOT NULL;

ALTER TABLE inp_reactions_gl ALTER COLUMN react_type SET NOT NULL;
ALTER TABLE inp_reactions_gl ALTER COLUMN "parameter" SET NOT NULL;
ALTER TABLE inp_reactions_gl ALTER COLUMN "value" SET NOT NULL;

ALTER TABLE inp_rules_x_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_rules_x_node ALTER COLUMN text SET NOT NULL;

ALTER TABLE inp_rules_x_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE inp_rules_x_arc ALTER COLUMN text SET NOT NULL;

ALTER TABLE inp_pump_additional ALTER COLUMN node_id SET NOT NULL;

--RPT
ALTER TABLE rpt_inp_node ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_inp_arc ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_arc ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_energy_usage ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_hydraulic_status ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_node ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_selector_hourly ALTER COLUMN "time" SET NOT NULL;
ALTER TABLE rpt_selector_hourly ALTER COLUMN cur_user SET NOT NULL;

