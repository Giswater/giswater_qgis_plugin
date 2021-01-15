/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'manageConflict', 'false'::text) WHERE parameter = 'utils_grafanalytics_status';

UPDATE config_form_tabs SET tabactions =
'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false},
{"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false},
{"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]' WHERE formname = 'v_edit_node';

DELETE FROM sys_function WHERE id = 2638;

DROP FUNCTION IF EXISTS gw_fct_utils_update_dma_hydroval();

INSERT INTO sys_table (id, descript, sys_role) VALUES ('temp_mincut', 'Temporal table for mincut analysis', 'role_om') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user VALUES('inp_options_epaversion','hidden', 'EPA version', 'role_epa', null, 'EPA version', null,null, true, 37, 
'ud', false, null, null, null, false, 'text', 'linetext', true, null, '5.0.022', 'lyt_hydraulics_1', true, null, null, null, null, false, 
'{"from":"2.0.12", "to":null,"language":"english"}')
ON CONFLICT (id) DO NOTHING;

--2021/01/13
UPDATE config_param_system SET value='FALSE' WHERE parameter='admin_config_control_trigger';
DELETE FROM config_form_fields WHERE formname='v_edit_inp_connec';
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'connec_id', 1, 'string', 'text', 'connec_id', NULL, NULL, NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'elevation', 2, 'double', 'spinbox', 'elevation', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'depth', 3, 'double', 'spinbox', 'depth', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'connecat_id', 4, 'string', 'combo', 'connecat_id', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_connec WHERE id IS NOT NULL', TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'arc_id', 5, 'string', 'text', 'arc_id', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'sector_id', 6, 'integer', 'combo', 'sector_id', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL', TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'expl_id', 11, 'integer', 'combo', 'exploitation', NULL, NULL, NULL, FALSE, TRUE, TRUE, FALSE, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'dma_id', 7, 'integer', 'combo', 'dma_id', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id = 0 UNION SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', TRUE, FALSE, 'expl_id', ' AND dma.expl_id', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'state', 8, 'integer', 'combo', 'state', NULL, NULL, NULL, FALSE, TRUE, TRUE, FALSE, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'state_type', 9, 'integer', 'combo', 'state_type', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL', TRUE, FALSE, 'state', ' AND value_state_type.state', NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'annotation', 10, 'string', 'text', 'annotation', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'pjoinyt_type', 12, 'string', 'combo', 'pjoint_type', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_pjoint_type''', TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'pjoinyt_id', 13, 'integer', 'text', 'pjoint_id', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'demand', 14, 'double', 'text', 'demand', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
INSERT INTO config_form_fields VALUES ('v_edit_inp_connec', 'form_feature', 'pattern_id', 15, 'string', 'combo', 'pattern_id', NULL, NULL, NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', TRUE, TRUE, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_1', NULL, FALSE);
UPDATE config_param_system SET value='TRUE' WHERE parameter='admin_config_control_trigger';

--2021/01/14
UPDATE ext_rtc_hydrometer_state SET is_operative=TRUE;

INSERT INTO om_typevalue VALUES ('mincut_state','4','On planning')
ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE config_param_system SET value  = $${"arc":"SELECT arc_id AS arc_id, (case when dext IS NOT NULL THEN concat(v_edit_arc.cat_matcat_id,'-Ø',(c.dext)::integer) ELSE  concat(v_edit_arc.cat_matcat_id,'-Ø',(c.dint)::integer) END) as catalog, concat('None / ',gis_length::numeric(12,2),'m') as dimensions , arc_id as code FROM v_edit_arc JOIN cat_arc c ON id = arccat_id"}$$ 
WHERE parameter = 'om_profile_guitartext';