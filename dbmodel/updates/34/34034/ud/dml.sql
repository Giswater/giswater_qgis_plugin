/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/15

UPDATE config_form_tabs SET tabactions =
'[{"actionName": "actionEdit", "actionTooltip": "Edit", "disabled": false}, 
{"actionName": "actionZoom", "actionTooltip": "Zoom In", "disabled": false}, 
{"actionName": "actionCentered", "actionTooltip": "Center", "disabled": false}, 
{"actionName": "actionZoomOut", "actionTooltip": "Zoom Out", "disabled": false}, 
{"actionName": "actionCatalog", "actionTooltip": "Change Catalog", "disabled": false}, 
{"actionName": "actionWorkcat", "actionTooltip": "Add Workcat", "disabled": false}, 
{"actionName": "actionCopyPaste", "actionTooltip": "Copy Paste", "disabled": false}, 
{"actionName": "actionLink", "actionTooltip": "Open Link", "disabled": false},
{"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName":"actionInterpolate", "actionTooltip":"Interpolate",  "disabled":false},
{"actionName": "actionHelp", "actionTooltip": "Help", "disabled": false}]' WHERE formname = 'v_edit_node';

--2021/03/25
-- v_edit_review_node
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'node_id', 1, 'string', 'text', 'node_id', NULL, 'node_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'top_elev', 2, 'double', 'text', 'top_elev', NULL, 'top_elev', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'ymax', 3, 'double', 'text', 'ymax', NULL, 'ymax', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'node_type', 4, 'string', 'combo', 'node_type', NULL, 'node_type', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'matcat_id', 5, 'string', 'combo', 'matcat_id', NULL, 'matcat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_mat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'nodecat_id', 6, 'string', 'combo', 'nodecat_id', NULL, 'nodecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'annotation', 7, 'string', 'text', 'annotation', NULL, 'annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'observ', 8, 'string', 'text', 'observ', NULL, 'observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'review_obs', 9, 'string', 'text', 'review_obs', NULL, 'review_obs', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'expl_id', 10, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'field_checked', 11, 'boolean', 'check', 'field_checked', NULL, 'field_checked', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'is_validated', 12, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_audit_node
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'id', 1, 'string', 'text', 'id', NULL, 'id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'node_id', 2, 'string', 'text', 'node_id', NULL, 'node_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_top_elev', 3, 'double', 'text', 'old_top_elev', NULL, 'old_top_elev', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_top_elev', 4, 'double', 'text', 'new_top_elev', NULL, 'new_top_elev', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_ymax', 5, 'double', 'text', 'old_ymax', NULL, 'old_ymax', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_ymax', 6, 'double', 'text', 'new_ymax', NULL, 'new_ymax', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_node_type', 7, 'string', 'combo', 'old_node_type', NULL, 'old_node_type', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_feature_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_node_type', 8, 'string', 'combo', 'new_node_type', NULL, 'new_node_type', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_matcat_id', 9, 'string', 'combo', 'old_matcat_id', NULL, 'old_matcat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_mat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_matcat_id', 10, 'string', 'combo', 'new_matcat_id', NULL, 'new_matcat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_mat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_nodecat_id', 11, 'string', 'combo', 'old_nodecat_id', NULL, 'old_nodecat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_nodecat_id', 12, 'string', 'combo', 'new_nodecat_id', NULL, 'new_nodecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_annotation', 13, 'string', 'text', 'old_annotation', NULL, 'old_annotation', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_annotation', 14, 'string', 'text', 'new_annotation', NULL, 'new_annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_observ', 15, 'string', 'text', 'old_observ', NULL, 'old_observ', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_observ', 16, 'string', 'text', 'new_observ', NULL, 'new_observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'expl_id', 17, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'review_status_id', 18, 'integer', 'text', 'review_status_id', NULL, 'review_status_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'field_date', 19, 'date', 'datetime', 'field_date', NULL, 'field_date', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'field_user', 20, 'string', 'text', 'field_user', NULL, 'field_user', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'is_validated', 21, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_arc
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'arc_id', 1, 'string', 'text', 'arc_id', NULL, 'arc_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'node_1', 2, 'string', 'text', 'node_1', NULL, 'node_1', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'y1', 3, 'double', 'text', 'y1', NULL, 'y1', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'node_2', 4, 'string', 'text', 'node_2', NULL, 'node_2', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'y2', 5, 'double', 'text', 'y2', NULL, 'y2', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'arc_type', 6, 'string', 'combo', 'arc_type', NULL, 'arc_type', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'matcat_id', 7, 'string', 'combo', 'matcat_id', NULL, 'matcat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_mat_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'arccat_id', 8, 'string', 'combo', 'arccat_id', NULL, 'arccat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'annotation', 7, 'string', 'text', 'annotation', NULL, 'annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'observ', 8, 'string', 'text', 'observ', NULL, 'observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'review_obs', 9, 'string', 'text', 'review_obs', NULL, 'review_obs', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'expl_id', 10, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'field_checked', 11, 'boolean', 'check', 'field_checked', NULL, 'field_checked', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'is_validated', 12, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_audit_arc
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'id', 1, 'string', 'text', 'id', NULL, 'id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'arc_id', 2, 'string', 'text', 'arc_id', NULL, 'arc_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_y1', 3, 'double', 'text', 'old_y1', NULL, 'old_y1', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_y1', 4, 'double', 'text', 'new_y1', NULL, 'new_y1', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_y2', 3, 'double', 'text', 'old_y2', NULL, 'old_y2', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_y2', 4, 'double', 'text', 'new_y2', NULL, 'new_y2', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_arc_type', 5, 'string', 'combo', 'old_arc_type', NULL, 'old_arc_type', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_feature_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_arc_type', 6, 'string', 'combo', 'new_arc_type', NULL, 'new_arc_type', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_matcat_id', 7, 'string', 'combo', 'old_matcat_id', NULL, 'old_matcat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_mat_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_matcat_id', 8, 'string', 'combo', 'new_matcat_id', NULL, 'new_matcat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_mat_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_arccat_id', 9, 'string', 'combo', 'old_arccat_id', NULL, 'old_arccat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_arccat_id', 10, 'string', 'combo', 'new_arccat_id', NULL, 'new_arccat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_annotation', 13, 'string', 'text', 'old_annotation', NULL, 'old_annotation', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_annotation', 14, 'string', 'text', 'new_annotation', NULL, 'new_annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_observ', 15, 'string', 'text', 'old_observ', NULL, 'old_observ', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_observ', 16, 'string', 'text', 'new_observ', NULL, 'new_observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'expl_id', 17, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'review_status_id', 18, 'integer', 'text', 'review_status_id', NULL, 'review_status_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'field_date', 19, 'date', 'datetime', 'field_date', NULL, 'field_date', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'field_user', 20, 'string', 'text', 'field_user', NULL, 'field_user', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'is_validated', 21, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_connec
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'connec_id', 1, 'string', 'text', 'connec_id', NULL, 'connec_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'y1', 2, 'double', 'text', 'y1', NULL, 'y1', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'y2', 3, 'double', 'text', 'y2', NULL, 'y2', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'connec_type', 4, 'string', 'combo', 'connec_type', NULL, 'connec_type', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'matcat_id', 5, 'string', 'combo', 'matcat_id', NULL, 'matcat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_mat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'connecat_id', 6, 'string', 'combo', 'connecat_id', NULL, 'connecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'annotation', 7, 'string', 'text', 'annotation', NULL, 'annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'observ', 8, 'string', 'text', 'observ', NULL, 'observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'review_obs', 9, 'string', 'text', 'review_obs', NULL, 'review_obs', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'expl_id', 10, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'field_checked', 11, 'boolean', 'check', 'field_checked', NULL, 'field_checked', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'is_validated', 12, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_audit_connec
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'id', 1, 'string', 'text', 'id', NULL, 'id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'connec_id', 2, 'string', 'text', 'connec_id', NULL, 'connec_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_y1', 3, 'double', 'text', 'old_y1', NULL, 'old_y1', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_y1', 4, 'double', 'text', 'new_y1', NULL, 'new_y1', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_y2', 3, 'double', 'text', 'old_y2', NULL, 'old_y2', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_y2', 4, 'double', 'text', 'new_y2', NULL, 'new_y2', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_connec_type', 5, 'string', 'combo', 'old_connec_type', NULL, 'old_connec_type', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_feature_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_connec_type', 6, 'string', 'combo', 'new_connec_type', NULL, 'new_connec_type', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_matcat_id', 7, 'string', 'combo', 'old_matcat_id', NULL, 'old_matcat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_mat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_matcat_id', 8, 'string', 'combo', 'new_matcat_id', NULL, 'new_matcat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_mat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_connecat_id', 9, 'string', 'combo', 'old_connecat_id', NULL, 'old_connecat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_connecat_id', 10, 'string', 'combo', 'new_connecat_id', NULL, 'new_connecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_annotation', 13, 'string', 'text', 'old_annotation', NULL, 'old_annotation', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_annotation', 14, 'string', 'text', 'new_annotation', NULL, 'new_annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_observ', 15, 'string', 'text', 'old_observ', NULL, 'old_observ', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_observ', 16, 'string', 'text', 'new_observ', NULL, 'new_observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'expl_id', 17, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'review_status_id', 18, 'integer', 'text', 'review_status_id', NULL, 'review_status_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'field_date', 19, 'date', 'datetime', 'field_date', NULL, 'field_date', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'field_user', 20, 'string', 'text', 'field_user', NULL, 'field_user', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'is_validated', 21, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_gully
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'gully_id', 1, 'string', 'text', 'gully_id', NULL, 'gully_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'top_elev', 2, 'double', 'text', 'top_elev', NULL, 'top_elev', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'ymax', 3, 'double', 'text', 'ymax', NULL, 'ymax', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'sandbox', 4, 'double', 'text', 'sandbox', NULL, 'sandbox', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'matcat_id', 5, 'string', 'combo', 'matcat_id', NULL, 'matcat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_mat_gully WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'gully_type', 6, 'string', 'combo', 'gully_type', NULL, 'gully_type', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature_gully WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'gratecat_id', 7, 'string', 'combo', 'gratecat_id', NULL, 'gratecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_grate WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'units', 10, 'integer', 'text', 'units', NULL, 'units', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'groove', 11, 'boolean', 'check', 'groove', NULL, 'groove', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'siphon', 11, 'boolean', 'check', 'siphon', NULL, 'siphon', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'connec_arccat_id', 12, 'string', 'combo', 'connec_arccat_id', NULL, 'connec_arccat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'featurecat_id', 13, 'string', 'combo', 'featurecat_id', NULL, 'featurecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'feature_id', 14, 'string', 'text', 'feature_id', NULL, 'feature_id', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'annotation', 15, 'string', 'text', 'annotation', NULL, 'annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'observ', 16, 'string', 'text', 'observ', NULL, 'observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'review_obs', 17, 'string', 'text', 'review_obs', NULL, 'review_obs', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'expl_id', 18, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'field_checked', 19, 'boolean', 'check', 'field_checked', NULL, 'field_checked', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_gully', 'form_feature', 'is_validated', 20, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_audit_gully
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'id', 1, 'string', 'text', 'id', NULL, 'id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'gully_id', 2, 'string', 'text', 'gully_id', NULL, 'gully_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_top_elev', 3, 'double', 'text', 'old_top_elev', NULL, 'old_top_elev', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_top_elev', 4, 'double', 'text', 'new_top_elev', NULL, 'new_top_elev', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_ymax', 5, 'double', 'text', 'old_ymax', NULL, 'old_ymax', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_ymax', 6, 'double', 'text', 'new_ymax', NULL, 'new_ymax', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_sandbox', 7, 'double', 'text', 'old_sandbox', NULL, 'old_sandbox', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_sandbox', 8, 'double', 'text', 'new_sandbox', NULL, 'new_sandbox', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_matcat_id', 9, 'string', 'combo', 'old_matcat_id', NULL, 'old_matcat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_mat_gully WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_matcat_id', 10, 'string', 'combo', 'new_matcat_id', NULL, 'new_matcat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_mat_gully WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_gully_type', 11, 'string', 'combo', 'old_gully_type', NULL, 'old_gully_type', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_feature_gully WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_gully_type', 12, 'string', 'combo', 'new_gully_type', NULL, 'new_gully_type', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature_gully WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_gratecat_id', 13, 'string', 'combo', 'old_gratecat_id', NULL, 'old_gratecat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_grate WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_gratecat_id', 14, 'string', 'combo', 'new_gratecat_id', NULL, 'new_gratecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_grate WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_units', 15, 'integer', 'text', 'old_units', NULL, 'old_units', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_units', 16, 'integer', 'text', 'new_units', NULL, 'new_units', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_groove', 17, 'boolean', 'check', 'old_groove', NULL, 'old_groove', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_groove', 18, 'boolean', 'check', 'new_groove', NULL, 'new_groove', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_siphon', 17, 'boolean', 'check', 'old_siphon', NULL, 'old_siphon', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_siphon', 19, 'boolean', 'check', 'new_siphon', NULL, 'new_siphon', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_connec_arccat_id', 20, 'string', 'combo', 'old_connec_arccat_id', NULL, 'old_connec_arccat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_connec_arccat_id', 21, 'string', 'combo', 'new_connec_arccat_id', NULL, 'new_connec_arccat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_featurecat_id', 22, 'string', 'combo', 'old_featurecat_id', NULL, 'old_featurecat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_feature WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_featurecat_id', 23, 'string', 'combo', 'new_featurecat_id', NULL, 'new_featurecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_feature WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_feature_id', 24, 'integer', 'text', 'old_feature_id', NULL, 'old_feature_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_feature_id', 25, 'integer', 'text', 'new_feature_id', NULL, 'new_feature_id', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_annotation', 13, 'string', 'text', 'old_annotation', NULL, 'old_annotation', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_annotation', 14, 'string', 'text', 'new_annotation', NULL, 'new_annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'old_observ', 15, 'string', 'text', 'old_observ', NULL, 'old_observ', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'new_observ', 16, 'string', 'text', 'new_observ', NULL, 'new_observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'expl_id', 17, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'review_status_id', 18, 'integer', 'text', 'review_status_id', NULL, 'review_status_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'field_date', 19, 'date', 'datetime', 'field_date', NULL, 'field_date', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'field_user', 20, 'string', 'text', 'field_user', NULL, 'field_user', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_gully', 'form_feature', 'is_validated', 21, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;



INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, vdefault)
VALUES ('edit_node_interpolate', 'hidden', 'Values to use with tool node interpolate',
'role_edit', 'Values to manage node interpolate tool', FALSE, NULL, 'ud', FALSE, FALSE, 'json', 'text', true, NULL, NULL,
'{"topElev":{"status":false, "column":"custom_top_elev"},  "elev":{"status":true, "column":"custom_elev"}, "ymax":{"status":false, "column":"custom_ymax"}}'
) ON CONFLICT (id) DO NOTHING;