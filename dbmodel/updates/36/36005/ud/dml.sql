/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_inp_transects',formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 'inp_transects_value'  ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
SELECT 'v_edit_inp_transects',formtype, tabname, columnname, null, null, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent, 
iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder
FROM config_form_fields WHERE formname = 've_node' AND columnname in ('sector_id') ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE config_form_fields SET dv_isnullvalue = false WHERE formname='v_edit_inp_transects' and columnname in ('sector_id');

INSERT INTO sys_table(id, descript, sys_role,  source, context,alias )
VALUES ('v_edit_inp_transects' , 'Editable view of transects', 'role_epa', 'core','{"level_1":"EPA","level_2":"CATALOGS"}','Transects value')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET context=NULL, alias = NULL WHERE id = 'inp_transects_value';

INSERT INTO sys_function( id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, source)
VALUES (3276, 'gw_trg_edit_inp_transects', 'ud', 'function trigger', null, null, 'Function trigger that allows editing view of inp transects', 'role_epa', 'core')
ON CONFLICT (id) DO NOTHING;