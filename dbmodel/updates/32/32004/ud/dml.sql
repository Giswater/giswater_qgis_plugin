/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_table SET isdeprecated = true WHERE id='vi_title';


INSERT INTO audit_cat_table VALUES ('inp_hydrograph_id');---------------------------TODO


DELETE FROM inp_typevalue WHERE id='EXT_BUILDUP';
DELETE FROM inp_typevalue WHERE id='CONCEN_TREAT';


DELETE FROM inp_typevalue WHERE id='TIMESERIES_OUTFALL';
INSERT INTO inp_typevalue VALUES ('inp_typevalue_evap', 'DRY_ONLY', 'DRY_ONLY');
DELETE FROM inp_typevalue WHERE id='FILE_WINDSP';
INSERT INTO inp_typevalue VALUES ('inp_typevalue_temp', 'WINDSPEED', 'WINDSPEED');
DELETE FROM inp_typevalue WHERE id='FILE_TEMP';
UPDATE inp_typevalue SET id='ADC', idval='ADC' WHERE id='ADC IMPERVIOUS';
DELETE FROM inp_typevalue WHERE id='ADC PERVIOUS';
DELETE FROM inp_typevalue wHERE id='WINDSPEED FILE';


UPDATE audit_cat_param_user SET layout_id=3, layout_name='grl_hyd_3' WHERE layout_id=11;
UPDATE audit_cat_param_user SET layout_id=4, layout_name='grl_hyd_4' WHERE layout_id=12;
UPDATE audit_cat_param_user SET layout_id=4, layout_order=4,layout_name='grl_hyd_4' WHERE id='inp_options_dry_days';
UPDATE audit_cat_param_user SET layout_id=3, layout_order=5,layout_name='grl_hyd_3' WHERE id='inp_options_wet_step';
UPDATE audit_cat_param_user SET layout_id=4, layout_order=5,layout_name='grl_hyd_4' WHERE id='inp_options_dry_step';
UPDATE audit_cat_param_user SET layout_id=3, layout_order=6,layout_name='grl_hyd_3' WHERE id='inp_options_sweep_start';
UPDATE audit_cat_param_user SET layout_id=4, layout_order=6,layout_name='grl_hyd_4' WHERE id='inp_options_sweep_end';
UPDATE audit_cat_param_user SET vdefault='CURVE_NUMBER' WHERE id='inp_options_infiltration';

UPDATE audit_cat_param_user SET layout_id=13,layout_name='grl_date_13', widgettype='linetext', vdefault='00:00:00', placeholder='HH:MM:SS'  WHERE id='inp_options_start_time';

UPDATE audit_cat_param_user SET layout_id=13,layout_order=1,layout_name='grl_date_13' WHERE id='inp_options_routing_step';
UPDATE audit_cat_param_user SET layout_id=14,layout_order=1,layout_name='grl_date_14' WHERE id='inp_options_report_step';

UPDATE audit_cat_param_user SET layout_id=13,layout_order = 2, layout_name='grl_date_13', widgettype='linetext', vdefault='01/01/2017', placeholder='DD/MM/AAAA'  WHERE id='inp_options_start_date';
UPDATE audit_cat_param_user SET layout_id=14,layout_order = 2, layout_name='grl_date_14', widgettype='linetext', vdefault='00:00:00', placeholder='HH:MM:SS'  WHERE id='inp_options_start_time';

UPDATE audit_cat_param_user SET layout_id=13,layout_order = 3, layout_name='grl_date_13', widgettype='linetext', vdefault='01/01/2017', placeholder='DD/MM/AAAA' WHERE id='inp_options_end_date';
UPDATE audit_cat_param_user SET layout_id=14,layout_order = 3, layout_name='grl_date_14', widgettype='linetext', vdefault='03:00:00', placeholder='HH:MM:SS'  WHERE id='inp_options_end_time';

UPDATE audit_cat_param_user SET layout_id=13,layout_order = 4, layout_name='grl_date_13', widgettype='linetext', vdefault='01/01/2017', placeholder='DD/MM/AAAA' WHERE id='inp_options_report_start_date';
UPDATE audit_cat_param_user SET layout_id=14,layout_order = 4, layout_name='grl_date_14', widgettype='linetext', vdefault='00:00:00', placeholder='HH:MM:SS' WHERE id='inp_options_report_start_time';


UPDATE audit_cat_param_user SET layout_id=2,layout_order=90, layout_name='grl_general_2', isenabled=true, ismandatory=true WHERE id='inp_options_tempdir';

UPDATE audit_cat_param_user SET label = 'Timestep detailed nodes:', placeholder='ALL / node1 node2 node3 node4' WHERE id='inp_report_nodes';
UPDATE audit_cat_param_user SET label = 'Timestep detailed links:', placeholder='ALL / link1 link2 link3 link4' WHERE id='inp_report_links';
UPDATE audit_cat_param_user SET label = 'Timestep detailed subcatchments:',placeholder='ALL / subc1 subc2 subc3 subc4' WHERE id='inp_report_subcatchments';


INSERT INTO audit_cat_param_user VALUES ('epaversion', 'epaoptions', 'Version of SWMM. Hard coded variable. Only enabled version is SWMM-EN 5.0.022', 'role_epa', NULL, NULL, 'SWMM version:', NULL, NULL, false, NULL, NULL, 'ud', false, NULL, NULL, NULL, false, 'string', 'combo', true, null, '5.0.022', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);

UPDATE audit_cat_param_user SET epaversion='{"from":"5.0.022", "to":null,"language":"english"}' where formname='epaoptions';


UPDATE audit_cat_param_user SET isenabled=FALSE, ismandatory=FALSE WHERE id='inp_options_rtc_period_id';
UPDATE audit_cat_param_user SET epaversion='{"from":"5.1.000", "to":null,"language":"english"}' where id ='inp_options_max_trials';
UPDATE audit_cat_param_user SET epaversion='{"from":"5.1.000", "to":null,"language":"english"}' where id ='inp_options_lat_flow_tol';
UPDATE audit_cat_param_user SET epaversion='{"from":"5.1.000", "to":null,"language":"english"}' where id ='inp_options_head_tolerance';
UPDATE audit_cat_param_user SET epaversion='{"from":"5.1.000", "to":null,"language":"english"}' where id ='inp_options_sys_flow_tol';

UPDATE audit_cat_param_user SET project_type='ud' where id ='epa_conduit_q0_vdefault';
UPDATE audit_cat_param_user SET project_type='ud' where id ='epa_outfall_type_vdefault';
UPDATE audit_cat_param_user SET project_type='ud' where id ='epa_junction_y0_vdefault';
UPDATE audit_cat_param_user SET project_type='ud' where id ='epa_rgage_scf_vdefault';


DELETE FROM sys_csv2pg_config;

INSERT INTO sys_csv2pg_config VALUES (2, 10, 'vi_options', '[OPTIONS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (3, 10, 'vi_report', '[REPORT]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (5, 10, 'vi_evaporation', '[EVAPORATION]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (6, 10, 'vi_raingages', '[RAINGAGES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (8, 10, 'vi_subcatchments', '[SUBCATCHMENTS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (10, 10, 'vi_subareas', '[SUBAREAS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (9, 10, 'vi_infiltration', '[INFILTRATION]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (14, 10, 'vi_snowpacks', '[SNOWPACKS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (15, 10, 'vi_junction', '[JUNCTIONS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (19, 10, 'vi_conduits', '[CONDUITS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (24, 10, 'vi_xsections', '[XSECTIONS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (25, 10, 'vi_losses', '[LOSSES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (27, 10, 'vi_controls', '[CONTROLS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (28, 10, 'vi_pollutants', '[POLLUTANTS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (29, 10, 'vi_landuses', '[LANDUSES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (30, 10, 'vi_coverages', '[COVERAGES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (31, 10, 'vi_buildup', '[BUILDUP]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (32, 10, 'vi_washoff', '[WASHOFF]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (33, 10, 'vi_treatment', '[TREATMENT]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (34, 10, 'vi_dwf', '[DWF]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (35, 10, 'vi_patterns', '[PATTERNS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (37, 10, 'vi_loadings', '[LOADINGS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (41, 10, 'vi_timeseries', '[TIMESERIES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (42, 10, 'vi_lid_controls', '[LID_CONTROLS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (43, 10, 'vi_lid_usage', '[LID_USAGE]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (51, 10, 'vi_polygons', '[Polygons]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (52, 11, 'rpt_pumping_sum', 'Pumping Summary', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (53, 11, 'rpt_arcflow_sum', 'Link Flow', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (54, 11, 'rpt_flowrouting_cont', 'Flow Routing', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (55, 11, 'rpt_storagevol_sum', 'Storage Volume', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (57, 11, 'rpt_outfallload_sum', 'Outfall Loading', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (58, 11, 'rpt_condsurcharge_sum', 'Conduit Surcharge', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (59, 11, 'rpt_flowclass_sum', 'Flow Classification', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (60, 11, 'rpt_nodeflooding_sum', 'Node Flooding', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (61, 11, 'rpt_nodeinflow_sum', 'Node Inflow', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (62, 11, 'rpt_nodesurcharge_sum', 'Node Surcharge', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (56, 11, 'rpt_subcathrunoff_sum', 'Subcatchment Runoff', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (72, 11, 'rpt_summary_subcatchment', 'Subcathment Summary', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (73, 11, 'rpt_summary_node', 'Node Summary', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (74, 11, 'rpt_summary_arc', 'Link Summary', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (75, 11, 'rpt_summary_crossection', 'Cross Section', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (71, 11, 'rpt_cat_result', 'Element Count', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (76, 11, 'rpt_subcatchment', 'Subcatchment Results', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (4, 10, 'vi_files', '[FILES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (7, 10, 'vi_temperature', '[TEMPERATURE]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (11, 10, 'vi_aquifers', '[AQUIFERS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (12, 10, 'vi_groundwater', '[GROUNDWATER]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (16, 10, 'vi_outfalls', '[OUTFALLS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (17, 10, 'vi_dividers', '[DIVIDERS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (18, 10, 'vi_storage', '[STORAGE]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (20, 10, 'vi_pumps', '[PUMPS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (21, 10, 'vi_orifices', '[ORIFICES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (22, 10, 'vi_weirs', '[WEIRS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (23, 10, 'vi_outlets', '[OUTLETS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (26, 10, 'vi_transects', '[TRANSECTS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (36, 10, 'vi_inflows', '[INFLOWS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (38, 10, 'vi_rdii', '[RDII]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (39, 10, 'vi_hydrographs', '[HYDROGRAPHS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (40, 10, 'vi_curves', '[CURVES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (45, 10, 'vi_map', '[MAP]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (47, 10, 'vi_symbols', '[SYMBOLS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (69, 11, 'rpt_runoff_quant', 'Runoff Quantity', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (70, 11, 'rpt_cat_result', 'Analysis Options', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (77, 11, 'rpt_node', 'Node Results', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (46, 10, 'vi_backdrop', '[BACKDROP]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (48, 10, 'vi_labels', '[LABELS]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (49, 10, 'vi_coordinates', '[COORDINATES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (50, 10, 'vi_vertices', '[VERTICES]', NULL, 12, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (78, 11, 'rpt_arc', 'Link Results', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (63, 11, 'rpt_nodedepth_sum', 'Node Depth', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (65, 11, 'rpt_routing_timestep', 'Routing Time', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (66, 11, 'rpt_high_flowinest_ind', 'Highest Flow', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (67, 11, 'rpt_timestep_critelem', 'Time-Step Critical', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (68, 11, 'rpt_high_conterrors', 'Highest Continuity', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (13, 10, 'vi_gwf', '[GWF]', NULL, 12, '{"from":"5.1", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (44, 10, 'vi_adjustments', '[ADJUSTMENTS]', NULL, 12, '{"from":"5.1", "to":null,"language":"english"}');
INSERT INTO sys_csv2pg_config VALUES (79, 11, 'rpt_warning_summary', 'WARNING', NULL, NULL, '{"from":"5.0.022", "to":null,"language":"english"}');




UPDATE inp_typevalue SET descript='TRIANGULAR' WHERE id='V-NOTCH';



