/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('CONDUCTO', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('SIFON', 'SIPHON', 'ARC');
INSERT INTO cat_feature VALUES ('RAPIDO', 'WACCEL', 'ARC');
INSERT INTO cat_feature VALUES ('FICTICIO', 'VARC', 'ARC'); 
INSERT INTO cat_feature VALUES ('IMPULSION', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('CAMERA', 'CHAMBER', 'NODE');
INSERT INTO cat_feature VALUES ('POZO_CIRCULAR', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('PUNTO_ALTO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTRO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CAMBIO_SECCION', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('NODO_FICTICIO', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('PRESA', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('SALTO', 'WJUMP', 'NODE');
INSERT INTO cat_feature VALUES ('POZO_RECTANGULAR', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('ARQUETA_ARENAL', 'NETINIT', 'NODE');
INSERT INTO cat_feature VALUES ('EDAR', 'WWTP', 'NODE');
INSERT INTO cat_feature VALUES ('VALVULA', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('DEPOSITO', 'STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('DEPOSITO_DESBORDAMIENTO', 'STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('DESAGUE', 'OUTFALL', 'NODE');
INSERT INTO cat_feature VALUES ('SUMIDERO_TOPO', 'NETGULLY', 'NODE');
INSERT INTO cat_feature VALUES ('ACOMETIDA', 'CONNEC', 'CONNEC');
INSERT INTO cat_feature VALUES ('SUMIDERO', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('REJA', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('UNION', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('ELEMENTO_TOPO', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('ESTACION_BOMBEO', 'CHAMBER', 'NODE');


-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('CAMERA', 'CHAMBER', 'STORAGE', 'man_chamber', 'inp_storage');
INSERT INTO node_type VALUES ('POZO_CIRCULAR', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction');
INSERT INTO node_type VALUES ('PUNTO_ALTO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('REGISTRO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('CAMBIO_SECCION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('NODO_FICTICIO', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('PRESA', 'CHAMBER', 'JUNCTION', 'man_chamber', 'inp_junction');
INSERT INTO node_type VALUES ('SALTO', 'WJUMP', 'JUNCTION', 'man_wjump', 'inp_junction');
INSERT INTO node_type VALUES ('POZO_RECTANGULAR', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction');
INSERT INTO node_type VALUES ('ARQUETA_ARENAL', 'NETINIT', 'JUNCTION', 'man_netinit', 'inp_junction');
INSERT INTO node_type VALUES ('EDAR', 'WWTP', 'JUNCTION', 'man_wwtp', 'inp_junction');
INSERT INTO node_type VALUES ('VALVULA', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction');
INSERT INTO node_type VALUES ('DEPOSITO', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage');
INSERT INTO node_type VALUES ('DEPOSITO_DESBORDAMIENTO', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage');
INSERT INTO node_type VALUES ('DESAGUE', 'OUTFALL', 'OUTFALL', 'man_outfall', 'inp_outfall');
INSERT INTO node_type VALUES ('SUMIDERO_TOPO', 'NETGULLY', 'JUNCTION', 'man_netgully', 'inp_junction');
INSERT INTO node_type VALUES ('UNION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('ELEMENTO_TOPO', 'NETELEMENT', 'JUNCTION', 'man_netelement', 'inp_junction');
INSERT INTO node_type VALUES ('ESTACION_BOMBEO', 'CHAMBER', 'STORAGE', 'man_chamber', 'inp_storage');


-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('CONDUCTO', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('IMPULSION', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('SIFON', 'SIPHON', 'CONDUIT', 'man_siphon', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('RAPIDO', 'WACCEL', 'CONDUIT', 'man_waccel', 'inp_conduit',true);
INSERT INTO arc_type VALUES ('FICTICIO', 'VARC', 'OUTLET', 'man_varc', 'inp_outlet',true);

-- Records of connec_type
-- ----------------------------
INSERT INTO connec_type VALUES ('ACOMETIDA', 'CONNEC', 'man_connec',true);

-- Records of gully_type
-- ----------------------------
INSERT INTO gully_type VALUES ('SUMIDERO', 'GULLY', 'man_gully',true);
INSERT INTO gully_type VALUES ('REJA', 'GULLY', 'man_gully',true);

-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('TAPA', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('COMPUERTA', true, true, NULL, NULL);
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