/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('ESC SIMPLE', 'WJOIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('ESC MULTIPLE', 'WJOIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('ESC ANTIINCENDIS', 'WJOIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FONT ORNAMENTAL', 'FOUNTAIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FONT PUBLICA', 'TAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('BOCA DE REG', 'GREENTAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('PUNT DE MOSTREIG', 'NETSAMPLEPOINT', 'NODE');
INSERT INTO cat_feature VALUES ('NETELEMENT', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('ESTACIÓ TRACTAMENT', 'WTP', 'NODE');
INSERT INTO cat_feature VALUES ('TUBERIA', 'PIPE', 'ARC');
INSERT INTO cat_feature VALUES ('VARC', 'VARC', 'ARC');
INSERT INTO cat_feature VALUES ('VALVULA CONTROL', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA REDUCTORA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA VERDA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('CORBA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FILTRE', 'FILTER', 'NODE');
INSERT INTO cat_feature VALUES ('FINAL LINEA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FL-CONTR.VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('GEN-PURP.VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('HYDRANT', 'HYDRANT', 'NODE');
INSERT INTO cat_feature VALUES ('PR-BREAK.VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('OUTFALL-VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('UNIO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VALV. SOSTENIDORA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('SHUTOFF-VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('REDUCCIO', 'REDUCTION', 'NODE');
INSERT INTO cat_feature VALUES ('BOMBA POU', 'PUMP', 'NODE');
INSERT INTO cat_feature VALUES ('BOMBA GRUP PRESSIO', 'PUMP', 'NODE');
INSERT INTO cat_feature VALUES ('DIPOSIT', 'TANK', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA ACCELERACIÓ', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA COMPORTA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('TE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('TAP', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('X', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CAPTACIO', 'SOURCE', 'NODE');
INSERT INTO cat_feature VALUES ('POU DE CAPTACIÓ', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRE', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('CONTROL-REGISTRE', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('BYPASS-REGISTRE', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA-REGISTRE', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('ESCOMESA DE XARXA', 'NETWJOIN', 'NODE');
INSERT INTO cat_feature VALUES ('UNIÓ FLEXIBLE', 'FLEXUNION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA D''AIRE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA VENTOSA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('MEDIDOR DE FLUID', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('TANC D''EXPANSIÓ', 'EXPANSIONTANK', 'NODE');
INSERT INTO cat_feature VALUES ('MESURADOR PRESSIO', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('ADAPTACIO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('AIGUA ALTA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('LUVE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('AIXETA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('HIDRANT', 'HYDRANT', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA DESCARREGA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA DE PAS', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA RETENCIO', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA PAPALLONA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('CABALIMETRE', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('COMPTADOR', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('MANOMETRE', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('MINA', 'WATERWELL', 'NODE');
INSERT INTO cat_feature VALUES ('POU', 'WATERWELL', 'NODE');

-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('CORBA','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Corba');
INSERT INTO node_type VALUES ('REDUCCIO','REDUCTION','JUNCTION', 'man_reduction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Reducció');
INSERT INTO node_type VALUES ('LUVE','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Luve');
INSERT INTO node_type VALUES ('ADAPTACIO','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Adaptació');
INSERT INTO node_type VALUES ('AIGUA ALTA','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Aigua alta');
INSERT INTO node_type VALUES ('UNIO','JUNCTION','JUNCTION', 'man_junction',  'inp_junction', TRUE, TRUE, 2, TRUE, 'Unió');
INSERT INTO node_type VALUES ('FINAL LINEA','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 1, TRUE, 'Final de línea');
INSERT INTO node_type VALUES ('X','JUNCTION', 'JUNCTION','man_junction', 'inp_junction', TRUE, TRUE, 4, TRUE, 'Unió on 4 conductes convergeixen');
INSERT INTO node_type VALUES ('TE','JUNCTION', 'JUNCTION','man_junction', 'inp_junction', TRUE, TRUE, 3, TRUE, 'Unió on 3 conductes convergeixen');
INSERT INTO node_type VALUES ('AIXETA','JUNCTION', 'JUNCTION', 'man_junction',  'inp_junction,', TRUE, TRUE, 2, TRUE, 'Aixeta');
INSERT INTO node_type VALUES ('DIPOSIT','TANK', 'TANK', 'man_tank', 'inp_tank', TRUE, TRUE, 2, TRUE, 'Dipòsit');
INSERT INTO node_type VALUES ('HIDRANT','HYDRANT','JUNCTION', 'man_hydrant', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Hidrant');
INSERT INTO node_type VALUES ('VALVULA VERDA','VALVE','JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Vàlvula verda');
INSERT INTO node_type VALUES ('VALVULA D''AIRE','VALVE','JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Vàlvula d''aire');
INSERT INTO node_type VALUES ('VALVULA VENTOSA','VALVE','JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Vàlvula ventosa');
INSERT INTO node_type VALUES ('VALVULA DESCARREGA','VALVE', 'JUNCTION', 'man_valve',  'inp_junction', TRUE, TRUE, 2, TRUE, 'Vàlvula de descàrrega');
INSERT INTO node_type VALUES ('MESURADOR PRESSIO','METER', 'JUNCTION', 'man_meter',  'inp_junction', TRUE, TRUE, 2, TRUE, 'Mesurador de pressió');
INSERT INTO node_type VALUES ('VALVULA DE PAS','VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Vàlvula de pas');
INSERT INTO node_type VALUES ('VALVULA RETENCIO','VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Vàlvula de retenció');
INSERT INTO node_type VALUES ('VALVULA REDUCTORA','VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula reductora');
INSERT INTO node_type VALUES ('VALVULA COMPORTA','VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Vàlvula comporta');
INSERT INTO node_type VALUES ('VALV. SOSTENIDORA','VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula sostenidora de pressió');
INSERT INTO node_type VALUES ('PR-BREAK.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula trencadora de pressió');
INSERT INTO node_type VALUES ('FL-CONTR.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula controladora de fluxe');
INSERT INTO node_type VALUES ('VALVULA PAPALLONA','VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula papallona');
INSERT INTO node_type VALUES ('GEN-PURP.VALVE','VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula genèrica');
INSERT INTO node_type VALUES ('BOMBA POU','PUMP', 'PUMP', 'man_pump', 'inp_pump', TRUE, TRUE, 2, TRUE, 'Bomba pou');
INSERT INTO node_type VALUES ('BOMBA GRUP PRESSIO','PUMP', 'PUMP', 'man_pump', 'inp_pump', TRUE, TRUE, 2, TRUE, 'Bomba grup pressió');
INSERT INTO node_type VALUES ('FILTRE','FILTER', 'SHORTPIPE', 'man_filter', 'inp_shortpipe',TRUE, TRUE, 2, TRUE, 'Filtre');
INSERT INTO node_type VALUES ('CABALIMETRE','METER', 'SHORTPIPE', 'man_meter', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Cabalimetre');
INSERT INTO node_type VALUES ('COMPTADOR','METER', 'SHORTPIPE', 'man_meter', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Comptador');
INSERT INTO node_type VALUES ('MANOMETRE','METER', 'JUNCTION', 'man_meter', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Manòmetre');
INSERT INTO node_type VALUES ('POU DE CAPTACIÓ', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Pou');
INSERT INTO node_type VALUES ('CAPTACIO', 'SOURCE', 'JUNCTION', 'man_source', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Captació');
INSERT INTO node_type VALUES ('MINA', 'WATERWELL', 'RESERVOIR', 'man_waterwell', 'inp_reservoir', TRUE, TRUE, 2, TRUE, 'Mina');
INSERT INTO node_type VALUES ('POU', 'WATERWELL', 'RESERVOIR', 'man_waterwell', 'inp_reservoir', TRUE, TRUE, 2, TRUE, 'Pou');
INSERT INTO node_type VALUES ('TAP','JUNCTION', 'JUNCTION','man_junction', 'inp_junction', TRUE, TRUE, 3, TRUE, 'Tap');


-- ----------------------------
-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('TUBERIA','PIPE','PIPE', 'man_pipe', 'inp_pipe', TRUE, TRUE, 'Tuberia de distribució d''aigua' );
INSERT INTO arc_type VALUES ('VARC','VARC','PIPE', 'man_varc', 'inp_pipe', TRUE, TRUE, 'Secció virtual d''una tuberia de la xarxa. Utilitzada per connectar arcs i nodes quan tenen polígons' );


-- ----------------------------
-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('ESC SIMPLE', 'WJOIN', 'man_wjoin',  TRUE, TRUE, 'Escomesa simple');
INSERT INTO connec_type VALUES ('ESC MULTIPLE', 'WJOIN', 'man_wjoin',  TRUE, TRUE, 'Escomesa múltiple');
INSERT INTO connec_type VALUES ('ESC ANTIINCENDIS', 'WJOIN', 'man_wjoin',  TRUE, TRUE, 'Escomesa antiincendis');
INSERT INTO connec_type VALUES ('BOCA DE REG', 'GREENTAP', 'man_greentap',  TRUE, TRUE, 'Boca de reg');
INSERT INTO connec_type VALUES ('FONT ORNAMENTAL', 'FOUNTAIN', 'man_fountain',  TRUE, TRUE, 'Font ornamental');
INSERT INTO connec_type VALUES ('FONT PUBLICA', 'TAP', 'man_tap',  TRUE, TRUE, 'Font pública');


-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('REGISTRE', true, true, 'REGISTRE', NULL);
INSERT INTO element_type VALUES ('POU', true, true, 'POU', NULL);
INSERT INTO element_type VALUES ('TAPA', true, true, 'TAPA', NULL);
INSERT INTO element_type VALUES ('PATE', true, true, 'PATE', NULL);
