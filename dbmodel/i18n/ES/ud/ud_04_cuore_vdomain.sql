/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of value_state
-- ----------------------------
INSERT INTO "value_state" VALUES (0,'OBSOLETO');
INSERT INTO "value_state" VALUES (1,'EN_SERVICIO');
INSERT INTO "value_state" VALUES (2,'PLANIFICADO');


-- ----------------------------
-- Records of value_state_type
-- ----------------------------
INSERT INTO value_state_type VALUES (1, 0, 'OBSOLETO', false, false);
INSERT INTO value_state_type VALUES (2, 1, 'EN_SERVICIO', true, true);
INSERT INTO value_state_type VALUES (3, 2, 'PLANIFICADO', true, true);
INSERT INTO value_state_type VALUES (4, 2, 'RECONSTRUIDO', true, false);
INSERT INTO value_state_type VALUES (5, 1, 'PROVISIONAL', false, true);


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
-- Records of man_type_category
-- ----------------------------
INSERT INTO man_type_category VALUES (1, 'Categoría estándar', 'NODE');
INSERT INTO man_type_category VALUES (2, 'Categoría estándar', 'ARC');
INSERT INTO man_type_category VALUES (3, 'Categoría estándar', 'CONNEC');
INSERT INTO man_type_category VALUES (4, 'Categoría estándar', 'ELEMENT');
INSERT INTO man_type_category VALUES (5, 'Categoría estándar', 'GULLY');

-- ----------------------------
-- Records of man_type_fluid
-- ----------------------------
INSERT INTO man_type_fluid VALUES (1, 'Fluido estándar', 'NODE');
INSERT INTO man_type_fluid VALUES (2, 'Fluido estándar', 'ARC');
INSERT INTO man_type_fluid VALUES (3, 'Fluido estándar', 'CONNEC');
INSERT INTO man_type_fluid VALUES (4, 'Fluido estándar', 'ELEMENT');
INSERT INTO man_type_fluid VALUES (5, 'Fluido estándar', 'GULLY');

-- ----------------------------
-- Records of man_type_location
-- ----------------------------
INSERT INTO man_type_location VALUES (1, 'Localización estándar', 'NODE');
INSERT INTO man_type_location VALUES (2, 'Localización estándar', 'ARC');
INSERT INTO man_type_location VALUES (3, 'Localización estándar', 'CONNEC');
INSERT INTO man_type_location VALUES (4, 'Localización estándar', 'ELEMENT');
INSERT INTO man_type_location VALUES (5, 'Localización estándar', 'GULLY');

-- ----------------------------
-- Records of man_type_function
-- ----------------------------
INSERT INTO man_type_function VALUES (1, 'Función estándar', 'NODE');
INSERT INTO man_type_function VALUES (2, 'Función estándar', 'ARC');
INSERT INTO man_type_function VALUES (3, 'Función estándar', 'CONNEC');
INSERT INTO man_type_function VALUES (4, 'Función estándar', 'ELEMENT');
INSERT INTO man_type_function VALUES (5, 'Función estándar', 'GULLY');
