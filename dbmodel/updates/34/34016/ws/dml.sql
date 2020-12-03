/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/02
UPDATE config_toolbox SET inputparams = '[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["DMA","PRESSZONE","SECTOR"],"comboNames":["District Metering Areas (DMA)","PRESSZONE", "SECTOR"], "selectedId":"DMA"}, {"widgetname":"mapzoneField", "label":"Mapzone field name:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layoutorder":2, "value":"c_sector"}]'
WHERE ID = 2970;



-- add fields of state_om, adate, adescript, dma_style, presszone_style
INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_arc', 'form_feature', 'depth', null , 'double', 'text', 'Depth', 'Depth', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_arc', 'form_feature', 'adate', null , 'text', 'text', 'Adate', 'Date used as complementary date', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_arc', 'form_feature', 'adescript', null , 'text', 'text', 'A descript', 'Additional description', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_arc', 'form_feature', 'dma_style', null , 'text', 'text', 'Dma color', 'Dma color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_arc', 'form_feature', 'presszone_style', null , 'text', 'text', 'Presszone color', 'Presszone color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

	


INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_node', 'form_feature', 'adate', null , 'text', 'text', 'Adate', 'Date used as complementary date', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_node', 'form_feature', 'adescript', null , 'text', 'text', 'A descript', 'Additional description', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_node', 'form_feature', 'accessibility', null , 'integer', 'text', 'Accessibility', 'Accessibility', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_node', 'form_feature', 'dma_style', null , 'text', 'text', 'Dma color', 'Dma color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_node', 'form_feature', 'presszone_style', null , 'text', 'text', 'Presszone color', 'Presszone color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;



INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_connec', 'form_feature', 'adate', null , 'text', 'text', 'Adate', 'Date used as complementary date', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_connec', 'form_feature', 'adescript', null , 'text', 'text', 'A descript', 'Additional description', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_connec', 'form_feature', 'accessibility', null , 'integer', 'text', 'Accessibility', 'Accessibility', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_connec', 'form_feature', 'dma_style', null , 'text', 'text', 'Dma color', 'Dma color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('ve_connec', 'form_feature', 'presszone_style', null , 'text', 'text', 'Presszone color', 'Presszone color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;



INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_arc', 'form_feature', 'depth', null , 'double', 'text', 'Depth', 'Depth', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_arc', 'form_feature', 'adate', null , 'text', 'text', 'Adate', 'Date used as complementary date', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_arc', 'form_feature', 'adescript', null , 'text', 'text', 'A descript', 'Additional description', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_arc', 'form_feature', 'dma_style', null , 'text', 'text', 'Dma color', 'Dma color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_arc', 'form_feature', 'presszone_style', null , 'text', 'text', 'Presszone color', 'Presszone color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

	


INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_node', 'form_feature', 'adate', null , 'text', 'text', 'Adate', 'Date used as complementary date', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_node', 'form_feature', 'adescript', null , 'text', 'text', 'A descript', 'Additional description', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_node', 'form_feature', 'accessibility', null , 'integer', 'text', 'Accessibility', 'Accessibility', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_node', 'form_feature', 'dma_style', null , 'text', 'text', 'Dma color', 'Dma color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_node', 'form_feature', 'presszone_style', null , 'text', 'text', 'Presszone color', 'Presszone color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;



INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_connec', 'form_feature', 'adate', null , 'text', 'text', 'Adate', 'Date used as complementary date', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_connec', 'form_feature', 'adescript', null , 'text', 'text', 'A descript', 'Additional description', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_connec', 'form_feature', 'accessibility', null , 'integer', 'text', 'Accessibility', 'Accessibility', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_connec', 'form_feature', 'dma_style', null , 'text', 'text', 'Dma color', 'Dma color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, columnname, layoutorder,  datatype, widgettype, label, tooltip, placeholder, 
	ismandatory, isparent, iseditable, isautoupdate, hidden) 
	VALUES ('v_edit_connec', 'form_feature', 'presszone_style', null , 'text', 'text', 'Presszone color', 'Presszone color', null, 
	FALSE, FALSE, FALSE, FALSE, TRUE)
	ON CONFLICT (formname, formtype, columnname) DO NOTHING;


-- re-creation of child
SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "multi_create":"True" }}$$);


UPDATE config_form_fields SET 
dv_querytext = 'SELECT presszone.presszone_id as id, name as idval FROM presszone WHERE presszone_id=''0'' UNION SELECT presszone.presszone_id AS id, presszone.name AS idval FROM presszone WHERE presszone_id IS NOT NULL'
WHERE columnname = 'presszone_id' AND widgettype = 'combo';




