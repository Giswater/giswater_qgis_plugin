--DROP
ALTER TABLE inp_selector_dscenario ALTER COLUMN dscenario_id DROP NOT NULL;
ALTER TABLE inp_selector_dscenario ALTER COLUMN cur_user DROP NOT NULL;

ALTER TABLE inp_cat_mat_roughness ALTER COLUMN matcat_id DROP NOT NULL;

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

ALTER TABLE inp_pump ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_pump ALTER COLUMN to_arc DROP NOT NULL;

ALTER TABLE inp_reactions_el ALTER COLUMN "parameter" DROP NOT NULL;
ALTER TABLE inp_reactions_el ALTER COLUMN "arc_id" DROP NOT NULL;
ALTER TABLE inp_reactions_el ALTER COLUMN "value" DROP NOT NULL;

ALTER TABLE inp_reactions_gl ALTER COLUMN react_type DROP NOT NULL;
ALTER TABLE inp_reactions_gl ALTER COLUMN "parameter" DROP NOT NULL;
ALTER TABLE inp_reactions_gl ALTER COLUMN "value" DROP NOT NULL;

ALTER TABLE inp_raport ALTER COLUMN pagesize DROP NOT NULL;

ALTER TABLE inp_rules_x_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_rules_x_node ALTER COLUMN text DROP NOT NULL;

ALTER TABLE inp_rules_x_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE inp_rules_x_arc ALTER COLUMN text DROP NOT NULL;

ALTER TABLE inp_tags ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE inp_valve ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE inp_valve ALTER COLUMN to_arc DROP NOT NULL;
ALTER TABLE inp_valve ALTER COLUMN valv_type DROP NOT NULL;

ALTER TABLE inp_pump_additional ALTER COLUMN node_id DROP NOT NULL;

--RPT
ALTER TABLE rpt_inp_node ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_inp_arc ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_arc ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_energy_usage ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_hydraulic_status ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_node ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_cat_result ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE rpt_selector_hourly ALTER COLUMN "time" DROP NOT NULL;

--SET
--INP
ALTER TABLE inp_selector_dscenario ALTER COLUMN dscenario_id SET NOT NULL;
ALTER TABLE inp_selector_dscenario ALTER COLUMN cur_user SET NOT NULL;

ALTER TABLE inp_cat_mat_roughness ALTER COLUMN matcat_id SET NOT NULL;

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

ALTER TABLE inp_pump ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_pump ALTER COLUMN to_arc SET NOT NULL;

ALTER TABLE inp_reactions_el ALTER COLUMN "parameter" SET NOT NULL;
ALTER TABLE inp_reactions_el ALTER COLUMN "arc_id" SET NOT NULL;
ALTER TABLE inp_reactions_el ALTER COLUMN "value" SET NOT NULL;

ALTER TABLE inp_reactions_gl ALTER COLUMN react_type SET NOT NULL;
ALTER TABLE inp_reactions_gl ALTER COLUMN "parameter" SET NOT NULL;
ALTER TABLE inp_reactions_gl ALTER COLUMN "value" SET NOT NULL;

ALTER TABLE inp_raport ALTER COLUMN pagesize SET NOT NULL;

ALTER TABLE inp_rules_x_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_rules_x_node ALTER COLUMN text SET NOT NULL;

ALTER TABLE inp_rules_x_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE inp_rules_x_arc ALTER COLUMN text SET NOT NULL;

ALTER TABLE inp_tags ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE inp_valve ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE inp_valve ALTER COLUMN to_arc SET NOT NULL;
ALTER TABLE inp_valve ALTER COLUMN valv_type SET NOT NULL;

ALTER TABLE inp_pump_additional ALTER COLUMN node_id SET NOT NULL;

--RPT
ALTER TABLE rpt_inp_node ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_inp_arc ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_arc ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_energy_usage ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_hydraulic_status ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_node ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_cat_result ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE rpt_selector_hourly ALTER COLUMN "time" SET NOT NULL;
ALTER TABLE rpt_selector_hourly ALTER COLUMN cur_user SET NOT NULL;

