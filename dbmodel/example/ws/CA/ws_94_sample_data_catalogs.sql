/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of cat_mat_arc
-- ----------------------------
INSERT INTO cat_mat_arc VALUES ('S/I', NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_mat_arc VALUES ('PVC', 'PVC', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_arc VALUES ('FD', 'Fundició', 120.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_arc VALUES ('FC', 'Fibrociment', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_arc VALUES ('PE-AD', 'Polietilè alta densitat', 140.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_arc VALUES ('PE-BD', 'Polietilè baixa densitat', 130.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');



-- ----------------------------
-- Records of cat_press_zone
-- ----------------------------
INSERT INTO cat_press_zone VALUES ('ALTA');
INSERT INTO cat_press_zone VALUES ('MITJA');
INSERT INTO cat_press_zone VALUES ('BAIXA');




-- ----------------------------
-- Records of cat_mat_element
-- ----------------------------
INSERT INTO cat_mat_element VALUES ('S/I', NULL, NULL, NULL, NULL);
INSERT INTO cat_mat_element VALUES ('FD', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL);
INSERT INTO cat_mat_element VALUES ('FORMIGO', NULL, NULL, NULL, NULL);
INSERT INTO cat_mat_element VALUES ('OBRA+FERRO', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_mat_node
-- ----------------------------
INSERT INTO cat_mat_node VALUES ('S/I', NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_mat_node VALUES ('PVC', 'PVC', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('FD', 'Funcidió', 120.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('FD-FD-PVC', 'Fundició-Fundició-PVC', NULL, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('CC', 'Formigó', 100.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('FC-FC-FC', 'Fibrociment', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');
INSERT INTO cat_mat_node VALUES ('FC', 'Fibrociment', 150.0000, 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg');


-- ----------------------------
-- Records of cat_arc
-- ---------------------------
INSERT INTO cat_arc VALUES ('PVC63-PN10', 'TUBERIA', 'PVC', '10 atm', '63 mm', 60.00000, 63.00000, 'Tuberia de PVC', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc63_pn10.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('PVC110-PN16', 'TUBERIA', 'PVC', '16 atm', '110 mm', 105.00000, 110.00000, 'Tuberia de PVC', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc110_pn16.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('PVC200-PN16', 'TUBERIA', 'PVC', '16 atm', '200 mm', 186.00000, 200.00000, 'Tuberia de PVC', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc200_pn16.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('FD150', 'TUBERIA', 'FD', NULL, '150 mm', 150.00000, 170.00000, 'Tuberia de fundició', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fd150.svg', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('FD200', 'TUBERIA', 'FD', NULL, '200 mm', 200.00000, 222.00000, 'Tuberia de fundició', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fd200.svg',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('PEHD110-PN16', 'TUBERIA', 'PE-AD', '16 atm', '110 mm', 100.00000, 110.00000, 'Tuberia PEAD', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pehd110_pn16.svg',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('PELD110-PN10', 'TUBERIA', 'PE-BD', '10 atm', '110 mm', 100.00000, 110.00000, 'Tuberia PEBD', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'peld110_pn10.svg',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('PVC160-PN16', 'TUBERIA', 'PVC', '16 atm', '160 mm', 150.00000, 160.00000, 'Tuberia de PVC', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pvc160_pn16.svg',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('FC63-PN10', 'TUBERIA', 'FC', '10 atm', '63 mm', 55.00000, 63.00000, 'Tuberia de fundició', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fc63_pn10.svg',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('FC110-PN10', 'TUBERIA', 'FC', '10 atm', '110 mm', 100.00000, 110.00000, 'Tuberia de fundició', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fc110_pn10.svg',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_arc VALUES ('FC160-PN10', 'TUBERIA', 'FC', '10 atm', '160 mm', 150.00000, 160.00000, 'Tuberia de fundició', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'fc160_pn10.svg',NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_node
-- ----------------------------
INSERT INTO cat_node VALUES ('VALV_PAS_DN160 PN16', 'VALVULA DE PAS', 'FD', '16 atm', '160 mm', 148.00000, '160 mm', 'Valvula de tancament 160 mm', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VALV_PAS_DN110 PN16', 'VALVULA DE PAS', 'FD', '16 atm', '110 mm', 100.00000, '110 mm', 'Valvula de tancament 110 mm', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VALV_PAS_DN63 PN16', 'VALVULA DE PAS', 'FD', '16 atm', '63 mm', 55.00000, '63 mm', 'Valvula de tancament 63 mm', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('UNIO DN63', 'UNIO', 'FD', '16 atm', NULL, NULL, '63 mm', 'Unió de 63mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('UNIO DN110', 'UNIO', 'FD', '16 atm', NULL, NULL, '110 mm', 'Unió de 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('UNIO DN160', 'UNIO', 'FD', '16 atm', NULL, NULL, '160 mm', 'Unió de 160mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('UNIO DN200', 'UNIO', 'FD', '16 atm', NULL, NULL, '200 mm', 'Unió de 200mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('DESCARREGA-01', 'VALVULA DESCARREGA', 'FD', '16 atm', NULL, NULL, NULL, 'Vàlvula de descàrrega', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('MES_PRESSIO_DN63 PN16', 'MESURADOR PRESSIO', 'FD', '16 atm', '63 mm', NULL, '63 mm', 'Mesurador de pressió 63 mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pressuremeter.svg', NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('MES_PRESSIO_DN110 PN16', 'MESURADOR PRESSIO', 'FD', '16 atm', '110 mm', NULL, '110 mm', 'Mesurador de pressió 110 mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'pressuremeter.svg', NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('RETENCIO_100-PN10', 'VALVULA RETENCIO', 'FD', '10 atm', '100 mm', 95.00000, 'Valvula retenció', 'Valvula de retenció 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('HIDRANT 1X110-2X63', 'HIDRANT', 'FD', '16 atm', '110 mm', NULL, '110-63 mm', 'Hidrant de 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'hydrant_1x110_2x63.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('TDN160-110 PN16', 'T', 'FD', '16 atm', '110-160-160 mm', NULL, '110-160-160 mm', 'T de fundició', NULL, NULL, 't_noequal.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VALVULAREGDN63 PN16', 'VALVULA DE REG', 'FD', '16 atm', '63 mm', NULL, '63 mm', 'Vàlvula de reg 63mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'greenvalve.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VALVULAREGDN110 PN16', 'VALVULA DE REG', 'FD', '16 atm', '110 mm', NULL, '110 mm', 'Vàlvula de reg 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'greenvalve.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VALVULAREGDN50 PN16', 'VALVULA DE REG', 'FD', '16 atm', '50 mm', NULL, '50 mm', 'Vàlvula de reg 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'greenvalve.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VALVULAREDUC200-PN6/16', 'VALVULA REDUCTORA', 'FD', '6-16 atm', '200 mm', 186.00000, '200 mm', 'Vàlvula reductora de pressió', 'c:\\users\users\catalog.jpg', 'http://url.info', 'prv.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('RETENCIO_200-PN10', 'VALVULA RETENCIO', 'FD', '10 atm', '200 mm', 186.00000, 'Valvula retenció', 'Valvula de retenció 200mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('RETENCIO_300-PN10', 'VALVULA RETENCIO', 'FD', '10 atm', '300 mm', 186.00000, 'Valvula retenció', 'Valvula de retenció 300mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'chkvalve.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VALVULA_AIREDN50', 'VALVULA D''AIRE', 'FD', '16 atm', '50 mm', NULL, '50 mm', 'Vàlvula d''aire 50mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'airvalve.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('TDN63-63 PN16', 'T', 'PVC', '16 atm', '63-63-63 mm', NULL, '63-63-63 mm', 'T de PVC', NULL, NULL, 't_equal.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('TDN110-110 PN16', 'T', 'FD', '16 atm', '110-110-110 mm', NULL, '110-110-110 mm', 'T de fundició', 'c:\\users\users\catalog.pdf', 'http://url.info', 't_equal.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('BOMBA-01', 'EBAP', 'FD', '16 atm', '110 mm', 100.00000, '110 mm', 'Estació de bombament', 'c:\\users\users\catalog.jpg', 'http://url.info', 'pump.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VALVULAREDUC150-PN6/16', 'VALVULA REDUCTORA', 'FD', '6-16 atm', '150 mm', 148.00000, '150 mm', 'Vàlvula reductora de pressió', 'c:\\users\users\catalog.jpg', 'http://url.info', 'prv.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('CABALIMETRE-02', 'CABALIMETRE', 'FD', '16 atm', '110 mm', 100.00000, 'Cabalimetre 110 mm', 'Cabalimetre de 110 mm', 'c:\\users\users\catalog.jpg', 'http://url.info', 'flowmeter.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('TDN160-160 PN16', 'T', 'FD', '16 atm', '160-160-160 mm', NULL, '160-160-160 mm', 'T de fundició', NULL, NULL, 't_equal.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('COLZE30DN110 PVCPN16', 'COLZE', 'PVC', '16 atm', '100 mm', NULL, '110 ext x 100 int', 'Colze de PVC', 'c:\\users\users\catalog.pdf', 'http://url.info', 'curve30.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('TDN160-110-63 PN16', 'T', 'FD', '16 atm', '160-110-63 mm', NULL, '160-110-63 m', 'T de fundició', NULL, NULL, 't_noequal.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('COLZE45DN110 PVCPN16', 'COLZE', 'PVC', '16 atm', '100 mm', NULL, '110 ext x 100 int', 'Colze de PVC', 'c:\\users\users\catalog.pdf', 'http://url.info', 'curve45.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('FINAL_LINEA-01', 'FINAL_LINEA', 'PVC', '16 atm', NULL, NULL, NULL, 'Final de linea', NULL, NULL, 'endline.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('FILTRE-01', 'FILTRE', 'FD', '16 atm', '200 mm', 186.00000, 'F 200 mm', 'Filtre 200 mm', 'c:\\users\users\catalog.jpg', 'http://url.info', 'filter.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('CABALIMETRE-01', 'CABALIMETRE', 'FD', '16 atm', '200 mm', 186.00000, 'Cabalimetre 200 mm', 'Cabalimetre 200 mm', 'c:\\users\users\catalog.jpg', 'http://url.info', 'flowmeter.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('RETENCIO_63-PN10', 'VALVULA RETENCIO', 'FD', '10 atm', '63 mm', 55.00000, 'Valvula retenció', 'Valvula de retenció 63mm', 'c:\\users\users\catalog.jpg', 'http://url.info', 'chkvalve.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('VALVULAREDUC100-PN6/16', 'VALVULA REDUCTORA', 'FD', '6-16 atm', '100 mm', 86.00000, '100 mm', 'Vàlvula reductora de pressió', 'c:\\users\users\catalog.jpg', 'http://url.info', 'prv.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('DIPOSIT_01', 'DIPOSIT', 'FD', NULL, NULL, NULL, '30x10x3 m', 'Dipòsit', 'c:\\users\users\catalog.pdf', 'http://url.info', 'tank.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('HIDRANT 1X110', 'HIDRANT', 'FD', '16 atm', '110 mm', NULL, '110 ext x 100 int', 'Hidrant de 110mm', 'c:\\users\users\catalog.pdf', 'http://url.info', 'hydrant_1x110.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('TDN110-63 PN16', 'T', 'PVC', '16 atm', '110-110-63 mm', NULL, '110-110-63 mm', 'T de PVC', 'c:\\users\users\catalog.pdf', 'http://url.info', 't_noequal.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('TDN160-63 PN16', 'T', 'FD', '16 atm', '160-160-63 mm', NULL, '160-160-63 mm', 'T de fundició', NULL, NULL, 't_noequal.svg', NULL, NULL, NULL, NULL);
INSERT INTO cat_node VALUES ('TDN200-160 PN16', 'T', 'FD', '16 atm', '200-160-160 mm', NULL, '200-160-160 mm', 'T de fundició', NULL, NULL, 't_noequal.svg', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_connec
-- ----------------------------
INSERT INTO cat_connec VALUES ('PVC25-PN16-DOM', 'DOMESTIC', 'PVC', '16 atm', '25 mm', NULL, 'Escomesa de PVC', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC32-PN16-DOM', 'DOMESTIC', 'PVC', '16 atm', '32 mm', NULL, 'Escomesa de PVC', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC32-PN16-COM', 'COMERCIAL', 'PVC', '16 atm', '32 mm', NULL, 'Escomesa de PVC', NULL, NULL, NULL, NULL);
INSERT INTO cat_connec VALUES ('PVC50-PN16-IND', 'INDUSTRIAL', 'PVC', '16 atm', '50 mm', NULL, 'Escomesa de PVC', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_element
-- ----------------------------
INSERT INTO cat_element VALUES ('TAPA', 'TAPA', 'FD', '60 cm', 'Tapa de fundició', 'c:\\users\users\catalog.pdf', 'http://url.info', 'c:\\users\users\catalog.jpg', 'Cover fd.svg');
INSERT INTO cat_element VALUES ('TAPA40X40', 'TAPA', 'FD', '40x40 cm', 'Tapa de fundició', NULL, NULL, NULL, NULL);
INSERT INTO cat_element VALUES ('VREGISTRE200X200', 'REGISTRE', 'OBRA+FERRO', '200x200 cm', 'Registre vertical de formigó/ferro', NULL, NULL, NULL, NULL);
INSERT INTO cat_element VALUES ('REGISTRE40X40', 'REGISTRE', 'FORMIGO', '40x40 cm', 'Registre de formigó 40x40', NULL, NULL, NULL, NULL);
INSERT INTO cat_element VALUES ('REGISTRE60X60', 'REGISTRE', 'FORMIGO', '60x60 cm', 'Registre de formigó 60x60', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_builder
-- ----------------------------
INSERT INTO cat_builder VALUES ('SENSE DADES', NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_owner
-- ----------------------------
INSERT INTO cat_owner VALUES ('SENSE DADES', NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_soil
-- ----------------------------
INSERT INTO cat_soil VALUES ('SENSE DADES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_work
-- ----------------------------
INSERT INTO cat_work VALUES ('SENSE DADES', NULL, NULL, NULL);

-- ----------------------------
-- Records of cat_pavement
-- ----------------------------
INSERT INTO cat_pavement VALUES ('SENSE DADES', NULL, NULL, NULL, NULL, NULL);


-- ----------------------------
-- Records of cat_tag
-- ----------------------------
INSERT INTO "cat_tag" VALUES ('SENSE ETIQUETA', null);

