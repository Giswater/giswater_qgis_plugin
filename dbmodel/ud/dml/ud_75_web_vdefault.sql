/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



INSERT INTO config_web_fields VALUES (2, 'review_arc', 'y1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (14, 'review_node', 'ymax', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (47, 'review_connec', 'y1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (49, 'review_connec', 'matcat_id', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_mat_arc', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (50, 'review_connec', 'y2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (51, 'review_connec', 'arc_type', NULL, 'text', 18, NULL, NULL, NULL, 'QComboBox', 'arc_type', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (1, 'review_arc', 'arc_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, false);
INSERT INTO config_web_fields VALUES (52, 'review_connec', 'shape', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_arc_shape', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (53, 'review_connec', 'geom1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (54, 'review_connec', 'geom2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (55, 'review_connec', 'annotation', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (56, 'review_connec', 'observ', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (57, 'review_connec', 'field_checked', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (48, 'review_connec', 'connec_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, false);
INSERT INTO config_web_fields VALUES (59, 'review_gully', 'arc_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, false);
INSERT INTO config_web_fields VALUES (5, 'review_arc', 'matcat_id', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_mat_arc', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (3, 'review_arc', 'y2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (4, 'review_arc', 'arc_type', NULL, 'text', 18, NULL, NULL, NULL, 'QComboBox', 'arc_type', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (62, 'review_gully', 'arc_type', NULL, 'text', 18, NULL, NULL, NULL, 'QComboBox', 'arc_type', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (63, 'review_gully', 'shape', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_arc_shape', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (6, 'review_arc', 'shape', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_arc_shape', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (64, 'review_gully', 'geom1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (7, 'review_arc', 'geom1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (65, 'review_gully', 'geom2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (8, 'review_arc', 'geom2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (9, 'review_arc', 'annotation', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (10, 'review_arc', 'observ', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (11, 'review_arc', 'field_checked', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (66, 'review_gully', 'annotation', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (67, 'review_gully', 'observ', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (15, 'review_node', 'node_type', NULL, 'text', 18, NULL, NULL, NULL, 'QComboBox', 'node_type', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (16, 'review_node', 'matcat_id', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_mat_node', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (68, 'review_gully', 'field_checked', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (17, 'review_node', 'shape', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_node_shape', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (61, 'review_gully', 'ymax', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (18, 'review_node', 'geom1', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (19, 'review_node', 'geom2', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (20, 'review_node', 'annotation', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (21, 'review_node', 'observ', NULL, 'text', 500, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (22, 'review_node', 'field_checked', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (12, 'review_node', 'node_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, false);
INSERT INTO config_web_fields VALUES (60, 'review_gully', 'connec_matcat', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_mat_arc', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (58, 'review_gully', 'top_elev', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (69, 'review_gully', 'sandbox', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (70, 'review_gully', 'groove', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (71, 'review_gully', 'siphon', NULL, 'boolean', NULL, NULL, NULL, NULL, 'QCheckBox', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (73, 'review_gully', 'featurecat_id', NULL, 'text', 30, NULL, NULL, NULL, 'QComboBox', 'cat_feature', 'id', 'id', NULL, true);
INSERT INTO config_web_fields VALUES (74, 'review_gully', 'feature_id', NULL, 'text', 16, NULL, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
INSERT INTO config_web_fields VALUES (13, 'review_node', 'top_elev', NULL, 'numeric', 12, 3, NULL, NULL, 'QLineEdit', NULL, NULL, NULL, NULL, true);
