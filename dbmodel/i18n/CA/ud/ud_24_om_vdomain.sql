/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- Records of event om_visit_parameter_type table
-- ----------------------------
INSERT INTO "om_visit_parameter_type" VALUES ('INSPECCIO', '');
INSERT INTO "om_visit_parameter_type" VALUES ('REPARACIO', '');
INSERT INTO "om_visit_parameter_type" VALUES ('RECONSTRUCCIO', '');
INSERT INTO "om_visit_parameter_type" VALUES ('ALTRES', '');
INSERT INTO "om_visit_parameter_type" VALUES ('FOTOGRAFIA', '');

-- ----------------------------
-- Records of event om_visit_parameter table
-- ----------------------------
INSERT INTO "om_visit_parameter" VALUES ('insp_node_p1','INSPECCIO','NODE', 'TEXT', 'Inspeccio del node parametre 1');
INSERT INTO "om_visit_parameter" VALUES ('insp_arc_p1','INSPECCIO','ARC', 'TEXT', 'Inspeccio del arc parametre 1');
INSERT INTO "om_visit_parameter" VALUES ('insp_node_p2','INSPECCIO','NODE', 'TEXT', 'Inspeccio del node parametre 2');
INSERT INTO "om_visit_parameter" VALUES ('insp_arc_p2','INSPECCIO','ARC', 'TEXT', 'Inspeccio del arc parametre 2');
INSERT INTO "om_visit_parameter" VALUES ('insp_node_p3','INSPECCIO','NODE', 'TEXT', 'Inspeccio del node parametre 3');
INSERT INTO "om_visit_parameter" VALUES ('insp_arc_p3','INSPECCIO','ARC', 'TEXT', 'Inspeccio del arc parametre 3');
INSERT INTO "om_visit_parameter" VALUES ('insp_connec_p1','INSPECCIO','CONNEXIO', 'TEXT', 'Inspeccio de la escomesa parametre 1');
INSERT INTO "om_visit_parameter" VALUES ('insp_connec_p2','INSPECCIO','CONNEXIO', 'TEXT', 'Inspeccio de la escomesa parametre 2');
INSERT INTO "om_visit_parameter" VALUES ('insp_gully_p1','INSPECCIO','EMBORNAL', 'TEXT', 'Inspeccio del embornal parametre 1');
INSERT INTO "om_visit_parameter" VALUES ('insp_gully_p2','INSPECCIO','EMBORNAL', 'TEXT', 'Inspeccio del embornal parametre 2');
INSERT INTO "om_visit_parameter" VALUES ('insp_gully_p3','INSPECCIO','EMBORNAL', 'TEXT', 'Inspeccio del embornal parametre 3');
INSERT INTO "om_visit_parameter" VALUES ('png','FOTOGRAFIA','TOTS', '', '');



-- ----------------------------
-- Records of event om_visit_value_position table
-- ----------------------------
INSERT INTO "om_visit_parameter" VALUES ('inferior', 'NODE', 'descripcio');
INSERT INTO "om_visit_parameter" VALUES ('superior', 'NODE', 'descripcio');
