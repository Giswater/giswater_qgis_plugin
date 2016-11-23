/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('CORBA','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('REDUCCIO','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('LUVE','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('ADAPTACIO','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('UNIO','JUNCTION','JUNCTION', 'man_junction',  'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('FINAL_LINEA','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('X','JUNCTION', 'JUNCTION','man_junction', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('T','JUNCTION', 'JUNCTION','man_junction', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('AIXETA','JUNCTION', 'JUNCTION', 'man_junction',  'inp_junction,', 'event_x_node');
INSERT INTO node_type VALUES ('TANC','TANK', 'TANK', 'man_tank', 'inp_tank', 'event_x_node');
INSERT INTO node_type VALUES ('HIDRANT','HYDRANT','JUNCTION', 'man_hydrant', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('VALVULA VERDA','VALVE','JUNCTION', 'man_valve', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('VALVULA D''AIRE','VALVE','JUNCTION', 'man_valve', 'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('VALVULA DESCARREGA','VALVE', 'JUNCTION', 'man_valve',  'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('MESURADOR PRESSIO','MEASURE INSTRUMENT', 'JUNCTION', 'man_meter',  'inp_junction', 'event_x_node');
INSERT INTO node_type VALUES ('VALVULA DE PAS','VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', 'event_x_node');
INSERT INTO node_type VALUES ('VALVULA RETENCIO','VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', 'event_x_node');
INSERT INTO node_type VALUES ('VALVULA REDUCTORA','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'event_x_node');
INSERT INTO node_type VALUES ('PR-SUSTA.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'event_x_node');
INSERT INTO node_type VALUES ('PR-BREAK.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'event_x_node');
INSERT INTO node_type VALUES ('FL-CONTR.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'event_x_node');
INSERT INTO node_type VALUES ('VALVULA PAPALLONA','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'event_x_node');
INSERT INTO node_type VALUES ('GEN-PURP.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'event_x_node');
INSERT INTO node_type VALUES ('EBAP','PUMP', 'PUMP', 'man_pump', 'inp_pump', 'event_x_node');
INSERT INTO node_type VALUES ('FILTRE','FILTER', 'SHORTPIPE', 'man_filter', 'inp_shortpipe','event_x_node');
INSERT INTO node_type VALUES ('CABALIMETRE','MEASURE INSTRUMENT', 'PIPE', 'man_meter', 'inp_pipe', 'event_x_node');


-- ----------------------------
-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('TUBERIA','PIPE','PIPE', 'man_pipe', 'inp_pipe', 'event_x_arc');


-- ----------------------------
-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('DOMESTIC', 'DOMESTIC', 'man_wjoin', 'event_x_connec);



-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('REGISTRE', 'event_x_element');
INSERT INTO element_type VALUES ('POU', 'event_x_element');
INSERT INTO element_type VALUES ('TAPA', 'event_x_element');
INSERT INTO element_type VALUES ('PAS', 'event_x_element');

