/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


INSERT INTO "SCHEMA_NAME"."config" VALUES (1, 0.1, 0.5, 0.5, 0.1, 0.5,false,null,false,null,false);




-- ----------------------------
-- Records of node type system table
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('VIRTUAL NODE','JUNCTION','JUNCTION', 'man_junction', 'inp_junction', 'event_x_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('REGISTER','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('RECT_MANHOLE','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('CIRC_MANHOLE','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('SECTION CHANGE','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('HIGH POINT','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('JUMP','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('SANDBOX','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('WEIR','JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction','event_x_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('SEWER STORAGE','STORAGE', 'STORAGE', 'man_storage', 'inp_storage','event_x_storage');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('OWERFLOWS STORAGE','STORAGE', 'STORAGE', 'man_storage', 'inp_storage','event_x_storage');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('OUTFALL','OUTFALL','OUTFALL', 'man_outfall', 'inp_outfall', 'event_x_outfall');



-- ----------------------------
-- Records of arc type system table
-- ----------------------------

INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('CONDUIT','CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'event_x_conduit' );
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PUMP PIPE','CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'event_x_conduit' );
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('SIPHON','CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'event_x_conduit' );
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('RAPID','CONDUIT', 'CONDUIT', 'man_conduit', 'inp_conduit', 'event_x_conduit' );
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('VIRTUAL','VIRTUAL', 'OUTLET', 'man_virtual', 'inp_outlet', 'event_x_virtual' );



-- ----------------------------
-- Records of element type system table
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."element_type" VALUES ('COVER', 'event_x_cover');
INSERT INTO "SCHEMA_NAME"."element_type" VALUES ('STEP', 'event_x_step');
INSERT INTO "SCHEMA_NAME"."element_type" VALUES ('PUMP', 'event_x_pump');
INSERT INTO "SCHEMA_NAME"."element_type" VALUES ('GATE', 'event_x_gate');