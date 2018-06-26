/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('NODO VIRTUAL','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRO','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('POZO_RECTANGULAR', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('POZO_CIRCULAR','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CAMBIO DE SECCION','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('PUNTO ALTO','JUNCTION','NODE');
INSERT INTO cat_feature VALUES ('SALTO','JUNCTION','NODE');
INSERT INTO cat_feature VALUES ('ARQUETA ARENAL','JUNCTION','NODE');
INSERT INTO cat_feature VALUES ('PRESA','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('DEPOSITO','STORAGE','NODE');
INSERT INTO cat_feature VALUES ('DEPOSITO DE DESBORDAMIENTO','STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('DESAGUE','OUTFALL','NODE');
INSERT INTO cat_feature VALUES ('CONDUCTO', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('IMPULSION', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('SIFON', 'SIPHON', 'ARC');
INSERT INTO cat_feature VALUES ('RAPIDO', 'WACCEL', 'ARC');
INSERT INTO cat_feature VALUES ('FICTICIO', 'VARC',  'ARC');
INSERT INTO cat_feature VALUES ('ACOMETIDA', 'CONNEC', 'CONNEC');
INSERT INTO cat_feature VALUES ('SUMIDERO', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('REJA', 'GULLY', 'GULLY');


-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO "node_type" VALUES ('NODO VIRTUAL','JUNCTION','JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('REGISTRO','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('POZO_RECTANGULAR','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('POZO_CIRCULAR','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('CAMBIO DE SECCION','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('PUNTO ALTO','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('SALTO','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('ARQUETA ARENAL','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('PRESA','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('DEPOSITO','STORAGE', 'STORAGE', 'man_storage', 'inp_storage',true);
INSERT INTO "node_type" VALUES ('DEPOSITO DE DESBORDAMIENTO','STORAGE', 'STORAGE', 'man_storage', 'inp_storage',true);
INSERT INTO "node_type" VALUES ('DESAGUE','OUTFALL','OUTFALL', 'man_outfall', 'inp_outfall',true);



-- ----------------------------
-- Records of arc type system table
-- ----------------------------

INSERT INTO arc_type VALUES ('CONDUCTO', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('IMPULSION', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('SIFON', 'SIPHON', 'CONDUIT', 'man_siphon', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('RAPIDO', 'WACCEL', 'CONDUIT', 'man_waccel', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('FICTICIO', 'VARC', 'OUTLET', 'man_varc', 'inp_outlet',true);

-- ----------------------------
-- Records of connec_type
-- ----------------------------
INSERT INTO connec_type VALUES ('ACOMETIDA', 'CONNEC', 'man_connec',true);

-- ----------------------------
-- Records of gully_type
-- ----------------------------
INSERT INTO gully_type VALUES ('SUMIDERO', 'GULLY', 'man_gully',true);
INSERT INTO gully_type VALUES ('REJA', 'GULLY', 'man_gully',true);

-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO "element_type" VALUES ('TAPA', true, true, NULL, NULL);
INSERT INTO "element_type" VALUES ('PATE' , true, true, NULL, NULL);
INSERT INTO "element_type" VALUES ('BOMBA', true, true, NULL, NULL);
INSERT INTO "element_type" VALUES ('COMPUERTA', true, true, NULL, NULL);


-- ----------------------------
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
INSERT INTO cat_arc_shape VALUES ('VIRTUAL', 'VIRTUAL', NULL, NULL, NULL, 'Non real shape.', false);


