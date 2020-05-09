/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/02/27
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_virtualvalve', 'form', 'id', 12, 'text', 'combo', 'State type', 
NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL' , 
NULL, NULL, 'state',  ' AND value_state_type.state = ', 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order,  datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('v_edit_inp_pipe', 'form', 'state_type', 12, 'text', 'combo', 'State type',
NULL, NULL, NULL, TRUE, NULL, TRUE, NULL, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL' , 
NULL, NULL, 'state',  ' AND value_state_type.state = ', 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE)
ON CONFLICT (formname, formtype, column_id) DO NOTHING;