/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/20
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder, datatype, widgettype, label, widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden)
SELECT formname, formtype, 'custom_dint', 21, 'double', 'text', 'custom_dint', widgetdim, ismandatory, isparent, iseditable, isautoupdate, hidden FROM config_form_fields 
WHERE formname = 'v_edit_inp_valve' and columnname = 'flow' ON CONFLICT  (formname, formtype, columnname) DO NOTHING;


-- 2020/11/20
UPDATE config_form_tabs SET tabactions= '[
{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
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
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}]' where formname = 'v_edit_node';


INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden, dv_querytext, dv_orderby_id, dv_isnullvalue)
VALUES ('new_dma', 'form_catalog', 'mapzoneType', 1, 'string','combo', 'Type', TRUE, FALSE,FALSE, FALSE,'lyt_data_1',FALSE,
'SELECT DISTINCT ''DMA'' as id, ''DMA'' as idval FROM exploitation WHERE expl_id IS NOT NULL',
true, false) ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate,layoutname, hidden)
VALUES ('new_dma', 'form_catalog', 'name', 2, 'string','text', 'Name', TRUE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
        
INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden,dv_querytext,dv_orderby_id,dv_isnullvalue)
VALUES ('new_dma', 'form_catalog', 'expl_id', 3, 'integer','combo', 'Exploitation', TRUE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE,
'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id != 0 AND expl_id IS NOT NULL', true, false)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden,dv_querytext,dv_orderby_id,dv_isnullvalue)
VALUES ('new_dma', 'form_catalog', 'macrodma_id', 4, 'integer','combo', 'Macrodma', FALSE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE,
'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id != 0 AND macrodma_id IS NOT NULL', true, false)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden)
VALUES ('new_dma', 'form_catalog', 'descript', 5, 'string','text', 'descript', FALSE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden)
VALUES ('new_dma', 'form_catalog', 'link', 6, 'string','text', 'Link', FALSE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden,placeholder)
VALUES ('new_dma', 'form_catalog', 'stylesheet', 7, 'string','text', 'Stylesheet', FALSE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE,
'{"color":[255,255,204], "featureColor":"255,255,204"}') ON CONFLICT (formname, formtype, columnname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden, dv_querytext, dv_orderby_id, dv_isnullvalue)
VALUES ('new_presszone', 'form_catalog', 'mapzoneType', 1, 'string','combo', 'Type', TRUE, FALSE,FALSE, FALSE,'lyt_data_1',FALSE,
'SELECT DISTINCT ''PRESSZONE'' as id, ''PRESSZONE'' as idval FROM exploitation WHERE expl_id IS NOT NULL',
true, false) ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate,layoutname, hidden)
VALUES ('new_presszone', 'form_catalog', 'presszone_id', 2, 'string','text', 'Id', TRUE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate,layoutname, hidden)
VALUES ('new_presszone', 'form_catalog', 'name', 3, 'string','text', 'Name', TRUE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
        
INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden,dv_querytext,dv_orderby_id,dv_isnullvalue)
VALUES ('new_presszone', 'form_catalog', 'expl_id', 4, 'integer','combo', 'Exploitation', TRUE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE,
'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id != 0 AND expl_id IS NOT NULL', true, false)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden)
VALUES ('new_presszone', 'form_catalog', 'link', 5, 'string','text', 'Link', FALSE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden,placeholder)
VALUES ('new_presszone', 'form_catalog', 'stylesheet', 6, 'string','text', 'Stylesheet', FALSE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE,
'{"color":[255,255,204], "featureColor":"255,255,204"}') ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, columnname, layoutorder, datatype, widgettype,
label, ismandatory, isparent, iseditable, isautoupdate, layoutname, hidden)
VALUES ('new_presszone', 'form_catalog', 'head', 7, 'numeric','text', 'Head', FALSE, FALSE,TRUE, FALSE,'lyt_data_1',FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
