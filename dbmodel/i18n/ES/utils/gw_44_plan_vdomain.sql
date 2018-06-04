/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Records of price_value_unit
-- ----------------------------
INSERT INTO price_value_unit VALUES ('m3');
INSERT INTO price_value_unit VALUES ('m2');
INSERT INTO price_value_unit VALUES ('m');
INSERT INTO price_value_unit VALUES ('pa');
INSERT INTO price_value_unit VALUES ('u');
INSERT INTO price_value_unit VALUES ('kg');
INSERT INTO price_value_unit VALUES ('t');


-- ----------------------------
-- Records of value_priority
-- ----------------------------
INSERT INTO value_priority VALUES ('PRIORIDAD ALTA');
INSERT INTO value_priority VALUES ('PRIORIDAD MEDIA');
INSERT INTO value_priority VALUES ('PRIORIDAD BAJA');

INSERT INTO plan_result_type VALUES (1,'Reconstrucción');
INSERT INTO plan_result_type VALUES (2,'Rehabilitación');


INSERT INTO plan_psector_cat_type VALUES (1,'Planificado');


INSERT INTO om_psector_cat_type VALUES (1,'Reconstrucción');
INSERT INTO om_psector_cat_type VALUES (2,'Rehabilitación');



-- ----------------------------
-- Records of review
-- ----------------------------
INSERT INTO value_review_validation VALUES (0, 'Rechazado');
INSERT INTO value_review_validation VALUES (1, 'Aceptado');
INSERT INTO value_review_validation VALUES (2, 'A revisar');

INSERT INTO value_review_status VALUES (0, 'No hay cambios por encima o debajo de los valores de tolerancia', 'Sin cambios');
INSERT INTO value_review_status VALUES (1, 'Nuevo elemento introducido para revisar', 'Nuevo elemento');
INSERT INTO value_review_status VALUES (2, 'Geometría modificada en la revisión. Otros datos pueden ser modificados', 'Geometría modificada');
INSERT INTO value_review_status VALUES (3, 'Cambios en los datos, no en la geometría', 'Datos modificados');




