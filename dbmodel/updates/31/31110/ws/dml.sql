/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO audit_cat_param_user VALUES ('inp_report_f_factor', 'epaoptions', NULL, 'role_epa', NULL, 'F-FACTOR', 'F Factor:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 2, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'combo', 'text', true, NULL, 'PRECISION 4', 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_checkfreq', 'epaoptions', NULL, 'role_epa', NULL, 'CHECKFREQ', 'Check frequency:', NULL, NULL, true, 4, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '2.00', 'grl_hyd_4', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_damplimit', 'epaoptions', NULL, 'role_epa', NULL, 'DAMPLIMIT', 'Damp limit:', NULL, NULL, true, 4, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '0.00', 'grl_hyd_4', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_demand_multiplier', 'epaoptions', NULL, 'role_epa', NULL, 'DEMAND MULTIPLIER', 'Demand multiplier:', NULL, NULL, true, 1, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '1.00', 'grl_general_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_emitter_exponent', 'epaoptions', NULL, 'role_epa', NULL, 'EMITTER EXPONENT', 'Emitter exponent:', NULL, NULL, true, 3, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '0.5', 'grl_hyd_3', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_maxcheck', 'epaoptions', NULL, 'role_epa', NULL, 'MAXCHECK', 'Max check:', NULL, NULL, true, 3, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '10.00', 'grl_hyd_3', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_links', 'epaoptions', NULL, 'role_epa', NULL, 'LINKS', 'Links:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 9, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'ALL', 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_rtc_coefficient', 'epaoptions', NULL, 'role_epa', NULL, 'RTC_COEFFICIENT', 'Coefficient:', NULL, NULL, true, 10, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_crm_10', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_specific_gravity', 'epaoptions', NULL, 'role_epa', NULL, 'SPECIFIC GRAVITY', 'Specific gravety:', NULL, NULL, true, 4, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '1.00', 'grl_hyd_4', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_trials', 'epaoptions', NULL, 'role_epa', NULL, 'TRIALS', 'Trials:', NULL, NULL, true, 3, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '40.00', 'grl_hyd_3', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_unbalanced_n', 'epaoptions', NULL, 'role_epa', NULL, 'UNBALANCED_N', 'Unbalanced n:', NULL, NULL, true, 4, 7, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '40.00', 'grl_hyd_4', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_valve_mode_mincut_result', 'epaoptions', NULL, 'role_epa', NULL, 'VALVE_MODE_MINCUT_RESULT', 'Mincut result id:', NULL, NULL, true, 8, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'integer', 'text', true, NULL, NULL, 'grl_status_8', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_energy', 'epaoptions', NULL, 'role_epa', NULL, 'ENERGY', 'Energy:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_pagesize', 'epaoptions', NULL, 'role_epa', NULL, 'PAGESIZE', 'Pagesize:', NULL, NULL, true, 14, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'integer', 'text', true, NULL, NULL, 'grl_reports_18', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_status', 'epaoptions', NULL, 'role_epa', NULL, 'STATUS', 'Status:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesnofull''', NULL, true, 14, 7, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_duration', 'epaoptions', NULL, 'role_epa', NULL, 'DURATION', 'Duration:', NULL, NULL, true, 11, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'integer', 'text', true, '{"minValue":0.001, "maxValue":100}', '24', 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]');
INSERT INTO audit_cat_param_user VALUES ('inp_options_rtc_period_id', 'epaoptions', NULL, 'role_epa', NULL, 'RTC_PERIOD_ID', 'Time period:', NULL, NULL, true, 9, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_crm_9', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_node_id', 'epaoptions', NULL, 'role_epa', NULL, 'NODE_ID', 'Node id:', NULL, NULL, true, 6, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_quality_6', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_quality_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'QUALITY TIMESTEP', 'Quality timestep:', NULL, NULL, true, 11, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]');
INSERT INTO audit_cat_param_user VALUES ('inp_options_viscosity', 'epaoptions', NULL, 'role_epa', NULL, 'VISCOSITY', 'Viscosity:', NULL, NULL, true, 3, 7, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '1.00', 'grl_hyd_3', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_hydraulic_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'HYDRAULIC TIMESTEP', 'Hydraulic timestemp:', NULL, NULL, true, 12, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, '{"minValue":0.001, "maxValue":100}', '0:30', 'grl_date_14', '[\d]+:[0-5][0-9]:[0-5][0-9]');
INSERT INTO audit_cat_param_user VALUES ('inp_report_elevation', 'epaoptions', NULL, 'role_epa', NULL, 'ELEVATION', 'Elevation:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_pattern_start', 'epaoptions', NULL, 'role_epa', NULL, 'PATTERN START', 'Pattern start:', NULL, NULL, true, 12, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_14', '[\d]+:[0-5][0-9]:[0-5][0-9]');
INSERT INTO audit_cat_param_user VALUES ('inp_options_pattern', 'epaoptions', NULL, 'role_epa', NULL, 'PATTERN', 'Pattern:', NULL, NULL, true, 2, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, '{"minValue":0.001, "maxValue":100}', '1', 'grl_general_2', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_file', 'epaoptions', NULL, 'role_epa', NULL, 'FILE', 'File:', NULL, NULL, true, 13, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_flow', 'epaoptions', NULL, 'role_epa', NULL, 'FLOW', 'Flow:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 6, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_head', 'epaoptions', NULL, 'role_epa', NULL, 'HEAD', 'Head:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 7, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_length', 'epaoptions', NULL, 'role_epa', NULL, 'LENGTH', 'Length:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 8, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_pattern_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'PATTERN TIMESTEP', 'Pattern timestep:', NULL, NULL, true, 11, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]');
INSERT INTO audit_cat_param_user VALUES ('inp_times_report_start', 'epaoptions', NULL, 'role_epa', NULL, 'REPORT START', 'Report start:', NULL, NULL, true, 12, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_14', '[\d]+:[0-5][0-9]:[0-5][0-9]');
INSERT INTO audit_cat_param_user VALUES ('inp_times_report_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'REPORT TIMESTEP', 'Report timestep:', NULL, NULL, true, 11, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]');
INSERT INTO audit_cat_param_user VALUES ('inp_times_rule_timestep', 'epaoptions', NULL, 'role_epa', NULL, 'RULE TIMESTEP', 'Rule timestep:', NULL, NULL, true, 12, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_14', '[\d]+:[0-5][0-9]:[0-5][0-9]');
INSERT INTO audit_cat_param_user VALUES ('inp_times_start_clocktime', 'epaoptions', NULL, 'role_epa', NULL, 'START CLOCKTIME', 'Start clocktime:', NULL, NULL, true, 11, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_date_13', '[\d]+:[0-5][0-9]:[0-5][0-9]');
INSERT INTO audit_cat_param_user VALUES ('inp_report_summary', 'epaoptions', NULL, 'role_epa', NULL, 'SUMMARY', 'Summary:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 8, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_velocity', 'epaoptions', NULL, 'role_epa', NULL, 'VELOCITY', 'Velocity:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 9, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_quality_mode', 'epaoptions', NULL, 'role_epa', NULL, 'QUALITY', 'Quality Mode:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_qual''', NULL, true, 5, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'NONE', 'grl_quality_5', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_valve_mode', 'epaoptions', NULL, 'role_epa', NULL, 'VALVE_MODE', 'Valve mode:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_valvemode''', NULL, true, 7, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'EPA TABLES', 'grl_status_7', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_reaction', 'epaoptions', NULL, 'role_epa', NULL, 'REACTION', 'Reaction:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_diffusivity', 'epaoptions', NULL, 'role_epa', NULL, 'DIFFUSIVITY', 'Diffusivity:', NULL, NULL, true, 4, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '1', 'grl_hyd_4', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_setting', 'epaoptions', NULL, 'role_epa', NULL, 'SETTING', 'Setting:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 6, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_rtc_enabled', 'epaoptions', NULL, 'role_epa', NULL, 'RTC ENABLED', 'CRM values', NULL, NULL, true, 9, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'boolean', 'check', true, NULL, 'FALSE', 'grl_crm_9', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_headloss', 'epaoptions', NULL, 'role_epa', NULL, 'HEADLOSS', 'Headloss:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_headloss''', NULL, true, 2, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'H-W', 'grl_general_2', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_unbalanced', 'epaoptions', NULL, 'role_epa', NULL, 'UNBALANCED', 'Unbalanced:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_unbal''', NULL, true, 3, 6, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'CONTINUE', 'grl_hyd_3', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_demand', 'epaoptions', NULL, 'role_epa', NULL, 'DEMAND', 'Demand:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_diameter', 'epaoptions', NULL, 'role_epa', NULL, 'DIAMETER', 'Diameter:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 13, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_17', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_pressure', 'epaoptions', NULL, 'role_epa', NULL, 'PRESSURE', 'Pressure:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_quality', 'epaoptions', NULL, 'role_epa', NULL, 'QUALITY', 'Quality:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'YES', 'grl_reports_18', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_accuracy', 'epaoptions', NULL, 'role_epa', NULL, 'ACCURACY', 'Accuracy:', NULL, NULL, true, 3, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '0.001', 'grl_hyd_3', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_hydraulics', 'epaoptions', NULL, 'role_epa', NULL, 'HYDRAULICS', 'Hydraulics:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_hyd''', NULL, true, 3, 3, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'NONE', 'grl_hyd_3', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_hydraulics_fname', 'epaoptions', NULL, 'role_epa', NULL, 'HYDRAULICS_FNAME', 'Hydraulics fname:', NULL, NULL, true, 4, 4, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'text', true, NULL, NULL, 'grl_hyd_4', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_tolerance', 'epaoptions', NULL, 'role_epa', NULL, 'TOLERANCE', 'Tolerance:', NULL, NULL, true, 4, 6, 'ws', NULL, NULL, NULL, NULL, NULL, 'float', 'text', true, '{"minValue":0.001, "maxValue":100}', '0.01', 'grl_hyd_4', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_units', 'epaoptions', NULL, 'role_epa', NULL, 'UNITS', 'Units:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_units''', NULL, true, 1, 2, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'LPS', 'grl_general_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_nodes', 'epaoptions', NULL, 'role_epa', NULL, 'NODES', 'Nodes:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_yesno''', NULL, true, 14, 1, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'ALL', 'grl_reports_18', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_times_statistic', 'epaoptions', NULL, 'role_epa', NULL, 'STATISTIC', 'Statistic:', 'SELECT idval AS id, idval FROM inp_typevalue WHERE typevalue=''inp_value_times''', NULL, true, 12, 5, 'ws', NULL, NULL, NULL, NULL, NULL, 'text', 'combo', true, NULL, 'NONE', 'grl_date_14', '[\d]+:[0-5][0-9]:[0-5][0-9]');


/*
-- example on 31107/utils/dml
UPDATE audit_cat_param_user SET     WHERE parameter='pumpcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Pump catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''PUMP''', NULL, true, 9, 9, 'ws', false, NULL, 'nodecat_id', 'PUMP', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='wtpcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Wtp catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''WTP''', NULL, true, 9, 2, 'ws', false, NULL, 'nodecat_id', 'WTP', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='waterwellcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Waterwell catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''WATERWELL''', NULL, true, 9, 15, 'ws', false, NULL, 'nodecat_id', 'WATERWELL', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='netsamplepointcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Netsamplepoint catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''NETSAMPLEPOINT''', NULL, true, 9, 3, 'ws', false, NULL, 'nodecat_id', 'NETSAMPLEPOINT', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='reductioncat_vdefault', 'config', NULL, 'role_edit', NULL, 'Reduction catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''REDUCTION''', NULL, true, 9, 10, 'ws', false, NULL, 'nodecat_id', 'REDUCTION', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='flexunioncat_vdefault', 'config', NULL, 'role_edit', NULL, 'Flexunioncat catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''FLEXUNION''', NULL, true, 9, 5, 'ws', false, NULL, 'nodecat_id', 'FLEXUNION', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='metercat_vdefault', 'config', NULL, 'role_edit', NULL, 'Meter catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''METER''', NULL, true, 9, 13, 'ws', false, NULL, 'nodecat_id', 'METER', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='netwjoincat_vdefault', 'config', NULL, 'role_edit', NULL, 'Netwjoin catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''NETWJOIN''', NULL, true, 9, 18, 'ws', false, NULL, 'nodecat_id', 'NETWJOIN', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='netelementcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Netelement catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''NETELEMENT''', NULL, true, 9, 4, 'ws', false, NULL, 'nodecat_id', 'NETELEMENT', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='registercat_vdefault', 'config', NULL, 'role_edit', NULL, 'Register catalog:', 'SELECT cat_node.id AS id,  cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''REGISTER''', NULL, true, 9, 17, 'ws', false, NULL, 'nodecat_id', 'REGISTER', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='connectype_vdefault', 'config', NULL, 'role_edit', NULL, 'Connec Type:', 'SELECT id AS id, id AS idval FROM connec_type WHERE id IS NOT NULL', NULL, true, 9, 3, 'ud', false, NULL, 'connecat_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='hydrantcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Hydrant catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''HYDRANT''', NULL, true, 9, 7, 'ws', false, NULL, 'nodecat_id', 'HYDRANT', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='wjoincat_vdefault', 'config', NULL, 'role_edit', NULL, 'Wjoin catalog:', 'SELECT cat_connec.id AS id, cat_connec.id as idval FROM cat_connec JOIN connec_type ON connec_type.id=connectype_id WHERE type=''WJOIN''', NULL, true, 9, 21, 'ws', false, NULL, 'connecat_id', 'WJOIN', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='greentapcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Greentap catalog:', 'SELECT cat_connec.id AS id, cat_connec.id as idval  FROM cat_connec JOIN connec_type ON connec_type.id=connectype_id WHERE type=''GREENTAP''', NULL, true, 9, 22, 'ws', false, NULL, 'connecat_id', 'GREENTAP', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='fountaincat_vdefault', 'config', NULL, 'role_edit', NULL, 'Fountain catalog', 'SELECT cat_connec.id AS id, cat_connec.id as idval  FROM cat_connec JOIN connec_type ON connec_type.id=connectype_id WHERE type=''FOUNTAIN''', NULL, true, 9, 23, 'ws', false, NULL, 'connecat_id', 'FOUNTAIN', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='expansiontankcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Expansiontank catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''EXPANSIONTANK''', NULL, true, 9, 19, 'ws', false, NULL, 'nodecat_id', 'EXPANTANK', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='sourcecat_vdefault', 'config', NULL, 'role_edit', NULL, 'Source catalog:', 'SELECT cat_node.id AS id,  cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''SOURCE''', NULL, true, 9, 14, 'ws', false, NULL, 'nodecat_id', 'SOURCE', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='valvecat_vdefault', 'config', NULL, 'role_edit', NULL, 'Valve catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''VALVE''', NULL, true, 9, 11, 'ws', false, NULL, 'nodecat_id', 'VALVE', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='presszone_vdefault', 'config', NULL, 'role_edit', NULL, 'Presszone:', 'SELECT cat_presszone.id AS id, cat_presszone.id as idval FROM cat_presszone WHERE id IS NOT NULL', NULL, true, 9, 1, 'ws', false, NULL, 'presszone_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='tankcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Tank catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''TANK''', NULL, true, 9, 6, 'ws', false, NULL, 'nodecat_id', 'TANK', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='filtercat_vdefault', 'config', NULL, 'role_edit', NULL, 'Filter catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''FILTER''', NULL, true, 9, 16, 'ws', false, NULL, 'nodecat_id', 'FILTER', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='pipecat_vdefault', 'config', NULL, 'role_edit', NULL, 'Pipe catalog:', 'SELECT cat_arc.id AS id, cat_arc.id as idval FROM cat_arc JOIN arc_type ON arc_type.id=arctype_id WHERE type=''PIPE''', NULL, true, 9, 20, 'ws', false, NULL, 'arccat_id', 'PIPE', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='junctioncat_vdefault', 'config', NULL, 'role_edit', NULL, 'Junction catalog:', 'SELECT cat_node.id AS id,cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''JUNCTION''', NULL, true, 9, 8, 'ws', false, NULL, 'nodecat_id', 'JUNCTION', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='tapcat_vdefault', 'config', NULL, 'role_edit', NULL, 'Tap catalog:', 'SELECT cat_connec.id AS id, cat_connec.id as idval  FROM cat_connec JOIN connec_type ON connec_type.id=connectype_id WHERE type=''TAP''', NULL, true, 9, 24, 'ws', false, NULL, 'connecat_id', 'TAP', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='manholecat_vdefault', 'config', NULL, 'role_edit', NULL, 'Manhole catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval  FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''MANHOLE''', NULL, true, 9, 12, 'ws', false, NULL, 'nodecat_id', 'MANHOLE', false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
*/



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

INSERT INTO audit_cat_param_user VALUES ('manholecat_vdefault', 'config', 'Default value for manhole element parameter', 'role_edit', null, 'manholecat_vdefault:', 'id', 'SELECT cat_node.id FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''MANHOLE'' AND cat_node.id=', 'text');
INSERT INTO audit_cat_param_user VALUES ('waterwellcat_vdefault', 'config', 'Default value for waterwell element parameter', 'role_edit', null, 'waterwellcat_vdefault:', 'id', 'SELECT cat_node.id FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''WATERWELL'' AND cat_node.id=', 'text');


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

--2019/02/08
INSERT INTO audit_cat_param_user VALUES ('psector_type_vdefault', 'config', 'Default value for psector type parameter', 'role_master', NULL, 'psector_type_vdefault:');
INSERT INTO audit_cat_param_user VALUES ('owndercat_vdefault', 'config', 'Default value for owner parameter', 'role_edit', NULL, 'owndercat_vdefault:');
DELETE FROM config_param_user WHERE parameter='qgis_template_folder_path';

-- 2019/02/12
INSERT INTO config_param_system (parameter, value, datatype, context, descript) VALUES ('code_vd', 'No code', 'string', 'OM', 'UD');
UPDATE config_param_system SET descript='Variable to enable/disable the possibility to use valve unaccess button to open valves with closed status (WS)' WHERE parameter='om_mincut_valvestat_using_valveunaccess';
UPDATE config_param_system SET descript='Variable to enable/disable the debug messages of mincut (WS)' WHERE parameter='om_mincut_debug';


