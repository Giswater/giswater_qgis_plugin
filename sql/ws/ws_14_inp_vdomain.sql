/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of inp_arc_type
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_arc_type" VALUES ('PIPE');
INSERT INTO "SCHEMA_NAME"."inp_arc_type" VALUES ('NOT DEFINED');

-- ----------------------------
-- Records of inp_node_type
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_node_type" VALUES ('JUNCTION');
INSERT INTO "SCHEMA_NAME"."inp_node_type" VALUES ('RESERVOIR');
INSERT INTO "SCHEMA_NAME"."inp_node_type" VALUES ('TANK');
INSERT INTO "SCHEMA_NAME"."inp_node_type" VALUES ('PUMP');
INSERT INTO "SCHEMA_NAME"."inp_node_type" VALUES ('VALVE');
INSERT INTO "SCHEMA_NAME"."inp_node_type" VALUES ('SHORTPIPE');
INSERT INTO "SCHEMA_NAME"."inp_node_type" VALUES ('NOT DEFINED');


-- ----------------------------
-- Records of inp_typevalue_energy
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_typevalue_energy" VALUES ('DEMAND CHARGE');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_energy" VALUES ('GLOBAL');
 

-- ----------------------------
-- Records of inp_typevalue_pump
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_typevalue_pump" VALUES ('HEAD');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_pump" VALUES ('PATTERN');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_pump" VALUES ('POWER');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_pump" VALUES ('SPEED');
 

-- ----------------------------
-- Records of inp_typevalue_reactions_gl
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_typevalue_reactions_gl" VALUES ('GLOBAL');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_reactions_gl" VALUES ('LIMITING POTENTIAL');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_reactions_gl" VALUES ('ORDER');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_reactions_gl" VALUES ('ROUGHNESS CORRELATION');
 

-- ----------------------------
-- Records of inp_typevalue_source
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_typevalue_source" VALUES ('CONCEN');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_source" VALUES ('FLOWPACED');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_source" VALUES ('MASS');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_source" VALUES ('SETPOINT');
 

-- ----------------------------
-- Records of inp_typevalue_valve
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_typevalue_valve" VALUES ('FCV', 'Flow Control Valve', 'Flow');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_valve" VALUES ('PBV', 'Pressure Break Valve', 'Pressure');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_valve" VALUES ('PRV', 'Pressure Reduction Valve', 'Pressure');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_valve" VALUES ('PSV', 'Pressure Sustain Valve', 'Pressure');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_valve" VALUES ('TCV', ' Throttle Control Valve', 'Losses');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_valve" VALUES ('VPG', 'General Purpose Valve', 'Losses');
INSERT INTO "SCHEMA_NAME"."inp_typevalue_valve" VALUES ('GTV', 'Gate Valve', 'Control'); 


-- ----------------------------
-- Records of inp_value_ampm
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_ampm" VALUES ('AM');
INSERT INTO "SCHEMA_NAME"."inp_value_ampm" VALUES ('PM');
 

-- ----------------------------
-- Records of inp_value_curve
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('EFFICIENCY');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('HEADLOSS');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('PUMP');
INSERT INTO "SCHEMA_NAME"."inp_value_curve" VALUES ('VOLUME');
 

-- ----------------------------
-- Records of inp_value_mixing
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_mixing" VALUES ('2COMP');
INSERT INTO "SCHEMA_NAME"."inp_value_mixing" VALUES ('FIFO');
INSERT INTO "SCHEMA_NAME"."inp_value_mixing" VALUES ('LIFO');
INSERT INTO "SCHEMA_NAME"."inp_value_mixing" VALUES ('MIXED');
 

-- ----------------------------
-- Records of inp_value_noneall
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_noneall" VALUES ('ALL');
INSERT INTO "SCHEMA_NAME"."inp_value_noneall" VALUES ('NONE');
 

-- ----------------------------
-- Records of inp_value_opti_headloss
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_opti_headloss" VALUES ('C-M');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_headloss" VALUES ('D-W');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_headloss" VALUES ('H-W');
 

-- ----------------------------
-- Records of inp_value_opti_hyd
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_opti_hyd" VALUES ('');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_hyd" VALUES ('SAVE');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_hyd" VALUES ('USE');
 

-- ----------------------------
-- Records of inp_value_opti_qual
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_opti_qual" VALUES ('AGE');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_qual" VALUES ('CHEMICAL mg/L');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_qual" VALUES ('CHEMICAL ug/L');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_qual" VALUES ('NONE');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_qual" VALUES ('TRACE');
 

-- ----------------------------
-- Records of inp_value_opti_unb
-- ----------------------------
 
 

-- ----------------------------
-- Records of inp_value_opti_unbal
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_opti_unbal" VALUES ('CONTINUE');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_unbal" VALUES ('STOP');
 

-- ----------------------------
-- Records of inp_value_opti_units
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_opti_units" VALUES ('AFD');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_units" VALUES ('CMD');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_units" VALUES ('CMH');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_units" VALUES ('GPM');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_units" VALUES ('IMGD');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_units" VALUES ('LPM');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_units" VALUES ('LPS');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_units" VALUES ('MGD');
INSERT INTO "SCHEMA_NAME"."inp_value_opti_units" VALUES ('MLD');
 

-- ----------------------------
-- Records of inp_value_param_energy
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_param_energy" VALUES ('EFFIC');
INSERT INTO "SCHEMA_NAME"."inp_value_param_energy" VALUES ('PATTERN');
INSERT INTO "SCHEMA_NAME"."inp_value_param_energy" VALUES ('PRICE');
 

-- ----------------------------
-- Records of inp_value_reactions_el
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_reactions_el" VALUES ('BULK');
INSERT INTO "SCHEMA_NAME"."inp_value_reactions_el" VALUES ('TANK');
INSERT INTO "SCHEMA_NAME"."inp_value_reactions_el" VALUES ('WALL');
 

-- ----------------------------
-- Records of inp_value_reactions_gl
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_reactions_gl" VALUES ('BULK');
INSERT INTO "SCHEMA_NAME"."inp_value_reactions_gl" VALUES ('TANK');
INSERT INTO "SCHEMA_NAME"."inp_value_reactions_gl" VALUES ('WALL');
 

-- ----------------------------
-- Records of inp_value_status_pipe
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_status_pipe" VALUES ('CLOSED');
INSERT INTO "SCHEMA_NAME"."inp_value_status_pipe" VALUES ('CV');
INSERT INTO "SCHEMA_NAME"."inp_value_status_pipe" VALUES ('OPEN');
 

-- ----------------------------
-- Records of inp_value_status_pump
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_status_pump" VALUES ('CLOSED');
INSERT INTO "SCHEMA_NAME"."inp_value_status_pump" VALUES ('OPEN');


-- ----------------------------
-- Records of inp_value_status_valve
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_status_valve" VALUES ('ACTIVE');
INSERT INTO "SCHEMA_NAME"."inp_value_status_valve" VALUES ('CLOSED');
INSERT INTO "SCHEMA_NAME"."inp_value_status_valve" VALUES ('OPEN');
 

-- ----------------------------
-- Records of inp_value_times
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_times" VALUES ('AVERAGED');
INSERT INTO "SCHEMA_NAME"."inp_value_times" VALUES ('MAXIMUM');
INSERT INTO "SCHEMA_NAME"."inp_value_times" VALUES ('MINIMUM');
INSERT INTO "SCHEMA_NAME"."inp_value_times" VALUES ('NONE');
INSERT INTO "SCHEMA_NAME"."inp_value_times" VALUES ('RANGE');
 

-- ----------------------------
-- Records of inp_value_yesno
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_yesno" VALUES ('NO');
INSERT INTO "SCHEMA_NAME"."inp_value_yesno" VALUES ('YES');
 

-- ----------------------------
-- Records of inp_value_yesnofull
-- ----------------------------
 
INSERT INTO "SCHEMA_NAME"."inp_value_yesnofull" VALUES ('FULL');
INSERT INTO "SCHEMA_NAME"."inp_value_yesnofull" VALUES ('NO');
INSERT INTO "SCHEMA_NAME"."inp_value_yesnofull" VALUES ('YES');




