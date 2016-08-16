/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of value_state
-- ----------------------------
INSERT INTO value_state VALUES ('OBSOLET');
INSERT INTO value_state VALUES ('EN_SERVEI');
INSERT INTO value_state VALUES ('RECONSTRUIR');
INSERT INTO value_state VALUES ('SUBSTITUIR');
INSERT INTO value_state VALUES ('PLANIFICAT');


-- ----------------------------
-- Records of value_verified
-- ----------------------------
INSERT INTO value_verified VALUES ('PER REVISAR');
INSERT INTO value_verified VALUES ('VERIFICAT');


-- ----------------------------
-- Records of value_yesno
-- ----------------------------
INSERT INTO value_yesno VALUES ('NO');
INSERT INTO value_yesno VALUES ('SI');



-- ----------------------------
-- Records of connec_type
-- ----------------------------
INSERT INTO connec_type VALUES ('DOMESTIC', NULL);
INSERT INTO connec_type VALUES ('COMERCIAL', NULL);
INSERT INTO connec_type VALUES ('INDUSTRIAL', NULL);


-- ----------------------------
-- Records of man_type_category
-- ----------------------------
INSERT INTO man_type_category VALUES ('SENSE DADES DE CATEGORIA', null);


-- ----------------------------
-- Records of man_type_fluid
-- ----------------------------
INSERT INTO man_type_fluid VALUES ('SENSE DADES DE FLUIDS', null);


-- ----------------------------
-- Records of man_type_location
-- ----------------------------
INSERT INTO man_type_location VALUES ('SENSE DADES DE UBICACIO', null);


-- ----------------------------
-- Records of selector_valve
-- ----------------------------
INSERT INTO man_selector_valve VALUES ('VALVULA DE TANCAMENT');


