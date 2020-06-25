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
