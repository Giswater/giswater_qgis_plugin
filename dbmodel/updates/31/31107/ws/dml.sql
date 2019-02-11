/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



--2019/02/11
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('epa_units_factor', 
'{"LPS":1, "LPM":60, "MLD":0.216, "CMH":3.6, "CMD":3.6, "CMD":86.4, "CFS":0, "GPM":0, "MGD":0, "IMGD":0, "AFD":0}', 'json', 'Epa', 'Conversion factors of CRM flows in function of EPA units choosed by user');


-- 2019/01/26
DELETE FROM config_client_forms WHERE table_id='v_ui_anl_mincut_result_cat' AND column_id='macroexpl_id' AND column_index=8;
UPDATE  config_client_forms SET status=false WHERE table_id='v_ui_anl_mincut_result_cat' AND column_index=2;

-- 2019/02/01
ALTER TABLE anl_mincut_cat_state DROP CONSTRAINT anl_mincut_cat_state_check;
INSERT INTO anl_mincut_cat_state VALUES (3, 'Canceled');

INSERT INTO audit_cat_param_user VALUES ('manholecat_vdefault', NULL, 'Default value for manhole element parameter', 'role_edit', 'cat_node', 'id', 'SELECT cat_node.id FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''MANHOLE'' AND cat_node.id=', 'text');
INSERT INTO audit_cat_param_user VALUES ('waterwellcat_vdefault', NULL, 'Default value for waterwell element parameter', 'role_edit', 'cat_node', 'id', 'SELECT cat_node.id FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''WATERWELL'' AND cat_node.id=', 'text');


--temp remove constraints inp

ALTER TABLE inp_selector_dscenario DROP CONSTRAINT IF EXISTS dscenario_id_cur_user_unique;
ALTER TABLE "inp_selector_dscenario" DROP CONSTRAINT IF EXISTS "inp_selector_dscenario_dscenario_id_fkey";

ALTER TABLE "inp_cat_mat_roughness" DROP CONSTRAINT IF EXISTS "inp_cat_mat_roughness_matcat_id_fkey";

ALTER TABLE "inp_controls_x_node" DROP CONSTRAINT IF EXISTS "inp_controls_x_node_id_fkey";

ALTER TABLE "inp_controls_x_arc" DROP CONSTRAINT IF EXISTS "inp_controls_x_arc_id_fkey";

ALTER TABLE "inp_curve" DROP CONSTRAINT IF EXISTS "inp_curve_curve_id_fkey";

ALTER TABLE "inp_demand" DROP CONSTRAINT IF EXISTS "inp_demand_node_id_fkey";
ALTER TABLE "inp_demand" DROP CONSTRAINT IF EXISTS "inp_demand_dscenario_id_fkey";
ALTER TABLE "inp_demand" DROP CONSTRAINT IF EXISTS "inp_demand_pattern_id_fkey";

ALTER TABLE "inp_emitter" DROP CONSTRAINT IF EXISTS "inp_emitter_node_id_fkey";

ALTER TABLE "inp_energy_el" DROP CONSTRAINT IF EXISTS "inp_energy_el_pump_id_fkey" ;
ALTER TABLE "inp_energy_el" DROP CONSTRAINT IF EXISTS "inp_energy_el_parameter_fkey";

ALTER TABLE "inp_energy_gl" DROP CONSTRAINT IF EXISTS "inp_energy_gl_parameter_fkey";

ALTER TABLE "inp_junction" DROP CONSTRAINT IF EXISTS "inp_junction_node_id_fkey";
ALTER TABLE "inp_junction"  DROP CONSTRAINT IF EXISTS "inp_junction_pattern_id_fkey";

ALTER TABLE "inp_label" DROP CONSTRAINT IF EXISTS "inp_label_node_id_fkey";

ALTER TABLE "inp_mixing" DROP CONSTRAINT IF EXISTS "inp_mixing_node_id_fkey";
ALTER TABLE "inp_mixing" DROP CONSTRAINT IF EXISTS "inp_mixing_mix_type_fkey";

ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_units_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_hydraulics_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_headloss_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_quality_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_unbalanced_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_period_id_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_coefficient_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_valve_mode_mincut_result_fkey";
ALTER TABLE "inp_options" DROP CONSTRAINT IF EXISTS "inp_options_valve_mode_fkey";

ALTER TABLE "inp_pattern_value" DROP CONSTRAINT IF EXISTS "inp_pattern_value_pattern_id_fkey" ;

ALTER TABLE "inp_pipe" DROP CONSTRAINT IF EXISTS "inp_pipe_arc_id_fkey";

ALTER TABLE "inp_shortpipe" DROP CONSTRAINT IF EXISTS "inp_shortpipe_node_id_fkey";

ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_node_id_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_curve_id_fkey";
ALTER TABLE "inp_pump" DROP CONSTRAINT IF EXISTS "inp_pump_to_arc_fkey";

ALTER TABLE "inp_quality" DROP CONSTRAINT IF EXISTS "inp_quality_node_id_fkey";

ALTER TABLE "inp_reactions_el" DROP CONSTRAINT IF EXISTS "inp_reactions_el_arc_id_fkey";
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

ALTER TABLE "inp_reservoir" DROP CONSTRAINT IF EXISTS "inp_reservoir_node_id_fkey";
ALTER TABLE "inp_reservoir" DROP CONSTRAINT IF EXISTS "inp_reservoir_pattern_id_fkey";

ALTER TABLE "inp_rules_x_node" DROP CONSTRAINT IF EXISTS "inp_rules_x_node_id_fkey";

ALTER TABLE "inp_rules_x_arc" DROP CONSTRAINT IF EXISTS "inp_rules_x_arc_id_fkey";

ALTER TABLE "inp_source" DROP CONSTRAINT IF EXISTS "inp_source_node_id_fkey";
ALTER TABLE "inp_source" DROP CONSTRAINT IF EXISTS "inp_source_pattern_id_fkey";
ALTER TABLE "inp_source" DROP CONSTRAINT IF EXISTS "inp_source_sourc_type_fkey" ;


ALTER TABLE "inp_tags" DROP CONSTRAINT IF EXISTS "inp_tags_node_id_fkey";

ALTER TABLE "inp_tank" DROP CONSTRAINT IF EXISTS "inp_tank_node_id_fkey";
ALTER TABLE "inp_tank" DROP CONSTRAINT IF EXISTS "inp_tank_curve_id_fkey";

ALTER TABLE "inp_times" DROP CONSTRAINT IF EXISTS "inp_times_statistic_fkey";

ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_node_id_fkey";
ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_curve_id_fkey";
ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_to_arc_fkey";
ALTER TABLE "inp_valve" DROP CONSTRAINT IF EXISTS "inp_valve_valv_type_fkey";

ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_node_id_fkey";
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_curve_id_fkey";
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_pattern_id_fkey";
ALTER TABLE "inp_pump_additional" DROP CONSTRAINT IF EXISTS "inp_pump_additional_status_fkey";

-----------------------
-- Records of inp_options
-----------------------
UPDATE inp_options SET quality='NONE_QUAL' WHERE quality='NONE';


--UPDATE inp_report SET status='YES_YNF' WHERE status='YES';

UPDATE inp_times SET statistic='NONE_TIMES' WHERE statistic='NONE';

--UPDATE inp_report SET status='YES_YNF' WHERE status='YES'; -- text is too long to fit into field length


-----------------------
-- Records of inp_typevalue
-----------------------

INSERT INTO inp_typevalue VALUES ('inp_typevalue_pump', 'PATTERN_PUMP', 'PATTERN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_pump', 'HEAD_PUMP', 'HEAD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_pump', 'SPEED_PUMP', 'SPEED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_pump', 'POWER_PUMP', 'POWER', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_reactions_gl', 'GLOBAL_GL', 'GLOBAL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'AGE', 'AGE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_energy', 'DEMAND CHARGE', 'DEMAND CHARGE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_energy', 'GLOBAL', 'GLOBAL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_source', 'CONCEN', 'CONCEN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_source', 'FLOWPACED', 'FLOWPACED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_source', 'MASS', 'MASS', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_source', 'SETPOINT', 'SETPOINT', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_ampm', 'AM', 'AM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_ampm', 'PM', 'PM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_curve', 'EFFICIENCY', 'EFFICIENCY', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_curve', 'HEADLOSS', 'HEADLOSS', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_curve', 'PUMP', 'PUMP', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_curve', 'VOLUME', 'VOLUME', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_mixing', '2COMP', '2COMP', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_mixing', 'FIFO', 'FIFO', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_mixing', 'LIFO', 'LIFO', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_mixing', 'MIXED', 'MIXED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_noneall', 'ALL', 'ALL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_noneall', 'NONE', 'NONE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_headloss', 'C-M', 'C-M', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_headloss', 'D-W', 'D-W', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_headloss', 'H-W', 'H-W', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_hyd', ' ', ' ', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_hyd', 'SAVE', 'SAVE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_hyd', 'USE', 'USE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'CHEMICAL mg/L', 'CHEMICAL mg/L', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'CHEMICAL ug/L', 'CHEMICAL ug/L', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_rtc_coef', 'MIN', 'MIN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_rtc_coef', 'AVG', 'AVG', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_rtc_coef', 'MAX', 'MAX', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_unbal', 'CONTINUE', 'CONTINUE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_unbal', 'STOP', 'STOP', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'AFD', 'AFD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'CMD', 'CMD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'CMH', 'CMH', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'GPM', 'GPM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'IMGD', 'IMGD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'LPM', 'LPM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'LPS', 'LPS', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'MGD', 'MGD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'MLD', 'MLD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 'EPA TABLES', 'EPA TABLES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 'INVENTORY VALUES', 'INVENTORY VALUES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 'MINCUT RESULTS', 'MINCUT RESULTS', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_param_energy', 'EFFIC', 'EFFIC', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_param_energy', 'PATTERN', 'PATTERN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_param_energy', 'PRICE', 'PRICE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesno', 'NO', 'NO', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesno', 'YES', 'YES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'GPV', 'GPV', 'General Purpose Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'FCV', 'FCV', 'Flow Control Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'PBV', 'PBV', 'Pressure Break Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'PRV', 'PRV', 'Pressure Reduction Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'PSV', 'PSV', 'Pressure Sustain Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'TCV', 'TCV', 'Throttle Control Valve');
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_el', 'BULK_EL', 'BULK', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_el', 'TANK_EL', 'TANK', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_el', 'WALL_EL', 'WALL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_gl', 'BULK_GL', 'BULK', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_gl', 'TANK_GL', 'TANK', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_gl', 'WALL_GL', 'WALL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pipe', 'CLOSED_PIPE', 'CLOSED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pipe', 'CV_PIPE', 'CV', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pipe', 'OPEN_PIPE', 'OPEN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pump', 'CLOSED_PUMP', 'CLOSED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pump', 'OPEN_PUMP', 'OPEN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_valve', 'ACTIVE_VALVE', 'ACTIVE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_valve', 'CLOSED_VALVE', 'CLOSED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_valve', 'OPEN_VALVE', 'OPEN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesnofull', 'FULL_YNF', 'FULL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesnofull', 'NO_YNF', 'NO', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesnofull', 'YES_YNF', 'YES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'NONE_QUAL', 'NONE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'NONE_TIMES', 'NONE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'RANGE', 'RANGE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'MINIMUM', 'MINIMUM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'MAXIMUM', 'MAXIMUM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'AVERAGED', 'AVERAGED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'TRACE', 'TRACE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_reactions_gl', 'ROUGHNESS CORRELATION', 'ROUGHNESS CORRELATION', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_reactions_gl', 'ORDER', 'ORDER', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_reactions_gl', 'LIMITING POTENTIAL', 'LIMITING POTENTIAL', NULL);


-----------------------
-- Records of sys_csv2pg_config
-----------------------
INSERT INTO sys_csv2pg_config VALUES (28, 11, 'rpt_node', 'Node Results', NULL, NULL);
INSERT INTO sys_csv2pg_config VALUES (29, 11, 'rpt_arc', 'Link Results', NULL, NULL);
INSERT INTO sys_csv2pg_config VALUES (30, 11, 'rpt_energy_usage', 'Pump Factor', NULL, NULL);
INSERT INTO sys_csv2pg_config VALUES (31, 11, 'rpt_hydraulic_status', 'Hydraulic Status:', NULL, NULL);
INSERT INTO sys_csv2pg_config VALUES (32, 11, 'rpt_cat_result', 'Input Data', NULL, NULL);
INSERT INTO sys_csv2pg_config VALUES (27, 10, 'vi_backdrop', '[BACKDROP]', 'csv1', 12);
INSERT INTO sys_csv2pg_config VALUES (26, 10, 'vi_labels', '[LABELS]', 'csv1, csv2, csv3, csv4', 12);
INSERT INTO sys_csv2pg_config VALUES (25, 10, 'vi_vertices', '[VERTICES]', 'csv1, csv2, csv3', 12);
INSERT INTO sys_csv2pg_config VALUES (24, 10, 'vi_coordinates', '[COORDINATES]', 'csv1, csv2, csv3', 12);
INSERT INTO sys_csv2pg_config VALUES (23, 10, 'vi_options', '[OPTIONS]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (22, 10, 'vi_report', '[REPORT]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (21, 10, 'vi_times', '[TIMES]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (20, 10, 'vi_mixing', '[MIXING]', 'csv1, csv2, csv3', 12);
INSERT INTO sys_csv2pg_config VALUES (17, 10, 'vi_sources', '[SOURCES]', 'csv1, csv2, csv3, csv4', 12);
INSERT INTO sys_csv2pg_config VALUES (18, 10, 'vi_reactions', '[REACTIONS]', 'csv1, csv2, csv3', 12);
INSERT INTO sys_csv2pg_config VALUES (16, 10, 'vi_quality', '[QUALITY]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (15, 10, 'vi_emitters', '[EMITTERS]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (14, 10, 'vi_energy', '[ENERGY]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (13, 10, 'vi_rules', '[RULES]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (12, 10, 'vi_controls', '[CONTROLS]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (11, 10, 'vi_curves', '[CURVES]', 'csv1, csv2, csv3', 12);
INSERT INTO sys_csv2pg_config VALUES (10, 10, 'vi_patterns', '[PATTERNS]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (9, 10, 'vi_status', '[STATUS]', 'csv1, csv2', 12);
INSERT INTO sys_csv2pg_config VALUES (8, 10, 'vi_demands', '[DEMANDS]', 'csv1, csv2, csv3, csv4', 12);
INSERT INTO sys_csv2pg_config VALUES (7, 10, 'vi_tags', '[TAGS]', 'csv1, csv2, csv3', 12);
INSERT INTO sys_csv2pg_config VALUES (5, 10, 'vi_pumps', '[PUMPS]', 'csv1, csv2, csv3, csv4', 12);
INSERT INTO sys_csv2pg_config VALUES (6, 10, 'vi_valves', '[VALVES]', 'csv1, csv2, csv3, csv4, csv5, csv6, csv7', 12);
INSERT INTO sys_csv2pg_config VALUES (2, 10, 'vi_reservoirs', '[RESERVOIRS]', 'csv1, csv2, csv3', 12);
INSERT INTO sys_csv2pg_config VALUES (1, 10, 'vi_junctions', '[JUNCTIONS]', 'csv1, csv2, csv3, csv4', 12);
INSERT INTO sys_csv2pg_config VALUES (4, 10, 'vi_pipes', '[PIPES]', 'csv1, csv2, csv3, csv4, csv5, csv6, csv7, csv8', 12);
INSERT INTO sys_csv2pg_config VALUES (3, 10, 'vi_tanks', '[TANKS]', 'csv1, csv2, csv3, csv4, csv5, csv6, csv7, csv8', 12);



