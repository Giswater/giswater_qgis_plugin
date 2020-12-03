/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/06/25
INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_arc', 'form_feature', 'sector_name', 41, 'string', 'text', 'Sector name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_arc', 'form_feature', 'dma_name', 42, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_arc', 'form_feature', 'presszone_name', 31, 'string', 'text', 'Presszone name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_arc', 'form_feature', 'dqa_name', 32, 'string', 'text', 'Dqa name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);


INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_node', 'form_feature', 'sector_name', 41, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_node', 'form_feature', 'dma_name', 42, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_node', 'form_feature', 'presszone_name', 31, 'string', 'text', 'Presszone name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_node', 'form_feature', 'dqa_name', 32, 'string', 'text', 'Dqa name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);


INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_connec', 'form_feature', 'sector_name', 41, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_connec', 'form_feature', 'dma_name', 42, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_connec', 'form_feature', 'presszone_name', 31, 'string', 'text', 'Presszone name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('v_edit_connec', 'form_feature', 'dqa_name', 32, 'string', 'text', 'Dqa name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);


INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_arc', 'form_feature', 'sector_name', 41, 'string', 'text', 'Sector name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_arc', 'form_feature', 'dma_name', 42, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_arc', 'form_feature', 'presszone_name', 31, 'string', 'text', 'Presszone name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_arc', 'form_feature', 'dqa_name', 32, 'string', 'text', 'Dqa name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);


INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_node', 'form_feature', 'sector_name', 41, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_node', 'form_feature', 'dma_name', 42, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_node', 'form_feature', 'presszone_name', 31, 'string', 'text', 'Presszone name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_node', 'form_feature', 'dqa_name', 32, 'string', 'text', 'Dqa name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_connec', 'form_feature', 'sector_name', 41, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_connec', 'form_feature', 'dma_name', 42, 'string', 'text', 'Dma name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_1', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_connec', 'form_feature', 'presszone_name', 31, 'string', 'text', 'Presszone name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);

INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden) 
VALUES ('ve_connec', 'form_feature', 'dqa_name', 32, 'string', 'text', 'Dqa name', FALSE, FALSE, FALSE, FALSE,  'lyt_data_2', TRUE);


INSERT INTO config_param_system VALUES
('edit_mapzones_automatic_insert', '{"SECTOR":false, "DMA":false, "PRESSZONE":false, "DQA":false, "MINSECTOR":false}', 'Enable automatic insert of mapzone when new node header is created and code of mapzones is filled on widget',
'Automatic mapzones insert', null, null, TRUE, NULL, 'ws');


UPDATE sys_param_user SET project_type = 'ws', label = 'Default values', datatype = 'json', 
iseditable = 'true', epaversion = '{"from":"2.0.12", "to":null,"language":"english"}', descript = 'Default values on go2epa generation inp file'
WHERE id = 'inp_options_vdefault';

UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'presszone';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_rpt_node_hourly';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_rpt_comp_arc_hourly';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_rpt_comp_node_hourly';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_edit_macrosector';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_edit_macrodma';

UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_rpt_arc_all';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_rpt_node_all';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_rpt_comp_arc';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_rpt_comp_node';

UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_ext_streetaxis';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_ext_plot';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_ext_address';
UPDATE sys_table SET qgis_criticity = 0 WHERE id = 'v_minsector';


INSERT INTO sys_table VALUES ('inp_pump_importinp', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('inp_rules_importinp', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('inp_rules_x_sector', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('inp_valve_importinp', NULL, 'role_epa', 0);
INSERT INTO sys_table VALUES ('inp_rules_controls_importinp', NULL, 'role_epa', 0);
DELETE FROM sys_table WHERE id='anl_graf';
DELETE FROM sys_table WHERE id='anl_mincut_arc_x_node';
DELETE FROM sys_table WHERE id='ext_rtc_hydrometer_x_value';
DELETE FROM sys_table WHERE id='inp_energy_el';
DELETE FROM sys_table WHERE id='inp_energy_gl';
DELETE FROM sys_table WHERE id='inp_reactions_el';
DELETE FROM sys_table WHERE id='inp_reactions_gl';
DELETE FROM sys_table WHERE id='inp_typevalue_energy';
DELETE FROM sys_table WHERE id='inp_typevalue_pump';
DELETE FROM sys_table WHERE id='inp_typevalue_reactions_gl';
DELETE FROM sys_table WHERE id='inp_typevalue_source';
DELETE FROM sys_table WHERE id='inp_typevalue_valve';
DELETE FROM sys_table WHERE id='inp_value_ampm';
DELETE FROM sys_table WHERE id='inp_value_curve';
DELETE FROM sys_table WHERE id='inp_value_mixing';
DELETE FROM sys_table WHERE id='inp_value_noneall';
DELETE FROM sys_table WHERE id='inp_value_opti_headloss';
DELETE FROM sys_table WHERE id='inp_value_opti_hyd';
DELETE FROM sys_table WHERE id='inp_value_opti_qual';
DELETE FROM sys_table WHERE id='inp_value_opti_rtc_coef';
DELETE FROM sys_table WHERE id='inp_value_opti_unbal';
DELETE FROM sys_table WHERE id='inp_value_opti_units';
DELETE FROM sys_table WHERE id='inp_value_opti_valvemode';
DELETE FROM sys_table WHERE id='inp_value_param_energy';
DELETE FROM sys_table WHERE id='inp_value_reactions_el';
DELETE FROM sys_table WHERE id='inp_value_reactions_gl';
DELETE FROM sys_table WHERE id='inp_value_status_pipe';
DELETE FROM sys_table WHERE id='inp_value_status_pump';
DELETE FROM sys_table WHERE id='inp_value_status_valve';
DELETE FROM sys_table WHERE id='inp_value_times';
DELETE FROM sys_table WHERE id='inp_value_yesno';