/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('LIGACAO', 'WJOIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FONTE_ORNAMENTAL', 'FOUNTAIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('TORNERIA', 'TAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('PONTO_IRRIGACAO', 'GREENTAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('CAPT_SUBT', 'WATERWELL', 'NODE');
INSERT INTO cat_feature VALUES ('COLETA_AMOSTRA', 'NETSAMPLEPOINT', 'NODE');
INSERT INTO cat_feature VALUES ('NETELEMENT', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('ETA', 'WTP', 'NODE');
INSERT INTO cat_feature VALUES ('TUBULACAO', 'PIPE', 'ARC');
INSERT INTO cat_feature VALUES ('VARC', 'VARC', 'ARC');
INSERT INTO cat_feature VALUES ('VALVULA_CUNHA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_REDU_PRES', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_IRRIGA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('CURVA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FILTRO', 'FILTER', 'NODE');
INSERT INTO cat_feature VALUES ('FIM_REDE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_BORBOLETA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_GERAL', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('HIDRANTE', 'HYDRANT', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_QUEBRA_VACUO', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_EXULTORIO', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('UNIAO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_SUST_PRES', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA_PARADA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('CONE_REDUCAO', 'REDUCTION', 'NODE');
INSERT INTO cat_feature VALUES ('BOMBA', 'PUMP', 'NODE');
INSERT INTO cat_feature VALUES ('RESERVATORIO', 'TANK', 'NODE');
INSERT INTO cat_feature VALUES ('T', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('X', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CAPT_SUP', 'SOURCE', 'NODE');
INSERT INTO cat_feature VALUES ('PONTO_INSPECAO', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRO', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('HIDROMETRO', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('BYPASS', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRO_VALVULA', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('LIGACAO_TOPO', 'NETWJOIN', 'NODE');
INSERT INTO cat_feature VALUES ('JUNTA_ELASTICA', 'FLEXUNION', 'NODE');
INSERT INTO cat_feature VALUES ('VENTOSA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('MEDIDOR', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('TANQUE_EXPAN', 'EXPANSIONTANK', 'NODE');
INSERT INTO cat_feature VALUES ('MEDIDOR_PRES', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('ADAPTADOR', 'JUNCTION', 'NODE');




-- Records of node type system table
-- ----------------------------

INSERT INTO node_type  VALUES ('VALVULA_BORBOLETA', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Valvula borboleta/ reguladora de fluxo', NULL);
INSERT INTO node_type  VALUES ('VALVULA_PARADA', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', true, true, 2, true, 'Valvula de parada', NULL);
INSERT INTO node_type  VALUES ('RESERVATORIO', 'TANK', 'TANK', 'man_tank', 'inp_tank', true, true, 2, true, 'Reservatorio', NULL);
INSERT INTO node_type  VALUES ('VALVULA_IRRIGA', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true, 'Valvula para irrigação', NULL);
INSERT INTO node_type  VALUES ('VALVULA_EXULTORIO', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true, 'Valvula tipo exultório', NULL);
INSERT INTO node_type  VALUES ('VALVULA_GERAL', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Valvula de aplicação geral', NULL);
INSERT INTO node_type  VALUES ('HIDRANTE', 'HYDRANT', 'JUNCTION', 'man_hydrant', 'inp_junction', true, true, 2, true, 'Hidrante', NULL);
INSERT INTO node_type  VALUES ('UNIAO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'União', NULL);
INSERT INTO node_type  VALUES ('CONE_REDUCAO', 'REDUCTION', 'JUNCTION', 'man_reduction', 'inp_junction', true, true, 2, true, 'Cone de redução', NULL);
INSERT INTO node_type  VALUES ('BOMBA', 'PUMP', 'PUMP', 'man_pump', 'inp_pump', true, true, 2, true, 'Bomba', NULL);
INSERT INTO node_type  VALUES ('VALVULA_SUST_PRES', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Valvula sustentadora de pressão', NULL);
INSERT INTO node_type  VALUES ('VALVULA_REDU_PRES', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Valvula redutora de pressão', NULL);
INSERT INTO node_type  VALUES ('VALVULA_QUEBRA_VACUO', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Válvula Quebra Vácuo', NULL);
INSERT INTO node_type  VALUES ('T', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 3, true, 'União tipo Tê', NULL);
INSERT INTO node_type  VALUES ('X', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 4, true, 'União tipo X', NULL);
INSERT INTO node_type  VALUES ('PONTO_INSPECAO', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', true, true, 2, true, 'Ponto de inspeção', NULL);
INSERT INTO node_type  VALUES ('REGISTRO', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', true, true, 2, true, 'Registro de passagem', NULL);
INSERT INTO node_type  VALUES ('REGISTRO_VALVULA', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', true, true, 2, true, 'Registro de válvula', NULL);
INSERT INTO node_type  VALUES ('LIGACAO_TOPO', 'NETWJOIN', 'JUNCTION', 'man_netwjoin', 'inp_junction', true, true, 2, true, 'Conexão predial direta na rede', NULL);
INSERT INTO node_type  VALUES ('JUNTA_ELASTICA', 'FLEXUNION', 'JUNCTION', 'man_flexunion', 'inp_junction', true, true, 2, true, 'Junta elástica', NULL);
INSERT INTO node_type  VALUES ('MEDIDOR_PRES', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', true, true, 2, true, 'Medidor de pressão', NULL);
INSERT INTO node_type  VALUES ('COLETA_AMOSTRA', 'NETSAMPLEPOINT', 'JUNCTION', 'man_netsamplepoint', 'inp_junction', true, true, 2, true, 'Ponto de coleta de amostra', NULL);
INSERT INTO node_type  VALUES ('NETELEMENT', 'NETELEMENT', 'JUNCTION', 'man_netelement', 'inp_junction', true, true, 2, true, 'Elemento geral sob traçado da rede', NULL);
INSERT INTO node_type  VALUES ('ADAPTADOR', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'Adaptador', NULL);
INSERT INTO node_type  VALUES ('BYPASS', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', true, true, 2, true, 'Ponto de bypass de rede', NULL);
INSERT INTO node_type  VALUES ('CURVA', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'Curva', NULL);
INSERT INTO node_type  VALUES ('HIDROMETRO', 'REGISTER', 'JUNCTION', 'man_register', 'inp_valve', true, true, 2, true, 'Hidrometro', NULL);
INSERT INTO node_type  VALUES ('FIM_REDE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 1, true, 'Fim de rede', NULL);
INSERT INTO node_type  VALUES ('TANQUE_EXPAN', 'EXPANSIONTANK', 'JUNCTION', 'man_expansiontank', 'inp_junction', true, true, 2, true, 'Tanque de expansão termica de agua', NULL);
INSERT INTO node_type  VALUES ('FILTRO', 'FILTER', 'JUNCTION', 'man_filter', 'inp_shortpipe', true, true, 2, true, 'Filtro', NULL);
INSERT INTO node_type  VALUES ('CAPT_SUBT', 'WATERWELL', 'RESERVOIR', 'man_waterwell', 'inp_junction', true, true, 2, true, 'Poço de captação', NULL);
INSERT INTO node_type  VALUES ('CAPT_SUP', 'SOURCE', 'RESERVOIR', 'man_source', 'inp_junction', true, true, 2, true, 'Ponto de Captação', NULL);
INSERT INTO node_type  VALUES ('ETA', 'WTP', 'RESERVOIR', 'man_wtp', 'inp_junction', true, true, 2, true, 'Estação de Tratamento de Água', NULL);
INSERT INTO node_type  VALUES ('VALVULA_CUNHA', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true,'Valvula de cunha', NULL);
INSERT INTO node_type  VALUES ('VENTOSA', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true,'Valvula ventosa', NULL);
INSERT INTO node_type  VALUES ('MEDIDOR', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', true, true, 2, true, 'Medidor de Vazão', NULL);



-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('TUBULACAO', 'PIPE', 'PIPE', 'man_pipe', 'inp_pipe', TRUE, TRUE, 'Tubulação');
INSERT INTO arc_type VALUES ('VARC', 'VARC', 'PIPE', 'man_varc', 'inp_pipe', TRUE, TRUE, 'Tubulação virtual');

-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('LIGACAO', 'WJOIN', 'man_wjoin', TRUE, TRUE, 'Ligação');
INSERT INTO connec_type VALUES ('FONTE_ORNAMENTAL', 'FOUNTAIN', 'man_fountain', TRUE, TRUE, 'Fonte Ornamental' );
INSERT INTO connec_type VALUES ('TORNERIA', 'TAP', 'man_tap', TRUE, TRUE, 'Torneria');
INSERT INTO connec_type VALUES ('PONTO_IRRIGACAO', 'GREENTAP', 'man_greentap', TRUE, TRUE, 'Ponto de irrigação');


-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('REGISTER', true, true, 'REGISTER', NULL);
INSERT INTO element_type VALUES ('MANHOLE', true, true, 'MANHOLE', NULL);
INSERT INTO element_type VALUES ('COVER', true, true, 'COVER', NULL);
INSERT INTO element_type VALUES ('STEP', true, true, 'STEP', NULL);
INSERT INTO element_type VALUES ('PROTECT_BAND', true, true, 'PROTECT BAND', NULL);
INSERT INTO element_type VALUES ('HYDRANT_PLATE', true, true, 'HYDRANT_PLATE', NULL);

-- Records of mincut
-- ----------------------------
INSERT INTO anl_mincut_selector_valve VALUES ('VALVULA_PARADA');

INSERT INTO anl_mincut_cat_cause VALUES ('Accidental', NULL);
INSERT INTO anl_mincut_cat_cause VALUES ('Planified', NULL);

INSERT INTO anl_mincut_cat_class VALUES (1, 'Network mincut', NULL);
INSERT INTO anl_mincut_cat_class VALUES (2, 'Connec mincut', NULL);
INSERT INTO anl_mincut_cat_class VALUES (3, 'Hydrometer mincut', NULL);

INSERT INTO anl_mincut_cat_state VALUES (1, 'In Progress', NULL);
INSERT INTO anl_mincut_cat_state VALUES (2, 'Finished', NULL);
INSERT INTO anl_mincut_cat_state VALUES (0, 'Planified', NULL);


INSERT INTO anl_mincut_cat_type VALUES ('Test', true);
INSERT INTO anl_mincut_cat_type VALUES ('Demo', true);
INSERT INTO anl_mincut_cat_type VALUES ('Real', false);