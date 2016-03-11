/*
This file is part of Giswater
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
-- Records of event_value
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."event_value" VALUES ('EXCELENT', 1,'Excelent');
INSERT INTO "SCHEMA_NAME"."event_value" VALUES ('GOOD', 2,'Excelent');
INSERT INTO "SCHEMA_NAME"."event_value" VALUES ('NORMAL', 3,'Excelent');
INSERT INTO "SCHEMA_NAME"."event_value" VALUES ('BAD', 4,'Excelent');
INSERT INTO "SCHEMA_NAME"."event_value" VALUES ('VERY BAD', 5,'Excelent');


-- ----------------------------
-- Records of cat_event
-- ----------------------------
INSERT INTO "SCHEMA_NAME"."cat_event" VALUES ('EV01', 'INSPECTION','Inspecció 2014', 'Prova');
INSERT INTO "SCHEMA_NAME"."cat_event" VALUES ('EV02', 'INSPECTION','Inspecció 2015', 'Prova');
INSERT INTO "SCHEMA_NAME"."cat_event" VALUES ('EV03', 'INSPECTION','Inspecció 2016', 'Prova');
INSERT INTO "SCHEMA_NAME"."cat_event" VALUES ('EV04', 'REPAIR','Reparació 2015', 'Prova');

