/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Records of event om_visit_parameter_type table
-- ----------------------------
INSERT INTO om_visit_parameter_type VALUES ('INSPECCION', '');
INSERT INTO om_visit_parameter_type VALUES ('REPARACION', '');
INSERT INTO om_visit_parameter_type VALUES ('RECONSTRUIR', '');
INSERT INTO om_visit_parameter_type VALUES ('OTROS', '');
INSERT INTO "om_visit_parameter_type" VALUES ('FOTOGRAFIA', '');



-- ----------------------------
-- Records of event om_visit_parameter table
-- ----------------------------
INSERT INTO om_visit_parameter VALUES ('insp_node_p1','INSPECCION','NODO', 'TEXTO', 'Inspeccion del nodo parametro 1');
INSERT INTO om_visit_parameter VALUES ('insp_arc_p1','INSPECCION','ARCO', 'TEXTO', 'Inspeccion del arco parametro 1');
INSERT INTO om_visit_parameter VALUES ('insp_element_p1','INSPECCION','ELEMENTO', 'TEXTO', 'Inspeccion del elemento parametro 1');
INSERT INTO om_visit_parameter VALUES ('insp_node_p2','INSPECCION','NODO', 'TEXTO', 'Inspeccion del nodo parametro 2');
INSERT INTO om_visit_parameter VALUES ('insp_arc_p2','INSPECCION','ARCO', 'TEXTO', 'Inspeccion del arco parametro 2');
INSERT INTO om_visit_parameter VALUES ('insp_element_p2','INSPECCION','ELEMENTO', 'TEXTO', 'Inspeccion del elemento parametro 2');
INSERT INTO om_visit_parameter VALUES ('insp_node_p3','INSPECCION','NODO', 'TEXTO', 'Inspeccion del nodo parametro 3');
INSERT INTO om_visit_parameter VALUES ('insp_arc_p3','INSPECCION','ARCO', 'TEXTO', 'Inspeccion del arco parametro 3');
INSERT INTO om_visit_parameter VALUES ('insp_element_p3','INSPECCION','ELEMENTO', 'TEXTO', 'Inspeccion del elemento parametro 3');
INSERT INTO om_visit_parameter VALUES ('insp_connec_p1','INSPECCION','CONEXON', 'TEXTO', 'Inspeccion de la acometida parametro 1');
INSERT INTO om_visit_parameter VALUES ('insp_connec_p2','INSPECCION','CONEXON', 'TEXTO', 'Inspeccion de la acometida parametro 2');
INSERT INTO "om_visit_parameter" VALUES ('png','FOTOGRAFIA','TOTS', '', '');


-- ----------------------------
-- Records of event om_visit_value_position table
-- ----------------------------
INSERT INTO om_visit_value_position VALUES ('inferior', 'NODO', 'descripcion');
INSERT INTO om_visit_value_position VALUES ('superior', 'NODO', 'descripcion');