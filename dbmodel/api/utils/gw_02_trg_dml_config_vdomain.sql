/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;



INSERT INTO config_web_fields_cat_type VALUES ('text');
INSERT INTO config_web_fields_cat_type VALUES ('combo');
INSERT INTO config_web_fields_cat_type VALUES ('textarea');
INSERT INTO config_web_fields_cat_type VALUES ('checkbox');
INSERT INTO config_web_fields_cat_type VALUES ('date');


INSERT INTO config_web_fields_cat_datatype VALUES ('string');
INSERT INTO config_web_fields_cat_datatype VALUES ('boolean');
INSERT INTO config_web_fields_cat_datatype VALUES ('double');
INSERT INTO config_web_fields_cat_datatype VALUES ('date');


INSERT INTO config_web_layer_cat_formtab VALUES ('tabConnect');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabDoc');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabElement');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabVisit');
INSERT INTO config_web_layer_cat_formtab VALUES ('taHydro');
INSERT INTO config_web_layer_cat_formtab VALUES ('tabMincut');


INSERT INTO config_web_layer_cat_form VALUES ('F11', 'INFO_UD_NODE');
INSERT INTO config_web_layer_cat_form VALUES ('F12', 'INFO_WS_NODE');
INSERT INTO config_web_layer_cat_form VALUES ('F13', 'INFO_UTILS_ARC');
INSERT INTO config_web_layer_cat_form VALUES ('F14', 'INFO_UTILS_CONNEC');
INSERT INTO config_web_layer_cat_form VALUES ('F15', 'INFO_UD_GULLY');
INSERT INTO config_web_layer_cat_form VALUES ('F16', 'GENERIC');
INSERT INTO config_web_layer_cat_form VALUES ('F21', 'VISIT');
INSERT INTO config_web_layer_cat_form VALUES ('F22', 'VISIT_EVENT_STANDARD');
INSERT INTO config_web_layer_cat_form VALUES ('F23', 'VISIT_EVENT_UD_ARC_STANDARD');
INSERT INTO config_web_layer_cat_form VALUES ('F24', 'VISIT_EVENT_UD_ARC_REHABIT');
INSERT INTO config_web_layer_cat_form VALUES ('F25', 'VISIT_MANAGER');
INSERT INTO config_web_layer_cat_form VALUES ('F26', 'ADD_MULTIPLE_VISIT');
INSERT INTO config_web_layer_cat_form VALUES ('F27', 'GALLERY');
INSERT INTO config_web_layer_cat_form VALUES ('F31', 'SEARCH');
INSERT INTO config_web_layer_cat_form VALUES ('F32', 'PRINT');
INSERT INTO config_web_layer_cat_form VALUES ('F33', 'FILTER');
INSERT INTO config_web_layer_cat_form VALUES ('F41', 'MINCUT_NEW');
INSERT INTO config_web_layer_cat_form VALUES ('F42', 'MINCUT_ADD_CONNEC');
INSERT INTO config_web_layer_cat_form VALUES ('F43', 'MINCUT_ADD_HYDROMETER');
INSERT INTO config_web_layer_cat_form VALUES ('F44', 'MINCUT_END');
INSERT INTO config_web_layer_cat_form VALUES ('F45', 'MINCUT_MANAGEMENT');
INSERT INTO config_web_layer_cat_form VALUES ('F51', 'REVIEW_UD_ARC');
INSERT INTO config_web_layer_cat_form VALUES ('F52', 'REVIEW_UD_NODE');
INSERT INTO config_web_layer_cat_form VALUES ('F53', 'REVIEW_UD_CONNEC');
INSERT INTO config_web_layer_cat_form VALUES ('F54', 'REVIEW_UD_GULLY');
INSERT INTO config_web_layer_cat_form VALUES ('F55', 'REVIEW_WS_ARC');
INSERT INTO config_web_layer_cat_form VALUES ('F56', 'REVIEW_WS_NODE');
INSERT INTO config_web_layer_cat_form VALUES ('F57', 'REVIEW_WS_CONNEC');
