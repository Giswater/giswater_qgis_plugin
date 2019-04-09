INSERT INTO ud_sample.inp_adjustments (id, adj_type, value_1, value_2, value_3, value_4, value_5, value_6, value_7, value_8, value_9, value_10, value_11, value_12) VALUES ('2', 'EVAPORATION_ADEJ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_adjustments (id, adj_type, value_1, value_2, value_3, value_4, value_5, value_6, value_7, value_8, value_9, value_10, value_11, value_12) VALUES ('1', 'TEMPERATURE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO ud_sample.inp_aquifer (aquif_id, por, wp, fc, k, ks, ps, uef, led, gwr, be, wte, umc, pattern_id) VALUES ('aquifer01', 0.5000, 0.1500, 0.3000, 5.0000, 10.0000, 15.0000, 0.3500, 14.0000, 0.0020, 0.0000, 10.0000, 0.3000, 'patter01');


INSERT INTO ud_sample.inp_buildup_land_x_pol (landus_id, poll_id, funcb_type, c1, c2, c3, perunit) VALUES ('rural', 'SS', 'SAT', 0.0500, 1.0000, 5.0000, 'AREA');
INSERT INTO ud_sample.inp_buildup_land_x_pol (landus_id, poll_id, funcb_type, c1, c2, c3, perunit) VALUES ('urban', 'SS', 'SAT', 0.0500, 1.0000, 2.5000, 'AREA');


INSERT INTO ud_sample.inp_controls_x_arc (id, arc_id, text) VALUES (2, '201', 'IF TIME SIMULATION IS >3');
INSERT INTO ud_sample.inp_controls_x_arc (id, arc_id, text) VALUES (4, '201', 'THEN PUMP 2 OPEN');
INSERT INTO ud_sample.inp_controls_x_arc (id, arc_id, text) VALUES (6, '201', 'ELSE PUM 2 CLOSED');
INSERT INTO ud_sample.inp_controls_x_arc (id, arc_id, text) VALUES (7, '201', 'EVER: STATUS ON');


INSERT INTO ud_sample.inp_controls_x_node (id, node_id, text) VALUES (1, '101', 'IF TIME SIMULATION IS >3');
INSERT INTO ud_sample.inp_controls_x_node (id, node_id, text) VALUES (4, '101', 'THEN JUNCTION 101 IS OPEN');
INSERT INTO ud_sample.inp_controls_x_node (id, node_id, text) VALUES (5, '101', 'ELSE JUNCTION 101 IS CLOSED');
INSERT INTO ud_sample.inp_controls_x_node (id, node_id, text) VALUES (6, '101', 'EVER: STATUS ON ');



INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (8, 'EBAR-01', 0.000000, 17.500000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (9, 'EBAR-01', 10.000000, 17.500000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (1, 'PUMP-01', 10.000000, 0.016000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (2, 'PUMP-01', 20.000000, 0.015000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (3, 'PUMP-01', 30.000000, 0.013000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (4, 'PUMP-01', 40.000000, 0.008000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (14, 'EBAR-02', 0.000000, 15.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (15, 'EBAR-02', 10.000000, 15.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (10, 'PUMP-02', 10.000000, 0.045000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (11, 'PUMP-02', 20.000000, 0.038000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (12, 'PUMP-02', 30.000000, 0.035000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (13, 'PUMP-02', 40.000000, 0.033000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (16, 'C1_CONTROL', 1.000000, 1.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (17, 'C1_CONTROL', 2.000000, 2.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (18, 'C1_CONTROL', 3.000000, 3.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (19, 'C2_DIVERSION', 1.000000, 1.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (20, 'C2_DIVERSION', 2.000000, 2.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (21, 'C2_DIVERSION', 3.000000, 3.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (22, 'C3_PUMP', 1.000000, 1.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (23, 'C3_PUMP', 2.000000, 2.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (24, 'C3_PUMP', 3.000000, 3.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (25, 'C4_RATING', 1.000000, 1.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (26, 'C4_RATING', 2.000000, 2.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (27, 'C4_RATING', 3.000000, 3.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (28, 'C5_SHAPE', 1.000000, 1.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (29, 'C5_SHAPE', 2.000000, 2.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (30, 'C5_SHAPE', 3.000000, 3.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (31, 'C6_STORAGE', 1.000000, 1.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (32, 'C6_STORAGE', 2.000000, 2.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (33, 'C6_STORAGE', 3.000000, 3.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (34, 'C7_TIDAL', 1.000000, 1.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (35, 'C7_TIDAL', 2.000000, 2.000000);
INSERT INTO ud_sample.inp_curve (id, curve_id, x_value, y_value) VALUES (36, 'C7_TIDAL', 3.000000, 3.000000);



INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('PUMP-01', 'PUMP2');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('EBAR-01', 'STORAGE_CURVE');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('EBAR-02', 'STORAGE_CURVE');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('PUMP-02', 'PUMP2');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('C1_CONTROL', 'CONTROL');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('C2_DIVERSION', 'DIVERSION');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('C3_PUMP', 'PUMP1');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('C4_RATING', 'RATING');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('C5_SHAPE', 'SHAPE');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('C6_STORAGE', 'STORAGE_CURVE');
INSERT INTO ud_sample.inp_curve_id (id, curve_type) VALUES ('C7_TIDAL', 'TIDAL_CURVE');



INSERT INTO ud_sample.inp_divider (node_id, divider_type, arc_id, curve_id, qmin, ht, cd, y0, ysur, apond) VALUES ('129', 'TABULAR_DIVIDER', '201', 'C2_DIVERSION', NULL, NULL, NULL, 0.8982, 0.6767, 63.5941);
INSERT INTO ud_sample.inp_divider (node_id, divider_type, arc_id, curve_id, qmin, ht, cd, y0, ysur, apond) VALUES ('130', 'CUTOFF', '202', NULL, 1.000000, NULL, NULL, 0.1588, 0.7805, 79.9171);
INSERT INTO ud_sample.inp_divider (node_id, divider_type, arc_id, curve_id, qmin, ht, cd, y0, ysur, apond) VALUES ('131', 'WEIR', '203', NULL, 1.000000, 1.0000, 1.0000, 0.5573, 0.1130, 75.8022);
INSERT INTO ud_sample.inp_divider (node_id, divider_type, arc_id, curve_id, qmin, ht, cd, y0, ysur, apond) VALUES ('132', 'OVERFLOW', '204', NULL, NULL, NULL, NULL, 0.0345, 0.3384, 35.7010);


INSERT INTO ud_sample.inp_evaporation (evap_type, value) VALUES ('CONSTANT', '1');
INSERT INTO ud_sample.inp_evaporation (evap_type, value) VALUES ('TEMPERATURE_EVAP', NULL);
INSERT INTO ud_sample.inp_evaporation (evap_type, value) VALUES ('MONTHLY_EVAP', '1 0.5 2 4 2 5 4.3 2 2.3 2 1.2 3.4');
INSERT INTO ud_sample.inp_evaporation (evap_type, value) VALUES ('TIMESERIES_EVAP', 'T100-5m');
INSERT INTO ud_sample.inp_evaporation (evap_type, value) VALUES ('FILE_EVAP', 'fname');
INSERT INTO ud_sample.inp_evaporation (evap_type, value) VALUES ('RECOVERY', 'patten_01');


INSERT INTO ud_sample.inp_flwreg_orifice (id, node_id, to_arc, flwreg_id, flwreg_length, ori_type, "offset", cd, orate, flap, shape, geom1, geom2, geom3, geom4) VALUES (4, '40', '163', 5, 1.25, 'SIDE', 34.1250, 1.5000, 1.0000, 'YES', 'CIRCULAR', 0.8800, 0.0000, 0.0000, 0.0000);
INSERT INTO ud_sample.inp_flwreg_orifice (id, node_id, to_arc, flwreg_id, flwreg_length, ori_type, "offset", cd, orate, flap, shape, geom1, geom2, geom3, geom4) VALUES (7, '40', '163', 6, 0.98499999999999999, 'BOTTOM', 34.0080, 1.5000, 1.0000, 'YES', 'RECT-CLOSED', 0.7700, 0.6600, 0.0000, 0.0000);


INSERT INTO ud_sample.inp_flwreg_outlet (id, node_id, to_arc, flwreg_id, flwreg_length, outlet_type, "offset", curve_id, cd1, cd2, flap) VALUES (4, '40', '163', 3, 3.234, 'TABULAR/DEPTH', 33.9250, 'C1_CONTROL', NULL, NULL, NULL);
INSERT INTO ud_sample.inp_flwreg_outlet (id, node_id, to_arc, flwreg_id, flwreg_length, outlet_type, "offset", curve_id, cd1, cd2, flap) VALUES (6, '40', '163', 4, 1.234, 'TABULAR/HEAD', 33.9954, 'C1_CONTROL', NULL, NULL, NULL);
INSERT INTO ud_sample.inp_flwreg_outlet (id, node_id, to_arc, flwreg_id, flwreg_length, outlet_type, "offset", curve_id, cd1, cd2, flap) VALUES (1, '40', '163', 1, 1.254, 'FUNCTIONAL/DEPTH', 34.1255, NULL, 0.2500, 0.7481, 'YES');
INSERT INTO ud_sample.inp_flwreg_outlet (id, node_id, to_arc, flwreg_id, flwreg_length, outlet_type, "offset", curve_id, cd1, cd2, flap) VALUES (3, '40', '163', 2, 2.012, 'FUNCTIONAL/HEAD', 34.0244, NULL, 1.1520, 0.2517, NULL);


INSERT INTO ud_sample.inp_flwreg_pump (id, node_id, to_arc, flwreg_id, flwreg_length, curve_id, status, startup, shutoff) VALUES (2, '18828', '18964', 1, 1, 'PUMP-02', 'ON', 2.0000, 0.4000);
INSERT INTO ud_sample.inp_flwreg_pump (id, node_id, to_arc, flwreg_id, flwreg_length, curve_id, status, startup, shutoff) VALUES (3, '238', '245', 1, 1, 'PUMP-01', 'ON', 2.0000, 0.4000);
INSERT INTO ud_sample.inp_flwreg_pump (id, node_id, to_arc, flwreg_id, flwreg_length, curve_id, status, startup, shutoff) VALUES (4, '238', '245', 2, 1, 'PUMP-01', 'ON', 2.0000, 0.4000);
INSERT INTO ud_sample.inp_flwreg_pump (id, node_id, to_arc, flwreg_id, flwreg_length, curve_id, status, startup, shutoff) VALUES (7, '238', '245', 3, 1, 'PUMP-01', 'ON', 2.0000, 0.4000);


INSERT INTO ud_sample.inp_flwreg_weir (id, node_id, to_arc, flwreg_id, flwreg_length, weir_type, "offset", cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge) VALUES (1, '237', '242', 1, 0.5, 'TRANSVERSE', 16.3500, 1.5000, NULL, NULL, 'NO', 2.0000, 2.0000, 0.0000, 0.0000, NULL);
INSERT INTO ud_sample.inp_flwreg_weir (id, node_id, to_arc, flwreg_id, flwreg_length, weir_type, "offset", cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge) VALUES (2, '238', '244', 1, 1, 'SIDEFLOW', 29.0000, 1.5000, NULL, NULL, 'NO', 1.0000, 1.0000, 0.0000, 0.0000, NULL);
INSERT INTO ud_sample.inp_flwreg_weir (id, node_id, to_arc, flwreg_id, flwreg_length, weir_type, "offset", cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge) VALUES (3, '18828', '18969', 1, 0.5, 'TRAPEZOIDAL_WEIR', 17.1500, 1.5000, NULL, NULL, 'NO', 1.0000, 1.0000, 0.0000, 0.0000, NULL);
INSERT INTO ud_sample.inp_flwreg_weir (id, node_id, to_arc, flwreg_id, flwreg_length, weir_type, "offset", cd, ec, cd2, flap, geom1, geom2, geom3, geom4, surcharge) VALUES (11, '40', '163', 1, 2, 'V-NOTCH', 35.1020, 1.5000, NULL, NULL, 'YES', 1.5000, 1.2500, 0.0000, 0.0000, NULL);

INSERT INTO ud_sample.inp_groundwater (subc_id, aquif_id, node_id, surfel, a1, b1, a2, b2, a3, tw, h, fl_eq_lat, fl_eq_deep) VALUES ('S101', 'aquifer01', '101', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, '0', '0');
INSERT INTO ud_sample.inp_groundwater (subc_id, aquif_id, node_id, surfel, a1, b1, a2, b2, a3, tw, h, fl_eq_lat, fl_eq_deep) VALUES ('S102', 'aquifer01', '102', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, '0', '0');


INSERT INTO ud_sample.inp_hydrograph (hydro_id, text) VALUES (1, 'UH1 RG-01');
INSERT INTO ud_sample.inp_hydrograph (hydro_id, text) VALUES (2, 'UH1 JAN SHORT 1 1 1 ');
INSERT INTO ud_sample.inp_hydrograph (hydro_id, text) VALUES (3, 'UH1 ALL MEDIUM 1 1 1');


INSERT INTO ud_sample.inp_landuses (landus_id, sweepint, availab, lastsweep) VALUES ('rural', 0.0000, 0.0000, 0.0000);
INSERT INTO ud_sample.inp_landuses (landus_id, sweepint, availab, lastsweep) VALUES ('urban', 0.0000, 0.0000, 0.0000);


INSERT INTO ud_sample.inp_lid_control (id, lidco_id, lidco_type, value_2, value_3, value_4, value_5, value_6, value_7, value_8) VALUES (1, 'lid01', 'IT', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_lid_control (id, lidco_id, lidco_type, value_2, value_3, value_4, value_5, value_6, value_7, value_8) VALUES (4, 'lid01', 'DRAIN', 0.0000, 0.5000, 0.0000, 6.0000, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_lid_control (id, lidco_id, lidco_type, value_2, value_3, value_4, value_5, value_6, value_7, value_8) VALUES (2, 'lid01', 'SURFACE_LID', 0.0000, 0.0000, 0.1000, 1.0000, 5.0000, 3.0000, NULL);
INSERT INTO ud_sample.inp_lid_control (id, lidco_id, lidco_type, value_2, value_3, value_4, value_5, value_6, value_7, value_8) VALUES (3, 'lid01', 'SURFACE_LID', 12.0000, 0.7500, 0.0000, 6.0000, 5.0000, 3.0000, NULL);


INSERT INTO ud_sample.inp_lidusage_subc_x_lidco (subc_id, lidco_id, number, area, width, initsat, fromimp, toperv, rptfile) VALUES ('S104', 'lid01', 1, 0.010000, 10.0000, 0.0000, 0.0000, 0, '0');
INSERT INTO ud_sample.inp_lidusage_subc_x_lidco (subc_id, lidco_id, number, area, width, initsat, fromimp, toperv, rptfile) VALUES ('S105', 'lid01', 2, 0.020000, 5.0000, 1.0000, 0.0000, 0, '0');

INSERT INTO ud_sample.inp_loadings_pol_x_subc (poll_id, subc_id, ibuildup) VALUES ('SS', 'S101', 1.0000);
INSERT INTO ud_sample.inp_loadings_pol_x_subc (poll_id, subc_id, ibuildup) VALUES ('SS', 'S102', 2.0000);
INSERT INTO ud_sample.inp_loadings_pol_x_subc (poll_id, subc_id, ibuildup) VALUES ('SS', 'S107', 1.2500);


INSERT INTO ud_sample.inp_orifice (arc_id, node_id, ori_type, "offset", cd, orate, flap, shape, to_arc, geom1, geom2, geom3, geom4) VALUES ('158', NULL, 'SIDE', 2.0000, 1.0000, 1.0000, 'YES', 'CIRCULAR', NULL, 1.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO ud_sample.inp_orifice (arc_id, node_id, ori_type, "offset", cd, orate, flap, shape, to_arc, geom1, geom2, geom3, geom4) VALUES ('159', NULL, 'BOTTOM', 2.0000, 1.0000, 1.0000, 'NO', 'RECT_CLOSED', NULL, 1.0000, 2.0000, 0.0000, 0.0000);


INSERT INTO ud_sample.inp_outfall (node_id, outfall_type, stage, curve_id, timser_id, gate) VALUES ('127', 'TIDAL_OUTFALL', NULL, 'C7_TIDAL', NULL, 'YES');
INSERT INTO ud_sample.inp_outfall (node_id, outfall_type, stage, curve_id, timser_id, gate) VALUES ('128', 'FIXED', 225.0000, NULL, NULL, 'YES');
INSERT INTO ud_sample.inp_outfall (node_id, outfall_type, stage, curve_id, timser_id, gate) VALUES ('240', 'FREE', NULL, NULL, NULL, 'NO');
INSERT INTO ud_sample.inp_outfall (node_id, outfall_type, stage, curve_id, timser_id, gate) VALUES ('126', 'NORMAL', NULL, NULL, NULL, 'YES');
INSERT INTO ud_sample.inp_outfall (node_id, outfall_type, stage, curve_id, timser_id, gate) VALUES ('236', 'TIMESERIES_OUTF', NULL, NULL, 'T10-5m', 'NO');


INSERT INTO ud_sample.inp_outlet (arc_id, node_id, outlet_type, "offset", curve_id, cd1, cd2, flap) VALUES ('150', NULL, 'FUNCTIONAL/DEPTH', 1.0000, NULL, 1.0000, 1.0000, 'YES');
INSERT INTO ud_sample.inp_outlet (arc_id, node_id, outlet_type, "offset", curve_id, cd1, cd2, flap) VALUES ('151', NULL, 'FUNCTIONAL/HEAD', 1.0000, NULL, 1.0000, 1.0000, 'NO');
INSERT INTO ud_sample.inp_outlet (arc_id, node_id, outlet_type, "offset", curve_id, cd1, cd2, flap) VALUES ('152', NULL, 'TABULAR/DEPTH', 1.0000, 'C1_CONTROL', NULL, NULL, NULL);
INSERT INTO ud_sample.inp_outlet (arc_id, node_id, outlet_type, "offset", curve_id, cd1, cd2, flap) VALUES ('153', NULL, 'TABULAR/HEAD', 1.0000, 'C1_CONTROL', NULL, NULL, NULL);


INSERT INTO ud_sample.inp_pattern (pattern_id, pattern_type, observ) VALUES ('pattern_02', 'DAILY', NULL);
INSERT INTO ud_sample.inp_pattern (pattern_id, pattern_type, observ) VALUES ('pattern_01', 'HOURLY', NULL);
INSERT INTO ud_sample.inp_pattern (pattern_id, pattern_type, observ) VALUES ('pattern_03', 'MONTHLY_PATTERN', NULL);
INSERT INTO ud_sample.inp_pattern (pattern_id, pattern_type, observ) VALUES ('pattern_04', 'WEEKEND', NULL);


INSERT INTO ud_sample.inp_pattern_value (id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) VALUES (2, 'pattern_01', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_pattern_value (id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) VALUES (3, 'pattern_01', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_pattern_value (id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) VALUES (4, 'pattern_01', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_pattern_value (id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) VALUES (5, 'pattern_02', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_pattern_value (id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) VALUES (6, 'pattern_03', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_pattern_value (id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) VALUES (7, 'pattern_04', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_pattern_value (id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) VALUES (8, 'pattern_04', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ud_sample.inp_pattern_value (id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18, factor_19, factor_20, factor_21, factor_22, factor_23, factor_24) VALUES (1, 'pattern_01', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO ud_sample.inp_pollutant (poll_id, units_type, crain, cgw, cii, kd, sflag, copoll_id, cofract, cdwf, cinit) VALUES ('SS', 'MG/L', 10.0000, 5.0000, 0.0000, 5.0000, 'NO', '*', 0.0000, 350.0000, 1.0000);


INSERT INTO ud_sample.inp_rdii (node_id, hydro_id, sewerarea) VALUES ('101', 'UH1', 0.251000);
INSERT INTO ud_sample.inp_rdii (node_id, hydro_id, sewerarea) VALUES ('102', 'UH1', 0.325100);


INSERT INTO ud_sample.inp_snowpack (id, snow_id, snow_type, value_1, value_2, value_3, value_4, value_5, value_6, value_7) VALUES (1, 'Spack_01', 'PLOWABLE', 0.001, 0.001, 32.000, 0.001, 0.000, 0.000, 0.000);
INSERT INTO ud_sample.inp_snowpack (id, snow_id, snow_type, value_1, value_2, value_3, value_4, value_5, value_6, value_7) VALUES (2, 'Spack_01', 'IMPERVIOUS', 0.001, 0.001, 32.000, 0.001, 0.000, 0.000, 0.000);
INSERT INTO ud_sample.inp_snowpack (id, snow_id, snow_type, value_1, value_2, value_3, value_4, value_5, value_6, value_7) VALUES (3, 'Spack_01', 'PERVIOUS', 0.001, 0.001, 0.000, 0.001, 0.000, 0.000, 0.000);
INSERT INTO ud_sample.inp_snowpack (id, snow_id, snow_type, value_1, value_2, value_3, value_4, value_5, value_6, value_7) VALUES (4, 'Spack_01', 'REMOVAL', 1.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000);


INSERT INTO ud_sample.inp_storage (node_id, storage_type, curve_id, a1, a2, a0, fevap, sh, hc, imd, y0, ysur, apond) VALUES ('18828', 'TABULAR_STORAGE', 'EBAR-02', NULL, NULL, NULL, 1.0000, 1.0000, 1.0000, 1.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO ud_sample.inp_storage (node_id, storage_type, curve_id, a1, a2, a0, fevap, sh, hc, imd, y0, ysur, apond) VALUES ('238', 'FUNCTIONAL', NULL, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO ud_sample.inp_storage (node_id, storage_type, curve_id, a1, a2, a0, fevap, sh, hc, imd, y0, ysur, apond) VALUES ('125', 'TABULAR_STORAGE', 'EBAR-02', NULL, NULL, NULL, 1.0000, 1.0000, 1.0000, 1.0000, 0.0000, 0.0000, 0.0000);


INSERT INTO ud_sample.inp_temperature (id, temp_type, value) VALUES (6, 'SNOWMELT', '1 2 3 4 5 6 7 8 9 10 11 12');
INSERT INTO ud_sample.inp_temperature (id, temp_type, value) VALUES (1, 'ADC IMPERVIOUS', '1 2 3 4 5 6 7 8 9 10 11 12');
INSERT INTO ud_sample.inp_temperature (id, temp_type, value) VALUES (2, 'ADC PERVIOUS', '1 2 3 4 5 6 7 8 9 10 11 12');
INSERT INTO ud_sample.inp_temperature (id, temp_type, value) VALUES (5, 'MONTHLY_WINDSP', '1 2 3 4 5 6 7 8 9 10 11 12');
INSERT INTO ud_sample.inp_temperature (id, temp_type, value) VALUES (7, 'TIMESERIES_TEMP', 'T10-5m');
INSERT INTO ud_sample.inp_temperature (id, temp_type, value) VALUES (3, 'FILE_TEMP', 'c:/data/temperature.txt');
INSERT INTO ud_sample.inp_temperature (id, temp_type, value) VALUES (4, 'FILE_WINDSP', 'c:/data/windspeed.txt');


INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (1, 'T5-5m', NULL, NULL, '0:00', 0.7800, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (2, 'T5-5m', NULL, NULL, '0:05', 1.1500, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (3, 'T5-5m', NULL, NULL, '0:10', 2.2200, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (4, 'T5-5m', NULL, NULL, '0:15', 3.9900, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (5, 'T5-5m', NULL, NULL, '0:20', 4.8800, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (6, 'T5-5m', NULL, NULL, '0:25', 8.7500, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (7, 'T5-5m', NULL, NULL, '0:30', 5.1500, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (8, 'T5-5m', NULL, NULL, '0:35', 3.2000, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (9, 'T5-5m', NULL, NULL, '0:40', 2.2500, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (10, 'T5-5m', NULL, NULL, '0:45', 1.2500, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (11, 'T5-5m', NULL, NULL, '0:50', 0.9200, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (12, 'T5-5m', NULL, NULL, '0:55', 0.4900, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (13, 'T10-5m', NULL, NULL, '0:00', 1.7800, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (14, 'T10-5m', NULL, NULL, '0:05', 2.0800, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (15, 'T10-5m', NULL, NULL, '0:10', 2.5200, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (16, 'T10-5m', NULL, NULL, '0:15', 3.2500, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (17, 'T10-5m', NULL, NULL, '0:20', 4.7800, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (18, 'T10-5m', NULL, NULL, '0:25', 15.5200, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (19, 'T10-5m', NULL, NULL, '0:30', 6.5800, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (20, 'T10-5m', NULL, NULL, '0:35', 3.8400, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (21, 'T10-5m', NULL, NULL, '0:40', 2.8300, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (22, 'T10-5m', NULL, NULL, '0:45', 2.2800, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (23, 'T10-5m', NULL, NULL, '0:50', 1.9200, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (24, 'T10-5m', NULL, NULL, '0:55', 1.6600, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (26, 'T100-5m', '05/12/1995', '0:00', NULL, 0.5000, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (27, 'T100-5m', '05/12/1995', '0:05', NULL, 2.0000, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (28, 'T100-5m', '05/12/1995', '0:10', NULL, 3.5000, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (29, 'T100-5m', '05/12/1995', '0:15', NULL, 4.8600, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (25, 'T2-5m', NULL, NULL, NULL, NULL, 'C:\Users\usuario\Desktop\masterplan_test.txt');
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (30, 'T100-5m', '05/12/1995', '0:20', NULL, 8.5200, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (31, 'T100-5m', '05/12/1995', '0:25', NULL, 12.2500, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (33, 'T100-5m', '05/12/1995', '0:35', NULL, 11.2500, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (34, 'T100-5m', '05/12/1995', '0:40', NULL, 9.6250, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (35, 'T100-5m', '05/12/1995', '0:45', NULL, 4.5250, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (36, 'T100-5m', '05/12/1995', '0:40', NULL, 2.5400, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (37, 'T100-5m', '05/12/1995', '0:55', NULL, 0.5000, NULL);
INSERT INTO ud_sample.inp_timeseries (id, timser_id, date, hour, "time", value, fname) VALUES (32, 'T100-5m', '05/12/1995', '0:30', NULL, 22.1250, NULL);


INSERT INTO ud_sample.inp_timser_id (id, timser_type, times_type) VALUES ('T10-5m', 'Rainfall', 'RELATIVE');
INSERT INTO ud_sample.inp_timser_id (id, timser_type, times_type) VALUES ('T5-5m', 'Rainfall', 'RELATIVE');
INSERT INTO ud_sample.inp_timser_id (id, timser_type, times_type) VALUES ('T100-5m', 'Rainfall', 'ABSOLUTE');
INSERT INTO ud_sample.inp_timser_id (id, timser_type, times_type) VALUES ('T2-5m', 'Rainfall', 'FILE_TIME');
INSERT INTO ud_sample.inp_timser_id (id, timser_type, times_type) VALUES ('ATAEW', NULL, NULL);


INSERT INTO ud_sample.inp_transects (id, tsect_id, text) VALUES (1, 'ts1', 'NC 0.02 0.02 0.01');
INSERT INTO ud_sample.inp_transects (id, tsect_id, text) VALUES (2, 'ts1', 'X1 ts1 6 2 45 0.0 0.0 1 1 1');
INSERT INTO ud_sample.inp_transects (id, tsect_id, text) VALUES (3, 'ts1', 'GR 6 1 5 10 3 12 3 40 5 45');
INSERT INTO ud_sample.inp_transects (id, tsect_id, text) VALUES (4, 'ts1', 'GR 6 50');


INSERT INTO ud_sample.inp_transects_id (id) VALUES ('ts1');


INSERT INTO ud_sample.inp_treatment_node_x_pol (node_id, poll_id, function) VALUES ('110', 'SS', 'R=0.75 * R_SS');
INSERT INTO ud_sample.inp_treatment_node_x_pol (node_id, poll_id, function) VALUES ('111', 'SS', 'R=0.85 * R_SS');
INSERT INTO ud_sample.inp_treatment_node_x_pol (node_id, poll_id, function) VALUES ('112', 'SS', 'R=0.75 * R_SS');



INSERT INTO ud_sample.inp_washoff_land_x_pol (landus_id, poll_id, funcw_type, c1, c2, sweepeffic, bmpeffic) VALUES ('rural', 'SS', 'RC', 1.0000, 1.2500, 0.5200, 2.5000);
INSERT INTO ud_sample.inp_washoff_land_x_pol (landus_id, poll_id, funcw_type, c1, c2, sweepeffic, bmpeffic) VALUES ('urban', 'SS', 'RC', 0.8500, 1.8000, 0.6400, 26.6000);


INSERT INTO ud_sample.inp_weir (arc_id, _node_id, weir_type, "offset", cd, ec, cd2, flap, to_arc, geom1, geom2, geom3, geom4, surcharge) VALUES ('155', NULL, 'TRAPEZOIDAL_WEIR', 1.0000, 0.5000, 1.0000, 1.0000, 'NO', NULL, 1.0000, 1.0000, 1.0000, 1.0000, '2.1');
INSERT INTO ud_sample.inp_weir (arc_id, _node_id, weir_type, "offset", cd, ec, cd2, flap, to_arc, geom1, geom2, geom3, geom4, surcharge) VALUES ('156', NULL, 'SIDEFLOW', 1.0000, 0.5000, 1.0000, 1.0000, 'YES', NULL, 1.0000, 1.0000, 0.0000, 0.0000, '2.1');
INSERT INTO ud_sample.inp_weir (arc_id, _node_id, weir_type, "offset", cd, ec, cd2, flap, to_arc, geom1, geom2, geom3, geom4, surcharge) VALUES ('157', NULL, 'V-NOTCH', 1.0000, 0.5000, 1.0000, 1.0000, 'NO', NULL, 1.0000, 1.0000, 0.0000, 0.0000, '1.0');
INSERT INTO ud_sample.inp_weir (arc_id, _node_id, weir_type, "offset", cd, ec, cd2, flap, to_arc, geom1, geom2, geom3, geom4, surcharge) VALUES ('154', NULL, 'TRANSVERSE', 1.0000, 0.5000, 1.0000, 1.0000, 'YES', NULL, 1.0000, 1.0000, 0.0000, 0.0000, '0.0');