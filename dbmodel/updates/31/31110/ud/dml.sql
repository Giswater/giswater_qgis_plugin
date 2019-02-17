/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 20110/02/05

INSERT INTO audit_cat_param_user VALUES ('dim_tooltip', 'config', 'If true, tooltip appears when you are selecting depth from another node with dimensioning tool', 'role_edit', NULL, NULL, NULL, NULL);
INSERT INTO audit_cat_param_user VALUES ('cad_tools_base_layer_vdefault', 'config', 'Selected layer will be the only one which allow snapping with CAD tools', 'role_edit', NULL, NULL, NULL, NULL);



INSERT INTO audit_cat_param_user VALUES ('inp_options_report_start_time', 'epaoptions', NULL, 'role_epa', NULL, 'REPORT_START_TIME', 'inp_options_report_start_time:', NULL, NULL, true, 1, 16, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, '00:00:00', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_min_slope', 'epaoptions', NULL, 'role_epa', NULL, 'MIN_SLOPE', 'inp_options_min_slope:', NULL, NULL, true, 1, 29, 'ud', NULL, NULL, NULL, NULL, NULL, 'float', 'linetext', true, NULL, '0.00', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_dry_step', 'epaoptions', NULL, 'role_epa', NULL, 'DRY_STEP', 'inp_options_dry_step:', NULL, NULL, true, 1, 22, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, '01:00:00', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_routing_step', 'epaoptions', NULL, 'role_epa', NULL, 'ROUTING_STEP', 'inp_options_routing_step:', NULL, NULL, true, 1, 23, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, '00:00:02', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_rtc_period_id', 'epaoptions', NULL, 'role_epa', NULL, 'RTC_PERIOD_ID', 'inp_options_rtc_period_id:', NULL, NULL, true, 1, 36, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, NULL, 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_tempdir', 'epaoptions', NULL, 'role_epa', NULL, 'TEMPDIR', 'inp_options_tempdir:', NULL, NULL, true, 1, 31, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, NULL, 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_wet_step', 'epaoptions', NULL, 'role_epa', NULL, 'WET_STEP', 'inp_options_wet_step:', NULL, NULL, true, 1, 21, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, '00:05:00', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_links', 'epaoptions', NULL, 'role_epa', NULL, 'LINKS', 'inp_report_links:', NULL, NULL, true, 1, NULL, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, 'ALL', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_nodes', 'epaoptions', NULL, 'role_epa', NULL, 'NODES', 'inp_report_nodes:', NULL, NULL, true, 1, 6, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, 'ALL', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_subcatchments', 'epaoptions', NULL, 'role_epa', NULL, 'SUBCATCHMENTS', 'inp_report_subcatchments:', NULL, NULL, true, 1, 5, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, 'ALL', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_input', 'epaoptions', NULL, 'role_epa', NULL, 'INPUT', 'inp_report_input:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 1, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'YES', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_lengthening_step', 'epaoptions', NULL, 'role_epa', NULL, 'LENGTHENING_STEP', 'inp_options_lengthening_step:', NULL, NULL, true, 1, 24, 'ud', NULL, NULL, NULL, NULL, NULL, 'float', 'linetext', true, NULL, 'demo', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_continuity', 'epaoptions', NULL, 'role_epa', NULL, 'CONTINUITY', 'inp_report_continuity:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 2, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'YES', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_flowstats', 'epaoptions', NULL, 'role_epa', NULL, 'FLOWSTATS', 'inp_report_flowstats:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 3, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'YES', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_report_controls', 'epaoptions', NULL, 'role_epa', NULL, 'CONTROLS', 'inp_report_controls:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 4, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'YES', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_end_date', 'epaoptions', NULL, 'role_epa', NULL, 'END_DATE', 'inp_options_end_date:', NULL, NULL, true, 1, 13, 'ud', NULL, NULL, NULL, NULL, NULL, 'date', 'datetime', true, NULL, '01/02/2017', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_normal_flow_limited', 'epaoptions', NULL, 'role_epa', NULL, 'NORMAL_FLOW_LIMITED', 'inp_options_normal_flow_limited:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_options_nfl''', NULL, true, 1, 27, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'BOTH', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_ignore_rainfall', 'epaoptions', NULL, 'role_epa', NULL, 'IGNORE_RAINFALL', 'inp_options_ignore_rainfall:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 5, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'NO', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_ignore_routing', 'epaoptions', NULL, 'role_epa', NULL, 'IGNORE_ROUTING', 'inp_options_ignore_routing:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 8, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'NO', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_skip_steady_state', 'epaoptions', NULL, 'role_epa', NULL, 'SKIP_STEADY_STATE', 'inp_options_skip_steady_state:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 10, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'NO', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_inertial_damping', 'epaoptions', NULL, 'role_epa', NULL, 'INERTIAL_DAMPING', 'inp_options_inertial_damping:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_options_id''', NULL, true, 1, 26, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'NONE', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_end_time', 'epaoptions', NULL, 'role_epa', NULL, 'END_TIME', 'inp_options_end_time:', NULL, NULL, true, 1, 14, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, '00:00:00', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_report_step', 'epaoptions', NULL, 'role_epa', NULL, 'REPORT_STEP', 'inp_options_report_step:', NULL, NULL, true, 1, 20, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, '00:05:00', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_start_time', 'epaoptions', NULL, 'role_epa', NULL, 'START_TIME', 'inp_options_start_time:', NULL, NULL, true, 1, 12, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, '00:00:00', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_sweep_end', 'epaoptions', NULL, 'role_epa', NULL, 'SWEEP_END', 'inp_options_sweep_end:', NULL, NULL, true, 1, 18, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, '12/31', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_sweep_start', 'epaoptions', NULL, 'role_epa', NULL, 'SWEEP_START', 'inp_options_sweep_start:', NULL, NULL, true, 1, 17, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'linetext', true, NULL, '01/01', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_dry_days', 'epaoptions', NULL, 'role_epa', NULL, 'DRY_DAYS', 'inp_options_dry_days:', NULL, NULL, true, 1, 19, 'ud', NULL, NULL, NULL, NULL, NULL, 'integer', 'linetext', true, NULL, '10', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_start_date', 'epaoptions', NULL, 'role_epa', NULL, 'START_DATE', 'inp_options_start_date:', NULL, NULL, true, 1, 11, 'ud', NULL, NULL, NULL, NULL, NULL, 'date', 'datetime', true, NULL, '01/01/2017', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_report_start_date', 'epaoptions', NULL, 'role_epa', NULL, 'REPORT_START_DATE', 'inp_options_report_start_date:', NULL, NULL, true, 1, 15, 'ud', NULL, NULL, NULL, NULL, NULL, 'date', 'datetime', true, NULL, '01/01/2017', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_variable_step', 'epaoptions', NULL, 'role_epa', NULL, 'VARIABLE_STEP', 'inp_options_variable_step:', NULL, NULL, true, 1, 25, 'ud', NULL, NULL, NULL, NULL, NULL, 'float', 'linetext', true, NULL, NULL, 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_min_surfarea', 'epaoptions', NULL, 'role_epa', NULL, 'MIN_SURFAREA', 'inp_options_min_surfarea:', NULL, NULL, true, 1, 28, 'ud', NULL, NULL, NULL, NULL, NULL, 'float', 'linetext', true, NULL, '0.00', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_head_tolerance', 'epaoptions', NULL, 'role_epa', NULL, 'HEAD_TOLERANCE', 'inp_options_head_tolerance:', NULL, NULL, true, 1, 33, 'ud', NULL, NULL, NULL, NULL, NULL, 'float', 'linetext', true, NULL, '0.000', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_flow_units', 'epaoptions', NULL, 'role_epa', NULL, 'FLOW_UNITS', 'inp_options_flow_units:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_options_fu''', NULL, true, 1, 1, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'CMS', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_flow_routing', 'epaoptions', NULL, 'role_epa', NULL, 'FLOW_ROUTING', 'inp_options_flow_routing:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_options_fr''', NULL, true, 1, 2, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'DYNWAVE', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_link_offsets', 'epaoptions', NULL, 'role_epa', NULL, 'LINK_OFFSETS', 'inp_options_link_offsets:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_options_lo''', NULL, true, 1, 3, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'ELEVATION', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_force_main_equation', 'epaoptions', NULL, 'role_epa', NULL, 'FORCE_MAIN_EQUATION', 'inp_options_force_main_equation:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_options_fme''', NULL, true, 1, 4, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'H-W', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_ignore_snowmelt', 'epaoptions', NULL, 'role_epa', NULL, 'IGNORE_SNOWMELT', 'inp_options_ignore_snowmelt:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 6, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'NO', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_ignore_groundwater', 'epaoptions', NULL, 'role_epa', NULL, 'IGNORE_GROUNDWATER', 'inp_options_ignore_groundwater:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 7, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'NO', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_ignore_quality', 'epaoptions', NULL, 'role_epa', NULL, 'IGNORE_QUALITY', 'inp_options_ignore_quality:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 9, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'NO', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_allow_ponding', 'epaoptions', NULL, 'role_epa', NULL, 'ALLOW_PONDING', 'inp_options_allow_ponding:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_yesno''', NULL, true, 1, 30, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'YES', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_max_trials', 'epaoptions', NULL, 'role_epa', NULL, 'MAX_TRIALS', 'inp_options_max_trials:', NULL, NULL, true, 1, 32, 'ud', NULL, NULL, NULL, NULL, NULL, 'integer', 'linetext', true, NULL, '0', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_sys_flow_tol', 'epaoptions', NULL, 'role_epa', NULL, 'SYS_FLOW_TOL', 'inp_options_sys_flow_tol:', NULL, NULL, true, 1, 34, 'ud', NULL, NULL, NULL, NULL, NULL, 'integer', 'linetext', true, NULL, '5', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_lat_flow_tol', 'epaoptions', NULL, 'role_epa', NULL, 'LAT_FLOW_TOL', 'inp_options_lat_flow_tol:', NULL, NULL, true, 1, 35, 'ud', NULL, NULL, NULL, NULL, NULL, 'integer', 'linetext', true, NULL, '5', 'gw_1', NULL);
INSERT INTO audit_cat_param_user VALUES ('inp_options_infiltration', 'epaoptions', NULL, 'role_epa', NULL, 'INFILTRATION', 'inp_options_infiltration:', 'SELECT idval as id, idval FROM inp_typevalue WHERE typevalue = ''inp_value_options_in''', NULL, true, 1, 37, 'ud', NULL, NULL, NULL, NULL, NULL, 'string', 'combo', true, NULL, 'HORTON', 'gw_1', NULL);


/*

-- example on 31107/utils/dml
UPDATE audit_cat_param_user SET     WHERE parameter='arccat_vdefault', 'config', NULL, 'role_edit', NULL, 'Arc catalog:', 'SELECT cat_arc.id AS id, cat_arc.id as idval FROM cat_arc WHERE id IS NOT NULL', NULL, true, 10, 2, 'ud', false, NULL, 'arccat_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='nodecat_vdefault', 'config', NULL, 'role_edit', NULL, 'Node catalog:', 'SELECT cat_node.id AS id, cat_node.id as idval FROM cat_node WHERE id IS NOT NULL', NULL, true, 10, 2, 'ud', false, NULL, 'nodecat_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='connecat_vdefault', 'config', NULL, 'role_edit', NULL, 'Connec catalog:', 'SELECT cat_connec.id AS id, cat_connec.id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, true, 10, 3, 'ud', false, NULL, 'connecat_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);
UPDATE audit_cat_param_user SET     WHERE parameter='gratecat_vdefault', 'config', NULL, 'role_edit', NULL, 'Grate catalog:', 'SELECT id AS id, id AS idval FROM connec_type WHERE id IS NOT NULL', NULL, true, 10, 4, 'ud', false, NULL, NULL, NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL);

*/


UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_divider';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_evap';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_orifice';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_outfall';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_outlet';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_pattern';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_divider';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_raingage';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_divider';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_storage';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_temp';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_timeseries';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_allnone';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_buildup';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_catarc';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_curve';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_files_actio';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_files_type';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_inflows';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_lidcontrol';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_mapunits';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_options_fme';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_options_fr';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_options_fu';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_options_id';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_options_in';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_options_lo';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_options_nfl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_orifice';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_pollutants';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_raingage';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_routeto';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_status';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_timserid';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_treatment';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_washoff';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_weirs';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_yesno';


UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_adjustments';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_aquifer';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_backdrop';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_buildup';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_conduit_cu';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_conduit_no';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_conduit_xs';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_controls';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_coverages';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_curve';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_divider_cu';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_divider_ov';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_divider_tb';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_divider_wr';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_dwf_flow';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_dwf_load';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_files';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_groundwater';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_infiltration_cu';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_infiltration_gr';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_infiltration_ho';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_inflows_flow';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_inflows_load';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_junction';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_label';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_landuses';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_lidusage';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_loadings';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_losses';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_mapdim';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_mapunits';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_options';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_orifice';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_outfall_fi';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_outfall_fr';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_outfall_nm';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_outfall_ti';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_outfall_ts';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_outlet_fcd';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_outlet_fch';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_outlet_tbd';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_outlet_tbh';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_pollutant';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_project_id';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_pump';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_rdii';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_report';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_rgage_fl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_rgage_ts';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_storage_fc';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_storage_tb';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_subcatch';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_temp_sn';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_temp_wf';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_temp_wf';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_timser_abs';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_timser_rel';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_timser_fl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_transects';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_treatment';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_vertice';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_washoff';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='v_inp_weir';


-- ----------------------------
-- Records of inp_typevalue
-- ----------------------------
 
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_raingage', 'TIMESERIES_RAIN', 'TIMESERIES', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_temp', 'TIMESERIES_TEMP', 'TIMESERIES', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_timeseries', 'FILE_TIME', 'FILE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_temp', 'FILE_TEMP', 'FILE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_temp', 'FILE_WINDSP', 'FILE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_temp', 'MONTHLY_WINDSP', 'MONTHLY', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_temp', 'SNOWMELT', 'SNOWMELT', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_temp', 'ADC PERVIOUS', 'ADC PERVIOUS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_temp', 'ADC IMPERVIOUS', 'IMPERVIOUS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_pattern', 'MONTHLY_PATTERN', 'MONTHLY', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_evap', 'FILE_EVAP', 'FILE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_storage', 'TABULAR_STORAGE', 'TABULAR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_divider', 'TABULAR_DIVIDER', 'TABULAR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_inflows', 'CONCEN_INFLOWS', 'CONCEN', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_evap', 'TIMESERIES_EVAP', 'TIMESERIES', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_outfall', 'TIMESERIES_OUTFALL', 'TIMESERIES', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_evap', 'MONTHLY_EVAP', 'MONTHLY', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_evap', 'TEMPERATURE_EVAP', 'TEMPERATURE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_outfall', 'TIDAL_OUTFALL', 'TIDAL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_raingage', 'FILE_RAIN', 'FILE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_buildup', 'EXP_BUILDUP', 'EXP', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_buildup', 'EXT_BUILDUP', 'EXT', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'STORAGE_CURVE', 'STORAGE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'TIDAL_CURVE', 'TIDAL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_divider', 'CUTOFF', 'CUTOFF', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_divider', 'OVERFLOW', 'OVERFLOW', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_divider', 'WEIR', 'WEIR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_evap', 'CONSTANT', 'CONSTANT', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_evap', 'RECOVERY', 'RECOVERY', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_orifice', 'BOTTOM', 'BOTTOM', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_orifice', 'SIDE', 'SIDE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_outfall', 'FIXED', 'FIXED', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_outfall', 'FREE', 'FREE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_outfall', 'NORMAL', 'NORMAL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_outlet', 'FUNCTIONAL/DEPTH', 'FUNCTIONAL/DEPTH', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_outlet', 'FUNCTIONAL/HEAD', 'FUNCTIONAL/HEAD', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_outlet', 'TABULAR/DEPTH', 'TABULAR/DEPTH', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_outlet', 'TABULAR/HEAD', 'TABULAR/HEAD', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_pattern', 'DAILY', 'DAILY', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_pattern', 'HOURLY', 'HOURLY', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_pattern', 'WEEKEND', 'WEEKEND', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_storage', 'FUNCTIONAL', 'FUNCTIONAL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_timeseries', 'ABSOLUTE', 'ABSOLUTE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_typevalue_timeseries', 'RELATIVE', 'RELATIVE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_allnone', 'ALL', 'ALL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_allnone', 'NONE', 'NONE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_buildup', 'POW', 'POW', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_buildup', 'SAT', 'SAT', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'CIRCULAR', 'CIRCULAR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'FILLED_CIRCULAR', 'FILLED_CIRCULAR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'RECT_CLOSED', 'RECT_CLOSED', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'RECT_OPEN', 'RECT_OPEN', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'TRAPEZOIDAL', 'TRAPEZOIDAL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'TRIANGULAR', 'TRIANGULAR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'HORIZ_ELLIPSE', 'HORIZ_ELLIPSE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'ARCH', 'ARCH', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'PARABOLIC', 'PARABOLIC', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'POWER', 'POWER', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'RECT_TRIANGULAR', 'RECT_TRIANGULAR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'RECT_ROUND', 'RECT_ROUND', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'MODBASKETHANDLE', 'MODBASKETHANDLE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'EGG', 'EGG', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'HORSESHOE', 'HORSESHOE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'SEMIELLIPTICAL', 'SEMIELLIPTICAL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'BASKETHANDLE', 'BASKETHANDLE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'SEMICIRCULAR', 'SEMICIRCULAR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'IRREGULAR', 'IRREGULAR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'CUSTOM', 'CUSTOM', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'DUMMY', 'DUMMY', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'FORCE_MAIN', 'FORCE_MAIN', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_catarc', 'VIRTUAL', 'VIRTUAL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'CONTROL', 'CONTROL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'DIVERSION', 'DIVERSION', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'PUMP1', 'PUMP1', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'PUMP2', 'PUMP2', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'PUMP3', 'PUMP3', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'PUMP4', 'PUMP4', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'RATING', 'RATING', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_curve', 'SHAPE', 'SHAPE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_files_actio', 'SAVE', 'SAVE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_files_actio', 'USE', 'USE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_files_type', 'HOTSTART', 'HOTSTART', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_files_type', 'INFLOWS', 'INFLOWS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_files_type', 'OUTFLOWS', 'OUTFLOWS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_files_type', 'RAINFALL', 'RAINFALL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_files_type', 'RDII', 'RDII', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_files_type', 'RUNOFF', 'RUNOFF', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_inflows', 'MASS', 'MASS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'DRAIN', 'DRAIN', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'PAVEMENT', 'PAVEMENT', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'SOIL', 'SOIL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'BC', 'BC', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'PP', 'PP', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'IT', 'IT', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'RB', 'RB', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'VS', 'VS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'GR', 'GR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'DRAINMAT', 'DRAINMAT', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fme', 'D-W', 'D-W', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fme', 'H-W', 'H-W', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fr', 'DYNWAVE', 'DYNWAVE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fr', 'KINWAVE', 'KINWAVE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fr', 'STEADY', 'STEADY', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fu', 'CFS', 'CFS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fu', 'CMS', 'CMS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fu', 'GPM', 'GPM', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fu', 'LPS', 'LPS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fu', 'MGD', 'MGD', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_fu', 'MLD', 'MLD', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_id', 'FULL', 'FULL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_id', 'PARTIAL', 'PARTIAL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_in', 'CURVE_NUMBER', 'CURVE_NUMBER', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_in', 'GREEN_AMPT', 'GREEN_AMPT', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_in', 'HORTON', 'HORTON', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_in', 'MODIFIED_HORTON', 'MODIFIED_HORTON', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_lo', 'DEPTH', 'DEPTH', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_lo', 'ELEVATION', 'ELEVATION', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_nfl', 'BOTH', 'BOTH', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_nfl', 'FROUD', 'FROUD', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_nfl', 'SLOPE', 'SLOPE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_pollutants', '#/L', '#/L', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_pollutants', 'MG/L', 'MG/L', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_pollutants', 'UG/L', 'UG/L', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_raingage', 'CUMULATIVE', 'CUMULATIVE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_raingage', 'INTENSITY', 'INTENSITY', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_raingage', 'VOLUME', 'VOLUME', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_routeto', 'OUTLET', 'OUTLET', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_routeto', 'IMPERVIOUS', 'IMPERVIOUS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_routeto', 'PERVIOUS', 'PERVIOUS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_status', 'ON', 'ON', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_status', 'OFF', 'OFF', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_timserid', 'Evaporation', 'Evaporation', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_timserid', 'Inflow_Hydrograph', 'Inflow_Hydrograph', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_timserid', 'Inflow_Pollutograph', 'Inflow_Pollutograph', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_timserid', 'Rainfall', 'Rainfall', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_treatment', 'RATE', 'RATE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_treatment', 'REMOVAL', 'REMOVAL', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_washoff', 'EMC', 'EMC', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_washoff', 'RC', 'RC', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_yesno', 'NO', 'NO', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_yesno', 'YES', 'YES', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_weirs', 'V-NOTCH', 'V-NOTCH', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_weirs', 'SIDEFLOW', 'SIDEFLOW', 'RECT_OPEN');
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_weirs', 'TRANSVERSE', 'TRANSVERSE', 'RECT_OPEN');
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_orifice', 'RECT-CLOSED_ORIFICE', 'RECT-CLOSED', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_orifice', 'CIRCULAR_ORIFICE', 'CIRCULAR', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_treatment', 'CONCEN_TREAT', 'CONCEN', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_mapunits', 'NONE_MAP', 'NONE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_options_id', 'NONE_OPTION', 'NONE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_weirs', 'TRAPEZOIDAL_WEIR', 'TRAPEZOIDAL', 'TRAPEZOIDAL');
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'STORAGE_LID', 'STORAGE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_lidcontrol', 'SURFACE_LID', 'SURFACE', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_timserid', 'Temperature_time', 'Temperature', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_washoff', 'EXP_WASHOFF', 'EXP', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_mapunits', 'DEGREES', 'DEGREES', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_mapunits', 'FEET', 'FEET', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_value_mapunits', 'METERS', 'METERS', NULL);

-----------------------
-- Records of sys_csv2pg_config
	-----------------------

INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (2, 10, 'vi_options', '[OPTIONS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (3, 10, 'vi_report', '[REPORT]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (5, 10, 'vi_evaporation', '[EVAPORATION]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (6, 10, 'vi_raingages', '[RAINGAGES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (8, 10, 'vi_subcatchments', '[SUBCATCHMENTS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (10, 10, 'vi_subareas', '[SUBAREAS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (9, 10, 'vi_infiltration', '[INFILTRATION]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (14, 10, 'vi_snowpacks', '[SNOWPACKS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (15, 10, 'vi_junction', '[JUNCTIONS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (19, 10, 'vi_conduits', '[CONDUITS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (24, 10, 'vi_xsections', '[XSECTIONS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (25, 10, 'vi_losses', '[LOSSES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (27, 10, 'vi_controls', '[CONTROLS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (28, 10, 'vi_pollutants', '[POLLUTANTS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (29, 10, 'vi_landuses', '[LANDUSES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (30, 10, 'vi_coverages', '[COVERAGES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (31, 10, 'vi_buildup', '[BUILDUP]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (32, 10, 'vi_washoff', '[WASHOFF]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (33, 10, 'vi_treatment', '[TREATMENT]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (34, 10, 'vi_dwf', '[DWF]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (35, 10, 'vi_patterns', '[PATTERNS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (37, 10, 'vi_loadings', '[LOADINGS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (41, 10, 'vi_timeseries', '[TIMESERIES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (42, 10, 'vi_lid_controls', '[LID_CONTROLS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (43, 10, 'vi_lid_usage', '[LID_USAGE]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (71, 11, 'rpt_warning_summary', 'WARNING',NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (1, 10, 'vi_title', '[TITLE]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (4, 10, 'vi_files', '[FILES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (7, 10, 'vi_temperature', '[TEMPERATURE]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (11, 10, 'vi_aquifers', '[AQUIFERS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (12, 10, 'vi_groundwater', '[GROUNDWATER]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (13, 10, 'vi_gwf', '[GWF]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (16, 10, 'vi_outfalls', '[OUTFALLS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (17, 10, 'vi_dividers', '[DIVIDERS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (18, 10, 'vi_storage', '[STORAGE]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (20, 10, 'vi_pumps', '[PUMPS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (21, 10, 'vi_orifices', '[ORIFICES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (22, 10, 'vi_weirs', '[WEIRS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (23, 10, 'vi_outlets', '[OUTLETS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (26, 10, 'vi_transects', '[TRANSECTS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (36, 10, 'vi_inflows', '[INFLOWS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (38, 10, 'vi_rdii', '[RDII]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (39, 10, 'vi_hydrographs', '[HYDROGRAPHS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (40, 10, 'vi_curves', '[CURVES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (45, 10, 'vi_map', '[MAP]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (47, 10, 'vi_symbols', '[SYMBOLS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (69, 11, 'rpt_runoff_quant', 'Runoff Quantity', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (70, 11, 'rpt_cat_result', 'Analysis Options', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (44, 10, 'vi_adjustments', '[ADJUSTMENTS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (46, 10, 'vi_backdrop', '[BACKDROP]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (48, 10, 'vi_labels', '[LABELS]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (49, 10, 'vi_coordinates', '[COORDINATES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (50, 10, 'vi_vertices', '[VERTICES]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (51, 10, 'vi_polygons', '[Polygons]',12);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (52, 11, 'rpt_pumping_sum', 'Pumping Summary', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (53, 11, 'rpt_arcflow_sum', 'Link Flow', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (54, 11, 'rpt_flowrouting_cont', 'Flow Routing', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (55, 11, 'rpt_storagevol_sum', 'Storage Volume', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (56, 11, 'rpt_subcathrunoff_sum', 'Subcatchment Runoff', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (57, 11, 'rpt_outfallload_sum', 'Outfall Loading', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (58, 11, 'rpt_condsurcharge_sum', 'Conduit Surcharge', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (59, 11, 'rpt_flowclass_sum', 'Flow Classification', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (60, 11, 'rpt_nodeflooding_sum', 'Node Flooding', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (61, 11, 'rpt_nodeinflow_sum', 'Node Inflow', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (62, 11, 'rpt_nodesurcharge_sum', 'Node Surcharge', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (63, 11, 'rpt_nodedepth_sum', 'Node Depth', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (65, 11, 'rpt_routing_timestep', 'Routing Time', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (66, 11, 'rpt_high_flowinest_ind', 'Highest Flow', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (67, 11, 'rpt_timestep_critelem', 'Time-Step Critical', NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (68, 11, 'rpt_high_conterrors', 'Highest Continuity', NULL);

--2019/02/08
DELETE FROM audit_cat_param_user WHERE id='virtual_line_vdefault';
DELETE FROM audit_cat_param_user WHERE id='virtual_point_vdefault';
DELETE FROM audit_cat_param_user WHERE id='virtual_polygon_vdefault';
DELETE FROM audit_cat_param_user WHERE id='qgis_template_folder_path';


DELETE FROM config_param_user WHERE parameter='virtual_line_vdefault';
DELETE FROM config_param_user WHERE parameter='virtual_point_vdefault';
DELETE FROM config_param_user WHERE parameter='virtual_polygon_vdefault';
DELETE FROM config_param_user WHERE parameter='qgis_template_folder_path';


-- 2019/02/12
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('om_mincut_valvestat_using_valveunaccess', 'FALSE', 'Boolean', 'Mincut', 'Variable to enable/disable the possibility to use valve unaccess button to open valves with closed status (WS)');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('om_mincut_debug', 'FALSE', 'Boolean', 'Mincut', 'Variable to enable/disable the debug messages of mincut (WS)');
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('epa_units_factor', 
'{"CFS":0, "GPM":0, "MGD":0, "CMS":1, "LPS":1000, "MLD":86.4}', 'json', 'Epa', 'Conversion factors of CRM flows in function of EPA units choosed by user');


