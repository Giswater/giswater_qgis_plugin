/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-- ----------------------------
-- Records of inp_type_arc
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_type_arc" VALUES ('CONDUIT', 'inp_conduit', null);
INSERT INTO "SCHEMA_NAME"."inp_type_arc" VALUES ('ORIFICE', 'inp_orifice', null);
INSERT INTO "SCHEMA_NAME"."inp_type_arc" VALUES ('OUTLET', 'inp_outlet', null);
INSERT INTO "SCHEMA_NAME"."inp_type_arc" VALUES ('PUMP', 'inp_pump', null);
INSERT INTO "SCHEMA_NAME"."inp_type_arc" VALUES ('WEIR', 'inp_weir', null);
COMMIT;

-- ----------------------------
-- Records of inp_type_node
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_type_node" VALUES ('DIVIDER', 'inp_divider', null);
INSERT INTO "SCHEMA_NAME"."inp_type_node" VALUES ('JUNCTION', 'inp_junction', null);
INSERT INTO "SCHEMA_NAME"."inp_type_node" VALUES ('OUTFALL', 'inp_outfall', null);
INSERT INTO "SCHEMA_NAME"."inp_type_node" VALUES ('STORAGE', 'inp_storage', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_divider
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_divider" VALUES ('CUTOFF', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_divider" VALUES ('OVERFLOW', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_divider" VALUES ('TABULAR', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_divider" VALUES ('WEIR', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_evap
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_evap" VALUES ('CONSTANT', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_evap" VALUES ('FILE', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_evap" VALUES ('MONTHLY', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_evap" VALUES ('RECOVERY', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_evap" VALUES ('TEMPERATURE', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_evap" VALUES ('TIMESERIES', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_orifice
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_orifice" VALUES ('BOTTOM', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_orifice" VALUES ('SIDE', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_outfall
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_outfall" VALUES ('FIXED', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_outfall" VALUES ('FREE', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_outfall" VALUES ('NORMAL', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_outfall" VALUES ('TIDAL', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_outfall" VALUES ('TIMESERIES', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_outlet
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_outlet" VALUES ('FUNCTIONAL/DEPTH', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_outlet" VALUES ('FUNCTIONAL/HEAD', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_outlet" VALUES ('TABULAR/DEPTH', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_outlet" VALUES ('TABULAR/HEAD', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_pattern
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_pattern" VALUES ('DAILY', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_pattern" VALUES ('HOURLY', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_pattern" VALUES ('MONTHLY', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_pattern" VALUES ('WEEKEND', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_raingage
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_raingage" VALUES ('FILE', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_raingage" VALUES ('TIMESERIES', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_storage
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_storage" VALUES ('FUCTIONAL', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_storage" VALUES ('TABULAR', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_temp
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_temp" VALUES ('FILE', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_temp" VALUES ('TIMESERIES', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_timeseries
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_timeseries" VALUES ('ABSOLUTE', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_timeseries" VALUES ('FILE', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_timeseries" VALUES ('RELATIVE', null);
COMMIT;

-- ----------------------------
-- Records of inp_typevalue_windsp
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_typevalue_windsp" VALUES ('FILE', null);
INSERT INTO "SCHEMA_NAME"."inp_typevalue_windsp" VALUES ('MONTHLY', null);
COMMIT;

-- ----------------------------
-- Records of inp_value_allnone
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_allnone" VALUES ('ALL');
INSERT INTO "SCHEMA_NAME"."inp_value_allnone" VALUES ('NONE');
COMMIT;

-- ----------------------------
-- Records of inp_value_arccat
-- ----------------------------

BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('CIRCULAR');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('FILLED_CIRCULAR');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('RECT_CLOSED');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('RECT_OPEN');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('TRAPEZOIDAL');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('TRIANGULAR');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('HORIZ_ELLIPSE');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('ARCH');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('PARABOLIC');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('POWER');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('RECT_TRIANGULAR');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('RECT_ROUND');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('MODBASKETHANDLE');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('EGG');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('HORSESHOE');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('SEMIELLIPTICAL');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('BASKETHANDLE');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('SEMICIRCULAR');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('IRREGULAR');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('CUSTOM');
INSERT INTO "SCHEMA_NAME"."inp_value_catarc" VALUES ('DUMMY');
COMMIT;


-- ----------------------------
-- Records of inp_value_buildup
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_buildup" VALUES ('EXP');
INSERT INTO "SCHEMA_NAME"."inp_value_buildup" VALUES ('EXT');
INSERT INTO "SCHEMA_NAME"."inp_value_buildup" VALUES ('POW');
INSERT INTO "SCHEMA_NAME"."inp_value_buildup" VALUES ('SAT');
COMMIT;

-- ----------------------------
-- Records of inp_value_curve
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('CONTROL');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('DIVERSION');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('PUMP1');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('PUMP2');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('PUMP3');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('PUMP4');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('RATING');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('SHAPE');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('STORAGE');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('TIDAL');
COMMIT;

-- ----------------------------
-- Records of inp_value_files_actio
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_files_actio" VALUES ('SAVE');
INSERT INTO "SCHEMA_NAME"."inp_value_files_actio" VALUES ('USE');
COMMIT;

-- ----------------------------
-- Records of inp_value_files_type
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_files_type" VALUES ('HOTSTART');
INSERT INTO "SCHEMA_NAME"."inp_value_files_type" VALUES ('INFLOWS');
INSERT INTO "SCHEMA_NAME"."inp_value_files_type" VALUES ('OUTFLOWS');
INSERT INTO "SCHEMA_NAME"."inp_value_files_type" VALUES ('RAINFALL');
INSERT INTO "SCHEMA_NAME"."inp_value_files_type" VALUES ('RDII');
INSERT INTO "SCHEMA_NAME"."inp_value_files_type" VALUES ('RUNOFF');
COMMIT;

-- ----------------------------
-- Records of inp_value_inflows
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_inflows" VALUES ('CONCEN');
INSERT INTO "SCHEMA_NAME"."inp_value_inflows" VALUES ('MASS');
COMMIT;

-- ----------------------------
-- Records of inp_value_lidcontrol
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_lidcontrol" VALUES ('DRAIN');
INSERT INTO "SCHEMA_NAME"."inp_value_lidcontrol" VALUES ('PAVEMENT');
INSERT INTO "SCHEMA_NAME"."inp_value_lidcontrol" VALUES ('SOIL');
INSERT INTO "SCHEMA_NAME"."inp_value_lidcontrol" VALUES ('STORAGE');
INSERT INTO "SCHEMA_NAME"."inp_value_lidcontrol" VALUES ('SURFACE');
COMMIT;

-- ----------------------------
-- Records of inp_value_mapunits
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_mapunits" VALUES ('DEGREES');
INSERT INTO "SCHEMA_NAME"."inp_value_mapunits" VALUES ('FEET');
INSERT INTO "SCHEMA_NAME"."inp_value_mapunits" VALUES ('METERS');
INSERT INTO "SCHEMA_NAME"."inp_value_mapunits" VALUES ('NONE');
COMMIT;

-- ----------------------------
-- Records of inp_value_options_fme
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_options_fme" VALUES ('D-W');
INSERT INTO "SCHEMA_NAME"."inp_value_options_fme" VALUES ('H-W');
COMMIT;

-- ----------------------------
-- Records of inp_value_options_fr
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_options_fr" VALUES ('DYNWAVE');
INSERT INTO "SCHEMA_NAME"."inp_value_options_fr" VALUES ('KINWAVE');
INSERT INTO "SCHEMA_NAME"."inp_value_options_fr" VALUES ('STEADY');
COMMIT;

-- ----------------------------
-- Records of inp_value_options_fu
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_options_fu" VALUES ('CFS');
INSERT INTO "SCHEMA_NAME"."inp_value_options_fu" VALUES ('CMS');
INSERT INTO "SCHEMA_NAME"."inp_value_options_fu" VALUES ('GPM');
INSERT INTO "SCHEMA_NAME"."inp_value_options_fu" VALUES ('LPS');
INSERT INTO "SCHEMA_NAME"."inp_value_options_fu" VALUES ('MGD');
INSERT INTO "SCHEMA_NAME"."inp_value_options_fu" VALUES ('MLD');
COMMIT;

-- ----------------------------
-- Records of inp_value_options_id
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_options_id" VALUES ('FULL');
INSERT INTO "SCHEMA_NAME"."inp_value_options_id" VALUES ('NONE');
INSERT INTO "SCHEMA_NAME"."inp_value_options_id" VALUES ('PARTIAL');
COMMIT;

-- ----------------------------
-- Records of inp_value_options_in
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_options_in" VALUES ('CURVE_NUMBER');
INSERT INTO "SCHEMA_NAME"."inp_value_options_in" VALUES ('GREEN_AMPT');
INSERT INTO "SCHEMA_NAME"."inp_value_options_in" VALUES ('HORTON');
COMMIT;

-- ----------------------------
-- Records of inp_value_options_lo
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_options_lo" VALUES ('DEPTH');
INSERT INTO "SCHEMA_NAME"."inp_value_options_lo" VALUES ('ELEVATION');
COMMIT;

-- ----------------------------
-- Records of inp_value_options_nfl
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_options_nfl" VALUES ('BOTH');
INSERT INTO "SCHEMA_NAME"."inp_value_options_nfl" VALUES ('FROUD');
INSERT INTO "SCHEMA_NAME"."inp_value_options_nfl" VALUES ('SLOPE');
COMMIT;

-- ----------------------------
-- Records of inp_value_orifice
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_orifice" VALUES ('CIRCULAR');
INSERT INTO "SCHEMA_NAME"."inp_value_orifice" VALUES ('RECT-CLOSED');
COMMIT;

-- ----------------------------
-- Records of inp_value_pollutants
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_pollutants" VALUES ('#/L');
INSERT INTO "SCHEMA_NAME"."inp_value_pollutants" VALUES ('MG/L');
INSERT INTO "SCHEMA_NAME"."inp_value_pollutants" VALUES ('UG/L');
COMMIT;

-- ----------------------------
-- Records of inp_value_raingage
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_raingage" VALUES ('CUMULATIVE');
INSERT INTO "SCHEMA_NAME"."inp_value_raingage" VALUES ('INTENSITY');
INSERT INTO "SCHEMA_NAME"."inp_value_raingage" VALUES ('VOLUME');
COMMIT;

-- ----------------------------
-- Records of inp_value_routeto
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_routeto" VALUES ('OUTLET');
INSERT INTO "SCHEMA_NAME"."inp_value_routeto" VALUES ('IMPERVIOUS');
INSERT INTO "SCHEMA_NAME"."inp_value_routeto" VALUES ('PERVIOUS');
COMMIT;


-- ----------------------------
-- Records of inp_value_status
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_status" VALUES ('ON');
INSERT INTO "SCHEMA_NAME"."inp_value_status" VALUES ('OFF');
COMMIT;

-- ----------------------------
-- Records of inp_value_timserid
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_timserid" VALUES ('Evaporation', null);
INSERT INTO "SCHEMA_NAME"."inp_value_timserid" VALUES ('Inflow_Hydrograph', null);
INSERT INTO "SCHEMA_NAME"."inp_value_timserid" VALUES ('Inflow_Pollutograph', null);
INSERT INTO "SCHEMA_NAME"."inp_value_timserid" VALUES ('Rainfall', null);
INSERT INTO "SCHEMA_NAME"."inp_value_timserid" VALUES ('Temperature', null);
COMMIT;

-- ----------------------------
-- Records of inp_value_treatment
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_treatment" VALUES ('CONCEN');
INSERT INTO "SCHEMA_NAME"."inp_value_treatment" VALUES ('RATE');
INSERT INTO "SCHEMA_NAME"."inp_value_treatment" VALUES ('REMOVAL');
COMMIT;

-- ----------------------------
-- Records of inp_value_washoff
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_washoff" VALUES ('EMC');
INSERT INTO "SCHEMA_NAME"."inp_value_washoff" VALUES ('EXP');
INSERT INTO "SCHEMA_NAME"."inp_value_washoff" VALUES ('RC');
COMMIT;

-- ----------------------------
-- Records of inp_value_weirs
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_weirs" VALUES ('SIDEFLOW', 'RECT_OPEN');
INSERT INTO "SCHEMA_NAME"."inp_value_weirs" VALUES ('TRAPEZOIDAL', 'TRAPEZOIDAL');
INSERT INTO "SCHEMA_NAME"."inp_value_weirs" VALUES ('TRASVERSE', 'RECT_OPEN');
INSERT INTO "SCHEMA_NAME"."inp_value_weirs" VALUES ('V-NOTCH', 'TRIANGULAR');
COMMIT;

-- ----------------------------
-- Records of inp_value_yesno
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_value_yesno" VALUES ('NO');
INSERT INTO "SCHEMA_NAME"."inp_value_yesno" VALUES ('YES');
COMMIT;

-- ----------------------------
-- Records of inp_options
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_options" VALUES ('CMS', 'CURVE_NUMBER', 'DYNWAVE', 'DEPTH', 'H-W', 'NO', 'NO', 'NO', 'NO', 'NO', 'NO', '01/01/2001', '00:00:00', '01/01/2001', '05:00:00', '01/01/2001', '00:00:00', '01/01', '12/31', '10', '00:15:00', '00:05:00', '01:00:00', '00:00:03', null, null, 'NONE', 'BOTH', '0', '0', 'YES', null);
COMMIT;

-- ----------------------------
-- Records of inp_report
-- ----------------------------
BEGIN;
INSERT INTO "SCHEMA_NAME"."inp_report" VALUES ('YES', 'YES', 'YES', 'YES', 'ALL', 'ALL', 'ALL');
COMMIT;


-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------


