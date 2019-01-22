/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of inp_options
-- ----------------------------
 
INSERT INTO inp_options VALUES (1,'LPS', 'H-W', NULL, 1.000000, 1.000000, 40.000000, 0.001000, 'CONTINUE', 2.000000, 10.000000, 0.000000, '1', 1.000000, 0.500000, 'NONE', 1.000000, 0.010000, '', 40.000000, NULL, 'EPA TABLES', NULL, 'f', NULL, NULL);


-- ----------------------------
-- Records of inp_value_opti_valvemodeoptions
-- ----------------------------
INSERT INTO "inp_value_opti_valvemode" VALUES ('EPA TABLES');
INSERT INTO "inp_value_opti_valvemode" VALUES ('INVENTORY VALUES');
INSERT INTO "inp_value_opti_valvemode" VALUES ('MINCUT RESULTS');


-- ----------------------------
-- Records of inp_value_opti_rtc_coef
-- ----------------------------
INSERT INTO "inp_value_opti_rtc_coef" VALUES ('MIN');
INSERT INTO "inp_value_opti_rtc_coef" VALUES ('AVG');
INSERT INTO "inp_value_opti_rtc_coef" VALUES ('MAX');



-- ----------------------------
-- Records of inp_report
-- ----------------------------
 
INSERT INTO "inp_report" VALUES ('0', '', 'YES', 'YES', 'YES', 'ALL', 'ALL', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES');
 

-- ----------------------------
-- Records of inp_times
-- ----------------------------
 
INSERT INTO "inp_times" VALUES (1,'24', '0:30', '0:06', '0:05', '1:00', '0:00', '1:00', '0:00', '12', 'NONE');


-- ----------------------------
-- Records of inp_arc_type
-- ----------------------------
 
INSERT INTO "inp_arc_type" VALUES ('PIPE');
INSERT INTO "inp_arc_type" VALUES ('NOT DEFINED');

-- ----------------------------
-- Records of inp_node_type
-- ----------------------------
 
INSERT INTO "inp_node_type" VALUES ('JUNCTION');
INSERT INTO "inp_node_type" VALUES ('RESERVOIR');
INSERT INTO "inp_node_type" VALUES ('TANK');
INSERT INTO "inp_node_type" VALUES ('PUMP');
INSERT INTO "inp_node_type" VALUES ('VALVE');
INSERT INTO "inp_node_type" VALUES ('SHORTPIPE');
INSERT INTO "inp_node_type" VALUES ('NOT DEFINED');


-- ----------------------------
-- Records of inp_typevalue_energy
-- ----------------------------
 
INSERT INTO "inp_typevalue_energy" VALUES ('DEMAND CHARGE');
INSERT INTO "inp_typevalue_energy" VALUES ('GLOBAL');
 

-- ----------------------------
-- Records of inp_typevalue_pump
-- ----------------------------
 
INSERT INTO "inp_typevalue_pump" VALUES ('HEAD');
INSERT INTO "inp_typevalue_pump" VALUES ('PATTERN');
INSERT INTO "inp_typevalue_pump" VALUES ('POWER');
INSERT INTO "inp_typevalue_pump" VALUES ('SPEED');
 

-- ----------------------------
-- Records of inp_typevalue_reactions_gl
-- ----------------------------
 
INSERT INTO "inp_typevalue_reactions_gl" VALUES ('GLOBAL');
INSERT INTO "inp_typevalue_reactions_gl" VALUES ('LIMITING POTENTIAL');
INSERT INTO "inp_typevalue_reactions_gl" VALUES ('ORDER');
INSERT INTO "inp_typevalue_reactions_gl" VALUES ('ROUGHNESS CORRELATION');
 

-- ----------------------------
-- Records of inp_typevalue_source
-- ----------------------------
 
INSERT INTO "inp_typevalue_source" VALUES ('CONCEN');
INSERT INTO "inp_typevalue_source" VALUES ('FLOWPACED');
INSERT INTO "inp_typevalue_source" VALUES ('MASS');
INSERT INTO "inp_typevalue_source" VALUES ('SETPOINT');
 

-- ----------------------------
-- Records of inp_typevalue_valve
-- ----------------------------
 
INSERT INTO "inp_typevalue_valve" VALUES ('FCV', 'Flow Control Valve', 'Flow');
INSERT INTO "inp_typevalue_valve" VALUES ('PBV', 'Pressure Break Valve', 'Pressure');
INSERT INTO "inp_typevalue_valve" VALUES ('PRV', 'Pressure Reduction Valve', 'Pressure');
INSERT INTO "inp_typevalue_valve" VALUES ('PSV', 'Pressure Sustain Valve', 'Pressure');
INSERT INTO "inp_typevalue_valve" VALUES ('TCV', 'Throttle Control Valve', 'Losses');
INSERT INTO "inp_typevalue_valve" VALUES ('GPV', 'General Purpose Valve', 'Losses');


-- ----------------------------
-- Records of inp_value_ampm
-- ----------------------------
 
INSERT INTO "inp_value_ampm" VALUES ('AM');
INSERT INTO "inp_value_ampm" VALUES ('PM');
 

-- ----------------------------
-- Records of inp_value_curve
-- ----------------------------
 
INSERT INTO "inp_value_curve" VALUES ('EFFICIENCY');
INSERT INTO "inp_value_curve" VALUES ('HEADLOSS');
INSERT INTO "inp_value_curve" VALUES ('PUMP');
INSERT INTO "inp_value_curve" VALUES ('VOLUME');
 

-- ----------------------------
-- Records of inp_value_mixing
-- ----------------------------
 
INSERT INTO "inp_value_mixing" VALUES ('2COMP');
INSERT INTO "inp_value_mixing" VALUES ('FIFO');
INSERT INTO "inp_value_mixing" VALUES ('LIFO');
INSERT INTO "inp_value_mixing" VALUES ('MIXED');
 

-- ----------------------------
-- Records of inp_value_noneall
-- ----------------------------
 
INSERT INTO "inp_value_noneall" VALUES ('ALL');
INSERT INTO "inp_value_noneall" VALUES ('NONE');
 

-- ----------------------------
-- Records of inp_value_opti_headloss
-- ----------------------------
 
INSERT INTO "inp_value_opti_headloss" VALUES ('C-M');
INSERT INTO "inp_value_opti_headloss" VALUES ('D-W');
INSERT INTO "inp_value_opti_headloss" VALUES ('H-W');
 

-- ----------------------------
-- Records of inp_value_opti_hyd
-- ----------------------------
 
INSERT INTO "inp_value_opti_hyd" VALUES (' ');
INSERT INTO "inp_value_opti_hyd" VALUES ('SAVE');
INSERT INTO "inp_value_opti_hyd" VALUES ('USE');
 

-- ----------------------------
-- Records of inp_value_opti_qual
-- ----------------------------
 
INSERT INTO "inp_value_opti_qual" VALUES ('AGE');
INSERT INTO "inp_value_opti_qual" VALUES ('CHEMICAL mg/L');
INSERT INTO "inp_value_opti_qual" VALUES ('CHEMICAL ug/L');
INSERT INTO "inp_value_opti_qual" VALUES ('NONE');
INSERT INTO "inp_value_opti_qual" VALUES ('TRACE');
 

-- ----------------------------
-- Records of inp_value_opti_unb
-- ----------------------------
 
 

-- ----------------------------
-- Records of inp_value_opti_unbal
-- ----------------------------
 
INSERT INTO "inp_value_opti_unbal" VALUES ('CONTINUE');
INSERT INTO "inp_value_opti_unbal" VALUES ('STOP');
 

-- ----------------------------
-- Records of inp_value_opti_units
-- ----------------------------
 
INSERT INTO "inp_value_opti_units" VALUES ('AFD');
INSERT INTO "inp_value_opti_units" VALUES ('CMD');
INSERT INTO "inp_value_opti_units" VALUES ('CMH');
INSERT INTO "inp_value_opti_units" VALUES ('GPM');
INSERT INTO "inp_value_opti_units" VALUES ('IMGD');
INSERT INTO "inp_value_opti_units" VALUES ('LPM');
INSERT INTO "inp_value_opti_units" VALUES ('LPS');
INSERT INTO "inp_value_opti_units" VALUES ('MGD');
INSERT INTO "inp_value_opti_units" VALUES ('MLD');
 

-- ----------------------------
-- Records of inp_value_param_energy
-- ----------------------------
 
INSERT INTO "inp_value_param_energy" VALUES ('EFFIC');
INSERT INTO "inp_value_param_energy" VALUES ('PATTERN');
INSERT INTO "inp_value_param_energy" VALUES ('PRICE');
 

-- ----------------------------
-- Records of inp_value_reactions_el
-- ----------------------------
 
INSERT INTO "inp_value_reactions_el" VALUES ('BULK');
INSERT INTO "inp_value_reactions_el" VALUES ('TANK');
INSERT INTO "inp_value_reactions_el" VALUES ('WALL');
 

-- ----------------------------
-- Records of inp_value_reactions_gl
-- ----------------------------
 
INSERT INTO "inp_value_reactions_gl" VALUES ('BULK');
INSERT INTO "inp_value_reactions_gl" VALUES ('TANK');
INSERT INTO "inp_value_reactions_gl" VALUES ('WALL');
 

-- ----------------------------
-- Records of inp_value_status_pipe
-- ----------------------------
 
INSERT INTO "inp_value_status_pipe" VALUES ('CLOSED');
INSERT INTO "inp_value_status_pipe" VALUES ('CV');
INSERT INTO "inp_value_status_pipe" VALUES ('OPEN');
 

-- ----------------------------
-- Records of inp_value_status_pump
-- ----------------------------
 
INSERT INTO "inp_value_status_pump" VALUES ('CLOSED');
INSERT INTO "inp_value_status_pump" VALUES ('OPEN');


-- ----------------------------
-- Records of inp_value_status_valve
-- ----------------------------
 
INSERT INTO "inp_value_status_valve" VALUES ('ACTIVE');
INSERT INTO "inp_value_status_valve" VALUES ('CLOSED');
INSERT INTO "inp_value_status_valve" VALUES ('OPEN');
 

-- ----------------------------
-- Records of inp_value_times
-- ----------------------------
 
INSERT INTO "inp_value_times" VALUES ('AVERAGED');
INSERT INTO "inp_value_times" VALUES ('MAXIMUM');
INSERT INTO "inp_value_times" VALUES ('MINIMUM');
INSERT INTO "inp_value_times" VALUES ('NONE');
INSERT INTO "inp_value_times" VALUES ('RANGE');
 

-- ----------------------------
-- Records of inp_value_yesno
-- ----------------------------
 
INSERT INTO "inp_value_yesno" VALUES ('NO');
INSERT INTO "inp_value_yesno" VALUES ('YES');
 

-- ----------------------------
-- Records of inp_value_yesnofull
-- ----------------------------
 
INSERT INTO "inp_value_yesnofull" VALUES ('FULL');
INSERT INTO "inp_value_yesnofull" VALUES ('NO');
INSERT INTO "inp_value_yesnofull" VALUES ('YES');




