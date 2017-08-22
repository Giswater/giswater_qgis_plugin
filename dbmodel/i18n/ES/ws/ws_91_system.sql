/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Records of config system table
-- ----------------------------

-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('CURVA','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('REDUCCION','REDUCTION','JUNCTION', 'man_reduction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('ADAPTACION','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('UNION','JUNCTION','JUNCTION', 'man_junction',  'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('LINEA_DE_FONDO','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('X','JUNCTION', 'JUNCTION','man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('T','JUNCTION', 'JUNCTION','man_junction', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('GRIFO','JUNCTION', 'JUNCTION', 'man_junction',  'inp_junction,', 'om_visit_x_node');
INSERT INTO node_type VALUES ('TANQUE','TANK', 'TANK', 'man_tank', 'inp_tank', 'om_visit_x_node');
INSERT INTO node_type VALUES ('HIDRANTE','HYDRANT','JUNCTION', 'man_hydrant', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA VERDE','VALVE','JUNCTION', 'man_valve', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA DE AIRE','VALVE','JUNCTION', 'man_valve', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA DE DESAGUE','VALVE', 'JUNCTION', 'man_valve',  'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('MESURADOR DE PRESSION','MEASURE INSTRUMENT', 'JUNCTION', 'man_meter',  'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA DE CIERRE','VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA DE RETENCION','VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PR-REDUC.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PR-SUSTA.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('PR-BREAK.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('FL-CONTR.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VALVULA DE MARIPOSA','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('GEN-PURP.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('ESTACION DE BOMBAMIENTO','PUMP', 'PUMP', 'man_pump', 'inp_pump', 'om_visit_x_node');
INSERT INTO node_type VALUES ('FILTRO','FILTER', 'SHORTPIPE', 'man_filter', 'inp_shortpipe','om_visit_x_node');
INSERT INTO node_type VALUES ('CAUDALIMETRO','MEASURE INSTRUMENT', 'SHORTPIPE', 'man_meter', 'inp_shrtpipe', 'om_visit_x_node');
INSERT INTO node_type VALUES ('POZO', 'JUNCTION', 'JUNCTION', 'man_manhole', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('CAPTACION', 'SOURCE', 'JUNCTION', 'man_source', 'inp_junction', 'om_visit_x_node');

-- ----------------------------
-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('TUBO','PIPE','PIPE', 'man_pipe', 'inp_pipe', 'om_visit_x_arc');


-- ----------------------------
-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('ACOMETIDA', 'WJOIN', 'man_wjoin', 'event_x_connec');
INSERT INTO connec_type VALUES ('BOCA_DE_RIEGO', 'GREEN TAP', 'man_greentap', 'om_visit_x_connec');
INSERT INTO connec_type VALUES ('FUENTE_ORNAMENTAL', 'FOUNTAIN', 'man_fountain', 'om_visit_x_connec');
INSERT INTO connec_type VALUES ('FUENTE_PUBLICA', 'TAP', 'man_tap', 'om_visit_x_connec');
-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('REGISTRO','REGISTER');
INSERT INTO element_type VALUES ('POZO', 'MANHOLE');
INSERT INTO element_type VALUES ('TAPA', 'COVER');
INSERT INTO element_type VALUES ('PATE', 'STEP');


