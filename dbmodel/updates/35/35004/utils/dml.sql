/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/04
INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3184, 'There is at least one hydrometer related to the feature','Connec with state=0 can''t have any hydrometers state=1 attached.', 2, true,'utils',null) 
ON CONFLICT (id) DO NOTHING;

--2021/05/05
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_arc','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_brand','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_brand_model','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_builder','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_mat_arc','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_mat_node','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_mat_element','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_owner','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_pavement','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_soil','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_users','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder,datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate,hidden)
VALUES ('cat_work','form_feature', 'main','active',null,null, 'boolean','check', 'active',null,null,false,
false,true,false,false) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;