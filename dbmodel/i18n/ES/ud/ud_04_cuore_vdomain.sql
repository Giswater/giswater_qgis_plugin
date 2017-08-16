/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of value_state
-- ----------------------------
INSERT INTO "value_state" VALUES ('OBSOLETO');
INSERT INTO "value_state" VALUES ('EN_SERVICIO');
INSERT INTO "value_state" VALUES ('RECONSTRUIR');
INSERT INTO "value_state" VALUES ('SUBSTITUIR');
INSERT INTO "value_state" VALUES ('PLANIFICADO');


-- ----------------------------
-- Records of value_verified
-- ----------------------------
INSERT INTO "value_verified" VALUES ('PARA REVISAR');
INSERT INTO "value_verified" VALUES ('VERIFICADO');


-- ----------------------------
-- Records of value_yesno
-- ----------------------------
INSERT INTO "value_yesno" VALUES ('NO');
INSERT INTO "value_yesno" VALUES ('SI');


-- ----------------------------
-- Records of connec_type
-- ----------------------------
INSERT INTO connec_type VALUES ('DOMESTICO', NULL);
INSERT INTO connec_type VALUES ('COMERCIAL', NULL);
INSERT INTO connec_type VALUES ('INDUSTRIAL', NULL);


-- ----------------------------
-- Records of man_type_category
-- ----------------------------
INSERT INTO "man_type_category" VALUES ('SIN DATOS DE CATEGORIA', null);


-- ----------------------------
-- Records of man_type_fluid
-- ----------------------------
INSERT INTO "man_type_fluid" VALUES ('SIN DATOS DE FLUIDOS', null);


-- ----------------------------
-- Records of man_type_location
-- ----------------------------
INSERT INTO "man_type_location" VALUES ('SIN DATOS DE LOCALITZACION', null);