/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('NODE VIRTUAL','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRE','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('POU_RECTANGULAR','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('POU_CIRCULAR', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CANVI DE SECCIO','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('PUNT ALT','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('SALT','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('ARQUETA SORRERA','JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('PRESA','JUNCTION',  'NODE');
INSERT INTO cat_feature VALUES ('DIPOSIT','STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('DIPOSIT DE DESBORDAMENT', 'STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('DESGUAS','OUTFALL', 'NODE');
INSERT INTO cat_feature VALUES ('CONDUCTE', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('IMPULSIO', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('SIFO', 'SIPHON', 'ARC');
INSERT INTO cat_feature VALUES ('RAPID', 'WACCEL', 'ARC');
INSERT INTO cat_feature VALUES ('FICTICI', 'VARC', 'ARC');
INSERT INTO cat_feature VALUES ('ESCOMESA', 'CONNEC', 'CONNEC');
INSERT INTO cat_feature VALUES ('EMBORNAL', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('REIXA', 'GULLY', 'GULLY');

-- Records of node type system table
-- ----------------------------
INSERT INTO "node_type" VALUES ('NODE VIRTUAL','JUNCTION','JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('REGISTRE','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('POU_RECTANGULAR','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('POU_CIRCULAR','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('CANVI DE SECCIO','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('PUNT ALT','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('SALT','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('ARQUETA SORRERA','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('PRESA','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',true);
INSERT INTO "node_type" VALUES ('DIPOSIT','STORAGE', 'STORAGE', 'man_storage', 'inp_storage',true);
INSERT INTO "node_type" VALUES ('DIPOSIT DE DESBORDAMENT','STORAGE', 'STORAGE', 'man_storage', 'inp_storage',true);
INSERT INTO "node_type" VALUES ('DESGUAS','OUTFALL','OUTFALL', 'man_outfall', 'inp_outfall',true);

-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('CONDUCTE', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('IMPULSIO', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('SIFO', 'SIPHON', 'CONDUIT', 'man_siphon', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('RAPID', 'WACCEL', 'CONDUIT', 'man_waccel', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('FICTICI', 'VARC', 'OUTLET', 'man_varc', 'inp_outlet',true);

-- Records of connec_type
-- ----------------------------
INSERT INTO connec_type VALUES ('ESCOMESA', 'CONNEC', 'man_connec',true);

-- Records of gully_type
-- ----------------------------
INSERT INTO gully_type VALUES ('EMBORNAL', 'GULLY', 'man_gully',true);
INSERT INTO gully_type VALUES ('REIXA', 'GULLY', 'man_gully',true);

-- Records of element type system table
-- ----------------------------
INSERT INTO "element_type" VALUES ('TAPA', true, true, NULL, NULL);
INSERT INTO "element_type" VALUES ('PATE', true, true, NULL, NULL);
INSERT INTO "element_type" VALUES ('BOMBA', true, true, NULL, NULL);
INSERT INTO "element_type" VALUES ('COMPORTA', true, true, NULL, NULL);

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