/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('ESCOMESA', 'WJOIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FONT_ORNAMENTAL', 'FOUNTAIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FONT', 'TAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('BOCA_REG', 'GREENTAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('POU', 'WATERWELL', 'NODE');
INSERT INTO cat_feature VALUES ('PUNT_MOSTREIG', 'NETSAMPLEPOINT', 'NODE');
INSERT INTO cat_feature VALUES ('NETELEMENT', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('ESTACIO_TRACTAMENT', 'WTP', 'NODE');
INSERT INTO cat_feature VALUES ('TUBERIA', 'PIPE', 'ARC');
INSERT INTO cat_feature VALUES ('VARC', 'VARC', 'ARC');
INSERT INTO cat_feature VALUES ('VALVULA_CONTROL', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_REDUCTORA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('GREEN-VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('CORBA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FILTRE', 'FILTER', 'NODE');
INSERT INTO cat_feature VALUES ('FINAL_LINEA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_CONTROL_FL', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('HIDRANT', 'HYDRANT', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_TRENCA_PRESSIO', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_DESGUAS', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('UNIO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_SOST_PRESSIO', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_SHUTOFF', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('REDUCCIO', 'REDUCTION', 'NODE');
INSERT INTO cat_feature VALUES ('BOMBA', 'PUMP', 'NODE');
INSERT INTO cat_feature VALUES ('DIPOSIT', 'TANK', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_ACCEL', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('T', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('X', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CAPTACIO', 'SOURCE', 'NODE');
INSERT INTO cat_feature VALUES ('POU_CAPTACIO', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRE', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRE_CONTROL', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRE_BYPASS', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_REGISTRE', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('ESCOMESA_TOPO', 'NETWJOIN', 'NODE');
INSERT INTO cat_feature VALUES ('DILATADOR', 'FLEXUNION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_VENTOSA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('MEDIDOR_FLUID', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('TANC_EXPANSIO', 'EXPANSIONTANK', 'NODE');
INSERT INTO cat_feature VALUES ('MEDIDOR_PRESSIO', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('ADAPTACIO', 'JUNCTION', 'NODE');


-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('ADAPTACIO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Adaptació');
INSERT INTO node_type VALUES ('VALVULA_CONTROL', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Vàlvula de control');
INSERT INTO node_type VALUES ('VALVULA_VENTOSA', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Vàlvula ventosa');
INSERT INTO node_type VALUES ('VALVULA_REDUCTORA', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula reductora');
INSERT INTO node_type VALUES ('GREEN-VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Green valve');
INSERT INTO node_type VALUES ('CORBA', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Corba');
INSERT INTO node_type VALUES ('FILTRE', 'FILTER', 'SHORTPIPE', 'man_filter', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Filtre');
INSERT INTO node_type VALUES ('FINAL_LINEA', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 1, TRUE, 'Final de línia');
INSERT INTO node_type VALUES ('VALVULA_CONTROL_FL', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula controladora de fluxe');
INSERT INTO node_type VALUES ('VALVULA', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula genèrica');
INSERT INTO node_type VALUES ('HIDRANT', 'HYDRANT', 'JUNCTION', 'man_hydrant', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Hidrant');
INSERT INTO node_type VALUES ('VALVULA_TRENCA_PRESSIO', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula trencadora de pressió');
INSERT INTO node_type VALUES ('VALVULA_DESGUAS', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Vàlvula de desguàs');
INSERT INTO node_type VALUES ('UNIO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Unió');
INSERT INTO node_type VALUES ('VALVULA_SOST_PRESSIO', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula sostenidora de pressió');
INSERT INTO node_type VALUES ('VALVULA_SHUTOFF', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Vàlvula shutoff');
INSERT INTO node_type VALUES ('REDUCCIO', 'REDUCTION', 'JUNCTION', 'man_reduction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Reducció');
INSERT INTO node_type VALUES ('BOMBA', 'PUMP', 'PUMP', 'man_pump', 'inp_pump', TRUE, TRUE, 2, TRUE, 'Bomba');
INSERT INTO node_type VALUES ('DIPOSIT', 'TANK', 'TANK', 'man_tank', 'inp_tank', TRUE, TRUE, 2, TRUE, 'Dipòsit');
INSERT INTO node_type VALUES ('VALVULA_ACCEL', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Vàlvula d''acceleració');
INSERT INTO node_type VALUES ('T', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 3, TRUE, 'Unió on 3 conductes convergeixen');
INSERT INTO node_type VALUES ('POU', 'WATERWELL', 'JUNCTION', 'man_waterwell', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Pou');
INSERT INTO node_type VALUES ('TAP', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction,', TRUE, TRUE, 2, TRUE, 'Tap');
INSERT INTO node_type VALUES ('X', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 4, TRUE, 'Unió on 4 conductes convergeixen');
INSERT INTO node_type VALUES ('CAPTACIO', 'SOURCE', 'JUNCTION', 'man_source', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Captació');
INSERT INTO node_type VALUES ('POU_CAPTACIO', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Pou de captació');
INSERT INTO node_type VALUES ('REGISTRE', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Registre');
INSERT INTO node_type VALUES ('REGISTRE_CONTROL', 'REGISTER', 'VALVE', 'man_register', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Registre de control');
INSERT INTO node_type VALUES ('REGISTRE_BYPASS', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Registre de bypass');
INSERT INTO node_type VALUES ('VALVULA_REGISTRE', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Registre de vàlvula');
INSERT INTO node_type VALUES ('ESCOMESA_TOPO', 'NETWJOIN', 'JUNCTION', 'man_netwjoin', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Escomesa topològica');
INSERT INTO node_type VALUES ('TANC_EXPANSIO', 'EXPANSIONTANK', 'JUNCTION', 'man_expansiontank', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Tanc d''expansió');
INSERT INTO node_type VALUES ('DILATADOR', 'FLEXUNION', 'JUNCTION', 'man_flexunion', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Dilatador');
INSERT INTO node_type VALUES ('MEDIDOR_FLUID', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Medidor de fluid');
INSERT INTO node_type VALUES ('MEDIDOR_PRESSIO', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Medidor de pressió');
INSERT INTO node_type VALUES ('PUNT_MOSTREIG', 'NETSAMPLEPOINT', 'JUNCTION', 'man_netsamplepoint', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Punt de mostreig');
INSERT INTO node_type VALUES ('ESTACIO_TRACTAMENT', 'WTP', 'RESERVOIR', 'man_wtp', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Estació de tractament');
INSERT INTO node_type VALUES ('NETELEMENT', 'NETELEMENT', 'JUNCTION', 'man_netelement', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Element topològic');


-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('TUBERIA','PIPE','PIPE', 'man_pipe', 'inp_pipe', TRUE, TRUE, 'Tuberia de distribució d''aigua' );
INSERT INTO arc_type VALUES ('VARC','VARC','PIPE', 'man_varc', 'inp_pipe', TRUE, TRUE, 'Secció virtual d''una tuberia de la xarxa. Utilitzada per connectar arcs i nodes quan tenen polígons' );

-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('ESCOMESA', 'WJOIN', 'man_wjoin',  TRUE, TRUE, 'Escomesa');
INSERT INTO connec_type VALUES ('BOCA_REG', 'GREENTAP', 'man_greentap',  TRUE, TRUE, 'Boca de reg');
INSERT INTO connec_type VALUES ('FONT_ORNAMENTAL', 'FOUNTAIN', 'man_fountain',  TRUE, TRUE, 'Font ornamental');
INSERT INTO connec_type VALUES ('FONT', 'TAP', 'man_tap',  TRUE, TRUE, 'Font pública');

-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('REGISTRE', true, true, 'REGISTRE', NULL);
INSERT INTO element_type VALUES ('POU', true, true, 'POU', NULL);
INSERT INTO element_type VALUES ('TAPA', true, true, 'TAPA', NULL);
INSERT INTO element_type VALUES ('PATE', true, true, 'PATE', NULL);
INSERT INTO element_type VALUES ('BANDA_PROTECCIO', true, true, 'BANDA_PROTECCIO', NULL);

-- Records of mincut tables
-- ----------------------------
INSERT INTO anl_mincut_selector_valve VALUES ('VALVULA_SHUTOFF');

INSERT INTO anl_mincut_cat_cause VALUES ('Accidental', NULL);
INSERT INTO anl_mincut_cat_cause VALUES ('Planificat', NULL);

INSERT INTO anl_mincut_cat_class VALUES (1, 'Tancament de xarxa', NULL);
INSERT INTO anl_mincut_cat_class VALUES (2, 'Tancament d''escomeses', NULL);
INSERT INTO anl_mincut_cat_class VALUES (3, 'Tancament d''abonats', NULL);

INSERT INTO anl_mincut_cat_state VALUES (1, 'En procés', NULL);
INSERT INTO anl_mincut_cat_state VALUES (2, 'Finalitzat', NULL);
INSERT INTO anl_mincut_cat_state VALUES (0, 'Planificat', NULL);

INSERT INTO anl_mincut_cat_type VALUES ('Test', true);
INSERT INTO anl_mincut_cat_type VALUES ('Demo', true);
INSERT INTO anl_mincut_cat_type VALUES ('Real', false);

