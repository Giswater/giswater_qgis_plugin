/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of event event_type table
-- ----------------------------
INSERT INTO "sample_ud"."event_type" VALUES ('INSPECTION', '');
INSERT INTO "sample_ud"."event_type" VALUES ('REPAIR', '');
INSERT INTO "sample_ud"."event_type" VALUES ('RECONSTRUCT', '');
INSERT INTO "sample_ud"."event_type" VALUES ('OTHER', '');


-- ----------------------------
-- Records of event_value
-- ----------------------------
INSERT INTO "sample_ud"."event_value" VALUES ('EXCELENT', 1,'Excelent');
INSERT INTO "sample_ud"."event_value" VALUES ('GOOD', 2,'Good');
INSERT INTO "sample_ud"."event_value" VALUES ('NORMAL', 3,'Normal');
INSERT INTO "sample_ud"."event_value" VALUES ('BAD', 4,'Bad');
INSERT INTO "sample_ud"."event_value" VALUES ('VERY BAD', 5,'Very bad');


-- ----------------------------
-- Records of event_value_struc
-- ----------------------------
INSERT INTO "sample_ud"."event_value_struc" VALUES ('EXCELENT STR.', 1,'Excelent');
INSERT INTO "sample_ud"."event_value_struc" VALUES ('GOOD STR.', 2,'Good');
INSERT INTO "sample_ud"."event_value_struc" VALUES ('NORMAL STR.', 3,'Normal');
INSERT INTO "sample_ud"."event_value_struc" VALUES ('BAD STR.', 4,'Bad');
INSERT INTO "sample_ud"."event_value_struc" VALUES ('VERY BAD STR.', 5,'Very bad');


-- ----------------------------
-- Records of event_value_sediment
-- ----------------------------
INSERT INTO "sample_ud"."event_value_sediment" VALUES ('< 2%', 1,'Excelent');
INSERT INTO "sample_ud"."event_value_sediment" VALUES ('2-5%', 2,'Good');
INSERT INTO "sample_ud"."event_value_sediment" VALUES ('5-10%', 3,'Normal');
INSERT INTO "sample_ud"."event_value_sediment" VALUES ('10-20%', 4,'Bad');
INSERT INTO "sample_ud"."event_value_sediment" VALUES ('>20', 5,'Very bad');


-- ----------------------------
-- Records of event_value_coverstate
-- ----------------------------
INSERT INTO "sample_ud"."event_value_coverstate" VALUES ('EXCELENT', 1,'Excelent');
INSERT INTO "sample_ud"."event_value_coverstate" VALUES ('NORMAL', 2,'Good');
INSERT INTO "sample_ud"."event_value_coverstate" VALUES ('TO REPAIR', 3,'Normal');
INSERT INTO "sample_ud"."event_value_coverstate" VALUES ('TO REPLACE', 4,'Bad');