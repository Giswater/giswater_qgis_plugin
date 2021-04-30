/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
UPDATE sys_feature_epa_type SET active = true;
UPDATE sys_feature_epa_type SET active = false WHERE id IN ('DIVIDER');

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''ARC'''  WHERE columnname = 'epa_type' AND formname like '%_arc%';
UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''NODE'''  WHERE columnname = 'epa_type' AND formname like '%_node%';

UPDATE cat_feature_node SET epa_default  ='UNDEFINED' WHERE epa_default  ='NOT DEFINED';
UPDATE cat_feature_arc SET epa_default  ='UNDEFINED' WHERE epa_default  ='NOT DEFINED';
UPDATE sys_feature_epa_type SET id  ='UNDEFINED' WHERE id  ='NOT DEFINED';
UPDATE arc SET epa_type ='UNDEFINED' WHERE epa_type  ='NOT DEFINED';
UPDATE node SET epa_type ='UNDEFINED' WHERE epa_type  ='NOT DEFINED';

--2021/04/07
DELETE FROM config_form_fields where formname='inp_flwreg_type';
DELETE FROM sys_table where id='inp_flwreg_type';

UPDATE config_form_tabs SET tabactions = '[{"actionName": "actionEdit", "disabled": false}, 
{"actionName": "actionZoom", "disabled": false}, 
{"actionName": "actionCentered", "disabled": false}, 
{"actionName": "actionZoomOut", "disabled": false}, 
{"actionName": "actionCatalog", "disabled": false}, 
{"actionName": "actionWorkcat", "disabled": false}, 
{"actionName": "actionCopyPaste", "disabled": false}, 
{"actionName": "actionLink", "disabled": false},
{"actionName":"actionGetArcId", "disabled":false},
{"actionName":"actionInterpolate", "disabled":false},
{"actionName": "actionHelp", "disabled": false}]'
WHERE formname ='v_edit_node';


UPDATE config_form_tabs SET tabactions = '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste", "disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionLink", "disabled":false},
{"actionName":"actionHelp", "disabled":false}]'
WHERE formname ='v_edit_arc';


UPDATE config_form_tabs SET tabactions = '[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste", "disabled":false},
{"actionName":"actionLink", "disabled":false},
{"actionName":"actionHelp", "disabled":false}, 
{"actionName":"actionGetArcId", "disabled":false}]'
WHERE formname ='v_edit_connec';


UPDATE config_form_tabs SET tabactions = '[{"actionName":"actionEdit", "disabled":true},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste", "disabled":false},
{"actionName":"actionLink", "disabled":false},
{"actionName":"actionHelp", "disabled":false}, 
{"actionName":"actionGetArcId", "disabled":false}]'
WHERE formname ='v_edit_gully';

-- 2021/04/24
DELETE FROM sys_table WHERE id = 'inp_controls_importinp';


-- 2021/04/30

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,hidden)
VALUES ('cat_feature_gully','form_feature', 'main','id',null,null, 'string','text', 'id',null,null,true,
false, false, false, false, 'SELECT id as id, id as idval FROM cat_feature WHERE feature_type = ''GULLY'' ', true, false,null, null,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,hidden)
VALUES ('cat_feature_gully','form_feature', 'main','type',null,null, 'string','text', 'type',null,null,true,
false, false, false, false, 'SELECT type as id, type as idval FROM sys_feature_cat WHERE type = ''GULLY''', true, true,null, null,false) 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,hidden)
VALUES ('cat_feature_node','form_feature', 'main','id',null,null, 'string','text', 'id',null,null,true,
false, false, false, false, NULL, true, false,null, null,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,hidden)
VALUES ('cat_feature_node','form_feature', 'main','type',null,null, 'string','text', 'type',null,null,true,
false, false, false, false, NULL, true, true,null, null,false) 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,hidden)
VALUES ('cat_feature_node','form_feature', 'main','epa_default',null,null, 'string','combo', 'epa default',null,null,true,
false, true, false, false, 'SELECT id as id, id as idval FROM sys_feature_epa_type WHERE feature_type =''NODE''', true, false,null, null,false) 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_feature_node','form_feature', 'main','num_arcs',null,null, 'integer','text', 'arcs number',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_feature_node','form_feature', 'main','choose_hemisphere',null,null, 'boolean','check', 'choose hemisphere',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_feature_node','form_feature', 'main','isarcdivide',null,null, 'boolean','check', 'divides arc',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,hidden)
VALUES ('cat_feature_node','form_feature', 'main','graf_delimiter',null,null, 'string','combo', 'Graf delimiter',null,null,true,
false, true, false, false, 'SELECT id, idval FROM edit_typevalue WHERE typevalue =''grafdelimiter_type''', true, false,null, null,false) 
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_feature_node','form_feature', 'main','isprofilesurface',null,null, 'boolean','check', 'Profile surface',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_feature_node','form_feature', 'main','isexitupperintro',null,null, 'boolean','check', 'Exit upper intro',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;