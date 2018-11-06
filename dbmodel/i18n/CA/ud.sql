/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('CONDUCTE', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('SIFO', 'SIPHON', 'ARC');
INSERT INTO cat_feature VALUES ('RAPID', 'WACCEL', 'ARC');
INSERT INTO cat_feature VALUES ('FICTICI', 'VARC', 'ARC'); 
INSERT INTO cat_feature VALUES ('IMPULSIO', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('CAMBRA', 'CHAMBER', 'NODE');
INSERT INTO cat_feature VALUES ('POU_CIRCULAR', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('PUNT_ALT', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CANVI_SECCIO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('NODE_FICTICI', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('PRESA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('SALT', 'WJUMP', 'NODE');
INSERT INTO cat_feature VALUES ('POU_RECTANGULAR', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('ARQUETA_SORRERA', 'NETINIT', 'NODE');
INSERT INTO cat_feature VALUES ('EDAR', 'WWTP', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('DIPOSIT', 'STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('DIPOSIT_DESBORDAMENT', 'STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('DESGUAS', 'OUTFALL', 'NODE');
INSERT INTO cat_feature VALUES ('EMBORNAL_TOPO', 'NETGULLY', 'NODE');
INSERT INTO cat_feature VALUES ('ESCOMESA', 'CONNEC', 'CONNEC');
INSERT INTO cat_feature VALUES ('EMBORNAL', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('REIXA', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('UNIO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('ELEMENT_TOPO', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('ESTACIO_BOMBAMENT', 'CHAMBER', 'NODE');


-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('CAMBRA', 'CHAMBER', 'STORAGE', 'man_chamber', 'inp_storage');
INSERT INTO node_type VALUES ('POU_CIRCULAR', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction');
INSERT INTO node_type VALUES ('PUNT_ALT', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('REGISTRE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('CANVI_SECCIO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('NODE_FICTICI', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('PRESA', 'CHAMBER', 'JUNCTION', 'man_chamber', 'inp_junction');
INSERT INTO node_type VALUES ('SALT', 'WJUMP', 'JUNCTION', 'man_wjump', 'inp_junction');
INSERT INTO node_type VALUES ('POU_RECTANGULAR', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction');
INSERT INTO node_type VALUES ('ARQUETA_SORRERA', 'NETINIT', 'JUNCTION', 'man_netinit', 'inp_junction');
INSERT INTO node_type VALUES ('EDAR', 'WWTP', 'JUNCTION', 'man_wwtp', 'inp_junction');
INSERT INTO node_type VALUES ('VALVULA', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction');
INSERT INTO node_type VALUES ('DIPOSIT', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage');
INSERT INTO node_type VALUES ('DIPOSIT_DESBORDAMENT', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage');
INSERT INTO node_type VALUES ('DESGUAS', 'OUTFALL', 'OUTFALL', 'man_outfall', 'inp_outfall');
INSERT INTO node_type VALUES ('EMBORNAL_TOPO', 'NETGULLY', 'JUNCTION', 'man_netgully', 'inp_junction');
INSERT INTO node_type VALUES ('UNIO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('ELEMENT_TOPO', 'NETELEMENT', 'JUNCTION', 'man_netelement', 'inp_junction');
INSERT INTO node_type VALUES ('ESTACIO_BOMBAMENT', 'CHAMBER', 'STORAGE', 'man_chamber', 'inp_storage');


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
INSERT INTO element_type VALUES ('TAPA', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('COMPORTA', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('SENSOR_IOT', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('BOMBA', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('PATE', true, true, NULL, NULL);
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