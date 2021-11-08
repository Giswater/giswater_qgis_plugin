/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('TUBULACAO', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('SIFAO', 'SIPHON', 'ARC');
INSERT INTO cat_feature VALUES ('TUBO_QUEDA', 'WACCEL', 'ARC');
INSERT INTO cat_feature VALUES ('TUBULACAO_VIRTUAL', 'VARC', 'ARC'); 
INSERT INTO cat_feature VALUES ('TUBULACAO_RECALQUE', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('CAIXA_INSPECAO', 'CHAMBER', 'NODE');
INSERT INTO cat_feature VALUES ('POCO_VISITA', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('PONTO_ALTO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CAIXA_PASSAGEM', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('NO_VIRTUAL', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VERTEDOURO', 'CHAMBER', 'NODE');
INSERT INTO cat_feature VALUES ('RESSALTO_HIDRAULICO', 'WJUMP', 'NODE');
INSERT INTO cat_feature VALUES ('POCO_VISITA_RETANGULAR', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('DESARENADOR', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('ETE', 'WWTP', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('RESERVATORIO_PULMAO', 'STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('RESERVATORIO_CONTENCAO', 'STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('EXULTORIO', 'OUTFALL', 'NODE');
INSERT INTO cat_feature VALUES ('BOCA_LOBO_TOPO', 'NETGULLY', 'NODE');
INSERT INTO cat_feature VALUES ('LIGACAO', 'CONNEC', 'CONNEC');
INSERT INTO cat_feature VALUES ('BOCA_LOBO', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('BOCA_LOBO_MAYOR', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('CAIXA_LIGACAO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('ELEMENT_GERAL_REDE', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('BOMBEAMENTO', 'CHAMBER', 'NODE');
INSERT INTO cat_feature VALUES ('PONTO_INICIO_REDE', 'NETINIT', 'NODE');



-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('CAIXA_INSPECAO', 'CHAMBER', 'STORAGE', 'man_chamber', 'inp_storage', TRUE, TRUE, 2, TRUE, 'Caixa de Inspeção');
INSERT INTO node_type VALUES ('POCO_VISITA', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Poço de Visita');
INSERT INTO node_type VALUES ('PONTO_ALTO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Ponto Alto');
INSERT INTO node_type VALUES ('REGISTRO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Registro');
INSERT INTO node_type VALUES ('CAIXA_PASSAGEM', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Caixa de passagem');
INSERT INTO node_type VALUES ('NO_VIRTUAL', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'No virtual');
INSERT INTO node_type VALUES ('VERTEDOURO', 'CHAMBER', 'JUNCTION', 'man_chamber', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Vertedouro');
INSERT INTO node_type VALUES ('RESSALTO_HIDRAULICO', 'WJUMP', 'JUNCTION', 'man_wjump', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Ressalto Hidraulico');
INSERT INTO node_type VALUES ('POCO_VISITA_RETANGULAR', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Poço de Visita de seção Retangular');
INSERT INTO node_type VALUES ('DESARENADOR', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Caixa de areia');
INSERT INTO node_type VALUES ('ETE', 'WWTP', 'JUNCTION', 'man_wwtp', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Estação de Tratamento de Esgoto');
INSERT INTO node_type VALUES ('VALVULA', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Valvula');
INSERT INTO node_type VALUES ('RESERVATORIO_PULMAO', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage', TRUE, TRUE, 2, TRUE, 'Reservatório pulmão');
INSERT INTO node_type VALUES ('RESERVATORIO_CONTENCAO', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage', TRUE, TRUE, 2, TRUE, 'Reservatório de contenção de cheias');
INSERT INTO node_type VALUES ('EXULTORIO', 'OUTFALL', 'OUTFALL', 'man_outfall', 'inp_outfall', TRUE, TRUE, 2, TRUE, 'Exultório');
INSERT INTO node_type VALUES ('BOCA_LOBO_TOPO', 'NETGULLY', 'JUNCTION', 'man_netgully', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Boca de lobo sob galeria principal');
INSERT INTO node_type VALUES ('CAIXA_LIGACAO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Caixa de ligação');
INSERT INTO node_type VALUES ('ELEMENT_GERAL_REDE', 'NETELEMENT', 'JUNCTION', 'man_netelement', 'inp_junction', TRUE, TRUE, 2, TRUE, 'Element geral de rede');
INSERT INTO node_type VALUES ('BOMBEAMENTO', 'CHAMBER', 'STORAGE', 'man_chamber', 'inp_storage', TRUE, TRUE, 2, TRUE, 'Estação de Bombeamento');
INSERT INTO node_type VALUES ('PONTO_INICIO_REDE', 'NETINIT', 'JUNCTION', 'man_netinit', 'inp_junction', TRUE, TRUE, 1, TRUE, 'Ponto de Inicio de Rede');

-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('TUBULACAO', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', TRUE, TRUE, 'Tubulação');
INSERT INTO arc_type VALUES ('SIFAO', 'SIPHON', 'CONDUIT', 'man_siphon', 'inp_conduit', TRUE, TRUE, 'Sifão');
INSERT INTO arc_type VALUES ('TUBO_QUEDA', 'WACCEL', 'CONDUIT', 'man_waccel', 'inp_conduit', TRUE, TRUE, 'Tubo de Queda');
INSERT INTO arc_type VALUES ('TUBULACAO_VIRTUAL', 'VARC', 'VIRTUAL', 'man_varc', 'inp_virtual', TRUE, TRUE, 'Tubulação Virtual');
INSERT INTO arc_type VALUES ('TUBULACAO_RECALQUE', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', TRUE, TRUE, 'Tubulação de recalque ');

-- Records of connec_type
-- ----------------------------
INSERT INTO connec_type VALUES ('LIGACAO', 'CONNEC', 'man_connec', TRUE, TRUE, 'Ligação predial/domiciliar');


-- Records of gully_type
-- ----------------------------
INSERT INTO gully_type VALUES ('BOCA_LOBO', 'GULLY', 'man_gully', TRUE, TRUE, 'Boca de Lobo');
INSERT INTO gully_type VALUES ('BOCA_LOBO_MAYOR', 'GULLY', 'man_gully', TRUE, TRUE, 'Boca de Lobo Mayor');


-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('COVER', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('GATE', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('IOT SENSOR', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('PUMP', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('STEP', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('PROTECTOR', true, true, NULL, NULL);

-- Records of element cat_arc_shape
-- ----------------------------
INSERT INTO cat_arc_shape VALUES ('CIRCULAR', 'CIRCULAR', NULL, NULL, 'ud_section_circular.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('FILLED_CIRCULAR', 'FILLED_CIRCULAR', NULL, NULL, 'ud_section_filled_circular.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('RECT_CLOSED', 'RECT_CLOSED', NULL, NULL, 'ud_section_rect_closed.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('RECT_OPEN', 'RECT_OPEN', NULL, NULL, 'ud_section_rect_open.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('TRAPEZOIDAL', 'TRAPEZOIDAL', NULL, NULL, 'ud_section_trapezoidal.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('TRIANGULAR', 'TRIANGULAR', NULL, NULL, 'ud_section_triangular.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('HORIZ_ELLIPSE', 'HORIZ_ELLIPSE', NULL, NULL, 'ud_section_horiz_ellipse.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('ARCH', 'ARCH', NULL, NULL, 'ud_section_arch.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('PARABOLIC', 'PARABOLIC', NULL, NULL, 'ud_section_parabolic.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('POWER', 'POWER', NULL, NULL, 'ud_section_power.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('RECT_TRIANGULAR', 'RECT_TRIANGULAR', NULL, NULL, 'ud_section_rect_triangular.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('RECT_ROUND', 'RECT_ROUND', NULL, NULL, 'ud_section_rect_round.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('MODBASKETHANDLE', 'MODBASKETHANDLE', NULL, NULL, 'ud_section_modbaskethandle.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('EGG', 'EGG', NULL, NULL, 'ud_section_egg.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('HORSESHOE', 'HORSESHOE', NULL, NULL, 'ud_section_horseshoe.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('SEMIELLIPTICAL', 'SEMIELLIPTICAL', NULL, NULL, 'ud_section_semielliptical.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('BASKETHANDLE', 'BASKETHANDLE', NULL, NULL, 'ud_section_baskethandle.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('SEMICIRCULAR', 'SEMICIRCULAR', NULL, NULL, 'ud_section_semicircular.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('DUMMY', 'DUMMY', NULL, NULL, 'ud_section_dummy.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('FORCE_MAIN', 'FORCE_MAIN', NULL, NULL, 'ud_section_force_main.png', NULL, true);
INSERT INTO cat_arc_shape VALUES ('CUSTOM', 'CUSTOM', NULL, NULL, 'ud_section_custom.png', 'Custom defined closed shape using the curve values of some curve defined on inp_curve table. Needed to normalize as a simetric shape', true);
INSERT INTO cat_arc_shape VALUES ('IRREGULAR', 'IRREGULAR', NULL, NULL, 'ud_section_irregular.png', 'Custom defined open inrregular channel shape using HEC format and storing information on some tsect values stored on inp_transects table', true);
INSERT INTO cat_arc_shape VALUES ('VIRTUAL', 'VIRTUAL', NULL, NULL, 'null.png', 'Non real shape.', false);