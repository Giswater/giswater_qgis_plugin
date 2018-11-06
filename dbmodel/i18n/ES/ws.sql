/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('ACOMETIDA', 'WJOIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FUENTE_ORNAMENTAL', 'FOUNTAIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FUENTE', 'TAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('BOCA_RIEGO', 'GREENTAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('POZO_CAPTACION', 'WATERWELL', 'NODE');
INSERT INTO cat_feature VALUES ('PUNTO_MOSTREO', 'NETSAMPLEPOINT', 'NODE');
INSERT INTO cat_feature VALUES ('ELEMENTO_RED', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('ESTACION_TRATAMIENTO', 'WTP', 'NODE');
INSERT INTO cat_feature VALUES ('TUBERIA', 'PIPE', 'ARC');
INSERT INTO cat_feature VALUES ('VARC', 'VARC', 'ARC');
INSERT INTO cat_feature VALUES ('VALVULA_CONTROL', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_REDUC_PR', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_VERDE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('CURVA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FILTRO', 'FILTER', 'NODE');
INSERT INTO cat_feature VALUES ('FINAL_LINEA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_CONTROL_FL', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('HIDRANTE', 'HYDRANT', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_ROTURA_PR', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_DESAGUE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('UNION', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_SOST_PR', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_CIERRE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('REDUCCION', 'REDUCTION', 'NODE');
INSERT INTO cat_feature VALUES ('BOMBEO', 'PUMP', 'NODE');
INSERT INTO cat_feature VALUES ('DEPOSITO', 'TANK', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_ACCEL', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('T', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('X', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CAPTACION', 'SOURCE', 'NODE');
INSERT INTO cat_feature VALUES ('POZO_ACCESO', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRO', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRO_CONTROL', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRO_BYPASS', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRO_VALVULA', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('ACOMETIDA_TOPO', 'NETWJOIN', 'NODE');
INSERT INTO cat_feature VALUES ('DILATADOR', 'FLEXUNION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_AIRE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('MEDIDOR', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('CALDERIN_EXPANSION', 'EXPANSIONTANK', 'NODE');
INSERT INTO cat_feature VALUES ('MEDIDOR_PRESION', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('ADAPTACION', 'JUNCTION', 'NODE');

-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('ADAPTACION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Adaptación');
INSERT INTO node_type VALUES ('VALVULA_CONTROL', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Válvula de control');
INSERT INTO node_type VALUES ('VALVULA_AIRE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Válvula de aire');
INSERT INTO node_type VALUES ('VALVULA_REDUC_PR', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Válvula reductora de presión');
INSERT INTO node_type VALUES ('VALVULA_VERDE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Válvula verde');
INSERT INTO node_type VALUES ('CURVA', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Curva');
INSERT INTO node_type VALUES ('FILTRO', 'FILTER', 'SHORTPIPE', 'man_filter', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Filtro');
INSERT INTO node_type VALUES ('FINAL_LINEA', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 1, TRUE, 'Final de línia');
INSERT INTO node_type VALUES ('VALVULA_CONTROL_FL', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Válvula de control de fluido');
INSERT INTO node_type VALUES ('VALVULA', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Válvula genérica');
INSERT INTO node_type VALUES ('HIDRANTE', 'HYDRANT', 'JUNCTION', 'man_hydrant', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Hidrante');
INSERT INTO node_type VALUES ('VALVULA_ROTURA_PR', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Válvula de rotura de presión');
INSERT INTO node_type VALUES ('VALVULA_DESAGUE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Válvula de desagüe');
INSERT INTO node_type VALUES ('UNION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Unión');
INSERT INTO node_type VALUES ('VALVULA_SOST_PR', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Válvula sostenedora de presión');
INSERT INTO node_type VALUES ('VALVULA_CIERRE', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', TRUE, TRUE, 2, TRUE, 'Válvula de cierre');
INSERT INTO node_type VALUES ('REDUCCION', 'REDUCTION', 'JUNCTION', 'man_reduction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Reducción');
INSERT INTO node_type VALUES ('BOMBEO', 'PUMP', 'PUMP', 'man_pump', 'inp_pump', TRUE, TRUE, 2, TRUE, 'Bombeo');
INSERT INTO node_type VALUES ('DEPOSITO', 'TANK', 'TANK', 'man_tank', 'inp_tank', TRUE, TRUE, 2, TRUE, 'Depósito');
INSERT INTO node_type VALUES ('VALVULA_ACCEL', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Válvula acelaración');
INSERT INTO node_type VALUES ('T', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 3, TRUE, 'Unión donde convergen 3 tuberías');
INSERT INTO node_type VALUES ('POZO_CAPTACION', 'WATERWELL', 'JUNCTION', 'man_waterwell', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Pozo de captación');
INSERT INTO node_type VALUES ('TAP', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction,', TRUE, TRUE, 2, TRUE, 'Tap');
INSERT INTO node_type VALUES ('X', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 4, TRUE, 'Unión donde convergen 4 tuberías');
INSERT INTO node_type VALUES ('CAPTACION', 'SOURCE', 'JUNCTION', 'man_source', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Captación');
INSERT INTO node_type VALUES ('POZO_ACCESO', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Pozo de acceso para inspección');
INSERT INTO node_type VALUES ('REGISTRO', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Registro');
INSERT INTO node_type VALUES ('REGISTRO_CONTROL', 'REGISTER', 'VALVE', 'man_register', 'inp_valve', TRUE, TRUE, 2, TRUE, 'Registro de control');
INSERT INTO node_type VALUES ('REGISTRO_BYPASS', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Registro de bypass');
INSERT INTO node_type VALUES ('REGISTRO_VALVULA', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Registro de válvula');
INSERT INTO node_type VALUES ('ACOMETIDA_TOPO', 'NETWJOIN', 'JUNCTION', 'man_netwjoin', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Acometida connectada a la red');
INSERT INTO node_type VALUES ('CALDERIN_EXPANSION', 'EXPANSIONTANK', 'JUNCTION', 'man_expansiontank', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Calderín de expansión');
INSERT INTO node_type VALUES ('DILATADOR', 'FLEXUNION', 'JUNCTION', 'man_flexunion', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Dilatador');
INSERT INTO node_type VALUES ('MEDIDOR', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Medidor');
INSERT INTO node_type VALUES ('MEDIDOR_PRESSION', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Medidor de pressión');
INSERT INTO node_type VALUES ('PUNTO_MOSTREO', 'NETSAMPLEPOINT', 'JUNCTION', 'man_netsamplepoint', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Punto de mostreo');
INSERT INTO node_type VALUES ('ESTACION_TRATAMIENTO', 'WTP', 'RESERVOIR', 'man_wtp', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Estación de tratamiento');
INSERT INTO node_type VALUES ('ELEMENTO_RED', 'NETELEMENT', 'JUNCTION', 'man_netelement', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Elemento de red');


-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('TUBERIA', 'PIPE', 'PIPE', 'man_pipe', 'inp_pipe', TRUE, TRUE, 'Tubería de distribución de agua' );
INSERT INTO arc_type VALUES ('VARC', 'VARC', 'PIPE', 'man_varc', 'inp_pipe', TRUE, TRUE, 'Sección virtual de una tuberia. Se usa para conectar arcos y nodos cuando existe un polígono');

-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('ACOMETIDA', 'WJOIN', 'man_wjoin', TRUE, TRUE, 'Acometida');
INSERT INTO connec_type VALUES ('FUENTE_ORNAMENTAL', 'FOUNTAIN', 'man_fountain', TRUE, TRUE, 'Fuente ornamental' );
INSERT INTO connec_type VALUES ('FUENTE', 'TAP', 'man_tap', TRUE, TRUE, 'Fuente de agua');
INSERT INTO connec_type VALUES ('BOCA_RIEGO', 'GREENTAP', 'man_greentap', TRUE, TRUE, 'Boca de riego');

-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('REGISTRO', true, true, 'REGISTRO', NULL);
INSERT INTO element_type VALUES ('POZO', true, true, 'MANHOLE', NULL);
INSERT INTO element_type VALUES ('TAPA', true, true, 'COVER', NULL);
INSERT INTO element_type VALUES ('PATE', true, true, 'STEP', NULL);
INSERT INTO element_type VALUES ('BANDA_PROTECTORA', true, true, 'BANDA_PROTECTORA', NULL);

-- Records of mincut system table
-- ----------------------------
INSERT INTO anl_mincut_selector_valve VALUES ('VALVULA_CIERRE');

INSERT INTO anl_mincut_cat_cause VALUES ('Accidental', NULL);
INSERT INTO anl_mincut_cat_cause VALUES ('Planificado', NULL);

INSERT INTO anl_mincut_cat_class VALUES (1, 'Cierre de red', NULL);
INSERT INTO anl_mincut_cat_class VALUES (2, 'Cierre de acometidas', NULL);
INSERT INTO anl_mincut_cat_class VALUES (3, 'Cierre de abonados', NULL);

INSERT INTO anl_mincut_cat_state VALUES (1, 'En proceso', NULL);
INSERT INTO anl_mincut_cat_state VALUES (2, 'Finalizado', NULL);
INSERT INTO anl_mincut_cat_state VALUES (0, 'Planificado', NULL);

INSERT INTO anl_mincut_cat_type VALUES ('Test', true);
INSERT INTO anl_mincut_cat_type VALUES ('Demo', true);
INSERT INTO anl_mincut_cat_type VALUES ('Real', false);

