/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



INSERT INTO audit_cat_param_user VALUES ('inp_report_f_factor', 'epaoptions', NULL, 'role_epa', NULL, 'F-FACTOR', 'F Factor:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 2, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'combo', 'text', true, NULL, 'PRECISION 4', 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_links', 'epaoptions', NULL, 'role_epa', NULL, 'LINKS', 'Links:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 9, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'ALL', 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_valve_mode_mincut_result', 'epaoptions', NULL, 'role_epa', NULL, 'VALVE_MODE_MINCUT_RESULT', 'Mincut result id:', NULL, NULL, true, 8, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'integer', 'text', true, NULL, NULL, 'grl_status_8', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_energy', 'epaoptions', NULL, 'role_epa', NULL, 'ENERGY', 'Energy:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_pagesize', 'epaoptions', NULL, 'role_epa', NULL, 'PAGESIZE', 'Pagesize:', NULL, NULL, true, 14, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'integer', 'text', true, NULL, NULL, 'grl_reports_18', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_status', 'epaoptions', NULL, 'role_epa', NULL, 'STATUS', 'Status:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesnofull''', NULL, true, 14, 7, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_node_id', 'epaoptions', NULL, 'role_epa', NULL, 'NODE_ID', 'Node id:', NULL, NULL, true, 6, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_quality_6', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_elevation', 'epaoptions', NULL, 'role_epa', NULL, 'ELEVATION', 'Elevation:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_file', 'epaoptions', NULL, 'role_epa', NULL, 'FILE', 'File:', NULL, NULL, true, 13, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_flow', 'epaoptions', NULL, 'role_epa', NULL, 'FLOW', 'Flow:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 6, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_head', 'epaoptions', NULL, 'role_epa', NULL, 'HEAD', 'Head:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 7, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_length', 'epaoptions', NULL, 'role_epa', NULL, 'LENGTH', 'Length:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 8, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_pattern_start', 'epaoptions', NULL, 'role_epa', NULL, 'PATTERN START', 'Pattern start:', NULL, NULL, true, 12, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_14', '[\d]+:[0-5][0-9]:[0-5][0-9]', NULL, NULL, NULL, NULL, '0:00');
INSERT INTO audit_cat_param_user VALUES ('inp_times_quality_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'QUALITY TIMESTEP', 'Quality timestep:', NULL, NULL, true, 11, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]', NULL, NULL, NULL, NULL, '0:05');
INSERT INTO audit_cat_param_user VALUES ('inp_times_pattern_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'PATTERN TIMESTEP', 'Pattern timestep:', NULL, NULL, true, 11, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]', NULL, NULL, NULL, NULL, '1:00');
INSERT INTO audit_cat_param_user VALUES ('inp_times_duration', 'epaoptions', NULL, 'role_epa', NULL, 'DURATION', 'Duration:', NULL, NULL, true, 11, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'integer', 'text', true, '{"minValue":0.001, "maxValue":100}', '24', 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]', NULL, NULL, NULL, NULL, '365:23:59');
INSERT INTO audit_cat_param_user VALUES ('inp_options_rtc_period_id', 'epaoptions', NULL, 'role_epa', NULL, 'RTC_PERIOD_ID', 'Time period:', 'SELECT id AS id, code AS idval FROM ext_cat_period', NULL, true, 9, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, NULL, 'grl_crm_9', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_demand_multiplier', 'epaoptions', NULL, 'role_epa', NULL, 'DEMAND MULTIPLIER', 'Demand multiplier:', NULL, NULL, true, 1, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '1.00', 'grl_general_1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_trials', 'epaoptions', NULL, 'role_epa', NULL, 'TRIALS', 'Maximum trials:', NULL, NULL, true, 3, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '40.00', 'grl_hyd_3', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_specific_gravity', 'epaoptions', NULL, 'role_epa', NULL, 'SPECIFIC GRAVITY', 'Specific gravity:', NULL, NULL, true, 3, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '1.00', 'grl_hyd_4', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_pattern', 'epaoptions', NULL, 'role_epa', NULL, 'PATTERN', 'Pattern:', 'SELECT ''NULLVALUE''::text AS id, null AS idval UNION SELECT pattern_id AS id, pattern_id AS idval FROM inp_pattern', NULL, true, 2, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, NULL, 'grl_general_2', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_viscosity', 'epaoptions', NULL, 'role_epa', NULL, 'VISCOSITY', 'Relative viscosity:', NULL, NULL, true, 4, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '1.00', 'grl_hyd_3', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_maxcheck', 'epaoptions', NULL, 'role_epa', NULL, 'MAXCHECK', 'Max check:', NULL, NULL, true, 3, 7, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '10.00', 'grl_hyd_3', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_checkfreq', 'epaoptions', NULL, 'role_epa', NULL, 'CHECKFREQ', 'Check frequency:', NULL, NULL, true, 4, 7, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '2.00', 'grl_hyd_4', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_emitter_exponent', 'epaoptions', NULL, 'role_epa', NULL, 'EMITTER EXPONENT', 'Emitter exponent:', NULL, NULL, true, 3, 6, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '0.5', 'grl_hyd_3', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_unbalanced_n', 'epaoptions', NULL, 'role_epa', NULL, 'UNBALANCED_N', 'Additional trials:', NULL, NULL, true, 4, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '40.00', 'grl_hyd_4', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_damplimit', 'epaoptions', NULL, 'role_epa', NULL, 'DAMPLIMIT', 'Damp limit:', NULL, NULL, true, 4, 6, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '0.00', 'grl_hyd_4', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_quality_mode', 'epaoptions', NULL, 'role_epa', NULL, 'QUALITY', 'Quality Mode:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_qual''', NULL, true, 5, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'NONE', 'grl_quality_5', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_valve_mode', 'epaoptions', NULL, 'role_epa', NULL, 'VALVE_MODE', 'Valve mode:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_valvemode''', NULL, true, 7, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'EPA TABLES', 'grl_status_7', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_reaction', 'epaoptions', NULL, 'role_epa', NULL, 'REACTION', 'Reaction:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_setting', 'epaoptions', NULL, 'role_epa', NULL, 'SETTING', 'Setting:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 6, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_headloss', 'epaoptions', NULL, 'role_epa', NULL, 'HEADLOSS', 'Headloss:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_headloss''', NULL, true, 2, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'H-W', 'grl_general_2', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_demand', 'epaoptions', NULL, 'role_epa', NULL, 'DEMAND', 'Demand:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_diameter', 'epaoptions', NULL, 'role_epa', NULL, 'DIAMETER', 'Diameter:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_pressure', 'epaoptions', NULL, 'role_epa', NULL, 'PRESSURE', 'Pressure:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_quality', 'epaoptions', NULL, 'role_epa', NULL, 'QUALITY', 'Quality:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_nodes', 'epaoptions', NULL, 'role_epa', NULL, 'NODES', 'Nodes:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'ALL', 'grl_reports_18', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_report_start', 'epaoptions', NULL, 'role_epa', NULL, 'REPORT START', 'Report start:', NULL, NULL, true, 12, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_14', '[\d]+:[0-5][0-9]:[0-5][0-9]', NULL, NULL, NULL, NULL, '0:00');
INSERT INTO audit_cat_param_user VALUES ('inp_options_nodarc_onlymandatory', 'epaoptions', NULL, 'role_epa', NULL, 'nodarc_mandatory', 'Only mandatory nodarc:', NULL, NULL, true, 16, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'boolean', 'check', true, NULL, 'FALSE', 'grl_inpother_16', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_summary', 'epaoptions', NULL, 'role_epa', NULL, 'SUMMARY', 'Summary:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 8, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_hydraulic_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'HYDRAULIC TIMESTEP', 'Hydraulic timestemp:', NULL, NULL, true, 12, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, '{"minValue":0.001, "maxValue":100}', '0:30', 'grl_date_14', '[\d]+:[0-5][0-9]:[0-5][0-9]', NULL, NULL, NULL, NULL, '1:00');
INSERT INTO audit_cat_param_user VALUES ('inp_options_units', 'epaoptions', NULL, 'role_epa', NULL, 'UNITS', 'Units:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_units''', NULL, true, 1, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'LPS', 'grl_general_1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_start_clocktime', 'epaoptions', NULL, 'role_epa', NULL, 'START CLOCKTIME', 'Start clocktime:', NULL, NULL, true, 11, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]', NULL, NULL, NULL, NULL, '0:00');
INSERT INTO audit_cat_param_user VALUES ('inp_report_velocity', 'epaoptions', NULL, 'role_epa', NULL, 'VELOCITY', 'Velocity:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 9, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL, false, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_tolerance', 'epaoptions', NULL, 'role_epa', NULL, 'TOLERANCE', 'Quality tolerance:', NULL, NULL, true, 5, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '0.01', 'grl_quality_5', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_report_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'REPORT TIMESTEP', 'Report timestep:', NULL, NULL, true, 11, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]', NULL, NULL, NULL, NULL, '1:00');
INSERT INTO audit_cat_param_user VALUES ('inp_options_rtc_coefficient', 'epaoptions', NULL, 'role_epa', NULL, 'RTC_COEFFICIENT', 'Coefficient:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_rtc_coef''', NULL, true, 10, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, NULL, 'grl_crm_10', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_rtc_enabled', 'epaoptions', NULL, 'role_epa', NULL, 'RTC ENABLED', 'CRM values', NULL, NULL, true, 9, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'boolean', 'check', true, NULL, 'FALSE', 'grl_crm_9', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_other_recursive_function', 'epaoptions', NULL, 'role_epa', NULL, 'RECURSIVE', 'Recursive:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_times''', NULL, false, 15, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', false, NULL, 'NONE', 'grl_inpother_15', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_nodarc_length', 'epaoptions', NULL, 'role_epa', NULL, 'nod2arc_length', 'Nod2arc length:', NULL, NULL, true, 15, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, NULL, '0.3', 'grl_inpother_15', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_statistic', 'epaoptions', NULL, 'role_epa', NULL, 'STATISTIC', 'Statistic:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_times''', NULL, true, 12, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'NONE', 'grl_date_14', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_rule_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'RULE TIMESTEP', 'Rule timestep:', NULL, NULL, true, 12, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_14', '[\d]+:[0-5][0-9]:[0-5][0-9]', NULL, NULL, NULL, NULL, '1:00');
INSERT INTO audit_cat_param_user VALUES ('inp_options_hydraulics', 'epaoptions', NULL, 'role_epa', NULL, 'HYDRAULICS', 'Hydraulics:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_hyd''', NULL, true, 3, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, NULL, 'grl_hyd_3', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_diffusivity', 'epaoptions', NULL, 'role_epa', NULL, 'DIFFUSIVITY', 'Relative diffusivity:', NULL, NULL, true, 6, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '1', 'grl_quality_6', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_unbalanced', 'epaoptions', NULL, 'role_epa', NULL, 'UNBALANCED', 'If unbalanced:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_unbal''', NULL, true, 3, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'CONTINUE', 'grl_hyd_3', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_hydraulics_fname', 'epaoptions', NULL, 'role_epa', NULL, 'HYDRAULICS_FNAME', 'Hydraulics fname:', NULL, NULL, true, 4, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_hyd_4', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_accuracy', 'epaoptions', NULL, 'role_epa', NULL, 'ACCURACY', 'Accuracy:', NULL, NULL, true, 4, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '0.001', 'grl_hyd_4', NULL, NULL, NULL, NULL, NULL, NULL);



UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_backdrop';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_controls';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_curve';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_demand';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_emitter';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_energy_el';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_energy_gl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_junction';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_label';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_mixing';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_options';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_pattern';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_pipe';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_project_id';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_pump';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_quality';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_reactions_el';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_reactions_gl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_report';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_reservoir';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_rules';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_source';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_status';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_tags';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_tank';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_times';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_valve_cu';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_valve_fl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_valve_lc';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_valve_pr';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_vertice';

UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_energy';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_pump';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_reactions_gl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_source';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_valve';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_ampm';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_curve';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_mixing';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_noneall';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_headloss';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_hyd';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_qual';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_rtc_coef';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_unbal';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_units';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_valvemode';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_param_energy';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_reactions_el';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_reactions_gl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_status_pipe';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_status_pump';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_status_valve';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_times';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_yesno';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_yesnofull';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_options';



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



UPDATE inp_energy_gl SET parameter='GLOBAL_GL' WHERE parameter='GLOBAL';
UPDATE inp_energy_gl SET parameter='BULK_GL' WHERE parameter='BULK';
UPDATE inp_energy_gl SET parameter='TANK_GL' WHERE parameter='TANK';
UPDATE inp_energy_gl SET parameter='WALL_GL' WHERE parameter='WALL';
UPDATE inp_energy_el SET parameter='BULK_EL' WHERE parameter='BULK';
UPDATE inp_energy_el SET parameter='TANK_EL' WHERE parameter='TANK';
UPDATE inp_energy_el SET parameter='WALL_EL' WHERE parameter='WALL';
UPDATE inp_pipe SET status='CLOSED_PIPE' WHERE status='CLOSED';
UPDATE inp_pipe SET status='CV_PIPE' WHERE status='CV';
UPDATE inp_pipe SET status='OPEN_PIPE' WHERE status='OPEN';
UPDATE inp_pump SET status='CLOSED_PUMP' WHERE status='CLOSED';
UPDATE inp_pump SET status='OPEN_PUMP' WHERE status='OPEN';
UPDATE inp_valve SET status='OPEN_VALVE' WHERE status='OPEN';
UPDATE inp_valve SET status='ACTIVE_VALVE' WHERE status='ACTIVE';
UPDATE inp_valve SET status='CLOSED_VALVE' WHERE status='CLOSED';


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


-- INSERTS

INSERT INTO audit_cat_param_user (id,formname,description,sys_role_id,qgis_message,label,dv_querytext,dv_parent_id,isenabled,layout_id,layout_order,project_type,isparent,dv_querytext_filterc,feature_field_id,feature_dv_parent_value,isautoupdate,datatype,widgettype,ismandatory,widgetcontrols,vdefault,layout_name,reg_exp) VALUES('reductioncat_vdefault', 'config', NULL, 'role_edit', NULL, 'Reduction catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''REDUCTION''', NULL, true, 9, 10, 'ws', false, NULL, 'nodecat_id', 'REDUCTION', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);

-- UPDATES
UPDATE audit_cat_param_user SET  label='Pump catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''PUMP''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=9 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='PUMP', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL,layout_name=NULL, reg_exp=NULL WHERE id='pumpcat_vdefault';
UPDATE audit_cat_param_user SET  label='Wtp catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''WTP''', dv_parent_id=NULL, isenabled=true , layout_id=9,layout_order=2 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='WTP', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='wtpcat_vdefault';
UPDATE audit_cat_param_user SET  label='Waterwell catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''WATERWELL''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=15 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='WATERWELL', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='waterwellcat_vdefault';
UPDATE audit_cat_param_user SET  label='Netsamplepoint catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''NETSAMPLEPOINT''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=3 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='NETSAMPLEPOINT', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='netsamplepointcat_vdefault';
UPDATE audit_cat_param_user SET  label='Flexunioncat catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''FLEXUNION''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=5 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='FLEXUNION', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='flexunioncat_vdefault';
UPDATE audit_cat_param_user SET  label='Meter catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''METER''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=13 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='METER', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='metercat_vdefault';
UPDATE audit_cat_param_user SET  label='Netwjoin catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''NETWJOIN''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=18 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='NETWJOIN', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='netwjoincat_vdefault';
UPDATE audit_cat_param_user SET  label='Netelement catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''NETELEMENT''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=4 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='NETELEMENT', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='netelementcat_vdefault';
UPDATE audit_cat_param_user SET  label='Register catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id,  cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''REGISTER''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=17 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='REGISTER', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='registercat_vdefault';
UPDATE audit_cat_param_user SET  label='Hydrant catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''HYDRANT''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=7 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='HYDRANT', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='hydrantcat_vdefault';
UPDATE audit_cat_param_user SET  label='Wjoin catalog:',formname='config', dv_querytext='SELECT cat_connec.id AS id, cat_connec.id as idval FROM cat_connec JOIN connec_type ON connec_type.id=connectype_id WHERE type=''WJOIN''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=21 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='connecat_id', feature_dv_parent_value='WJOIN', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='wjoincat_vdefault';
UPDATE audit_cat_param_user SET  label='Greentap catalog:',formname='config', dv_querytext='SELECT cat_connec.id AS id, cat_connec.id as idval  FROM cat_connec JOIN connec_type ON connec_type.id=connectype_id WHERE type=''GREENTAP''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=22 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='connecat_id', feature_dv_parent_value='GREENTAP', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='greentapcat_vdefault';
UPDATE audit_cat_param_user SET  label='Fountain catalog:',formname='config', dv_querytext='SELECT cat_connec.id AS id, cat_connec.id as idval  FROM cat_connec JOIN connec_type ON connec_type.id=connectype_id WHERE type=''FOUNTAIN''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=23 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='connecat_id', feature_dv_parent_value='FOUNTAIN', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='fountaincat_vdefault';
UPDATE audit_cat_param_user SET  label='Expansiontank catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''EXPANSIONTANK''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=19 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='EXPANTANK', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='expansiontankcat_vdefault';
UPDATE audit_cat_param_user SET  label='Source catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id,  cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''SOURCE''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=14 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='SOURCE', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='sourcecat_vdefault';
UPDATE audit_cat_param_user SET  label='Valve catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''VALVE''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=11 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='VALVE', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='valvecat_vdefault';
UPDATE audit_cat_param_user SET  label='Presszone:',formname='config', dv_querytext='SELECT cat_presszone.id AS id, cat_presszone.id as idval FROM cat_presszone WHERE id IS NOT NULL', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=1 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='presszone_id', feature_dv_parent_value='VALVE', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='presszone_vdefault';
UPDATE audit_cat_param_user SET  label='Tank catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''TANK''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=6 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='TANK', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='tankcat_vdefault';
UPDATE audit_cat_param_user SET  label='Filter catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''FILTER''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=16 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='FILTER', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='filtercat_vdefault';
UPDATE audit_cat_param_user SET  label='Pipe catalog:',formname='config', dv_querytext='SELECT cat_arc.id AS id, cat_arc.id as idval FROM cat_arc JOIN arc_type ON arc_type.id=arctype_id WHERE type=''PIPE''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=20 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='arccat_id', feature_dv_parent_value='PIPE', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='pipecat_vdefault';
UPDATE audit_cat_param_user SET  label='Junction catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id,cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''JUNCTION''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=8 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='JUNCTION', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='junctioncat_vdefault';
UPDATE audit_cat_param_user SET  label='Tap catalog:',formname='config', dv_querytext='SELECT cat_connec.id AS id, cat_connec.id as idval  FROM cat_connec JOIN connec_type ON connec_type.id=connectype_id WHERE type=''TAP''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=24 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='connecat_id', feature_dv_parent_value='TAP', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='tapcat_vdefault';
UPDATE audit_cat_param_user SET  label='Manhole catalog:',formname='config', dv_querytext='SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''MANHOLE''', dv_parent_id=NULL, isenabled=true , layout_id=9 ,layout_order=12 , project_type='ws' ,isparent=false ,dv_querytext_filterc=NULL, feature_field_id='nodecat_id', feature_dv_parent_value='MANHOLE', isautoupdate=false, datatype='string' , widgettype='combo', ismandatory=false , widgetcontrols=NULL , vdefault=NULL, layout_name=NULL, reg_exp=NULL WHERE id='manholecat_vdefault';
