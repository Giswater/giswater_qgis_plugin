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
INSERT INTO value_priority VALUES ('HIGH_PRIORITY');
INSERT INTO value_priority VALUES ('NORMAL_PRIORITY');
INSERT INTO value_priority VALUES ('LOW_PRIORITY');


INSERT INTO plan_result_type VALUES (1,'Reconstruction');
INSERT INTO plan_result_type VALUES (2,'Rehabilitation');

-- ----------------------------
-- Records of review
-- ----------------------------
INSERT INTO value_review_validation VALUES (0, 'Rejected');
INSERT INTO value_review_validation VALUES (1, 'Accepted');
INSERT INTO value_review_validation VALUES (2, 'To review');

INSERT INTO value_review_status VALUES (0, 'There are no changes above or below the tolerance values', 'No changes');
INSERT INTO value_review_status VALUES (1, 'New element inserted in the review', 'new element');
INSERT INTO value_review_status VALUES (2, 'Geometry modified in the review. Other data can also be modified', 'Geometry modified');
INSERT INTO value_review_status VALUES (3, 'Changes in the data, not in the geometry', 'Data modified');





