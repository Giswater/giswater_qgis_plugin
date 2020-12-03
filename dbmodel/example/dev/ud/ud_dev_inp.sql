/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO inp_evaporation VALUES ('DRY_ONLY','NO');

DELETE FROM inp_junction WHERE node_id IN ('125','126','127','128','129','130','131','132');
UPDATE node set epa_type='OUTFALL' WHERE node_id IN ('126','127','128');
UPDATE node set epa_type='STORAGE' WHERE node_id IN ('125');
UPDATE node set epa_type='DIVIDER' WHERE node_id IN ('129','130','131','132');


DELETE FROM inp_conduit WHERE arc_id IN ('150','151','152','153','154','155','156','157','158','159');
UPDATE arc set epa_type='OUTLET' WHERE arc_id IN ('150','151','152','153');
UPDATE arc set epa_type='ORIFICE' WHERE arc_id IN ('158','159');
UPDATE arc set epa_type='WEIR' WHERE arc_id IN ('154','155','156','157');

UPDATE inp_conduit SET flap='NO';

INSERT INTO inp_snowpack_id VALUES ('Spack_01', 'Demo snow pack');

UPDATE subcatchment SET snow_id='Spack_01';


INSERT INTO inp_inflows (node_id, timser_id, sfactor, base, pattern_id) SELECT node_id, 'T5-5m', 1, 0.2, NULL FROM node;


INSERT INTO inp_adjustments VALUES ('2', 'EVAPORATION', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO inp_adjustments VALUES ('1', 'TEMPERATURE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO inp_aquifer VALUES ('aquifer01', 0.5000, 0.1500, 0.3000, 5.0000, 10.0000, 15.0000, 0.3500, 14.0000, 0.0020, 0.0000, 10.0000, 0.3000, NULL);


INSERT INTO inp_controls_x_arc (id, arc_id, text) VALUES (1, '201', 
'IF TIME SIMULATION IS >3
THEN PUMP 2 OPEN
ELSE PUM 2 CLOSED
EVER: STATUS ON'
, true);

INSERT INTO inp_controls_x_node (id, node_id, text) VALUES (1, '101', 
'IF TIME SIMULATION IS >3
THEN JUNCTION 101 IS OPEN
ELSE JUNCTION 101 IS CLOSED
EVER: STATUS ON', true');


INSERT INTO inp_curve (id, curve_type) VALUES ('C1_CONTROL', 'CONTROL');
INSERT INTO inp_curve (id, curve_type) VALUES ('C2_DIVERSION', 'DIVERSION');
INSERT INTO inp_curve (id, curve_type) VALUES ('C3_PUMP', 'PUMP1');
INSERT INTO inp_curve (id, curve_type) VALUES ('C4_RATING', 'RATING');
INSERT INTO inp_curve (id, curve_type) VALUES ('C5_SHAPE', 'SHAPE');
INSERT INTO inp_curve (id, curve_type) VALUES ('C6_STORAGE', 'STORAGE_CURVE');
INSERT INTO inp_curve (id, curve_type) VALUES ('C7_TIDAL', 'TIDAL_CURVE');


INSERT INTO inp_curve_value VALUES (16, 'C1_CONTROL', 1.000000, 1.000000);
INSERT INTO inp_curve_value VALUES (17, 'C1_CONTROL', 2.000000, 2.000000);
INSERT INTO inp_curve_value VALUES (18, 'C1_CONTROL', 3.000000, 3.000000);
INSERT INTO inp_curve_value VALUES (19, 'C2_DIVERSION', 1.000000, 1.000000);
INSERT INTO inp_curve_value VALUES (20, 'C2_DIVERSION', 2.000000, 2.000000);
INSERT INTO inp_curve_value VALUES (21, 'C2_DIVERSION', 3.000000, 3.000000);
INSERT INTO inp_curve_value VALUES (22, 'C3_PUMP', 1.000000, 1.000000);
INSERT INTO inp_curve_value VALUES (23, 'C3_PUMP', 2.000000, 2.000000);
INSERT INTO inp_curve_value VALUES (24, 'C3_PUMP', 3.000000, 3.000000);
INSERT INTO inp_curve_value VALUES (25, 'C4_RATING', 1.000000, 1.000000);
INSERT INTO inp_curve_value VALUES (26, 'C4_RATING', 2.000000, 2.000000);
INSERT INTO inp_curve_value VALUES (27, 'C4_RATING', 3.000000, 3.000000);
INSERT INTO inp_curve_value VALUES (28, 'C5_SHAPE', 1.000000, 1.000000);
INSERT INTO inp_curve_value VALUES (29, 'C5_SHAPE', 2.000000, 2.000000);
INSERT INTO inp_curve_value VALUES (30, 'C5_SHAPE', 3.000000, 3.000000);
INSERT INTO inp_curve_value VALUES (31, 'C6_STORAGE', 1.000000, 1.000000);
INSERT INTO inp_curve_value VALUES (32, 'C6_STORAGE', 2.000000, 2.000000);
INSERT INTO inp_curve_value VALUES (33, 'C6_STORAGE', 3.000000, 3.000000);
INSERT INTO inp_curve_value VALUES (34, 'C7_TIDAL', 1.000000, 1.000000);
INSERT INTO inp_curve_value VALUES (35, 'C7_TIDAL', 2.000000, 2.000000);
INSERT INTO inp_curve_value VALUES (36, 'C7_TIDAL', 3.000000, 3.000000);



INSERT INTO inp_divider VALUES ('129', 'TABULAR', '201', 'C2_DIVERSION', NULL, NULL, NULL, 0.8982, 0.6767, 63.5941);
INSERT INTO inp_divider VALUES ('130', 'CUTOFF', '202', NULL, 1.000000, NULL, NULL, 0.1588, 0.7805, 79.9171);
INSERT INTO inp_divider VALUES ('131', 'WEIR', '203', NULL, 1.000000, 1.0000, 1.0000, 0.5573, 0.1130, 75.8022);
INSERT INTO inp_divider VALUES ('132', 'OVERFLOW', '204', NULL, NULL, NULL, NULL, 0.0345, 0.3384, 35.7010);



INSERT INTO inp_evaporation (evap_type, value) VALUES ('CONSTANT', '1');
INSERT INTO inp_evaporation (evap_type, value) VALUES ('TEMPERATURE', NULL);
INSERT INTO inp_evaporation (evap_type, value) VALUES ('MONTHLY', '1 0.5 2 4 2 5 4.3 2 2.3 2 1.2 3.4');
INSERT INTO inp_evaporation (evap_type, value) VALUES ('TIMESERIES', 'T100-5m');
INSERT INTO inp_evaporation (evap_type, value) VALUES ('FILE', 'fname');
INSERT INTO inp_evaporation (evap_type, value) VALUES ('RECOVERY', 'patten_01');


INSERT INTO inp_flwreg_orifice (id, node_id, to_arc, flwreg_id, flwreg_length, ori_type, "offset", cd, orate, flap, shape, geom1, geom2, geom3, geom4) 
VALUES (4, '40', '163', 5, 1.25, 'SIDE', 34.1250, 1.5000, 1.0000, 'YES', 'CIRCULAR', 0.8800, 0.0000, 0.0000, 0.0000);
INSERT INTO inp_flwreg_orifice (id, node_id, to_arc, flwreg_id, flwreg_length, ori_type, "offset", cd, orate, flap, shape, geom1, geom2, geom3, geom4) 
VALUES (7, '40', '163', 6, 0.98499999999999999, 'BOTTOM', 34.0080, 1.5000, 1.0000, 'YES', 'RECT-CLOSED', 0.7700, 0.6600, 0.0000, 0.0000);


INSERT INTO inp_flwreg_outlet (id, node_id, to_arc, flwreg_id, flwreg_length, outlet_type, "offset", curve_id, cd1, cd2, flap) 
VALUES (4, '40', '163', 3, 3.234, 'TABULAR/DEPTH', 33.9250, 'C1_CONTROL', NULL, NULL, NULL);
INSERT INTO inp_flwreg_outlet (id, node_id, to_arc, flwreg_id, flwreg_length, outlet_type, "offset", curve_id, cd1, cd2, flap) 
VALUES (6, '40', '163', 4, 1.234, 'TABULAR/HEAD', 33.9954, 'C1_CONTROL', NULL, NULL, NULL);
INSERT INTO inp_flwreg_outlet (id, node_id, to_arc, flwreg_id, flwreg_length, outlet_type, "offset", curve_id, cd1, cd2, flap) 
VALUES (1, '40', '163', 1, 1.254, 'FUNCTIONAL/DEPTH', 34.1255, NULL, 0.2500, 0.7481, 'YES');
INSERT INTO inp_flwreg_outlet (id, node_id, to_arc, flwreg_id, flwreg_length, outlet_type, "offset", curve_id, cd1, cd2, flap) 
VALUES (3, '40', '163', 2, 2.012, 'FUNCTIONAL/HEAD', 34.0244, NULL, 1.1520, 0.2517, NULL);


DELETE FROM inp_flwreg_weir;
INSERT INTO inp_flwreg_weir VALUES (1, '237', '242', 1, 0.5, 'TRANSVERSE', 16.3500, 1.5000, NULL, NULL, 'NO', 2.0000, 2.0000, 0.0000, 0.0000, NULL);
INSERT INTO inp_flwreg_weir VALUES (2, '238', '244', 1, 1, 'SIDEFLOW', 29.0000, 1.5000, NULL, NULL, 'NO', 1.0000, 1.0000, 0.0000, 0.0000, NULL);
INSERT INTO inp_flwreg_weir VALUES (3, '18828', '18969', 1, 0.5, 'TRAPEZOIDAL_WEIR', 17.1500, 1.5000, NULL, NULL, 'NO', 1.0000, 1.0000, 0.0000, 0.0000, NULL);
INSERT INTO inp_flwreg_weir VALUES (11, '40', '163', 1, 2, 'V-NOTCH', 35.1020, 1.5000, NULL, NULL, 'YES', 1.5000, 1.2500, 0.0000, 0.0000, NULL);

INSERT INTO inp_groundwater VALUES ('S101', 'aquifer01', '101', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, '0', '0');
INSERT INTO inp_groundwater VALUES ('S102', 'aquifer01', '102', 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, '0', '0');

INSERT INTO inp_hydrograph_id VALUES ('UH1');

INSERT INTO inp_hydrograph VALUES (1, 'UH1 RG-01');
INSERT INTO inp_hydrograph VALUES (2, 'UH1 JAN SHORT 1 1 1 ');
INSERT INTO inp_hydrograph VALUES (3, 'UH1 ALL MEDIUM 1 1 1');


INSERT INTO inp_landuses VALUES ('rural', 0.0000, 0.0000, 0.0000);
INSERT INTO inp_landuses VALUES ('urban', 0.0000, 0.0000, 0.0000);


INSERT INTO inp_lid_control VALUES (1, 'lid01', 'IT', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO inp_lid_control VALUES (4, 'lid01', 'DRAIN', 0.0000, 0.5000, 0.0000, 6.0000, NULL, NULL, NULL);
INSERT INTO inp_lid_control VALUES (2, 'lid01', 'SURFACE', 0.0000, 0.0000, 0.1000, 1.0000, 5.0000, 3.0000, NULL);
INSERT INTO inp_lid_control VALUES (3, 'lid01', 'SURFACE', 12.0000, 0.7500, 0.0000, 6.0000, 5.0000, 3.0000, NULL);


INSERT INTO inp_lidusage_subc_x_lidco VALUES ('S104', 'lid01', 1, 0.010000, 10.0000, 0.0000, 0.0000, 0, '0');
INSERT INTO inp_lidusage_subc_x_lidco VALUES ('S105', 'lid01', 2, 0.020000, 5.0000, 1.0000, 0.0000, 0, '0');


INSERT INTO inp_loadings_pol_x_subc VALUES ('SS', 'S101', 1.0000);
INSERT INTO inp_loadings_pol_x_subc VALUES ('SS', 'S102', 2.0000);
INSERT INTO inp_loadings_pol_x_subc VALUES ('SS', 'S107', 1.2500);


INSERT INTO inp_orifice VALUES ('158', NULL, 'SIDE', 2.0000, 1.0000, 1.0000, 'YES', 'CIRCULAR', NULL, 1.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO inp_orifice VALUES ('159', NULL, 'BOTTOM', 2.0000, 1.0000, 1.0000, 'NO', 'RECT_CLOSED', NULL, 1.0000, 2.0000, 0.0000, 0.0000);


INSERT INTO inp_outfall VALUES ('127', 'TIDAL', NULL, 'C7_TIDAL', NULL, 'YES');
INSERT INTO inp_outfall VALUES ('128', 'FIXED', 225.0000, NULL, NULL, 'YES');
INSERT INTO inp_outfall VALUES ('126', 'NORMAL', NULL, NULL, NULL, 'YES');
UPDATE inp_outfall SET outfall_type='TIMESERIES', timser_id='T10-5m', gate='YES'  WHERE node_id='236';
UPDATE inp_outfall SET outfall_type='FREE', gate='YES'  WHERE node_id='240';


INSERT INTO inp_outlet VALUES ('150', NULL, 'FUNCTIONAL/DEPTH', 1.0000, NULL, 1.0000, 1.0000, 'YES');
INSERT INTO inp_outlet VALUES ('151', NULL, 'FUNCTIONAL/HEAD', 1.0000, NULL, 1.0000, 1.0000, 'NO');
INSERT INTO inp_outlet VALUES ('152', NULL, 'TABULAR/DEPTH', 1.0000, 'C1_CONTROL', NULL, NULL, NULL);
INSERT INTO inp_outlet VALUES ('153', NULL, 'TABULAR/HEAD', 1.0000, 'C1_CONTROL', NULL, NULL, NULL);

DELETE FROM inp_pattern;
INSERT INTO inp_pattern (pattern_id, pattern_type, observ) VALUES ('pattern_02', 'DAILY', NULL);
INSERT INTO inp_pattern (pattern_id, pattern_type, observ) VALUES ('pattern_01', 'HOURLY', NULL);
INSERT INTO inp_pattern (pattern_id, pattern_type, observ) VALUES ('pattern_03', 'MONTHLY', NULL);
INSERT INTO inp_pattern (pattern_id, pattern_type, observ) VALUES ('pattern_04', 'WEEKEND', NULL);

DELETE FROM inp_pattern_value;
INSERT INTO inp_pattern_value 
VALUES (2, 'pattern_01', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO inp_pattern_value 
VALUES (3, 'pattern_01', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO inp_pattern_value 
VALUES (4, 'pattern_01', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO inp_pattern_value 
VALUES (5, 'pattern_02', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO inp_pattern_value 
VALUES (6, 'pattern_03', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO inp_pattern_value 
VALUES (7, 'pattern_04', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO inp_pattern_value 
VALUES (8, 'pattern_04', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO inp_pattern_value 
VALUES (1, 'pattern_01', 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO inp_pollutant VALUES ('SS', 'MG/L', 10.0000, 5.0000, 0.0000, 5.0000, 'NO', '*', 0.0000, 350.0000, 1.0000);


INSERT INTO inp_rdii VALUES ('101', 'UH1', 0.251000);
INSERT INTO inp_rdii VALUES ('102', 'UH1', 0.325100);

INSERT INTO inp_snowpack VALUES (1, 'Spack_01', 'PLOWABLE', 0.001, 0.001, 32.000, 0.001, 0.000, 0.000, 0.000);
INSERT INTO inp_snowpack VALUES (2, 'Spack_01', 'IMPERVIOUS', 0.001, 0.001, 32.000, 0.001, 0.000, 0.000, 0.000);
INSERT INTO inp_snowpack VALUES (3, 'Spack_01', 'PERVIOUS', 0.001, 0.001, 0.000, 0.001, 0.000, 0.000, 0.000);
INSERT INTO inp_snowpack VALUES (4, 'Spack_01', 'REMOVAL', 1.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000);

DELETE FROM inp_storage;
INSERT INTO inp_storage VALUES ('18828', 'TABULAR', 'EBAR-02', NULL, NULL, NULL, 1.0000, 1.0000, 1.0000, 1.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO inp_storage VALUES ('238', 'FUNCTIONAL', NULL, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 1.0000, 0.0000, 0.0000, 0.0000);
INSERT INTO inp_storage VALUES ('125', 'TABULAR', 'EBAR-02', NULL, NULL, NULL, 1.0000, 1.0000, 1.0000, 1.0000, 0.0000, 0.0000, 0.0000);


INSERT INTO inp_temperature VALUES (6, 'SNOWMELT', '1 2 3 4 5 6 7 8 9 10 11 12');
INSERT INTO inp_temperature VALUES (1, 'ADC', 'IMPERVIOUS 1 2 3 4 5 6 7 8 9 10 11 12');
INSERT INTO inp_temperature VALUES (2, 'ADC', 'PERVIOUS 1 2 3 4 5 6 7 8 9 10 11 12');
INSERT INTO inp_temperature VALUES (7, 'TIMESERIES', 'T10-5m');
INSERT INTO inp_temperature VALUES (3, 'TIMESERIES', 'FILE "c:/data/temperature.txt"');
INSERT INTO inp_temperature VALUES (4, 'WINDSPEED', 'FILE "c:/data/windspeed.txt"');
INSERT INTO inp_temperature VALUES (5, 'WINDSPEED', 'MONTHLY 1 2 3 4 5 6 7 8 9 10 11 12');


INSERT INTO inp_timser_id VALUES ('T100-5m', 'Rainfall', 'ABSOLUTE');
INSERT INTO inp_timser_id VALUES ('T2-5m', 'Rainfall', 'FILE');

INSERT INTO inp_timeseries VALUES (25, 'T2-5m', NULL, NULL, NULL, NULL, '"C:\Users\usuario\Desktop\masterplan_test.txt"');
INSERT INTO inp_timeseries VALUES (26, 'T100-5m', '05/12/1995', '0:00', NULL, 0.5000, NULL);
INSERT INTO inp_timeseries VALUES (27, 'T100-5m', '05/12/1995', '0:05', NULL, 2.0000, NULL);
INSERT INTO inp_timeseries VALUES (28, 'T100-5m', '05/12/1995', '0:10', NULL, 3.5000, NULL);
INSERT INTO inp_timeseries VALUES (29, 'T100-5m', '05/12/1995', '0:15', NULL, 4.8600, NULL);
INSERT INTO inp_timeseries VALUES (30, 'T100-5m', '05/12/1995', '0:20', NULL, 8.5200, NULL);
INSERT INTO inp_timeseries VALUES (31, 'T100-5m', '05/12/1995', '0:25', NULL, 12.2500, NULL);
INSERT INTO inp_timeseries VALUES (33, 'T100-5m', '05/12/1995', '0:35', NULL, 11.2500, NULL);
INSERT INTO inp_timeseries VALUES (34, 'T100-5m', '05/12/1995', '0:40', NULL, 9.6250, NULL);
INSERT INTO inp_timeseries VALUES (35, 'T100-5m', '05/12/1995', '0:45', NULL, 4.5250, NULL);
INSERT INTO inp_timeseries VALUES (36, 'T100-5m', '05/12/1995', '0:40', NULL, 2.5400, NULL);
INSERT INTO inp_timeseries VALUES (37, 'T100-5m', '05/12/1995', '0:55', NULL, 0.5000, NULL);
INSERT INTO inp_timeseries VALUES (32, 'T100-5m', '05/12/1995', '0:30', NULL, 22.1250, NULL);

INSERT INTO inp_inflows_pol_x_node (poll_id, node_id, timser_id, form_type, mfactor, sfactor, base, pattern_id) 
SELECT 'SS',node_id, 'T5-5m', 'CONCEN',1, 1, 0.2, 'pattern_01' FROM node;


INSERT INTO inp_buildup_land_x_pol (landus_id, poll_id, funcb_type, c1, c2, c3, perunit) VALUES ('rural', 'SS', 'SAT', 0.0500, 1.0000, 5.0000, 'AREA');
INSERT INTO inp_buildup_land_x_pol (landus_id, poll_id, funcb_type, c1, c2, c3, perunit) VALUES ('urban', 'SS', 'SAT', 0.0500, 1.0000, 2.5000, 'AREA');


INSERT INTO inp_transects_id (id) VALUES ('ts1');

INSERT INTO inp_transects VALUES (1, 'ts1', 'NC 0.02 0.02 0.01');
INSERT INTO inp_transects VALUES (2, 'ts1', 'X1 ts1 6 2 45 0.0 0.0 1 1 1');
INSERT INTO inp_transects VALUES (3, 'ts1', 'GR 6 1 5 10 3 12 3 40 5 45');
INSERT INTO inp_transects VALUES (4, 'ts1', 'GR 6 50');


INSERT INTO inp_treatment_node_x_pol VALUES ('110', 'SS', 'R=0.75 * R_SS');
INSERT INTO inp_treatment_node_x_pol VALUES ('111', 'SS', 'R=0.85 * R_SS');
INSERT INTO inp_treatment_node_x_pol VALUES ('112', 'SS', 'R=0.75 * R_SS');


INSERT INTO inp_washoff_land_x_pol VALUES ('rural', 'SS', 'RC', 1.0000, 1.2500, 0.5200, 2.5000);
INSERT INTO inp_washoff_land_x_pol VALUES ('urban', 'SS', 'RC', 0.8500, 1.8000, 0.6400, 26.6000);


INSERT INTO inp_weir VALUES ('155', NULL, 'TRAPEZOIDAL', 1.0000, 0.5000, 1.0000, 1.0000, 'NO', NULL, 1.0000, 1.0000, 1.0000, 1.0000, '2.1');
INSERT INTO inp_weir VALUES ('156', NULL, 'SIDEFLOW', 1.0000, 0.5000, 1.0000, 1.0000, 'YES', NULL, 1.0000, 1.0000, 0.0000, 0.0000, '2.1');
INSERT INTO inp_weir VALUES ('157', NULL, 'V-NOTCH', 1.0000, 0.5000, 1.0000, 1.0000, 'NO', NULL, 1.0000, 1.0000, 0.0000, 0.0000, '1.0');
INSERT INTO inp_weir VALUES ('154', NULL, 'TRANSVERSE', 1.0000, 0.5000, 1.0000, 1.0000, 'YES', NULL, 1.0000, 1.0000, 0.0000, 0.0000, '0.0');


INSERT INTO inp_coverage_land_x_subc SELECT subc_id, landus_id, 0.5 FROM subcatchment, inp_landuses;


UPDATE inp_junction SET y0=random(), ysur=random(), apond=random()*100 ;
UPDATE inp_divider SET y0=random(), ysur=random(), apond= random()*100 ;
UPDATE inp_conduit SET kentry=random()*0.3, kexit=random()*0.3, kavg=random()*0.3 , q0=random()*01, qmax=random(), custom_n=0.011 ;

UPDATE inp_dwf SET pat1='pattern_01', pat2='pattern_02', pat3='pattern_03', pat4='pattern_04';