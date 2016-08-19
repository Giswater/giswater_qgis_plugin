/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of event event_type table
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."event_type" VALUES ('INSPECTION', '');
INSERT INTO "SCHEMA_NAME"."event_type" VALUES ('REPAIR', '');
INSERT INTO "SCHEMA_NAME"."event_type" VALUES ('RECONSTRUCT', '');
INSERT INTO "SCHEMA_NAME"."event_type" VALUES ('OTHER', '');


-- ----------------------------
-- Records of event event_parameter table
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_node_p1','INSPECTION','NODE', 'TEXT', 'Inspection node parameter 1');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_arc_p1','INSPECTION','ARC', 'TEXT', 'Inspection arc parameter 1');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_element_p1','INSPECTION','ELEMENT', 'TEXT', 'Inspection element parameter 1');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_node_p2','INSPECTION','NODE', 'TEXT', 'Inspection node parameter 2');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_arc_p2','INSPECTION','ARC', 'TEXT', 'Inspection arc parameter 2');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_element_p2','INSPECTION','ELEMENT', 'TEXT', 'Inspection element parameter 2');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_node_p3','INSPECTION','NODE', 'TEXT', 'Inspection node parameter 3');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_arc_p3','INSPECTION','ARC', 'TEXT', 'Inspection arc parameter 3');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_element_p3','INSPECTION','ELEMENT', 'TEXT', 'Inspection element parameter 3');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_connec_p1','INSPECTION','CONNEC', 'TEXT', 'Inspection connec parameter 1');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_connec_p2','INSPECTION','CONNEC', 'TEXT', 'Inspection connec parameter 2');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_gully_p1','INSPECTION','CONNEC', 'TEXT', 'Inspection gully parameter 1');
INSERT INTO "SCHEMA_NAME"."event_parameter" VALUES ('insp_gully_p2','INSPECTION','CONNEC', 'TEXT', 'Inspection gully parameter 2');



-- ----------------------------
-- Records of event event_position table
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."event_position" VALUES ('bottom', 'NODE', 'description');
INSERT INTO "SCHEMA_NAME"."event_position" VALUES ('top', 'NODE', 'description');
