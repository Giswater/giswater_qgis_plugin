/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Records of event om_visit_parameter_type table
-- ----------------------------
INSERT INTO om_visit_parameter_type VALUES ('INSPECCIO', '');
INSERT INTO om_visit_parameter_type VALUES ('REPARACIO', '');
INSERT INTO om_visit_parameter_type VALUES ('RECONSTRUIR', '');
INSERT INTO om_visit_parameter_type VALUES ('ALTRES', '');
INSERT INTO om_visit_parameter_type VALUES ('FOTOGRAFIA', '');


-- ----------------------------
-- Records of event om_visit_parameter table
-- ----------------------------

INSERT INTO om_visit_parameter VALUES ('Reparació arc tipus 1', NULL, 'REPARACIO', 'ARC', 'TEXT', NULL, 'Reparació del arc parametre 1', 'event_ud_arc_rehabit', 'a');
INSERT INTO om_visit_parameter VALUES ('Reparació arc tipus 2', NULL, 'REPARACIO', 'ARC', 'TEXT', NULL, 'Reparació del arc parametre 2', 'event_ud_arc_rehabit', 'b');
INSERT INTO om_visit_parameter VALUES ('Inspecció arc tipus 1', NULL, 'INSPECCIO', 'ARC', 'TEXT', NULL, 'Inspeccio del arc parametre 1', 'event_ud_arc_standard', 'c');
INSERT INTO om_visit_parameter VALUES ('Inspecció arc tipus 2', NULL, 'INSPECCIO', 'ARC', 'TEXT', NULL, 'Inspeccio del arc parametre 2', 'event_ud_arc_standard', 'f');
INSERT INTO om_visit_parameter VALUES ('Inspecció connec tipus 1', NULL, 'INSPECCIO', 'CONNEC', 'TEXT', NULL, 'Inspeccio del connec parametre 1', 'event_standard', 'd');
INSERT INTO om_visit_parameter VALUES ('Inspecció connec tipus 2', NULL, 'INSPECCIO', 'CONNEC', 'TEXT', NULL, 'Inspeccio del connec parametre 2', 'event_standard', 'e');
INSERT INTO om_visit_parameter VALUES ('Inspecció node tipus 1', NULL, 'INSPECCIO', 'NODE', 'TEXT', NULL, 'Inspeccio del node parametre 1', 'event_standard', 'f');
INSERT INTO om_visit_parameter VALUES ('Inspecció node tipus 2', NULL, 'INSPECCIO', 'NODE', 'TEXT', NULL, 'Inspeccio del node parametre 2', 'event_standard', 'g');
INSERT INTO om_visit_parameter VALUES ('Inspecció node tipus 3', NULL, 'INSPECCIO', 'NODE', 'TEXT', NULL, 'Inspeccio del node parametre 3', 'event_standard', 'i');

-- ----------------------------
-- Records of event om_visit_value_position table
-- ----------------------------
--INSERT INTO om_visit_value_position VALUES ('inferior', 'NODE', 'descripcio');
--INSERT INTO om_visit_value_position VALUES ('superior', 'NODE', 'descripcio');