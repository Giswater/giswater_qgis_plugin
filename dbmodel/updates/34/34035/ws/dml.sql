/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/04/15
UPDATE config_form_fields SET dv_querytext = NULL WHERE formname = 'new_dma';
UPDATE config_form_fields SET dv_querytext = 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL',hidden = false
WHERE formname = 'new_dma' AND columnname = 'macrodma_id' ;
UPDATE config_form_fields SET dv_querytext = 'SELECT DISTINCT ''DMA'' as id, ''DMA'' as idval FROM exploitation WHERE expl_id IS NOT NULL' 
WHERE formname = 'new_dma' AND columnname = 'mapzoneType';
UPDATE config_form_fields SET dv_querytext = 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id != 0 AND expl_id IS NOT NULL' 
WHERE formname = 'new_dma' AND columnname = 'expl_id';

-- 2021/04/18
UPDATE config_param_system set standardvalue = 
'{"status":false, "values":[
{"source":{"table":"ve_node_shutoff_valve", "column":"pression_exit"}, "target":{"table":"inp_valve", "column":"pressure"}}]}'
WHERE parameter = 'epa_automatic_man2inp_values';

UPDATE config_param_system set standardvalue = 'True' WHERE parameter = 'admin_raster_dem';

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype, label, ismandatory, isparent, 
iseditable, isautoupdate, layoutname, hidden)
VALUES ('new_dma','form_catalog','dma_id',2, 'string', 'text', 'Dma id',false, false,true,false,'lyt_data_1',false); 

UPDATE config_form_fields SET layoutorder=3 WHERE formname='new_dma' AND columnname='name';

-- 2021/05/06
-- v_edit_review_node
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'node_id', 1, 'string', 'text', 'node_id', NULL, 'node_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'elevation', 2, 'double', 'text', 'elevation', NULL, 'elevation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'depth', 3, 'double', 'text', 'depth', NULL, 'depth', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'nodecat_id', 4, 'string', 'combo', 'nodecat_id', NULL, 'nodecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'annotation', 5, 'string', 'text', 'annotation', NULL, 'annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'observ', 6, 'string', 'text', 'observ', NULL, 'observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'review_obs', 7, 'string', 'text', 'review_obs', NULL, 'review_obs', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'expl_id', 8, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'field_checked', 9, 'boolean', 'check', 'field_checked', NULL, 'field_checked', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_node', 'form_feature', 'is_validated', 10, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_audit_node
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'id', 1, 'string', 'text', 'id', NULL, 'id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'node_id', 2, 'string', 'text', 'node_id', NULL, 'node_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_elevation', 3, 'double', 'text', 'old_elevation', NULL, 'old_elevation', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_elevation', 4, 'double', 'text', 'new_elevation', NULL, 'new_elevation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_depth', 5, 'double', 'text', 'old_depth', NULL, 'old_depth', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_depth', 6, 'double', 'text', 'new_depth', NULL, 'new_depth', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_nodecat_id', 7, 'string', 'combo', 'old_nodecat_id', NULL, 'old_nodecat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_nodecat_id', 8, 'string', 'combo', 'new_nodecat_id', NULL, 'new_nodecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_node WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_annotation', 9, 'string', 'text', 'old_annotation', NULL, 'old_annotation', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_annotation', 10, 'string', 'text', 'new_annotation', NULL, 'new_annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'old_observ', 11, 'string', 'text', 'old_observ', NULL, 'old_observ', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'new_observ', 12, 'string', 'text', 'new_observ', NULL, 'new_observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'expl_id', 13, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'review_status_id', 14, 'integer', 'text', 'review_status_id', NULL, 'review_status_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'field_date', 15, 'date', 'datetime', 'field_date', NULL, 'field_date', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'field_user', 16, 'string', 'text', 'field_user', NULL, 'field_user', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_node', 'form_feature', 'is_validated', 17, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_arc
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'arc_id', 1, 'string', 'text', 'arc_id', NULL, 'arc_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'arccat_id', 2, 'string', 'combo', 'arccat_id', NULL, 'arccat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'annotation', 3, 'string', 'text', 'annotation', NULL, 'annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'observ', 4, 'string', 'text', 'observ', NULL, 'observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'review_obs', 5, 'string', 'text', 'review_obs', NULL, 'review_obs', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'expl_id', 6, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'field_checked', 7, 'boolean', 'check', 'field_checked', NULL, 'field_checked', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_arc', 'form_feature', 'is_validated', 8, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_audit_arc
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'id', 1, 'string', 'text', 'id', NULL, 'id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'arc_id', 2, 'string', 'text', 'arc_id', NULL, 'arc_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_arccat_id', 3, 'string', 'combo', 'old_arccat_id', NULL, 'old_arccat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_arccat_id', 4, 'string', 'combo', 'new_arccat_id', NULL, 'new_arccat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_arc WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_annotation', 5, 'string', 'text', 'old_annotation', NULL, 'old_annotation', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_annotation', 6, 'string', 'text', 'new_annotation', NULL, 'new_annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'old_observ', 7, 'string', 'text', 'old_observ', NULL, 'old_observ', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'new_observ', 8, 'string', 'text', 'new_observ', NULL, 'new_observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'expl_id', 9, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'review_status_id', 10, 'integer', 'text', 'review_status_id', NULL, 'review_status_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'field_date', 11, 'date', 'datetime', 'field_date', NULL, 'field_date', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'field_user', 12, 'string', 'text', 'field_user', NULL, 'field_user', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_arc', 'form_feature', 'is_validated', 13, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_connec
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'connec_id', 1, 'string', 'text', 'connec_id', NULL, 'connec_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'connecat_id', 2, 'string', 'combo', 'connecat_id', NULL, 'connecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'annotation', 3, 'string', 'text', 'annotation', NULL, 'annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'observ', 4, 'string', 'text', 'observ', NULL, 'observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'review_obs', 5, 'string', 'text', 'review_obs', NULL, 'review_obs', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'expl_id', 6, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'field_checked', 7, 'boolean', 'check', 'field_checked', NULL, 'field_checked', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_connec', 'form_feature', 'is_validated', 8, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

-- v_edit_review_audit_connec
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'id', 1, 'string', 'text', 'id', NULL, 'id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'connec_id', 2, 'string', 'text', 'connec_id', NULL, 'connec_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_connecat_id', 3, 'string', 'combo', 'old_connecat_id', NULL, 'old_connecat_id', NULL, FALSE, FALSE, FALSE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_connecat_id', 4, 'string', 'combo', 'new_connecat_id', NULL, 'new_connecat_id', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_annotation', 5, 'string', 'text', 'old_annotation', NULL, 'old_annotation', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_annotation', 6, 'string', 'text', 'new_annotation', NULL, 'new_annotation', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'old_observ', 7, 'string', 'text', 'old_observ', NULL, 'old_observ', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'new_observ', 8, 'string', 'text', 'new_observ', NULL, 'new_observ', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'expl_id', 9, 'integer', 'text', 'expl_id', NULL, 'expl_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'review_status_id', 10, 'integer', 'text', 'review_status_id', NULL, 'review_status_id', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'field_date', 11, 'date', 'datetime', 'field_date', NULL, 'field_date', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'field_user', 12, 'string', 'text', 'field_user', NULL, 'field_user', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('v_edit_review_audit_connec', 'form_feature', 'is_validated', 13, 'integer', 'text', 'is_validated', NULL, 'is_validated', NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE) 
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
