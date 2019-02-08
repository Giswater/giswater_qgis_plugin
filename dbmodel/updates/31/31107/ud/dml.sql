/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 20110/02/05

INSERT INTO audit_cat_param_user VALUES ('dim_tooltip', NULL, 'If true, tooltip appears when you''re selecting depth from another node with dimensioning tool', 'role_edit', NULL, NULL, NULL, NULL, 'boolean');
INSERT INTO audit_cat_param_user VALUES ('cad_tools_base_layer_vdefault', NULL, 'Selected layer will be the only one which allow snapping with CAD tools', 'role_edit', NULL, NULL, NULL, NULL, 'text');

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
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, reverse_pg2csvcat_id) VALUES (110, 10, 'vi_conduits', '[CONDUITS]',12);
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


