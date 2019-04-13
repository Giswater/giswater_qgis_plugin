/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_api_form_fields (id, formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam) VALUES (10004, 'printGeneric', 'utils', 'scale', 1, 1, true, 'integer', 'text', 'Escala:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'gw_api_setprint', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields (id, formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam) VALUES (10002, 'printGeneric', 'utils', 'composer', 1, 1, true, NULL, 'combo', 'Composer:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SELECT 1 as id, ''1'' as idval FROM arc WHERE arc_id=''''', NULL, NULL, NULL, NULL, 'gw_api_setprint', NULL, NULL, NULL, NULL, NULL, NULL);
