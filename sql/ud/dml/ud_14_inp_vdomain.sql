/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of inp_options
-- ----------------------------
 
INSERT INTO inp_options 
VALUES (1,'CMS', 'DYNWAVE', 'ELEVATION', 'H-W', 'NO', 'NO', 'NO', 'NO', 'NO', 'NO', '01/01/2017', '00:00:00', '01/02/2017', '00:00:00', '01/01/2001', '00:00:00', '01/01', '12/31', 10, '00:05:00', '00:05:00', '01:00:00', '00:00:02', NULL, NULL, 'NONE', 'BOTH', 0.000000, 0.000000, 'YES', NULL, 0, 0.0000, 5, 5);

-- ----------------------------
-- Records of inp_report
-- ----------------------------
 
INSERT INTO inp_report VALUES ('YES', 'YES', 'YES', 'YES', 'ALL', 'ALL', 'ALL');


-- ----------------------------
-- Records of inp_arc_type
-- ----------------------------
 
INSERT INTO "inp_arc_type" VALUES ('CONDUIT');
INSERT INTO "inp_arc_type" VALUES ('ORIFICE');
INSERT INTO "inp_arc_type" VALUES ('OUTLET');
INSERT INTO "inp_arc_type" VALUES ('PUMP');
INSERT INTO "inp_arc_type" VALUES ('WEIR');
INSERT INTO "inp_arc_type" VALUES ('NOT DEFINED');
INSERT INTO "inp_arc_type" VALUES ('VIRTUAL');


-- ----------------------------
-- Records of inp_node_type
-- ----------------------------
 
INSERT INTO "inp_node_type" VALUES ('JUNCTION');
INSERT INTO "inp_node_type" VALUES ('OUTFALL');
INSERT INTO "inp_node_type" VALUES ('DIVIDER');
INSERT INTO "inp_node_type" VALUES ('STORAGE');
INSERT INTO "inp_node_type" VALUES ('NOT DEFINED');



-- ----------------------------
-- Records of inp_typevalue_divider
-- ----------------------------
 
INSERT INTO "inp_typevalue_divider" VALUES ('CUTOFF', null);
INSERT INTO "inp_typevalue_divider" VALUES ('OVERFLOW', null);
INSERT INTO "inp_typevalue_divider" VALUES ('TABULAR', null);
INSERT INTO "inp_typevalue_divider" VALUES ('WEIR', null);
 

-- ----------------------------
-- Records of inp_typevalue_evap
-- ----------------------------
 
INSERT INTO "inp_typevalue_evap" VALUES ('CONSTANT', null);
INSERT INTO "inp_typevalue_evap" VALUES ('FILE', null);
INSERT INTO "inp_typevalue_evap" VALUES ('MONTHLY', null);
INSERT INTO "inp_typevalue_evap" VALUES ('RECOVERY', null);
INSERT INTO "inp_typevalue_evap" VALUES ('TEMPERATURE', null);
INSERT INTO "inp_typevalue_evap" VALUES ('TIMESERIES', null);
 

-- ----------------------------
-- Records of inp_typevalue_orifice
-- ----------------------------
 
INSERT INTO "inp_typevalue_orifice" VALUES ('BOTTOM', null);
INSERT INTO "inp_typevalue_orifice" VALUES ('SIDE', null);
 

-- ----------------------------
-- Records of inp_typevalue_outfall
-- ----------------------------
 
INSERT INTO "inp_typevalue_outfall" VALUES ('FIXED', null);
INSERT INTO "inp_typevalue_outfall" VALUES ('FREE', null);
INSERT INTO "inp_typevalue_outfall" VALUES ('NORMAL', null);
INSERT INTO "inp_typevalue_outfall" VALUES ('TIDAL', null);
INSERT INTO "inp_typevalue_outfall" VALUES ('TIMESERIES', null);
 

-- ----------------------------
-- Records of inp_typevalue_outlet
-- ----------------------------
 
INSERT INTO "inp_typevalue_outlet" VALUES ('FUNCTIONAL/DEPTH', null);
INSERT INTO "inp_typevalue_outlet" VALUES ('FUNCTIONAL/HEAD', null);
INSERT INTO "inp_typevalue_outlet" VALUES ('TABULAR/DEPTH', null);
INSERT INTO "inp_typevalue_outlet" VALUES ('TABULAR/HEAD', null);
 

-- ----------------------------
-- Records of inp_typevalue_pattern
-- ----------------------------
 
INSERT INTO "inp_typevalue_pattern" VALUES ('DAILY', null);
INSERT INTO "inp_typevalue_pattern" VALUES ('HOURLY', null);
INSERT INTO "inp_typevalue_pattern" VALUES ('MONTHLY', null);
INSERT INTO "inp_typevalue_pattern" VALUES ('WEEKEND', null);
 

-- ----------------------------
-- Records of inp_typevalue_raingage
-- ----------------------------
 
INSERT INTO "inp_typevalue_raingage" VALUES ('FILE', null);
INSERT INTO "inp_typevalue_raingage" VALUES ('TIMESERIES', null);
 

-- ----------------------------
-- Records of inp_typevalue_storage
-- ----------------------------
 
INSERT INTO "inp_typevalue_storage" VALUES ('FUNCTIONAL', null);
INSERT INTO "inp_typevalue_storage" VALUES ('TABULAR', null);
 

-- ----------------------------
-- Records of inp_typevalue_temp
-- ----------------------------
 
INSERT INTO "inp_typevalue_temp" VALUES ('FILE', null);
INSERT INTO "inp_typevalue_temp" VALUES ('TIMESERIES', null);
 

-- ----------------------------
-- Records of inp_typevalue_timeseries
-- ----------------------------
 
INSERT INTO "inp_typevalue_timeseries" VALUES ('ABSOLUTE', null);
INSERT INTO "inp_typevalue_timeseries" VALUES ('FILE', null);
INSERT INTO "inp_typevalue_timeseries" VALUES ('RELATIVE', null);
 

-- ----------------------------
-- Records of inp_typevalue_windsp
-- ----------------------------
 
INSERT INTO "inp_typevalue_windsp" VALUES ('FILE', null);
INSERT INTO "inp_typevalue_windsp" VALUES ('MONTHLY', null);
 

-- ----------------------------
-- Records of inp_value_allnone
-- ----------------------------
 
INSERT INTO "inp_value_allnone" VALUES ('ALL');
INSERT INTO "inp_value_allnone" VALUES ('NONE');
 

-- ----------------------------
-- Records of inp_value_arccat
-- ----------------------------

 
INSERT INTO "inp_value_catarc" VALUES ('CIRCULAR');
INSERT INTO "inp_value_catarc" VALUES ('FILLED_CIRCULAR');
INSERT INTO "inp_value_catarc" VALUES ('RECT_CLOSED');
INSERT INTO "inp_value_catarc" VALUES ('RECT_OPEN');
INSERT INTO "inp_value_catarc" VALUES ('TRAPEZOIDAL');
INSERT INTO "inp_value_catarc" VALUES ('TRIANGULAR');
INSERT INTO "inp_value_catarc" VALUES ('HORIZ_ELLIPSE');
INSERT INTO "inp_value_catarc" VALUES ('ARCH');
INSERT INTO "inp_value_catarc" VALUES ('PARABOLIC');
INSERT INTO "inp_value_catarc" VALUES ('POWER');
INSERT INTO "inp_value_catarc" VALUES ('RECT_TRIANGULAR');
INSERT INTO "inp_value_catarc" VALUES ('RECT_ROUND');
INSERT INTO "inp_value_catarc" VALUES ('MODBASKETHANDLE');
INSERT INTO "inp_value_catarc" VALUES ('EGG');
INSERT INTO "inp_value_catarc" VALUES ('HORSESHOE');
INSERT INTO "inp_value_catarc" VALUES ('SEMIELLIPTICAL');
INSERT INTO "inp_value_catarc" VALUES ('BASKETHANDLE');
INSERT INTO "inp_value_catarc" VALUES ('SEMICIRCULAR');
INSERT INTO "inp_value_catarc" VALUES ('IRREGULAR');
INSERT INTO "inp_value_catarc" VALUES ('CUSTOM');
INSERT INTO "inp_value_catarc" VALUES ('DUMMY');
INSERT INTO "inp_value_catarc" VALUES ('FORCE_MAIN'); 
INSERT INTO "inp_value_catarc" VALUES ('VIRTUAL'); 

-- ----------------------------
-- Records of inp_value_buildup
-- ----------------------------
 
INSERT INTO "inp_value_buildup" VALUES ('EXP');
INSERT INTO "inp_value_buildup" VALUES ('EXT');
INSERT INTO "inp_value_buildup" VALUES ('POW');
INSERT INTO "inp_value_buildup" VALUES ('SAT');
 

-- ----------------------------
-- Records of inp_value_curve
-- ----------------------------
 
INSERT INTO "inp_value_curve" VALUES ('CONTROL');
INSERT INTO "inp_value_curve" VALUES ('DIVERSION');
INSERT INTO "inp_value_curve" VALUES ('PUMP1');
INSERT INTO "inp_value_curve" VALUES ('PUMP2');
INSERT INTO "inp_value_curve" VALUES ('PUMP3');
INSERT INTO "inp_value_curve" VALUES ('PUMP4');
INSERT INTO "inp_value_curve" VALUES ('RATING');
INSERT INTO "inp_value_curve" VALUES ('SHAPE');
INSERT INTO "inp_value_curve" VALUES ('STORAGE');
INSERT INTO "inp_value_curve" VALUES ('TIDAL');
 

-- ----------------------------
-- Records of inp_value_files_actio
-- ----------------------------
 
INSERT INTO "inp_value_files_actio" VALUES ('SAVE');
INSERT INTO "inp_value_files_actio" VALUES ('USE');
 

-- ----------------------------
-- Records of inp_value_files_type
-- ----------------------------
 
INSERT INTO "inp_value_files_type" VALUES ('HOTSTART');
INSERT INTO "inp_value_files_type" VALUES ('INFLOWS');
INSERT INTO "inp_value_files_type" VALUES ('OUTFLOWS');
INSERT INTO "inp_value_files_type" VALUES ('RAINFALL');
INSERT INTO "inp_value_files_type" VALUES ('RDII');
INSERT INTO "inp_value_files_type" VALUES ('RUNOFF');
 

-- ----------------------------
-- Records of inp_value_inflows
-- ----------------------------
 
INSERT INTO "inp_value_inflows" VALUES ('CONCEN');
INSERT INTO "inp_value_inflows" VALUES ('MASS');
 

-- ----------------------------
-- Records of inp_value_lidcontrol
-- ----------------------------
 
INSERT INTO "inp_value_lidcontrol" VALUES ('DRAIN');
INSERT INTO "inp_value_lidcontrol" VALUES ('PAVEMENT');
INSERT INTO "inp_value_lidcontrol" VALUES ('SOIL');
INSERT INTO "inp_value_lidcontrol" VALUES ('STORAGE');
INSERT INTO "inp_value_lidcontrol" VALUES ('SURFACE');
INSERT INTO "inp_value_lidcontrol" VALUES ('BC');
INSERT INTO "inp_value_lidcontrol" VALUES ('PP');
INSERT INTO "inp_value_lidcontrol" VALUES ('IT');
INSERT INTO "inp_value_lidcontrol" VALUES ('RB');
INSERT INTO "inp_value_lidcontrol" VALUES ('VS');
INSERT INTO "inp_value_lidcontrol" VALUES ('GR');
INSERT INTO "inp_value_lidcontrol" VALUES ('DRAINMAT');

-- ----------------------------
-- Records of inp_value_mapunits
-- ----------------------------
 
INSERT INTO "inp_value_mapunits" VALUES ('DEGREES');
INSERT INTO "inp_value_mapunits" VALUES ('FEET');
INSERT INTO "inp_value_mapunits" VALUES ('METERS');
INSERT INTO "inp_value_mapunits" VALUES ('NONE');
 

-- ----------------------------
-- Records of inp_value_options_fme
-- ----------------------------
 
INSERT INTO "inp_value_options_fme" VALUES ('D-W');
INSERT INTO "inp_value_options_fme" VALUES ('H-W');
 

-- ----------------------------
-- Records of inp_value_options_fr
-- ----------------------------
 
INSERT INTO "inp_value_options_fr" VALUES ('DYNWAVE');
INSERT INTO "inp_value_options_fr" VALUES ('KINWAVE');
INSERT INTO "inp_value_options_fr" VALUES ('STEADY');
 

-- ----------------------------
-- Records of inp_value_options_fu
-- ----------------------------
 
INSERT INTO "inp_value_options_fu" VALUES ('CFS');
INSERT INTO "inp_value_options_fu" VALUES ('CMS');
INSERT INTO "inp_value_options_fu" VALUES ('GPM');
INSERT INTO "inp_value_options_fu" VALUES ('LPS');
INSERT INTO "inp_value_options_fu" VALUES ('MGD');
INSERT INTO "inp_value_options_fu" VALUES ('MLD');
 

-- ----------------------------
-- Records of inp_value_options_id
-- ----------------------------
 
INSERT INTO "inp_value_options_id" VALUES ('FULL');
INSERT INTO "inp_value_options_id" VALUES ('NONE');
INSERT INTO "inp_value_options_id" VALUES ('PARTIAL');
 

-- ----------------------------
-- Records of inp_value_options_in
-- ----------------------------
 
INSERT INTO "inp_value_options_in" VALUES ('CURVE_NUMBER');
INSERT INTO "inp_value_options_in" VALUES ('GREEN_AMPT');
INSERT INTO "inp_value_options_in" VALUES ('HORTON');
INSERT INTO "inp_value_options_in" VALUES ('MODIFIED_HORTON'); 
 

-- ----------------------------
-- Records of inp_value_options_lo
-- ----------------------------
 
INSERT INTO "inp_value_options_lo" VALUES ('DEPTH');
INSERT INTO "inp_value_options_lo" VALUES ('ELEVATION');
 

-- ----------------------------
-- Records of inp_value_options_nfl
-- ----------------------------
 
INSERT INTO "inp_value_options_nfl" VALUES ('BOTH');
INSERT INTO "inp_value_options_nfl" VALUES ('FROUD');
INSERT INTO "inp_value_options_nfl" VALUES ('SLOPE');
 

-- ----------------------------
-- Records of inp_value_orifice
-- ----------------------------
 
INSERT INTO "inp_value_orifice" VALUES ('CIRCULAR');
INSERT INTO "inp_value_orifice" VALUES ('RECT-CLOSED');
 

-- ----------------------------
-- Records of inp_value_pollutants
-- ----------------------------
 
INSERT INTO "inp_value_pollutants" VALUES ('#/L');
INSERT INTO "inp_value_pollutants" VALUES ('MG/L');
INSERT INTO "inp_value_pollutants" VALUES ('UG/L');
 

-- ----------------------------
-- Records of inp_value_raingage
-- ----------------------------
 
INSERT INTO "inp_value_raingage" VALUES ('CUMULATIVE');
INSERT INTO "inp_value_raingage" VALUES ('INTENSITY');
INSERT INTO "inp_value_raingage" VALUES ('VOLUME');
 

-- ----------------------------
-- Records of inp_value_routeto
-- ----------------------------
 
INSERT INTO "inp_value_routeto" VALUES ('OUTLET');
INSERT INTO "inp_value_routeto" VALUES ('IMPERVIOUS');
INSERT INTO "inp_value_routeto" VALUES ('PERVIOUS');
 


-- ----------------------------
-- Records of inp_value_status
-- ----------------------------
 
INSERT INTO "inp_value_status" VALUES ('ON');
INSERT INTO "inp_value_status" VALUES ('OFF');
 

-- ----------------------------
-- Records of inp_value_timserid
-- ----------------------------
 
INSERT INTO "inp_value_timserid" VALUES ('Evaporation', null);
INSERT INTO "inp_value_timserid" VALUES ('Inflow_Hydrograph', null);
INSERT INTO "inp_value_timserid" VALUES ('Inflow_Pollutograph', null);
INSERT INTO "inp_value_timserid" VALUES ('Rainfall', null);
INSERT INTO "inp_value_timserid" VALUES ('Temperature', null);
 

-- ----------------------------
-- Records of inp_value_treatment
-- ----------------------------
 
INSERT INTO "inp_value_treatment" VALUES ('CONCEN');
INSERT INTO "inp_value_treatment" VALUES ('RATE');
INSERT INTO "inp_value_treatment" VALUES ('REMOVAL');
 

-- ----------------------------
-- Records of inp_value_washoff
-- ----------------------------
 
INSERT INTO "inp_value_washoff" VALUES ('EMC');
INSERT INTO "inp_value_washoff" VALUES ('EXP');
INSERT INTO "inp_value_washoff" VALUES ('RC');
 

-- ----------------------------
-- Records of inp_value_weirs
-- ----------------------------
 
INSERT INTO "inp_value_weirs" VALUES ('SIDEFLOW', 'RECT_OPEN');
INSERT INTO "inp_value_weirs" VALUES ('TRAPEZOIDAL', 'TRAPEZOIDAL');
INSERT INTO "inp_value_weirs" VALUES ('TRANSVERSE', 'RECT_OPEN');
INSERT INTO "inp_value_weirs" VALUES ('V-NOTCH', 'TRIANGULAR');
 

-- ----------------------------
-- Records of inp_value_yesno
-- ----------------------------
 
INSERT INTO "inp_value_yesno" VALUES ('NO');
INSERT INTO "inp_value_yesno" VALUES ('YES');


-- ----------------------------
-- Records of inp_hydrology
-- ----------------------------
INSERT INTO "cat_hydrology" VALUES (1, 'Infiltration default value', 'CURVE_NUMBER', 'Default value of infiltration');
 
