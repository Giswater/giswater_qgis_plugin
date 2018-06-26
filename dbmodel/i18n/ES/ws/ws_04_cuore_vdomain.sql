/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of value_state
-- ----------------------------
INSERT INTO value_state VALUES (0, 'OBSOLETO');
INSERT INTO value_state VALUES (1, 'EN SERVICIO');
INSERT INTO value_state VALUES (2, 'PLANIFICADO');


-- ----------------------------
-- Records of value_state_type
-- ----------------------------

INSERT INTO value_state_type VALUES (1, 0, 'OBSOLETO', false, false);
INSERT INTO value_state_type VALUES (2, 1, 'EN SERVICIO', true, true);
INSERT INTO value_state_type VALUES (3, 2, 'PLANIFICADO', true, true);
INSERT INTO value_state_type VALUES (4, 2, 'RECONSTRUIDO', true, false);
INSERT INTO value_state_type VALUES (5, 1, 'PROVISIONAL', false, true);

-- ----------------------------
-- Records of value_verified
-- ----------------------------
INSERT INTO value_verified VALUES ('PARA REVISAR');
INSERT INTO value_verified VALUES ('VERIFICADO');


-- ----------------------------
-- Records of value_yesno
-- ----------------------------
INSERT INTO value_yesno VALUES ('NO');
INSERT INTO value_yesno VALUES ('SI');

