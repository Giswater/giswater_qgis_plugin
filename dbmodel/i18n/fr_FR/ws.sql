/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Records of cat_feature
-- ----------------------------
INSERT INTO cat_feature VALUES ('CONNEXION_EAU', 'WJOIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('FONTAINE', 'FOUNTAIN', 'CONNEC');
INSERT INTO cat_feature VALUES ('TAP', 'TAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('GREENTAP', 'GREENTAP', 'CONNEC');
INSERT INTO cat_feature VALUES ('PUIT', 'WATERWELL', 'NODE');
INSERT INTO cat_feature VALUES ('NETSAMPLEPOINT', 'NETSAMPLEPOINT', 'NODE');
INSERT INTO cat_feature VALUES ('ELEMENT_RESEAU', 'NETELEMENT', 'NODE');
INSERT INTO cat_feature VALUES ('USINE_RETRAITEMENT', 'WTP', 'NODE');
INSERT INTO cat_feature VALUES ('CONDUIT', 'PIPE', 'ARC');
INSERT INTO cat_feature VALUES ('ARC_VIRTUEL', 'VARC', 'ARC');
INSERT INTO cat_feature VALUES ('VALVE_VERIF', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE_REDUC_PRESSION', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE_VERTE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('COURBE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('FILTRE', 'FILTER', 'NODE');
INSERT INTO cat_feature VALUES ('FIN_LIGNE', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VANNE_CONTROLE_DEBIT', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE_USAGE_GENERALE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('BORNE_INCENDIE', 'HYDRANT', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE_COUPURE_PRESSION', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE_CHUTE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('JONCTION', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE_MAINTIEN_PRESSION', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('VANNE_FERMETURE', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('REDUCTION', 'REDUCTION', 'NODE');
INSERT INTO cat_feature VALUES ('POMPE', 'PUMP', 'NODE');
INSERT INTO cat_feature VALUES ('RESERVOIR', 'TANK', 'NODE');
INSERT INTO cat_feature VALUES ('BOITIER_PAPILLON', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('T', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('X', 'JUNCTION', 'NODE');
INSERT INTO cat_feature VALUES ('SOURCE', 'SOURCE', 'NODE');
INSERT INTO cat_feature VALUES ('REGARD', 'MANHOLE', 'NODE');
INSERT INTO cat_feature VALUES ('COMPTEUR', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('CONTROLE_COMPTEUR', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('CONTOURNEMENT_COMPTEUR', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE_COMPTEUR', 'REGISTER', 'NODE');
INSERT INTO cat_feature VALUES ('CONNEXION_EAU_TOPO', 'NETWJOIN', 'NODE');
INSERT INTO cat_feature VALUES ('FLEXUNION', 'FLEXUNION', 'NODE');
INSERT INTO cat_feature VALUES ('VALVE_AIR', 'VALVE', 'NODE');
INSERT INTO cat_feature VALUES ('CAPTEUR_DEBIT', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('VASE_EXPANSION', 'EXPANSIONTANK', 'NODE');
INSERT INTO cat_feature VALUES ('CAPTEUR_PRESSION', 'METER', 'NODE');
INSERT INTO cat_feature VALUES ('ADAPTATION', 'JUNCTION', 'NODE');




-- Records of node type system table
-- ----------------------------

INSERT INTO node_type  VALUES ('VANNE_CONTROLE_DEBIT', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Flow control valve', NULL);
INSERT INTO node_type  VALUES ('VANNE_FERMETURE', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', true, true, 2, true, 'Shutoff valve', NULL);
INSERT INTO node_type  VALUES ('RESERVOIR', 'TANK', 'TANK', 'man_tank', 'inp_tank', true, true, 2, true, 'Tank', NULL);
INSERT INTO node_type  VALUES ('VALVE_VERTE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true, 'Green valve', NULL);
INSERT INTO node_type  VALUES ('VALVE_CHUTE', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true, 'Outfall valve', NULL);
INSERT INTO node_type  VALUES ('VALVE_USAGE_GENERALE', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'General purpose valve', NULL);
INSERT INTO node_type  VALUES ('BORNE_INCENDIE', 'HYDRANT', 'JUNCTION', 'man_hydrant', 'inp_junction', true, true, 2, true, 'Hydrant', NULL);
INSERT INTO node_type  VALUES ('JONCTION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'Junction', NULL);
INSERT INTO node_type  VALUES ('REDUCTION', 'REDUCTION', 'JUNCTION', 'man_reduction', 'inp_junction', true, true, 2, true, 'Reduction', NULL);
INSERT INTO node_type  VALUES ('POMPE', 'PUMP', 'PUMP', 'man_pump', 'inp_pump', true, true, 2, true, 'Pump', NULL);
INSERT INTO node_type  VALUES ('VALVE_MAINTIEN_PRESSION', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Pressure sustainer valve', NULL);
INSERT INTO node_type  VALUES ('VALVE_REDUC_PRESSION', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Pressure reduction valve', NULL);
INSERT INTO node_type  VALUES ('VALVE_COUPURE_PRESSION', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Pressure break valve', NULL);
INSERT INTO node_type  VALUES ('T', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 3, true, 'Junction where 3 pipes converge', NULL);
INSERT INTO node_type  VALUES ('X', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 4, true, 'Junction where 4 pipes converge', NULL);
INSERT INTO node_type  VALUES ('REGARD', 'MANHOLE', 'JUNCTION', 'man_manhole', 'inp_junction', true, true, 2, true, 'Inspection chamber', NULL);
INSERT INTO node_type  VALUES ('COMPTEUR', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', true, true, 2, true, 'Register', NULL);
INSERT INTO node_type  VALUES ('VALVE_COMPTEUR', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', true, true, 2, true, 'Valve register', NULL);
INSERT INTO node_type  VALUES ('CONNEXION_EAU_TOPO', 'NETWJOIN', 'JUNCTION', 'man_netwjoin', 'inp_junction', true, true, 2, true, 'Water connection', NULL);
INSERT INTO node_type  VALUES ('FLEXUNION', 'FLEXUNION', 'JUNCTION', 'man_flexunion', 'inp_junction', true, true, 2, true, 'Flex union', NULL); -- No translate
INSERT INTO node_type  VALUES ('CAPTEUR_PRESSION', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', true, true, 2, true, 'Pressure meter', NULL);
INSERT INTO node_type  VALUES ('NETSAMPLEPOINT', 'NETSAMPLEPOINT', 'JUNCTION', 'man_netsamplepoint', 'inp_junction', true, true, 2, true, 'Netsamplepoint', NULL); -- No translate
INSERT INTO node_type  VALUES ('ELEMENT_RESEAU', 'NETELEMENT', 'JUNCTION', 'man_netelement', 'inp_junction', true, true, 2, true, 'Netelement', NULL);
INSERT INTO node_type  VALUES ('ADAPTATION', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'Adaptation junction', NULL);
INSERT INTO node_type  VALUES ('CONTOURNEMENT_COMPTEUR', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', true, true, 2, true, 'Bypass-register', NULL);
INSERT INTO node_type  VALUES ('COURBE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 2, true, 'Curve', NULL);
INSERT INTO node_type  VALUES ('CONTROLE_COMPTEUR', 'REGISTER', 'JUNCTION', 'man_register', 'inp_valve', true, true, 2, true, 'Control register', NULL);
INSERT INTO node_type  VALUES ('FIN_LIGNE', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction', true, true, 1, true, 'End of the line', NULL);
INSERT INTO node_type  VALUES ('VASE_EXPANSION', 'EXPANSIONTANK', 'JUNCTION', 'man_expansiontank', 'inp_junction', true, true, 2, true, 'Expansiontank', NULL);
INSERT INTO node_type  VALUES ('FILTRE', 'FILTER', 'JUNCTION', 'man_filter', 'inp_shortpipe', true, true, 2, true, 'Filter', NULL);
INSERT INTO node_type  VALUES ('PUIT', 'WATERWELL', 'RESERVOIR', 'man_waterwell', 'inp_junction', true, true, 2, true, 'Waterwell', NULL);
INSERT INTO node_type  VALUES ('SOURCE', 'SOURCE', 'RESERVOIR', 'man_source', 'inp_junction', true, true, 2, true, 'Source', NULL);
INSERT INTO node_type  VALUES ('USINE_RETRAITEMENT', 'WTP', 'RESERVOIR', 'man_wtp', 'inp_junction', true, true, 2, true, 'Water treatment point', NULL);
INSERT INTO node_type  VALUES ('VALVE_AIR', 'VALVE', 'JUNCTION', 'man_valve', 'inp_junction', true, true, 2, true, 'Air valve', NULL);
INSERT INTO node_type  VALUES ('VALVE_VERIF', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe', true, true, 2, true, 'Check valve', NULL);
INSERT INTO node_type  VALUES ('CAPTEUR_DEBIT', 'METER', 'JUNCTION', 'man_meter', 'inp_junction', true, true, 2, true, 'Flow meter', NULL);
INSERT INTO node_type  VALUES ('BOITIER_PAPILLON', 'VALVE', 'VALVE', 'man_valve', 'inp_valve', true, true, 2, true, 'Throttle-valve', NULL);



-- Records of arc type system table
-- ----------------------------
INSERT INTO arc_type VALUES ('CONDUIT', 'PIPE', 'PIPE', 'man_pipe', 'inp_pipe', TRUE, TRUE, 'Water distribution pipe' );
INSERT INTO arc_type VALUES ('ARC_VIRTUEL', 'VARC', 'PIPE', 'man_varc', 'inp_pipe', TRUE, TRUE, 'Virtual section of the pipe network. Used to connect arcs and nodes when polygons exists'  );

-- Records of connec_type system table
-- ----------------------------
INSERT INTO connec_type VALUES ('CONNEXION_EAU', 'WJOIN', 'man_wjoin', TRUE, TRUE, 'Wjoin');
INSERT INTO connec_type VALUES ('FONTAINE', 'FOUNTAIN', 'man_fountain', TRUE, TRUE, 'Ornamental fountain' );
INSERT INTO connec_type VALUES ('TAP', 'TAP', 'man_tap', TRUE, TRUE, 'Water source');
INSERT INTO connec_type VALUES ('GREENTAP', 'GREENTAP', 'man_greentap', TRUE, TRUE, 'Greentap');


-- Records of element type system table
-- ----------------------------
INSERT INTO element_type VALUES ('COMPTEUR', true, true, 'REGISTER', NULL);
INSERT INTO element_type VALUES ('REGARD', true, true, 'MANHOLE', NULL);
INSERT INTO element_type VALUES ('COVER', true, true, 'COVER', NULL);
INSERT INTO element_type VALUES ('ETAPE', true, true, 'STEP', NULL);
INSERT INTO element_type VALUES ('BANDE_PROTECTION', true, true, 'PROTECT BAND', NULL);
INSERT INTO element_type VALUES ('PLAQUE_INCENDIE', true, true, 'HYDRANT_PLATE', NULL);

-- Records of mincut
-- ----------------------------
INSERT INTO anl_mincut_selector_valve VALUES ('VANNE_FERMETURE');

INSERT INTO anl_mincut_cat_cause VALUES ('Accidentel', NULL);
INSERT INTO anl_mincut_cat_cause VALUES ('Planifié', NULL);

INSERT INTO anl_mincut_cat_class VALUES (1, 'Reseau coupe minimum', NULL);
INSERT INTO anl_mincut_cat_class VALUES (2, 'Connexion coupe minimum', NULL);
INSERT INTO anl_mincut_cat_class VALUES (3, 'Hydromètre coupeminimum', NULL);

INSERT INTO anl_mincut_cat_state VALUES (1, 'En progression', NULL);
INSERT INTO anl_mincut_cat_state VALUES (2, 'Réalisé', NULL);
INSERT INTO anl_mincut_cat_state VALUES (0, 'Planifié', NULL);


INSERT INTO anl_mincut_cat_type VALUES ('Test', true);
INSERT INTO anl_mincut_cat_type VALUES ('Demo', true);
INSERT INTO anl_mincut_cat_type VALUES ('Reel', false);