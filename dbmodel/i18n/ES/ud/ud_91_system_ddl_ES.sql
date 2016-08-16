/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO "config" VALUES (1, 0.1, 0.5, 0.5, 0.1, 0.5,false,null,false,null,false);




-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO "node_type" VALUES ('NODO VIRTUAL','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'event_x_junction');
INSERT INTO "node_type" VALUES ('REGISTRO','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('POZO_RECTANGULAR','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('POZO_CIRCULAR','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('CAMBIO DE SECCION','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('PUNTO ALTO','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('SALTO','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('ARQUETA ARENAL','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('PRESA','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('DEPOSITO','STORAGE', 'STORAGE', 'man_storage', 'inp_storage','event_x_storage');
INSERT INTO "node_type" VALUES ('DEPOSITO DE DESBORDAMIENTO','STORAGE', 'STORAGE', 'man_storage', 'inp_storage','event_x_storage');
INSERT INTO "node_type" VALUES ('DESAGUE','OUTFALL','OUTFALL', 'man_outfall', 'inp_outfall', 'event_x_outfall');



-- ----------------------------
-- Records of arc type system table
-- ----------------------------

INSERT INTO "arc_type" VALUES ('CONDUCTO','CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'event_x_conduit' );
INSERT INTO "arc_type" VALUES ('BOMBA','CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'event_x_conduit' );
INSERT INTO "arc_type" VALUES ('SIFON','CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'event_x_conduit' );
INSERT INTO "arc_type" VALUES ('RAPIDO','CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'event_x_conduit' );
INSERT INTO "arc_type" VALUES ('CONDUCTO VIRTUAL','VIRTUAL', 'OUTLET', 'man_virtual', 'inp_outlet', 'event_x_virtual' );



-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO "element_type" VALUES ('TAPA', 'event_x_cover');
INSERT INTO "element_type" VALUES ('PASO', 'event_x_step');
INSERT INTO "element_type" VALUES ('BOMBA', 'event_x_pump');
INSERT INTO "element_type" VALUES ('PUERTA', 'event_x_gate');