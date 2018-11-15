/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('CONDUIT', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('SIPHON', 'SIPHON', 'ARC');
INSERT INTO cat_feature VALUES ('WACCEL', 'WACCEL', 'ARC');
INSERT INTO cat_feature VALUES ('VARC', 'VARC', 'ARC'); 
INSERT INTO cat_feature VALUES ('PUMP-PIPE', 'CONDUIT', 'ARC');
INSERT INTO cat_feature VALUES ('CHAMBER', 'CHAMBER', 'NODE');
INSERT INTO cat_feature VALUES ('CIRC-MANHOLE', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('HIGHPOINT', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('REGISTER', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('CHANGE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VIRTUAL_NODE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('WEIR', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('JUMP', 'WJUMP', 'NODE');
INSERT INTO cat_feature VALUES ('RECT-MANHOLE', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('SANDBOX', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('WWTP', 'WWTP', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('SEWER-STORAGE', 'STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('OWERFLOW-STORAGE', 'STORAGE', 'NODE');
INSERT INTO cat_feature VALUES ('OUTFALL', 'OUTFALL', 'NODE');
INSERT INTO cat_feature VALUES ('NETGULLY', 'NETGULLY', 'NODE');
INSERT INTO cat_feature VALUES ('CONNEC', 'CONNEC', 'CONNEC');
INSERT INTO cat_feature VALUES ('GULLY', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('PGULLY', 'GULLY', 'GULLY');
INSERT INTO cat_feature VALUES ('JUNCTION', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('NETELEMENT', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('PUMP-STATION', 'CHAMBER', 'NODE');
INSERT INTO cat_feature VALUES ('NETINIT', 'NETINIT', 'NODE');

-- Records of node type system table
-- ----------------------------
INSERT INTO node_type VALUES ('CHAMBER', 'CHAMBER', 'STORAGE', 'man_chamber', 'inp_storage');
INSERT INTO node_type VALUES ('CIRC-MANHOLE', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction');
INSERT INTO node_type VALUES ('HIGHPOINT', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('REGISTER', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('CHANGE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('VIRTUAL_NODE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('WEIR', 'CHAMBER', 'JUNCTION', 'man_chamber', 'inp_junction');
INSERT INTO node_type VALUES ('JUMP', 'WJUMP', 'JUNCTION', 'man_wjump', 'inp_junction');
INSERT INTO node_type VALUES ('RECT-MANHOLE', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction');
INSERT INTO node_type VALUES ('SANDBOX', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction');
INSERT INTO node_type VALUES ('WWTP', 'WWTP', 'JUNCTION', 'man_wwtp', 'inp_junction');
INSERT INTO node_type VALUES ('VALVE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction');
INSERT INTO node_type VALUES ('SEWER-STORAGE', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage');
INSERT INTO node_type VALUES ('OWERFLOW-STORAGE', 'STORAGE', 'STORAGE', 'man_storage', 'inp_storage');
INSERT INTO node_type VALUES ('OUTFALL', 'OUTFALL', 'OUTFALL', 'man_outfall', 'inp_outfall');
INSERT INTO node_type VALUES ('NETGULLY', 'NETGULLY', 'JUNCTION', 'man_netgully', 'inp_junction');
INSERT INTO node_type VALUES ('JUNCTION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction');
INSERT INTO node_type VALUES ('NETELEMENT', 'NETELEMENT', 'JUNCTION', 'man_netelement', 'inp_junction');
INSERT INTO node_type VALUES ('PUMP-STATION', 'CHAMBER', 'STORAGE', 'man_chamber', 'inp_storage');
INSERT INTO node_type VALUES ('NETINIT', 'NETINIT', 'JUNCTION', 'man_netinit', 'inp_junction');

-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('CONDUIT', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit');
INSERT INTO arc_type VALUES ('SIPHON', 'SIPHON', 'CONDUIT', 'man_siphon', 'inp_conduit');
INSERT INTO arc_type VALUES ('WACCEL', 'WACCEL', 'CONDUIT', 'man_waccel', 'inp_conduit');
INSERT INTO arc_type VALUES ('VARC', 'VARC', 'VIRTUAL', 'man_varc', 'inp_virtual');
INSERT INTO arc_type VALUES ('PUMP-PIPE', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit');

-- Records of connec_type
-- ----------------------------
INSERT INTO connec_type VALUES ('CONNEC', 'CONNEC', 'man_connec');

-- Records of gully_type
-- ----------------------------
INSERT INTO gully_type VALUES ('GULLY', 'GULLY', 'man_gully');
INSERT INTO gully_type VALUES ('PGULLY', 'GULLY', 'man_gully');

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