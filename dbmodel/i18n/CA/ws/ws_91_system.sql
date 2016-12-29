/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('CORBA','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('REDUCCIO','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('LUVE','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('ADAPTACIO','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('UNIO','JUNCTION','JUNCTION', 'man_junction',  'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('FINAL_LINEA','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('X','JUNCTION', 'JUNCTION','man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('T','JUNCTION', 'JUNCTION','man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('AIXETA','JUNCTION', 'JUNCTION', 'man_junction',  'inp_junction,', 'om_visit_x_node');
INSERT INTO node_type VALUES ('TANC','TANK', 'TANK', 'man_tank', 'inp_tank', 'om_visit_x_node');
INSERT INTO node_type VALUES ('HIDRANT','HYDRANT','JUNCTION', 'man_hydrant', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA VERDA','VALVE','JUNCTION', 'man_valve', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA D''AIRE','VALVE','JUNCTION', 'man_valve', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA DESCARREGA','VALVE', 'JUNCTION', 'man_valve',  'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('MESURADOR PRESSIO','MEASURE INSTRUMENT', 'JUNCTION', 'man_meter',  'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA DE PAS','VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA RETENCIO','VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA REDUCTORA','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PR-SUSTA.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PR-BREAK.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('FL-CONTR.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA PAPALLONA','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('GEN-PURP.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('EBAP','PUMP', 'PUMP', 'man_pump', 'inp_pump', 'om_visit_x_node');
INSERT INTO node_type VALUES ('FILTRE','FILTER', 'SHORTPIPE', 'man_filter', 'inp_shortpipe','om_visit_x_node');
INSERT INTO node_type VALUES ('CABALIMETRE','MEASURE INSTRUMENT', 'PIPE', 'man_meter', 'inp_pipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('POU', 'JUNCTION', 'JUNCTION', 'man_waterwell', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('CAPTACIO', 'JUNCTION', 'JUNCTION', 'man_source', 'inp_junction', 'om_visit_x_node');

-- ----------------------------
-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('TUBERIA','PIPE','PIPE', 'man_pipe', 'inp_pipe', 'om_visit_x_arc');


-- ----------------------------
-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('ESCOMESA', 'WJOIN', 'man_wjoin', 'om_visit_x_connec');
INSERT INTO connec_type VALUES ('BOCA_DE_REG', 'GREEN TAP', 'man_greentap', 'om_visit_x_connec');
INSERT INTO connec_type VALUES ('FONT_ORNAMENTAL', 'FOUNTAIN', 'man_fountain', 'om_visit_x_connec');
INSERT INTO connec_type VALUES ('FONT_PUBLICA', 'TAP', 'man_tap', 'om_visit_x_connec');


-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('REGISTRE', 'REGISTER');
INSERT INTO element_type VALUES ('POU', 'MANHOLE');
INSERT INTO element_type VALUES ('TAPA', 'COVER');
INSERT INTO element_type VALUES ('PATE', 'STEP');
