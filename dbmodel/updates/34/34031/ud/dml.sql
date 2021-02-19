/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/02/11
INSERT INTO config_form_fields VALUES ('v_edit_arc', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('ve_arc', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields VALUES ('v_edit_node', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('ve_node', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields VALUES ('v_edit_connec', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('ve_connec', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields VALUES ('v_edit_gully', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('ve_gully', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;