/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



-- ----------------------------
-- Records of node type system table
-- ----------------------------

INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('VIRTUAL NODE','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('REGISTER','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('RECT_MANHOLE','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('CIRC_MANHOLE','JUCTION', 'man_node_junction', 'JUNCTION', 'inp_junction');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('STORAGE','STORAGE', 'man_node_storage', 'STORAGE', 'inp_storage');
INSERT INTO "SCHEMA_NAME"."node_type" VALUES ('OUTFALL','OUTFALL', 'man_node_outfall', 'OUTFALL', 'inp_outfall');


-- ----------------------------
-- Records of arc type system table
-- ----------------------------

INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('CONDUIT','CONDUIT', 'man_arc_conduit', 'CONDUIT', 'inp_conduit');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('PUMP','PUMP', 'man_arc_pump', 'PUMP', 'inp_pump');
INSERT INTO "SCHEMA_NAME"."arc_type" VALUES ('VIRTUAL LINK','VIRTUAL LINK', 'man_arc_virtual', 'OUTLET', 'inp_otulet');
