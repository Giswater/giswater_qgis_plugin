/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/05
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_arc_shape','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_grate','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_hydrology','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_mat_grate','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_node_shape','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
