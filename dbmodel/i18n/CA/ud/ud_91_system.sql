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
INSERT INTO "node_type" VALUES ('NODE VIRTUAL','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'event_x_junction');
INSERT INTO "node_type" VALUES ('REGISTRE','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('POU_RECTANGULAR','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('POU_CIRCULAR','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('CANVI DE SECCIO','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('PUNT ALT','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('SALT','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('ARQUETA SORRERA','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('PRESA','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "node_type" VALUES ('DIPOSIT','STORAGE', 'STORAGE', 'man_storage', 'inp_storage','event_x_storage');
INSERT INTO "node_type" VALUES ('DIPOSIT DE DESBORDAMENT','STORAGE', 'STORAGE', 'man_storage', 'inp_storage','event_x_storage');
INSERT INTO "node_type" VALUES ('DESGUAS','OUTFALL','OUTFALL', 'man_outfall', 'inp_outfall', 'event_x_outfall');



-- ----------------------------
-- Records of arc type system table
-- ----------------------------

INSERT INTO arc_type VALUES ('CONDUCTE', 'CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'om_visit_x_arc');
INSERT INTO arc_type VALUES ('IMPULSIO', 'CONDUIT', 'FORCE_MAIN', 'man_conduit', 'inp_conduit', 'om_visit_x_arc');
INSERT INTO arc_type VALUES ('SIFO', 'SIPHON', 'CONDUIT', 'man_siphon', 'inp_conduit', 'om_visit_x_arc');
INSERT INTO arc_type VALUES ('RAPID', 'WACCEL', 'CONDUIT', 'man_waccel', 'inp_conduit', 'om_visit_x_arc');
INSERT INTO arc_type VALUES ('FICTICI', 'VARC', 'OUTLET', 'man_varc', 'inp_outlet', 'om_visit_x_arc');


-- ----------------------------
-- Records of connec_type
-- ----------------------------
INSERT INTO connec_type VALUES ('ESCOMESA', 'CONNEC', 'man_connec' ,'om_visit_x_connec');


-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO "element_type" VALUES ('TAPA', 'COVER');
INSERT INTO "element_type" VALUES ('PATE', 'STEP');
INSERT INTO "element_type" VALUES ('BOMBA', 'PUMP');
INSERT INTO "element_type" VALUES ('COMPORTA', 'GATE');